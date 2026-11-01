* Advancing Justice Uganda: explicit research-workflow entry point.
* Requires Stata 19 and the two current coded datasets in private Dropbox.
* Supply absolute repository and Dropbox roots; no author-specific paths.
*
* do "0 Master Code_AdvJusticeUganda.do" "repository" "Dropbox project" 0
* 0 (default): read-only preflight. 1: preflight, then baseline analysis.
* Optional fourth argument: an existing alternative output root for validation.
*
* Fifth argument: analysis (default), preparation, phase2_admin or phase2_geo.
* Sixth: existing geographic mode. Seventh: PDF/Excel runtime for phase2_admin.
* Historical sampling is frozen. Preparation runs only the baseline block;
* no archived scripts or randomization commands are called.
* A successful execution is not scientific or public-release clearance.
version 19
args repository_root dropbox_root run_analysis output_root workflow phase2_mode python_runtime
if "`workflow'" == "" local workflow "analysis"

if `"`repository_root'"' == "" | `"`dropbox_root'"' == "" {
    display as error "Supply the absolute repository root and private Dropbox project root."
    display as error "See README.md for preflight and analysis examples."
    exit 198
}
if "`run_analysis'" == "" local run_analysis 0
if !inlist("`run_analysis'", "0", "1") {
    display as error "The third argument must be 0 (preflight) or 1 (analysis)."
    exit 198
}

clear all
set more off
set varabbrev off

* Resolve roots from explicit arguments, not the username or session globals.
local starting_directory `"`c(pwd)'"'
capture cd `"`repository_root'"'
if _rc {
    display as error "Repository directory not found: `repository_root'"
    exit 601
}
global git = subinstr(c(pwd), char(92), "/", .)
capture cd `"`dropbox_root'"'
if _rc {
    quietly cd `"`starting_directory'"'
    display as error "Dropbox project directory not found: `dropbox_root'"
    exit 601
}
global dropbox = subinstr(c(pwd), char(92), "/", .)
quietly cd "${git}"

global input_dir "${dropbox}/3 Data"
global code_dir "${git}/1 Code"
if `"`output_root'"' == "" local output_root "${git}/2 Output"
capture cd `"`output_root'"'
if _rc {
    display as error "Output root must already exist: `output_root'"
    exit 601
}
global output_dir = subinstr(c(pwd), char(92), "/", .)
quietly cd "${git}"

