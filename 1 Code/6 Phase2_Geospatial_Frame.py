"""Milestones 2-4 geographic source conversion and review, called from Stata.

Raw responses, archives and derived geography stay in Dropbox. This companion
does not select mentors, approve final neighbor eligibility, or allocate treatment. Stata owns
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
from pathlib import Path, PureWindowsPath

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


def acquire_coverage(root):
    """Milestone 5 public-source search; archive responses, not inferred boundaries.

    Catalog pagination and all inspected item/layer metadata are retained in
    Dropbox. A publisher copy of EC 2022 is not independent administrative
    evidence and a publication/upload date is not the geometry's vintage.
    """
    raw, _ = folders(root)
    folder = raw / "milestone5"
    def get(name, url, required=False):
        p = fetch(root, name, url, required=required, raw_subdir="milestone5")
        if p and p.suffix in (".json", ".geojson"):
            return json.loads(p.read_text(encoding="utf-8-sig"))
        return p
    commit = get("gazetteer_commit.json", "https://api.github.com/repos/kakandemanwell/uganda/commits/master", True)
    revision = commit["sha"]
    assert re.fullmatch(r"[0-9a-f]{40}", revision)
    for file in ("dist/uganda-locations-full.csv", "data/ec/administrative_units_ec2022.json",
                 "data/sources.json", "docs/DATA_QUALITY.md", "LICENSE-DATA.md"):
        get("gazetteer_" + Path(file).name, f"https://raw.githubusercontent.com/kakandemanwell/uganda/{revision}/{file}", True)
    for name, url in {
        "nbrb_catalog.json": SOURCES["nbrb_catalog.json"],
        "nbrb_wfs.xml": SOURCES["nbrb_wfs_capabilities.xml"],
        "wasmis_wfs.xml": SOURCES["wasmis_wfs_capabilities.xml"],
        "npa_catalog.html": SOURCES["npa_catalog.html"],
        "npa_ankole.html": "https://ugnsdigeoportal.com/sector/regional-planning-ankole/shapefiles",
        "ubos_census_map.html": SOURCES["ubos_census_map.html"],
        "ubos_census_builder.html": "https://statistics.ubos.org/nphc/builder.php",
        "psu_mapping_page.html": SOURCES["psu_mapping_metadata.html"],
        "psu_mapping_files_2018.zip": "https://scholarsphere.psu.edu/resources/78c6d2e7-cbff-46e0-9c26-06338b6c943d/downloads/1954",
        "nes_server.json": "https://ied-sa.fr:6443/arcgis/rest/services/UGANDA/Uganda/MapServer?f=pjson",
        "ucc_services.json": "https://services1.arcgis.com/49FlB10KwAxJa07X/ArcGIS/rest/services?f=pjson",
        "uganda_service.json": "https://services6.arcgis.com/zOnyumh63cMmLBBH/ArcGIS/rest/services/Uganda/FeatureServer?f=pjson",
    }.items(): get(name, url)
    # Supplementary settlement points, never interpreted as legal LC polygons.
    # A wide rectangular review extent covers study districts and nearby areas.
    bbox = "(-1.0,29.4,0.2,30.75)"
    queries = {
        "osm_settlement_points.json": f'[out:json][timeout:60];node["place"~"^(village|hamlet|suburb|neighbourhood)$"]{bbox};out body;',
        "osm_lc_boundary_counts.json": f'[out:json][timeout:60];nwr["boundary"="administrative"]["admin_level"="10"]{bbox};out count;',
    }
    for name, query in queries.items():
        get(name, "https://overpass-api.de/api/interpreter?" + urllib.parse.urlencode({"data": query}))
    get("osm_conventions.html", "https://wiki.openstreetmap.org/wiki/WikiProject_Uganda/Conventions-Categories")
    get("osm_license.html", "https://www.openstreetmap.org/copyright")
    items = {}
    searches = ["Uganda village", "Uganda villages", "Uganda cell boundary", "Bushenyi", "Rubirizi", "Sheema", "UBOS village", "Uganda administrative village"]
    pages = []
    for qi, query in enumerate(searches, 1):
        start = 1
        while start > 0:
            params = urllib.parse.urlencode(dict(f="json", num=100, start=start, q=query))
            name = f"arcgis_search_{qi:02}_{start:04}.json"
            result = get(name, "https://www.arcgis.com/sharing/rest/search?" + params)
            if not isinstance(result, dict) or "results" not in result: break
            pages.append(dict(query=query, start=start, total=result["total"], returned=len(result["results"]), source_file=name))
            for item in result["results"]:
                items[item["id"]] = item
            start = result.get("nextStart", -1)
            assert start <= 10001, "Search ceiling exceeded: explicitly revise the source-search protocol"
    write_json(folder / "arcgis_search_pages.json", pages)
    write_json(folder / "arcgis_search_items.json", sorted(items.values(), key=lambda r: r["id"]))
    layers = []
    for item in sorted(items.values(), key=lambda r:r["id"]):
        # Search is scoped to Uganda and the study names. Inspect geographic
        # services, not unrelated dashboards, story maps or applications.
        if item.get("type") not in ("Feature Service", "Map Service", "Shapefile", "File Geodatabase", "GeoJson", "GeoJSON", "Map Package"): continue
        meta = get("item_" + item["id"] + ".json", f"https://www.arcgis.com/sharing/rest/content/items/{item['id']}?f=json")
        if not isinstance(meta, dict): continue
        url = meta.get("url", "")
        if not url.startswith("https://") or not re.search(r"/(FeatureServer|MapServer)$", url): continue
        service = get("service_" + item["id"] + ".json", url + "?f=pjson")
        if not isinstance(service, dict): continue
        for layer in service.get("layers", []):
            if not re.search(r"villag|\bcell\b|lc.?1|settlement", layer.get("name", ""), re.I): continue
            lid = layer["id"]
            layer_meta = get(f"layer_{item['id']}_{lid}.json", f"{url}/{lid}?f=pjson")
            if not isinstance(layer_meta, dict): continue
            count = get(f"count_{item['id']}_{lid}.json", f"{url}/{lid}/query?where=1%3D1&returnCountOnly=true&f=json")
            layers.append(dict(item_id=item["id"], item_title=meta.get("title", ""), owner=meta.get("owner", ""),
                               layer_id=lid, name=layer_meta.get("name", ""), url=f"{url}/{lid}",
                               geometry_type=layer_meta.get("geometryType", ""), feature_count=count.get("count") if isinstance(count, dict) else None,
                               extent=layer_meta.get("extent", {}), description=layer_meta.get("description", ""),
                               copyright=layer_meta.get("copyrightText", ""), license_info=meta.get("licenseInfo", ""),
                               fields=[f["name"] for f in layer_meta.get("fields", [])]))
    write_json(folder / "arcgis_village_layers.json", layers)
    # A separate western-Uganda partner-village layer, not represented as a
    # complete official LC census. Only geographic attributes are requested.
    partner = next((x for x in layers if x["item_id"] == "4841ed598eda4e33b8197cf4b133ecd9" and x["layer_id"] == 1), None)
    if partner:
        params = urllib.parse.urlencode(dict(where="1=1", outFields="FID,District,County,Subcounty,Parish,Village",
                                             returnGeometry="true", outSR=4326, f="geojson", resultRecordCount=2000))
        get("rtv_partner_villages.geojson", partner["url"] + "/query?" + params)
    print(f"Milestone 5 source audit: {len(pages)} complete catalog pages, {len(items)} unique items, {len(layers)} village/settlement layers", flush=True)


def review_workbook(root, inspect_only=False, reconcile_mode=False, neighbors_mode=False, coverage_mode=False):
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
    cmd = [str(node), str(builder), str(root)] + (["--inspect"] if inspect_only else []) + (["--reconcile"] if reconcile_mode else []) + (["--neighbors"] if neighbors_mode else []) + (["--coverage"] if coverage_mode else [])
    r = subprocess.run(cmd, capture_output=True, text=True, creationflags=subprocess.CREATE_NO_WINDOW)
    _, out = folders(root)
    (out / ("phase2_coverage_workbook.log" if coverage_mode else "phase2_neighbor_workbook.log" if neighbors_mode else "phase2_reconciliation_workbook.log" if reconcile_mode else "phase2_geographic_workbook.log")).write_text(r.stdout + r.stderr, encoding="utf-8")
    print(r.stdout + r.stderr, flush=True)
    r.check_returncode()


def saved_path(root, recorded):
    """Resolve portable pins, including accepted manifests with old Windows roots."""
    root, repo = Path(root).resolve(), Path(__file__).resolve().parents[1]
    text = str(recorded).replace("\\", "/")
    parts = tuple(p for p in text.split("/") if p)
    if parts and parts[0] in ("DROPBOX", "REPO"):
        base = root if parts[0] == "DROPBOX" else repo
        suffix = parts[1:]
    elif Path(text).is_absolute() or PureWindowsPath(text).is_absolute():
        path = Path(text).resolve()
        for base in (root, repo):
            if path.is_relative_to(base):
                return path
        # Legacy absolute manifests pin project identities, not a user's drive.
        anchors = [(i, root if part in ("3 Data", "4 Deliverables and Presentations") else repo)
                   for i, part in enumerate(parts)
                   if part in ("3 Data", "4 Deliverables and Presentations", "1 Code")]
        assert len(anchors) == 1, f"Cannot relocate saved pin safely: {recorded}"
        index, base = anchors[0]
        suffix = parts[index:]
    else:
        base = repo if parts and parts[0] == "1 Code" else root
        suffix = parts
    path = base.joinpath(*suffix).resolve()
    assert path.is_relative_to(base), f"Saved pin escapes its project root: {recorded}"
    return path


def same_pins(root, first, second):
    """Compare manifest identities independently of the checkout/Dropbox root."""
    def canonical(pins):
        result = {}
        for recorded, digest in pins.items():
            path = saved_path(root, recorded)
            assert path not in result or result[path] == digest, f"Conflicting pins: {recorded}"
            result[path] = digest
        return result
    return canonical(first) == canonical(second)


def verify_outputs(root):
    _, out = folders(root)
    path = out / "phase2_geographic_manifest.json"
    manifest = json.loads(path.read_text(encoding="utf-8"))
    assert same_pins(root, protected_inputs(root), manifest["protected_inputs_before_after"]), "Protected input changed during Stata execution"
    # Do not capture M3/later products from the shared output folder in M2 pins.
    layers = ("district_context", "subcounty_context", "historical_villages", "parish_context")
    tabular = ("phase2_geographic_coverage", "phase2_geographic_dictionary", "phase2_geographic_layers",
               "phase2_geographic_lc_reference", "phase2_geographic_sources", "phase2_geometry_candidates",
               "phase2_geometry_issues", "phase2_project_geometry_crosswalk", "phase2_source_layer_inventory",
               "phase2_spatial_checks")
    products = [out / (name + suffix) for name in tabular for suffix in (".csv", ".dta")]
    products += [out / (name + suffix) for name in (*layers, "historical_points")
                 for suffix in ("_attributes.csv", "_field_map.csv")]
    products += [out / "historical_points.dta", out / "phase2_geometry_links.csv", out / "phase2_geographic_reference.gpkg"]
    products += [out / f"phase2_geographic_coverage_{district}.png" for district in (*DISTRICTS, "ALL")]
    products += [out / "stata_bridge" / (name + suffix) for name in layers
                 for suffix in (".shp", ".shx", ".dbf", ".prj", "_shp.dta", ".dta")]
    products += [out / "stata_bridge" / ("historical_points" + suffix) for suffix in (".shp", ".shx", ".dbf", ".prj")]
    assert all(p.is_file() for p in products), "Milestone 2 owned product is missing"
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
        path = saved_path(root, p)
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
    frozen = {saved_path(root, p): h for p, h in m2["product_sha256"].items()}
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
    assert same_pins(root, protected_inputs(root), protected)
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
    assert same_pins(root, protected_inputs(root), m["protected_inputs_before_after"])
    for p, h in m["frozen_m2_sha256"].items(): assert sha(saved_path(root, p)) == h, f"Frozen product changed: {p}"
    for p, h in m["raw_source_sha256"].items(): assert sha(saved_path(root, p)) == h, f"Raw source changed: {p}"
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


def repair_inventory_receipt(root, old_hash):
    """Record the narrow native metadata repair; never relabel a full rerun."""
    import pandas as pd
    _, out = folders(root)
    native = out / "phase2_source_layer_inventory.dta"
    csvpath = out / "phase2_source_layer_inventory.csv"
    source = pd.read_csv(csvpath, dtype=str, keep_default_na=False)
    data = pd.read_stata(native, convert_categoricals=False)
    assert len(data) == len(source) == 22 and set(data.columns) == set(source.columns)
    for c in source:
        if c in ("feature_rows", "retained_primary_layer"):
            assert pd.to_numeric(source[c]).equals(data[c].astype("int64")), c
        else: assert source[c].equals(data[c].fillna("").astype(str)), c
    m2path, m3path = out / "phase2_geographic_manifest.json", out / "phase2_reconciliation_manifest.json"
    m2, m3 = json.loads(m2path.read_text()), json.loads(m3path.read_text())
    key = next(p for p in m2["product_sha256"] if p.endswith("phase2_source_layer_inventory.dta"))
    assert m2["product_sha256"][key] == old_hash
    frozen = m3["frozen_m2_sha256"]
    fk = next(p for p in frozen if p.endswith("phase2_source_layer_inventory.dta"))
    mk = next(p for p in frozen if p.endswith("phase2_geographic_manifest.json"))
    assert frozen[fk] == old_hash and frozen[mk] == sha(m2path)
    for p,h in frozen.items():
        if p != fk: assert sha(saved_path(root,p)) == h, p
    correction = {"corrected_utc": datetime.now(timezone.utc).isoformat(), "input_csv_sha256": sha(csvpath),
        "native_before_sha256": old_hash, "native_after_sha256": sha(native), "rows":22,"columns":9,
        "reason":"Explicit comma delimiter replaces mis-detected semicolon; metadata only; no geometry or LC linkage changed",
        "execution":"Stata MCP auditfix; not a full M2/M3 rerun"}
    m2["product_sha256"][key] = sha(native)
    m2.setdefault("metadata_import_corrections", []).append(correction)
    write_json(m2path,m2)
    frozen[fk], frozen[mk] = sha(native), sha(m2path)
    m3.setdefault("upstream_metadata_corrections", []).append(correction)
    write_json(m3path,m3)
    print("22-row metadata inventory corrected and exact nine columns verified. Only its two upstream pins updated.",flush=True)


def workbook_cells(path):
    """Compare accepted worksheet values/formulas independently of formatting."""
    from decimal import Decimal
    ns = {"s":"http://schemas.openxmlformats.org/spreadsheetml/2006/main"}
    with zipfile.ZipFile(path) as z:
        assert z.testzip() is None
        strings = ["".join(n.itertext()) for n in ET.fromstring(z.read("xl/sharedStrings.xml"))] if "xl/sharedStrings.xml" in z.namelist() else []
        rels = {n.get("Id"):n.get("Target") for n in ET.fromstring(z.read("xl/_rels/workbook.xml.rels"))}
        result = {}
        for s in ET.fromstring(z.read("xl/workbook.xml")).find("s:sheets",ns):
            target = rels[s.get("{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id")].lstrip("/")
            if not target.startswith("xl/"): target = "xl/" + target
            cells = []
            for c in ET.fromstring(z.read(target)).findall(".//s:sheetData/s:row/s:c",ns):
                v,f,t = c.find("s:v",ns),c.find("s:f",ns),c.get("t","n")
                text = v.text if v is not None else ""
                if t == "s": text,t = strings[int(text)],"text"
                elif t == "inlineStr": text,t = "".join(c.find("s:is",ns).itertext()),"text"
                elif t == "str": t = "text"
                elif t == "n" and text: text = str(Decimal(text).normalize())
                assert t != "e", f"Workbook error: {s.get('name')}/{c.get('r')}"
                if text or f is not None: cells.append((c.get("r"),t,text,f.text if f is not None else ""))
            result[s.get("name")] = {"cells":len(cells),"formulas":sum(bool(c[3]) for c in cells),
                "sha256":hashlib.sha256(json.dumps(cells,ensure_ascii=False).encode()).hexdigest()}
        return result


def neighbors(root):
    """Historical adjacency/distance sensitivity. No approved eligibility."""
    import geopandas as gpd
    import shapely
    import importlib.metadata
    raw,out = folders(root)
    admin = root / "3 Data/2 Working/Phase2_Administrative_Frame"
    workbook = root / "4 Deliverables and Presentations/Phase2_Administrative_Village_Census.xlsx"
    paths = [admin/"phase2_administrative_source_manifest.json",out/"phase2_geographic_manifest.json",out/"phase2_reconciliation_manifest.json"]
    m1,m2,m3 = [json.loads(p.read_text()) for p in paths]
    pins,audit = {},[]
    def check(label,mapping):
        for p,h in mapping.items():
            actual = saved_path(root,p)
            assert actual.is_file() and sha(actual) == h, f"{label}: changed/missing {actual}"
            repo = Path(__file__).resolve().parents[1]
            key = "DROPBOX/"+actual.relative_to(root).as_posix() if actual.is_relative_to(root) else "REPO/"+actual.relative_to(repo).as_posix()
            assert key not in pins or pins[key] == h, key
            pins[key] = h
        audit.append(dict(check=label,status="PASS",observed=len(mapping),unit="pinned files",detail="All named hashes checked against accepted receipts",required_action="None"))
    for label,mapping in [("M1 inputs",m1["input_sha256"]),("M2 protected",m2["protected_inputs_before_after"]),("M2 products",m2["product_sha256"]),("M3 frozen M2",m3["frozen_m2_sha256"]),("M3 protected",m3["protected_inputs_before_after"]),("M3 raw",m3["raw_source_sha256"]),("M3 products",m3["product_sha256"])]: check(label,mapping)
    check("M2 HTTPS manifest",{str(raw/"download_manifest.json"):m2["raw_download_manifest_sha256"]})
    for folder in (raw,raw/"milestone3"):
        records = json.loads((folder/"download_manifest.json").read_text())
        check("HTTPS receipt "+folder.name,{str(folder/n):r["sha256"] for n,r in records.items() if r.get("status")=="downloaded"})
    check("Accepted manifests",{str(p):sha(p) for p in paths})
    protected = protected_inputs(root)
    path = out/"phase2_neighbor_manifest.json"
    old = json.loads(path.read_text()) if path.exists() else None
    baseline = workbook_cells(workbook)
    if old:
        current_pins = {saved_path(root,p):h for p,h in pins.items()}
        assert all(current_pins.get(saved_path(root,p))==h for p,h in old["input_sha256"].items()), "Neighborhood source versions changed"
        assert all(baseline[n]==s for n,s in old["accepted_workbook_sheets"].items())
    else: assert sha(workbook)==m3["review_workbook_sha256"], "Review workbook changed: inspect before extending"
    baseline = old["accepted_workbook_sheets"] if old else baseline
    lcs,project = read_csv(out/"phase2_reconciled_lc_reference.csv"),read_csv(out/"phase2_reconciled_project_reference.csv")
    mapped = [r for r in lcs if r["historical_geo_id"]]
    assert len(lcs)==1483 and len(project)==130 and len(mapped)==316
    geo_lc = {int(r["historical_geo_id"]):r for r in mapped}
    project_ids = {r["linked_ec_uid"] for r in project if r["linked_ec_uid"]}
    anchor_ids = {int(r["historical_geo_id"]) for r in project if r["historical_geo_id"]}
    assert len(geo_lc)==316 and len(project_ids)==37 and len(anchor_ids)==10
    layer = gpd.read_file(out/"phase2_geographic_reference.gpkg",layer="historical_villages")
    assert len(layer)==44034 and layer.geo_id.is_unique and layer.crs.to_epsg()==4326 and layer.is_valid.all()
    shapes = layer.to_crs(32736).geometry.to_numpy()
    points = gpd.GeoSeries(gpd.points_from_xy(layer.ref_lon,layer.ref_lat),crs=4326).to_crs(32736).to_numpy()
    assert shapely.covers(shapes,points).all()
    lookup = dict(zip(layer.geo_id.astype(int),range(len(layer))))
    tree = shapely.STRtree(shapes)
    rules = [dict(scenario="queen_exact",edge_flag="queen_exact",definition="Exact boundary/vertex contact, no interior overlap, no snapping"),dict(scenario="rook_exact",edge_flag="rook_exact",definition="Exact contact with positive shared-border length, no interior overlap or snapping")]
    rules += [dict(scenario=f"point_{k}m",edge_flag=f"point_le_{k}m",definition=f"Derived polygon interior-point distance <= {k}m in EPSG32736; not GPS or travel distance") for k in (1000,2000,3000,5000)]
    edges,sensitivity = [],[]
    # ponytail: spatial index bounds exact geometry tests; no nearest-name/mentor assignment.
    for a in sorted(mapped,key=lambda r:r["phase2_lc_uid"]):
        ai = lookup[int(a["historical_geo_id"])]; local = []
        for ci in sorted(map(int,tree.query(shapes[ai],predicate="dwithin",distance=5000))):
            c = layer.iloc[ci]; cid = int(c.geo_id)
            if cid==int(a["historical_geo_id"]): continue
            linked = geo_lc.get(cid)
            distance = float(shapely.distance(points[ai],points[ci]))
            contact = bool(shapely.touches(shapes[ai],shapes[ci]))
            border = float(shapely.length(shapely.intersection(shapely.boundary(shapes[ai]),shapely.boundary(shapes[ci])))) if contact else 0.0
            area = float(shapely.area(shapely.intersection(shapes[ai],shapes[ci]))) if shapely.intersects(shapes[ai],shapes[ci]) else 0.0
            e = dict(anchor_lc_uid=a["phase2_lc_uid"],anchor_geo_id=int(a["historical_geo_id"]),anchor_district=a["district"],project_anchor=int(int(a["historical_geo_id"]) in anchor_ids),candidate_geo_id=cid,candidate_lc_uid=linked["phase2_lc_uid"] if linked else "",candidate_district=str(c.district),candidate_subcounty=str(c.subcounty),candidate_parish=str(c.parish),candidate_village=str(c.village),candidate_in_study=int(name_key(c.district) in DISTRICTS),same_district=int(name_key(c.district)==a["district"]),candidate_project_identity=int(bool(linked and linked["phase2_lc_uid"] in project_ids)),candidate_geometry_copies=int(c.same_geom_rows),candidate_name_repeats=int(c.same_hierarchy_rows),candidate_nonsettlement=int(c.nonsettlement_name_flag),candidate_source_invalid=int(c.source_invalid),point_distance_m=distance,polygon_distance_m=float(shapely.distance(shapes[ai],shapes[ci])),shared_border_m=border,overlap_area_m2=area,positive_area_overlap=int(area>0),queen_exact=int(contact),rook_exact=int(contact and border>0),short_border_review=int(contact and 0<border<=1),current_boundary_certified=0,rct_geographic_release=0)
            e.update({f"point_le_{k}m":int(distance<=k) for k in (1000,2000,3000,5000)})
            assert not contact or area==0
            local.append(e); edges.append(e)
        for rule in rules:
            rr = [r for r in local if r[rule["edge_flag"]]]
            sensitivity.append(dict(anchor_lc_uid=a["phase2_lc_uid"],anchor_geo_id=int(a["historical_geo_id"]),district=a["district"],project_anchor=int(int(a["historical_geo_id"]) in anchor_ids),scenario=rule["scenario"],historical_polygon_rows=len(rr),identity_linked_lcs=sum(bool(r["candidate_lc_uid"]) for r in rr),known_project_identities=sum(r["candidate_project_identity"] for r in rr),outside_study_rows=sum(not r["candidate_in_study"] for r in rr),cross_district_rows=sum(not r["same_district"] for r in rr),overlap_rows=sum(r["positive_area_overlap"] for r in rr),source_quality_flag_rows=sum(r["candidate_geometry_copies"]>1 or r["candidate_name_repeats"]>1 or r["candidate_nonsettlement"] or r["candidate_source_invalid"] for r in rr),hist_rows_at_least_6=int(len(rr)>=6),hist_rows_at_least_8=int(len(rr)>=8),current_eligible_neighbors="UNKNOWN",capacity_status="HISTORICAL_ILLUSTRATION_ONLY",current_boundary_certified=0,rct_geographic_release=0))
    assert len(edges)==len({(r["anchor_lc_uid"],r["candidate_geo_id"]) for r in edges}) and len(sensitivity)==1896
    shared = []
    for rule in rules:
        targets = defaultdict(set)
        for e in edges:
            if e["project_anchor"] and e[rule["edge_flag"]]: targets[e["candidate_geo_id"]].add(e["anchor_lc_uid"])
        for cid,aa in sorted(targets.items()):
            if len(aa)<2: continue
            c = layer.iloc[lookup[cid]]
            shared.append(dict(scenario=rule["scenario"],candidate_geo_id=cid,candidate_lc_uid=geo_lc[cid]["phase2_lc_uid"] if cid in geo_lc else "",candidate_district=str(c.district),candidate_village=str(c.village),mapped_project_anchors=len(aa),anchor_lc_uids="; ".join(sorted(aa)),ownership_status="NOT_ASSIGNED",current_boundary_certified=0,rct_geographic_release=0))
    coverage = []
    for p in project:
        ss = {r["scenario"]:r["historical_polygon_rows"] for r in sensitivity if p["historical_geo_id"] and r["anchor_lc_uid"]==p["linked_ec_uid"]}
        coverage.append(dict(project_source_row_id=p["source_row_id"],phase1_uid=p["phase1_uid"],district=p["district"],subcounty=p["subcounty"],parish=p["parish"],village=p["village"],linked_ec_uid=p["linked_ec_uid"],historical_geo_id=p["historical_geo_id"],geometry_status="HISTORICAL_DIAGNOSTIC_ONLY" if ss else "UNKNOWN_MISSING_GEOMETRY",**{r["scenario"]+"_rows":ss.get(r["scenario"],"") for r in rules},mentor_status="NOT_ASSESSED",neighbors_status="NOT_APPROVED",hotspot_status="NOT_VERIFIED",travel_status="NOT_VERIFIED",current_boundary_certified=0,rct_geographic_release=0))
    notes = [
        ("Native metadata import","CORRECTED",22,"rows / nine columns","M2 delimiter error fixed by auditfix. Source CSV, geometry and identities unchanged","Narrow correction receipt retained"),
        ("Administrative frame","DATED_REFERENCE",1483,"EC 2022 LC units","571 Bushenyi, 293 Rubirizi, 619 Sheema. Not a current certified census","Validate current administrative universe"),
        ("Local printed totals","REVIEW",m1["source_count_discrepancies"],"source discrepancies","Six local controls disagree. EC anchor preserved","Do not silently repair source totals"),
        ("Project identity","INCOMPLETE",37,"linked of 130 references","93 pending. Twelve priority candidates not approved","Resolve actual mentor LC identities"),
        ("Project geometry","INCOMPLETE",10,"historical polygons of 130 references","120 unknown neighborhoods. Missing is not zero","Acquire current geometry or document locally verified neighbor identities"),
        ("Parent containment","REVIEW",5,"outside of 316 historical points","311 inside. Point containment is not boundary certification","Keep spatial conflict flags"),
        ("Prior sample indicators","NOT_ELIGIBILITY",130,"project references","original100_frame_selected is blank. selected100_observed has 93 ones and 37 zeros. Neither is mentor status","Use an approved assessment/training roster"),
        ("Neighbor rule","SCENARIOS_ONLY",6,"unapproved definitions","Exact queen/rook contact and 1/2/3/5 km interior-point bands. Not travel distance","CDFU/Jorge approve operational definition"),
        ("Shared candidates","REVIEW",len(shared),"candidate-scenario rows","Only ten mapped project anchors. Counts overlap across rules","Approve ownership and spillover handling"),
        ("Capacity","NOT_LOCKED",2,"planning workloads","Three or four per wave means six or eight distinct villages across two waves. Historical rows are not eligible LCs","Agree feasible workloads with CDFU"),
        ("Mentor assessment","MISSING",0,"approved mentors","No assessment-based ranking or selection performed","Integrate CDFU assessment when available"),
        ("License","HOLD",0,"unrestricted GIS permissions","NPA license blank. UBOS/NBRB public access does not establish reuse rights","Keep license-held raw GIS private"),
        ("Reproducibility safeguards","IMPLEMENTED",2,"code safeguards","M2 product enumeration isolated. Legacy absolute pins are portable","M1-M3 full builds not rerun"),
        ("M1 execution sequence","PROTOCOL_REQUIRED",3,"ordered steps","Source export, companion build, native validation must run in that order. M1 native validation alone is not a source freshness check","Follow the documented M1 sequence; M4 independently checks all source pins"),
        ("Randomization release","NOT_READY",0,"released frames","Mentors, current LC/neighbors, travel/hotspot, ownership, workload, outcome linkage and governance remain unfinalized","Review these decisions before assignment")]
    audit += [dict(zip(("check","status","observed","unit","detail","required_action"),row)) for row in notes]
    tables = {"phase2_neighbor_edges":edges,"phase2_neighbor_sensitivity":sensitivity,"phase2_neighbor_project_coverage":coverage,"phase2_neighbor_shared_candidates":shared,"phase2_neighbor_rules":rules,"phase2_milestone_audit":audit}
    shared_fields = ["scenario","candidate_geo_id","candidate_lc_uid","candidate_district","candidate_village","mapped_project_anchors","anchor_lc_uids","ownership_status","current_boundary_certified","rct_geographic_release"]
    for stem,rows in tables.items(): write_csv(out/(stem+".csv"),rows,shared_fields if stem=="phase2_neighbor_shared_candidates" else None)
    write_json(out/"neighbor_workbook_inputs.json",{n:dict(fields=list(rows[0]) if rows else shared_fields,rows=rows) for n,rows in [("NeighborCoverage",coverage),("NeighborSensitivity",sensitivity),("SharedCandidates",shared),("MilestoneAudit",audit)]})
    assert same_pins(root,protected,protected_inputs(root))
    write_json(path,dict(milestone="4 Historical neighborhood scenarios and cumulative audit",status="DIAGNOSTICS_COMPLETE_NOT_RCT_FRAME",built_utc=datetime.now(timezone.utc).isoformat(),input_sha256=pins,accepted_workbook_sheets=baseline,counts=dict(project_references=130,project_identity_links=37,project_geometry_anchors=10,mapped_lc_anchors=316,historical_edge_pairs=len(edges),scenario_rows=len(sensitivity),shared_candidate_scenario_rows=len(shared)),runtime={p.split("==")[0]:importlib.metadata.version(p.split("==")[0]) for p in GIS_PACKAGES},rules=rules,metric_crs="EPSG:32736",scenario_radius_max_m=5000,current_lc_boundaries_certified=0,mentor_selection_performed=False,randomization_performed=False,rct_geographic_release=0))
    print(f"Neighborhood diagnostics:{len(edges)}pairs/1896scenarios;10of130project anchors;notRCTrelease.",flush=True)


def verify_neighbors(root):
    import pandas as pd
    import numpy as np
    _,out = folders(root)
    path = out/"phase2_neighbor_manifest.json"; m=json.loads(path.read_text())
    for p,h in m["input_sha256"].items(): assert sha(saved_path(root,p))==h,p
    keys = {"phase2_neighbor_edges":["anchor_lc_uid","candidate_geo_id"],"phase2_neighbor_sensitivity":["anchor_lc_uid","scenario"],"phase2_neighbor_project_coverage":["project_source_row_id"],"phase2_neighbor_shared_candidates":["scenario","candidate_geo_id"],"phase2_neighbor_rules":["scenario"],"phase2_milestone_audit":["check"]}
    products=[]
    for stem,kk in keys.items():
        source=pd.read_csv(out/(stem+".csv"),dtype=str,keep_default_na=False).sort_values(kk).reset_index(drop=True)
        data=pd.read_stata(out/(stem+".dta"),convert_categoricals=False)
        sortkey=data[kk].astype(str).apply(lambda s:s.str.replace(r"\.0$","",regex=True))
        data=data.iloc[sortkey.sort_values(kk).index].reset_index(drop=True)
        assert len(source)==len(data) and set(source.columns)==set(data.columns) and not data.duplicated(kk).any(),stem
        for c in source:
            if pd.api.types.is_numeric_dtype(data[c]): assert np.allclose(pd.to_numeric(source[c].replace("",np.nan)),data[c],rtol=1e-12,atol=1e-8,equal_nan=True),(stem,c)
            else: assert source[c].equals(data[c].fillna("").astype(str)),(stem,c)
        products += [out/(stem+s) for s in (".csv",".dta")]
    workbook=root/"4 Deliverables and Presentations/Phase2_Administrative_Village_Census.xlsx"
    now=workbook_cells(workbook)
    assert all(now[n]==s for n,s in m["accepted_workbook_sheets"].items()),"Accepted worksheet cells changed"
    assert all(n in now for n in ("NeighborCoverage","NeighborSensitivity","SharedCandidates","MilestoneAudit"))
    m.update(stata_import_validation_passed=True,stata_execution_route="stata_run_selection MCP",accepted_worksheet_cells_unchanged=True,review_workbook_sha256=sha(workbook),product_sha256={p.relative_to(root).as_posix():sha(p) for p in products},code_sha256={p.name:sha(p) for p in Path(__file__).parent.glob("6 Phase2_Geospatial*.*") if p.is_file()})
    write_json(path,m)
    (out/"README_MILESTONE4.txt").write_text("""MILESTONE 4: HISTORICAL NEIGHBORHOOD SCENARIOS AND CUMULATIVE AUDIT

