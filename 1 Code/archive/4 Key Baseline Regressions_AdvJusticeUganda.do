/*------------------------------------------------------------------------------*
| Title:       Key Phase 1 baseline regressions and coefficient plot            |
| Project:     Advancing Justice Uganda LC training for case diversion          |
| Purpose:     District-adjusted descriptive origin comparisons                 |
| Version:     Stata 19                                                         |
|                                                                                |
| Interpretation: These are baseline associations and are not causal estimates. |
| The focal coefficient is the adjusted mean difference between administratively|
| previously-contacted and new/randomly selected villages. Outcomes are 0-1     |
| indices; the graph reports percentage-point differences.                      |
*-------------------------------------------------------------------------------*/

version 19
set more off

if `"${input_dir}"' == "" | `"${output_dir}"' == "" {
    display as error "Run the master do-file first so input_dir and output_dir are defined."
    exit 198
}

local analysis_data "${input_dir}/3 Coded/phase1_baseline_analysis.dta"
capture confirm file `"`analysis_data'"'
if _rc {
    display as error "Analysis dataset not found: `analysis_data'"
    exit 601
}

local reg_dir "${output_dir}/Phase1_Baseline_Key_Regressions"
capture mkdir `"`reg_dir'"'

capture log close key_baseline_reg
log using `"`reg_dir'/key_baseline_regressions.log"', text replace name(key_baseline_reg)

use `"`analysis_data'"', clear

foreach v in p1_admin_previously_contacted district_scto survey_village_id {
    capture confirm variable `v'
    if _rc {
        display as error "Required regression variable missing: `v'"
        log close key_baseline_reg
        exit 111
    }
}

capture drop regression_district_id
encode district_scto, gen(regression_district_id)
label var regression_district_id "District fixed-effect identifier"

local outcomes ///
    idx_lcc_operational_capacity ///
    idx_lcc_case_handling_quality ///
    idx_lcc_legitimacy_and_norms ///
    idx_p1_base_mentor_ready_proxy

foreach y of local outcomes {
    capture confirm numeric variable `y'
    if _rc {
        display as error "Required outcome missing or nonnumeric: `y'"
        log close key_baseline_reg
        exit 111
    }
}

tempfile regression_results
tempname regpost
postfile `regpost' byte order str40 outcome str80 outcome_label long n long n_clusters ///
    double mean_new mean_previously_contacted raw_difference adjusted_difference ///
    se p_value ci_low ci_high r_squared using `regression_results', replace

local label1 "Operational capacity"
local label2 "Case-handling quality"
local label3 "Legitimacy and reintegration"
local label4 "Mentor-readiness proxy"

display as text "============================================================"
display as text "KEY PHASE 1 BASELINE REGRESSIONS"
display as text "Previously contacted vs new/randomly selected villages"
display as text "District fixed effects; standard errors clustered by village"
display as text "These are descriptive baseline associations, not causal effects."
display as text "============================================================"

local order = 0
foreach y of local outcomes {
    local ++order
    local ylab `"`label`order''"'

    quietly summarize `y' if p1_admin_previously_contacted == 0, meanonly
    local mean0 = r(mean)
    quietly summarize `y' if p1_admin_previously_contacted == 1, meanonly
    local mean1 = r(mean)
    local rawdiff = `mean1' - `mean0'

    display as text _newline "Outcome `order': `ylab'"
    noisily regress `y' i.p1_admin_previously_contacted i.regression_district_id, ///
        vce(cluster survey_village_id)

    local b = _b[1.p1_admin_previously_contacted]
    local se = _se[1.p1_admin_previously_contacted]
    local p = 2 * ttail(e(df_r), abs(`b' / `se'))
    local crit = invttail(e(df_r), .025)
    local lo = `b' - `crit' * `se'
    local hi = `b' + `crit' * `se'
    local n = e(N)
    local clusters = e(N_clust)
    local r2 = e(r2)

    display as result "Previously contacted coefficient: " %7.3f `b' ///
        " (SE " %7.3f `se' ", p=" %6.3f `p' ")"
    display as result "95% CI: [" %7.3f `lo' ", " %7.3f `hi' "]"

    post `regpost' (`order') (`"`y'"') (`"`ylab'"') (`n') (`clusters') ///
        (`mean0') (`mean1') (`rawdiff') (`b') (`se') (`p') (`lo') (`hi') (`r2')
}
postclose `regpost'

use `regression_results', clear

gen double adjusted_difference_pp = 100 * adjusted_difference
gen double ci_low_pp = 100 * ci_low
gen double ci_high_pp = 100 * ci_high
gen str3 significance = ""
replace significance = "***" if p_value < .01
replace significance = "**" if p_value >= .01 & p_value < .05
replace significance = "*" if p_value >= .05 & p_value < .10

format mean_new mean_previously_contacted raw_difference adjusted_difference se ///
    ci_low ci_high r_squared %9.3f
format p_value %9.4f
format adjusted_difference_pp ci_low_pp ci_high_pp %9.1f

order order outcome outcome_label n n_clusters mean_new mean_previously_contacted ///
    raw_difference adjusted_difference se p_value ci_low ci_high ///
    adjusted_difference_pp ci_low_pp ci_high_pp significance r_squared
sort order

save `"`reg_dir'/key_baseline_regression_results.dta"', replace
export delimited using `"`reg_dir'/key_baseline_regression_results.csv"', replace
export excel using `"`reg_dir'/key_baseline_regression_results.xlsx"', ///
    sheet("regression_results", replace) firstrow(variables)

display as text _newline "============================================================"
display as text "FOCAL COEFFICIENT SUMMARY"
display as text "Coefficients are previously contacted minus new/randomly selected."
display as text "============================================================"
list outcome_label n n_clusters mean_new mean_previously_contacted ///
    adjusted_difference se p_value ci_low ci_high significance, ///
    noobs abbreviate(32) separator(0)

twoway ///
    (rcap ci_low_pp ci_high_pp order, horizontal lcolor(navy) lwidth(medthick)) ///
    (scatter order adjusted_difference_pp, msymbol(D) mcolor(maroon) msize(medium)), ///
    yscale(reverse) ///
    ylabel(1 "Operational capacity" ///
           2 "Case-handling quality" ///
           3 "Legitimacy and reintegration" ///
           4 "Mentor-readiness proxy", angle(horizontal) labsize(small)) ///
    xline(0, lcolor(gs8) lpattern(dash)) ///
    xlabel(-15(5)15, labsize(small)) ///
    xtitle("Adjusted difference (percentage points)", size(small)) ///
    ytitle("") ///
    title("Baseline differences by prior administrative contact", size(medsmall)) ///
    subtitle("Previously contacted minus new/randomly selected villages", size(small)) ///
    note("District fixed effects; 95% CIs; SEs clustered by village. Descriptive, not causal.", size(vsmall)) ///
    legend(off) ///
    graphregion(color(white)) plotregion(color(white)) scheme(s2color)

graph export `"`reg_dir'/key_baseline_regression_coefficients.png"', width(2800) replace
graph export `"`reg_dir'/key_baseline_regression_coefficients.pdf"', replace

display as text "------------------------------------------------------------"
display as result "Regression outputs created:"
display as result `"`reg_dir'/key_baseline_regression_results.xlsx"'
display as result `"`reg_dir'/key_baseline_regression_coefficients.png"'
display as result `"`reg_dir'/key_baseline_regressions.log"'
display as text "------------------------------------------------------------"

log close key_baseline_reg

/*******************************************************************************
End of file
*******************************************************************************/