* Maintenance uses a private copy, never the historical sampling entry point.
if "`workflow'" != "analysis" {
    if !inlist("`workflow'", "preparation", "phase2_admin", "phase2_geo") {
        display as error "Workflow must be analysis, preparation, phase2_admin or phase2_geo."
        exit 198
    }
    if "`workflow'" == "phase2_geo" & !inlist("`phase2_mode'", "build", "acquire", "reconcile", "neighbors", "auditfix", "coverage", "verification", "official") {
        display as error "Supply the existing Phase 2 geographic mode as argument six."
        exit 198
    }
    local io_rc 0
    local io_error ""
    local manual_recovery 0
    python:
from pathlib import Path, PureWindowsPath
from tempfile import mkdtemp
from datetime import datetime, timezone
from sfi import Macro
import hashlib, json, os, shutil, time

def _aju_release_lock(lock):
    for name in ("owner.json", "journal.json"):
        (lock / name).unlink(missing_ok=True)
    for attempt in range(5):
        try:
            os.rmdir(lock)
            return
        except FileNotFoundError:
            return
        except OSError:
            if attempt == 4:
                raise
            time.sleep(0.2 * (attempt + 1))

def _aju_hash(path):
    h = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for block in iter(lambda: stream.read(1048576), b""):
            h.update(block)
    return h.hexdigest()

def _aju_inventory(root, relatives):
    result = {}
    for rel in relatives:
        path = root / rel
        if path.is_symlink():
            raise RuntimeError(f"Linked publication path requires review: {path}")
        files = sorted(path.rglob("*")) if path.is_dir() else [path]
        for p in files:
            if p.is_symlink():
                raise RuntimeError(f"Linked source requires review: {p}")
            if p.is_file():
                if not p.resolve().is_relative_to(root):
                    raise RuntimeError(f"Source escapes its declared root: {p}")
                result[p.relative_to(root).as_posix()] = _aju_hash(p)
    return result

def _aju_pin_path(root, recorded):
    text = str(recorded).replace(chr(92), "/")
    if text.startswith("DROPBOX/"):
        path = root / text[8:]
    elif text.startswith("REPO/") or text.startswith("1 Code/"):
        return None
    elif Path(text).is_absolute() or PureWindowsPath(text).is_absolute():
        if "/1 Code/" in text:
            return None
        anchors = [part for part in ("3 Data", "4 Deliverables and Presentations") if f"/{part}/" in text]
        if len(anchors) != 1:
            raise RuntimeError(f"Unrecognized receipt path: {recorded}")
        part = anchors[0]
        path = root / part / text.split(f"/{part}/", 1)[1]
    else:
        path = root / text
    if not path.resolve().is_relative_to(root):
        raise RuntimeError(f"Receipt path escapes project: {recorded}")
    return path

def _aju_check_receipts(root, skip_publication=None):
    checked = 0
    for folder in ("Phase2_Administrative_Frame", "Phase2_Geospatial_Frame"):
        for manifest in (root / "3 Data/2 Working" / folder).glob("*manifest.json"):
            data = json.loads(manifest.read_text(encoding="utf-8"))
            for field in ("input_sha256", "product_sha256", "preserved_sha256"):
                for recorded, expected in data.get(field, {}).items():
                    path = _aju_pin_path(root, recorded)
                    if path is not None:
                        if not path.is_file() or _aju_hash(path) != expected:
                            raise RuntimeError(f"Accepted receipt mismatch before writes: {manifest.name}: {recorded}")
                        checked += 1
    for receipt in (root / "3 Data").glob("*_publication.json"):
        if receipt.name == skip_publication:
            continue
        data = json.loads(receipt.read_text(encoding="utf-8"))
        for rel, expected in data["product_sha256"].items():
            path = _aju_pin_path(root, rel)
            if path is None or not path.is_file() or _aju_hash(path) != expected:
                raise RuntimeError(f"Published generation changed before writes: {receipt.name}: {rel}")
            checked += 1
    return checked

def _aju_promote(root, stage, units, backup, journal):
    # shortcut: multiple renames are recoverable, not power-loss atomic; use the journal for manual recovery after interruption.
    moved, installed = [], []
    plan = dict(root=root.as_posix(), workspace=stage.as_posix(), units=units, moved=moved, installed=installed)
    def record():
        journal.write_text(json.dumps(plan, indent=2), encoding="utf-8")
    if not stage.is_dir() or backup.exists():
        raise RuntimeError("Missing workspace or existing recovery directory.")
    if any(not (stage / rel).exists() for rel in units):
        raise RuntimeError("A required staged publication unit is missing.")
    for rel in units:
        if not (root / rel).resolve().is_relative_to(root) or not (stage / rel).resolve().is_relative_to(stage):
            raise RuntimeError("Publication unit escapes its declared root.")
    backup.mkdir()
    record()
    try:
        for rel in [units[-1]] + units[:-1]:
            target = root / rel
            if target.exists():
                old = backup / rel
                old.parent.mkdir(parents=True, exist_ok=True)
                os.rename(target, old)
                moved.append(rel)
                record()
        for rel in units:
            target = root / rel
            target.parent.mkdir(parents=True, exist_ok=True)
            os.rename(stage / rel, target)
            installed.append(rel)
            record()
    except Exception:
        try:
            for rel in reversed(installed):
                (stage / rel).parent.mkdir(parents=True, exist_ok=True)
                os.rename(root / rel, stage / rel)
            for rel in reversed(moved):
                os.rename(backup / rel, root / rel)
            plan["rollback_complete"] = True
            record()
        except Exception as recovery:
            Macro.setLocal("manual_recovery", "1")
            raise RuntimeError(f"Manual recovery required: {journal}; rollback error: {recovery}")
        raise

_aju_live = Path(Macro.getGlobal("dropbox")).resolve()
_aju_task = Macro.getLocal("workflow")
_aju_lock = _aju_live / "3 Data/.workflow-publication-lock"
_aju_owned = False
try:
    os.mkdir(_aju_lock)
    _aju_owned = True
    _aju_checked = _aju_check_receipts(_aju_live)
    _aju_reads = ["3 Data/1 Raw", "3 Data/2 Working", "3 Data/3 Coded", "4 Deliverables and Presentations"]
    _aju_reads += ["3 Data/" + task + suffix for task in ("preparation", "phase2_admin", "phase2_geo")
                   for suffix in ("_publication.json", "_validation.log")]
    _aju_before = _aju_inventory(_aju_live, _aju_reads)
    if _aju_task == "preparation":
        _aju_units = ["3 Data/3 Coded/phase1_baseline_reconciliation_release_status.txt"]
        _aju_units += ["3 Data/2 Working/" + name + ".dta" for name in (
            "phase1_baseline_all_submissions_raw", "phase1_village_crosswalk",
            "phase1_baseline_record_lineage", "phase1_baseline_clean_all_records", "phase1_baseline_clean")]
        _aju_units += ["3 Data/3 Coded/" + name for name in (
            "phase1_baseline_analysis.dta", "phase1_baseline_selected100_frame.dta", "phase1_baseline_reconciliation.xlsx")]
    elif _aju_task == "phase2_admin":
        _aju_units = ["3 Data/1 Raw/Secondary data/Phase2_Administrative_Sources",
                      "3 Data/2 Working/Phase2_Administrative_Frame"]
        runtime = Path(Macro.getLocal("python_runtime"))
        if not runtime.is_file():
            raise RuntimeError("Supply the existing PDF/Excel Python runtime as argument seven; no installation is performed.")
    else:
        _aju_units = ["3 Data/1 Raw/Secondary data/Phase2_Geospatial_Sources",
                      "3 Data/2 Working/Phase2_Geospatial_Frame",
                      "4 Deliverables and Presentations/Phase2_Administrative_Village_Census.xlsx"]
    _aju_receipt = "3 Data/" + _aju_task + "_publication.json"
    _aju_validation_log = "3 Data/" + _aju_task + "_validation.log"
    _aju_units.append(_aju_validation_log)
    # Remove any old generation receipt first; install the new receipt last.
    _aju_units = [_aju_receipt] + _aju_units
    if Macro.getLocal("run_analysis") == "1":
        _aju_workspace = Path(mkdtemp(prefix="aju_" + _aju_task + "_"))
        _aju_stage = _aju_workspace / "project"
        _aju_stage.mkdir()
        if _aju_stage.stat().st_dev != (_aju_live / "3 Data").stat().st_dev:
            raise RuntimeError("Temporary workspace and Dropbox must be on the same filesystem for rename-based publication.")
        for rel in _aju_reads:
            source = _aju_live / rel
            if source.exists():
                ( _aju_stage / rel).parent.mkdir(parents=True, exist_ok=True)
                if source.is_dir():
                    shutil.copytree(source, _aju_stage / rel)
                else:
                    shutil.copy2(source, _aju_stage / rel)
        _aju_backup = _aju_live / "3 Data" / (".publication-backup-" + _aju_workspace.name)
        _aju_owner = dict(live_root=_aju_live.as_posix(), workspace=_aju_stage.as_posix(), task=_aju_task)
        (_aju_lock / "owner.json").write_text(json.dumps(_aju_owner), encoding="utf-8")
        (_aju_stage / "__publication_workspace.json").write_text(json.dumps(_aju_owner), encoding="utf-8")
        Macro.setLocal("maintenance_stage", _aju_stage.as_posix())
        Macro.setLocal("maintenance_log", (_aju_stage / _aju_validation_log).as_posix())
    else:
        _aju_release_lock(_aju_lock)
        _aju_owned = False
except Exception as error:
    Macro.setLocal("io_rc", "603")
    Macro.setLocal("io_error", str(error))
    if _aju_owned:
        try:
            _aju_release_lock(_aju_lock)
        except Exception as cleanup:
            Macro.setLocal("io_error", f"{error}; lock cleanup requires review: {cleanup}")
end
    if `io_rc' {
        display as error `"Maintenance preflight failed: `io_error'"'
        exit `io_rc'
    }
    if "`run_analysis'" == "0" {
        display as result "MAINTENANCE PREFLIGHT PASSED; no source snapshot or output was replaced."
        exit 0
    }
    capture log close maintenance
    log using "`maintenance_log'", text name(maintenance) replace
    display as text "Workflow: `workflow'; mode: `phase2_mode'; staging: `maintenance_stage'"
    if "`workflow'" == "preparation" {
        global input_dir "`maintenance_stage'/3 Data"
        capture noisily do "$code_dir/1 Data Preparation_AdvJusticeUganda.do" "`maintenance_stage'" "publication_worker"
        local worker_rc = _rc
        global input_dir "$dropbox/3 Data"
    }
    if "`workflow'" == "phase2_admin" {
        capture noisily do "$code_dir/5 Phase2_Administrative_Frame.do" "`maintenance_stage'" "" "$code_dir/5 Phase2_Administrative_Frame.py" "publication_worker" "`python_runtime'"
        local worker_rc = _rc
    }
    if "`workflow'" == "phase2_geo" {
        capture noisily do "$code_dir/6 Phase2_Geospatial_Frame.do" "`maintenance_stage'" "`phase2_mode'" "$code_dir/6 Phase2_Geospatial_Frame.py" "publication_worker"
        local worker_rc = _rc
    }
    capture log close phase2check
    capture log close phase2geo
    quietly cd "$git"
    if `worker_rc' == 0 {
        * Existing data must agree observation by observation before promotion.
        python:
_aju_native = []
_aju_native_generated = {}
for rel in _aju_units:
    target = _aju_stage / rel
    candidates = target.rglob("*.dta") if target.is_dir() else [target]
    for path in candidates:
        if path.suffix == ".dta" and (_aju_live / path.relative_to(_aju_stage)).is_file():
            _aju_rel = path.relative_to(_aju_stage).as_posix()
            _aju_native.append(_aju_rel)
            _aju_native_generated[_aju_rel] = _aju_hash(path)
Macro.setLocal("native_count", str(len(_aju_native)))
end
        if `native_count' > 0 {
        forvalues file_index = 1/`native_count' {
            python: Macro.setLocal("native_file", _aju_native[int(Macro.getLocal("file_index")) - 1])
            use "`maintenance_stage'/`native_file'", clear
            local compare_variables "_all"
            local approved_alias_change = ("`workflow'" == "preparation" & "`native_file'" == "3 Data/2 Working/phase1_village_crosswalk.dta")
            if `approved_alias_change' {
                * Jorge approved only the deterministic choice of these audit aliases.
                ds subcounty_scto parish_scto village_scto, not
                local compare_variables "`r(varlist)'"
            }
            local comparison_key ""
            foreach candidate in submission_key canonical_village_uid selected100_frame_uid source_row_id reference_row_id phase2_lc_uid geo_id _ID {
                capture isid `candidate'
                if !_rc & "`comparison_key'" == "" local comparison_key "`candidate'"
            }
            tempfile comparison_reference
            if "`comparison_key'" != "" {
                preserve
                    use "$dropbox/`native_file'", clear
                    isid `comparison_key'
                    sort `comparison_key'
                    save `comparison_reference'
                restore
                sort `comparison_key'
                capture noisily cf `compare_variables' using `comparison_reference', all
            }
            else {
                capture noisily cf `compare_variables' using "$dropbox/`native_file'", all
            }
            if _rc {
                local worker_rc = _rc
                display as error "Existing native dataset differs: `native_file'. No publication; review before any substantive change."
                continue, break
            }
            if !`approved_alias_change' copy "$dropbox/`native_file'" "`maintenance_stage'/`native_file'", replace
        }
        }
    }
    display as text "Worker and native preservation check return code: `worker_rc'"
    log close maintenance
    local io_rc 0
    local publication_done 0
    python:
try:
    if Macro.getLocal("worker_rc") != "0":
        raise RuntimeError("Worker or observation-level preservation check failed; accepted files were not replaced.")
    if json.loads((_aju_lock / "owner.json").read_text()) != _aju_owner:
        Macro.setLocal("manual_recovery", "1")
        raise RuntimeError("Publication lock ownership changed.")
    if _aju_inventory(_aju_live, _aju_reads) != _aju_before:
        raise RuntimeError("A live input/output changed during staging; review instead of replacing it.")
    # Canonicalize only newly written receipt paths; leave data/score values alone.
    for path in _aju_stage.rglob("*manifest.json"):
        rel = path.relative_to(_aju_stage)
        live = _aju_live / rel
        if live.is_file() and _aju_hash(path) == _aju_hash(live):
            continue
        def canonical(value):
            if isinstance(value, str):
                return value.replace(_aju_stage.as_posix() + "/", _aju_live.as_posix() + "/").replace(str(_aju_stage) + os.sep, str(_aju_live) + os.sep)
            if isinstance(value, dict):
                return {canonical(k): canonical(v) for k, v in value.items()}
            if isinstance(value, list):
                return [canonical(v) for v in value]
            return value
        doc = json.loads(path.read_text(encoding="utf-8"))
        corrected = canonical(doc)
        for field in ("input_sha256", "product_sha256", "preserved_sha256", "protected_inputs_before_after"):
            for recorded, expected in list(corrected.get(field, {}).items()):
                target = _aju_pin_path(_aju_stage, recorded)
                if target is not None:
                    rel_native = target.relative_to(_aju_stage).as_posix()
                    if rel_native in _aju_native_generated and expected == _aju_native_generated[rel_native]:
                        corrected[field][recorded] = _aju_hash(target)
        if corrected != doc:
            path.write_text(json.dumps(corrected, ensure_ascii=False, indent=2), encoding="utf-8")
    _aju_check_receipts(_aju_stage, Path(_aju_receipt).name)
    _aju_products = _aju_inventory(_aju_stage, _aju_units[1:])
    (_aju_stage / _aju_receipt).write_text(json.dumps(dict(
        status="VALIDATED_LOCAL_PUBLICATION_NOT_SCIENTIFIC_OR_PUBLIC_RELEASE_CLEARANCE",
        workflow=_aju_task, mode=Macro.getLocal("phase2_mode"),
        completed_utc=datetime.now(timezone.utc).isoformat(),
        product_sha256=_aju_products, prior_receipt_checks=_aju_checked,
        native_datasets_compared=int(Macro.getLocal("native_count")),
        log_path=(_aju_live / _aju_validation_log).as_posix(),
        backup_path=_aju_backup.as_posix(),
        code_sha256={p.name: _aju_hash(p) for p in Path(Macro.getGlobal("code_dir")).glob("*")
                     if p.is_file() and p.suffix in (".do", ".py", ".mjs")},
        approved_audit_change=("Deterministic crosswalk raw-geography representative only" if _aju_task == "preparation" else "None"),
        randomization_performed=False, scientific_definitions_changed=False), indent=2), encoding="utf-8")
    # Receipt last; failures restore both data and the old completion status.
    _aju_promote(_aju_live, _aju_stage, _aju_units[1:] + [_aju_units[0]], _aju_backup, _aju_lock / "journal.json")
    Macro.setLocal("publication_done", "1")