Status: diagnostic review complete; NOT an eligible randomization frame.
Reproduce via stata_run_selection MCP only:
do "1 Code/6 Phase2_Geospatial_Frame.do" "<Dropbox root>" neighbors
The existing Stata entry owns conversion, native import, validation, DTA saving
and workbook formatting. Six CSV/DTA products are compared column by column.

SCOPE AND DEFINITIONS
All 316 conservatively mapped EC LC references receive six scenarios. Only ten
of 130 project references have accepted historical geometry. The remaining
120 neighborhoods are UNKNOWN, not zero. These 130 references are not a
confirmed training-attendance roster or an assessment-selected mentor pool.
Queen contact means exact shared boundary or vertex. Rook contact additionally
requires positive shared-border length. Neither snaps boundaries or treats
positive-area overlap as adjacency. The four distance scenarios use 1, 2, 3
and 5 km between stored derived polygon interior points in EPSG:32736. They
are not interview GPS, settlement centres, road distance, travel time or an
approved eligibility rule. Search includes all 44,034 historical polygons
within 5,000 m polygon distance, avoiding artificial study-district clipping.
Candidates outside the study districts and across district borders remain
visible. Geometry row IDs do not represent verified current LC identities.
Duplicate/repaired geometry, repeated names, possible nonsettlements, positive
overlaps and known project identities are flagged without defining eligibility.
SharedCandidates records candidate-by-scenario alternatives reachable from
at least two of the ten mapped project anchors. It does not assess overlap
among all eventual mentors. No candidate is allocated to a mentor.
Six/eight historical-row flags illustrate three/four villages per wave over
two waves. They are not eligible-current-LC counts or mentor feasibility tests.

