/*------------------------------------------------------------------------------*
| Title:       Phase 1 baseline QA presentation assets                          |
| Project:     Advancing Justice Uganda LC training for case diversion          |
| Purpose:     Produce slide-ready figures and tables from Stata QA outputs      |
| Version:     Stata 19                                                         |
*-------------------------------------------------------------------------------*/

version 19
set more off

if `"${input_dir}"' == "" | `"${output_dir}"' == "" {
    display as error "Run the master do-file first."
    exit 198
}

local qa_dir "${input_dir}/3 Coded/Phase1_Baseline_QA"
local deck_dir "${output_dir}/Phase1_Baseline_QA_Presentation"
local asset_dir "`deck_dir'/assets"

capture mkdir `"`deck_dir'"'
capture mkdir `"`asset_dir'"'

foreach f in phase1_baseline_dq_check_summary.dta phase1_baseline_dq_issues.dta ///
    phase1_baseline_dq_record_flags.dta phase1_baseline_dq_tagged.dta {
    capture confirm file `"`qa_dir'/`f'"'
    if _rc {
        display as error "Required QA file missing: `qa_dir'/`f'"
        exit 601
    }
}

*------------------------------------------------------------------------------*
**# 1. Overall issue severity
*------------------------------------------------------------------------------*

use `"`qa_dir'/phase1_baseline_dq_issues.dta"', clear
contract severity, freq(issue_rows)
gen byte severity_order = .
replace severity_order = 1 if severity == "ERROR"
replace severity_order = 2 if severity == "WARNING"
replace severity_order = 3 if severity == "INFO"
sort severity_order
export delimited using `"`asset_dir'/issue_severity.csv"', replace

twoway ///
    (bar issue_rows severity_order if severity == "ERROR", horizontal barwidth(.62) color("#B23A48")) ///
    (bar issue_rows severity_order if severity == "WARNING", horizontal barwidth(.62) color("#E09F3E")) ///
    (bar issue_rows severity_order if severity == "INFO", horizontal barwidth(.62) color("#587B7F")) ///
    (scatter severity_order issue_rows, msymbol(none) mlabel(issue_rows) mlabposition(3) mlabcolor("#172A3A") mlabsize(medsmall)), ///
    ylabel(1 "Errors" 2 "Warnings" 3 "Information", angle(horizontal) labsize(medsmall)) ///
    xlabel(0(25)175, labsize(small) grid glcolor("#E7ECEF")) ///
    xscale(range(0 185)) xtitle("Record × issue rows", size(small)) ytitle("") ///
    title("The audit generated 442 review items", size(medium) color("#172A3A")) ///
    subtitle("Errors block release; warnings need adjudication", size(small)) ///
    legend(off) graphregion(color(white)) plotregion(color(white)) scheme(s2color)
graph export `"`asset_dir'/issue_severity.png"', width(2400) replace

*------------------------------------------------------------------------------*
**# 2. Failed error checks and warning checks
*------------------------------------------------------------------------------*

use `"`qa_dir'/phase1_baseline_dq_check_summary.dta"', clear
keep if severity == "ERROR" & n_issues > 0
gen str70 display_label = check_id
replace display_label = "Vacancy count missing" if check_id == "VACANCY_COUNT_MISSING"
replace display_label = "Duplicate SurveyCTO village" if check_id == "DUPLICATE_SURVEY_VILLAGE"
replace display_label = "Overlapping enumerator interviews" if check_id == "ENUMERATOR_OVERLAP"
replace display_label = "Pending cases exceed 3-month caseload" if check_id == "m3_q08_GT_CASELOAD"
replace display_label = "Unlabelled enumerator code" if check_id == "VALUE_LABEL_enum"
replace display_label = "Referral barrier contradiction" if check_id == "M6_Q12_EXCLUSIVE"
replace display_label = "Record verification without record" if check_id == "M2_VERIFICATION_STRAY"
replace display_label = "ADR barrier contradiction" if check_id == "M5_Q11_EXCLUSIVE"
replace display_label = "Committee challenge contradiction" if check_id == "M8_Q15_EXCLUSIVE"
replace display_label = "Bypass reason contradiction" if check_id == "M9_Q16_EXCLUSIVE"
replace display_label = "Record count exceeds plan" if check_id == "EXPECTED_RECORD_COUNT"
gsort n_issues check_id
gen byte check_order = _n
label define error_check_lbl 1 "", replace
forvalues i = 1/`=_N' {
    local lbl = display_label[`i']
    label define error_check_lbl `i' `"`lbl'"', modify
}
label values check_order error_check_lbl
export delimited using `"`asset_dir'/failed_error_checks.csv"', replace

