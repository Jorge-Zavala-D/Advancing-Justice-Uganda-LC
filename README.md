# Advancing Justice Uganda LC

Applied social-science research on Local Council training and appropriate case diversion.

## Safe master entry point

Use Stata 19. Run [0 Master Code_AdvJusticeUganda.do](<1 Code/0 Master Code_AdvJusticeUganda.do>) with explicit **absolute** repository and private Dropbox project roots. Quote paths containing spaces. No username-based paths or pre-existing globals are required.

Run these commands in Stata; Codex uses `stata_run_selection` MCP, not a shell Stata process:

```stata
* Replace the two example roots with the locations on your computer.
* Third argument 0 (or omitted): read-only preflight.
do "C:/research/Advancing-Justice-Uganda-LC/1 Code/0 Master Code_AdvJusticeUganda.do" ///
    "C:/research/Advancing-Justice-Uganda-LC" ///
    "D:/private/Legatum Uganda Advancing Justice" 0

* Third argument 1: preflight, then the existing baseline analysis.
do "C:/research/Advancing-Justice-Uganda-LC/1 Code/0 Master Code_AdvJusticeUganda.do" ///
    "C:/research/Advancing-Justice-Uganda-LC" ///
    "D:/private/Legatum Uganda Advancing Justice" 1
```

The default is deliberately preflight, not a silent no-op: it reports its status and the observed sample counts. It checks paths, the required graph scheme, unique identifiers, consent, and correspondence between observed interviews and the original selection frame. It does not write analytical outputs. It clears in-memory data; save unrelated interactive work first. Preflight also checks that Stata's Python integration can import the standard-library file-management tools.

The analysis branch calls only `2 Data Analysis_AdvJusticeUganda.do`, passing a fresh staging folder. The analysis file refuses a direct call without that master-supplied staging path. It propagates an analytical failure as a nonzero Stata return code. It **never calls Data Preparation, archived scripts, Phase 2 frame builders, or randomization**. Historical sampling is frozen.

An optional fourth argument selects an **existing** alternative output root. Use it to validate without replacing accepted outputs:

```stata
do "C:/research/Advancing-Justice-Uganda-LC/1 Code/0 Master Code_AdvJusticeUganda.do" ///
    "C:/research/Advancing-Justice-Uganda-LC" ///
    "D:/private/Legatum Uganda Advancing Justice" 1 ///
    "D:/private/validation-output"
```

The master leaves Stata's working directory at the repository root and sets `git`, `dropbox`, `input_dir`, `code_dir`, and `output_dir` from these arguments. Other session settings or globals are not a source of project paths.


## Baseline preparation and Phase 2 publication

The optional fifth master argument selects one of the existing research tasks:

| Task | Work executed | Published units in private Dropbox |
|---|---|---|
| `preparation` | Existing Phase 1 baseline block only | Five working datasets, two coded datasets, reconciliation workbook/status, validation log and generation receipt |
| `phase2_admin` | Geography-only snapshots, existing administrative Python build, existing Stata checks | Administrative-source snapshot folder, administrative-frame folder, validation log and receipt |
| `phase2_geo` | Existing geographic mode supplied as argument six | Geographic-source folder, geographic-frame folder, shared census workbook, validation log and receipt |

Third argument `0` performs preflight without replacing research files; it briefly holds the common project lock. Third argument `1` explicitly runs the selected task. Use Stata MCP for all Codex execution. Save unrelated in-memory work first.

`phase2_geo` accepts only the existing modes: `build`, `acquire`, `reconcile`, `neighbors`, `auditfix`, `coverage`, `verification`, `official`. Modes retain their existing scientific roles. `acquire` is source acquisition, not a claim that new sources have been integrated or that the RCT frame is released. Direct calls to the three `.do` children or writing CLI invocations of the two Python companions refuse a non-workspace root.

Example commands (replace all placeholder paths, including the existing Python runtime):

```stata
local repo "C:/research/Advancing-Justice-Uganda-LC"
local data "C:/private/Legatum Uganda Advancing Justice"
local pdf_python "C:/tools/research-python/python.exe"

* Preflight baseline preparation; use 1 to run and publish after validation.
do "`repo'/1 Code/0 Master Code_AdvJusticeUganda.do" "`repo'" "`data'" 0 "" "preparation"

* Existing administrative build and native checks.
do "`repo'/1 Code/0 Master Code_AdvJusticeUganda.do" "`repo'" "`data'" 1 "" "phase2_admin" "" "`pdf_python'"