CUMULATIVE AUDIT
Saved source/product/protected-file hashes checked against M1-M3 receipts.
Independent audit compared 22 existing CSV/native pairs and five native polygon
coordinate datasets, totaling 5,844,770 coordinate rows. A 22-row source-layer
inventory had an incorrectly inferred delimiter in its native DTA: 40 garbled
columns instead of nine. The source CSV was correct. Only that native metadata
file was reimported with explicit commas through the existing auditfix mode.
M2/M3 receipts record before/after hashes and exactly which pins changed. No
geometry, LC linkage, Phase1 data, score, report or assignment was changed.
M2 product pinning now enumerates its own files, not subsequent milestones.
Legacy absolute receipt paths resolve under the supplied Dropbox/repo roots.
M1 must follow source export -> companion build -> native validation. A native
validation alone does not enforce source freshness; M4 checks all saved pins.
Native Stata uses preserve/restore for the active dataset, not full session
state. Run in a dedicated session because clear all clears frames/programs.
Full M1-M3 builds were not rerun here. Historical receipts are not represented
as new full executions. M4 was run natively and independently cross-checked.
All 18 accepted worksheet values/formulas remain unchanged. New workbook tabs:
NeighborCoverage, NeighborSensitivity, SharedCandidates, MilestoneAudit.

