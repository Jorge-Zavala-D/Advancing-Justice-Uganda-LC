"""Milestone 2 geographic source acquisition/conversion, called from Stata.

Raw responses, archives and derived geography stay in Dropbox. This companion
does not select mentors, define neighbors, or allocate treatment. Stata owns
the final imports, crosswalk merges, validation and analytical DTA products.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import html
import importlib.util
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
import urllib.parse
import urllib.request
import zipfile
import xml.etree.ElementTree as ET
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path

DEFAULT_ROOT = Path(r"C:\Users\jzava\Dropbox (Personal)\Research & Consulting\1 Research\Legatum Uganda Advancing Justice")
GIS_PACKAGES = ("geopandas==1.1.1", "pyogrio==0.13.0", "shapely==2.1.2", "pyproj==3.8.0",
                "pandas==3.0.1", "numpy==2.3.5")
DISTRICTS = ("BUSHENYI", "RUBIRIZI", "SHEEMA")
SOURCES = {
    "hdx_catalog.json": "https://data.humdata.org/api/3/action/package_show?id=cod-ab-uga",
    "nes_report_2021.pdf": "https://nrep.ug/wp-content/uploads/2024/09/NES-STUDY-REPORT-1.pdf",
    "nes_app.json": "https://www.arcgis.com/sharing/rest/content/items/24dcc91c943d4c639ef696940b1ddff1/data?f=json",
    "nes_webmap.json": "https://www.arcgis.com/sharing/rest/content/items/c8ce0e07427f4ad09f83bd4d269028c2/data?f=json",
    "npa_map_package_metadata.json": "https://www.arcgis.com/sharing/rest/content/items/29e9f30ca7ab47ebb68cd30e0bb2f1fe?f=json",
    "nbrb_catalog.json": "https://maps.nbrb.go.ug/api/layer-catalog",
    "nbrb_wfs_capabilities.xml": "https://maps.nbrb.go.ug/geoserver/wfs?service=WFS&version=2.0.0&request=GetCapabilities",
    "nbrb_terms.html": "https://maps.nbrb.go.ug/",
    "npa_catalog.html": "https://ugnsdigeoportal.com/sector/administrative/shapefiles",
    "wasmis_faq.html": "https://wasmis.wemis.mwe.go.ug/FAQS",
    "stanford_village_points_metadata.html": "https://geodiscovery.uwm.edu/catalog/stanford-vx912bz3835",
    "icpac_village_points_metadata.html": "https://geoportal.icpac.net/layers/data0%3Ageonode%3Auga_villages_jan_2009/metadata_detail",
    "energydata_catalog.json": "https://energydata.info/api/3/action/package_show?id=uganda-distributed-renewable-energy-dre",
    "grid3_metadata.xml": "https://www.arcgis.com/sharing/rest/content/items/b17090c865db4c2b970d98a22bc38913/info/metadata/metadata.xml",
    "arcgis_village_search.json": "https://www.arcgis.com/sharing/rest/search?f=json&num=100&q=Uganda%20village",
    "ubos_census_map.html": "https://statistics.ubos.org/nphc/map",
    "energy_gis_access.html": "https://energy-gis.ug/download-registration",
    "psu_datacite.json": "https://api.datacite.org/dois/10.18113/S1V91R",
    "psu_mapping_metadata.html": "https://scholarsphere.psu.edu/resources/78c6d2e7-cbff-46e0-9c26-06338b6c943d",
    "wasmis_wfs_capabilities.xml": "https://wasmis.wemis.mwe.go.ug/geoserver/ows?service=WFS&version=2.0.0&request=GetCapabilities",
}
LOCAL_ARCHIVES = {
    "uga_admin_boundaries.shp.zip": "4b2b0458693d014efdde1e8c86e00f1c390849d92fe47fd7909cfa97a8488314",
    "uga_villages_jan_2009.zip": "3cc0559238e2c26476e269bab13aae9bd88d9f05ca55f7f2f49ee38d83643463",
    "uga_villages_jan_2009_pcodedb.zip": "7874ed5a692ca6a69ddf09386c1ecdc136a1c42581e6c29dd6639b28468db719",
}


def sha(path: Path) -> str:
    with path.open("rb") as f:
        return hashlib.file_digest(f, "sha256").hexdigest()


def folders(root: Path):
    raw = root / "3 Data/1 Raw/Secondary data/Phase2_Geospatial_Sources"
    out = root / "3 Data/2 Working/Phase2_Geospatial_Frame"
    raw.mkdir(parents=True, exist_ok=True)
    out.mkdir(parents=True, exist_ok=True)
    return raw, out


def read_csv(path):
    with Path(path).open(encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path, rows, fields=None):
    rows = list(rows)
    fields = fields or (list(rows[0]) if rows else [])
    with Path(path).open("w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields, extrasaction="raise")
        w.writeheader()
        w.writerows(rows)


def write_json(path, data):
    path = Path(path)
    # Dropbox can briefly hold the destination. Keep the old receipt intact.
    with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=path.parent,
                                     suffix=".tmp", delete=False) as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        temp = Path(f.name)
    try:
        for attempt in range(5):
            try:
                temp.replace(path)
                break
            except PermissionError:
                if attempt == 4:
                    raise
                time.sleep(0.2 * (attempt + 1))
    finally:
        temp.unlink(missing_ok=True)


def source_identity(url):
    p = urllib.parse.urlsplit(url)
    q = [(k, v) for k, v in urllib.parse.parse_qsl(p.query) if k != "download_token"]
    return urllib.parse.urlunsplit((p.scheme, p.netloc, p.path, urllib.parse.urlencode(q), ""))


def transfer(url, temp, limit):
    assert urllib.parse.urlsplit(url).scheme == "https", "HTTPS required"
    class HTTPSRedirect(urllib.request.HTTPRedirectHandler):
        def redirect_request(self, req, fp, code, msg, headers, newurl):
            if urllib.parse.urlsplit(newurl).scheme != "https":
                raise ValueError("Refusing non-HTTPS source redirect")
            return super().redirect_request(req, fp, code, msg, headers, newurl)
    request = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (Advancing Justice research source audit)"})
    try:
        with urllib.request.build_opener(HTTPSRedirect).open(request, timeout=75) as r:
            content_type, final_url = r.headers.get("Content-Type", ""), r.geturl()
            size = 0
            with temp.open("wb") as f:
                while chunk := r.read(1_048_576):
                    size += len(chunk)
                    if size > limit:
                        raise ValueError("Source exceeds audited size limit")
                    f.write(chunk)
        return size, content_type, final_url
    except urllib.error.URLError as e:
        # Native curl uses the OS trust store. It still verifies TLS and revocation.
        # No -k/--insecure or revocation bypass is permitted, including NES :6443.
        curl = shutil.which("curl.exe" if os.name == "nt" else "curl")
        if not curl:
            raise
        p = subprocess.run([curl, "--fail", "--location", "--silent", "--show-error",
                            "--proto", "=https", "--proto-redir", "=https",
                            "--max-time", "90", "--max-filesize", str(limit),
                            "--output", str(temp), "--write-out", "%{content_type}\n%{url_effective}", url],
                           capture_output=True, text=True,
                           creationflags=subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0)
        if p.returncode:
            raise RuntimeError(f"Verified HTTPS failed: urllib={e}; curl={p.stderr.strip()}") from e
        size = temp.stat().st_size
        if size > limit:
            raise ValueError("Source exceeds audited size limit")
        parts = p.stdout.splitlines()
        return size, parts[0] if parts else "", parts[-1] if parts else url


def fetch(root, name, url, *, required=True, limit=400_000_000, raw_subdir=None):
    """Cache exact responses and hashes. Never disable TLS verification."""
    raw, _ = folders(root)
    if raw_subdir is not None:
        target = (raw / raw_subdir).resolve()
        assert target.is_relative_to(raw.resolve()), "Source folder must stay within Dropbox GIS archive"
        raw = target
        raw.mkdir(parents=True, exist_ok=True)
    path = raw / name
    manifest_path = raw / "download_manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8")) if manifest_path.exists() else {}
    if path.exists():
        record = manifest.get(name)
        assert record and record["sha256"] == sha(path), f"Unpinned/changed source: {path}"
        assert source_identity(record["url"]) == source_identity(url), f"Cached source URL changed: {name}"
        return path
    if manifest.get(name, {}).get("status") == "unavailable" and manifest[name].get("url") == url and not required:
        return None  # audited access failure; do not repeatedly probe restricted/broken endpoints
    try:
        temp = path.with_suffix(path.suffix + ".download")
        size, content_type, final_url = transfer(url, temp, limit)
        if name.endswith(".zip") and not zipfile.is_zipfile(temp):
            raise ValueError(f"Expected ZIP-compatible archive: {url}")
        if name.endswith(".mpk"):
            with temp.open("rb") as f:
                magic = f.read(6)
            if not zipfile.is_zipfile(temp) and magic != b"7z\xbc\xaf\x27\x1c":
                raise ValueError(f"Expected ArcGIS ZIP/7z map package: {url}")
        if name.endswith(".pdf") and not temp.read_bytes()[:5] == b"%PDF-":
            raise ValueError(f"Expected PDF: {url}")
        if name.endswith(".txt") and "html" in content_type.lower():
            raise ValueError("HTML access page returned instead of source text")
        response_status = "ok"
        if name.endswith((".json", ".geojson")):
            body = json.loads(temp.read_text(encoding="utf-8-sig"))
            if isinstance(body, dict) and (body.get("error") or body.get("success") is False):
                response_status = "service_error_not_data"
                if required:
                    raise ValueError(f"Service returned error object: {body}")
        if name.endswith(".xml"):
            ET.parse(temp)
        manifest[name] = {"url": url, "final_url": final_url, "bytes": size,
                          "content_type": content_type, "sha256": sha(temp),
                          "retrieved_utc": datetime.now(timezone.utc).isoformat(), "status": "downloaded",
                          "response_status": response_status}
    except Exception as e:
        temp = path.with_suffix(path.suffix + ".download")
        if temp.exists():
            temp.unlink()  # only this function's incomplete download, never an input
        manifest[name] = {"url": url, "status": "unavailable", "error": str(e),
                          "checked_utc": datetime.now(timezone.utc).isoformat()}
        write_json(manifest_path, manifest)
        if required:
            raise
        print(f"Unavailable {name}: {e}", flush=True)
        return None
    # Storage failures propagate. Never relabel a successfully acquired input
    # as a network failure or leave an unpinned final path.
    write_json(manifest_path, manifest)
    temp.replace(path)
    print(f"Archived {name}: {size:,} bytes", flush=True)
    return path


def extract_zip(root, path):
    """Extract only within the new snapshot directory, including all sidecars."""
    raw, _ = folders(root)
    dest = raw / "expanded" / path.stem
    dest.mkdir(parents=True, exist_ok=True)
    base = dest.resolve()
    with zipfile.ZipFile(path) as z:
        assert len(z.infolist()) <= 10000 and sum(e.file_size for e in z.infolist()) <= 2_000_000_000, "Archive expansion limit"
        for entry in z.infolist():
            target = (dest / entry.filename).resolve()
            if not target.is_relative_to(base) or (entry.external_attr >> 16) & 0o170000 == 0o120000:
                raise ValueError(f"Unsafe archive entry: {entry.filename}")
        for entry in z.infolist():
            target = dest / entry.filename
            if target.exists() and not entry.is_dir():
                assert target.read_bytes() == z.read(entry), f"Expanded source changed: {target}"
            elif not target.exists():
                z.extract(entry, dest)
    return dest


def extract_mpk(root, path):
    if zipfile.is_zipfile(path):
        return extract_zip(root, path)
    raw, _ = folders(root)
    dest = raw / "expanded" / path.stem
    dest.mkdir(parents=True, exist_ok=True)
    tar = shutil.which("tar.exe" if os.name == "nt" else "tar")
    if not tar:
        raise RuntimeError("A 7z-capable bsdtar is required to read the original ArcGIS map package")
    flags = subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0
    listed = subprocess.run([tar, "-tf", str(path)], capture_output=True, text=True, check=True, creationflags=flags)
    verbose = subprocess.run([tar, "-tvf", str(path)], capture_output=True, text=True, check=True, creationflags=flags)
    assert not any(line.startswith(("l", "h")) for line in verbose.stdout.splitlines()), "Archive links are forbidden"
    for name in listed.stdout.splitlines():
        assert (dest / name).resolve().is_relative_to(dest.resolve()), f"Unsafe map-package path: {name}"
    subprocess.run([tar, "-xf", str(path), "-C", str(dest)], check=True, creationflags=flags)
    return dest


def acquire(root):
    raw, _ = folders(root)
    for name, url in SOURCES.items():
        fetch(root, name, url, required=name == "hdx_catalog.json")
    hdx = json.loads((raw / "hdx_catalog.json").read_text(encoding="utf-8"))["result"]
    resources = {r["name"]: r for r in hdx["resources"]}
    fetch(root, "hdx_admin_boundaries.shp.zip", resources["uga_admin_boundaries.shp.zip"]["url"])
    for name, digest in LOCAL_ARCHIVES.items():
        p = root / "3 Data/1 Raw/Secondary data" / name
        assert sha(p) == digest, f"Existing source changed: {p}"
        # Existing archives remain authoritative pinned inputs; no overwrite.
    for name, url in {
        "nes_server.json": "https://ied-sa.fr:6443/arcgis/rest/services/UGANDA/Uganda/MapServer?f=pjson",
        "npa_archive_legacy.html": "https://scholarsphere.psu.edu/concern/generic_works/k0p096889c",
        "rcmrd_service.html": "https://maps.rcmrd.org/arcgis/rest/services/Uganda/Uganda_OGRVD/MapServer",
        "npa_map_package.mpk": "https://www.arcgis.com/sharing/rest/content/items/29e9f30ca7ab47ebb68cd30e0bb2f1fe/data",
        "parish_2024_metadata.json": "https://services1.arcgis.com/49FlB10KwAxJa07X/ArcGIS/rest/services/Map_2_June_WFL1/FeatureServer/1?f=pjson",
        "psu_mapping_files_2018.zip": "https://scholarsphere.psu.edu/resources/78c6d2e7-cbff-46e0-9c26-06338b6c943d/downloads/1954",
        "psu_archive_readme.txt": "https://scholarsphere.psu.edu/resources/78c6d2e7-cbff-46e0-9c26-06338b6c943d/downloads/1952",
    }.items():
        fetch(root, name, url, required=False)
    # Ordinary public Download links, distinct from ScholarSphere's View routes.
    page_path = raw / "psu_mapping_metadata.html"
    page = page_path.read_text(encoding="utf-8") if page_path.exists() else ""
    for fid, name, digest in (
        ("1954", "psu_mapping_files_2018.zip", "14cef087e87b803a228bac500d40d3b6a66ac2af93cf585d5c41004f60a55a59"),
        ("1952", "psu_readme_2018.txt", "194a6c39a90108a9572b34f39fc679fbc0ed8e0c231f6cf7a85cdfd86549bf36"),
    ):
        hrefs = re.findall(r'href="([^"<>]*downloads/' + fid + r'\?download_token=[^"<>]+)"', page)
        if hrefs:
            url = urllib.parse.urljoin(SOURCES["psu_mapping_metadata.html"], html.unescape(hrefs[0]))
            p = fetch(root, name, url, required=False)
            if p:
                assert sha(p) == digest, f"Publisher checksum differs: {p}"
    params = urllib.parse.urlencode({"service": "WFS", "version": "2.0.0", "request": "GetFeature",
                                    "typeNames": "nbrb:admin_parishes", "outputFormat": "application/json",
                                    "srsName": "EPSG:4326", "count": 10000,
                                    "CQL_FILTER": "district ILIKE 'BUSHENYI' OR district ILIKE 'RUBIRIZI' OR district ILIKE 'SHEEMA'"})
    fetch(root, "nbrb_study_parishes.geojson", "https://maps.nbrb.go.ug/geoserver/wfs?" + params, required=False)
    energy_path = raw / "energydata_catalog.json"
    energy = json.loads(energy_path.read_text(encoding="utf-8")).get("result", {}) if energy_path.exists() else {}
    for resource in energy.get("resources", []):
        if resource["url"].endswith("uganda_dre_atlas_settlements.geojson"):
            fetch(root, "dre_settlements_2025.geojson", resource["url"], required=False)


def worker_args():
    uv = shutil.which("uv")
    if not uv:
        raise RuntimeError("Install uv or run with the documented pinned GIS packages. Stata cannot silently skip this step.")
    cmd = [uv, "run", "--python", "3.12"]
    for p in GIS_PACKAGES:
        cmd += ["--with", p]
    cmd += ["python", str(Path(__file__).resolve()), *sys.argv[1:], "--worker"]
    return cmd


def review_workbook(root, inspect_only=False, reconcile_mode=False):
    # Presentation formatting only; input values have already passed Stata.
    runtime = Path(os.environ.get("CODEX_RUNTIME_DEPENDENCIES", str(Path.home() / ".cache/codex-runtimes/codex-primary-runtime/dependencies")))
    node = runtime / "node/bin/node.exe"
    packages = runtime / "node/node_modules"
    assert node.exists() and (packages / "@oai/artifact-tool").exists(), "Bundled Node/artifact-tool runtime required"
    staging = Path(tempfile.gettempdir()) / "AdvancingJustice_Phase2_GeoReview"
    staging.mkdir(exist_ok=True)
    module_path = staging / "node_modules"
    if not module_path.exists():
        subprocess.run(["cmd", "/c", "mklink", "/J", str(module_path), str(packages)], check=True,
                       capture_output=True, creationflags=subprocess.CREATE_NO_WINDOW)
    assert module_path.resolve() == packages.resolve(), "Unexpected staging dependency target"
    builder = staging / "6 Phase2_Geospatial_Review.mjs"
    shutil.copyfile(Path(__file__).with_name(builder.name), builder)
    cmd = [str(node), str(builder), str(root)] + (["--inspect"] if inspect_only else []) + (["--reconcile"] if reconcile_mode else [])
    r = subprocess.run(cmd, capture_output=True, text=True, creationflags=subprocess.CREATE_NO_WINDOW)
    _, out = folders(root)
    (out / ("phase2_reconciliation_workbook.log" if reconcile_mode else "phase2_geographic_workbook.log")).write_text(r.stdout + r.stderr, encoding="utf-8")
    print(r.stdout + r.stderr, flush=True)
    r.check_returncode()


def verify_outputs(root):
    _, out = folders(root)
    path = out / "phase2_geographic_manifest.json"
    manifest = json.loads(path.read_text(encoding="utf-8"))
    assert protected_inputs(root) == manifest["protected_inputs_before_after"], "Protected input changed during Stata execution"
    products = [p for p in out.rglob("*") if p.is_file() and p != path and p.suffix in (".dta", ".csv", ".gpkg", ".png", ".shp", ".dbf", ".shx", ".prj")]
    assert len([p for p in products if p.suffix == ".png"]) == 4
    assert (out / "phase2_geographic_lc_reference.dta").exists()
    workbook = root / "4 Deliverables and Presentations/Phase2_Administrative_Village_Census.xlsx"
    manifest.update({"stata_import_validation_passed": True, "stata_execution_route": "stata_run_selection MCP",
                     "protected_inputs_unchanged_after_stata": True,
                     "product_sha256": {str(p.relative_to(root)): sha(p) for p in products},
                     "review_workbook_sha256": sha(workbook),
                     "code_sha256": {p.name: sha(p) for p in Path(__file__).parent.glob("6 Phase2_Geospatial*") if p.is_file()}})
    write_json(path, manifest)
    print("Final GIS products hashed; protected inputs unchanged after Stata/workbook execution.", flush=True)


def name_key(value, level="village"):
    # Same conservative rules as Milestone 1; numerals/token boundaries survive.
    value = re.sub(r"\s+", " ", str(value or "")).strip().upper()
    value = re.sub(r"^\d+[.)]\s*", "", value)
    value = re.sub(r"\s*[\[(](?:NEW |FROM |OLD\b).*", "", value)
    if level == "subcounty":
        value = re.sub(r"\b(SUB[ -]?COUNTY|S/C|SC)\b", "", value)
        value = re.sub(r"\bTOWN(?: COUNCIL)?\b|\bT/C\b", "TC", value)
        value = re.sub(r"\bDIVISION\b", "DIV", value)
    if level == "parish":
        value = re.sub(r"\b(PARISH|WARD)\b", "", value)
    return re.sub(r"\s+", " ", re.sub(r"[^A-Z0-9 ]", " ", value)).strip()


def hierarchy_key(row, levels=("district", "subcounty", "parish", "village")):
    return tuple(name_key(row[x], x) for x in levels)


def shorthand_key(key):
    return (key[0], re.sub(r"\s+", " ", re.sub(r"\b(TC|DIV)\b", "", key[1])).strip(), *key[2:])


def protected_inputs(root):
    repo = Path(__file__).resolve().parents[1]
    paths = [p for p in (repo / "1 Code").rglob("*.do") if p.name != "6 Phase2_Geospatial_Frame.do"]
    paths += [root / "3 Data/3 Coded/phase1_baseline_analysis.dta",
              root / "4 Deliverables and Presentations/Legatum_Baseline_Report_Final_20260930.docx"]
    paths += list((root / "3 Data/2 Working/Phase2_Administrative_Frame").glob("*.csv"))
    paths += list((root / "3 Data/2 Working/Phase2_Administrative_Frame").glob("*.dta"))
    manifest = json.loads((root / "3 Data/2 Working/Phase2_Administrative_Frame/phase2_administrative_source_manifest.json").read_text(encoding="utf-8"))
    for p, digest in manifest["input_sha256"].items():
        path = Path(p) if Path(p).is_absolute() else root / p
        assert sha(path) == digest, f"Milestone 1 prerequisite changed: {path}"
        paths.append(path)
    paths += [p for p in (root / "3 Data/1 Raw").rglob("*") if p.is_file() and
              p.suffix.lower() in (".csv", ".xlsx", ".xls", ".dta") and "Phase2_Geospatial_Sources" not in str(p)]
    return {str(p): sha(p) for p in paths if p.exists()}


def build(root):
    """Frozen GIS inputs -> explicit geographic evidence, never guessed LC IDs."""
    import geopandas as gpd
    import pandas as pd
    import pyogrio
    import shapely
    import pyproj
    import importlib.metadata
    raw, out = folders(root)
    before = protected_inputs(root)
    admin = root / "3 Data/2 Working/Phase2_Administrative_Frame"
    frame = read_csv(admin / "phase2_administrative_village_frame.csv")
    assert len(frame) == 1483 and len({r["phase2_lc_uid"] for r in frame}) == len(frame)
    cache = json.loads((raw / "download_manifest.json").read_text(encoding="utf-8"))
    for name, r in cache.items():
        if r["status"] == "downloaded":
            assert sha(raw / name) == r["sha256"], f"Downloaded source changed: {name}"
    expanded = {}
    for name, digest in LOCAL_ARCHIVES.items():
        p = root / "3 Data/1 Raw/Secondary data" / name
        assert sha(p) == digest
        expanded[name] = extract_zip(root, p)
    hd = extract_zip(root, raw / "hdx_admin_boundaries.shp.zip")
    mpk = extract_mpk(root, raw / "npa_map_package.mpk")
    registry, issues, layers = [], [], {}
    gpkg = out / "phase2_geographic_reference.gpkg"
    # Overwrite only our derived package, never a source geometry.
    if gpkg.exists():
        gpkg.unlink()
    bridge = out / "stata_bridge"
    bridge.mkdir(exist_ok=True)

    def layer(name, path, mapping, source_id, vintage, level, license_note):
        original = gpd.read_file(path)
        assert original.crs is not None, f"Unknown source CRS: {path}"
        assert not original.geometry.isna().any() and not original.geometry.is_empty.any(), f"Missing geometry: {path}"
        assert original.geom_type.isin(["Polygon", "MultiPolygon", "Point"]).all(), f"Unsupported geometry: {path}"
        df = original.to_crs(4326).reset_index(drop=True)
        permitted = ["Point"] if level == "historical_point" else ["Polygon", "MultiPolygon"]
        assert df.geom_type.isin(permitted).all(), f"Geometry type does not support claimed layer level: {path}"
        xmin, ymin, xmax, ymax = df.total_bounds
        assert 28 < xmin < xmax < 36 and -3 < ymin < ymax < 6, f"Implausible Uganda bounds: {path}"
        original_names = list(df.columns)
        df.columns = [re.sub(r"[^a-z0-9_]", "_", c.lower()) for c in df.columns]
        assert len(set(df.columns)) == len(df.columns)
        df.insert(0, "geo_id", range(1, len(df) + 1))
        for target, source in mapping.items():
            df[target] = df[source.lower()].fillna("").astype(str)
        if vintage == "source valid_on field":
            vintage = "; ".join(sorted(str(x)[:10] for x in df.valid_on.dropna().unique()))
        df["source_id"] = source_id
        df["source_vintage"] = vintage
        df["geometry_level"] = level
        df["source_invalid"] = (~df.is_valid).astype(int)
        df["same_geom_rows"] = df.geometry.to_wkb().groupby(df.geometry.to_wkb()).transform("size")
        for i in df.index[df.source_invalid == 1]:
            issues.append({"layer": name, "geo_id": int(df.loc[i, "geo_id"]), "issue": "invalid_original_geometry",
                           "detail": shapely.is_valid_reason(df.geometry.iloc[i]), "action": "derived make_valid; original preserved"})
        # Explicit derived repair only; source SHP/GDB remains byte-for-byte intact.
        if df.source_invalid.any():
            df.geometry = df.geometry.make_valid()
        assert df.is_valid.all() and df.geom_type.isin(permitted).all()
        if "district" in df:
            df["study_district"] = df.district.map(name_key).where(df.district.map(name_key).isin(DISTRICTS), "")
        else:
            df["study_district"] = ""
        if level == "historical_point":
            study = layers["district_context"]
            study_shape = study[study.study_district != ""].geometry.union_all()
            df["inside_study_geometry"] = df.geometry.intersects(study_shape).astype(int)
        if level == "village_polygon":
            keys = [hierarchy_key(r) for r in df.to_dict("records")]
            counts = Counter(keys)
            df["same_hierarchy_rows"] = [counts[k] for k in keys]
            df["nonsettlement_name_flag"] = df.village.str.contains("FOREST|RESERVE|NATIONAL PARK|LAKE", case=False, regex=True).astype(int)
        projected = df.to_crs(32736)  # WGS84 UTM 36S for the southern study-area diagnostics.
        if level != "historical_point":
            df["geom_area_sqkm"] = projected.area / 1e6
        # Representative interior point is a derived polygon location, NOT survey GPS.
        reps = projected.representative_point().to_crs(4326)
        df["ref_lon"] = reps.x
        df["ref_lat"] = reps.y
        df["coordinate_basis"] = "source_point" if level == "historical_point" else "derived_interior_point_not_survey_gps"
        df.to_file(gpkg, layer=name, driver="GPKG", mode="a" if gpkg.exists() else "w", index=False)
        # Tiny DBF schema avoids silent ten-character field truncation; full
        # attributes travel in CSV and Stata merges them by native geo_id.
        df[["geo_id", "geometry"]].to_file(bridge / (name + ".shp"), driver="ESRI Shapefile", index=False)
        attrs = df.drop(columns="geometry")
        attrs.to_csv(out / (name + "_attributes.csv"), index=False, encoding="utf-8-sig")
        fields = [{"layer": name, "source_field": s, "prepared_field": s.lower(), "stata_name": s.lower()[:32]} for s in original_names if s != "geometry"]
        write_csv(out / (name + "_field_map.csv"), fields)
        registry.append({"layer": name, "source_id": source_id, "raw_path": str(path.relative_to(root)),
                         "source_vintage": vintage, "source_crs": original.crs.to_string(), "prepared_crs": "EPSG:4326",
                         "metric_crs": "EPSG:32736; study-area diagnostics, not official national areas",
                         "geometry_level": level, "feature_rows": len(df), "study_rows": int((df.study_district != "").sum()),
                         "invalid_original_rows": int(df.source_invalid.sum()), "duplicate_geometry_rows": int((df.same_geom_rows > 1).sum()),
                         "license_note": license_note, "rct_boundary_status": "NOT_CURRENT_LC_BOUNDARIES_VERIFIED"})
        layers[name] = df
        print(f"GIS {name}: {len(df):,} features; {registry[-1]['study_rows']:,} study labels; original invalid={registry[-1]['invalid_original_rows']}", flush=True)
        return df

    district = layer("district_context", next(hd.rglob("uga_admin2.shp")), {"district": "adm2_name"},
                     "HDX_COD_DATED", "source valid_on field", "district", "CC BY-IGO; HDX metadata controls")
    layer("subcounty_context", next(hd.rglob("uga_admin4.shp")), {"district": "adm2_name", "subcounty": "adm4_name"},
          "HDX_COD_DATED", "source valid_on field", "subcounty", "CC BY-IGO; not village boundaries")
    villages = layer("historical_villages", next(mpk.rglob("villages_ubos_2011_44034.shp")), {},
                     "NPA_UBOS2011_MAP2016", "nominal 2011; copied 2016-08-07", "village_polygon",
                     "ArcGIS item license blank; private research copy only; redistribution permission unverified")
    assert len(villages) == 44034
    points = layer("historical_points", next(expanded["uga_villages_jan_2009_pcodedb.zip"].rglob("*.shp")),
                   {"village": "NAME", "district": "ADM2_EN"}, "UBOS_POINTS_2009", "2009-01", "historical_point",
                   "Stanford metadata public domain; ICPAC mirror license unspecified; preserve source distinction")
    assert len(points) == 5330
    mirror = gpd.read_file(next(expanded["uga_villages_jan_2009.zip"].rglob("*.shp"))).to_crs(4326)
    assert Counter(mirror.geometry.to_wkb()) == Counter(points.geometry.to_wkb()), "2009 point mirrors differ"
    # Old point district names are not current hierarchy. Spatial membership is
    # diagnostic only and never creates an LC-name identity.
    parishes = None
    if (raw / "nbrb_study_parishes.geojson").exists():
        doc = json.loads((raw / "nbrb_study_parishes.geojson").read_text(encoding="utf-8"))
        assert doc["type"] == "FeatureCollection" and doc["numberMatched"] == doc["numberReturned"] == len(doc["features"])
        parishes = layer("parish_context", raw / "nbrb_study_parishes.geojson", {}, "NBRB_UBOS_PUBLISHED2026",
                         "geometry vintage unverified; portal import 2026-07-09", "parish",
                         "Public access/report planning; raw GIS redistribution license unverified; not legal boundaries")
        assert len(parishes) == 199

    historic = [r for r in villages.to_dict("records") if r["study_district"]]
    district_geom = {r["study_district"]: r["geometry"] for r in district.to_dict("records") if r["study_district"]}
    spatial_checks = []
    for d in DISTRICTS:
        h = villages[villages.study_district == d].to_crs(32736)
        union = h.geometry.union_all()
        district_area = district[district.study_district == d].to_crs(32736).geometry.union_all()
        spatial_checks.append({"district": d, "historical_polygon_rows": len(h),
                               "source_area_sum_sqkm": h.geom_area_sqkm.sum(), "source_union_sqkm": union.area / 1e6,
                               "overlap_excess_sqkm": h.geom_area_sqkm.sum() - union.area / 1e6,
                               "context_district_sqkm": district_area.area / 1e6,
                               "district_not_covered_sqkm": district_area.difference(union).area / 1e6,
                               "historical_outside_district_sqkm": union.difference(district_area).area / 1e6,
                               "interpretation": "historical/district geometry diagnostic, not current LC boundary certification"})
    write_csv(out / "phase2_spatial_checks.csv", spatial_checks)
    exact, short, same_name, parish_exact, parish_short = (defaultdict(list) for _ in range(5))
    for r in historic:
        k = hierarchy_key(r)
        exact[k].append(r)
        short[shorthand_key(k)].append(r)
        same_name[(k[0], k[3])].append(r)
    if parishes is not None:
        for r in parishes.to_dict("records"):
            k = hierarchy_key(r, ("district", "subcounty", "parish"))
            parish_exact[k].append(r)
            parish_short[shorthand_key(k)].append(r)
    links, candidate_rows = [], []
    for f in frame:
        k = hierarchy_key(f)
        candidates = exact[k]
        status = "historical_full_hierarchy_match"
        if len(candidates) != 1:
            candidates = short[shorthand_key(k)]
            status = "historical_unique_admin_shorthand"
        match = candidates[0] if len(candidates) == 1 else None
        if not match:
            candidates = same_name[(k[0], k[3])]
            status = "parent_or_vintage_review" if len(candidates) == 1 else ("ambiguous_name_review" if candidates else "no_historical_name_candidate")
        for c in candidates:
            candidate_rows.append({"phase2_lc_uid": f["phase2_lc_uid"], "candidate_geo_id": c["geo_id"],
                                   "candidate_status": status, "source_district": c["district"], "source_subcounty": c["subcounty"],
                                   "source_parish": c["parish"], "source_village": c["village"],
                                   "accepted_documentary_link": int(match is not None)})
        pk = k[:3]
        pm = parish_exact[pk]
        pstatus = "parish_full_hierarchy_match"
        if len(pm) != 1:
            pm = parish_short[shorthand_key(pk)]
            pstatus = "parish_unique_admin_shorthand"
        parish_match = pm[0] if len(pm) == 1 else None
        if not parish_match:
            pstatus = "parish_identity_review"
        links.append({"phase2_lc_uid": f["phase2_lc_uid"], "village_geo_id": match["geo_id"] if match else "",
                      "geometry_link_status": status, "candidate_geometry_rows": len(candidates),
                      "hist_ref_lon": match["ref_lon"] if match else "", "hist_ref_lat": match["ref_lat"] if match else "",
                      "coordinate_basis": "historical_polygon_interior_point_not_survey_gps" if match else "unresolved_no_lc_coordinate",
                      "hist_source_invalid": match["source_invalid"] if match else "",
                      "hist_same_geometry_rows": match["same_geom_rows"] if match else "",
                      "hist_point_in_district": int(district_geom[k[0]].covers(shapely.Point(match["ref_lon"], match["ref_lat"]))) if match else "",
                      "parish_geo_id": parish_match["geo_id"] if parish_match else "", "parish_link_status": pstatus,
                      "current_lc_boundary_verified": 0, "rct_assignment_frame_released": 0,
                      "review_decision": "", "review_evidence": ""})
    assigned = [r["village_geo_id"] for r in links if r["village_geo_id"] != ""]
    assert len(assigned) == len(set(assigned)), "One historical polygon matched multiple current LCs; stop rather than guess"
    write_csv(out / "phase2_geometry_links.csv", links)
    write_csv(out / "phase2_geometry_candidates.csv", candidate_rows)
    linkmap = {r["phase2_lc_uid"]: r for r in links}
    project = [r for r in read_csv(admin / "phase2_administrative_source_crosswalk.csv") if r["source_id"] == "PROJECT_PHASE1"]
    assert len(project) == 130 and len({r["phase1_uid"] for r in project}) == 130
    for r in project:
        m = linkmap.get(r["phase2_lc_uid"])
        r.update({"village_geo_id": m["village_geo_id"] if m else "",
                  "geometry_link_status": m["geometry_link_status"] if m else "project_lc_identity_unresolved",
                  "current_lc_boundary_verified": 0, "mentor_eligibility": "NOT_ASSESSED"})
    write_csv(out / "phase2_project_geometry_crosswalk.csv", project)
    summary = []
    for d in DISTRICTS:
        ids = {r["phase2_lc_uid"] for r in frame if r["district"] == d}
        refs = [r for r in links if r["phase2_lc_uid"] in ids]
        summary.append({"district": d, "administrative_lcs": len(refs),
                        "historical_polygon_rows": sum(r["study_district"] == d for r in historic),
                        "hierarchy_geometry_links": sum(r["village_geo_id"] != "" for r in refs),
                        "parent_or_vintage_review": sum(r["geometry_link_status"] == "parent_or_vintage_review" for r in refs),
                        "ambiguous_name_review": sum(r["geometry_link_status"] == "ambiguous_name_review" for r in refs),
                        "no_name_candidate": sum(r["geometry_link_status"] == "no_historical_name_candidate" for r in refs),
                        "parish_context_links": sum(r["parish_geo_id"] != "" for r in refs),
                        "current_lc_boundaries_verified": 0})
    write_csv(out / "phase2_geographic_coverage.csv", summary)
    for name, df in layers.items():
        for r in df[df.same_geom_rows > 1][["geo_id", "same_geom_rows"]].to_dict("records"):
            issues.append({"layer": name, "geo_id": r["geo_id"], "issue": "duplicate_geometry_preserved",
                           "detail": str(r["same_geom_rows"]) + " identical rows", "action": "no automatic deduplication"})
        if "same_hierarchy_rows" in df:
            for r in df[(df.study_district != "") & (df.same_hierarchy_rows > 1)][["geo_id", "same_hierarchy_rows"]].to_dict("records"):
                issues.append({"layer": name, "geo_id": r["geo_id"], "issue": "duplicate_study_hierarchy",
                               "detail": str(r["same_hierarchy_rows"]) + " historical rows", "action": "identity review; no automatic dissolve"})
    write_csv(out / "phase2_geometry_issues.csv", issues, ["layer", "geo_id", "issue", "detail", "action"])
    write_csv(out / "phase2_geographic_layers.csv", registry)
    inventory = []
    selected_paths = {str(root / r["raw_path"]) for r in registry}
    for directory in [*expanded.values(), hd, mpk]:
        for p in [*directory.rglob("*.shp"), *directory.rglob("*.gdb")]:
            names = [None] if p.suffix == ".shp" else [x[0] for x in pyogrio.list_layers(p)]
            for sublayer in names:
                info = pyogrio.read_info(p, layer=sublayer, force_feature_count=True, force_total_bounds=True)
                inventory.append({"raw_path": str(p.relative_to(root)), "sublayer": sublayer or "",
                                  "feature_rows": info["features"], "geometry_type": info["geometry_type"],
                                  "crs": info["crs"], "bounds": str(info["total_bounds"]),
                                  "fields": "; ".join(info["fields"]), "retained_primary_layer": int(str(p) in selected_paths),
                                  "role": "retained GIS input" if str(p) in selected_paths else "unused context/mirror/archive layer; not assignment input"})
    write_csv(out / "phase2_source_layer_inventory.csv", inventory)
    dictionary = [
        ("phase2_lc_uid", "Dated EC-hierarchy administrative LC identity from Milestone 1", "Never a respondent or submission key"),
        ("village_geo_id", "Source row ID in 44,034-feature historical NPA village layer", "Missing if hierarchy identity is not uniquely linked"),
        ("parish_geo_id", "Contextual NBRB parish feature row", "Not village location; missing for unresolved parish identity"),
        ("geometry_link_status", "Unique full hierarchy/shorthand or explicit review status", "Name-only candidates are never authoritative matches"),
        ("candidate_geometry_rows", "Historical same-name candidate rows considered", "Not number of current LCs or survey interviews"),
        ("hist_ref_lon / hist_ref_lat", "WGS84 interior point derived from historical polygon after explicit validity repair", "Not interview GPS, a settlement center or a verified current LC location"),
        ("hist_point_in_district", "Derived interior point covered by dated HDX district polygon", "Spatial plausibility diagnostic, not boundary certification"),
        ("hist_same_geometry_rows / same_geom_rows", "Number of identical source geometries, including this row", "Duplicates preserved; no automatic deduplication"),
        ("hist_source_invalid / source_invalid", "Original source geometry failed validity test", "Source unchanged; only derived geometry repaired with make_valid"),
        ("same_hierarchy_rows", "Repeated full normalized historical hierarchy rows", "Distinct source polygons retained; no automatic dissolve"),
        ("source_vertex_order", "Native shapefile coordinate row order before Stata joins/sorts", "Preserves polygon rings and part separators for mapping"),
        ("inside_study_geometry", "Historical point is spatially inside the three dated district polygons", "Does not create a village-name identity or complete census"),
        ("source_vintage", "Source geometry reference/copy/import date, with uncertainty explicit", "Acquisition/import date does not establish boundary vintage"),
        ("current_lc_boundary_verified", "Current LC-boundary certification status", "Zero throughout; historical geometry alone cannot certify 2026 boundaries"),
        ("rct_assignment_frame_released", "RCT geographic frame release status", "Zero throughout; no mentor, neighbor or assignment selection"),
        ("review_decision / review_evidence", "Editable human-review notes preserved in workbook on refresh", "Notes only; not automatically applied to authoritative IDs or Stata data"),
    ]
    dictrows = [dict(zip(("variable", "definition", "interpretation_or_missing_rule"), r)) for r in dictionary]
    write_csv(out / "phase2_geographic_dictionary.csv", dictrows)
    source_rows = []
    roles = {
        "hdx_admin_boundaries.shp.zip": ("dated district/subcounty context", "2020-08-24 source valid_on", "CC BY-IGO", "Lowest level is subcounty, not LC"),
        "npa_map_package.mpk": ("historical village polygons", "nominal UBOS2011; 2016 copy", "License blank; permission for redistribution unverified", "Historical identity/current boundary review"),
        "nbrb_study_parishes.geojson": ("contextual parish polygons", "vintage unverified; import 2026-07-09", "Raw reuse/redistribution license unverified", "Parish geometry is not village geometry"),
        "nes_report_2021.pdf": ("source-existence documentation", "report 2021; described UBOS2020", "Not a raw geometry license", "IED service revoked TLS; geometry not acquired"),
        "psu_mapping_metadata.html": ("historical archive metadata", "deposited 2018; geometry vintage not established", "CC BY-NC 4.0", "Ordinary public downloads returned traffic-control pages"),
        "dre_settlements_2025.geojson": ("optional settlement clusters", "2025 release", "CC BY 4.0", "HTTP403; settlement clusters are not administrative LCs"),
        "grid3_metadata.xml": ("settlement-extent source metadata", "2024-09-30 release", "CC BY-SA 4.0", "Not village units; metadata retained, not an administrative frame"),
    }
    for name, r in cache.items():
        status = r["status"]
        if name == "psu_archive_readme.txt":
            status = "traffic_control_html_not_readme"
        if name == "rcmrd_service.html":
            status = "oauth_login_page_not_geometry"
        source_rows.append({"file": name, "source_url": source_identity(r["url"]), "acquisition_status": status,
                            "response_status": r.get("response_status", "not_applicable"), "sha256": r.get("sha256", ""),
                            "bytes": r.get("bytes", ""), "checked_utc": r.get("retrieved_utc", r.get("checked_utc", "")),
                            "issue": re.sub(r"download_token=[^ ;\"<>]+", "download_token=[expired public link]", r.get("error", "")),
                            **dict(zip(("use_category", "geometry_vintage_note", "license_note", "reason_not_assignment_ready"),
                                       roles.get(name, ("documentary source audit", "see linked source; acquisition date is not vintage", "No raw geometry rights inferred", "Metadata/catalog is not a current village frame"))))})
    for name, digest in LOCAL_ARCHIVES.items():
        p = root / "3 Data/1 Raw/Secondary data" / name
        source_rows.append({"file": name, "source_url": "Existing project Dropbox source; see M1/project corpus provenance",
                           "acquisition_status": "existing_archive_checksum_verified", "response_status": "ok", "sha256": digest,
                           "bytes": p.stat().st_size, "checked_utc": datetime.now(timezone.utc).isoformat(), "issue": "",
                           "use_category": "dated context" if "admin" in name else "historical point mirror",
                           "geometry_vintage_note": "2020-08-24" if "admin" in name else "2009-01",
                           "license_note": "HDX CC BY-IGO" if "admin" in name else "Stanford public-domain metadata; ICPAC unspecified",
                           "reason_not_assignment_ready": "Not complete verified current LC geography"})
    write_csv(out / "phase2_geographic_sources.csv", source_rows)
    after = protected_inputs(root)
    assert before == after, "Protected Phase 1/administrative source changed"
    runtime = {p.split("==")[0]: importlib.metadata.version(p.split("==")[0]) for p in GIS_PACKAGES}
    runtime.update({"python": sys.version, "gdal": pyogrio.__gdal_version_string__, "proj": pyproj.proj_version_str})
    write_json(out / "phase2_geographic_manifest.json", {"milestone": 2, "status": "HISTORICAL_GEOGRAPHIC_REFERENCE_NOT_RCT_RELEASE",
               "built_utc": datetime.now(timezone.utc).isoformat(), "runtime": runtime,
               "protected_inputs_before_after": before, "raw_download_manifest_sha256": sha(raw / "download_manifest.json"),
               "administrative_lcs": len(frame), "historical_geometry_links": len(assigned),
               "project_rows": len(project), "project_documentary_lc_links": sum(bool(r["phase2_lc_uid"]) for r in project),
               "project_historical_geometry_links": sum(bool(r["village_geo_id"]) for r in project),
               "geometry_currentness_verified": False, "survey_gps_available": False})
    write_json(out / "review_workbook_inputs.json", {"GeoCoverage": summary + [{"district": "TOTAL", **{k: sum(r[k] for r in summary) for k in summary[0] if k != "district"}}], "GeoReview":
               [{**{k: f[k] for k in ("district", "subcounty", "parish", "village")}, **m} for f, m in zip(frame, links)],
               "GeoProject": project, "GeoSources": source_rows, "GeoQA": issues, "GeoDictionary": dictrows})
    (out / "README.md").write_text("""# Phase 2 geographic reference — Milestone 2

