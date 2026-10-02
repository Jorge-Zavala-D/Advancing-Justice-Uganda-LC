"""Build the Phase 2 administrative LC reference census, not an RCT allocation.

Official source snapshots and outputs stay in Dropbox. Phase 1 files are read
only. Run with the bundled Codex Python runtime. --download retrieves the two
EC sources; --inspect reports source structure without changing any input.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import re
import subprocess
import time
import urllib.request
from datetime import date
from pathlib import Path
from collections import Counter, defaultdict
from difflib import SequenceMatcher

from pypdf import PdfReader
import pdfplumber
import openpyxl

DEFAULT_ROOT = Path(r"C:\Users\jzava\Dropbox (Personal)\Research & Consulting\1 Research\Legatum Uganda Advancing Justice")
SOURCE_URLS = {
    "ec_admin_2022.pdf": "https://www.ec.or.ug/sites/default/files/statistics/ADMINISTRATIVE%20UNITS%20IN%20UGANDA_JULY%202022.pdf",
    "ec_village_electoral_split_2025.pdf": "https://www.ec.or.ug/sites/default/files/press/Split%20by%20village%20Local%20Goverment%20Electoral%20Areas%20for%20display_0.pdf",
}
SOURCE_SHA256 = {
    "ec_admin_2022.pdf": "fa70833b077402f69cdba96075d13a032fe76ff045d4ee929bee491848cb683d",
    "ec_village_electoral_split_2025.pdf": "3b43920da9e605a9743a96cc6eece9b81eb865ae8ce3acf548d472e90fb087fe",
}
CONTEXT_URLS = {
    "ec_administrative_catalog.html": "https://www.ec.or.ug/admin-units",
    "ec_electoral_area_display_2025.html": "https://www.ec.or.ug/node/737",
    "bushenyi_gcic_facts_2025.html": "https://media.gcic.go.ug/key-development-facts-and-sector-updates-for-bushenyi-district/",
    "rubirizi_administrative_structure.html": "https://rubirizi.go.ug/node/9",
}
DISTRICTS = {"BUSHENYI", "RUBIRIZI", "SHEEMA"}


class PrefixComplete(Exception):
    pass


def page_prefix(page, limit: int = 350) -> str:
    chunks = []
    length = 0

    def collect(text, _cm, _tm, _font, _size):
        nonlocal length
        chunks.append(text)
        length += len(text)
        if length >= limit:
            raise PrefixComplete()

    try:
        page.extract_text(visitor_text=collect)
    except PrefixComplete:
        pass
    return "".join(chunks)


def locate_pages(root: Path) -> dict[str, list[int]]:
    folder = root / "3 Data/1 Raw/Secondary data/Phase2_Administrative_Sources"
    found = {}
    for name in SOURCE_URLS:
        reader = PdfReader(folder / name)
        indices = []
        started = time.time()
        for index, page in enumerate(reader.pages):
            prefix = page_prefix(page)
            match = re.search(r"DISTRICT:\s*([A-Z][A-Z -]*?)(\d{2,3})\s", prefix.upper())
            if match and match.group(1).strip() in DISTRICTS:
                indices.append(index)
                if not indices[:-1] or index != indices[-2] + 1:
                    print(f"{name}: starts {match.group(1).strip()} at PDF page {index + 1}", flush=True)
            if (index + 1) % 500 == 0:
                print(f"{name}: inspected {index + 1}/{len(reader.pages)} page headers", flush=True)
        found[name] = indices
        print(f"{name}: {len(indices)} study-district pages; {time.time()-started:.1f}s", flush=True)
        for index in indices[:1]:
            print(f"First selected page {index+1}:\n{reader.pages[index].extract_text()[:2200]}", flush=True)
    output = root / "3 Data/2 Working/Phase2_Administrative_Frame"
    output.mkdir(parents=True, exist_ok=True)
    (output / "source_page_index.json").write_text(json.dumps(found, indent=2), encoding="utf-8")
    return found


def digest(path: Path) -> str:
    with path.open("rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()


def download_sources(root: Path) -> None:
    folder = root / "3 Data/1 Raw/Secondary data/Phase2_Administrative_Sources"
    folder.mkdir(parents=True, exist_ok=True)
    for name, url in SOURCE_URLS.items():
        target = folder / name
        if target.exists():
            if not target.read_bytes().startswith(b"%PDF-"):
                raise ValueError(f"Existing snapshot is not a PDF: {target}")
            assert digest(target) == SOURCE_SHA256[name], f"Official source changed: {name}; review before replacing snapshot"
            print(f"Existing snapshot: {name}; sha256={digest(target)}", flush=True)
            continue
        request = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (research data retrieval)"})
        payload = None
        for attempt in range(3):
            try:
                with urllib.request.urlopen(request, timeout=60) as response:
                    payload = response.read(100_000_001)
                if len(payload) > 100_000_000 or not payload.startswith(b"%PDF-"):
                    raise ValueError(f"Invalid official PDF response: {url}")
                break
            except Exception:
                if attempt == 2:
                    raise
                time.sleep(2)
        assert payload is not None
        target.write_bytes(payload)
        assert digest(target) == SOURCE_SHA256[name], f"Official source revision differs from audited snapshot: {name}"
        print(f"Downloaded {name}: {len(payload):,} bytes; sha256={digest(target)}", flush=True)


def inspect_sources(root: Path) -> None:
    folder = root / "3 Data/1 Raw/Secondary data/Phase2_Administrative_Sources"
    for name in SOURCE_URLS:
        reader = PdfReader(folder / name)
        print(f"\n{name}: {len(reader.pages)} pages", flush=True)
        print(reader.pages[0].extract_text()[:6000], flush=True)
        raw = reader.pages[0].get_contents().get_data()
        print(f"Raw stream has literal district header: {b'DISTRICT' in raw or b'District' in raw}", flush=True)


def clean(value: str) -> str:
    return re.sub(r"\s+", " ", value).strip()


def coded_name(value: str) -> tuple[str, str] | None:
    match = re.fullmatch(r"(\d{1,3})\s+(.+)", clean(value))
    return (match.group(1), match.group(2)) if match else None


def word_rows(page, lower: float, upper: float, breaks: tuple[float, ...]):
    words = [w for w in page.extract_words(x_tolerance=2, y_tolerance=2)
             if lower <= w["top"] < upper]
    groups: list[list[dict]] = []
    for word in sorted(words, key=lambda w: (w["top"], w["x0"])):
        if not groups or abs(word["top"] - groups[-1][0]["top"]) > 3:
            groups.append([word])
        else:
            groups[-1].append(word)
    for group in groups:
        cells = []
        for left, right in zip(breaks[:-1], breaks[1:]):
            cells.append(" ".join(w["text"] for w in sorted(group, key=lambda w: w["x0"])
                                  if left <= w["x0"] < right))
        if any(cells):
            yield round(group[0]["top"], 2), cells


def write_csv(path: Path, rows: list[dict]) -> None:
    if not rows:
        raise ValueError(f"Cannot write empty extraction: {path}")
    path.parent.mkdir(parents=True, exist_ok=True)
    fields = list(dict.fromkeys(key for row in rows for key in row))
    with path.open("w", encoding="utf-8-sig", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)


def extract_sheema_tables(root: Path) -> list[dict]:
    """Read legacy DOC table cells without saving or editing the document.

    Use native Word only for the capability absent from the bundled Python
    readers. Never attach to or quit an existing user Word process.
    """
    folder = root / "3 Data/1 Raw/Secondary data/Phase2_Administrative_Sources"
    output = folder / "sheema_2020_table_cells.json"
    if output.exists():
        return json.loads(output.read_text(encoding="utf-8"))
    source = root / "3 Data/1 Raw/Secondary data/Sheema Administrative units.doc"
    before_hash = digest(source)
    path_literal = str(source).replace("'", "''")
    command = r"""