READINESS DECISIONS
No mentors, rankings, approved neighbor rule, catchment ownership, selected
sample, treatment waves or randomization were produced. The Inception Report
pp31-33 requires an assessed mentor pool, reliable administrative identities,
geographic proximity OR locally verified neighboring status, hotspot context
where available, and practical travel/transport and mentor capacity. Thus a
locally verified neighbor roster can be a valid route where polygons are absent;
this package does not require perfect polygons for every LC as the only route.
Jorge/CDFU must confirm the mentor roster, exact LC/neighbor identities, final
neighbor rule, cross-border/previous-contact policy, shared-candidate ownership,
workload, rollout governance and outcome-register linkage before release.
NPA reuse license is blank; UBOS/NBRB public access does not establish geometry
redistribution rights. Keep license-held raw GIS in the private Dropbox package
pending permission clarification or provide source acquisition instructions.
""",encoding="utf-8")
    print("Native neighbor products and accepted worksheets verified;randomizationrelease remains0.",flush=True)


def ordinal_key(value, level="village"):
    """Explicit orthographic rule only; no fuzzy identity or parent correction.

    Equivalent terminal Roman/Arabic ordinals and a terminal CELL label are
    normalized only in full-hierarchy joins. A/B and I/II remain distinct.
    Candidate generation can use this key but cannot approve a changed parent.
    """
    text = name_key(value, level)
    if level == "village":
        text = re.sub(r"\s+CELL$", "", text)
        text = re.sub(r"(?<=[A-Z])([1-9])$", r" \1", text)
        parts = text.split()
        roman = dict(I="1", II="2", III="3", IV="4", V="5", VI="6", VII="7", VIII="8", IX="9", X="10")
        if parts and parts[-1] in roman: parts[-1] = roman[parts[-1]]
        text = " ".join(parts)
    if level == "subcounty":
        text = re.sub(r"\s+", " ", re.sub(r"\b(TC|DIV)\b", "", text)).strip()
    return text


def coverage_key(row):
    return tuple(ordinal_key(row[k], k) for k in ("district", "subcounty", "parish", "village"))


def coverage(root):
    """Full coverage ledger and available-geography package; never fill gaps.

    This extends M1-M4 without altering their accepted data, definitions or
    source rows. Direct historical links are mapping references, not current
    LC boundaries. All unresolved rows remain in the registry with missing
    coordinates, and every proposed identity/geometry link retains its rule.
    """
    import geopandas as gpd
    import shapely
    import pandas as pd
    import importlib.metadata
    from difflib import SequenceMatcher
    raw, out = folders(root)
    admin = root / "3 Data/2 Working/Phase2_Administrative_Frame"
    path = out / "phase2_coverage_manifest.json"
    workbook = root / "4 Deliverables and Presentations/Phase2_Administrative_Village_Census.xlsx"
    old = json.loads(path.read_text(encoding="utf-8")) if path.exists() else None
    m4 = json.loads((out / "phase2_neighbor_manifest.json").read_text(encoding="utf-8"))
    pins = dict(m4["input_sha256"])
    pins.update({"DROPBOX/" + str(p).replace("\\", "/"): h for p, h in m4["product_sha256"].items()})
    pins["DROPBOX/" + (out / "phase2_neighbor_manifest.json").relative_to(root).as_posix()] = sha(out / "phase2_neighbor_manifest.json")
    for p, h in pins.items(): assert sha(saved_path(root, p)) == h, f"Changed M1-M4 input/product: {p}"
    receipt = json.loads((raw / "milestone5/download_manifest.json").read_text(encoding="utf-8"))
    for name, record in receipt.items():
        if record["status"] != "downloaded": continue
        p = raw / "milestone5" / name
        assert sha(p) == record["sha256"], name
        pins["DROPBOX/" + p.relative_to(root).as_posix()] = sha(p)
    for name in ("download_manifest.json", "arcgis_search_pages.json", "arcgis_search_items.json", "arcgis_village_layers.json"):
        p = raw / "milestone5" / name
        pins["DROPBOX/" + p.relative_to(root).as_posix()] = sha(p)
    before = workbook_cells(workbook)
    if old:
        if old.get("stata_import_validation_passed"):
            assert same_pins(root, old["input_sha256"], pins), "Accepted coverage inputs changed; inspect source versions first"
        assert all(before[n] == s for n, s in old["accepted_workbook_sheets"].items()), "Prior worksheet changed"
        before = old["accepted_workbook_sheets"]
    else:
        assert sha(workbook) == m4["review_workbook_sha256"], "Existing review workbook changed: inspect before extension"
    protected = protected_inputs(root)
    primary = read_csv(admin / "phase2_administrative_village_frame.csv")
    refs = read_csv(admin / "phase2_administrative_source_crosswalk.csv")
    previous = {r["source_row_id"]: r for r in read_csv(out / "phase2_reconciled_project_reference.csv")}
    old_lcs = {r["phase2_lc_uid"]: r for r in read_csv(out / "phase2_reconciled_lc_reference.csv")}
    assert len(primary) == 1483 and len(previous) == 130
    hist = gpd.read_file(out / "phase2_geographic_reference.gpkg", layer="historical_villages")
    parents = gpd.read_file(out / "gis/ubos2024_context.gpkg", layer="subcounties")
    # M3 stores the geometry and full administrative attributes separately.
    # Join their explicit source feature key, never the positional row order.
    parent_attrs = pd.read_csv(out / "phase2_ubos2024_subcounty_context.csv", dtype=str, keep_default_na=False)
    parent_attrs["geo_id"] = pd.to_numeric(parent_attrs["geo_id"]).astype(int)
    parents = parents.merge(parent_attrs[[c for c in parent_attrs if c == "geo_id" or c not in parents.columns]], on="geo_id", validate="one_to_one")
    parishes = gpd.read_file(out / "phase2_geographic_reference.gpkg", layer="parish_context")
    assert len(hist) == 44034 and hist.geo_id.is_unique and hist.crs.to_epsg() == 4326
    assert len(parents) == 43 and len(parishes) == 199
    hist_rows = hist.drop(columns="geometry").to_dict("records")
    by_geo = {int(r["geo_id"]): r for r in hist_rows}
    ec_index, hist_index, parent_index, hist_by_district = defaultdict(list), defaultdict(list), defaultdict(list), defaultdict(list)
    for r in primary: ec_index[coverage_key(r)].append(r)
    for r in hist_rows:
        hist_index[coverage_key(r)].append(r)
        hist_by_district[name_key(r["district"])].append(r)
    for i, r in parents.iterrows(): parent_index[(name_key(r.district), ordinal_key(r.subcounty, "subcounty"))].append(i)
    lc_geometry = []
    for p in primary:
        prior = old_lcs[p["phase2_lc_uid"]]
        matches = hist_index[coverage_key(p)]
        gid = int(prior["historical_geo_id"]) if prior["historical_geo_id"] else int(matches[0]["geo_id"]) if len(matches) == 1 and len(ec_index[coverage_key(p)]) == 1 else None
        rule = "M3_ACCEPTED_HISTORICAL_LINK" if prior["historical_geo_id"] else "UNIQUE_ORDINAL_FULL_HIERARCHY" if gid else "NO_UNIQUE_HISTORICAL_LINK"
        h = by_geo.get(gid)
        lc_geometry.append(dict(phase2_lc_uid=p["phase2_lc_uid"], district=p["district"], subcounty=p["subcounty"], parish=p["parish"], village=p["village"],
                                historical_geo_id=gid, geometry_rule=rule, historical_lon=h["ref_lon"] if h else None, historical_lat=h["ref_lat"] if h else None,
                                historical_candidate_rows=len(matches), identity_source="EC_VERIFIED_ADMINISTRATIVE_UNITS_JULY_2022", boundary_vintage="NPA nominal UBOS 2011, 2016 copy; not certified current",
                                current_boundary_certified=0, rct_geographic_release=0))
    lc_by_id = {r["phase2_lc_uid"]: r for r in lc_geometry}
    registry, candidates = [], []
    for r in refs:
        if r["source_id"] not in ("PROJECT_FVL", "PROJECT_PHASE1"): continue
        prior = previous.get(r["source_row_id"])
        ec_uid = prior["linked_ec_uid"] if prior else r["phase2_lc_uid"]
        ematches = ec_index[coverage_key(r)]
        identity_rule = "M1_M3_DOCUMENTARY_LINK" if ec_uid else "NO_UNIQUE_IDENTITY_LINK"
        if not ec_uid and len(ematches) == 1:
            ec_uid, identity_rule = ematches[0]["phase2_lc_uid"], "UNIQUE_ORDINAL_FULL_HIERARCHY"
        hm = hist_index[coverage_key(r)]
        chained = lc_by_id[ec_uid]["historical_geo_id"] if ec_uid else None
        direct = int(hm[0]["geo_id"]) if len(hm) == 1 else None
        conflict = int(chained is not None and direct is not None and chained != direct)
        gid = None if conflict else chained if chained is not None else direct
        geometry_rule = "CONFLICT_DO_NOT_ASSIGN" if conflict else "EC_IDENTITY_TO_HISTORICAL_HIERARCHY" if chained else "DIRECT_UNIQUE_HISTORICAL_HIERARCHY" if direct else "NO_UNIQUE_HISTORICAL_LINK"
        h = by_geo.get(gid)
        pi = parent_index[(name_key(r["district"]), ordinal_key(r["subcounty"], "subcounty"))]
        parent_code = str(parents.iloc[pi[0]].ubos_subcounty_code) if len(pi) == 1 else ""
        inside = int(parents.geometry.iloc[pi[0]].covers(shapely.Point(h["ref_lon"], h["ref_lat"]))) if h and len(pi) == 1 else None
        query_village = ordinal_key(r["village"])
        level_warning = int(bool(re.search(r"\b(WARD|PARISH|SUBCOUNTY)\b", name_key(r["village"]))) or query_village == ordinal_key(r["parish"]))
        candidate_count = 0
        for hh in hist_by_district[name_key(r["district"])]:
            same_name = ordinal_key(hh["village"]) == query_village
            same_sc = ordinal_key(hh["subcounty"], "subcounty") == ordinal_key(r["subcounty"], "subcounty")
            similarity = SequenceMatcher(None, query_village, ordinal_key(hh["village"])).ratio()
            if not (same_name or (same_sc and similarity >= 0.84)): continue
            candidate_count += 1
            cid = int(hh["geo_id"])
            candidates.append(dict(reference_row_id=r["source_row_id"], candidate_geo_id=cid,
                                   candidate_village=hh["village"], candidate_parish=hh["parish"], candidate_subcounty=hh["subcounty"], candidate_district=hh["district"],
                                   full_hierarchy_agrees=int(coverage_key(hh) == coverage_key(r)), same_name=int(same_name), same_subcounty=int(same_sc), name_similarity=similarity,
                                   point_in_named_parent=int(parents.geometry.iloc[pi[0]].covers(shapely.Point(hh["ref_lon"], hh["ref_lat"]))) if len(pi) == 1 else None,
                                   retained_hist_reference=int(gid == cid), current_boundary_certified=0, candidate_status="HISTORICAL_REFERENCE_NOT_CURRENT_IDENTITY"))
        registry.append(dict(reference_row_id=r["source_row_id"], reference_group=r["source_id"], original100_flag=int(r["source_id"] == "PROJECT_FVL" and r["original100_frame_selected"] == "1"),
                             phase1_uid=r["phase1_uid"], district=r["district"], subcounty=r["subcounty"], parish=r["parish"], village=r["village"],
                             ec_lc_uid=ec_uid, identity_rule=identity_rule, historical_geo_id=gid, geometry_rule=geometry_rule,
                             historical_lon=h["ref_lon"] if h else None, historical_lat=h["ref_lat"] if h else None,
                             ubos2024_parent_code=parent_code, point_in_named_parent=inside, possible_level_error=level_warning,
                             historical_candidate_rows=candidate_count, source_file=r["source_file"], source_location=r["source_location"],
                             mentor_status="NOT_ASSESSED", current_boundary_certified=0, rct_geographic_release=0,
                             review_decision="", review_evidence=""))
    assert len(registry) == 258 and sum(r["original100_flag"] for r in registry) == 100
    osm_rows, osm_candidates = [], []
    osm_file = raw / "milestone5/osm_settlement_points.json"
    if osm_file.exists():
        osm_doc = json.loads(osm_file.read_text(encoding="utf-8"))
        assert not osm_doc.get("remark"), "Incomplete Overpass response cannot be treated as complete data"
        for e in osm_doc.get("elements", []):
            assert e["type"] == "node" and "lat" in e and "lon" in e
            tags = e.get("tags", {})
            osm_rows.append(dict(osm_element_id="node/" + str(e["id"]), place_type=tags.get("place", ""), place_name=tags.get("name", ""), alt_names=tags.get("alt_name", ""),
                                 lon=e["lon"], lat=e["lat"], source_tag=tags.get("source", ""), snapshot_utc=osm_doc.get("osm3s", {}).get("timestamp_osm_base", ""),
                                 role="SUPPLEMENTARY_SETTLEMENT_NOT_OFFICIAL_LC_GEOMETRY", current_boundary_certified=0))
        for r in registry:
            pi = parent_index[(name_key(r["district"]), ordinal_key(r["subcounty"], "subcounty"))]
            query = ordinal_key(r["village"])
            for e in osm_rows:
                alternatives = [e["place_name"], *e["alt_names"].split(";")]
                if not query or query not in {ordinal_key(n) for n in alternatives if n.strip()}: continue
                osm_candidates.append(dict(reference_row_id=r["reference_row_id"], osm_element_id=e["osm_element_id"], place_name=e["place_name"], place_type=e["place_type"], lon=e["lon"], lat=e["lat"],
                                           point_in_named_parent=int(parents.geometry.iloc[pi[0]].covers(shapely.Point(e["lon"], e["lat"]))) if len(pi) == 1 else None,
                                           candidate_status="NAME_REVIEW_ONLY_NO_ACCEPTED_LC_OR_POLYGON_LINK", current_boundary_certified=0))
    # National supplementary names widen the lookup frame beyond study borders.
    # Exact local differences are exposed; the primary EC extraction wins.
    gaz = read_csv(raw / "milestone5/gazetteer_uganda-locations-full.csv")
    assert len(gaz) == 71230 and len({r["id"] for r in gaz}) == len(gaz)
    primary_exact = defaultdict(list)
    for r in primary: primary_exact[hierarchy_key(r)].append(r)
    gaz_counts = Counter(hierarchy_key(r) for r in gaz)
    area_gaz, gaz_audit = [], []
    for r in gaz:
        matches = primary_exact[hierarchy_key(r)]
        uid = matches[0]["phase2_lc_uid"] if len(matches) == 1 and gaz_counts[hierarchy_key(r)] == 1 else ""
        area_gaz.append(dict(supplementary_row_id="EC_COPY_2022_" + r["id"].zfill(6), district=r["district"], county=r["county"], subcounty=r["subcounty"], parish=r["parish"], village=r["village"],
                             matched_study_lc_uid=uid, duplicate_hierarchy_rows=gaz_counts[hierarchy_key(r)], source_vintage="EC July 2022; supplementary transcription, not independent authority",
                             source_declared_confidence=r["confidence"], current_boundary_certified=0))
        if name_key(r["district"]) in DISTRICTS and not uid:
            gaz_audit.append(dict(source_row_id="EC_COPY_2022_" + r["id"].zfill(6), district=r["district"], subcounty=r["subcounty"], parish=r["parish"], village=r["village"],
                                  issue="Supplementary copy not uniquely identical to primary EC hierarchy", action="Primary project EC extraction retained; no automatic name replacement"))
    assert len([r for r in gaz if name_key(r["district"]) in DISTRICTS]) == 1483 and len(gaz_audit) == 3
    # Mapping area includes every study historical feature plus an unclipped
    # 5km border buffer. This is a diagnostic extent, not the neighbor rule.
    h_utm = hist.to_crs(32736)
    study = h_utm.loc[hist.study_district != ""].geometry.union_all()
    mask = h_utm.geometry.intersects(study.buffer(5000))
    area = hist.loc[mask].copy()
    area["source_id"] = "NPA_UBOS2011_MAP2016"
    area["current_boundary_certified"] = 0
    package = out / "gis/phase2_village_mapping_package.gpkg"
    # GDAL replaces named layers; no unrelated layer/file is recursively removed.
    area.to_file(package, layer="historical_area_polygons", driver="GPKG", mode="w")
    parents.to_file(package, layer="ubos2024_subcounty_context", driver="GPKG", mode="w")
    parishes.to_file(package, layer="parish_context", driver="GPKG", mode="w")
    partner_path = raw / "milestone5/rtv_partner_villages.geojson"
    partner = gpd.read_file(partner_path)
    assert len(partner) == 740 and partner.crs.to_epsg() == 4326
    partner = partner.rename(columns={c:c.lower() for c in partner.columns})
    partner["source_invalid"] = (~partner.is_valid).astype(int)
    partner["geometry"] = partner.geometry.make_valid()
    assert partner.is_valid.all() and partner.geometry.geom_type.isin(["Polygon", "MultiPolygon"]).all()
    partner["geo_id"] = range(1, len(partner) + 1)
    partner["source_id"] = "RTV_PARTNER_UNDATED"
    partner["in_mapping_extent"] = partner.to_crs(32736).geometry.intersects(study.buffer(5000)).astype(int)
    partner["current_boundary_certified"] = 0
    partner.to_file(package, layer="partner_polygons_unverified", driver="GPKG", mode="w")
    partner_attrs = partner.drop(columns="geometry").to_dict("records")
    # Store minimal field sidecars for lossless Stata shape/attribute merges.
    for stem, frame in (("mapping_area_utm36s", area), ("partner_area_utm36s", partner), ("mapping_parent_utm36s", parents)):
        frame[["geo_id", "geometry"]].to_crs(32736).to_file(out / "gis" / (stem + ".shp"))
    mapped_points = [dict(reference_row_id=r["reference_row_id"], reference_group=r["reference_group"], original100_flag=r["original100_flag"], historical_geo_id=r["historical_geo_id"], district=r["district"], village=r["village"],
                          lon=r["historical_lon"], lat=r["historical_lat"], geometry_rule=r["geometry_rule"], current_boundary_certified=0) for r in registry if r["historical_geo_id"] is not None]
    points = gpd.GeoDataFrame(mapped_points, geometry=gpd.points_from_xy([r["lon"] for r in mapped_points], [r["lat"] for r in mapped_points]), crs=4326)
    utm_points = points.to_crs(32736)
    for i, r in enumerate(mapped_points):
        r["map_x_m"], r["map_y_m"] = float(utm_points.geometry.iloc[i].x), float(utm_points.geometry.iloc[i].y)
    points.to_file(package, layer="project_historical_reference_points", driver="GPKG", mode="w")
    if osm_rows:
        osm_geo = gpd.GeoDataFrame(osm_rows, geometry=gpd.points_from_xy([r["lon"] for r in osm_rows], [r["lat"] for r in osm_rows]), crs=4326)
        osm_geo.to_file(package, layer="osm_settlement_points_unverified", driver="GPKG", mode="w")
    # Six historical scenarios for every reference; absent anchor counts stay
    # missing. Repeated frame/survey references are never counted as new LCs.
    rules = json.loads((out / "phase2_neighbor_manifest.json").read_text(encoding="utf-8"))["rules"]
    shapes = h_utm.geometry.to_numpy()
    inner = gpd.GeoSeries(gpd.points_from_xy(hist.ref_lon, hist.ref_lat), crs=4326).to_crs(32736).to_numpy()
    lookup = dict(zip(hist.geo_id.astype(int), range(len(hist))))
    tree = shapely.STRtree(shapes)
    geo_ec = defaultdict(list)
    for r in lc_geometry:
        if r["historical_geo_id"] is not None: geo_ec[r["historical_geo_id"]].append(r["phase2_lc_uid"])
    edges, sensitivity = [], []
    for r in registry:
        local = []
        if r["historical_geo_id"] is not None:
            ai = lookup[r["historical_geo_id"]]
            for ci in sorted(map(int, tree.query(shapes[ai], predicate="dwithin", distance=5000))):
                c = hist.iloc[ci]; cid = int(c.geo_id)
                if ci == ai: continue
                contact = bool(shapely.touches(shapes[ai], shapes[ci]))
                distance = float(shapely.distance(inner[ai], inner[ci]))
                border = float(shapely.length(shapely.intersection(shapely.boundary(shapes[ai]), shapely.boundary(shapes[ci])))) if contact else 0.0
                e = dict(reference_row_id=r["reference_row_id"], reference_group=r["reference_group"], original100_flag=r["original100_flag"], anchor_geo_id=r["historical_geo_id"], candidate_geo_id=cid,
                         candidate_district=str(c.district), candidate_subcounty=str(c.subcounty), candidate_parish=str(c.parish), candidate_village=str(c.village),
                         candidate_ec_uid=geo_ec[cid][0] if len(geo_ec[cid]) == 1 else "", candidate_identity_rows=len(geo_ec[cid]),
                         polygon_distance_m=float(shapely.distance(shapes[ai], shapes[ci])), point_distance_m=distance, queen_exact=int(contact), rook_exact=int(contact and border > 0),
                         same_district=int(name_key(c.district) == name_key(r["district"])), source_quality_flag=int(c.same_geom_rows > 1 or c.same_hierarchy_rows > 1 or c.nonsettlement_name_flag or c.source_invalid), current_boundary_certified=0, rct_geographic_release=0)
                e.update({f"point_le_{k}m": int(distance <= k) for k in (1000, 2000, 3000, 5000)})
                local.append(e); edges.append(e)
        for rule in rules:
            selected = [e for e in local if e[rule["edge_flag"]]]
            sensitivity.append(dict(reference_row_id=r["reference_row_id"], reference_group=r["reference_group"], original100_flag=r["original100_flag"], district=r["district"], village=r["village"],
                                    historical_geo_id=r["historical_geo_id"], scenario=rule["scenario"], historical_neighbor_rows=len(selected) if r["historical_geo_id"] is not None else None,
                                    identity_linked_neighbor_rows=sum(bool(e["candidate_ec_uid"]) for e in selected) if r["historical_geo_id"] is not None else None,
                                    current_eligible_neighbors="UNKNOWN", current_boundary_certified=0, rct_geographic_release=0))
    source_audit = []
    for layer in json.loads((raw / "milestone5/arcgis_village_layers.json").read_text(encoding="utf-8")):
        status = "No confirmed study-coverage/current-boundary evidence"
        if "2009" in layer["name"]: status = "Older point-source copy; not village polygons"
        elif "2011" in layer["name"]: status = "44,034 historical polygon copy; not a new current LC census"
        elif layer["item_id"] == "4841ed598eda4e33b8197cf4b133ecd9": status = "740 partner polygons; no study-district rows; neighboring-area context only"
        elif "Banana" in layer["item_title"]: status = "Sample locations; not administrative village coordinates"
        source_audit.append(dict(source_id=layer["item_id"] + "_" + str(layer["layer_id"]), title=layer["item_title"], layer_name=layer["name"], source_url=layer["url"], geometry_type=layer["geometry_type"], feature_rows=layer["feature_count"], use_status=status,
                                 vintage_note=html.unescape(re.sub(r"<[^>]+>", " ", layer["copyright"])).strip() or "Boundary date unverified; upload date not used as vintage",
                                 license_note=layer.get("license_info") or "No reusable-geometry license established; private source archive only"))
    source_audit += [dict(source_id=name, title=name, layer_name="", source_url=r["url"], geometry_type="SOURCE_METADATA_OR_ACCESS_FAILURE", feature_rows=None,
                          use_status=r["status"] + ": " + r.get("error", "Public source archived"), vintage_note="Acquisition date does not establish data vintage", license_note="Metadata availability does not establish geometry rights")
                     for name, r in receipt.items() if name in ("nbrb_catalog.json", "wasmis_wfs.xml", "npa_catalog.html", "ubos_census_builder.html", "psu_mapping_files_2018.zip", "nes_server.json", "gazetteer_uganda-locations-full.csv")]
    for name in ("osm_settlement_points.json", "osm_lc_boundary_counts.json"):
        r = receipt[name]
        source_audit.append(dict(source_id=name, title="OpenStreetMap supplementary geographic search", layer_name="Settlement points" if "points" in name else "Village-level boundary count",
                                 source_url=r["url"], geometry_type="POINT_REFERENCES" if "points" in name else "BOUNDARY_COUNT_METADATA", feature_rows=len(osm_rows) if "points" in name else None,
                                 use_status=r["status"] + "; not official LC certification", vintage_note="Snapshot timestamp is not legal boundary date", license_note="OpenStreetMap contributors, ODbL; attribution and reuse conditions apply"))
    summary = []
    for group, rows in [("ALL_EC_2022_STUDY_LCS", lc_geometry), ("PROJECT_PHASE1_REFERENCES", [r for r in registry if r["reference_group"] == "PROJECT_PHASE1"]),
                        ("ORIGINAL_PROJECT_FRAME", [r for r in registry if r["reference_group"] == "PROJECT_FVL"]), ("ORIGINAL_RANDOM100_FRAME", [r for r in registry if r["original100_flag"]])]:
        for district in (*DISTRICTS, "TOTAL"):
            subset = rows if district == "TOTAL" else [r for r in rows if name_key(r["district"]) == district]
            summary.append(dict(reference_group=group, district=district, reference_rows=len(subset), ec_identity_links=sum(bool(r.get("ec_lc_uid", r.get("phase2_lc_uid"))) for r in subset),
                                historical_geometry_links=sum(r["historical_geo_id"] is not None for r in subset), missing_geometry_rows=sum(r["historical_geo_id"] is None for r in subset), current_certified_boundaries=0,
                                note="Source/reference rows, not approved mentors; historical geometry is not current LC certification"))
    rows_by_stem = {"phase2_village_linkage_register": registry, "phase2_lc_geometry_coverage": lc_geometry,
                    "phase2_linkage_candidates": candidates, "phase2_area_gazetteer": area_gaz, "phase2_gazetteer_discrepancies": gaz_audit,
                    "phase2_mapping_area_attributes": area.drop(columns="geometry").to_dict("records"), "phase2_partner_area_attributes": partner_attrs,
                    "phase2_mapping_parent_attributes": parents.drop(columns="geometry").to_dict("records"),
                    "phase2_project_map_points": mapped_points, "phase2_project_geo_neighbors": edges, "phase2_project_geo_sensitivity": sensitivity,
                    "phase2_boundary_source_audit": source_audit, "phase2_coverage_summary": summary}
    rows_by_stem.update(phase2_osm_settlement_reference=osm_rows, phase2_osm_name_candidates=osm_candidates)
    empty_fields = {"phase2_osm_settlement_reference": ["osm_element_id", "place_type", "place_name", "alt_names", "lon", "lat", "source_tag", "snapshot_utc", "role", "current_boundary_certified"],
                    "phase2_osm_name_candidates": ["reference_row_id", "osm_element_id", "place_name", "place_type", "lon", "lat", "point_in_named_parent", "candidate_status", "current_boundary_certified"]}
    for stem, rows in rows_by_stem.items(): write_csv(out / (stem + ".csv"), rows, empty_fields.get(stem) if not rows else None)
    write_json(out / "coverage_workbook_inputs.json", {name: dict(fields=list(rows[0]), rows=rows) for name, rows in [("VillageCoverage", summary), ("CoverageReview", registry), ("BoundarySources", source_audit), ("SourceDiscrepancies", gaz_audit)]})
    assert same_pins(root, protected, protected_inputs(root)), "Protected input changed"
    write_json(path, dict(milestone="5 Public-source coverage search and village mapping reference", status="BEST_AVAILABLE_REFERENCE_COMPLETE_CURRENT_BOUNDARIES_INCOMPLETE", input_sha256=pins,
                         protected_inputs_before_after=protected, accepted_workbook_sheets=before, csv_rows={stem: len(rows) for stem, rows in rows_by_stem.items()},
                         mapping_crs="EPSG:32736", storage_crs="EPSG:4326", mapping_buffer_m=5000, current_certified_lc_boundaries=0,
                         mentor_selection_performed=False, randomization_performed=False, rct_geographic_release=0,
                         runtime={p.split("==")[0]: importlib.metadata.version(p.split("==")[0]) for p in GIS_PACKAGES}, built_utc=datetime.now(timezone.utc).isoformat()))
    print(json.dumps({"coverage_summary": summary, "outputs": {stem: len(rows) for stem, rows in rows_by_stem.items()}, "partner_polygons_in_extent": int(partner.in_mapping_extent.sum())}), flush=True)


def verify_coverage(root):
    import pandas as pd
    import numpy as np
    import geopandas as gpd
    import shapely
    _, out = folders(root)
    path = out / "phase2_coverage_manifest.json"
    m = json.loads(path.read_text(encoding="utf-8"))
    for p, h in m["input_sha256"].items(): assert sha(saved_path(root, p)) == h, p
    assert same_pins(root, m["protected_inputs_before_after"], protected_inputs(root)), "Protected Phase1/M1 input changed"
    products = []
    for stem, n in m["csv_rows"].items():
        source = pd.read_csv(out / (stem + ".csv"), dtype=str, keep_default_na=False)
        data = pd.read_stata(out / (stem + ".dta"), convert_categoricals=False)
        assert len(data) == len(source) == n and set(data.columns) == set(source.columns), stem
        # Native import preserves source order, and all columns are checked.
        for c in source:
            if pd.api.types.is_numeric_dtype(data[c]):
                assert np.allclose(pd.to_numeric(source[c].replace("", np.nan)), data[c], rtol=1e-12, atol=1e-7, equal_nan=True), (stem, c)
            else: assert source[c].equals(data[c].fillna("").astype(str)), (stem, c)
        assert not any(c.lower() in ("name", "phone", "telephone", "uuid", "submission_key", "respondent_name", "chairperson_name", "mentor_selected", "assigned_wave", "treatment") for c in data.columns), stem
        products += [out / (stem + ext) for ext in (".csv", ".dta")]
    for stem, attr in (("mapping_area_utm36s", "phase2_mapping_area_attributes"), ("partner_area_utm36s", "phase2_partner_area_attributes"), ("mapping_parent_utm36s", "phase2_mapping_parent_attributes")):
        native = pd.read_stata(out / "gis" / (stem + ".dta"), convert_categoricals=False)
        shp = pd.read_stata(out / "gis" / (stem + "_shp.dta"), convert_categoricals=False)
        assert len(native) == m["csv_rows"][attr] and native._ID.is_unique and native.geo_id.is_unique
        assert shp._ID.isin(native._ID).all() and set(shp._ID) == set(native._ID)
        assert shp._X.isna().equals(shp._Y.isna()) and np.isfinite(shp.loc[shp._X.notna(), ["_X", "_Y"]]).all().all()
        original = gpd.read_file(out / "gis" / (stem + ".shp"))
        assert original.crs.to_epsg() == 32736
        vertices = shapely.get_coordinates(original.geometry)
        native_vertices = shp.loc[shp._X.notna(), ["_X", "_Y"]].to_numpy()
        assert vertices.shape == native_vertices.shape and np.allclose(vertices, native_vertices, rtol=0, atol=1e-6), f"Native coordinates differ from source shapefile: {stem}"
        attributes = pd.read_csv(out / (attr + ".csv"), dtype=str, keep_default_na=False)
        attributes["geo_id"] = pd.to_numeric(attributes.geo_id)
        linked = native.set_index("geo_id").loc[attributes.geo_id].reset_index()
        for c in attributes:
            if pd.api.types.is_numeric_dtype(linked[c]):
                assert np.allclose(pd.to_numeric(attributes[c].replace("", np.nan)), linked[c], rtol=1e-12, atol=1e-7, equal_nan=True), (stem, c)
            else: assert attributes[c].astype(str).equals(linked[c].fillna("").astype(str)), (stem, c)
        products += [out / "gis" / (stem + ext) for ext in (".shp", ".shx", ".dbf", ".prj", ".cpg", ".dta", "_shp.dta")]
    package = out / "gis/phase2_village_mapping_package.gpkg"
    expected_layers = {"historical_area_polygons", "ubos2024_subcounty_context", "parish_context", "partner_polygons_unverified", "project_historical_reference_points"}
    if m["csv_rows"]["phase2_osm_settlement_reference"]: expected_layers.add("osm_settlement_points_unverified")
    assert set(gpd.list_layers(package).name) == expected_layers
    for layer in expected_layers:
        frame = gpd.read_file(package, layer=layer)
        assert frame.crs.to_epsg() == 4326 and frame.is_valid.all() and not frame.is_empty.any(), layer
    products.append(package)
    workbook = root / "4 Deliverables and Presentations/Phase2_Administrative_Village_Census.xlsx"
    now = workbook_cells(workbook)
    assert all(now[n] == s for n, s in m["accepted_workbook_sheets"].items()), "An accepted worksheet changed"
    assert set(now) == set(m["accepted_workbook_sheets"]) | {"VillageCoverage", "CoverageReview", "BoundarySources", "SourceDiscrepancies"}
    # Independently compare exported worksheet cells with the Stata-validated
    # inputs. Only reviewer evidence/decision text is editable, not source data.
    inputs = json.loads((out / "coverage_workbook_inputs.json").read_text(encoding="utf-8"))
    ns = {"s": "http://schemas.openxmlformats.org/spreadsheetml/2006/main"}
    verified_cells = 0
    with zipfile.ZipFile(workbook) as z:
        strings = ["".join(n.itertext()) for n in ET.fromstring(z.read("xl/sharedStrings.xml"))] if "xl/sharedStrings.xml" in z.namelist() else []
        rels = {n.get("Id"): n.get("Target") for n in ET.fromstring(z.read("xl/_rels/workbook.xml.rels"))}
        for sheet in ET.fromstring(z.read("xl/workbook.xml")).find("s:sheets", ns):
            name = sheet.get("name")
            if name not in inputs: continue
            target = rels[sheet.get("{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id")].lstrip("/")
            if not target.startswith("xl/"): target = "xl/" + target
            cells = {}
            for c in ET.fromstring(z.read(target)).findall(".//s:sheetData/s:row/s:c", ns):
                assert c.find("s:f", ns) is None, f"Unexpected formula in review/source worksheet: {name}/{c.get('r')}"
                v, t = c.find("s:v", ns), c.get("t", "n")
                value = v.text if v is not None else ""
                if t == "s": value = strings[int(value)]
                elif t == "inlineStr": value = "".join(c.find("s:is", ns).itertext())
                cells[c.get("r")] = value
            fields = inputs[name]["fields"]
            for i, row in enumerate([dict(zip(fields, fields)), *inputs[name]["rows"]], 1):
                for j, field in enumerate(fields):
                    column, k = "", j + 1
                    while k: k, remainder = divmod(k - 1, 26); column = chr(65 + remainder) + column
                    actual, expected = cells.get(f"{column}{i}", ""), row[field]
                    if i > 1 and field in ("review_decision", "review_evidence"): continue
                    if isinstance(expected, (int, float)):
                        assert actual != "" and np.isclose(float(actual), expected, rtol=1e-12, atol=1e-7), (name, i, field)
                    else: assert actual == str(expected if expected is not None else ""), (name, i, field)
                    verified_cells += 1
    products += [out / f"phase2_village_mapping_{district}.png" for district in (*DISTRICTS, "ALL")]
    assert all(p.is_file() for p in products), "Missing native/geographic/map output"
    m.update(stata_import_validation_passed=True, stata_execution_route="stata_run_selection MCP", accepted_worksheet_cells_unchanged=True,
             new_worksheet_source_cells_verified=verified_cells, native_shape_vertices_verified=True,
             product_sha256={p.relative_to(root).as_posix(): sha(p) for p in products}, review_workbook_sha256=sha(workbook),
             code_sha256={p.name: sha(p) for p in Path(__file__).parent.glob("6 Phase2_Geospatial*.*") if p.is_file()})
    write_json(path, m)
    summary = read_csv(out / "phase2_coverage_summary.csv")
    totals = {r["reference_group"]: r for r in summary if r["district"] == "TOTAL"}
    pages = json.loads((folders(root)[0] / "milestone5/arcgis_search_pages.json").read_text(encoding="utf-8"))
    (out / "README_MILESTONE5.txt").write_text(f"""MILESTONE 5: VILLAGE LINKAGE AND AVAILABLE-GEOGRAPHY PACKAGE

