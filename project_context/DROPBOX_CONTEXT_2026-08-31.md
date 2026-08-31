# Dropbox corpus snapshot — 31 August 2026

This is a read-only, content-aware inventory of the Advancing Justice Uganda project Dropbox. Graphify-generated conversion sidecars are excluded from the source count.

## Coverage

- User-owned files: **157**
- Total size: **213,531,493 bytes**
- Every file has a SHA-256 checksum and modification timestamp.
- Tabular and geospatial datasets receive schema profiles; archives receive member inventories; documents receive structural profiles.
- Source Dropbox files were not modified by this snapshot script.

### Files by top-level area

- `0 Admin`: 3
- `1 Literature`: 49
- `2 Design`: 14
- `3 Data`: 83
- `4 Deliverables and Presentations`: 6
- `BASELINE_RECONCILIATION_AND_ANALYTICAL_GUIDANCE_AUG2026.md`: 1
- `desktop.ini`: 1

### Files by extension

- `.pdf`: 42
- `.xlsx`: 17
- `.dta`: 16
- `.docx`: 13
- `.dbf`: 9
- `.prj`: 9
- `.shp`: 9
- `.shx`: 9
- `.cpg`: 8
- `.doc`: 5
- `.csv`: 3
- `.zip`: 3
- `.ini`: 2
- `.html`: 2
- `.pptx`: 2
- `.bib`: 1
- `.xls`: 1
- `.cst`: 1
- `.sbn`: 1
- `.sbx`: 1
- `.log`: 1
- `.txt`: 1
- `.md`: 1

### Processing status

- `document_profiled`: 57
- `schema_profiled`: 55
- `text_profiled`: 26
- `inventoried`: 16
- `archive_profiled`: 3

## Canonical August 2026 analytical context

- `BASELINE_RECONCILIATION_AND_ANALYTICAL_GUIDANCE_AUG2026.md` is the controlling project note for the revised Phase 1 baseline workflow.
- The earlier 133-record analysis is a pre-amendment release and must not be treated as the final baseline.
- The final cohort is a lineage problem, not an append/drop operation: reconcile villages, respondents, LC1 election turnover, mop-up surveys, replacements, and actual training exposure.
- Preserve every raw submission, then select exactly one valid pre-treatment record for each final intervention LC/LCC.
- The administrative election crosswalk is `3 Data/1 Raw/Secondary data/List of LCs mapped.xlsx`.
- The original survey is `3 Data/1 Raw/Primary data/Phase 1 Baseline_Runyankore_WIDE.xlsx`; the August mop-up file is `Phase 1 Baseline_Runyankore_WIDE (new submissions).csv` with 34 submissions.
- Thirteen rows are marked `VOTED OUT`; at least eight have obvious post-election re-baselines. Supersede respondent records where appropriate rather than automatically deleting villages.
- Release remains blocked until actual training dates prove each retained survey occurred before first treatment exposure.

## Required data architecture

1. Archival all-submission raw file.
2. Canonical village crosswalk.
3. Record-level lineage and supersession ledger.
4. Harmonized clean file retaining all records.
5. Final analysis file with one verified pre-treatment record per final LC/LCC.
6. Reconciliation, QA, release-status, and sample-flow outputs generated from code.

## Profile exceptions

- None.

## Machine-readable companions

- `dropbox_corpus_manifest_2026-08-31.csv`: one row per source file.
- `dropbox_corpus_profiles_2026-08-31.json`: detailed schemas, archive members, structural profiles, hashes, and timestamps.