Run `1 Code/6 Phase2_Geospatial_Frame.do` through Stata MCP. The default build uses
frozen, checksum-verified Dropbox inputs. Mode `acquire` archives public HTTPS
responses before the build. No TLS or authentication controls are bypassed.
The three LOCAL_ARCHIVES and Milestone 1 CSV/DTA products are prerequisite inputs
included in the Dropbox package, not fetched silently from substitute mirrors.
Pinned Python GIS packages perform format conversion and explicit geometric QA;
Stata imports every retained layer, joins the reference, asserts IDs/counts and
saves the final DTA products. Coordinates are WGS84 longitude/latitude; polygon
interior points are explicitly DERIVED and are not interview GPS.
Study-area area/overlay diagnostics use WGS84 UTM zone 36S (EPSG:32736).
They are not official published areas or nationwide area estimates.

Prerequisites: Stata 19 with Python >=3.11 configured, uv, Windows bsdtar/curl,
and the bundled Node/artifact-tool runtime for the editable review workbook.
GIS package versions and GDAL/PROJ/Python versions are pinned/recorded in the
manifest. Set CODEX_RUNTIME_DEPENDENCIES only if the bundled-runtime directory
is elsewhere. Run from the repository root, or pass companion as third do-file
argument. The .do is the sole entry point: Python converts/validates geometry,
Stata creates/imports all native DTA files and maps, and the JavaScript companion
only formats the existing review workbook. It preserves all Milestone 1 sheets
and any existing GeoReview notes. Workbook notes do not alter LC identities.