except Exception as error:
    Macro.setLocal("io_rc", "603")
    Macro.setLocal("io_error", str(error))
finally:
    if Macro.getLocal("manual_recovery") != "1":
        try:
            _aju_release_lock(_aju_lock)
        except Exception as cleanup:
            Macro.setLocal("io_rc", "603")
            Macro.setLocal("manual_recovery", "1")
            Macro.setLocal("io_error", f"Lock cleanup requires review: {cleanup}")
end
    if `io_rc' {
        display as error `"MAINTENANCE ERROR: `io_error'"'
        display as error "Publication completed=`publication_done'; inspect the generation receipt before recovery."
        display as error "Workspace/log retained at `maintenance_stage'. Keep any lock requiring manual recovery."
        exit `io_rc'
    }
    display as result "VALIDATED `workflow' OUTPUTS PUBLISHED; prior files retained in the recorded backup."
    display as text "No historical randomization, score, index, sample or model definition changed."
    exit 0
}
confirm file "${code_dir}/0 Master Code_AdvJusticeUganda.do"
confirm file "${code_dir}/2 Data Analysis_AdvJusticeUganda.do"
local analysis_data "${input_dir}/3 Coded/phase1_baseline_analysis.dta"
local selection_frame "${input_dir}/3 Coded/phase1_baseline_selected100_frame.dta"