$ErrorActionPreference = 'Stop'
$existingPids = @(Get-Process WINWORD -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Id)
$word = $null
$document = $null
try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $word.DisplayAlerts = 0
    if ($word.Documents.Count -ne 0) { throw 'Refusing an application with existing documents.' }
    $document = $word.Documents.Open('__SOURCE__', $false, $true, $false)
    if (-not $document.ReadOnly) { throw 'Source document did not open read-only.' }
    $rows = [System.Collections.Generic.List[object]]::new()
    $tableIndex = 0
    foreach ($table in $document.Tables) {
        $tableIndex++
        foreach ($cell in $table.Range.Cells) {
            $rows.Add([pscustomobject]@{table=$tableIndex; row=$cell.RowIndex; column=$cell.ColumnIndex; text=$cell.Range.Text.Trim([char]7,[char]13)})
        }
    }
    ConvertTo-Json -InputObject @($rows.ToArray()) -Depth 8 -Compress
} finally {
    if ($null -ne $document) { $document.Close(0) }
    if ($null -ne $word -and $word.Documents.Count -eq 0) {
        $currentPids = @(Get-Process WINWORD -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Id)
        if (@($currentPids | Where-Object { $_ -notin $existingPids }).Count -gt 0) {
            $noSave = 0
            $word.Quit([ref]$noSave)
        }
    }
}
""".replace("__SOURCE__", path_literal)
    result = subprocess.run(["powershell", "-NoProfile", "-NonInteractive", "-Command", command],
                            capture_output=True, text=True, encoding="utf-8", timeout=60)
    if result.returncode:
        raise RuntimeError(f"Read-only Word extraction failed: {result.stderr}")
    if digest(source) != before_hash:
        raise ValueError("Read-only Word extraction changed the source DOC")
    rows = json.loads(result.stdout)
    assert isinstance(rows, list) and rows, "Legacy DOC returned no table cells"
    output.write_text(json.dumps(rows, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Sheema 2020 DOC: extracted {len(rows)} table cells; source hash unchanged", flush=True)
    return rows


def extract_ec_sources(root: Path) -> list[dict]:
    folder = root / "3 Data/1 Raw/Secondary data/Phase2_Administrative_Sources"
    output = root / "3 Data/2 Working/Phase2_Administrative_Frame"
    index_file = output / "source_page_index.json"
    pages = json.loads(index_file.read_text(encoding="utf-8")) if index_file.exists() else locate_pages(root)
    records = []
    for name in SOURCE_URLS:
        year = "2022" if "2022" in name else "2025"
        current_sc = current_parish = None
        last_district = last_county = None
        n_before = len(records)
        reader = PdfReader(folder / name)
        with pdfplumber.open(folder / name) as pdf:
            for page_index in pages[name]:
                page = pdf.pages[page_index]
                text = page.extract_text(x_tolerance=2, y_tolerance=2)
                district_match = re.search(r"DISTRICT:\s*(\d+)\s+([A-Z -]+)", text, re.I)
                county_match = re.search(r"CONSTITUENCY:\s*(\d+)\s+([^\n]+)", text, re.I)
                if not district_match or not county_match:
                    raise ValueError(f"Missing EC hierarchy: {name} page {page_index+1}")
                district_code, district = district_match.groups()
                county_code, county = county_match.groups()
                district, county = clean(district).upper(), clean(county).upper()
                assert district in DISTRICTS, (name, page_index, district)
                if (district, county) != (last_district, last_county):
                    current_sc = current_parish = None
                last_district, last_county = district, county
                if year == "2025":
                    # Metadata precedes the table. Electoral areas in the left
                    # body column are NOT administrative parishes or LC villages.
                    raw_text = reader.pages[page_index].extract_text()
                    sc_match = re.search(r"Subcounty/Town/Municipal Division:\s*(.+?)(\d{1,3})\s*\n", raw_text)
                    par_match = re.search(r"Parish:\s*(.+?)(\d{1,3})\s*\n", raw_text)
                    if not sc_match or not par_match:
                        raise ValueError(f"Missing 2025 page metadata: page {page_index+1}")
                    current_sc = (sc_match.group(2), clean(sc_match.group(1)))
                    current_parish = (par_match.group(2), clean(par_match.group(1)))
                    layout = (280, 800, (25, 310, 575))
                else:
                    layout = (130, 800, (35, 222, 375, 575))
                page_records = []
                for top, cells in word_rows(page, *layout):
                    row_text = clean(" ".join(cells))
                    if re.search(r"\bPage\s+\d+\s+of\s+\d+", row_text) or "TOTAL VILLAGES" in row_text:
                        continue
                    if year == "2022":
                        sc = coded_name(cells[0])
                        parish = coded_name(cells[1])
                        village = coded_name(cells[2])
                        if sc:
                            current_sc, current_parish = sc, None
                        if parish:
                            current_parish = parish
                    else:
                        village = coded_name(cells[1])
                    village_cell = cells[-1]
                    if village:
                        if current_sc is None or current_parish is None:
                            raise ValueError(f"Village without hierarchy: {name} page {page_index+1}: {cells}")
                        record = {
                            "source_id": f"EC_{year}", "source_file": name,
                            "source_page": page_index+1, "source_row_top": top,
                            "reference_date": "2022-07-19" if year == "2022" else "2025-01-14",
                            "district_code": district_code, "district": district,
                            "constituency_code": county_code, "constituency": county,
                            "subcounty_code": current_sc[0], "subcounty": current_sc[1],
                            "parish_code": current_parish[0], "parish": current_parish[1],
                            "village_code": village[0], "village": village[1],
                            "parser_note": "",
                        }
                        records.append(record)
                        page_records.append(record)
                    elif village_cell and not village_cell.startswith(("TOTAL", "Page", "Tuesday")):
                        if page_records and not any(cells[:-1]):
                            page_records[-1]["village"] += " " + village_cell
                            page_records[-1]["parser_note"] = "Wrapped village name joined within same source page"
                        elif not any(token in village_cell.upper() for token in ("VILLAGES", "ELECTORAL", "COUNCILLORS")):
                            raise ValueError(f"Unparsed village cell: {name} page {page_index+1}: {cells}")
                print(f"Extracted {name} page {page_index+1}: {len(page_records)} villages", flush=True)
        n = len(records)-n_before
        print(f"{name}: {n} source village rows", flush=True)
    write_csv(output / "ec_source_village_rows.csv", records)
    print("EC source counts:", {source: {district: sum(r["source_id"] == source and r["district"] == district for r in records)
          for district in sorted(DISTRICTS)} for source in ("EC_2022", "EC_2025")}, flush=True)
    return records


def strip_number(value) -> str:
    return clean(re.sub(r"^\s*\d+\s*[.)]?\s*", "", str(value or "")))


def local_record(source, file, location, date, district, sc, parish, village):
    district = re.sub(r"\s+DISTRICT$", "", clean(district).upper())
    return {"source_id": source, "source_file": file, "source_location": location,
            "reference_date": date, "district": district,
            "subcounty": clean(sc).upper(), "parish": clean(parish).upper(),
            "village": clean(village).upper()}


def extract_local_sources(root: Path):
    raw = root / "3 Data/1 Raw/Secondary data"
    output = root / "3 Data/2 Working/Phase2_Administrative_Frame"
    records, controls = [], []
    bush_file = "BUSHENYI - Updated Admn Units as at 1st June 2024 (1).xls"
    with (raw / "Phase2_Administrative_Sources/bushenyi_2024_sheet1.csv").open(encoding="utf-8-sig") as stream:
        parents = ["", "", "", "", ""]
        for row in csv.DictReader(stream):
            if int(row["excel_row"]) < 5:
                continue
            if row["A"].strip().upper() == "TOTAL":
                controls.append({"source_id": "BUSHENYI_2024", "level": "district", "unit": "BUSHENYI",
                                 "declared_villages": int(row["F"]), "source_location": f"Sheet1!F{row['excel_row']}"})
                continue
            for col, field in enumerate("ABCDE"):
                if row[field].strip():
                    parents[col] = row[field]
                    if col >= 3:
                        parents[col+1:] = [""] * (4-col)
            if row["F"].strip():
                assert parents[0].upper() == "BUSHENYI", row
                records.append(local_record("BUSHENYI_2024", bush_file,
                    f"Sheet1!F{row['excel_row']}", "2024-06-01", "BUSHENYI",
                    parents[3], parents[4], row["F"]))
    rub_file = "RUBIRIZI ADMIN DATA.xlsx"
    workbook = openpyxl.load_workbook(raw / rub_file, data_only=True, read_only=True)
    sc = parish = ""
    for row_number, row in enumerate(workbook.active.iter_rows(values_only=True), 1):
        if row_number < 3:
            continue
        a, b, c, d, e = row
        if str(a or "").strip().lower().startswith("total no. villages"):
            controls.append({"source_id": "RUBIRIZI_LOCAL", "level": "district", "unit": "RUBIRIZI",
                             "declared_villages": int(b), "source_location": f"Sheet1!B{row_number}"})
            break
        if a is not None and str(a).strip().lower().startswith("total"):
            controls.append({"source_id": "RUBIRIZI_LOCAL", "level": "subcounty", "unit": sc,
                             "declared_villages": e, "source_location": f"Sheet1!E{row_number}"})
            sc = parish = ""
            continue
        if a is not None:
            sc, parish = strip_number(a), ""
        if not sc:
            continue
        if b is not None:
            parish = strip_number(b)
            if isinstance(e, (int, float)):
                controls.append({"source_id": "RUBIRIZI_LOCAL", "level": "parish",
                                 "unit": f"{sc}|{parish}", "declared_villages": int(e),
                                 "source_location": f"Sheet1!E{row_number}"})
        for column, value in (("C", c), ("D", d)):
            if value is not None and isinstance(value, str) and value.strip():
                assert parish, (row_number, row)
                records.append(local_record("RUBIRIZI_LOCAL", rub_file, f"Sheet1!{column}{row_number}",
                    "Undated", "RUBIRIZI", sc, parish, strip_number(value)))
    workbook.close()
    sheema_file = "Sheema Administrative units.doc"
    cells = extract_sheema_tables(root)
    rows = defaultdict(dict)
    for cell in cells:
        if cell["table"] in (1, 3):
            rows[(cell["table"], cell["row"])][cell["column"]] = cell["text"]
    sc = parish = ""
    for (table, row_number), row in sorted(rows.items()):
        heading = clean(row.get(1, ""))
        if heading.upper().startswith(("SUB COUNTY", "DIVISIONS")):
            continue
        if "TOTAL" in heading.upper():
            grand = "GRAND" in heading.upper()
            controls.append({"source_id": "SHEEMA_2020", "level": "district_part" if grand else "subcounty",
                             "unit": "Rural and town councils" if grand and table == 1 else "Municipality" if grand else sc,
                             "declared_villages": clean(row.get(5, "")),
                             "source_location": f"Table {table} row {row_number}"})
            continue
        if heading:
            sc = re.sub(r"\s*cont.*$", "", heading, flags=re.I)
        if clean(row.get(2, "")):
            parish = clean(row[2])
        if not sc or not parish:
            continue
        village_names = []
        for col in (3, 4):
            for ordinal, name in enumerate(row.get(col, "").split("\r"), 1):
                if clean(name):
                    village_names.append(clean(name))
                    records.append(local_record("SHEEMA_2020", sheema_file,
                        f"Table {table} row {row_number} col {col} item {ordinal}", "2020-01-31",
                        "SHEEMA", sc, parish, name))
        if village_names and clean(row.get(5, "")).isdigit():
            controls.append({"source_id": "SHEEMA_2020", "level": "parish", "unit": f"{sc}|{parish}",
                             "declared_villages": int(clean(row[5])),
                             "source_location": f"Table {table} row {row_number}"})
    write_csv(output / "local_source_village_rows.csv", records)
    write_csv(output / "local_declared_controls.csv", controls)
    print("Local source village rows:", dict(Counter(r["source_id"] for r in records)), flush=True)
    return records


def extract_project_references(root: Path):
    """Geography only: never export chairperson, telephone or free-text notes."""
    raw = root / "3 Data/1 Raw"
    output = root / "3 Data/2 Working/Phase2_Administrative_Frame"
    records = []
    for source, filename in (("PROJECT_FVL", "Final Village List.xlsx"),
                             ("PROJECT_TRACKER", "Tracking_Form_Final.xlsx"),
                             ("PROJECT_MAPPED", "List of LCs mapped.xlsx")):
        file = raw / "Primary data" / filename
        if not file.exists():
            # Some project inventories place geography lists in Secondary data.
            file = raw / "Secondary data" / filename
        assert file.exists(), file
        workbook = openpyxl.load_workbook(file, data_only=True, read_only=True)
        for sheet in workbook:
            header = None
            for row_number, row in enumerate(sheet.iter_rows(values_only=True), 1):
                if header is None:
                    labels = [clean(str(x or "")).lower().replace(" ", "") for x in row]
                    if all(x in labels for x in ("district", "subcounty", "parish", "village")):
                        header = [labels.index(x) for x in ("district", "subcounty", "parish", "village")]
                    continue
                values = [str(row[i] or "").strip() for i in header]
                if not values[-1] or not values[0]:
                    continue
                if re.sub(r"\s+DISTRICT$", "", values[0].upper()) not in DISTRICTS:
                    continue
                record = local_record(source, filename, f"{sheet.title}!row {row_number}",
                    "Undated project reference", *values)
                if source == "PROJECT_FVL":
                    record["original100_frame_selected"] = str(row[5] or 0)
                records.append(record)
        workbook.close()
    snapshots = raw / "Secondary data/Phase2_Administrative_Sources"
    for source, filename, fields in (
        ("PROJECT_PHASE1", "phase1_geographic_reference.csv", ("canonical_district", "canonical_subcounty", "canonical_parish", "canonical_village")),
        ("PROJECT_SAMPLING", "phase1_sampling_geographic_reference.csv", ("district", "subcounty", "parish", "village")),
    ):
        with (snapshots / filename).open(encoding="utf-8-sig") as stream:
            for row_number, row in enumerate(csv.DictReader(stream), 2):
                record = local_record(source, filename, f"CSV row {row_number}", "Current project geographic reference",
                    *(row[x] for x in fields))
                record["phase1_uid"] = row.get("canonical_village_uid", row.get("village_uid", ""))
                record["selected100_observed"] = row.get("selected_fvl100_observed", "")
                record["selected100_frame_uid"] = row.get("selected100_frame_uid", "")
                records.append(record)
    write_csv(output / "project_geographic_reference_rows.csv", records)
    print("Project geography-only rows:", dict(Counter(r["source_id"] for r in records)), flush=True)
    return records


def name_key(value, level="village"):
    value = clean(value).upper()
    value = re.sub(r"^\d+[.)]\s*", "", value)
    value = re.sub(r"\s*[\[(](?:NEW |FROM |OLD\b).*", "", value)
    if level == "subcounty":
        value = re.sub(r"\b(SUB[ -]?COUNTY|S/C|SC)\b", "", value)
        value = re.sub(r"\bTOWN(?: COUNCIL)?\b|\bT/C\b", "TC", value)
        value = re.sub(r"\bDIVISION\b", "DIV", value)
    if level == "parish":
        value = re.sub(r"\b(PARISH|WARD)\b", "", value)
    # Preserve token boundaries: RYENJOKI II and RYENJOK III are not
    # interchangeable merely because deleting spaces produces the same text.
    return clean(re.sub(r"[^A-Z0-9 ]", " ", value))


def hierarchy_key(row):
    return tuple(name_key(row[x], x) for x in ("district", "subcounty", "parish", "village"))


def shorthand_key(key):
    return (key[0], clean(re.sub(r"\b(TC|DIV)\b", "", key[1])), key[2], key[3])


def ec_uid(row):
    return "UGA_" + "_".join(str(int(row[x])).zfill(3) for x in
        ("district_code", "constituency_code", "subcounty_code", "parish_code", "village_code"))


def reconcile(root: Path):
    output = root / "3 Data/2 Working/Phase2_Administrative_Frame"
    def read(name):
        with (output / name).open(encoding="utf-8-sig") as stream:
            return list(csv.DictReader(stream))
    official = read("ec_source_village_rows.csv")
    rows = official + read("local_source_village_rows.csv") + read("project_geographic_reference_rows.csv")
    base = {ec_uid(r): r for r in official if r["source_id"] == "EC_2022"}
    assert len(base) == sum(r["source_id"] == "EC_2022" for r in official), "Duplicate EC village code"
    assert Counter(r["district"] for r in base.values()) == Counter(BUSHENYI=571, RUBIRIZI=293, SHEEMA=619), "EC district printed totals do not reconcile"
    full, shorthand, sc_name, district_name = (defaultdict(list) for _ in range(4))
    base_keys = {uid: hierarchy_key(row) for uid, row in base.items()}
    for uid, row in base.items():
        key = base_keys[uid]
        full[key].append(uid)
        shorthand[shorthand_key(key)].append(uid)
        sc_name[(key[0], key[1], key[3])].append(uid)
        district_name[(key[0], key[3])].append(uid)
    crosswalk, issues = [], []
    for ordinal, row in enumerate(rows, 1):
        location = row.get("source_location", f"PDF page {row.get('source_page','')} y={row.get('source_row_top','')}")
        source_row_id = row["source_id"] + "_" + hashlib.sha256(location.encode()).hexdigest()[:12]
        key = hierarchy_key(row)
        uid = ec_uid(row) if row["source_id"].startswith("EC_") else ""
        candidates = []
        status = ""
        if uid in base:
            status = "official_code_match"
            candidates = [uid]
        elif len(full[key]) == 1:
            uid, status = full[key][0], "full_hierarchy_match"
            candidates = [uid]
        elif len(shorthand[shorthand_key(key)]) == 1:
            uid, status = shorthand[shorthand_key(key)][0], "unique_admin_shorthand_match"
            candidates = [uid]
        else:
            uid = ""
            candidates = full[key] or sc_name[(key[0], key[1], key[3])] or district_name[(key[0], key[3])]
            status = "ambiguous_identity" if len(candidates) > 1 else "parent_conflict" if candidates else "unmatched"
            if not candidates:
                scored = [(SequenceMatcher(None, key[3], k[3]).ratio(), ident)
                          for ident, k in base_keys.items() if k[:2] == key[:2]
                          or (k[0] == key[0] and shorthand_key(k)[1] == shorthand_key(key)[1])]
                candidates = [ident for score, ident in sorted(scored, reverse=True)[:3] if score >= .72]
                if candidates:
                    status = "spelling_candidate_review"
        item = {"source_row_id": source_row_id, "source_id": row["source_id"],
                "source_file": row["source_file"], "source_location": location,
                "reference_date": row["reference_date"], "district": row["district"],
                "subcounty": row["subcounty"], "parish": row["parish"], "village": row["village"],
                "phase2_lc_uid": uid, "match_status": status,
                "candidate_uids": ";".join(candidates), "phase1_uid": row.get("phase1_uid", ""),
                "original100_frame_selected": row.get("original100_frame_selected", ""),
                "selected100_observed": row.get("selected100_observed", ""),
                "selected100_frame_uid": row.get("selected100_frame_uid", "")}
        crosswalk.append(item)
        if not uid:
            candidate_names = "; ".join(f"{base[c]['subcounty']} / {base[c]['parish']} / {base[c]['village']}" for c in candidates)
            issues.append({**item, "candidate_names": candidate_names,
                           "resolution": "Not assigned automatically; source identity/hierarchy requires reconciliation"})
    write_csv(output / "phase2_administrative_source_crosswalk.csv", crosswalk)
    write_csv(output / "phase2_administrative_issues.csv", issues)
    print("Source matching:", {s: dict(Counter(r["match_status"] for r in crosswalk if r["source_id"] == s))
          for s in sorted(set(r["source_id"] for r in crosswalk))}, flush=True)
    return base, crosswalk, issues


def verify_source_totals(root: Path):
    """Independent publication checksums, plus visible local-list inconsistencies."""
    output = root / "3 Data/2 Working/Phase2_Administrative_Frame"
    with (output / "ec_source_village_rows.csv").open(encoding="utf-8-sig") as stream:
        ec = [r for r in csv.DictReader(stream) if r["source_id"] == "EC_2022"]
    totals = Counter((r["district"], name_key(r["subcounty"], "subcounty")) for r in ec)
    district_totals = Counter(r["district"] for r in ec)
    pages = json.loads((output / "source_page_index.json").read_text())["ec_admin_2022.pdf"]
    checks = []
    with pdfplumber.open(root / "3 Data/1 Raw/Secondary data/Phase2_Administrative_Sources/ec_admin_2022.pdf") as pdf:
        for index in pages:
            text = pdf.pages[index].extract_text(x_tolerance=2, y_tolerance=2)
            district = clean(re.search(r"DISTRICT:\s*\d+\s+([A-Z -]+)", text).group(1))
            for line in text.splitlines():
                match = re.fullmatch(r"TOTAL VILLAGES IN (.+?)\s+(\d+)", line)
                district_match = re.fullmatch(r"END OF DISTRICT (.+?)\s+(\d+)", line)
                if match or district_match:
                    unit, declared = (match or district_match).groups()
                    observed = totals[(district, name_key(unit, "subcounty"))] if match else district_totals[unit]
                    assert int(declared) == observed, (index+1, line, observed)
                    checks.append({"source_id": "EC_2022", "level": "subcounty" if match else "district",
                        "unit": f"{district}|{unit}" if match else unit,
                        "source_location": f"PDF page {index+1}", "declared_villages": int(declared),
                        "extracted_rows": observed, "difference": observed-int(declared), "status": "PASS"})
    assert sum(c["level"] == "district" for c in checks) == 3
    assert sum(c["level"] == "subcounty" for c in checks) == len(totals), "Missing EC subcounty checksum"
    with (output / "local_source_village_rows.csv").open(encoding="utf-8-sig") as stream:
        local = list(csv.DictReader(stream))
    local_totals = Counter()
    for r in local:
        for unit in (r["district"], r["subcounty"], r["subcounty"] + "|" + r["parish"]):
            local_totals[(r["source_id"], unit.upper())] += 1
    with (output / "local_declared_controls.csv").open(encoding="utf-8-sig") as stream:
        for c in csv.DictReader(stream):
            if not str(c["declared_villages"]).isdigit():
                continue
            if c["level"] == "district_part":
                prefix = "Table 1 " if c["unit"].startswith("Rural") else "Table 3 "
                observed = sum(r["source_id"] == c["source_id"] and r["source_location"].startswith(prefix) for r in local)
            else:
                observed = local_totals[(c["source_id"], c["unit"].upper())]
            declared = int(c["declared_villages"])
            checks.append({**c, "declared_villages": declared, "extracted_rows": observed,
                           "difference": observed-declared, "status": "PASS" if declared == observed else "SOURCE_COUNT_DISCREPANCY"})
    write_csv(output / "phase2_administrative_source_checks.csv", checks)
    print("Printed/source total checks:", dict(Counter(c["status"] for c in checks)), flush=True)
    return checks


def build_census(root: Path):
    """Produce an auditable administrative reference, never an eligibility/assignment roster."""
    output = root / "3 Data/2 Working/Phase2_Administrative_Frame"
    raw = root / "3 Data/1 Raw"
    snapshots = raw / "Secondary data/Phase2_Administrative_Sources"
    source_paths = [snapshots / name for name in SOURCE_URLS] + [
        raw / "Secondary data/BUSHENYI - Updated Admn Units as at 1st June 2024 (1).xls",
        raw / "Secondary data/RUBIRIZI ADMIN DATA.xlsx",
        raw / "Secondary data/Sheema Administrative units.doc",
        raw / "Primary data/Final Village List.xlsx",
        raw / "Primary data/Tracking_Form_Final.xlsx",
        raw / "Secondary data/List of LCs mapped.xlsx",
        root / "3 Data/3 Coded/phase1_baseline_analysis.dta",
        root / "3 Data/2 Working/phase1_sampling_frame_full.dta",
        snapshots / "bushenyi_2024_sheet1.csv",
        snapshots / "phase1_geographic_reference.csv",
        snapshots / "phase1_sampling_geographic_reference.csv",
        snapshots / "sheema_2020_table_cells.json",
        output / "ec_source_village_rows.csv",
        output / "source_page_index.json",
    ]
    input_hashes = {str(p.relative_to(root)): digest(p) for p in source_paths}
    manifest_path = output / "phase2_administrative_source_manifest.json"
    if manifest_path.exists():
        previous = json.loads(manifest_path.read_text())
        assert all(input_hashes.get(p) == h for p, h in previous["input_sha256"].items()), "Source versions changed; review rather than silently rebuild"
    for name in SOURCE_URLS:
        assert digest(snapshots / name) == SOURCE_SHA256[name], f"Wrong official PDF snapshot: {name}"
    for name, url in CONTEXT_URLS.items():
        target = snapshots / name
        if not target.exists():
            request = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (research source audit)"})
            with urllib.request.urlopen(request, timeout=45) as response:
                payload = response.read(8_000_001)
            assert len(payload) <= 8_000_000 and (b"<html" in payload.lower() or b"<!doctype html" in payload.lower()), (name, "Invalid HTML snapshot")
            target.write_bytes(payload)
    extract_local_sources(root)
    extract_project_references(root)
    base, crosswalk, issues = reconcile(root)
    checks = verify_source_totals(root)
    by_uid = defaultdict(list)
    for r in crosswalk:
        if r["phase2_lc_uid"]:
            by_uid[r["phase2_lc_uid"]].append(r)
    duplicates = defaultdict(list)
    for r in crosswalk:
        duplicates[(r["source_id"], *hierarchy_key(r))].append(r)
    for key, group in duplicates.items():
        if len(group) > 1:
            for r in group:
                issues.append({**r, "match_status": "duplicate_source_hierarchy", "candidate_names": "",
                               "resolution": f"{len(group)} source entries share the same normalized full hierarchy; preserved, not double-counted in census"})
    for c in checks:
        if c["status"] != "PASS":
            issues.append({"source_row_id": f"{c['source_id']}_CONTROL_{c['source_location']}",
                "source_id": c["source_id"], "source_file": "RUBIRIZI ADMIN DATA.xlsx",
                "source_location": c["source_location"], "reference_date": "Undated", "district": "RUBIRIZI",
                "subcounty": c["unit"].split("|")[0] if c["level"] != "district" else "",
                "parish": c["unit"].split("|")[-1] if c["level"] == "parish" else "", "village": "",
                "phase2_lc_uid": "", "match_status": "source_declared_count_discrepancy", "candidate_uids": "",
                "candidate_names": "", "resolution": f"Printed {c['declared_villages']}; extracted {c['extracted_rows']}. Source inconsistency, no count forced."})
    issues.append({"source_row_id": "RUBIRIZI_WEBSITE_DISTRICT_TOTAL", "source_id": "RUBIRIZI_WEBSITE",
        "source_file": "rubirizi_administrative_structure.html", "source_location": "Political and Administrative Structure",
        "reference_date": "Undated; retrieved " + date.today().isoformat(), "district": "RUBIRIZI",
        "subcounty": "", "parish": "", "village": "", "phase2_lc_uid": "",
        "match_status": "cross_source_district_count_discrepancy", "candidate_uids": "", "candidate_names": "",
        "resolution": "District website reports 294 villages; EC village-level list contains 293. No evidence identifying an additional current LC; not resolved by adding a row."})
    # A newer page may only enumerate some villages in a parent unit. Apply
    # its equivalent parent LABEL consistently to the shared official code;
    # absence of a village from that partial list never removes membership.
    sc_labels, parish_labels = {}, {}
    priority = {"EC_2022": 0, "BUSHENYI_2024": 1, "EC_2025": 2}
    for r in sorted((r for r in crosswalk if r["source_id"] in priority), key=lambda r: priority[r["source_id"]]):
        codes = r["phase2_lc_uid"].removeprefix("UGA_").split("_")
        original = base[r["phase2_lc_uid"]]
        assert name_key(r["subcounty"], "subcounty") == name_key(original["subcounty"], "subcounty")
        assert name_key(r["parish"], "parish") == name_key(original["parish"], "parish")
        sc_labels[tuple(codes[:3])] = r["subcounty"]
        parish_labels[tuple(codes[:4])] = r["parish"]
    frame = []
    for uid, original in sorted(base.items()):
        linked = by_uid[uid]
        latest = original
        update = next((r for r in linked if r["source_id"] == "EC_2025"), None)
        if update:
            assert name_key(update["village"]) == name_key(original["village"]), (uid, original, update)
            latest = update
        source_ids = sorted(set(r["source_id"] for r in linked))
        newest_source, newest_date = ("EC_2025", "2025-01-14") if update else (
            ("BUSHENYI_2024", "2024-06-01") if "BUSHENYI_2024" in source_ids else ("EC_2022", "2022-07-19"))
        phase1 = [r for r in linked if r["source_id"] == "PROJECT_PHASE1"]
        review_count = sum(uid in r.get("candidate_uids", "").split(";") and not r.get("phase2_lc_uid") for r in issues)
        codes = uid.removeprefix("UGA_").split("_")
        sc_id = "UGA_SC_" + "_".join(codes[:3])
        parish_id = "UGA_P_" + "_".join(codes[:4])
        sc_label, parish_label = sc_labels[tuple(codes[:3])], parish_labels[tuple(codes[:4])]
        frame.append({"phase2_lc_uid": uid, "district": latest["district"], "subcounty": sc_label,
            "parish": parish_label, "village": latest["village"],
            "admin_unit_type": "municipal_division" if "DIVISION" in sc_label else "town_council" if "TOWN" in sc_label else "subcounty",
            "constituency": original["constituency"], "district_code": codes[0], "constituency_code": codes[1],
            "subcounty_code": codes[2], "parish_code": codes[3], "village_code": codes[4],
            "subcounty_uid": sc_id, "parish_uid": parish_id, "anchor_source_id": "EC_2022",
            "anchor_reference_date": "2022-07-19", "anchor_pdf_page": original["source_page"],
            "newest_reference_date": newest_date, "newest_source_id": newest_source,
            "corroborating_source_ids": ";".join(s for s in source_ids if s != "EC_2022"),
            "linked_phase1_records": len(phase1), "unresolved_candidate_rows": review_count,
            "source_evidence_rows": len(linked), "release_status": "ADMIN_REFERENCE_ONLY_NOT_RCT_ASSIGNMENT_FRAME"})
    assert len({r["phase2_lc_uid"] for r in frame}) == len(frame) == len(base)
    assert all(all(r[x] for x in ("district", "subcounty", "parish", "village")) for r in frame)
    for field in ("subcounty_uid", "parish_uid"):
        parents = defaultdict(set)
        for r in frame:
            parents[r[field]].add(tuple(r[x] for x in ("district", "subcounty") + (("parish",) if field == "parish_uid" else ())))
        assert all(len(v) == 1 for v in parents.values()), f"Conflicting hierarchy for {field}"
    assert len({r["source_row_id"] for r in crosswalk}) == len(crosswalk)
    assert all(not r["phase2_lc_uid"] or r["phase2_lc_uid"] in base for r in crosswalk)
    for uid, linked in by_uid.items():
        p1 = [r for r in linked if r["source_id"] == "PROJECT_PHASE1"]
        if len(p1) > 1:
            issues.append({**p1[0], "match_status": "multiple_phase1_anchors_same_reference_lc",
                "candidate_names": "", "resolution": f"{len(p1)} distinct Phase 1 references link to this EC LC. Do not merge baseline records or designate a mentor automatically."})
    write_csv(output / "phase2_administrative_village_frame.csv", frame)
    write_csv(output / "phase2_administrative_issues.csv", issues)
    source_descriptions = {
        "EC_2022": ("ec_admin_2022.pdf", "2022-07-19", "National Electoral Commission", "Complete coded village/cell roster for the three districts; anchor", SOURCE_URLS["ec_admin_2022.pdf"]),
        "EC_2025": ("ec_village_electoral_split_2025.pdf", "2025-01-14", "National Electoral Commission", "Partial village split for electoral areas; corroboration only", SOURCE_URLS["ec_village_electoral_split_2025.pdf"]),
        "BUSHENYI_2024": ("BUSHENYI - Updated Admn Units as at 1st June 2024 (1).xls", "2024-06-01", "Ministry of Local Government / district document", "Complete district administrative roster; 571 exact hierarchy matches", "Dropbox project source"),
        "SHEEMA_2020": ("Sheema Administrative units.doc", "2020-01-31", "Sheema District Local Government", "Historical district and municipality roster; not a 2026 update", "Dropbox project source"),
        "RUBIRIZI_LOCAL": ("RUBIRIZI ADMIN DATA.xlsx", "Undated", "District document supplied in project corpus", "295 enumerated source entries; repeated entries and inconsistent totals; cannot replace EC frame", "Dropbox project source"),
        "PROJECT_FVL": ("Final Village List.xlsx", "Undated", "Project administrative list", "Historical selected-unit reference, not a census or training roster", "Dropbox project source"),
        "PROJECT_TRACKER": ("Tracking_Form_Final.xlsx", "Undated", "Project administrative tracker", "Geography-only reference; no names, telephone or notes extracted", "Dropbox project source"),
        "PROJECT_MAPPED": ("List of LCs mapped.xlsx", "Undated", "Project field mapping list", "Geography-only reference; not independently verified all-village roster", "Dropbox project source"),
        "PROJECT_PHASE1": ("phase1_baseline_analysis.dta", "Current locked project data", "Project final coded survey", "Geography-only reference to 130 LC interviews; not confirmed training attendance or mentor eligibility", "Dropbox project source"),
        "PROJECT_SAMPLING": ("phase1_sampling_frame_full.dta", "Historical project frame", "Project sampling frame", "305 geographic reference units; not the administrative census of all LCs", "Dropbox project source"),
    }
    sources = []
    for source, (filename, reference_date, authority, scope, url) in source_descriptions.items():
        file = next((p for p in source_paths if p.name == filename), None)
        source_rows = [r for r in crosswalk if r["source_id"] == source]
        sources.append({"source_id": source, "source_file": filename, "reference_date": reference_date,
            "authority": authority, "scope": scope, "url_or_location": url,
            "source_sha256": digest(file) if file else "", "source_rows": len(source_rows),
            "linked_rows": sum(bool(r["phase2_lc_uid"]) for r in source_rows),
            "unresolved_rows": sum(not r["phase2_lc_uid"] for r in source_rows),
            "extraction": "Position-aware PDF extraction" if source.startswith("EC_") else "Stata MCP geography-only export" if source.startswith("PROJECT_PHASE1") or source == "PROJECT_SAMPLING" or source == "BUSHENYI_2024" else "Read-only native Word table cells" if source == "SHEEMA_2020" else "Read-only XLSX cell extraction"})
    for name, url in CONTEXT_URLS.items():
        sources.append({"source_id": name.removesuffix(".html").upper(), "source_file": name,
            "reference_date": "2025-12-10" if name.startswith("bushenyi") else "2025-01-14" if "2025" in name else "Undated",
            "authority": "Official government website", "scope": "Context/count check only; not a village-level roster",
            "url_or_location": url, "source_sha256": digest(snapshots / name), "source_rows": 0,
            "linked_rows": 0, "unresolved_rows": 0, "extraction": "Saved HTML snapshot; relevant source text inspected"})
    write_csv(output / "phase2_administrative_sources.csv", sources)
    dictionary = []
    descriptions = {
        "phase2_lc_uid": "UGA plus padded district/constituency/subcounty/parish/village codes from EC 2022. Not a respondent ID.",
        "district": "Published district name; three study districts only.", "subcounty": "Published subcounty/town/division name; latest EC label where corroborated.",
        "parish": "Administrative parish/ward, not the electoral-area A/B label.", "village": "Published village/cell name; no spelling guesses.",
        "admin_unit_type": "Unit type inferred from the published parent label; not mentor or survey eligibility.",
        "constituency": "Published EC constituency hierarchy; retained for source-code uniqueness.",
        "subcounty_uid": "Hierarchical stable identifier using district, constituency and subcounty codes.",
        "parish_uid": "Hierarchical stable identifier using codes through parish.",
        "anchor_source_id": "Complete roster anchoring membership and identifiers.", "anchor_reference_date": "Reference date of the anchor publication, not 2026 certification.",
        "anchor_pdf_page": "One-based PDF page for direct audit.", "newest_reference_date": "Newest dated official/district source corroborating this unit, not a field revalidation date.",
        "newest_source_id": "Source associated with newest_reference_date; undated project lists do not override official membership.",
        "corroborating_source_ids": "Semicolon-delimited sources with documentary code/full-hierarchy/shorthand linkage.",
        "linked_phase1_records": "Number of geographic references in the locked coded Phase 1 data linked without fuzzy guesses. Not trained or mentor-eligible count.",
        "unresolved_candidate_rows": "Unassigned source rows listing this LC among review candidates; overlaps, not a count of missing villages.",
        "source_evidence_rows": "All assigned documentary/source references for this unit; not separate LC observations.",
        "release_status": "Administrative reference only. Coordinates, contemporary administrative review, mentor assessment, neighbor eligibility and approved design are outside Milestone 1.",
    }
    for field in frame[0]:
        dictionary.append({"variable": field, "type": "integer" if field in ("linked_phase1_records", "unresolved_candidate_rows", "source_evidence_rows", "anchor_pdf_page") else "string",
            "definition": descriptions.get(field, "Published EC code, zero-padded to three digits; retain as string to preserve leading zeros."),
            "missing_rule": "Empty means no additional assigned source." if field == "corroborating_source_ids" else "No missing values permitted; zero is valid for counts." if field in ("linked_phase1_records", "unresolved_candidate_rows") else "No missing values permitted."})
    write_csv(output / "phase2_administrative_dictionary.csv", dictionary)
    district_summary = []
    for district in sorted(DISTRICTS):
        units = [r for r in frame if r["district"] == district]
        district_summary.append({"district": district, "villages": len(units),
            "subcounties_towns_divisions": len(set(r["subcounty_uid"] for r in units)),
            "parishes_wards": len(set(r["parish_uid"] for r in units)),
            "ec2025_corroborated": sum(r["newest_source_id"] == "EC_2025" for r in units),
            "phase1_documentary_linked": sum(r["linked_phase1_records"] for r in units),
            "phase1_identity_review": sum(r["source_id"] == "PROJECT_PHASE1" and r["district"] == district and not r["phase2_lc_uid"] for r in crosswalk)})
    write_csv(output / "phase2_administrative_district_summary.csv", district_summary)
    manifest = {"created_or_verified": date.today().isoformat(), "milestone": "1 Administrative reference census",
        "status": "COMPLETE_SOURCE_BASED_CENSUS_WITH_EXPLICIT_RECONCILIATION_QUEUE_NOT_RCT_RELEASE",
        "input_sha256": input_hashes, "official_pdf_sha256": SOURCE_SHA256,
        "district_counts": {r["district"]: r["villages"] for r in district_summary},
        "canonical_lcs": len(frame), "source_reference_rows": len(crosswalk),
        "unassigned_source_rows": sum(not r["phase2_lc_uid"] for r in crosswalk),
        "issue_rows": len(issues), "checksum_passes": sum(c["status"] == "PASS" for c in checks),
        "source_count_discrepancies": sum(c["status"] != "PASS" for c in checks),
        "source_counts": sources,
        "non_actions": ["No Phase 1/report change", "No training/mentor eligibility inference", "No neighbors, GIS buffers or geocoding", "No randomization", "No impact analysis"]}
    assert {str(p.relative_to(root)): digest(p) for p in source_paths} == input_hashes, "An existing source changed during read-only build"
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    print("FINAL REFERENCE CENSUS:", json.dumps({k: manifest[k] for k in ("canonical_lcs", "district_counts", "source_reference_rows", "unassigned_source_rows", "issue_rows", "checksum_passes", "source_count_discrepancies")}), flush=True)
    return manifest


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=DEFAULT_ROOT)
    parser.add_argument("--download", action="store_true")
    parser.add_argument("--inspect", action="store_true")
    parser.add_argument("--locate", action="store_true")
    parser.add_argument("--extract", action="store_true")
    parser.add_argument("--sheema-tables", action="store_true")
    parser.add_argument("--local", action="store_true")
    parser.add_argument("--project", action="store_true")
    parser.add_argument("--reconcile", action="store_true")
    parser.add_argument("--checks", action="store_true")
    parser.add_argument("--build", action="store_true")
    args = parser.parse_args()
    if args.download:
        download_sources(args.root)
    if args.inspect:
        inspect_sources(args.root)
    if args.locate:
        locate_pages(args.root)
    if args.extract:
        extract_ec_sources(args.root)
    if args.sheema_tables:
        rows = extract_sheema_tables(args.root)
        print(json.dumps(rows[:20], ensure_ascii=False, indent=2), flush=True)
    if args.local:
        extract_local_sources(args.root)
    if args.project:
        extract_project_references(args.root)
    if args.reconcile:
        reconcile(args.root)
    if args.checks:
        verify_source_totals(args.root)
    if args.build:
        build_census(args.root)


if __name__ == "__main__":
    main()