twoway ///
    (bar n_issues check_order, horizontal barwidth(.64) color("#B23A48")) ///
    (scatter check_order n_issues, msymbol(none) mlabel(n_issues) mlabposition(3) mlabcolor("#172A3A") mlabsize(small)), ///
    yscale(reverse) ylabel(1(1)`=_N', valuelabel angle(horizontal) labsize(small)) ///
    xlabel(0(10)100, labsize(small) grid glcolor("#E7ECEF")) xscale(range(0 102)) ///
    xtitle("Affected records", size(small)) ytitle("") ///
    title("One systematic omission dominates the error burden", size(medium) color("#172A3A")) ///
    subtitle("All 11 failed error-severity checks", size(small)) ///
    legend(off) graphregion(color(white)) plotregion(color(white)) scheme(s2color)
graph export `"`asset_dir'/failed_error_checks.png"', width(2600) replace

use `"`qa_dir'/phase1_baseline_dq_check_summary.dta"', clear
keep if severity == "WARNING" & n_issues > 0
gen str70 display_label = check_id
replace display_label = "Recent reintegration response missing" if check_id == "M11_RESPONSE_MISSING"
replace display_label = "Duration differs from timestamps" if check_id == "DURATION_TIMESTAMP_MISMATCH"
replace display_label = "Training rating present after No" if check_id == "TRAINING_RATING_STRAY"
replace display_label = "Interview shorter than 20 minutes" if check_id == "SHORT_DURATION"
replace display_label = "ADR straightlining screen" if check_id == "M5_STRAIGHTLINE"
replace display_label = "Interview longer than 120 minutes" if check_id == "LONG_DURATION"
replace display_label = "Record recency answered without records" if check_id == "M2_RECORD_UPTODATE_STRAY"
replace display_label = "Reintegration straightlining screen" if check_id == "M11_STRAIGHTLINE"
replace display_label = "Case type Other not specified" if check_id == "M1_Q14_OTHER_MISS"
replace display_label = "Materials Other not specified" if check_id == "M2_Q15_OTHER_MISS"
gsort n_issues check_id
gen byte warning_order = _n
label define warning_check_lbl 1 "", replace
forvalues i = 1/`=_N' {
    local lbl = display_label[`i']
    label define warning_check_lbl `i' `"`lbl'"', modify
}
label values warning_order warning_check_lbl
export delimited using `"`asset_dir'/failed_warning_checks.csv"', replace