* Baseline analysis uses official Stata commands and this external graph scheme.
* Do not install or update packages during a research run.
capture findfile scheme-plotplain.scheme
if _rc {
    display as error "Required plotplain scheme not found. See README.md; no package was installed."
    exit 601
}
local scheme_file `"`r(fn)'"'

* Publication uses only Python's standard library, called from this Stata file.
* Check the configured interpreter before starting any analytical output.
capture python: import os, tempfile; from pathlib import Path; from sfi import Macro
if _rc {
    display as error "Configure Python 3 for Stata's integration; see README.md. No software was installed."
    exit 198
}

* All master workflows share this lock while reading or replacing project inputs.
local project_busy 0
python:
from pathlib import Path
from sfi import Macro
import hashlib
_aju_project_lock = Path(Macro.getGlobal("input_dir")) / ".workflow-publication-lock"
Macro.setLocal("project_busy", "1" if _aju_project_lock.exists() else "0")
end
if `project_busy' {
    display as error "Another project workflow is active or requires recovery; inspect the project publication lock."
    exit 603
}

confirm file "`analysis_data'"
confirm file "`selection_frame'"
python:
_aju_analysis_inputs = {p: hashlib.sha256(Path(p).read_bytes()).hexdigest()
                        for p in (Macro.getLocal("analysis_data"), Macro.getLocal("selection_frame"))}