Reproduce only through stata_run_selection MCP:
do "1 Code/6 Phase2_Geospatial_Frame.do" "<Dropbox project root>" coverage
Stata owns all native imports, key/count/coordinate checks, linked polygon DTA
creation and diagnostic maps. Pinned Python handles HTTPS, formats and geometry.

COMPLETED COVERAGE (not a claim of complete current LC boundaries)
EC 2022 study frame: {totals['ALL_EC_2022_STUDY_LCS']['reference_rows']} LC units;
historical geometry links: {totals['ALL_EC_2022_STUDY_LCS']['historical_geometry_links']}.
Original randomized 100 frame: {totals['ORIGINAL_RANDOM100_FRAME']['ec_identity_links']} dated EC identity links,
{totals['ORIGINAL_RANDOM100_FRAME']['historical_geometry_links']} historical mapping references.
Original complete project list: 128 geographic source rows.
Phase1 geographic references: 130 rows; {totals['PROJECT_PHASE1_REFERENCES']['ec_identity_links']} dated EC identity links,
{totals['PROJECT_PHASE1_REFERENCES']['historical_geometry_links']} historical mapping references.
These source groups overlap. They must not be summed as unique study LCs,
training participants or assessed mentors. All 258 source rows are retained.

PUBLIC SOURCE SEARCH
{len(pages)} complete paginated responses across eight targeted ArcGIS queries;
172 unique items, 16 village/settlement layers inspected. Catalogs of UBOS,
NBRB, NPA and WASMIS rechecked. Raw HTTPS files and failure receipts live in
3 Data/1 Raw/Secondary data/Phase2_Geospatial_Sources/milestone5.
The 71,230-row supplementary gazetteer is EC July 2022, not a June2026 census.
It has three local name discrepancies: two Rubumba rows lose I/II and one
Rwengando Trading Centre name is truncated. The project primary EC extraction
remains controlling. Repeated publisher copies are not independent evidence.
The 740 partner polygons have unverified vintage/rights and no rows named in
the study districts. Only potential neighboring-area context is retained.
OSM settlement and LC-boundary queries were attempted with their raw query
URLs preserved. Empty native OSM tables mean an unavailable query, not that
the area contains no settlements or administrative boundaries. A failed public
query cannot establish absence or current coverage.
No failed authentication, revoked certificate, traffic control or license
restriction is bypassed. No reusable geometry license is inferred from access.