* Current received UBOS/MoLG integration and native neighbor-frame checks.
do "`repo'/1 Code/0 Master Code_AdvJusticeUganda.do" "`repo'" "`data'" 1 "" "phase2_geo" "official"
```

### Maintenance safeguards and recovery

All master workflows share the private `3 Data/.workflow-publication-lock/`; analysis also retains its output-bundle lock. An active lock is never stolen. Existing data/product receipt hashes are checked before writes. A stale receipt, changed input, altered live file, failed native check or failed child stops promotion; there is no silent re-pinning or substitute sample.

Maintenance uses a full private temporary copy of the needed project data/deliverables, not hard links to live files. This can require several GB and must be on the same filesystem as Dropbox. Temporary files are not placed in GitHub or synchronized as new Dropbox inputs. Raw-source downloads, native conversions and workbook edits occur only in this workspace.

Before promotion, the master compares existing native datasets exactly, aligning on a validated unique key where available; coordinate tables without a unique listed key are compared in their existing order. Identical native data retain the accepted file bytes, avoiding timestamp-only checksum churn. The approved crosswalk exception concerns only `subcounty_scto`, `parish_scto` and `village_scto`: they now come deterministically from the earliest wave/source row, with submission key breaking ties. Canonical geography, the analytical observation, scores, indices and sample rules do not change.

Only explicit owned files/folders are promoted. Logs are closed first. The old generation receipt is removed from the current path before replacement; the new receipt is installed last. Prior files are retained under `3 Data/.publication-backup-<run identifier>/`. Ordinary partial-promotion failure restores all old units and status. A bounded retry handles transient lock-directory cleanup; persistent cleanup failure reports whether promotion had already completed.

Maintenance completion receipts are `3 Data/preparation_publication.json`, `phase2_admin_publication.json` and `phase2_geo_publication.json`; the corresponding `*_validation.log` is durable in `3 Data/`. A receipt records current products, code hashes, comparison count, backup location and validation time. It is not a public-release or scientific-validity seal. Cached website retrieval dates are retained rather than relabeled as today's date on a rerun.

Multiple renames are **not power-loss atomic**. During publication, readers must honor the project lock. After interruption, do not trust an old READY line or remove the lock blindly. Confirm no process remains active; inspect `owner.json` and `journal.json`, the workspace, current units and backup. Recover the entire planned unit set consistently before clearing the lock. Unknown ownership or failed rollback retains the lock for manual review. Backups and failed workspaces are not automatically deleted.

Replay of an earlier geographic milestone is not permission to invalidate later accepted receipts. If an older-mode rebuild would alter an accepted downstream prerequisite, the final receipt check blocks publication pending an explicit coordinated review. Current LC boundary certification, mentor assessment/eligibility, ownership rules and treatment assignment remain separate decisions. No task here randomizes villages.


## Inputs and sample interpretation

Required private files, relative to the Dropbox project root:

- `3 Data/3 Coded/phase1_baseline_analysis.dta`: current reconciled interview cohort.
- `3 Data/3 Coded/phase1_baseline_selected100_frame.dta`: original 100-unit selection frame, including rows without an observed interview.

The current audited files contain 130 reconciled interviews, including 93 observed interviews from the original selection frame and 22 previous-contact records used in the existing comparison analysis. The frame has 100 rows, not 100 observed interviews. The master derives observed counts from the files; it does not manufacture interviews or select observations to reach a target N.

The default analysis workflow reproduces results **from the existing coded inputs**. Explicit maintenance workflows below stage baseline preparation or Phase 2 work separately. Never execute the historical sampling block to refresh baseline results. Scoring, index construction, identity decisions and substantive sample changes still require approval.

## Environment and dependencies

Statistical calculations use official Stata 19 commands plus the external `plotplain` graph scheme. Configure Python 3.11 or newer for the maintenance publisher and existing Phase 2 companions (tested integration: Python 3.11.15). Folder operations use only Python's standard library; no survey scoring or baseline statistics are delegated to Python. Check configuration with `python query`. The administrative task also requires an explicitly supplied existing PDF/Excel Python runtime with `pypdf`, `pdfplumber` and `openpyxl`; no package installation is added by this task. The geographic companion retains its existing pinned GIS-worker route. A completely frozen/offline dependency distribution remains separate work.

For a new machine, obtain the approved `plotplain` files separately from the Stata Journal `gr0070` package and retain their provenance. Do not substitute a different scheme silently. The installed scheme inspected on 1 November 2026 has header `version 1.1 24dec2014`, includes Stata's `s1mono`, and has SHA-256:

```text
f38a3177f83363a5dea515791baee49e8a7a26ff88b15c8d977371e3abb9433d
```

This records the inspected file; the master currently checks availability, not this hash. More than one installed copy may exist, so retain the resolved path recorded by preflight and the master log. A fully frozen dependency distribution is not yet part of the release. Historical community packages in `1 Code/ado/` are retained for research history and are not automatically installed or selected by the new master.

## Denominators

Long-format summary tables already report an item-specific `n`. The nine wide grouped summary tables now report `n_*` separately for each measure, instead of using one index's N for the entire row. The executive workbook's `denominator_dictionary` maps each count column to its exact measure, statistic, grouping and source workbook/sheet; it also resolves count names truncated to Stata's 32-character limit.

An item N counts **nonmissing analyzed values under the unchanged construction rules**. It is not necessarily the number eligible for a raw question, the number answering every index component, or the number of records inspected. Existing structural zeros, unknown-code handling and available-component aggregation are not changed by this reporting correction. Multiple-response shares remain shares of responding chairpersons, not shares of cases.

Figure labels/notes report the applicable item or pairwise N. The four already-plotted vignette scenario means and their Ns are also exported in `vignette_scenarios`; no scenario definition or weight was changed.

## Safe output publication

An explicit analysis run builds a fresh, uniquely named sibling folder:

`Phase1_Baseline_Selected100_Observed.stage-<run identifier>/`

All six workbooks, figures and both logs are constructed there. There is no shared Excel/figure output folder in Stata's temporary directory. Analysis validates its indices and required artifacts before returning to the master.

The master holds an exclusive `Phase1_Baseline_Selected100_Observed.publish-lock/` directory for the run. After closing the logs, it moves any existing complete bundle to a unique `.backup-<run identifier>/` sibling and promotes the validated stage by same-parent directory renames. Ordinary promotion failure restores the previous bundle and returns an error; it does not copy a partial set of files into the current bundle. File operations are explicit in the master and use [Python's standard-library rename operation](https://docs.python.org/3.11/library/os.html#os.rename) through Stata.

The two renames are **not a single crash-atomic transaction**. There can be a brief absence of the current path between them. A power loss or failed rollback leaves the old bundle recoverable under its backup name and leaves the lock for manual review. The code does not automatically delete backups or abandoned stages.

Before recovering an abandoned lock, confirm that no run is active, read its `staging_path.txt`, and inspect the master log and current/stage/backup folders. If the current path is absent, restore the appropriate complete backup before rerunning. Never remove an active run's lock or guess between versions. Transient, lock and backup folders under the standard `2 Output/` root are excluded by `.gitignore`; the current published bundle is not excluded.

Failure diagnostics remain in the failed staging folder. The published log still belongs to the previous successful generation; its older completion line does not mean the latest failed attempt succeeded. Local output publication is not authorization to distribute results or data publicly.

## Outputs and execution records

Default output root: `2 Output/` in the repository. The analysis produces:

`Phase1_Baseline_Selected100_Observed/`

| Location | Contents |
|---|---|
| `tables/phase1_baseline_executive_results.xlsx` | Main descriptive/domain tables |
| `tables/phase1_baseline_all_item_tabulations.xlsx` | Supplementary item tabulations |
| `tables/phase1_baseline_origin_comparison.xlsx` | Existing administrative-origin comparisons |
| `tables/phase1_baseline_regression_results.xlsx` | Existing adjusted and multivariable associations |
| `tables/phase1_baseline_indicator_table.xlsx` | Survey benchmarks and formal-indicator crosswalk |
| `tables/phase1_baseline_jlos_expanded_analysis.xlsx` | Expanded referral/JLOS tables |
| `figures/` | Existing baseline PNG/PDF figure library |
| `logs/phase1_baseline_master.log` | Environment, paths, sample counts, analytical execution and completion/failure |
| `logs/phase1_baseline_executive_analysis.log` | Detailed analysis log |

An explicit successful analysis run replaces the **whole validated bundle** in the selected output root and retains the previous bundle as a recoverable backup. A preflight does not. Named logs keep the master and detailed analysis records open independently. Runtime depends on the machine; the dated audit records the observed validation rather than promising a universal runtime.

## Separate and historical workflows

| Script | Boundary |
|---|---|
| `1 Data Preparation_AdvJusticeUganda.do` | Master `preparation`: baseline block only; historical construction/sampling is retained but never executed |
| `5 Phase2_Administrative_Frame.do` | Master `phase2_admin`: staged snapshots, existing census build and native validation |
| `6 Phase2_Geospatial_Frame.do` | Master `phase2_geo` plus existing mode: staged geographic/candidate-neighbor work; never randomization |
| `1 Code/archive/` | Historical QA, regression and presentation scripts; not current release gates |

The old archived QA expectations of 128 observations and BLOCKED/READY logic are not the authority for the current selected-frame analysis.

## Access, release status, and remaining work

Private survey inputs and restricted LC1 geography remain outside the public repository. Access to this workspace is not permission to redistribute data, geographic products, or internal correspondence.

Successful execution is **not scientific or public-release clearance**. The [1 November audit](project_context/STATA_RESEARCH_CODE_AUDIT_2026-11-01.md) records measurement/missingness questions, disclosure review and dependency/reproduction limits. Publication safeguards now cover baseline preparation and both Phase 2 entry points as well as baseline analysis. They do not authorize scoring, index, sample, linkage-policy or randomization changes. The sole approved audit-data correction is a deterministic raw-geography representative in the village crosswalk; it does not select an analytical respondent.