end

* Check the existing sample relationship; do not rebuild or redefine the sample.
use "`analysis_data'", clear
assert _N > 0
isid survey_record_id
isid submission_key
isid canonical_village_uid
assert analysis_sample == 1
assert consent == 1
assert inlist(selected_fvl100_observed, 0, 1)
assert p1_admin_previously_contacted == inlist(p1_admin_origin, 1, 2)
assert selected_fvl100_observed == 0 if p1_admin_previously_contacted == 1
local cohort_n = _N
quietly count if selected_fvl100_observed == 1
local observed_n = r(N)
quietly count if p1_admin_previously_contacted == 1
local legacy_n = r(N)

tempfile observed_frame_keys
keep if selected_fvl100_observed == 1
assert _N > 0
keep selected100_frame_uid
isid selected100_frame_uid
save `observed_frame_keys'

use "`selection_frame'", clear
* The historical frame has 100 units, not necessarily 100 observed interviews.
assert _N == 100
local frame_n = _N
isid selected100_frame_uid
isid canonical_village_uid
assert inlist(selected100_survey_observed, 0, 1)
assert analysis_sample == selected100_survey_observed
assert missing(submission_key) & missing(consent) if selected100_survey_observed == 0
merge 1:1 selected100_frame_uid using `observed_frame_keys'
tabulate _merge, missing
assert _N == `frame_n'
assert (_merge == 3) == selected100_survey_observed
quietly count if selected100_survey_observed == 1
assert r(N) == `observed_n'
clear

display as result "Preflight passed: coded cohort=`cohort_n'; selected frame=`frame_n'."
display as result "Observed selected interviews=`observed_n'; previous contact=`legacy_n'."
display as text "Plotplain scheme: `scheme_file'"
display as text "Output root: ${output_dir}"
if "`run_analysis'" == "0" {
    display as result "PREFLIGHT ONLY: no analytical outputs were regenerated."
    display as text "Historical randomization and preparation were not run."
    exit 0
}