The 44,034-feature NPA layer is nominally UBOS 2011, copied into a 2016 map
package. Neither filename nor copy date verifies current LC boundaries. The
1,483-LC dated EC reference and the historical features are different objects.
Exact full-hierarchy and unique administrative-shorthand links preserve Roman
numerals and token boundaries. Same-name/different-parent candidates are REVIEW
ONLY. No fuzzy, nearest-name or parish-centroid village imputation is used.

NBRB parish geometry is contextual: import date is not boundary vintage and raw
redistribution permission is unverified. Historical UBOS 2009 points are sparse,
duplicated source points, not a complete current village census. The inaccessible
NES/IED endpoint has a revoked TLS certificate; PSU returned traffic-control
pages even for its ordinary public Download links; DRE returned HTTP403. These
failures are documented, not treated as evidence that the datasets do not exist.
The PSU archive license is CC BY-NC 4.0; the ArcGIS map-package license is blank.
Keep the latter as a private research copy pending permission clarification.
Do not redistribute license-held GIS files as an unrestricted public package.

No source boundary, Phase 1 survey, score, report, randomization or Master file
is changed. No mentors/neighbors/treatment waves are selected here. The package
is NOT an assignment-ready RCT frame. Geography/identity and licensing gaps stay
visible. Review-workbook edits are notes only, not automatic authoritative merges.
""", encoding="utf-8")
    print("Geographic bridge built; final DTA imports and checks must run in Stata.", flush=True)


def reconcile(root):
    """Dated identity/context review. Never certify current LC boundaries."""
    import geopandas as gpd
    import pandas as pd
    import shapely
    import importlib.metadata
    raw, out = folders(root)
    admin = root / "3 Data/2 Working/Phase2_Administrative_Frame"
    protected = protected_inputs(root)
    m2path = out / "phase2_geographic_manifest.json"
    m2 = json.loads(m2path.read_text(encoding="utf-8"))
    frozen = {root / p: h for p, h in m2["product_sha256"].items()}
    frozen[m2path] = sha(m2path)
    for p, h in frozen.items():
        assert sha(p) == h, f"Accepted Milestone 2 product changed: {p}"
    source = lambda name, endpoint: fetch(root, name, "https://statistics.ubos.org/nphc/" + endpoint, raw_subdir="milestone3")
    source("ubos_2024_map.html", "map")
    source("ubos_2024_drilldown.html", "drilldown")
    load = lambda name, endpoint: json.loads(source(name, "api/" + endpoint).read_text(encoding="utf-8-sig"))
    districts = load("ubos_districts.json", "get_districts.php?subregion_code=41")
    expected = {"BUSHENYI": ("402", 17, 72), "RUBIRIZI": ("425", 11, 53), "SHEEMA": ("426", 15, 74)}
    assert {r["name"]: r["code"] for r in districts if r["name"] in expected} == {d: x[0] for d, x in expected.items()}
    parents, scrows, features = [], [], []
    for district, (dc, nsc, np) in expected.items():
        counties = load(f"ubos_counties_{dc}.json", f"get_counties.php?district_code={dc}")
        assert len(counties) == 2
        district_scs = []
        for county in counties:
            cc = str(county["code"])
            assert str(county["district_code"]) == dc
            subcounties = load(f"ubos_subcounties_{cc}.json", f"get_subcounties.php?county_code={cc}")
            for sc in subcounties:
                code = str(sc["code"])
                assert str(sc["district_code"]) == dc and str(sc["county_code"]) == cc
                row = {"geo_id": int(code), "district": district, "census_county": county["name"],
                       "subcounty": sc["name"], "ubos_district_code": dc, "ubos_county_code": cc,
                       "ubos_subcounty_code": code, "source_context": "NPHC 2024; geometry update date unverified",
                       "current_boundary_certified": 0, "rct_geographic_release": 0}
                scrows.append(row); district_scs.append(row)
                parishfile = f"ubos_parishes_{code}.json"
                parishes = load(parishfile, f"get_parishes.php?district_code={dc}&subcounty_code={code}")
                for parish in parishes:
                    assert str(parish["district_code"]) == dc and str(parish["ccode"]) == cc and str(parish["scode"]) == code
                    parents.append({**row, "parish": parish["name"], "ubos_parish_code": str(parish["code"]),
                                    "source_file": str((raw / "milestone3" / parishfile).relative_to(root)),
                                    "source_sha256": sha(raw / "milestone3" / parishfile)})
        assert len(district_scs) == nsc and sum(r["district"] == district for r in parents) == np
        doc = load(f"ubos_geometry_{dc}.geojson", f"get_geospatial_data.php?level=subcounty&district_code={dc}")
        collection = doc["geojson"]
        if isinstance(collection, str): collection = json.loads(collection)
        assert collection["type"] == "FeatureCollection" and len(collection["features"]) == nsc
        assert collection.get("crs", {}).get("properties", {}).get("name") in (None, "urn:ogc:def:crs:OGC:1.3:CRS84", "EPSG:4326")
        for f in collection["features"]:
            p = f["properties"]
            code = str(p["population_data"]["code"])
            assert code == str(p["DCode"]) + str(p["CCode"]) + str(p["SCode"])
            assert code in {r["ubos_subcounty_code"] for r in district_scs}
            features.append({"type": "Feature", "properties": {"geo_id": int(code)}, "geometry": f["geometry"]})
    assert len(scrows) == 43 and len(parents) == 199
    assert len({r["ubos_parish_code"] for r in parents}) == 199
    geometry = gpd.GeoDataFrame.from_features(features, crs=4326)
    assert geometry.geo_id.is_unique and geometry.geom_type.isin(["Polygon", "MultiPolygon"]).all()
    invalid = ~geometry.is_valid
    geometry["source_invalid"] = invalid.astype(int)
    if invalid.any(): geometry.geometry = geometry.geometry.make_valid()
    assert geometry.is_valid.all() and geometry.geometry.to_wkb().is_unique
    assert (~geometry.is_empty).all() and geometry.geom_type.isin(["Polygon", "MultiPolygon"]).all()
    xmin, ymin, xmax, ymax = geometry.total_bounds
    assert 28 <= xmin <= xmax <= 36 and -3 <= ymin <= ymax <= 6
    reps = geometry.to_crs(32736).representative_point().to_crs(4326)
    geometry["ref_lon"], geometry["ref_lat"] = reps.x, reps.y
    geometry["geom_area_sqkm"] = geometry.to_crs(32736).area / 1e6
    assert geometry.covers(reps).all()
    gis = out / "gis"; gis.mkdir(exist_ok=True)
    geometry[["geo_id", "geometry"]].to_file(gis / "ubos2024_subcounties.shp", index=False)
    geometry.to_file(gis / "ubos2024_context.gpkg", layer="subcounties", driver="GPKG", index=False)
    bygeo = {r["geo_id"]: r for r in geometry.drop(columns="geometry").to_dict("records")}
    for r in scrows: r.update({k: v for k, v in bygeo[r["geo_id"]].items() if k != "geo_id"})
    lcs = read_csv(out / "phase2_geographic_lc_reference.csv")
    assert len(lcs) == 1483 and len({r["phase2_lc_uid"] for r in lcs}) == 1483
    parishrefs = defaultdict(dict)
    sckeys = defaultdict(set)
    for r in lcs:
        k = hierarchy_key(r)[:3]
        parishrefs[k][r["parish_uid"]] = r
        sckeys[k[:2]].add(r["subcounty_uid"])
    parishmap = {}
    for r in parents:
        k = hierarchy_key(r, ("district", "subcounty", "parish"))
        candidates = list(parishrefs[k].values())
        assert len(candidates) <= 1, "Ambiguous EC parish identity"
        r["ec_parish_uid"] = candidates[0]["parish_uid"] if candidates else ""
        r["crosswalk_status"] = "named_hierarchy_match" if candidates else "parish_spelling_review"
        r["ec_parish_name"] = candidates[0]["parish"] if candidates else ""
        r["interpretation"] = "Dated parent context only; not current LC geometry or compatible source codes"
        if candidates: parishmap[candidates[0]["parish_uid"]] = r
    assert sum(bool(r["ec_parish_uid"]) for r in parents) == 196
    assert len({hierarchy_key(r, ("district", "subcounty")) for r in scrows}) == 43
    census_sc = {hierarchy_key(r, ("district", "subcounty")): r for r in scrows}
    assert all(len(sckeys[k]) == 1 for k in census_sc), "Nonunique electoral parent"
    assert set(sckeys) == set(census_sc)
    geomdict = dict(zip(geometry.geo_id, geometry.geometry))
    historic = {r["geo_id"]: r for r in read_csv(out / "historical_villages_attributes.csv")}
    lcmap = {r["phase2_lc_uid"]: r for r in lcs}
    candidates = read_csv(out / "phase2_geometry_candidates.csv")
    assert len({(r["phase2_lc_uid"], r["candidate_geo_id"]) for r in candidates}) == len(candidates)
    for c in candidates:
        lc = lcmap[c["phase2_lc_uid"]]; h = historic[c["candidate_geo_id"]]
        sc = census_sc[hierarchy_key(lc)[:2]]
        c["ubos_subcounty_code"] = sc["ubos_subcounty_code"]
        c["candidate_inside_census_sc"] = int(geomdict[sc["geo_id"]].covers(shapely.Point(float(h["ref_lon"]), float(h["ref_lat"]))))
        c["candidate_parent_name_agrees"] = int(name_key(h["parish"], "parish") == name_key(lc["parish"], "parish"))
        c["interpretation"] = "Containment is a diagnostic, not identity evidence or current boundary certification"
    for lc in lcs:
        sc = census_sc[hierarchy_key(lc)[:2]]
        lc["historical_geo_id"] = lc["village_geo_id"]
        lc["ubos_subcounty_code"] = sc["ubos_subcounty_code"]
        lc["ubos_parish_code"] = parishmap.get(lc["parish_uid"], {}).get("ubos_parish_code", "")
        lc["census_parent_status"] = "named_hierarchy_match" if lc["ubos_parish_code"] else "parish_spelling_review"
        lc["historical_point_in_census_sc"] = next((c["candidate_inside_census_sc"] for c in candidates if c["phase2_lc_uid"] == lc["phase2_lc_uid"] and c["candidate_geo_id"] == lc["historical_geo_id"]), "")
        lc["current_parent_spatial_status"] = "outside_census_parent_review" if lc["historical_point_in_census_sc"] == 0 else "historical_point_inside_census_parent" if lc["historical_point_in_census_sc"] == 1 else "no_accepted_historical_point"
        lc["current_boundary_certified"] = lc["rct_geographic_release"] = 0
    project = read_csv(out / "phase2_project_geometry_crosswalk.csv")
    assert len(project) == 130 and len({r["source_row_id"] for r in project}) == 130
    assert sum(bool(r["phase2_lc_uid"]) for r in project) == 36
    kirugu = next(r for r in project if r["source_row_id"] == "PROJECT_PHASE1_d32d97b21e66")
    uid = "UGA_112_222_010_031_004"
    assert kirugu["phase1_uid"] == "rubirizi_kirugu_kyenzaza_kirugu_ib" and not kirugu["phase2_lc_uid"]
    assert hierarchy_key(kirugu) == ("RUBIRIZI", "KIRUGU", "KYENZAZA", "KIRUGU IB")
    assert hierarchy_key(lcmap[uid]) == ("RUBIRIZI", "KIRUGU", "KYENZAZA", "KIRUGU I B")
    evidence = [r for r in read_csv(admin / "ec_source_village_rows.csv") if r.get("phase2_lc_uid") == uid]
    # The official row is alternatively addressed by its independently coded hierarchy.
    if not evidence:
        evidence = [r for r in read_csv(admin / "ec_source_village_rows.csv") if hierarchy_key(r) == hierarchy_key(lcmap[uid])]
    assert len(evidence) == 1 and str(evidence[0]["source_page"]) == "2474"
    mapped = [r for r in read_csv(admin / "phase2_administrative_source_crosswalk.csv")
              if r["source_id"] == "PROJECT_MAPPED" and r["phase2_lc_uid"] == uid]
    assert len(mapped) == 1, "Independent project mapping evidence must be unique"
    kirugu["phase2_lc_uid"] = uid
    kirugu["match_status"] = "documented_record_specific_suffix_spacing"
    kirugu["identity_evidence"] = "EC2022 p2474; List of LCs mapped.xlsx Rubirizi row31; Final Village List.xlsx row71; Tracking_Form_Final.xlsx row80; RUBIRIZI ADMIN DATA.xlsx C170; accepted field confirmation 2026-10-02"
    kirugu["identity_evidence_sha256"] = sha(admin / "ec_source_village_rows.csv")
    priorities = {"RUHANDAGAZI": "UGA_004_225_001_009_003", "NYAMYERANDE I": "UGA_004_018_006_011_006",
                  "KISHARU I": "UGA_112_222_006_044_003", "NYAMWERU": "UGA_112_017_002_009_002",
                  "KYAMBURA C": "UGA_112_017_003_029_001", "BURURUMA": "UGA_112_017_008_026_003",
                  "KARAGARA": "UGA_112_017_004_034_002", "RUNYINYA II": "UGA_101_022_005_013_009",
                  "KIZIBA": "UGA_101_294_002_003_006", "KARUGORORA": "UGA_101_022_004_017_003",
                  "KIHANGA II": "UGA_101_022_004_018_008", "BUGARAMA": "UGA_101_021_007_006_002"}
    priorities = {(name_key(lcmap[u]["district"]), v): u for v, u in priorities.items()}
    for r in project:
        linked = r["phase2_lc_uid"]
        r["linked_ec_uid"] = linked
        r["historical_geo_id"] = lcmap[linked]["historical_geo_id"] if linked else ""
        r["current_parent_spatial_status"] = lcmap[linked]["current_parent_spatial_status"] if linked else "identity_unresolved"
        r["current_boundary_certified"] = r["rct_geographic_release"] = 0
        r.setdefault("identity_evidence", "Frozen Milestone 1 full-hierarchy crosswalk" if linked else "Unresolved; candidate names are not identity proof")
        r.setdefault("identity_evidence_sha256", sha(out / "phase2_project_geometry_crosswalk.csv"))
        proposed = priorities.get((name_key(r["district"]), name_key(r["village"]))) if not linked else None
        r["review_priority"] = "one_parent_component_candidate" if proposed else "standard"
        r["proposed_ec_uid"] = proposed or ""
        r["proposed_hierarchy"] = " / ".join(lcmap[proposed][x] for x in ("district", "subcounty", "parish", "village")) if proposed else ""
        if proposed:
            a, b = shorthand_key(hierarchy_key(r)), shorthand_key(hierarchy_key(lcmap[proposed]))
            assert a[0] == b[0] and a[3] == b[3] and sum(x != y for x, y in zip(a, b)) == 1, (r["phase1_uid"], a, b)
        r["review_decision"] = r["review_evidence"] = ""
    assert sum(bool(r["linked_ec_uid"]) for r in project) == 37
    assert len({r["linked_ec_uid"] for r in project if r["linked_ec_uid"]}) == 37
    assert sum(r["review_priority"] != "standard" for r in project) == 12
    assert sum(bool(r["historical_geo_id"]) for r in lcs) == 316
    assert len({r["historical_geo_id"] for r in lcs if r["historical_geo_id"]}) == 316
    write_csv(out / "phase2_ubos2024_subcounty_context.csv", scrows)
    write_csv(out / "phase2_ubos2024_parish_context.csv", parents)
    write_csv(out / "phase2_reconciled_project_reference.csv", project)
    write_csv(out / "phase2_reconciled_lc_reference.csv", lcs)
    write_csv(out / "phase2_reconciliation_geometry_candidates.csv", candidates)
    coverage = []
    for d in DISTRICTS:
        subset = [r for r in project if r["district"] == d]
        local = [r for r in lcs if r["district"] == d]
        coverage.append({"district": d, "dated_ec_lcs": len(local), "project_references": len(subset),
                         "project_identity_links": sum(bool(r["linked_ec_uid"]) for r in subset),
                         "project_identity_pending": sum(not r["linked_ec_uid"] for r in subset),
                         "historical_lc_geometry_links": sum(bool(r["historical_geo_id"]) for r in local),
                         "census_subcounties": sum(r["district"] == d for r in scrows),
                         "census_parishes": sum(r["district"] == d for r in parents),
                         "census_parish_name_matches": sum(r["district"] == d and bool(r["ec_parish_uid"]) for r in parents),
                         "current_lc_boundaries_certified": 0, "rct_geographic_release": 0})
    coverage.append({"district": "TOTAL", **{k: sum(r[k] for r in coverage) for k in coverage[0] if k != "district"}})
    checks = [{"check": "Project identity", "status": "PASS", "observed": 37, "expected": 37, "detail": "36 frozen links plus one documented Kirugu suffix-spacing link; 93 remain pending"},
              {"check": "Historical geometry", "status": "PASS", "observed": 316, "expected": 316, "detail": "No candidate promoted by proximity, containment or parent-label resemblance"},
              {"check": "Census parish hierarchy", "status": "REVIEW", "observed": 196, "expected": 199, "detail": "Kyarikunda/Kyarukunda, Rutooma/Rutoma, Mabaare/Mabare are explicit spelling reviews"},
              {"check": "Current LC boundaries", "status": "NOT_CERTIFIED", "observed": 0, "expected": 0, "detail": "2024 census-map context does not establish geometry vintage, legal LC boundaries or a licensed redistribution right"},
              {"check": "Code namespaces", "status": "PASS", "observed": 0, "expected": 0, "detail": "EC constituencies, UBOS counties and NBRB codes remain separate; no cross-agency numeric code joins"},
              {"check": "Review notes", "status": "AUDIT_ONLY", "observed": 0, "expected": 0, "detail": "Editable notes never automatically alter links; future approved identities require exact IDs and source evidence"}]
    outside = sum(r["historical_point_in_census_sc"] == 0 for r in lcs)
    checks.append({"check": "Historical point versus census parent", "status": "REVIEW" if outside else "PASS", "observed": outside, "expected": 0,
                   "detail": f"Of 316 historical links, {316-outside} points fall inside the matching census SC; {outside} lie outside. Preserve historical evidence but flag parent-context disagreement; no current boundary inference."})
    lead = ("source_row_id", "phase1_uid", "district", "subcounty", "parish", "village", "linked_ec_uid", "match_status", "review_priority", "proposed_ec_uid", "proposed_hierarchy", "historical_geo_id", "current_parent_spatial_status", "identity_evidence", "identity_evidence_sha256", "review_decision", "review_evidence")
    review = [{**{k: r[k] for k in lead}, **{k: v for k, v in r.items() if k not in lead}} for r in project]
    write_json(out / "reconciliation_workbook_inputs.json", {"ReconciledCoverage": coverage, "IdentityReview": review, "UBOSParents": parents, "ReconcileQA": checks})
    assert protected_inputs(root) == protected
    for p, h in frozen.items(): assert sha(p) == h
    manifest = {"milestone": "3 Dated identity and geographic context reconciliation", "built_utc": datetime.now(timezone.utc).isoformat(),
                "status": "REVIEW_PACKAGE_COMPLETE_NOT_RCT_FRAME", "protected_inputs_before_after": protected,
                "frozen_m2_sha256": {str(p): h for p, h in frozen.items()},
                "raw_source_sha256": {str(p.relative_to(root)): sha(p) for p in (raw / "milestone3").glob("*") if p.is_file() and not p.name.endswith(".tmp")},
                "runtime": {p.split("==")[0]: importlib.metadata.version(p.split("==")[0]) for p in GIS_PACKAGES},
                "project_references": 130, "project_identity_links": 37, "historical_geometry_links": 316,
                "census_subcounties": 43, "census_parishes": 199, "census_parish_matches": 196, "historical_points_outside_census_parent": outside,
                "stata_import_validation_passed": False, "current_lc_boundaries_certified": 0, "rct_geographic_release": 0}
    write_json(out / "phase2_reconciliation_manifest.json", manifest)
    print("Milestone 3 evidence bridge prepared; native Stata validation still required.", flush=True)


def verify_reconciliation(root):
    _, out = folders(root)
    path = out / "phase2_reconciliation_manifest.json"
    m = json.loads(path.read_text(encoding="utf-8"))
    assert protected_inputs(root) == m["protected_inputs_before_after"]
    for p, h in m["frozen_m2_sha256"].items(): assert sha(Path(p)) == h, f"Frozen product changed: {p}"
    for p, h in m["raw_source_sha256"].items(): assert sha(root / p) == h, f"Raw source changed: {p}"
    names = ("phase2_reconciled_project_reference", "phase2_reconciled_lc_reference", "phase2_ubos2024_parish_context", "phase2_ubos2024_subcounty_context", "phase2_reconciliation_geometry_candidates")
    assert all((out / (n + ".dta")).exists() for n in names)
    import pandas as pd
    import numpy as np
    for n, expected in zip(names, (130, 1483, 199, 43, None)):
        data = pd.read_stata(out / (n + ".dta"), convert_categoricals=False)
        if expected: assert len(data) == expected
        source = pd.read_csv(out / (n + ".csv"), dtype=str, keep_default_na=False)
        key = "source_row_id" if "project" in n else "ubos_parish_code" if "parish" in n else "geo_id" if "subcounty" in n else "phase2_lc_uid"
        keys = [key, "candidate_geo_id"] if "candidates" in n else [key]
        for k in keys: data[k] = data[k].astype(str)
        data = data.sort_values(keys).reset_index(drop=True)
        source = source.sort_values(keys).reset_index(drop=True)
        assert len(data) == len(source) and set(source.columns).issubset(data.columns)
        for col in source:
            if pd.api.types.is_numeric_dtype(data[col]):
                values = pd.to_numeric(source[col].replace("", np.nan))
                assert np.allclose(values, data[col], rtol=1e-7, atol=1e-9, equal_nan=True), f"Native numeric mismatch: {n}/{col}"
            else:
                assert source[col].equals(data[col].fillna("").astype(str)), f"Native text mismatch: {n}/{col}"
        for f in ("current_boundary_certified", "rct_geographic_release"):
            if f in data: assert (data[f] == 0).all()
    products = [out / (n + suffix) for n in names for suffix in (".csv", ".dta")]
    products += list((out / "gis").glob("*")) + [out / "reconciliation_workbook_inputs.json"]
    m.update({"stata_import_validation_passed": True, "stata_execution_route": "stata_run_selection MCP",
              "product_sha256": {str(p.relative_to(root)): sha(p) for p in products if p.is_file()},
              "review_workbook_sha256": sha(root / "4 Deliverables and Presentations/Phase2_Administrative_Village_Census.xlsx"),
              "code_sha256": {p.name: sha(p) for p in Path(__file__).parent.glob("6 Phase2_Geospatial*.*") if p.is_file()}})
    write_json(path, m)
    (out / "README_MILESTONE3.txt").write_text("""Milestone 3: dated identity/geographic-context review; not randomization release.