LINK RULES
Prior M1/M3 documentary links are retained. Unique full hierarchies additionally
allow terminal Roman/Arabic ordinal equivalence, attached terminal digit spacing,
a terminal CELL descriptor and the established SC/TC/DIV shorthand rule.
A/B, I/II and different parents remain distinct. Twelve previous parent-conflict
proposals are not automatically accepted. Direct project-to-historical hierarchy
links are usable as dated mapping references without implying a current LC ID.
Conflicting chained/direct geometry links are held. Similar names are review
candidates only; distance does not certify identity. Historical points are
derived polygon interior points, not chairperson/interview GPS or settlement centres.

FILES AND MAPS
gis/phase2_village_mapping_package.gpkg has five explicitly dated/status-labeled
layers: historical village polygons across the study area plus a 5km border
buffer, 2024 subcounty context, contextual parishes, unverified partner polygons,
and project historical reference points. A sixth, explicitly unverified OSM
settlement-point layer is included only if the public query yields usable points.
Three EPSG32736 shapefile packages (historical area, partner area and subcounty
context) have native Stata attribute/coordinate DTA pairs. Numeric geo_id is
source-specific. OSM names are review candidates, not certified LC links or
boundaries; an OSM settlement point does not fill a missing polygon reference.
The national gazetteer, register, candidate reviews, source audit, six scenario
rows per project reference and candidate edges are imported as native DTA.
Four Stata PNG maps are diagnostics. The 5km extent is not approved eligibility.
Missing anchor geometry yields missing scenario counts, never zero. Overlapping
frame and survey rows can point at one geometry; do not count them as distinct LCs.