* A fresh same-parent staging folder prevents stale figures and shared temp files.
* Return file-management errors to Stata explicitly, including through MCP.
local staging_rc 0
local staging_error ""
python:
from pathlib import Path
from tempfile import mkdtemp
from sfi import Macro
import os
_aju_root = Path(Macro.getGlobal("output_dir")).resolve()
_aju_lock = _aju_root / "Phase1_Baseline_Selected100_Observed.publish-lock"
_aju_lock_created = False
_aju_project_owned = False
try:
    os.mkdir(_aju_project_lock)
    _aju_project_owned = True
    if any(hashlib.sha256(Path(p).read_bytes()).hexdigest() != h for p, h in _aju_analysis_inputs.items()):
        raise RuntimeError("Coded input changed since preflight; rerun after reviewing the preparation generation.")
    os.mkdir(_aju_lock)
    _aju_lock_created = True
    _aju_stage = Path(mkdtemp(prefix="Phase1_Baseline_Selected100_Observed.stage-", dir=_aju_root))
    (_aju_stage / "logs").mkdir()
    (_aju_lock / "staging_path.txt").write_text(_aju_stage.as_posix(), encoding="utf-8")
    (_aju_project_lock / "owner.json").write_text(_aju_stage.as_posix(), encoding="utf-8")
    Macro.setLocal("project_lock", _aju_project_lock.as_posix())
    Macro.setLocal("stage_dir", _aju_stage.as_posix())
    Macro.setLocal("lock_dir", _aju_lock.as_posix())
    Macro.setLocal("published_dir", (_aju_root / "Phase1_Baseline_Selected100_Observed").as_posix())
    Macro.setLocal("backup_dir", (_aju_root / _aju_stage.name.replace(".stage-", ".backup-", 1)).as_posix())
except Exception as _aju_error:
    Macro.setLocal("staging_rc", "603")
    Macro.setLocal("staging_error", str(_aju_error))
    if _aju_lock_created:
        try:
            (_aju_lock / "staging_path.txt").unlink(missing_ok=True)
            os.rmdir(_aju_lock)
        except Exception as _aju_cleanup_error:
            Macro.setLocal("staging_error", f"{_aju_error}; inspect lock after cleanup failure: {_aju_cleanup_error}")
    if _aju_project_owned:
        (_aju_project_lock / "owner.json").unlink(missing_ok=True)
        os.rmdir(_aju_project_lock)
end
if `staging_rc' {
    display as error `"Cannot start a fresh output bundle: `staging_error'"'
    display as error "An existing lock belongs to another run or requires recovery; do not remove an active run's lock."
    exit `staging_rc'
}

capture log close baseline_master
log using "`stage_dir'/logs/phase1_baseline_master.log", ///
    text name(baseline_master)
display as text "Stata `c(stata_version)' (`c(flavor)'); OS `c(os)'."
python query
display as text "Started: `c(current_date)' `c(current_time)'"
display as text "Repository: ${git}"
display as text "Private data: ${input_dir}"
display as text "Staging folder: `stage_dir'"
display as text "Published destination: `published_dir'"
display as text "Plotplain scheme: `scheme_file'"
display as text "Cohort=`cohort_n'; frame=`frame_n'; observed=`observed_n'; previous contact=`legacy_n'."
display as text "No installations, preparation, archived scripts, or randomization."