twoway ///
    (bar n_issues warning_order, horizontal barwidth(.64) color("#E09F3E")) ///
    (scatter warning_order n_issues, msymbol(none) mlabel(n_issues) mlabposition(3) mlabcolor("#172A3A") mlabsize(small)), ///
    yscale(reverse) ylabel(1(1)`=_N', valuelabel angle(horizontal) labsize(small)) ///
    xlabel(0(10)90, labsize(small) grid glcolor("#E7ECEF")) xscale(range(0 94)) ///
    xtitle("Affected records", size(small)) ytitle("") ///
    title("Warnings point to instrument and timing problems", size(medium) color("#172A3A")) ///
    subtitle("All warning-severity checks with at least one issue", size(small)) ///
    legend(off) graphregion(color(white)) plotregion(color(white)) scheme(s2color)
graph export `"`asset_dir'/failed_warning_checks.png"', width(2600) replace

*------------------------------------------------------------------------------*
**# 3. Record review priority and district summary
*------------------------------------------------------------------------------*

use `"`qa_dir'/phase1_baseline_dq_record_flags.dta"', clear
preserve
    contract qa_review_priority, freq(records)
    gen byte priority_order = .
    replace priority_order = 1 if qa_review_priority == "ERROR"
    replace priority_order = 2 if qa_review_priority == "HIGH"
    replace priority_order = 3 if qa_review_priority == "REVIEW"
    replace priority_order = 4 if qa_review_priority == "PASS"
    sort priority_order
    export delimited using `"`asset_dir'/record_priority.csv"', replace

    twoway ///
        (bar records priority_order if qa_review_priority == "ERROR", horizontal barwidth(.62) color("#B23A48")) ///
        (bar records priority_order if qa_review_priority == "HIGH", horizontal barwidth(.62) color("#E09F3E")) ///
        (bar records priority_order if qa_review_priority == "REVIEW", horizontal barwidth(.62) color("#587B7F")) ///
        (bar records priority_order if qa_review_priority == "PASS", horizontal barwidth(.62) color("#3A7D44")) ///
        (scatter priority_order records, msymbol(none) mlabel(records) mlabposition(3) mlabcolor("#172A3A") mlabsize(medsmall)), ///
        ylabel(1 "Error" 2 "High review" 3 "Review" 4 "Pass", angle(horizontal) labsize(medsmall)) ///
        xlabel(0(20)140, labsize(small) grid glcolor("#E7ECEF")) xscale(range(0 145)) ///
        xtitle("Records", size(small)) ytitle("") ///
        title("Most submissions require record-level resolution", size(medium) color("#172A3A")) ///
        legend(off) graphregion(color(white)) plotregion(color(white)) scheme(s2color)
    graph export `"`asset_dir'/record_priority.png"', width(2400) replace
restore

preserve
    gen byte has_error = qa_n_errors > 0
    gen byte has_warning = qa_n_warnings > 0
    collapse (count) records=qa_row_id (sum) records_with_error=has_error ///
        records_with_warning=has_warning total_errors=qa_n_errors total_warnings=qa_n_warnings ///
        (mean) mean_duration=qa_duration_min, by(qa_district)
    gen double error_record_pct = 100 * records_with_error / records
    gen double warning_record_pct = 100 * records_with_warning / records
    export delimited using `"`asset_dir'/district_summary.csv"', replace
restore

* Anonymous enumerator monitoring summary.
preserve
    gen byte has_error = qa_n_errors > 0
    gen byte has_warning = qa_n_warnings > 0
    collapse (count) records=qa_row_id (sum) records_with_error=has_error ///
        records_with_warning=has_warning total_errors=qa_n_errors total_warnings=qa_n_warnings ///
        (p50) median_duration=qa_duration_min, by(qa_enumerator)
    sort qa_enumerator
    gen byte enumerator_order = _n
    gen str20 enumerator_id = "Enumerator " + string(enumerator_order)
    gen double error_record_pct = 100 * records_with_error / records
    export delimited using `"`asset_dir'/enumerator_summary.csv"', replace
    label define enum_anon_lbl 1 "", replace
    forvalues i = 1/`=_N' {
        local lbl = enumerator_id[`i']
        label define enum_anon_lbl `i' `"`lbl'"', modify
    }
    label values enumerator_order enum_anon_lbl
    twoway ///
        (bar error_record_pct enumerator_order, horizontal barwidth(.62) color("#4361A3")) ///
        (scatter enumerator_order error_record_pct, msymbol(none) mlabel(error_record_pct) ///
            mlabformat(%4.0f) mlabposition(3) mlabcolor("#172A3A") mlabsize(small)), ///
        yscale(reverse) ylabel(1(1)`=_N', valuelabel angle(horizontal) labsize(small)) ///
        xlabel(0(20)100, labsize(small) grid glcolor("#E7ECEF")) xscale(range(0 106)) ///
        xtitle("Records with at least one error (%)", size(small)) ytitle("") ///
        title("Error burden varies across field teams", size(medium) color("#172A3A")) ///
        subtitle("Enumerator identities anonymised for presentation", size(small)) ///
        legend(off) graphregion(color(white)) plotregion(color(white)) scheme(s2color)
    graph export `"`asset_dir'/enumerator_error_rate.png"', width(2400) replace
restore

*------------------------------------------------------------------------------*
**# 4. Interview duration diagnostics
*------------------------------------------------------------------------------*

use `"`qa_dir'/phase1_baseline_dq_tagged.dta"', clear
capture drop __*
quietly summarize qa_duration_min, detail
local duration_n = r(N)
local duration_mean = r(mean)
local duration_p50 = r(p50)
local duration_p10 = r(p10)
local duration_p90 = r(p90)
local duration_max = r(max)
quietly count if qa_duration_min < 20 & !missing(qa_duration_min)
local duration_short = r(N)
quietly count if qa_duration_min > 120 & !missing(qa_duration_min)
local duration_long = r(N)

preserve
    clear
    set obs 1
    gen long n = `duration_n'
    gen double mean_minutes = `duration_mean'
    gen double median_minutes = `duration_p50'
    gen double p10_minutes = `duration_p10'
    gen double p90_minutes = `duration_p90'
    gen double max_minutes = `duration_max'
    gen long n_under_20 = `duration_short'
    gen long n_over_120 = `duration_long'
    export delimited using `"`asset_dir'/duration_stats.csv"', replace
restore

histogram qa_duration_min if qa_duration_min <= 130, width(5) start(15) frequency ///
    fcolor("#4361A3%75") lcolor("#4361A3") ///
    xline(20, lcolor("#B23A48") lpattern(dash) lwidth(medthick)) ///
    xline(120, lcolor("#E09F3E") lpattern(dash) lwidth(medthick)) ///
    xlabel(20(20)120, labsize(small)) ylabel(, labsize(small) grid glcolor("#E7ECEF")) ///
    xtitle("Interview duration (minutes)", size(small)) ytitle("Number of interviews", size(small)) ///
    title("Most interviews lasted 30–60 minutes", size(medium) color("#172A3A")) ///
    subtitle("Dashed lines mark the 20- and 120-minute QA thresholds", size(small)) ///
    note("Three interviews exceed 120 minutes; maximum = 461.7 minutes and is outside this display.", size(vsmall)) ///
    graphregion(color(white)) plotregion(color(white)) scheme(s2color)
graph export `"`asset_dir'/duration_distribution.png"', width(2400) replace

*------------------------------------------------------------------------------*
**# 5. Lineage summary and high-level metrics
*------------------------------------------------------------------------------*

use `"`qa_dir'/phase1_baseline_dq_check_summary.dta"', clear
preserve
    keep if domain == "lineage"
    export delimited using `"`asset_dir'/lineage_checks.csv"', replace
    quietly count
    local lineage_checks = r(N)
    quietly count if n_issues > 0
    local lineage_failures = r(N)
restore

quietly count if severity == "ERROR" & n_issues > 0
local failed_error_checks = r(N)
quietly count if severity == "WARNING" & n_issues > 0
local failed_warning_checks = r(N)

use `"`qa_dir'/phase1_baseline_dq_record_flags.dta"', clear
quietly count
local source_records = r(N)
tempvar village_tag
egen byte `village_tag' = tag(qa_village_key)
quietly count if `village_tag'
local unique_villages = r(N)
quietly count if qa_n_errors > 0
local records_with_errors = r(N)
quietly count if qa_n_warnings > 0
local records_with_warnings = r(N)

use `"`qa_dir'/phase1_baseline_dq_issues.dta"', clear
quietly count if severity == "ERROR"
local error_rows = r(N)
quietly count if severity == "WARNING"
local warning_rows = r(N)
quietly count if severity == "INFO"
local info_rows = r(N)
quietly count if check_id == "DUPLICATE_SURVEY_VILLAGE"
local duplicate_records = r(N)
preserve
    keep if check_id == "DUPLICATE_SURVEY_VILLAGE"
    tempvar duplicate_key_tag
    egen byte `duplicate_key_tag' = tag(observed_value)
    quietly count if `duplicate_key_tag'
    local duplicate_keys = r(N)
restore

preserve
    clear
    set obs 1
    gen str8 release_status = "BLOCKED"
    gen long submissions = `source_records'
    gen long planned_villages = 128
    gen long unique_village_keys = `unique_villages'
    gen long extra_submissions = `source_records' - 128
    gen long duplicate_village_keys = `duplicate_keys'
    gen long duplicate_records = `duplicate_records'
    gen long failed_error_checks = `failed_error_checks'
    gen long failed_warning_checks = `failed_warning_checks'
    gen long error_issue_rows = `error_rows'
    gen long warning_issue_rows = `warning_rows'
    gen long info_issue_rows = `info_rows'
    gen long records_with_errors = `records_with_errors'
    gen long records_with_warnings = `records_with_warnings'
    gen long lineage_checks = `lineage_checks'
    gen long lineage_failures = `lineage_failures'
    export delimited using `"`asset_dir'/deck_metrics.csv"', replace
restore

display as result "QA presentation assets created in `asset_dir'."

/*******************************************************************************
End of file
*******************************************************************************/
