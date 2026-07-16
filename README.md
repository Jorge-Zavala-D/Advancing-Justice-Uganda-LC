# Advancing Justice Uganda LC

Repository for the Advancing Justice Uganda Local Council training program for petty-case diversion.

## Phase 1 baseline data quality

The standalone Stata 19 audit pipeline is [3 Baseline Data Quality_AdvJusticeUganda.do](1%20Code/3%20Baseline%20Data%20Quality_AdvJusticeUganda.do). It reads the cleaned baseline dataset, leaves all source responses unchanged, and creates:

- a release-gate status (`READY` or `BLOCKED`);
- a long record-by-issue registry in `.dta` and `.csv` formats;
- record-level review flags and a de-identified tagged analysis dataset;
- check, variable-missingness, module, enumerator, district, date, and paradata summaries;
- a multi-sheet Excel QA report and a reproducible Stata log.

Run the master do-file after setting the user paths, and switch the baseline-QA line from `if (0)` to `if (1)`. By default, outputs go to:

`$input_dir/3 Coded/Phase1_Baseline_QA`

The following globals can be set before running to override defaults:

```stata
global baseline_qa_input "path/to/phase1_baseline_clean.dta"
global baseline_qa_raw_input "path/to/Phase 1 Baseline_Runyankore_WIDE.xlsx"
global baseline_qa_output_dir "path/to/qa_outputs"
global baseline_qa_expected_n 128
global baseline_qa_expected_villages 128
global baseline_qa_field_start "18may2026"
global baseline_qa_field_end "05jun2026"
global baseline_qa_min_duration 20
global baseline_qa_max_duration 120
```

An error blocks analytical release but does not halt the audit. Correct or formally adjudicate issues outside the raw data, rerun preparation if needed, then rerun the QA pipeline.