* The child builds and validates this fresh bundle; it never publishes files.
capture noisily do "${code_dir}/2 Data Analysis_AdvJusticeUganda.do" "`stage_dir'"
local analysis_rc = _rc
if `analysis_rc' {
    display as error "BASELINE ANALYSIS FAILED: r(`analysis_rc'). Published results were not changed."
    display as error "Retained failed staging folder: `stage_dir'"
    capture log close baseline_analysis
    log close baseline_master
    erase "`lock_dir'/staging_path.txt"
    rmdir "`lock_dir'"
    erase "`project_lock'/owner.json"
    rmdir "`project_lock'"
    exit `analysis_rc'
}

display as result "ANALYSIS VALIDATED; preparing whole-folder publication."
display as text "All Stata log handles are closed before Windows directory moves."
log close baseline_master

* Same-parent renames prevent a mixture of old and new tables/figures.
* If promotion fails after moving the old bundle, restore it. Never delete it.
local publication_rc 0
local publication_error ""
local manual_recovery 0
python:
from pathlib import Path
from sfi import Macro
import os
_aju_root = Path(Macro.getGlobal("output_dir")).resolve()
_aju_stage = Path(Macro.getLocal("stage_dir")).resolve()
_aju_published = Path(Macro.getLocal("published_dir")).resolve()
_aju_backup = Path(Macro.getLocal("backup_dir")).resolve()
_aju_lock = Path(Macro.getLocal("lock_dir")).resolve()
_aju_moved_old = False
try:
    if any(p.parent != _aju_root for p in (_aju_stage, _aju_published, _aju_backup, _aju_lock)):
        Macro.setLocal("manual_recovery", "1")
        raise RuntimeError("Publication paths must be siblings inside the explicit output root.")
    if (_aju_lock / "staging_path.txt").read_text(encoding="utf-8") != _aju_stage.as_posix():
        Macro.setLocal("manual_recovery", "1")
        raise RuntimeError("Publication lock does not belong to this staging folder.")
    if not _aju_stage.is_dir() or os.path.lexists(_aju_backup):
        raise RuntimeError("Staging folder missing or recovery destination already exists.")
    if _aju_published.exists():
        if not _aju_published.is_dir():
            raise RuntimeError("Published destination is not a directory.")
        os.rename(_aju_published, _aju_backup)
        _aju_moved_old = True
    os.rename(_aju_stage, _aju_published)
except Exception as _aju_error:
    Macro.setLocal("publication_rc", "603")
    Macro.setLocal("publication_error", str(_aju_error))
    if _aju_moved_old:
        try:
            os.rename(_aju_backup, _aju_published)
        except Exception as _aju_rollback_error:
            Macro.setLocal("manual_recovery", "1")
            Macro.setLocal("publication_error", f"{_aju_error}; rollback failed: {_aju_rollback_error}")
end
if `publication_rc' {
    capture log using "`stage_dir'/logs/phase1_baseline_master.log", ///
        text append name(baseline_master)
    display as error "PUBLICATION FAILED: r(`publication_rc'). No files were copied into the published bundle."
    display as error "Staging: `stage_dir'; recovery: `backup_dir'."
    display as error `"`publication_error'"'
    if "`manual_recovery'" == "1" {
        display as error "Manual recovery required. Keep the lock and inspect both folders before recovery."
    }
    else {
        display as error "Any previous published bundle remains in place or was restored."
        erase "`lock_dir'/staging_path.txt"
        rmdir "`lock_dir'"
        erase "`project_lock'/owner.json"
        rmdir "`project_lock'"
    }
    capture log close baseline_master
    exit `publication_rc'
}

log using "`published_dir'/logs/phase1_baseline_master.log", ///
    text append name(baseline_master)
display as result "VALIDATED BASELINE BUNDLE PUBLISHED: `published_dir'"
display as text "Previous bundle retained, if it existed: `backup_dir'"
display as text "Finished: `c(current_date)' `c(current_time)'"
display as text "Execution and publication success are not scientific or public-release clearance."
log close baseline_master
erase "`lock_dir'/staging_path.txt"
rmdir "`lock_dir'"
erase "`project_lock'/owner.json"
rmdir "`project_lock'"