REMAINING LIMITS
Current certified LC boundaries: zero. Public files do not settle all village
identities, splits, aliases or boundaries. No new village coordinate, polygon,
training status, mentor selection, eligible-neighbor roster, ownership, wave or
treatment is fabricated. No final mentor roster exists yet. Assessment and
current locally confirmed LC/neighbor identities are still needed. Where no
current polygons are available, the Inception Report permits locally verified
neighbors; that route must be separately documented, not inferred from these maps.
All Phase1 data/reports, scoring, Master and randomization and M1-M4 products
are hash-checked and unchanged. The 22 accepted workbook tabs remain unchanged;
four coverage/source review tabs extend the same workbook. Geometric display
and native/file checks do not constitute field certification or assignment release.
""", encoding="utf-8")
    print("Milestone 5 native columns/shapes, source pins and 22 accepted workbook tabs verified. Current LC geometry remains incomplete.", flush=True)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--root", type=Path, default=DEFAULT_ROOT)
    p.add_argument("--acquire", action="store_true")
    p.add_argument("--build", action="store_true")
    p.add_argument("--reconcile", action="store_true")
    p.add_argument("--neighbors", action="store_true")
    p.add_argument("--coverage", action="store_true")
    p.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    p.add_argument("--review-workbook", action="store_true")
    p.add_argument("--inspect-workbook", action="store_true")
    p.add_argument("--verify", action="store_true")
    args = p.parse_args()
    if sum((args.acquire,args.build,args.reconcile,args.neighbors,args.coverage)) > 1:
        p.error("Choose one phase mode; source acquisition and builds are separate steps")
    import importlib.metadata
    pinned = all(importlib.util.find_spec(p.split("==")[0]) and
                 importlib.metadata.version(p.split("==")[0]) == p.split("==")[1] for p in GIS_PACKAGES)
    if (args.build or (args.coverage and args.verify) or ((args.reconcile or args.neighbors or args.coverage) and not (args.review_workbook or args.inspect_workbook or args.verify))) and not args.worker and not pinned:
        r = subprocess.run(worker_args(), capture_output=True, text=True,
                           creationflags=subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0)
        _, out = folders(args.root)
        (out / ("phase2_coverage_final_verification.log" if args.coverage and args.verify else "phase2_coverage_conversion.log" if args.coverage else "phase2_neighbor_conversion.log" if args.neighbors else "phase2_reconciliation_conversion.log" if args.reconcile else "phase2_gis_conversion.log")).write_text(r.stdout + r.stderr, encoding="utf-8")
        print(r.stdout + r.stderr, flush=True)
        r.check_returncode()
        return
    if args.acquire:
        acquire(args.root)
    if args.build:
        build(args.root)
    if args.reconcile and not (args.review_workbook or args.inspect_workbook or args.verify):
        reconcile(args.root)
    if args.neighbors and not (args.review_workbook or args.inspect_workbook or args.verify):
        neighbors(args.root)
    if args.coverage and not (args.review_workbook or args.inspect_workbook or args.verify):
        acquire_coverage(args.root)
        coverage(args.root)
    if args.review_workbook or args.inspect_workbook:
        review_workbook(args.root, args.inspect_workbook, args.reconcile, args.neighbors, args.coverage)
    if args.verify:
        if args.coverage: verify_coverage(args.root)
        elif args.neighbors: verify_neighbors(args.root)
        elif args.reconcile: verify_reconciliation(args.root)
        else: verify_outputs(args.root)


if __name__ == "__main__":
    main()