Reproduce via existing Stata entry: do \"1 Code/6 Phase2_Geospatial_Frame.do\" \"<Dropbox root>\" reconcile
All retained inputs enter native Stata DTA via the stata_run_selection MCP route.
130 project geography entries are not the baseline analytical sample or a training roster.
37 documentary EC identities are linked; 93 remain pending. Only Kirugu IB/I B added.
The 316 historical polygon links are unchanged. Their locations are derived historical
interior points, not survey GPS, current LC boundaries, or approved neighbors.
UBOS NPHC2024 supplies 43 census-map subcounty polygons and 199 parish identity rows.
196 named parish hierarchies match; three spelling pairs remain review-only.
Five accepted historical interior points lie outside the matching census SC;
these are flagged for parent-context review, not silently moved or deleted.
EC constituency, UBOS county, NBRB and census codes are separate namespaces.
The API's reporting year does not certify geometry update date or legal boundaries.
Reuse/redistribution licensing is unverified; keep exact raw responses in private Dropbox.
Original JSONs are preserved; any invalid geometry repair is derived and flagged.
Workbook review notes are audit-only, never automatic merge approvals.
No Phase1 scores, report, baseline sample, Master or randomization code/data changed.
No mentors selected; no neighboring-LC eligibility rule or wave assignment generated.
Next approval-dependent step requires mentor assessment and authoritative identity/
LC geometry evidence; missing identities are not imputed from nearest-name matches.
""", encoding="utf-8")
    print("Milestone 3 native Stata products and immutable inputs verified.", flush=True)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--root", type=Path, default=DEFAULT_ROOT)
    p.add_argument("--acquire", action="store_true")
    p.add_argument("--build", action="store_true")
    p.add_argument("--reconcile", action="store_true")
    p.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    p.add_argument("--review-workbook", action="store_true")
    p.add_argument("--inspect-workbook", action="store_true")
    p.add_argument("--verify", action="store_true")
    args = p.parse_args()
    import importlib.metadata
    pinned = all(importlib.util.find_spec(p.split("==")[0]) and
                 importlib.metadata.version(p.split("==")[0]) == p.split("==")[1] for p in GIS_PACKAGES)
    if (args.build or (args.reconcile and not (args.review_workbook or args.inspect_workbook or args.verify))) and not args.worker and not pinned:
        r = subprocess.run(worker_args(), capture_output=True, text=True,
                           creationflags=subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0)
        _, out = folders(args.root)
        (out / ("phase2_reconciliation_conversion.log" if args.reconcile else "phase2_gis_conversion.log")).write_text(r.stdout + r.stderr, encoding="utf-8")
        print(r.stdout + r.stderr, flush=True)
        r.check_returncode()
        return
    if args.acquire:
        acquire(args.root)
    if args.build:
        build(args.root)
    if args.reconcile and not (args.review_workbook or args.inspect_workbook or args.verify):
        reconcile(args.root)
    if args.review_workbook or args.inspect_workbook:
        review_workbook(args.root, args.inspect_workbook, args.reconcile)
    if args.verify:
        if args.reconcile: verify_reconciliation(args.root)
        else: verify_outputs(args.root)


if __name__ == "__main__":
    main()
