/*------------------------------------------------------------------------------*
| Title:       Quick alternative-outcome baseline regression                    |
| Project:     Advancing Justice Uganda LC training for case diversion          |
| Outcome:     Record-quality index (0-1)                                       |
| Purpose:     District-adjusted descriptive origin comparison                  |
| Version:     Stata 19                                                         |
*-------------------------------------------------------------------------------*/

version 19
set more off

if `"${input_dir}"' == "" | `"${output_dir}"' == "" {
    display as error "Run the master do-file first so input_dir and output_dir are defined."
    exit 198
}

local analysis_data "${input_dir}/3 Coded/phase1_baseline_analysis.dta"
local quick_dir "${output_dir}/Phase1_Baseline_Quick_Regression"
capture mkdir `"`quick_dir'"'

capture log close quick_alt_reg
log using `"`quick_dir'/quick_record_quality_regression.log"', ///
    text replace name(quick_alt_reg)

use `"`analysis_data'"', clear

foreach v in idx_record_quality p1_admin_previously_contacted ///
    district_scto survey_village_id {
    capture confirm variable `v'
    if _rc {
        display as error "Required regression variable missing: `v'"
        log close quick_alt_reg
        exit 111
    }
}

capture drop regression_district_id
encode district_scto, gen(regression_district_id)

quietly summarize idx_record_quality if p1_admin_previously_contacted == 0, meanonly
local mean_new = r(mean)
quietly summarize idx_record_quality if p1_admin_previously_contacted == 1, meanonly
local mean_previous = r(mean)

display as text "============================================================"
display as text "QUICK ALTERNATIVE-OUTCOME REGRESSION"
display as text "Outcome: record-quality index (0-1)"
display as text "Comparison: previously contacted vs new/random villages"
display as text "District fixed effects; SEs clustered by village"
display as text "Descriptive baseline association; not a causal effect"
display as text "============================================================"
display as result "Mean, new/random villages:       " %7.4f `mean_new'
display as result "Mean, previously contacted:      " %7.4f `mean_previous'
display as result "Unadjusted mean difference:      " %7.4f (`mean_previous' - `mean_new')

noisily regress idx_record_quality i.p1_admin_previously_contacted ///
    i.regression_district_id, vce(cluster survey_village_id)

local b = _b[1.p1_admin_previously_contacted]
local se = _se[1.p1_admin_previously_contacted]
local p = 2 * ttail(e(df_r), abs(`b' / `se'))
local crit = invttail(e(df_r), .025)
local lo = `b' - `crit' * `se'
local hi = `b' + `crit' * `se'
local n = e(N)
local clusters = e(N_clust)
local r2 = e(r2)

display as text _newline "FOCAL RESULT"
display as result "Adjusted difference: " %7.4f `b' ///
    " (" %6.2f (100 * `b') " percentage points)"
display as result "Clustered SE:        " %7.4f `se'
display as result "p-value:             " %7.4f `p'
display as result "95% CI:              [" %7.4f `lo' ", " %7.4f `hi' "]"
display as result "N / village clusters: " %5.0f `n' " / " %5.0f `clusters'

preserve
clear
set obs 1
gen str40 outcome = "idx_record_quality"
gen str80 outcome_label = "Record-quality index"
gen double mean_new = `mean_new'
gen double mean_previously_contacted = `mean_previous'
gen double adjusted_difference = `b'
gen double adjusted_difference_pp = 100 * adjusted_difference
gen double clustered_se = `se'
gen double p_value = `p'
gen double ci_low = `lo'
gen double ci_high = `hi'
gen long n = `n'
gen long n_clusters = `clusters'
gen double r_squared = `r2'
export delimited using `"`quick_dir'/quick_record_quality_regression.csv"', replace
export excel using `"`quick_dir'/quick_record_quality_regression.xlsx"', ///
    sheet("result", replace) firstrow(variables)
restore

display as text _newline "Outputs written to:"
display as result `"`quick_dir'/quick_record_quality_regression.log"'
display as result `"`quick_dir'/quick_record_quality_regression.csv"'
display as result `"`quick_dir'/quick_record_quality_regression.xlsx"'

log close quick_alt_reg

