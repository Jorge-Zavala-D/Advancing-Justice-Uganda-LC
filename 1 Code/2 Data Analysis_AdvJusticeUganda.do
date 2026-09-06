/*------------------------------------------------------------------------------*
| Title: 			Data Analysis												|
| Project: 			Advancing Justice Uganda LC training RCT				   	|
| Authors:			Jorge Zavala 												|
| 					  									                        |
|																				|
| Description:		Final Phase 1 implementation-focused baseline analysis		|
|                                                                               |
| Date created: 24/04/2026			 					                        |										          
|																			    |
| Version: Stata 13/16 	                    							 	    |
*-------------------------------------------------------------------------------*/

/*--------------------------*
*           INDEX           *
*---------------------------*


		

*-------------------------------------------------------------------------------*/

version 19
clear all
set more off


*-------------------------------*
**#		Baseline analysis		*
*-------------------------------*
*------------------------------------------------------------------------------*
**# 0. Setup
*------------------------------------------------------------------------------*

if `"${input_dir}"' == "" {
    display as error "Global input_dir is not defined. Run the master code first."
    exit 198
}
if `"${output_dir}"' == "" {
    display as error "Global output_dir is not defined. Run the master code first."
    exit 198
}

local analysis_data "${input_dir}/3 Coded/phase1_baseline_analysis.dta"

capture confirm file "`analysis_data'"
if _rc {
    display as error "Analysis dataset not found: `analysis_data'"
    exit 601
}

local exec_dir "${output_dir}/Phase1_Baseline_Executive"
local fig_dir_final "`exec_dir'/figures"
local fig_dir  "`c(tmpdir)'/phase1_baseline_figures"
local tab_dir  "`exec_dir'/tables"
local log_dir  "`exec_dir'/logs"

capture mkdir "`exec_dir'"
capture mkdir "`fig_dir'"
capture mkdir "`fig_dir_final'"
capture mkdir "`tab_dir'"
capture mkdir "`log_dir'"

local excel_exec_final   "`tab_dir'/phase1_baseline_executive_results.xlsx"
local excel_items_final  "`tab_dir'/phase1_baseline_all_item_tabulations.xlsx"
local excel_origin_final "`tab_dir'/phase1_baseline_origin_comparison.xlsx"
local excel_reg_final    "`tab_dir'/phase1_baseline_regression_results.xlsx"
local excel_ind_final    "`tab_dir'/phase1_baseline_indicator_table.xlsx"
local excel_jlos_final   "`tab_dir'/phase1_baseline_jlos_expanded_analysis.xlsx"

* Assemble multi-sheet workbooks in Stata's session directory, then publish each
* completed workbook once. This avoids intermittent Windows file contention.
local excel_exec   "`c(tmpdir)'/phase1_baseline_executive_results.xlsx"
local excel_items  "`c(tmpdir)'/phase1_baseline_all_item_tabulations.xlsx"
local excel_origin "`c(tmpdir)'/phase1_baseline_origin_comparison.xlsx"
local excel_reg    "`c(tmpdir)'/phase1_baseline_regression_results.xlsx"
local excel_ind    "`c(tmpdir)'/phase1_baseline_indicator_table.xlsx"
local excel_jlos   "`c(tmpdir)'/phase1_baseline_jlos_expanded_analysis.xlsx"

capture erase "`excel_exec'"
capture erase "`excel_items'"
capture erase "`excel_origin'"
capture erase "`excel_reg'"
capture erase "`excel_ind'"
capture erase "`excel_jlos'"
capture erase "`excel_exec_final'"
capture erase "`excel_items_final'"
capture erase "`excel_origin_final'"
capture erase "`excel_reg_final'"
capture erase "`excel_ind_final'"
capture erase "`excel_jlos_final'"

capture log close _all
log using "`log_dir'/phase1_baseline_executive_analysis.log", replace text

set scheme plotplain
graph set window fontface "Arial"

use "`analysis_data'", clear

keep if analysis_sample == 1

* Final amended two-wave baseline: fail fast if the locked cohort changes.
assert _N == 129
assert analysis_sample == 1
assert consent == 1
isid survey_record_id
isid submission_key
isid canonical_village_uid

quietly count if canonical_district == "Bushenyi"
assert r(N) == 55
quietly count if canonical_district == "Rubirizi"
assert r(N) == 40
quietly count if canonical_district == "Sheema"
assert r(N) == 34
quietly count if baseline_wave == 1
assert r(N) == 95
quietly count if baseline_wave == 2
assert r(N) == 34
quietly count if p1_admin_origin == 0
assert r(N) == 107
quietly count if p1_admin_origin == 1
assert r(N) == 17
quietly count if p1_admin_origin == 2
assert r(N) == 5
quietly count if p1_admin_previously_contacted == 1
assert r(N) == 22
assert !missing(canonical_district, canonical_subcounty, canonical_parish, canonical_village)

* Encode district for regressions/tables where needed
capture drop district_id
encode canonical_district, gen(district_id)
label var district_id "Canonical district numeric ID"

* Helpful global file paths for helper programs
global AJU_EXEC_XLSX "`excel_exec'"
global AJU_ITEMS_XLSX "`excel_items'"
global AJU_FIG_DIR   "`fig_dir'"

* Core variable lists
local core_indices ///
    idx_respondent_capacity ///
    idx_institutional_functioning ///
    idx_legal_classif_knowledge ///
    idx_adr_mediation_practice ///
    idx_referral_practice ///
    idx_record_quality ///
    idx_committee_functioning ///
    idx_perceived_legitimacy ///
    idx_safeguards ///
    idx_reintegration_norms

local composite_indices ///
    idx_lcc_operational_capacity ///
    idx_lcc_case_handling_quality ///
    idx_lcc_legitimacy_and_norms ///
    idx_p1_base_mentor_ready_proxy

local all_indices `core_indices' `composite_indices'

* Preserve an in-memory checksum of every analytical index. Analysis may summarize
* or label these variables, but must never change their values.
local index_counter = 0
foreach v of local all_indices {
    assert inrange(`v', 0, 1) if !missing(`v')
    quietly summarize `v', meanonly
    local ++index_counter
    local index_n`index_counter' = r(N)
    local index_sum`index_counter' = r(sum)
}

local high_flags ///
    high_operational_capacity ///
    high_case_handling_quality ///
    high_legitimacy_norms ///
    high_mentor_readiness_proxy

* Add compact labels for the most important indices
label var idx_respondent_capacity          "Respondent capacity"
label var idx_institutional_functioning   "Institutional functioning"
label var idx_legal_classif_knowledge     "Legal/classification knowledge"
label var idx_adr_mediation_practice      "ADR/mediation practice"
label var idx_referral_practice           "Referral practice"
label var idx_record_quality              "Record quality"
label var idx_committee_functioning       "Committee functioning"
label var idx_perceived_legitimacy        "Perceived legitimacy"
label var idx_safeguards                  "Safeguards/referral knowledge"
label var idx_reintegration_norms         "Reintegration norms"
label var idx_lcc_operational_capacity    "Operational capacity"
label var idx_lcc_case_handling_quality   "Case-handling quality"
label var idx_lcc_legitimacy_and_norms    "Legitimacy and reintegration"
label var idx_p1_base_mentor_ready_proxy  "Baseline mentor-readiness proxy"

*------------------------------------------------------------------------------*
**# 0.2 Presentation labels and output hygiene
*------------------------------------------------------------------------------*
* These labels affect output readability only. They do not change values or scoring.

capture confirm numeric variable enum
if !_rc {
    local enum_vallab : value label enum
    if "`enum_vallab'" != "" {
        capture label define `enum_vallab' 11 "Enumerator 11 - name pending", modify
    }
}

capture label var flag_caseload_30d_gt_3m "30-day caseload exceeds reported 3-month caseload"
capture label var flag_pending_gt_3m "Pending/unresolved cases exceed reported 3-month caseload"
capture label var flag_direct_gt_3m "Directly brought cases exceed reported 3-month caseload"
capture label var flag_referred_to_lcc_gt_3m "Cases referred to LCC exceed reported 3-month caseload"
capture label var flag_referred_onward_gt_3m "Cases referred onward exceed reported 3-month caseload"
capture label var lcc_vacancies_count "Number of vacant LCC/LC committee positions"
capture label var any_serious_or_sensitive_case_3m "Any child, SGBV, or other serious/sensitive case in past 3 months"

capture label var m3_q04_1  "Land or boundary disputes"
capture label var m3_q04_2  "Family or marital disputes"
capture label var m3_q04_3  "Debt, loan, or money disputes"
capture label var m3_q04_4  "Neighbor insults, threats, or verbal conflicts"
capture label var m3_q04_5  "Minor assault or physical fights"
capture label var m3_q04_6  "Property damage or theft matters"
capture label var m3_q04_7  "Child-related cases"
capture label var m3_q04_8  "Sexual violence or SGBV cases"
capture label var m3_q04_9  "Alcohol, disorderly conduct, or public disturbance"
capture label var m3_q04_10 "Reintegration/former prisoner conflicts"

capture label var v01_boundary_q1_correct "Boundary vignette: correct classification"
capture label var v01_boundary_q2_correct "Boundary vignette: correct action/referral"
capture label var v01_boundary_q3_correct "Boundary vignette: correct documentation/procedure"
capture label var v02_family_q1_correct "Family dispute vignette: correct classification"
capture label var v02_family_q2_correct "Family dispute vignette: correct action/referral"
capture label var v02_family_q3_correct "Family dispute vignette: correct documentation/procedure"
capture label var v05_child_q1_correct "Child-related vignette: correct classification"
capture label var v05_child_q2_correct "Child-related vignette: correct action/referral"
capture label var v05_child_q3_correct "Child-related vignette: correct documentation/procedure"
capture label var v06_sgbv_q1_correct "SGBV vignette: correct classification"
capture label var v06_sgbv_q2_correct "SGBV vignette: correct action/referral"
capture label var v06_sgbv_q3_correct "SGBV vignette: correct documentation/procedure"

capture label var m5_q01_score "ADR practice score: hearing both sides"
capture label var m5_q02_score "ADR practice score: neutrality/impartiality"
capture label var m5_q03_score "ADR practice score: encouraging voluntary agreement"
capture label var m5_q06_score "ADR practice score: recording agreements"
capture label var m5_q07_score "ADR practice score: follow-up after mediation"
capture label var adr_confidence_score "Confidence mediating ordinary local disputes"
capture label var deescalation_confidence_score "Confidence de-escalating tense disputes"
capture label var m5_q14_score "Reported frequency of compliance with mediated agreements"
capture label var m5_q16_score "Perceived prevention of escalation to police or courts"

capture label var m5_q11_1 "Parties refuse to attend or participate"
capture label var m5_q11_2 "Parties do not trust the LCC"
capture label var m5_q11_3 "Conflict too intense or parties too angry"
capture label var m5_q11_4 "Power imbalance between parties"
capture label var m5_q11_5 "Case outside LCC mandate"
capture label var m5_q11_6 "LCC members need more training"
capture label var m5_q11_7 "Lack of records, forms, or materials"
capture label var m5_q11_8 "Weak cooperation from formal authorities"
capture label var m5_q11_9 "Fear of retaliation or community pressure"
capture label var m5_q11_10 "No major ADR barriers"

capture label var m5_q13_1 "Mediation between parties"
capture label var m5_q13_2 "Community dialogue"
capture label var m5_q13_3 "Reconciliation meeting"
capture label var m5_q13_4 "Negotiated written agreement"
capture label var m5_q13_5 "Advice or warning to parties"
capture label var m5_q13_6 "Referral to another authority"
capture label var m5_q13_7 "Committee hearing and decision"
capture label var m5_q13_8 "Restitution or compensation agreement"

capture label var referral_frequency_score "Referral practice score: frequency/regularity"
capture label var referral_documentation_score "Referral practice score: documentation"
capture label var referral_feedback_score "Referral practice score: receiving feedback"
capture label var police_coordination_score "Coordination score with police"
capture label var court_coordination_score "Coordination score with court/formal justice actors"
capture label var referral_path_conf_score "Confidence knowing where to refer cases"
capture label var referral_explain_conf_score "Confidence explaining referrals to community members"
capture label var women_perspective_mechanism "Reported mechanism to consider women's perspectives in case handling"

capture label var m6_q04_1 "Referral reason: outside LCC mandate"
capture label var m6_q04_2 "Referral reason: serious violence/threat to life"
capture label var m6_q04_3 "Referral reason: sexual violence or SGBV"
capture label var m6_q04_4 "Referral reason: child protection concern"
capture label var m6_q04_5 "Referral reason: parties refused local mediation"
capture label var m6_q04_6 "Referral reason: local agreement not followed"
capture label var m6_q04_7 "Referral reason: facts or evidence too complex"
capture label var m6_q04_8 "Referral reason: LCC lacked quorum/capacity"

capture label var m6_q12_1 "Referral barrier: authority too far away"
capture label var m6_q12_2 "Referral barrier: transport cost/lack of transport"
capture label var m6_q12_3 "Referral barrier: parties do not want referral"
capture label var m6_q12_4 "Referral barrier: fear costs, delay, or consequences"
capture label var m6_q12_5 "Referral barrier: receiving authority slow"
capture label var m6_q12_6 "Referral barrier: unclear receiving authority"
capture label var m6_q12_7 "Referral barrier: lack referral-procedure knowledge"
capture label var m6_q12_8 "Referral barrier: lack forms/documentation tools"
capture label var m6_q12_9 "Referral barrier: pressure to keep case local"
capture label var m6_q12_10 "Referral barrier: fear retaliation/worse conflict"
capture label var m6_q12_11 "No major referral barriers"

capture label var m7_q15_1 "Record challenge: no registers/books/forms/paper"
capture label var m7_q15_2 "Record challenge: no pens/basic stationery"
capture label var m7_q15_3 "Record challenge: need training on case records"
capture label var m7_q15_4 "Record challenge: limited time for records"
capture label var m7_q15_5 "Record challenge: difficulty writing required language"
capture label var m7_q15_6 "Record challenge: record holder often unavailable"
capture label var m7_q15_7 "Record challenge: records lost/damaged/insecure"
capture label var m7_q15_8 "Record challenge: hard to record sensitive cases"
capture label var m7_q15_9 "No major record-keeping challenges"

capture label var m8_q15_1 "Committee challenge: members often absent"
capture label var m8_q15_2 "Committee challenge: members lack time"
capture label var m8_q15_3 "Committee challenge: members need training"
capture label var m8_q15_4 "Committee challenge: one member dominates"
capture label var m8_q15_5 "Committee challenge: women/junior members less active"
capture label var m8_q15_6 "Committee challenge: quorum difficult"
capture label var m8_q15_7 "Committee challenge: disagreements delay decisions"
capture label var m8_q15_8 "Committee challenge: no meeting place/materials/records"
capture label var m8_q15_9 "Committee challenge: community prefers one leader"
capture label var m8_q15_10 "No major committee challenges"

capture label var m11_q10_1 "Reintegration support: family/community acceptance"
capture label var m11_q10_2 "Reintegration support: livelihood or income"
capture label var m11_q10_3 "Reintegration support: psychosocial/emotional support"
capture label var m11_q10_4 "Reintegration support: family/community mediation"
capture label var m11_q10_5 "Reintegration support: LC/community leaders"
capture label var m11_q10_6 "Reintegration support: religious/clan/cultural leaders"
capture label var m11_q10_7 "Reintegration support: legal/administrative support"
capture label var m11_q10_8 "Reintegration support: skills training/education"
capture label var m11_q10_9 "No support needed/manage alone"

capture label var m11_q12_1 "Reintegration barrier: fear of reoffending"
capture label var m11_q12_2 "Reintegration barrier: fear of violence/conflict"
capture label var m11_q12_3 "Reintegration barrier: shame or stigma"
capture label var m11_q12_4 "Reintegration barrier: lack of trust"
capture label var m11_q12_5 "Reintegration barrier: victims/families not reconciled"
capture label var m11_q12_6 "Reintegration barrier: lack livelihood/work"
capture label var m11_q12_7 "Reintegration barrier: weak support structures"
capture label var m11_q12_8 "Reintegration barrier: people do not know how to support"
capture label var m11_q12_9 "Community usually willing to accept"


*------------------------------------------------------------------------------*
**# 0.3 Helper programs
*------------------------------------------------------------------------------*

capture program drop aju_mean_table
program define aju_mean_table
    syntax anything, SHEET(string) MODULE(string) [XLSX(string) GRAPH(string) TITLE(string) GAP]

    tempfile out
    tempname memhold
    postfile `memhold' str80 module str80 variable str160 label ///
        long n double mean sd min p25 p50 p75 max gap using `out', replace

    local clean_module "`module'"
    local rawvars `anything'

    foreach v of local rawvars {
        capture confirm numeric variable `v'
        if !_rc {
            quietly count if !missing(`v')
            local n = r(N)
            local vlab : variable label `v'
            if `"`vlab'"' == "" local vlab "`v'"
            local vlab = substr(`"`vlab'"', 1, 160)

            if `n' > 0 {
                quietly summarize `v', detail
                local mean = r(mean)
                local sd   = r(sd)
                local min  = r(min)
                local p25  = r(p25)
                local p50  = r(p50)
                local p75  = r(p75)
                local max  = r(max)
                local gapval = .
                if "`gap'" != "" & `mean' >= 0 & `mean' <= 1 local gapval = 1 - `mean'
            }
            else {
                local mean   = .
                local sd     = .
                local min    = .
                local p25    = .
                local p50    = .
                local p75    = .
                local max    = .
                local gapval = .
            }

            post `memhold' (`"`clean_module'"') (`"`v'"') (`"`vlab'"') ///
                (`n') (`mean') (`sd') (`min') (`p25') (`p50') (`p75') (`max') (`gapval')
        }
    }
    postclose `memhold'

    local outxlsx "${AJU_EXEC_XLSX}"
    if `"`xlsx'"' != "" local outxlsx `"`xlsx'"'

    preserve
        use `out', clear
        drop if n == 0
        order module variable label n mean sd min p25 p50 p75 max gap
        if "`gap'" == "" drop gap
        export excel using `"`outxlsx'"', sheet("`sheet'", replace) firstrow(variables)

        if `"`graph'"' != "" {
            quietly count if !missing(mean)
            if r(N) > 0 {
                local graphname = strtoname("`graph'")
                local graphname = substr("`graphname'", 1, 32)
                local graphtitle `"`title'"'
                if `"`graphtitle'"' == "" local graphtitle "`sheet'"

                graph hbar mean if !missing(mean), ///
                    over(label, sort(mean) descending label(labsize(vsmall))) ///
                    bar(1, color("32 87 129")) ///
                    ytitle("Share / mean") ///
                    title(`"`graphtitle'"', size(medsmall)) ///
                    name(`graphname', replace)

                graph export "${AJU_FIG_DIR}/`graph'.png", replace width(2400)
                graph export "${AJU_FIG_DIR}/`graph'.pdf", replace
            }
        }
    restore
end

capture program drop aju_tab_numeric_all
program define aju_tab_numeric_all
    syntax anything, SHEET(string)

    tempfile out
    tempname memhold
    postfile `memhold' str30 module str80 variable str200 label ///
        long n n_missing double mean sd min p25 p50 p75 max using `out', replace

    local rawvars `anything'
    foreach v of local rawvars {
        capture confirm numeric variable `v'
        if !_rc {
            quietly count
            local Ntotal = r(N)
            quietly count if !missing(`v')
            local n = r(N)
            local nmiss = `Ntotal' - `n'

            local module "Other"
            if regexm("`v'","^m0_") local module "M0 Geography/metadata"
            if regexm("`v'","^m1_") local module "M1 Respondent profile"
            if regexm("`v'","^m2_") local module "M2 Institutional setup"
            if regexm("`v'","^m3_") local module "M3 Caseload"
            if regexm("`v'","^m4_") local module "M4 Legal knowledge"
            if regexm("`v'","^m5_") local module "M5 ADR/mediation"
            if regexm("`v'","^m6_") local module "M6 Referrals"
            if regexm("`v'","^m7_") local module "M7 Records"
            if regexm("`v'","^m8_") local module "M8 Committee"
            if regexm("`v'","^m9_") local module "M9 Legitimacy"
            if regexm("`v'","^m10_") local module "M10 Safeguards"
            if regexm("`v'","^m11_") local module "M11 Reintegration"
            if regexm("`v'","^idx_") local module "Indices"
            if regexm("`v'","^flag_") local module "QA flags"

            local vlab : variable label `v'
            if `"`vlab'"' == "" local vlab "`v'"
            local vlab = substr(`"`vlab'"', 1, 200)

            if `n' > 0 {
                quietly summarize `v', detail
                post `memhold' (`"`module'"') (`"`v'"') (`"`vlab'"') ///
                    (`n') (`nmiss') (r(mean)) (r(sd)) (r(min)) (r(p25)) (r(p50)) (r(p75)) (r(max))
            }
            else {
                post `memhold' (`"`module'"') (`"`v'"') (`"`vlab'"') ///
                    (`n') (`nmiss') (.) (.) (.) (.) (.) (.) (.)
            }
        }
    }
    postclose `memhold'

    preserve
        use `out', clear
        sort module variable
        export excel using "${AJU_ITEMS_XLSX}", sheet("`sheet'", replace) firstrow(variables)
    restore
end

capture program drop aju_tab_categorical_all
program define aju_tab_categorical_all
    syntax anything, SHEET(string) [MAXLEVELS(integer 25)]

    tempfile out
    tempname memhold
    postfile `memhold' str30 module str80 variable str200 label ///
        str40 value str200 value_label long n double percent using `out', replace

    local rawvars `anything'
    foreach v of local rawvars {
        capture confirm numeric variable `v'
        if !_rc {
            quietly levelsof `v' if !missing(`v'), local(levels)
            local k : word count `levels'

            if `k' > 0 & `k' <= `maxlevels' {
                quietly count if !missing(`v')
                local denom = r(N)

                local module "Other"
                if regexm("`v'","^m0_") local module "M0 Geography/metadata"
                if regexm("`v'","^m1_") local module "M1 Respondent profile"
                if regexm("`v'","^m2_") local module "M2 Institutional setup"
                if regexm("`v'","^m3_") local module "M3 Caseload"
                if regexm("`v'","^m4_") local module "M4 Legal knowledge"
                if regexm("`v'","^m5_") local module "M5 ADR/mediation"
                if regexm("`v'","^m6_") local module "M6 Referrals"
                if regexm("`v'","^m7_") local module "M7 Records"
                if regexm("`v'","^m8_") local module "M8 Committee"
                if regexm("`v'","^m9_") local module "M9 Legitimacy"
                if regexm("`v'","^m10_") local module "M10 Safeguards"
                if regexm("`v'","^m11_") local module "M11 Reintegration"
                if regexm("`v'","^idx_") local module "Indices"
                if regexm("`v'","^flag_") local module "QA flags"

                local vlab : variable label `v'
                if `"`vlab'"' == "" local vlab "`v'"
                local vlab = substr(`"`vlab'"', 1, 200)

                local vallab : value label `v'

                foreach lev of local levels {
                    quietly count if `v' == `lev'
                    local n = r(N)
                    local pct = 100 * `n' / `denom'

                    local levlabel "`lev'"
                    if `"`vallab'"' != "" {
                        capture local levlabel : label `vallab' `lev'
                        if _rc local levlabel "`lev'"
                    }
                    local levlabel = substr(`"`levlabel'"', 1, 200)

                    post `memhold' (`"`module'"') (`"`v'"') (`"`vlab'"') ///
                        (`"`lev'"') (`"`levlabel'"') (`n') (`pct')
                }
            }
        }
    }
    postclose `memhold'

    preserve
        use `out', clear
        sort module variable value
        export excel using "${AJU_ITEMS_XLSX}", sheet("`sheet'", replace) firstrow(variables)
    restore
end

capture program drop aju_module_of_var
program define aju_module_of_var, rclass
    args v
    local module "Other"
    if regexm("`v'","^m0_") local module "M0 Geography/metadata"
    if regexm("`v'","^m1_") local module "M1 Respondent profile"
    if regexm("`v'","^m2_") local module "M2 Institutional setup"
    if regexm("`v'","^m3_") local module "M3 Caseload"
    if regexm("`v'","^m4_") local module "M4 Legal knowledge"
    if regexm("`v'","^m5_") local module "M5 ADR/mediation"
    if regexm("`v'","^m6_") local module "M6 Referrals"
    if regexm("`v'","^m7_") local module "M7 Records"
    if regexm("`v'","^m8_") local module "M8 Committee"
    if regexm("`v'","^m9_") local module "M9 Legitimacy"
    if regexm("`v'","^m10_") local module "M10 Safeguards"
    if regexm("`v'","^m11_") local module "M11 Reintegration"
    if regexm("`v'","^idx_") local module "Indices"
    if regexm("`v'","^flag_") local module "QA flags"
    return local module "`module'"
end

*------------------------------------------------------------------------------*
**# 1. README and analysis metadata
*------------------------------------------------------------------------------*

putexcel set "`excel_exec'", replace sheet("README")
putexcel A1 = "Advancing Justice Uganda - Final Phase 1 Baseline Analysis"
putexcel A3 = "Purpose"
putexcel B3 = "Implementation-focused descriptive evidence for the Phase 1 Final Baseline Report."
putexcel A4 = "Input dataset"
putexcel B4 = "`analysis_data'"
putexcel A5 = "Analysis sample"
putexcel B5 = "Final amended two-wave baseline: 129 consented, unique canonical LCs; 95 original and 34 August corrective records."
putexcel A6 = "Causal status"
putexcel B6 = "Descriptive baseline analysis only. Associations are cross-sectional and are not treatment effects."
putexcel A7 = "Mentor-readiness note"
putexcel B7 = "The baseline mentor-readiness proxy is diagnostic only; final mentor eligibility will use Phase 1 training assessments."
putexcel A8 = "Generated outputs"
putexcel B8 = "Main results, supplementary items, origin comparisons, baseline associations, indicator table, figures, and analysis log."
putexcel A9 = "Output note"
putexcel B9 = "Fully missing variables are excluded from executive tables/graphs and listed in the all-item workbook field-status sheet."

quietly count
local N = r(N)
putexcel A10 = "N records"
putexcel B10 = `N'

quietly summarize interview_date, meanonly

local first_interview = string(r(min), "%tdDDmonCCYY")
local last_interview  = string(r(max), "%tdDDmonCCYY")

putexcel A11 = "First interview date"
putexcel B11 = "`first_interview'"

putexcel A12 = "Last interview date"
putexcel B12 = "`last_interview'"
putexcel clear

* 1.1 Report-ready sample table
tempfile sample_report
tempname sr
postfile `sr' str40 section str80 measure str24 statistic double value long denominator using `sample_report', replace
post `sr' ("Final sample") ("Unique canonical LCs") ("Count") (129) (129)
foreach d in Bushenyi Rubirizi Sheema {
    quietly count if canonical_district == "`d'"
    post `sr' ("District") ("`d'") ("Count") (r(N)) (129)
    post `sr' ("District") ("`d'") ("Percent") (100*r(N)/129) (129)
}
quietly count if baseline_wave == 1
post `sr' ("Baseline wave") ("Original May/June baseline") ("Count") (r(N)) (129)
quietly count if baseline_wave == 2
post `sr' ("Baseline wave") ("August 2026 corrective") ("Count") (r(N)) (129)
foreach o in 0 1 2 {
    quietly count if p1_admin_origin == `o'
    local olab : label p1_admin_origin_lbl `o'
    post `sr' ("Administrative origin") ("`olab'") ("Count") (r(N)) (129)
}
foreach v in respondent_female completed_secondary_or_above education_score lc_experience_years prior_justice_training prior_formal_coordination prior_cdfu_fhri_training {
    quietly summarize `v'
    local vl : variable label `v'
    if `"`vl'"' == "" local vl "`v'"
    post `sr' ("Chairperson profile") (`"`vl'"') ("Mean/share") (r(mean)) (r(N))
}
postclose `sr'
preserve
    use `sample_report', clear
    format value %9.3f
    export excel using "`excel_exec'", sheet("sample_report", replace) firstrow(variables)
restore

*------------------------------------------------------------------------------*
**# 2. Sample, fieldwork, and data-quality profile
*------------------------------------------------------------------------------*

* 2.1 District, wave, and administrative-origin distribution
preserve
    contract canonical_district
    rename _freq n_records
    gen percent = 100 * n_records / _N
    quietly summarize n_records, meanonly
    replace percent = 100 * n_records / r(sum)
    export excel using "`excel_exec'", sheet("sample_district", replace) firstrow(variables)

    graph bar n_records, over(canonical_district, label(angle(0))) ///
        bar(1, color("32 87 129")) ///
        blabel(bar, format(%9.0f)) ///
        ytitle("Number of interviews") ///
        title("Final Phase 1 baseline sample by district", size(medsmall)) ///
        note("N=129 unique canonical LCs.", size(vsmall))
    graph export "`fig_dir'/fig_01_sample_by_district.png", width(2400) replace
    graph export "`fig_dir'/fig_01_sample_by_district.pdf", replace
restore

preserve
    contract baseline_wave
    rename _freq n_records
    egen total = total(n_records)
    gen percent = 100*n_records/total
    export excel using "`excel_exec'", sheet("sample_wave", replace) firstrow(variables)
restore

preserve
    contract p1_admin_origin
    rename _freq n_records
    egen total = total(n_records)
    gen percent = 100*n_records/total
    export excel using "`excel_exec'", sheet("sample_origin", replace) firstrow(variables)
restore

* 2.2 Enumerator distribution
preserve
    contract enum
    rename _freq n_records
    quietly summarize n_records, meanonly
    gen percent = 100 * n_records / r(sum)
    export excel using "`excel_exec'", sheet("sample_enumerator", replace) firstrow(variables)
restore

* 2.3 Fieldwork duration summary
preserve
    keep duration_min interview_date canonical_district
    collapse (count) n=duration_min ///
        (mean) mean=duration_min ///
        (sd) sd=duration_min ///
        (p25) p25=duration_min ///
        (p50) median=duration_min ///
        (p75) p75=duration_min ///
        (min) min=duration_min ///
        (max) max=duration_min
    export excel using "`excel_exec'", sheet("fieldwork_duration", replace) firstrow(variables)
restore

preserve
    keep canonical_district duration_min
    collapse (count) n=duration_min ///
        (mean) mean=duration_min ///
        (p50) median=duration_min ///
        (min) min=duration_min ///
        (max) max=duration_min, by(canonical_district)
    export excel using "`excel_exec'", sheet("duration_by_district", replace) firstrow(variables)
restore

* 2.4 QA flags
local qa_flags ///
    flag_duplicate_submission_key ///
    flag_duplicate_scto_village ///
    flag_duration_short ///
    flag_duration_long ///
    flag_date_outside_fieldwork ///
    flag_caseload_30d_gt_3m ///
    flag_pending_gt_3m ///
    flag_direct_gt_3m ///
    flag_referred_to_lcc_gt_3m ///
    flag_referred_onward_gt_3m ///
    flag_any_data_quality_issue

aju_mean_table `qa_flags', sheet("qa_flags") module("Data quality flags") ///
    graph("fig_13_data_quality_flags") ///
    title("Automated data-quality flags")

* 2.5 Duplicate SurveyCTO village records for follow-up
preserve
    keep if flag_duplicate_scto_village > 0
    keep survey_record_id submission_key interview_date enum canonical_district canonical_subcounty canonical_parish canonical_village ///
        duration_min
    sort canonical_district canonical_subcounty canonical_parish canonical_village interview_date
    export excel using "`excel_exec'", sheet("duplicate_villages", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 3. Executive index dashboard and mentor-readiness profile
*------------------------------------------------------------------------------*

* 3.1 Overall index summary and graph
aju_mean_table `all_indices', sheet("index_summary") module("Core and composite indices") ///
    graph("fig_02_core_indices_overall") ///
    title("Average baseline scores across core domains") gap

* Polished report-ready domain dashboard on the common 0-1 scale.
preserve
    keep `core_indices'
    gen obs_id = _n
    reshape long idx_, i(obs_id) j(index_name) string
    rename idx_ score
    gen domain = index_name
    replace domain = "Respondent capacity" if domain == "respondent_capacity"
    replace domain = "Institutional functioning" if domain == "institutional_functioning"
    replace domain = "Legal/classification knowledge" if domain == "legal_classif_knowledge"
    replace domain = "ADR/mediation practice" if domain == "adr_mediation_practice"
    replace domain = "Referral practice" if domain == "referral_practice"
    replace domain = "Record quality" if domain == "record_quality"
    replace domain = "Committee functioning" if domain == "committee_functioning"
    replace domain = "Perceived legitimacy" if domain == "perceived_legitimacy"
    replace domain = "Safeguards" if domain == "safeguards"
    replace domain = "Reintegration norms" if domain == "reintegration_norms"
    collapse (mean) mean=score, by(domain)
    graph hbar mean, over(domain, sort(mean) descending label(labsize(small))) ///
        bar(1, color("32 87 129")) blabel(bar, format(%4.2f) size(small)) ///
        yscale(range(0 1)) ylabel(0(.2)1, format(%3.1f) grid) ///
        ytitle("Mean baseline score (0-1)") ///
        title("Phase 1 baseline domain dashboard", size(medsmall)) ///
        note("N=129 unique LCs. Higher scores indicate stronger baseline capacity or practice.", size(vsmall))
    graph export "`fig_dir'/fig_02_core_indices_overall.png", width(2800) replace
    graph export "`fig_dir'/fig_02_core_indices_overall.pdf", replace
restore

* 3.2 Index means by district
preserve
    keep survey_record_id canonical_district `all_indices'
    reshape long idx_, i(survey_record_id) j(index_name) string
    rename idx_ index_value

    gen domain = index_name
    replace domain = "Respondent capacity" if domain == "respondent_capacity"
    replace domain = "Institutional functioning" if domain == "institutional_functioning"
    replace domain = "Legal/classification knowledge" if domain == "legal_classif_knowledge"
    replace domain = "ADR/mediation practice" if domain == "adr_mediation_practice"
    replace domain = "Referral practice" if domain == "referral_practice"
    replace domain = "Record quality" if domain == "record_quality"
    replace domain = "Committee functioning" if domain == "committee_functioning"
    replace domain = "Perceived legitimacy" if domain == "perceived_legitimacy"
    replace domain = "Safeguards/referral knowledge" if domain == "safeguards"
    replace domain = "Reintegration norms" if domain == "reintegration_norms"
    replace domain = "Operational capacity" if domain == "lcc_operational_capacity"
    replace domain = "Case-handling quality" if domain == "lcc_case_handling_quality"
    replace domain = "Legitimacy and reintegration" if domain == "lcc_legitimacy_and_norms"
    replace domain = "Mentor-readiness proxy" if domain == "p1_base_mentor_ready_proxy"

    collapse (count) n=index_value (mean) mean=index_value (sd) sd=index_value, by(canonical_district domain)
    export excel using "`excel_exec'", sheet("index_by_district", replace) firstrow(variables)

    keep if inlist(domain,"Operational capacity","Case-handling quality","Legitimacy and reintegration","Mentor-readiness proxy")
    graph bar mean, over(domain, label(angle(35) labsize(vsmall))) over(canonical_district) ///
        ytitle("Mean score, 0-1") ///
        title("Composite baseline domains by district", size(medsmall)) ///
        legend(off)
    graph export "`fig_dir'/fig_03_composite_indices_by_district.png", width(2800) replace
    graph export "`fig_dir'/fig_03_composite_indices_by_district.pdf", replace
restore

* 3.3 Priority gaps: highest gaps indicate domains requiring most training attention
preserve
    keep `core_indices'
    gen obs_id = _n
    reshape long idx_, i(obs_id) j(index_name) string
    rename idx_ index_value

    gen domain = index_name
    replace domain = "Respondent capacity" if domain == "respondent_capacity"
    replace domain = "Institutional functioning" if domain == "institutional_functioning"
    replace domain = "Legal/classification knowledge" if domain == "legal_classif_knowledge"
    replace domain = "ADR/mediation practice" if domain == "adr_mediation_practice"
    replace domain = "Referral practice" if domain == "referral_practice"
    replace domain = "Record quality" if domain == "record_quality"
    replace domain = "Committee functioning" if domain == "committee_functioning"
    replace domain = "Perceived legitimacy" if domain == "perceived_legitimacy"
    replace domain = "Safeguards/referral knowledge" if domain == "safeguards"
    replace domain = "Reintegration norms" if domain == "reintegration_norms"

    collapse (count) n=index_value (mean) mean=index_value (sd) sd=index_value, by(domain)
    gen gap_to_full_score = 1 - mean
    gsort -gap_to_full_score
    export excel using "`excel_exec'", sheet("priority_gaps", replace) firstrow(variables)

    graph hbar gap_to_full_score, over(domain, sort(gap_to_full_score) descending label(labsize(small))) ///
        bar(1, color("211 118 35")) blabel(bar, format(%4.2f) size(small)) ///
        yscale(range(0 1)) ylabel(0(.2)1, format(%3.1f) grid) ///
        ytitle("Gap to full score (1 - mean)") ///
        title("Priority implementation gaps at baseline", size(medsmall)) ///
        note("Larger gaps identify areas with greater baseline room for training and implementation support.", size(vsmall))
    graph export "`fig_dir'/fig_04_priority_gaps.png", width(2600) replace
    graph export "`fig_dir'/fig_04_priority_gaps.pdf", replace
restore

* 3.4 Mentor-readiness distribution
histogram idx_p1_base_mentor_ready_proxy, percent width(.05) start(0) ///
    xline(.75, lpattern(dash)) ///
    xtitle("Baseline mentor-readiness proxy, 0-1") ///
    ytitle("Percent of LC chairpersons") ///
    title("Distribution of baseline mentor-readiness proxy", size(medsmall)) ///
    note("The 0.75 line is a descriptive flag, not a final mentor eligibility rule.", size(vsmall))
graph export "`fig_dir'/fig_05_mentor_readiness_distribution.png", width(2600) replace
graph export "`fig_dir'/fig_05_mentor_readiness_distribution.pdf", replace

* 3.5 High-capacity flags
aju_mean_table `high_flags', sheet("high_capacity_flags") module("High-capacity descriptive flags") ///
    graph("fig_06_high_capacity_flags") ///
    title("Share of chairpersons above high-capacity thresholds")

* 3.6 Readiness quartiles and domain profiles
capture drop readiness_quartile
xtile readiness_quartile = idx_p1_base_mentor_ready_proxy, nq(4)
label define readiness_q 1 "Q1 lowest readiness" 2 "Q2" 3 "Q3" 4 "Q4 highest readiness", replace
label values readiness_quartile readiness_q
label var readiness_quartile "Quartile of baseline mentor-readiness proxy"

preserve
    keep readiness_quartile `all_indices' `high_flags'
    collapse (count) n=idx_p1_base_mentor_ready_proxy ///
        (mean) `all_indices' `high_flags', by(readiness_quartile)
    export excel using "`excel_exec'", sheet("readiness_quartiles", replace) firstrow(variables)
restore

* 3.7 Descriptive district differences in main indices
tempfile district_tests
tempname dt
postfile `dt' str80 outcome str160 label double p_value using `district_tests', replace
foreach v of local all_indices {
    capture confirm numeric variable `v'
    if !_rc {
        quietly regress `v' i.district_id
        quietly testparm i.district_id
        local vl : variable label `v'
        if `"`vl'"' == "" local vl "`v'"
        post `dt' (`"`v'"') (`"`vl'"') (r(p))
    }
}
postclose `dt'
preserve
    use `district_tests', clear
    export excel using "`excel_exec'", sheet("district_diff_tests", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 4. Chairperson profile and pre-training exposure
*------------------------------------------------------------------------------*

local chair_profile ///
    respondent_female ///
    completed_secondary_or_above ///
    education_score ///
    lc_experience_years ///
    lc_experience_score ///
    record_literacy_score ///
    can_record_english ///
    can_record_runyankore ///
    cannot_complete_records ///
    prior_justice_training ///
    prior_formal_coordination ///
    prior_cdfu_fhri_training ///
    n_prior_training_topics ///
    case_experience_score ///
    handled_child_or_sgbv_case ///
    weekly_lc_time_score ///
    idx_respondent_capacity

aju_mean_table `chair_profile', sheet("chair_profile") module("LC chairperson profile") ///
    graph("fig_07_chairperson_profile") ///
    title("Chairperson profile: capacity and prior exposure")

preserve
    keep canonical_district `chair_profile'
    collapse (count) n=idx_respondent_capacity (mean) `chair_profile', by(canonical_district)
    export excel using "`excel_exec'", sheet("chair_profile_district", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 5. Institutional functioning and operational readiness
*------------------------------------------------------------------------------*

local institutional_vars ///
    lcc_members_total ///
    lcc_women_members ///
    lcc_women_share ///
    lcc_has_woman_member ///
    lcc_has_vacancy ///
    lcc_vacancies_count ///
    lcc_sittings_12m ///
    meeting_frequency_score ///
    quorum_score ///
    fixed_place_score ///
    inst_record_exist_score ///
    inst_record_uptodate_score ///
    materials_score ///
    n_materials_missing ///
    record_seen_score_m2 ///
    recent_entries_uptodate_score_m2 ///
    idx_institutional_functioning

aju_mean_table `institutional_vars', sheet("institutional_function") module("Institutional functioning") ///
    graph("fig_08_institutional_functioning") ///
    title("Institutional functioning and operational readiness")

preserve
    keep canonical_district `institutional_vars'
    collapse (count) n=idx_institutional_functioning (mean) `institutional_vars', by(canonical_district)
    export excel using "`excel_exec'", sheet("institutional_by_district", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 6. Caseload and dispute profile
*------------------------------------------------------------------------------*

local caseload_vars ///
    caseload_30d ///
    caseload_3m ///
    pending_cases ///
    pending_share_3m ///
    directly_brought_cases_3m ///
    directly_brought_share_3m ///
    n_case_types_received_3m ///
    any_child_or_sgbv_case_3m ///
    any_reintegration_case_3m ///
    any_serious_or_sensitive_case_3m ///
    petty_case_share_score ///
    caseload_accuracy_score

aju_mean_table `caseload_vars', sheet("caseload_summary") module("Caseload and dispute profile") ///
    graph("fig_09_caseload_selected") ///
    title("Caseload and sensitive-case exposure")

preserve
    keep canonical_district `caseload_vars'
    collapse (count) n=caseload_3m (mean) `caseload_vars' ///
        (p50) median_caseload_3m=caseload_3m, by(canonical_district)
    export excel using "`excel_exec'", sheet("caseload_by_district", replace) firstrow(variables)
restore

histogram caseload_3m if !missing(caseload_3m), frequency discrete ///
    xtitle("Cases received in past 3 months") ///
    ytitle("Number of LC chairpersons") ///
    title("Distribution of 3-month LCC caseload", size(medsmall))
graph export "`fig_dir'/fig_10_caseload_3m_distribution.png", width(2600) replace
graph export "`fig_dir'/fig_10_caseload_3m_distribution.pdf", replace

histogram caseload_3m if !missing(caseload_3m) & caseload_3m <= 15, frequency discrete ///
    xtitle("Cases received in past 3 months") ///
    ytitle("Number of LC chairpersons") ///
    title("Distribution of 3-month LCC caseload, excluding extreme outlier", size(medsmall)) ///
    note("Zoomed to 0-15 cases so the main distribution is visible; see outlier table for high values.", size(vsmall))
graph export "`fig_dir'/fig_10b_caseload_3m_zoom.png", width(2600) replace
graph export "`fig_dir'/fig_10b_caseload_3m_zoom.pdf", replace

preserve
    keep if !missing(caseload_3m) & caseload_3m > 15
    if _N > 0 {
        keep survey_record_id submission_key interview_date enum canonical_district canonical_subcounty canonical_parish canonical_village ///
            duration_min caseload_30d caseload_3m pending_cases flag_pending_gt_3m flag_any_data_quality_issue
        gsort -caseload_3m canonical_district canonical_subcounty canonical_parish canonical_village
        export excel using "`excel_exec'", sheet("caseload_outliers", replace) firstrow(variables)
    }
    else {
        putexcel set "`excel_exec'", sheet("caseload_outliers", replace) modify
        putexcel A1 = "No observations exceeded 15 cases in the prior three months."
        putexcel clear
    }
restore

local case_type_vars ///
    m3_q04_1 m3_q04_2 m3_q04_3 m3_q04_4 m3_q04_5 ///
    m3_q04_6 m3_q04_7 m3_q04_8 m3_q04_9 m3_q04_10

aju_mean_table `case_type_vars', sheet("case_types_3m") module("Case types received in past 3 months") ///
    graph("fig_11_case_types_3m") ///
    title("Types of cases received in past 3 months")


*------------------------------------------------------------------------------*
**# 7. Legal mandate, classification, and vignette performance
*------------------------------------------------------------------------------*

local legal_vars ///
    m4_q01_local_scope_score ///
    m4_q02_referral_scope_score ///
    m4_q04_correct_refer ///
    m4_q05_documentation_score ///
    m4_q06_procedure_score ///
    m4_q07_correct_adr_scope ///
    m4_q08_authority_score ///
    classification_confidence_score ///
    idx_vignette_classification ///
    idx_safeguard_classif_know ///
    idx_legal_classif_knowledge

aju_mean_table `legal_vars', sheet("legal_knowledge") module("Legal mandate and classification knowledge") ///
    graph("fig_12_legal_knowledge") ///
    title("Legal mandate, referral, and procedural knowledge")

local vignette_vars ///
    v01_boundary_q1_correct ///
    v01_boundary_q2_correct ///
    v01_boundary_q3_correct ///
    v02_family_q1_correct ///
    v02_family_q2_correct ///
    v02_family_q3_correct ///
    v05_child_q1_correct ///
    v05_child_q2_correct ///
    v05_child_q3_correct ///
    v06_sgbv_q1_correct ///
    v06_sgbv_q2_correct ///
    v06_sgbv_q3_correct

aju_mean_table `vignette_vars', sheet("vignette_performance") module("Case-vignette performance") ///
    graph("fig_13_vignette_performance") ///
    title("Performance on case-classification vignettes")

* Report-ready scenario summary highlights child-protection and SGBV weaknesses.
preserve
    egen vignette_boundary = rowmean(v01_boundary_q1_correct v01_boundary_q2_correct v01_boundary_q3_correct)
    egen vignette_family   = rowmean(v02_family_q1_correct v02_family_q2_correct v02_family_q3_correct)
    egen vignette_child    = rowmean(v05_child_q1_correct v05_child_q2_correct v05_child_q3_correct)
    egen vignette_sgbv     = rowmean(v06_sgbv_q1_correct v06_sgbv_q2_correct v06_sgbv_q3_correct)
    keep vignette_*
    collapse (mean) vignette_*
    gen id = 1
    reshape long vignette_, i(id) j(scenario) string
    rename vignette_ mean
    replace scenario = "Boundary dispute" if scenario == "boundary"
    replace scenario = "Family dispute" if scenario == "family"
    replace scenario = "Child-protection case" if scenario == "child"
    replace scenario = "SGBV case" if scenario == "sgbv"
    graph hbar mean, over(scenario, sort(mean) descending label(labsize(small))) ///
        bar(1, color("32 87 129")) blabel(bar, format(%4.2f) size(small)) ///
        yscale(range(0 1)) ylabel(0(.2)1, format(%3.1f) grid) ///
        ytitle("Mean correct response across classification, action, and documentation (0-1)") ///
        title("Case-vignette performance", size(medsmall)) ///
        note("Sensitive cases are shown alongside ordinary disputes to identify safeguarding training needs.", size(vsmall))
    graph export "`fig_dir'/fig_13_vignette_performance.png", width(2800) replace
    graph export "`fig_dir'/fig_13_vignette_performance.pdf", replace
restore


*------------------------------------------------------------------------------*
**# 8. ADR and mediation practice
*------------------------------------------------------------------------------*

local adr_vars ///
    m5_q01_score ///
    m5_q02_score ///
    m5_q03_score ///
    m5_q06_score ///
    m5_q07_score ///
    adr_confidence_score ///
    deescalation_confidence_score ///
    n_adr_methods ///
    adr_methods_score ///
    n_adr_barriers ///
    noncomp_response_app ///
    m5_q14_score ///
    m5_q16_score ///
    idx_adr_mediation_practice

aju_mean_table `adr_vars', sheet("adr_mediation") module("ADR and mediation practice") ///
    graph("fig_14_adr_mediation") ///
    title("ADR and mediation practice")

local adr_barrier_vars ///
    m5_q11_1 m5_q11_2 m5_q11_3 m5_q11_4 m5_q11_5 ///
    m5_q11_6 m5_q11_7 m5_q11_8 m5_q11_9

aju_mean_table `adr_barrier_vars', sheet("adr_barriers") module("ADR barriers") ///
    graph("fig_15_adr_barriers") ///
    title("Reported barriers to local mediation/ADR")

local adr_method_vars ///
    m5_q13_1 m5_q13_2 m5_q13_3 m5_q13_4 ///
    m5_q13_5 m5_q13_6 m5_q13_7 m5_q13_8

aju_mean_table `adr_method_vars', sheet("adr_methods") module("ADR/local resolution methods") ///
    graph("fig_16_adr_methods") ///
    title("ADR/local resolution methods used")


*------------------------------------------------------------------------------*
**# 9. Referral practice and coordination
*------------------------------------------------------------------------------*

local referral_vars ///
    referral_frequency_score ///
    referral_documentation_score ///
    referral_feedback_score ///
    police_coordination_score ///
    court_coordination_score ///
    referral_path_conf_score ///
    referral_explain_conf_score ///
    verified_referral_record_score ///
    verified_ref_dest_score ///
    n_referral_reasons ///
    n_referral_barriers ///
    no_major_referral_barriers ///
    idx_referral_practice

aju_mean_table `referral_vars', sheet("referral_practice") module("Referral practice and coordination") ///
    graph("fig_17_referral_practice") ///
    title("Referral practice, coordination, and documentation")

local referral_reason_vars ///
    m6_q04_1 m6_q04_2 m6_q04_3 m6_q04_4 ///
    m6_q04_5 m6_q04_6 m6_q04_7 m6_q04_8

aju_mean_table `referral_reason_vars', sheet("referral_reasons") module("Reasons for referral") ///
    graph("fig_18_referral_reasons") ///
    title("Reasons LC chairpersons refer cases onward")

local referral_barrier_vars ///
    m6_q12_1 m6_q12_2 m6_q12_3 m6_q12_4 m6_q12_5 ///
    m6_q12_6 m6_q12_7 m6_q12_8 m6_q12_9 m6_q12_10 m6_q12_11

aju_mean_table `referral_barrier_vars', sheet("referral_barriers") module("Referral barriers") ///
    graph("fig_19_referral_barriers") ///
    title("Reported barriers to referral")


*------------------------------------------------------------------------------*
**# 10. Record-keeping and case management
*------------------------------------------------------------------------------*

local record_vars ///
    case_register_score ///
    record_type_breadth_score ///
    record_uptodate_score ///
    most_recent_entry_score ///
    record_fields_score ///
    outcome_recorded_score ///
    record_retrieval_score ///
    secure_storage_score ///
    records_access_open_to_community ///
    n_record_challenges ///
    no_major_record_challenges ///
    verified_case_register_score ///
    verified_proceedings_score ///
    verified_storage_score ///
    verified_record_usability_score ///
    idx_record_quality

aju_mean_table `record_vars', sheet("record_quality") module("Record-keeping and case management") ///
    graph("fig_20_record_quality") ///
    title("Record-keeping and case-management quality")

local record_challenge_vars ///
    m7_q15_1 m7_q15_2 m7_q15_3 m7_q15_4 ///
    m7_q15_5 m7_q15_6 m7_q15_7 m7_q15_8 m7_q15_9

aju_mean_table `record_challenge_vars', sheet("record_challenges") module("Record-keeping challenges") ///
    graph("fig_21_record_challenges") ///
    title("Reported record-keeping challenges")


*------------------------------------------------------------------------------*
**# 11. Committee functioning and collective decision-making
*------------------------------------------------------------------------------*

local committee_vars ///
    collective_handling_score ///
    active_member_part_score ///
    collective_discussion_score ///
    women_participation_score ///
    women_perspective_mechanism ///
    record_validation_score ///
    case_review_score ///
    decision_process_score ///
    similar_case_consistency_score ///
    procedure_confidence_score ///
    n_committee_challenges ///
    no_major_committee_challenges ///
    verified_member_part_score ///
    verified_multimember_val_score ///
    idx_committee_functioning

aju_mean_table `committee_vars', sheet("committee_function") module("Committee functioning and collective decision-making") ///
    graph("fig_22_committee_functioning") ///
    title("Committee functioning and collective decision-making")

local committee_challenge_vars ///
    m8_q15_1 m8_q15_2 m8_q15_3 m8_q15_4 m8_q15_5 ///
    m8_q15_6 m8_q15_7 m8_q15_8 m8_q15_9 m8_q15_10

aju_mean_table `committee_challenge_vars', sheet("committee_challenges") module("Committee-functioning challenges") ///
    graph("fig_23_committee_challenges") ///
    title("Reported committee-functioning challenges")


*------------------------------------------------------------------------------*
**# 12. Procedural fairness, perceived legitimacy, and bypassing
*------------------------------------------------------------------------------*

local legitimacy_vars ///
    perceived_lcc_fairness_score ///
    perc_willing_use_lcc_score ///
    bypass_frequency_score ///
    low_bypass_score ///
    perc_favor_influence_score ///
    low_favoritism_influence_score ///
    conf_trust_when_referring ///
    conf_fair_respect_score ///
    bypass_due_distrust ///
    bypass_due_bias ///
    bypass_due_enforcement ///
    bypass_due_mandate_uncertainty ///
    bypass_due_serious_case ///
    eligible_cases_rarely_bypass ///
    idx_perceived_legitimacy

aju_mean_table `legitimacy_vars', sheet("legitimacy_bypass") module("Legitimacy and bypassing") ///
    graph("fig_24_legitimacy_bypass") ///
    title("Perceived legitimacy, bypassing, and fairness risks")


*------------------------------------------------------------------------------*
**# 13. Safeguards and serious/sensitive-case handling
*------------------------------------------------------------------------------*

local safeguards_vars ///
    vulnerable_need_sh ///
    idx_safeguard_classif_know ///
    v05_child_q1_correct ///
    v05_child_q2_correct ///
    v05_child_q3_correct ///
    v06_sgbv_q1_correct ///
    v06_sgbv_q2_correct ///
    v06_sgbv_q3_correct ///
    idx_safeguards

aju_mean_table `safeguards_vars', sheet("safeguards") module("Safeguards and serious/sensitive-case handling") ///
    graph("fig_25_safeguards") ///
    title("Safeguards and serious/sensitive-case handling")


*------------------------------------------------------------------------------*
**# 14. Reintegration norms and support for formerly incarcerated persons
*------------------------------------------------------------------------------*

local reintegration_vars ///
    reintegration_importance_score ///
    reintegration_willingness_score ///
    fair_chance_reintegration_score ///
    low_exclusion_norm_score ///
    low_reoffending_stigma_score ///
    comm_role_reint_score ///
    reint_mediation_comfort ///
    connect_support_willing_score ///
    community_stigma_level_score ///
    n_reintegration_support_types ///
    reint_support_breadth_score ///
    no_reintegration_support_needed ///
    n_reintegration_barriers ///
    comm_accepts_ex_prisoner ///
    recent_reintegration_issue ///
    reint_tension_conf_score ///
    reint_referral_conf_score ///
    reint_comm_justice_role ///
    idx_reintegration_norms

aju_mean_table `reintegration_vars', sheet("reintegration_norms") module("Reintegration norms") ///
    graph("fig_26_reintegration_norms") ///
    title("Reintegration norms and support capacity")

local reint_support_vars ///
    m11_q10_1 m11_q10_2 m11_q10_3 m11_q10_4 ///
    m11_q10_5 m11_q10_6 m11_q10_7 m11_q10_8 m11_q10_9

aju_mean_table `reint_support_vars', sheet("reint_support_types") module("Reintegration support types") ///
    graph("fig_27_reintegration_support") ///
    title("Support types identified for successful reintegration")

local reint_barrier_vars ///
    m11_q12_1 m11_q12_2 m11_q12_3 m11_q12_4 ///
    m11_q12_5 m11_q12_6 m11_q12_7 m11_q12_8 m11_q12_9

aju_mean_table `reint_barrier_vars', sheet("reint_barriers") module("Reintegration barriers") ///
    graph("fig_28_reintegration_barriers") ///
    title("Perceived barriers to reintegration")


*------------------------------------------------------------------------------*
**# 15. Cross-domain correlations and diagnostic relationships
*------------------------------------------------------------------------------*

* 15.1 Correlation matrix of core and composite indices
preserve
    keep `all_indices'
    corr `all_indices'
    matrix C = r(C)
    putexcel set "`excel_exec'", sheet("index_correlation_matrix", replace) modify
    putexcel A1 = matrix(C), names
    putexcel clear
restore

* 15.2 Pairwise correlations with mentor-readiness proxy
tempfile readiness_corrs
tempname rc
postfile `rc' str80 variable str160 label long n double corr_with_readiness using `readiness_corrs', replace

foreach v of local core_indices {
    capture confirm numeric variable `v'
    if !_rc {
        quietly count if !missing(idx_p1_base_mentor_ready_proxy, `v')
        local n = r(N)
        if `n' > 2 {
            quietly corr idx_p1_base_mentor_ready_proxy `v'
            matrix R = r(C)
            local rho = R[1,2]
        }
        else {
            local rho = .
        }
        local vl : variable label `v'
        if `"`vl'"' == "" local vl "`v'"
        post `rc' (`"`v'"') (`"`vl'"') (`n') (`rho')
    }
}
postclose `rc'

preserve
    use `readiness_corrs', clear
    gsort -corr_with_readiness
    export excel using "`excel_exec'", sheet("readiness_correlations", replace) firstrow(variables)

    graph hbar corr_with_readiness, over(label, sort(corr_with_readiness) label(labsize(vsmall))) ///
        bar(1, color("63 122 120")) ///
        blabel(bar, format(%4.2f) size(vsmall)) ///
        ytitle("Correlation with mentor-readiness proxy") ///
        title("Which baseline domains move with mentor readiness?", size(medsmall)) ///
        note("Diagnostic only: the readiness proxy is mechanically constructed from several component domains.", size(vsmall))
    graph export "`fig_dir'/fig_29_readiness_correlations.png", width(2600) replace
    graph export "`fig_dir'/fig_29_readiness_correlations.pdf", replace
restore

* 15.3 Scatterplots for selected diagnostic relationships
twoway ///
    (scatter idx_p1_base_mentor_ready_proxy idx_lcc_case_handling_quality, msize(small)) ///
    (lfit idx_p1_base_mentor_ready_proxy idx_lcc_case_handling_quality), ///
    xtitle("Case-handling quality") ///
    ytitle("Mentor-readiness proxy") ///
    title("Mentor readiness and case-handling quality", size(medsmall)) ///
    legend(off)
graph export "`fig_dir'/fig_30_readiness_vs_case_handling.png", width(2400) replace
graph export "`fig_dir'/fig_30_readiness_vs_case_handling.pdf", replace

twoway ///
    (scatter idx_p1_base_mentor_ready_proxy idx_lcc_legitimacy_and_norms, msize(small)) ///
    (lfit idx_p1_base_mentor_ready_proxy idx_lcc_legitimacy_and_norms), ///
    xtitle("Legitimacy and reintegration norms") ///
    ytitle("Mentor-readiness proxy") ///
    title("Mentor readiness and legitimacy/norms", size(medsmall)) ///
    legend(off)
graph export "`fig_dir'/fig_31_readiness_vs_legitimacy_norms.png", width(2400) replace
graph export "`fig_dir'/fig_31_readiness_vs_legitimacy_norms.pdf", replace


*------------------------------------------------------------------------------*
**# 16. Complete all-item tabulations for internal evaluation team
*------------------------------------------------------------------------------*
* This workbook is intentionally broader than the main report. It gives
* Ivan/CDFU and the internal team a complete reference of item-level responses.

putexcel set "`excel_items'", replace sheet("README")
putexcel A1 = "Advancing Justice Uganda - Phase 1 baseline all-item tabulations"
putexcel A3 = "Purpose"
putexcel B3 = "Complete internal reference workbook: numeric summaries and categorical tabulations for SurveyCTO raw items and constructed analysis variables."
putexcel A4 = "Caveat"
putexcel B4 = "String/free-text notes are summarized for missingness only, not fully tabulated. Fully missing/not-fielded numeric variables are flagged in numeric_field_status."
putexcel A5 = "Input"
putexcel B5 = "`analysis_data'"
putexcel clear

* Build broad numeric variable list: raw SurveyCTO items + key constructed variables.
local all_raw_num ""
foreach pattern in ///
    consent enum attend_cdfu_training rating_cdfu_training topics_trained_* ///
    m0_* m1_* m2_* m3_* m4_* m5_* m6_* m7_* m8_* m9_* m10_* m11_* ///
    respondent_* completed_secondary_or_above education_* lc_experience_* ///
    record_literacy_score can_record_* cannot_complete_records prior_* ///
    lcc_* *_score idx_* high_* flag_* n_* *_share_* *_cases* *_case* {
        capture unab tmp : `pattern'
        if !_rc local all_raw_num `all_raw_num' `tmp'
}
local all_raw_num : list uniq all_raw_num

* Keep only numeric variables for numeric summaries/tabulations
local all_num_existing ""
foreach v of local all_raw_num {
    capture confirm numeric variable `v'
    if !_rc local all_num_existing `all_num_existing' `v'
}
local all_num_existing : list uniq all_num_existing

* Numeric field-status sheet: distinguishes complete, partially observed, and fully missing/not-fielded variables.
tempfile numeric_field_status
tempname fs
postfile `fs' str30 module str80 variable str200 label long n_nonmissing n_missing str40 status using `numeric_field_status', replace
quietly count
local Ntotal_all = r(N)
foreach v of local all_num_existing {
    quietly count if !missing(`v')
    local n_nonmiss = r(N)
    local n_missing = `Ntotal_all' - `n_nonmiss'
    local status "Complete"
    if `n_nonmiss' == 0 local status "Fully missing / not fielded"
    else if `n_nonmiss' < `Ntotal_all' local status "Partially observed"

    aju_module_of_var `v'
    local module "`r(module)'"
    local vlab : variable label `v'
    if `"`vlab'"' == "" local vlab "`v'"
    local vlab = substr(`"`vlab'"', 1, 200)

    post `fs' (`"`module'"') (`"`v'"') (`"`vlab'"') (`n_nonmiss') (`n_missing') (`"`status'"')
}
postclose `fs'

preserve
    use `numeric_field_status', clear
    sort status module variable
    export excel using "`excel_items'", sheet("numeric_field_status", replace) firstrow(variables)
restore

aju_tab_numeric_all `all_num_existing', sheet("numeric_summary_all")
aju_tab_categorical_all `all_num_existing', sheet("categorical_counts_all") maxlevels(30)

* Select-multiple / dummy-style variables: report share selected.
local dummy_candidates ""
foreach v of local all_num_existing {
    quietly summarize `v', meanonly
    if r(N) > 0 & r(min) >= 0 & r(max) <= 1 {
        local dummy_candidates `dummy_candidates' `v'
    }
}
local dummy_candidates : list uniq dummy_candidates

aju_mean_table `dummy_candidates', sheet("binary_share_all") ///
    module("Binary/dummy variables and 0-1 scores") ///
    xlsx("${AJU_ITEMS_XLSX}")

* String/free-text missingness and uniqueness summary
tempfile string_summary
tempname ss

postfile `ss' str30 module str80 variable str200 label ///
    long n_nonmissing n_missing n_unique using `string_summary', replace

ds, has(type string)
local string_vars `r(varlist)'

foreach v of local string_vars {

    quietly count
    local Ntotal = r(N)

    quietly count if !missing(`v') & itrim(strtrim(`v')) != ""
    local n_nonmiss = r(N)
    local n_missing = `Ntotal' - `n_nonmiss'

    if `n_nonmiss' == 0 {
        local n_unique = 0
    }
    else {
        preserve
            keep `v'
            keep if !missing(`v') & itrim(strtrim(`v')) != ""
            quietly duplicates drop
            quietly count
            local n_unique = r(N)
        restore
    }

    local module "String/free text"
    if regexm("`v'","^m0_")  local module "M0 Geography/metadata"
    if regexm("`v'","^m1_")  local module "M1 Respondent profile"
    if regexm("`v'","^m2_")  local module "M2 Institutional setup"
    if regexm("`v'","^m3_")  local module "M3 Caseload"
    if regexm("`v'","^m4_")  local module "M4 Legal knowledge"
    if regexm("`v'","^m5_")  local module "M5 ADR/mediation"
    if regexm("`v'","^m6_")  local module "M6 Referrals"
    if regexm("`v'","^m7_")  local module "M7 Records"
    if regexm("`v'","^m8_")  local module "M8 Committee"
    if regexm("`v'","^m9_")  local module "M9 Legitimacy"
    if regexm("`v'","^m10_") local module "M10 Safeguards"
    if regexm("`v'","^m11_") local module "M11 Reintegration"

    local vlab : variable label `v'
    if `"`vlab'"' == "" local vlab "`v'"
    local vlab = substr(`"`vlab'"', 1, 200)

    post `ss' (`"`module'"') (`"`v'"') (`"`vlab'"') ///
        (`n_nonmiss') (`n_missing') (`n_unique')
}

postclose `ss'

preserve
    use `string_summary', clear
    export excel using "`excel_items'", ///
        sheet("string_missingness", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 18. Baseline comparison: new vs previously contacted villages
*------------------------------------------------------------------------------*
* Purpose:
*   Compare key high-level baseline indicators between:
*       0 = New / randomly selected villages
*       1 = Previously contacted villages
*
* Grouping variable:
*   p1_admin_previously_contacted
*
* Source of grouping:
*   Administrative village list: Last_CDFU_phase == 1 OR Inherited_FHRI == 1.
*   This is NOT based on self-reported prior training exposure.
*
* Interpretation:
*   Descriptive baseline comparison only.
*   These differences do not identify causal effects of previous exposure.
*------------------------------------------------------------------------------*

capture confirm variable p1_admin_previously_contacted
if _rc {
    display as error "p1_admin_previously_contacted not found."
    display as error "Re-run the Data Preparation do-file after adding the administrative origin dummy block."
    exit 111
}

capture label drop p1_admin_prev_lbl
label define p1_admin_prev_lbl ///
    0 "New / randomly selected" ///
    1 "Previously contacted"
label values p1_admin_previously_contacted p1_admin_prev_lbl

label var p1_admin_previously_contacted ///
    "Administrative group: previously contacted village"

capture label define yesno 0 "No" 1 "Yes", replace

* Basic validation
display as text "------------------------------------------------------------"
display as text "Phase 1 origin comparison: validation"
display as text "------------------------------------------------------------"

tab p1_admin_previously_contacted, missing
tab canonical_district p1_admin_previously_contacted, row missing

count if p1_admin_previously_contacted == 1
display as result "Previously contacted records: " r(N)
assert r(N) == 22

count if p1_admin_previously_contacted == 0
display as result "New/randomly selected records: " r(N)
assert r(N) == 107

count if missing(p1_admin_previously_contacted)
display as result "Missing origin group records: " r(N)
if r(N) > 0 {
    display as error "WARNING: Some records are missing p1_admin_previously_contacted."
}

*-------------------------------*
**# 18.1 README and sample sheets
*-------------------------------*

putexcel set "`excel_origin'", replace sheet("README")
putexcel A1 = "Advancing Justice Uganda - Phase 1 baseline origin comparison"
putexcel A3 = "Purpose"
putexcel B3 = "Descriptive comparison of baseline indicators between new/randomly selected villages and previously contacted villages."
putexcel A4 = "Grouping variable"
putexcel B4 = "p1_admin_previously_contacted"
putexcel A5 = "Definition"
putexcel B5 = "1 if admin list marks village as Last_CDFU_phase == 1 or Inherited_FHRI == 1; 0 otherwise."
putexcel A6 = "Interpretation"
putexcel B6 = "Descriptive baseline association, not a causal effect of previous contact."
putexcel A7 = "Recommended use"
putexcel B7 = "Use as implementation diagnostics in the Phase 1 Final Baseline Report."
putexcel clear

* Sample by group
preserve
    contract p1_admin_previously_contacted, freq(n)
    egen total = total(n)
    gen share = n / total
    format share %9.3f
    decode p1_admin_previously_contacted, gen(origin_group)
    order p1_admin_previously_contacted origin_group n share
    export excel using "`excel_origin'", sheet("sample_by_origin", replace) firstrow(variables)
restore

* Sample by district and group
preserve
    contract canonical_district p1_admin_previously_contacted, freq(n)
    bysort canonical_district: egen district_total = total(n)
    gen district_share = n / district_total
    format district_share %9.3f
    decode p1_admin_previously_contacted, gen(origin_group)
    order canonical_district p1_admin_previously_contacted origin_group n district_total district_share
    export excel using "`excel_origin'", sheet("sample_by_district_origin", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 18.2 High-level variable list for final baseline comparisons
*------------------------------------------------------------------------------*
* Short local macro names are used because Stata has strict name-length limits.

local corevars ///
    idx_lcc_operational_capacity ///
    idx_lcc_case_handling_quality ///
    idx_lcc_legitimacy_and_norms ///
    idx_p1_base_mentor_ready_proxy

local domainvars ///
    idx_respondent_capacity ///
    idx_institutional_functioning ///
    idx_legal_classif_knowledge ///
    idx_adr_mediation_practice ///
    idx_referral_practice ///
    idx_record_quality ///
    idx_committee_functioning ///
    idx_perceived_legitimacy ///
    idx_safeguards ///
    idx_reintegration_norms

local jlosvars ///
    prior_formal_coordination ///
    police_coordination_score ///
    court_coordination_score ///
    referral_frequency_score ///
    referral_documentation_score ///
    referral_feedback_score ///
    verified_referral_record_score ///
    verified_ref_dest_score ///
    referral_path_conf_score ///
    referral_explain_conf_score ///
    m6_q04_1 ///
    m6_q04_2 ///
    m6_q04_3 ///
    m6_q04_4 ///
    m6_q12_1 ///
    m6_q12_2 ///
    idx_referral_practice

local recsafevars ///
    idx_record_quality ///
    case_register_score ///
    record_fields_score ///
    verified_record_usability_score ///
    n_record_challenges ///
    m7_q15_1 ///
    m7_q15_2 ///
    m7_q15_3 ///
    idx_safeguards ///
    vulnerable_need_sh ///
    idx_safeguard_classif_know ///
    v05_child_q1_correct ///
    v05_child_q2_correct ///
    v05_child_q3_correct ///
    v06_sgbv_q1_correct ///
    v06_sgbv_q2_correct ///
    v06_sgbv_q3_correct

local legreintvars ///
    idx_perceived_legitimacy ///
    perceived_lcc_fairness_score ///
    perc_willing_use_lcc_score ///
    low_bypass_score ///
    conf_trust_when_referring ///
    conf_fair_respect_score ///
    bypass_due_distrust ///
    bypass_due_bias ///
    bypass_due_enforcement ///
    idx_reintegration_norms ///
    reintegration_importance_score ///
    fair_chance_reintegration_score ///
    low_reoffending_stigma_score ///
    comm_accepts_ex_prisoner ///
    recent_reintegration_issue ///
    reint_tension_conf_score ///
    reint_referral_conf_score

local mentorvars ///
    high_operational_capacity ///
    high_case_handling_quality ///
    high_legitimacy_norms ///
    high_mentor_readiness_proxy

local contextvars ///
    lc_experience_years ///
    completed_secondary_or_above ///
    can_record_english ///
    can_record_runyankore ///
    prior_justice_training ///
    prior_cdfu_fhri_training ///
    lcc_sittings_12m ///
    lcc_has_vacancy ///
    lcc_women_share ///
    caseload_3m ///
    pending_cases ///
    any_child_or_sgbv_case_3m ///
    any_serious_or_sensitive_case_3m

local candvars ///
    `corevars' ///
    `domainvars' ///
    `jlosvars' ///
    `recsafevars' ///
    `legreintvars' ///
    `mentorvars' ///
    `contextvars'


*------------------------------------------------------------------------------*
**# 18.3 Candidate difference table
*------------------------------------------------------------------------------*
* Produces a broad comparison table with:
*   - N and mean in new villages
*   - N and mean in previously contacted villages
*   - Difference: previously contacted minus new
*   - Two-sided p-value from a simple t-test
*
* P-values are descriptive diagnostics only. No causal interpretation.
*------------------------------------------------------------------------------*

tempfile origin_diffs
tempname memhold

postfile `memhold' ///
    str40 domain ///
    str80 variable ///
    str180 label ///
    long n_new ///
    double mean_new ///
    long n_prev ///
    double mean_prev ///
    double diff_prev_minus_new ///
    double p_value ///
    double abs_diff ///
    using `origin_diffs', replace

foreach v of local candvars {

    capture confirm numeric variable `v'
    if !_rc {

local domain "Other/context"
if strpos(" `corevars' ", " `v' ") > 0 local domain "Core composites"
if strpos(" `domainvars' ", " `v' ") > 0 local domain "Domain indices"
if strpos(" `jlosvars' ", " `v' ") > 0 local domain "JLOS/referral collaboration"
if strpos(" `recsafevars' ", " `v' ") > 0 local domain "Records and safeguards"
if strpos(" `legreintvars' ", " `v' ") > 0 local domain "Legitimacy and reintegration"
if strpos(" `mentorvars' ", " `v' ") > 0 local domain "Mentor-readiness flags"

        quietly count if p1_admin_previously_contacted == 0 & !missing(`v')
        local n0 = r(N)
        quietly summarize `v' if p1_admin_previously_contacted == 0, meanonly
        local m0 = r(mean)

        quietly count if p1_admin_previously_contacted == 1 & !missing(`v')
        local n1 = r(N)
        quietly summarize `v' if p1_admin_previously_contacted == 1, meanonly
        local m1 = r(mean)

        local diff = .
        if `n0' > 0 & `n1' > 0 local diff = `m1' - `m0'

        local pval = .
        if `n0' > 1 & `n1' > 1 {
            capture quietly ttest `v', by(p1_admin_previously_contacted)
            if !_rc local pval = r(p)
        }

        local adiff = abs(`diff')

        local vlab : variable label `v'
        if `"`vlab'"' == "" local vlab "`v'"
        local vlab = substr(`"`vlab'"', 1, 180)

        post `memhold' ///
            (`"`domain'"') ///
            (`"`v'"') ///
            (`"`vlab'"') ///
            (`n0') ///
            (`m0') ///
            (`n1') ///
            (`m1') ///
            (`diff') ///
            (`pval') ///
            (`adiff')
    }
}

postclose `memhold'

preserve
    use `origin_diffs', clear

    * Remove variables with no usable comparison
    drop if missing(mean_new) & missing(mean_prev)

    format mean_new mean_prev diff_prev_minus_new p_value abs_diff %9.3f

    * Full diagnostic table
    gsort domain -abs_diff
    export excel using "`excel_origin'", sheet("final_diff_table", replace) firstrow(variables)

    * Ranked table across all domains
    gsort -abs_diff
    export excel using "`excel_origin'", sheet("ranked_abs_differences", replace) firstrow(variables)

    * Parsimonious high-level comparison table for the Final Baseline Report
    keep if inlist(domain, "Core composites", "Domain indices", "JLOS/referral collaboration", ///
        "Records and safeguards", "Legitimacy and reintegration", "Mentor-readiness flags")
    gsort -abs_diff
    export excel using "`excel_origin'", sheet("report_core_comparisons", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 18.4 Slide-ready Figure 1: Core composites by origin
*------------------------------------------------------------------------------*
* Suggested slide:
*   "Previously contacted villages start from a different baseline profile"
*------------------------------------------------------------------------------*

graph bar (mean) ///
    idx_lcc_operational_capacity ///
    idx_lcc_case_handling_quality ///
    idx_lcc_legitimacy_and_norms ///
    idx_p1_base_mentor_ready_proxy, ///
    over(p1_admin_previously_contacted, label(labsize(small))) ///
    blabel(bar, format(%4.2f) size(vsmall)) ///
    ylabel(0(.2)1, labsize(small)) ///
    ytitle("Mean score, 0-1 scale") ///
	scheme(plotplain) ///
    title("Core baseline composites by Phase 1 origin", size(medsmall)) ///
    legend(order(1 "Operational capacity" ///
                 2 "Case-handling quality" ///
                 3 "Legitimacy & reintegration" ///
                 4 "Mentor-readiness proxy") ///
           rows(2) size(vsmall)) ///
    note("Descriptive baseline comparison only; not a causal effect of previous exposure.", size(vsmall))

graph export "`fig_dir'/fig_32_origin_core_composites.png", width(2600) replace
graph export "`fig_dir'/fig_32_origin_core_composites.pdf", replace

preserve
    keep p1_admin_previously_contacted ///
        idx_lcc_operational_capacity ///
        idx_lcc_case_handling_quality ///
        idx_lcc_legitimacy_and_norms ///
        idx_p1_base_mentor_ready_proxy

    collapse (count) n=idx_p1_base_mentor_ready_proxy ///
        (mean) idx_lcc_operational_capacity ///
               idx_lcc_case_handling_quality ///
               idx_lcc_legitimacy_and_norms ///
               idx_p1_base_mentor_ready_proxy, ///
        by(p1_admin_previously_contacted)

    decode p1_admin_previously_contacted, gen(origin_group)
    order p1_admin_previously_contacted origin_group n
    export excel using "`excel_origin'", sheet("fig32_core_composites", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 18.5 Slide-ready Figure 2: JLOS collaboration and referral pathway
*------------------------------------------------------------------------------*
* JLOS = Justice, Law and Order Sector.
*
* Suggested slide:
*   "Pre-exposure differences are clearest in justice-sector collaboration"
*------------------------------------------------------------------------------*

graph bar (mean) ///
    prior_formal_coordination ///
    police_coordination_score ///
    court_coordination_score ///
    referral_path_conf_score ///
    referral_explain_conf_score ///
    referral_feedback_score ///
    verified_referral_record_score, ///
    over(p1_admin_previously_contacted, label(labsize(small))) ///
    blabel(bar, format(%4.2f) size(vsmall)) ///
    ylabel(0(.2)1, labsize(small)) ///
    ytitle("Share / mean score") ///
	scheme(plotplain) ///
    title("JLOS collaboration and referral pathway by Phase 1 origin", size(medsmall)) ///
    legend(order(1 "Prior formal coordination" ///
                 2 "Police coordination" ///
                 3 "Court/formal justice coordination" ///
                 4 "Confidence: where to refer" ///
                 5 "Confidence: explain referral" ///
                 6 "Feedback after referral" ///
                 7 "Referral cases recorded") ///
           rows(3) size(vsmall)) ///
    note("JLOS = Justice, Law and Order Sector. Descriptive baseline comparison only.", size(vsmall))

graph export "`fig_dir'/fig_33_origin_jlos_collaboration.png", width(2800) replace
graph export "`fig_dir'/fig_33_origin_jlos_collaboration.pdf", replace

preserve
    keep p1_admin_previously_contacted ///
        prior_formal_coordination ///
        police_coordination_score ///
        court_coordination_score ///
        referral_path_conf_score ///
        referral_explain_conf_score ///
        referral_feedback_score ///
        verified_referral_record_score

    collapse (count) n=prior_formal_coordination ///
        (mean) prior_formal_coordination ///
               police_coordination_score ///
               court_coordination_score ///
               referral_path_conf_score ///
               referral_explain_conf_score ///
               referral_feedback_score ///
               verified_referral_record_score, ///
        by(p1_admin_previously_contacted)

    decode p1_admin_previously_contacted, gen(origin_group)
    order p1_admin_previously_contacted origin_group n
    export excel using "`excel_origin'", sheet("fig33_jlos_collaboration", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 18.6 Slide-ready Figure 3: Priority implementation gaps by origin
*------------------------------------------------------------------------------*
* For 0-1 positive indices, the implementation gap is defined as:
*   gap = 1 - mean(index)
*
* Suggested slide:
*   "Both groups still need practical support, but gaps differ by origin"
*------------------------------------------------------------------------------*

capture drop gap_perceived_legitimacy
capture drop gap_record_quality
capture drop gap_reintegration_norms
capture drop gap_referral_practice
capture drop gap_safeguards
capture drop gap_case_handling

gen double gap_perceived_legitimacy = 1 - idx_perceived_legitimacy ///
    if !missing(idx_perceived_legitimacy)
gen double gap_record_quality = 1 - idx_record_quality ///
    if !missing(idx_record_quality)
gen double gap_reintegration_norms = 1 - idx_reintegration_norms ///
    if !missing(idx_reintegration_norms)
gen double gap_referral_practice = 1 - idx_referral_practice ///
    if !missing(idx_referral_practice)
gen double gap_safeguards = 1 - idx_safeguards ///
    if !missing(idx_safeguards)
gen double gap_case_handling = 1 - idx_lcc_case_handling_quality ///
    if !missing(idx_lcc_case_handling_quality)

label var gap_perceived_legitimacy "Legitimacy gap"
label var gap_record_quality "Record-quality gap"
label var gap_reintegration_norms "Reintegration-norms gap"
label var gap_referral_practice "Referral-practice gap"
label var gap_safeguards "Safeguards gap"
label var gap_case_handling "Case-handling quality gap"

graph bar (mean) ///
    gap_perceived_legitimacy ///
    gap_record_quality ///
    gap_reintegration_norms ///
    gap_referral_practice ///
    gap_safeguards ///
    gap_case_handling, ///
    over(p1_admin_previously_contacted, label(labsize(small))) ///
    blabel(bar, format(%4.2f) size(vsmall)) ///
    ylabel(0(.2)1, labsize(small)) ///
    ytitle("Gap to full score, 1 - index mean") ///
	scheme(plotplain) ///
    title("Priority implementation gaps by Phase 1 origin", size(medsmall)) ///
    legend(order(1 "Legitimacy" ///
                 2 "Records" ///
                 3 "Reintegration" ///
                 4 "Referrals" ///
                 5 "Safeguards" ///
                 6 "Case handling") ///
           rows(2) size(vsmall)) ///
    note("Higher values indicate larger baseline gaps. Descriptive comparison only.", size(vsmall))

graph export "`fig_dir'/fig_34_origin_priority_gaps.png", width(2800) replace
graph export "`fig_dir'/fig_34_origin_priority_gaps.pdf", replace

preserve
    keep p1_admin_previously_contacted ///
        gap_perceived_legitimacy ///
        gap_record_quality ///
        gap_reintegration_norms ///
        gap_referral_practice ///
        gap_safeguards ///
        gap_case_handling

    collapse (count) n=gap_case_handling ///
        (mean) gap_perceived_legitimacy ///
               gap_record_quality ///
               gap_reintegration_norms ///
               gap_referral_practice ///
               gap_safeguards ///
               gap_case_handling, ///
        by(p1_admin_previously_contacted)

    decode p1_admin_previously_contacted, gen(origin_group)
    order p1_admin_previously_contacted origin_group n
    export excel using "`excel_origin'", sheet("fig34_priority_gaps", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 18.7 Slide-ready Figure 4: High-capacity / mentor-readiness flags by origin
*------------------------------------------------------------------------------*
* Suggested slide:
*   "Prior contact does not automatically imply mentor readiness"
*------------------------------------------------------------------------------*

graph bar (mean) ///
    high_operational_capacity ///
    high_case_handling_quality ///
    high_legitimacy_norms ///
    high_mentor_readiness_proxy, ///
    over(p1_admin_previously_contacted, label(labsize(small))) ///
    blabel(bar, format(%4.2f) size(vsmall)) ///
    ylabel(0(.2)1, labsize(small)) ///
    ytitle("Share of chairpersons") ///
	scheme(plotplain) ///
    title("High-capacity and mentor-readiness flags by Phase 1 origin", size(medsmall)) ///
    legend(order(1 "High operational capacity" ///
                 2 "High case-handling quality" ///
                 3 "High legitimacy/norms" ///
                 4 "High mentor-readiness proxy") ///
           rows(2) size(vsmall)) ///
    note("High = score >= 0.75. Mentor-readiness proxy is diagnostic, not final eligibility.", size(vsmall))

graph export "`fig_dir'/fig_35_origin_high_readiness_flags.png", width(2600) replace
graph export "`fig_dir'/fig_35_origin_high_readiness_flags.pdf", replace

preserve
    keep p1_admin_previously_contacted ///
        high_operational_capacity ///
        high_case_handling_quality ///
        high_legitimacy_norms ///
        high_mentor_readiness_proxy

    collapse (count) n=high_mentor_readiness_proxy ///
        (mean) high_operational_capacity ///
               high_case_handling_quality ///
               high_legitimacy_norms ///
               high_mentor_readiness_proxy, ///
        by(p1_admin_previously_contacted)

    decode p1_admin_previously_contacted, gen(origin_group)
    order p1_admin_previously_contacted origin_group n
    export excel using "`excel_origin'", sheet("fig35_high_readiness_flags", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 18.8 Optional additional diagnostic: district-adjusted descriptive regressions
*------------------------------------------------------------------------------*
* These are not causal models. They simply check whether origin differences remain
* after absorbing district-level average differences.
*------------------------------------------------------------------------------*

tempfile origin_regressions
tempname regpost

postfile `regpost' ///
    str80 outcome ///
    str160 label ///
    long n ///
    double coef_prev_contacted ///
    double se ///
    double p_value ///
    double mean_new ///
    double mean_prev ///
    using `origin_regressions', replace

local regression_outcomes ///
    idx_lcc_operational_capacity ///
    idx_lcc_case_handling_quality ///
    idx_lcc_legitimacy_and_norms ///
    idx_p1_base_mentor_ready_proxy ///
    idx_record_quality ///
    idx_referral_practice ///
    idx_safeguards

foreach y of local regression_outcomes {
    capture confirm numeric variable `y'
    if !_rc {
        quietly count if !missing(`y', p1_admin_previously_contacted, canonical_district)
        local n = r(N)

        quietly summarize `y' if p1_admin_previously_contacted == 0, meanonly
        local mean0 = r(mean)

        quietly summarize `y' if p1_admin_previously_contacted == 1, meanonly
        local mean1 = r(mean)

        local b = .
        local se = .
        local p = .

        if `n' > 5 {
            capture quietly regress `y' i.p1_admin_previously_contacted i.district_id, vce(robust)
            if !_rc {
                local b = _b[1.p1_admin_previously_contacted]
                local se = _se[1.p1_admin_previously_contacted]
                local p = 2 * ttail(e(df_r), abs(`b' / `se'))
            }
        }

        local ylab : variable label `y'
        if `"`ylab'"' == "" local ylab "`y'"
        local ylab = substr(`"`ylab'"', 1, 160)

        post `regpost' ///
            (`"`y'"') ///
            (`"`ylab'"') ///
            (`n') ///
            (`b') ///
            (`se') ///
            (`p') ///
            (`mean0') ///
            (`mean1')
    }
}

postclose `regpost'

preserve
    use `origin_regressions', clear
    gen raw_diff_prev_minus_new = mean_prev - mean_new
    gen ci_low = coef_prev_contacted - invttail(n-4, .025)*se
    gen ci_high = coef_prev_contacted + invttail(n-4, .025)*se
    gen model_note = "Cross-sectional baseline associations; not causal estimates."
    format coef_prev_contacted se p_value mean_new mean_prev raw_diff_prev_minus_new %9.3f
    order outcome label n mean_new mean_prev raw_diff_prev_minus_new coef_prev_contacted se ci_low ci_high p_value model_note
    export excel using "`excel_origin'", sheet("district_adjusted_diagnostics", replace) firstrow(variables)
    putexcel set "`excel_reg'", replace sheet("README")
    putexcel A1 = "Phase 1 final baseline association models"
    putexcel A3 = "Interpretation"
    putexcel B3 = "Cross-sectional baseline associations; not causal estimates."
    putexcel A4 = "Origin specification"
    putexcel B4 = "Previously contacted versus new/randomly selected, canonical district fixed effects, heteroskedasticity-robust standard errors."
    putexcel A5 = "Multivariable specification"
    putexcel B5 = "One common parsimonious specification using pre-existing chairperson characteristics and canonical district fixed effects."
    putexcel clear
    export excel using "`excel_reg'", sheet("origin_adjusted", replace) firstrow(variables)

    encode label, gen(outcome_id)
    twoway ///
        (rcap ci_low ci_high outcome_id, horizontal lcolor("32 87 129") lwidth(medthick)) ///
        (scatter outcome_id coef_prev_contacted, msymbol(D) msize(medsmall) mcolor("211 118 35")), ///
        xline(0, lcolor(gs8) lpattern(dash)) ///
        ylabel(1(1)7, valuelabel angle(0) labsize(small)) ///
        xlabel(-.30(.10).30, format(%4.2f) grid) ///
        xtitle("Adjusted difference: previously contacted minus new/random") ///
        ytitle("") legend(off) ///
        title("Adjusted administrative-origin associations", size(medsmall)) ///
        note("Canonical district fixed effects with robust standard errors." ///
             "Cross-sectional baseline associations; not causal estimates.", size(vsmall))
    graph export "`fig_dir'/fig_42_adjusted_origin_coefficients.png", width(3000) replace
    graph export "`fig_dir'/fig_42_adjusted_origin_coefficients.pdf", replace
restore

* One parsimonious diagnostic specification applied consistently across main domains.
tempfile multivar_results
tempname mr
postfile `mr' str80 outcome str160 outcome_label str50 predictor str120 predictor_label ///
    long n double coefficient se p_value r2 using `multivar_results', replace

local diagnostic_outcomes ///
    idx_legal_classif_knowledge ///
    idx_adr_mediation_practice ///
    idx_record_quality ///
    idx_committee_functioning ///
    idx_perceived_legitimacy ///
    idx_safeguards ///
    idx_reintegration_norms

foreach y of local diagnostic_outcomes {
    quietly regress `y' respondent_female education_score lc_experience_years ///
        prior_justice_training prior_formal_coordination ///
        i.p1_admin_previously_contacted i.district_id, vce(robust)
    local yl : variable label `y'
    local model_n = e(N)
    local model_r2 = e(r2)
    foreach x in respondent_female education_score lc_experience_years prior_justice_training prior_formal_coordination {
        local xl : variable label `x'
        local p = 2*ttail(e(df_r), abs(_b[`x']/_se[`x']))
        post `mr' ("`y'") (`"`yl'"') ("`x'") (`"`xl'"') (`model_n') ///
            (_b[`x']) (_se[`x']) (`p') (`model_r2')
    }
    local p = 2*ttail(e(df_r), abs(_b[1.p1_admin_previously_contacted]/_se[1.p1_admin_previously_contacted]))
    post `mr' ("`y'") (`"`yl'"') ("p1_admin_previously_contacted") ///
        ("Previously contacted village") (`model_n') ///
        (_b[1.p1_admin_previously_contacted]) (_se[1.p1_admin_previously_contacted]) (`p') (`model_r2')
}
postclose `mr'

preserve
    use `multivar_results', clear
    gen model_note = "Cross-sectional baseline associations; not causal estimates."
    format coefficient se p_value r2 %9.3f
    export excel using "`excel_reg'", sheet("multivariable_diagnostics", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 18.9 Console summary for final report
*------------------------------------------------------------------------------*

display as text "------------------------------------------------------------"
display as text "Origin comparison outputs created:"
display as text "Excel workbook:"
display as result "`excel_origin'"
display as text "Figures:"
display as result "`fig_dir'/fig_32_origin_core_composites.png"
display as result "`fig_dir'/fig_33_origin_jlos_collaboration.png"
display as result "`fig_dir'/fig_34_origin_priority_gaps.png"
display as result "`fig_dir'/fig_35_origin_high_readiness_flags.png"
display as text "------------------------------------------------------------"

display as text "Interpretation: Descriptive baseline association, not a causal effect of previous contact."
display as text "------------------------------------------------------------"



*------------------------------------------------------------------------------*
**# 19. Annex analysis: expanded JLOS collaboration and referral pathways
*------------------------------------------------------------------------------*
* Purpose:
*   Produce report-ready figures expanding the analysis of collaboration with
*   JLOS actors for the full Phase 1 baseline sample.
*
* JLOS:
*   Justice, Law and Order Sector. In this analysis, this mainly refers to
*   formal justice and protection actors such as police, courts, probation /
*   child protection, and related justice-sector authorities.
*
* Interpretation:
*   Descriptive baseline analysis only.
*------------------------------------------------------------------------------*

*-------------------------------*
**# 19.1 Clean labels
*-------------------------------*

capture label var m4_q02_referral_scope_score "Knows which cases require referral"
capture label var prior_formal_coordination "Prior coordination with JLOS actors"
capture label var police_coordination_score "Coordination with police"
capture label var court_coordination_score "Coordination with courts/formal justice"
capture label var referral_frequency_score "Referral regularity"
capture label var referral_documentation_score "Referral documentation"
capture label var referral_feedback_score "Feedback after referral"
capture label var referral_path_conf_score "Confidence knowing where to refer"
capture label var referral_explain_conf_score "Confidence explaining referral"
capture label var verified_referral_record_score "Verified referred cases are recorded"
capture label var verified_ref_dest_score "Verified referral destination recorded"
capture label var idx_referral_practice "Referral practice index"

capture label var m6_q04_1 "Outside LCC mandate"
capture label var m6_q04_2 "Serious violence/threat to life"
capture label var m6_q04_3 "Sexual violence or SGBV"
capture label var m6_q04_4 "Child protection concern"
capture label var m6_q04_5 "Parties refused local mediation"
capture label var m6_q04_6 "Local agreement not followed"
capture label var m6_q04_7 "Facts/evidence too complex"
capture label var m6_q04_8 "LCC lacked quorum/capacity"

capture label var m6_q12_1 "Authority too far away"
capture label var m6_q12_2 "Transport cost/lack of transport"
capture label var m6_q12_3 "Parties do not want referral"
capture label var m6_q12_4 "Fear costs/delay/consequences"
capture label var m6_q12_5 "Receiving authority slow"
capture label var m6_q12_6 "Unclear receiving authority"
capture label var m6_q12_7 "Lack referral-procedure knowledge"
capture label var m6_q12_8 "Lack forms/documentation tools"
capture label var m6_q12_9 "Pressure to keep case local"
capture label var m6_q12_10 "Fear retaliation/worse conflict"
capture label var m6_q12_11 "No major referral barriers"

*-------------------------------*
**# 19.2 README
*-------------------------------*

putexcel set "`excel_jlos'", replace sheet("README")
putexcel A1 = "Advancing Justice Uganda - Phase 1 baseline expanded JLOS analysis"
putexcel A3 = "Purpose"
putexcel B3 = "Expanded descriptive analysis of LC chairperson collaboration with JLOS actors and referral pathways."
putexcel A4 = "Sample"
putexcel B4 = "Full Phase 1 baseline analysis sample."
putexcel A5 = "JLOS definition"
putexcel B5 = "Justice, Law and Order Sector: police, courts, probation/child protection, and related justice-sector authorities."
putexcel A6 = "Interpretation"
putexcel B6 = "Descriptive baseline analysis only. These figures do not estimate program impact."
putexcel clear

*------------------------------------------------------------------------------*
**# 19.3 Figure 36: JLOS collaboration and referral practice snapshot
*------------------------------------------------------------------------------*
* Recommended slide:
*   "Collaboration with JLOS actors is already widespread, but referral closure is weaker"
*------------------------------------------------------------------------------*

preserve
    tempfile jlos_snapshot
    tempname mem

    postfile `mem' byte order str70 indicator long n double value using `jlos_snapshot', replace

    local v1  prior_formal_coordination
    local l1  "Prior formal coordination"
    local v2  m4_q02_referral_scope_score
    local l2  "Knows cases requiring referral"
    local v3  police_coordination_score
    local l3  "Coordination with police"
    local v4  court_coordination_score
    local l4  "Coordination with courts"
    local v5  referral_frequency_score
    local l5  "Referral regularity"
    local v6  referral_path_conf_score
    local l6  "Confidence knowing where to refer"
    local v7  referral_explain_conf_score
    local l7  "Confidence explaining referral"
    local v8  referral_documentation_score
    local l8  "Referral documentation"
    local v9  referral_feedback_score
    local l9  "Feedback after referral"

    forvalues i = 1/9 {
        local v "`v`i''"
        local lab "`l`i''"

        quietly summarize `v' if !missing(`v'), meanonly
        local n = r(N)
        local val = 100 * r(mean)

        post `mem' (`i') (`"`lab'"') (`n') (`val')
    }

    postclose `mem'

    use `jlos_snapshot', clear
    format value %9.1f

    gen item_id = order
    label define jlos_snap_lbl ///
        1 "Prior formal coordination" ///
        2 "Knows cases requiring referral" ///
        3 "Coordination with police" ///
        4 "Coordination with courts" ///
        5 "Referral regularity" ///
        6 "Confidence knowing where to refer" ///
        7 "Confidence explaining referral" ///
        8 "Referral documentation" ///
        9 "Feedback after referral", replace
    label values item_id jlos_snap_lbl

    export excel using "`excel_jlos'", sheet("fig36_jlos_snapshot", replace) firstrow(variables)

graph hbar (asis) value, ///
    bar(1, color("32 87 129")) ///
    over(item_id, label(labsize(vsmall))) ///
    blabel(bar, format(%4.1f) size(vsmall)) ///
    ylabel(0(20)100, labsize(small)) ///
    ytitle("") ///
	scheme(plotplain) ///
    title("JLOS collaboration and referral practice", size(medsmall)) ///
    subtitle("Full Phase 1 baseline sample", size(small)) ///
    note("Values are percentages or 0-1 scores converted to 0-100. JLOS = Justice, Law and Order Sector.", size(vsmall))

graph export "`fig_dir'/fig_36_jlos_snapshot.png", width(2800) replace
graph export "`fig_dir'/fig_36_jlos_snapshot.pdf", replace
restore

*------------------------------------------------------------------------------*
**# 19.4 Figure 37: Why chairpersons refer cases onward
*------------------------------------------------------------------------------*
* Recommended slide:
*   "Referral triggers broadly align with mandate and protection risks"
*------------------------------------------------------------------------------*

preserve
    tempfile jlos_reasons
    tempname mem

    postfile `mem' byte order str70 reason long n double value using `jlos_reasons', replace

    local v1  m6_q04_1
    local l1  "Outside LCC mandate"
    local v2  m6_q04_2
    local l2  "Serious violence/threat to life"
    local v3  m6_q04_3
    local l3  "Sexual violence or SGBV"
    local v4  m6_q04_4
    local l4  "Child protection concern"
    local v5  m6_q04_5
    local l5  "Parties refused local mediation"
    local v6  m6_q04_6
    local l6  "Local agreement not followed"
    local v7  m6_q04_7
    local l7  "Facts/evidence too complex"
    local v8  m6_q04_8
    local l8  "LCC lacked quorum/capacity"

    forvalues i = 1/8 {
        local v "`v`i''"
        local lab "`l`i''"

        quietly summarize `v' if !missing(`v'), meanonly
        local n = r(N)
        local val = 100 * r(mean)

        post `mem' (`i') (`"`lab'"') (`n') (`val')
    }

    postclose `mem'

    use `jlos_reasons', clear
    format value %9.1f

    gen item_id = order
    label define jlos_reason_lbl ///
        1 "Outside LCC mandate" ///
        2 "Serious violence/threat" ///
        3 "Sexual violence/SGBV" ///
        4 "Child protection" ///
        5 "Parties refused mediation" ///
        6 "Agreement not followed" ///
        7 "Facts too complex" ///
        8 "LCC lacked capacity", replace
    label values item_id jlos_reason_lbl

    export excel using "`excel_jlos'", sheet("fig37_referral_reasons", replace) firstrow(variables)

graph hbar (asis) value, ///
    bar(1, color("32 87 129")) ///
    over(item_id, sort(value) descending label(labsize(vsmall))) ///
    blabel(bar, format(%4.1f) size(vsmall)) ///
    ylabel(0(20)100, labsize(small)) ///
    ytitle("") ///
	scheme(plotplain) ///
    title("Reasons for referring cases onward", size(medsmall)) ///
    subtitle("Share of chairpersons selecting each reason", size(small)) ///
    note("Multiple responses allowed. Full Phase 1 baseline sample.", size(vsmall))

graph export "`fig_dir'/fig_37_jlos_referral_reasons.png", width(2800) replace
graph export "`fig_dir'/fig_37_jlos_referral_reasons.pdf", replace
restore

*------------------------------------------------------------------------------*
**# 19.5 Figure 38: Barriers to referral
*------------------------------------------------------------------------------*
* Recommended slide:
*   "Referral is constrained by distance, transport, and party resistance"
*------------------------------------------------------------------------------*

preserve
    tempfile jlos_barriers
    tempname mem

    postfile `mem' byte order str75 barrier long n double value using `jlos_barriers', replace

    local v1  m6_q12_1
    local l1  "Authority too far away"
    local v2  m6_q12_2
    local l2  "Transport cost/lack of transport"
    local v3  m6_q12_3
    local l3  "Parties do not want referral"
    local v4  m6_q12_4
    local l4  "Fear costs/delay/consequences"
    local v5  m6_q12_8
    local l5  "Lack forms/documentation tools"
    local v6  m6_q12_10
    local l6  "Fear retaliation/worse conflict"
    local v7  m6_q12_5
    local l7  "Receiving authority slow"
    local v8  m6_q12_7
    local l8  "Lack referral-procedure knowledge"
    local v9  m6_q12_6
    local l9  "Unclear receiving authority"
    local v10 m6_q12_9
    local l10 "Pressure to keep case local"
    local v11 m6_q12_11
    local l11 "No major referral barriers"

    forvalues i = 1/11 {
        local v "`v`i''"
        local lab "`l`i''"

        quietly summarize `v' if !missing(`v'), meanonly
        local n = r(N)
        local val = 100 * r(mean)

        post `mem' (`i') (`"`lab'"') (`n') (`val')
    }

    postclose `mem'

    use `jlos_barriers', clear
    format value %9.1f

    gen item_id = order
    label define jlos_barrier_lbl ///
        1 "Authority too far away" ///
        2 "Transport cost/lack transport" ///
        3 "Parties do not want referral" ///
        4 "Fear costs/delay/consequences" ///
        5 "Lack forms/documentation tools" ///
        6 "Fear retaliation/worse conflict" ///
        7 "Receiving authority slow" ///
        8 "Lack referral-procedure knowledge" ///
        9 "Unclear receiving authority" ///
        10 "Pressure to keep case local" ///
        11 "No major referral barriers", replace
    label values item_id jlos_barrier_lbl

    export excel using "`excel_jlos'", sheet("fig38_referral_barriers", replace) firstrow(variables)

graph hbar (asis) value, ///
    bar(1, color("211 118 35")) ///
    over(item_id, sort(value) descending label(labsize(vsmall))) ///
    blabel(bar, format(%4.1f) size(vsmall)) ///
    ylabel(0(20)100, labsize(small)) ///
    ytitle("") ///
	scheme(plotplain) ///
    title("Reported barriers to referral", size(medsmall)) ///
    subtitle("Share of chairpersons selecting each barrier", size(small)) ///
    note("Multiple responses allowed. Full Phase 1 baseline sample.", size(vsmall))

graph export "`fig_dir'/fig_38_jlos_referral_barriers.png", width(2800) replace
graph export "`fig_dir'/fig_38_jlos_referral_barriers.pdf", replace
restore

*------------------------------------------------------------------------------*
**# 19.6 Figure 39: Referral pathway bottleneck
*------------------------------------------------------------------------------*
* Recommended slide:
*   "The referral loop narrows after initial coordination"
*------------------------------------------------------------------------------*

capture drop jlos_coordination_avg
capture drop jlos_pathway_conf_avg
capture drop jlos_closure_avg
capture drop jlos_verified_record_avg

egen jlos_coordination_avg = rowmean(police_coordination_score court_coordination_score)
label var jlos_coordination_avg "Average police/court coordination score"

egen jlos_pathway_conf_avg = rowmean(referral_path_conf_score referral_explain_conf_score)
label var jlos_pathway_conf_avg "Average confidence in referral pathway"

egen jlos_closure_avg = rowmean(referral_documentation_score referral_feedback_score)
label var jlos_closure_avg "Average documentation/feedback closure score"

egen jlos_verified_record_avg = rowmean(verified_referral_record_score verified_ref_dest_score)
label var jlos_verified_record_avg "Average verified referral-record score"

preserve
    tempfile jlos_pathway
    tempname mem

    postfile `mem' byte order str70 stage long n double value using `jlos_pathway', replace

    local v1  prior_formal_coordination
    local l1  "Prior formal coordination"
    local v2  m4_q02_referral_scope_score
    local l2  "Knows cases requiring referral"
    local v3  jlos_coordination_avg
    local l3  "Police/court coordination"
    local v4  referral_frequency_score
    local l4  "Referral regularity"
    local v5  jlos_pathway_conf_avg
    local l5  "Referral pathway confidence"
    local v6  jlos_closure_avg
    local l6  "Documentation and feedback"
    local v7  jlos_verified_record_avg
    local l7  "Verified referral record"

    forvalues i = 1/7 {
        local v "`v`i''"
        local lab "`l`i''"

        quietly summarize `v' if !missing(`v'), meanonly
        local n = r(N)
        local val = 100 * r(mean)

        post `mem' (`i') (`"`lab'"') (`n') (`val')
    }

    postclose `mem'

    use `jlos_pathway', clear
    format value %9.1f

    gen item_id = order
    label define jlos_path_lbl ///
        1 "Prior formal coordination" ///
        2 "Knows cases requiring referral" ///
        3 "Police/court coordination" ///
        4 "Referral regularity" ///
        5 "Referral pathway confidence" ///
        6 "Documentation and feedback" ///
        7 "Verified referral record", replace
    label values item_id jlos_path_lbl

    export excel using "`excel_jlos'", sheet("fig39_referral_loop", replace) firstrow(variables)

graph hbar (asis) value, ///
    bar(1, color("32 87 129")) ///
    over(item_id, label(labsize(vsmall))) ///
    blabel(bar, format(%4.1f) size(vsmall)) ///
    ylabel(0(20)100, labsize(small)) ///
    ytitle("") ///
	scheme(plotplain) ///
    title("Referral pathway: strong entry, weaker closure", size(medsmall)) ///
    subtitle("Referral loop indicators, 0-100 scale", size(small)) ///
    note("Documentation/feedback combines referral documentation and feedback after referral.", size(vsmall))

graph export "`fig_dir'/fig_39_jlos_referral_loop.png", width(2800) replace
graph export "`fig_dir'/fig_39_jlos_referral_loop.pdf", replace
restore

*------------------------------------------------------------------------------*
**# 19.7 Optional diagnostic table: JLOS indicators by district
*------------------------------------------------------------------------------*

preserve
    keep canonical_district ///
        prior_formal_coordination ///
        m4_q02_referral_scope_score ///
        police_coordination_score ///
        court_coordination_score ///
        referral_path_conf_score ///
        referral_explain_conf_score ///
        referral_documentation_score ///
        referral_feedback_score ///
        verified_referral_record_score ///
        verified_ref_dest_score ///
        idx_referral_practice ///
        n_referral_reasons ///
        n_referral_barriers ///
        no_major_referral_barriers

    collapse ///
        (count) n=idx_referral_practice ///
        (mean) prior_formal_coordination ///
               m4_q02_referral_scope_score ///
               police_coordination_score ///
               court_coordination_score ///
               referral_path_conf_score ///
               referral_explain_conf_score ///
               referral_documentation_score ///
               referral_feedback_score ///
               verified_referral_record_score ///
               verified_ref_dest_score ///
               idx_referral_practice ///
               n_referral_reasons ///
               n_referral_barriers ///
               no_major_referral_barriers, ///
        by(canonical_district)

    export excel using "`excel_jlos'", sheet("district_jlos_diagnostic", replace) firstrow(variables)
restore

*------------------------------------------------------------------------------*
**# 19.8 Console summary
*------------------------------------------------------------------------------*

display as text "------------------------------------------------------------"
display as text "Expanded JLOS collaboration outputs created:"
display as result "`excel_jlos'"
display as result "`fig_dir'/fig_36_jlos_snapshot.png"
display as result "`fig_dir'/fig_37_jlos_referral_reasons.png"
display as result "`fig_dir'/fig_38_jlos_referral_barriers.png"
display as result "`fig_dir'/fig_39_jlos_referral_loop.png"
display as text "Recommended placement: referrals and JLOS coordination section of the Final Baseline Report."
display as text "------------------------------------------------------------"

*------------------------------------------------------------------------------*
**# 20. Cross-cutting report-ready implementation figures
*------------------------------------------------------------------------------*

* Build the records/committee figure from a compact posting table to retain labels.
tempfile operations_figure
tempname of
postfile `of' str80 measure double mean using `operations_figure', replace
foreach v in case_register_score verified_record_usability_score idx_record_quality active_member_part_score women_participation_score idx_committee_functioning {
    quietly summarize `v', meanonly
    local vl : variable label `v'
    post `of' (`"`vl'"') (r(mean))
}
postclose `of'
preserve
    use `operations_figure', clear
    graph hbar mean, over(measure, sort(mean) descending label(labsize(small))) ///
        bar(1, color("32 87 129")) blabel(bar, format(%4.2f) size(small)) ///
        yscale(range(0 1)) ylabel(0(.2)1, format(%3.1f) grid) ///
        ytitle("Mean baseline score (0-1)") ///
        title("Records and committee operational capacity", size(medsmall)) ///
        note("Verified measures reflect enumerator-observed records or participation where available.", size(vsmall))
    graph export "`fig_dir'/fig_40_records_committee_constraints.png", width(3000) replace
    graph export "`fig_dir'/fig_40_records_committee_constraints.pdf", replace
restore

tempfile norms_figure
tempname nf
postfile `nf' str80 measure double mean using `norms_figure', replace
foreach v in idx_perceived_legitimacy idx_safeguards idx_reintegration_norms {
    quietly summarize `v', meanonly
    local vl : variable label `v'
    post `nf' (`"`vl'"') (r(mean))
}
postclose `nf'
preserve
    use `norms_figure', clear
    graph hbar mean, over(measure, sort(mean) descending label(labsize(small))) ///
        bar(1, color("63 122 120")) blabel(bar, format(%4.2f) size(small)) ///
        yscale(range(0 1)) ylabel(0(.2)1, format(%3.1f) grid) ///
        ytitle("Mean baseline score (0-1)") ///
        title("Legitimacy, safeguards, and reintegration", size(medsmall)) ///
        note("Chairperson-reported baseline measures; higher scores indicate stronger practice or norms.", size(vsmall))
    graph export "`fig_dir'/fig_41_legitimacy_safeguards_reintegration.png", width(2800) replace
    graph export "`fig_dir'/fig_41_legitimacy_safeguards_reintegration.pdf", replace
restore

* Explicit shortlist for the narrative report.
putexcel set "`excel_exec'", sheet("report_ready_figures", replace) modify
putexcel A1 = "Figure file" B1 = "Purpose"
putexcel A2 = "fig_02_core_indices_overall" B2 = "Headline baseline domain dashboard"
putexcel A3 = "fig_04_priority_gaps" B3 = "Ranked implementation gaps"
putexcel A4 = "fig_13_vignette_performance" B4 = "Ordinary versus child/SGBV vignette performance"
putexcel A5 = "fig_14_adr_mediation / fig_15_adr_barriers" B5 = "ADR practice and constraints"
putexcel A6 = "fig_39_jlos_referral_loop" B6 = "JLOS/referral pathway"
putexcel A7 = "fig_40_records_committee_constraints" B7 = "Records and committee operational constraints"
putexcel A8 = "fig_41_legitimacy_safeguards_reintegration" B8 = "Legitimacy, safeguards, and reintegration summary"
putexcel A9 = "fig_42_adjusted_origin_coefficients" B9 = "Adjusted administrative-origin association"
putexcel clear

*------------------------------------------------------------------------------*
**# 21. Legatum Final Baseline Report indicator table
*------------------------------------------------------------------------------*
* Classification follows the revised Scope of Work. Missing values below are
* deliberate: administrative, prison, cost, intervention-effect, and future
* community outcomes cannot be measured from this LC chairperson survey.

tempfile indicator_table
tempname ip
postfile `ip' str140 indicator str1 classification str80 analysis_variable ///
    str200 definition double baseline_value long n str40 unit ///
    str100 relevant_disaggregation str244 measurement_note str24 measure_type ///
    using `indicator_table', replace

foreach v in idx_legal_classif_knowledge idx_adr_mediation_practice idx_referral_practice ///
    idx_record_quality idx_institutional_functioning idx_perceived_legitimacy ///
    idx_safeguards idx_reintegration_norms {
    local indicator ""
    local class "A"
    local def "Mean standardized baseline domain score constructed from the Phase 1 LC survey."
    local note "Direct structured LC survey benchmark."
    local type "Direct measure"
    if "`v'" == "idx_legal_classif_knowledge" local indicator "LC knowledge and case triage"
    if "`v'" == "idx_adr_mediation_practice" local indicator "ADR and mediation practice"
    if "`v'" == "idx_referral_practice" local indicator "Referral quality and coordination"
    if "`v'" == "idx_record_quality" local indicator "Record keeping and case management"
    if "`v'" == "idx_institutional_functioning" local indicator "Institutional functioning"
    if "`v'" == "idx_perceived_legitimacy" {
        local indicator "Perceived legitimacy and procedural fairness"
        local class "B"
        local note "LC chairperson perception; not a direct community-confidence measure."
        local type "Survey proxy"
    }
    if "`v'" == "idx_safeguards" {
        local indicator "Safeguards and sensitive-case handling"
        local class "B"
        local note "Knowledge/vignette/practice benchmark; not an administrative case-flow outcome."
        local type "Survey proxy"
    }
    if "`v'" == "idx_reintegration_norms" {
        local indicator "Reintegration conditions and norms"
        local class "B"
        local note "Chairperson-reported norms and conditions; not a survey of former prisoners or communities."
        local type "Survey proxy"
    }
    quietly summarize `v'
    post `ip' (`"`indicator'"') ("`class'") ("`v'") (`"`def'"') ///
        (r(mean)) (r(N)) ("Mean score (0-1)") ///
        ("Canonical district; administrative origin") (`"`note'"') ("`type'")
}

post `ip' ("0.0.1 Reduction in petty cases entering the formal-justice system") ("C") ("") ///
    ("Administrative count/share of petty cases entering the formal system") (.) (.) ("Percent change") ///
    ("Administrative geography and case type") ("Requires comparable police/court administrative case-flow data.") ("Not measurable")
post `ip' ("0.0.2 Reduction in the number of remandees") ("C") ("") ///
    ("Administrative remand population outcome") (.) (.) ("Count/percent change") ///
    ("Prison/court characteristics") ("Requires prison and court administrative data.") ("Not measurable")
post `ip' ("Cost-effectiveness / cost per case resolved") ("C") ("") ///
    ("Program costs relative to verified resolved cases") (.) (.) ("Currency per case") ///
    ("Program arm and implementation unit") ("Requires program cost data and verified administrative outcomes.") ("Not measurable")
post `ip' ("1.1.1 Increase in petty cases resolved through ADR") ("C") ("") ///
    ("Administrative volume/share of eligible cases resolved through ADR") (.) (.) ("Percent change") ///
    ("Case type; district; implementation period") ("Survey practice is a benchmark only; the indicator requires verified case-flow data.") ("Not measurable")
post `ip' ("1.1.2 Increase in cases referred to LCCs for ADR") ("C") ("") ///
    ("Administrative referrals into LCC ADR") (.) (.) ("Percent change") ///
    ("Referring authority; district") ("Requires administrative referral records.") ("Not measurable")
post `ip' ("2.1 Reduction in time spent on remand") ("C") ("") ///
    ("Duration on remand") (.) (.) ("Days/percent change") ///
    ("Case and prisoner characteristics") ("Requires prison/court administrative longitudinal data.") ("Not measurable")
post `ip' ("2.2 Legal-aid beneficiaries receiving a hearing within 60 days") ("C") ("") ///
    ("Share of supported cases heard within 60 days") (.) (.) ("Percent") ///
    ("Case and beneficiary characteristics") ("Requires legal-aid and court administrative data.") ("Not measurable")
post `ip' ("3.1.5 Prisoners generating income through acquired skills") ("C") ("") ///
    ("Income-generating activity among supported prisoners/former prisoners") (.) (.) ("Percent/count") ///
    ("Participant characteristics") ("Requires beneficiary follow-up and program monitoring data.") ("Not measurable")
post `ip' ("4.1.1 Improvements adopted by JLOS institutions") ("C") ("") ///
    ("Institutional reforms attributable to advocacy") (.) (.) ("Count/qualitative verification") ///
    ("Institution and reform type") ("Requires institutional documentation and follow-up verification.") ("Not measurable")
post `ip' ("4.1.2 Reduction in case backlog") ("C") ("") ///
    ("Administrative case backlog") (.) (.) ("Count/percent change") ///
    ("Court; case type; period") ("Requires court administrative data.") ("Not measurable")
postclose `ip'

putexcel set "`excel_ind'", replace sheet("README")
putexcel A1 = "Legatum Phase 1 Final Baseline indicator table"
putexcel A3 = "Classification A" B3 = "Directly measurable from the Phase 1 baseline survey"
putexcel A4 = "Classification B" B4 = "Survey proxy or benchmark only"
putexcel A5 = "Classification C" B5 = "Not measurable from the Phase 1 LC survey; administrative or follow-up data required"
putexcel A6 = "Interpretation" B6 = "No value is imputed for indicators outside the measurement scope of this survey."
putexcel clear
preserve
    use `indicator_table', clear
    format baseline_value %9.3f
    export excel using "`excel_ind'", sheet("indicator_table", replace) firstrow(variables)
restore

*------------------------------------------------------------------------------*
**# 21a. Section 10 survey benchmarks and Slide 57 crosswalk
*------------------------------------------------------------------------------*
* BEGIN SECTION 10 REPRODUCIBLE BENCHMARKS
* Requires final cohort in memory and local excel_ind pointing to the indicator
* workbook. Runs within this do-file; this block can also be selected in Stata.
* No source variables, scores, indices, thresholds or sample flags are changed.
* M3_Q09 question excludes parties whereas its hint includes them. The approved
* report interpretation retains the count but explicitly marks respondent scope
* ambiguous. It is NOT a formal diversion measure.
assert _N == 129
assert analysis_sample == 1 & consent == 1
isid canonical_village_uid
quietly datasignature
local s10_signature_before "`r(datasignature)'"
tempfile s10_metrics
tempname s10_post
postfile `s10_post' str40 variable str110 measure str40 domain ///
    str60 evidence_type str244 measurement_note str24 unit ///
    long n double total double mean double sd double median long missing_n ///
    using `s10_metrics', replace

* Capacity: Respondent capacity
quietly summarize idx_respondent_capacity, detail
post `s10_post' ("idx_respondent_capacity") ("Respondent capacity") ("Capacity") ///
    ("Self-reported characteristics / literacy") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Capacity: Institutional functioning
quietly summarize idx_institutional_functioning, detail
post `s10_post' ("idx_institutional_functioning") ("Institutional functioning") ("Capacity") ///
    ("Mixed survey evidence") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Capacity: Legal and classification knowledge
quietly summarize idx_legal_classif_knowledge, detail
post `s10_post' ("idx_legal_classif_knowledge") ("Legal and classification knowledge") ("Capacity") ///
    ("Objectively scored knowledge / vignettes") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Capacity: ADR and mediation practice
quietly summarize idx_adr_mediation_practice, detail
post `s10_post' ("idx_adr_mediation_practice") ("ADR and mediation practice") ("Capacity") ///
    ("Mixed survey evidence") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Capacity: Referral practice
quietly summarize idx_referral_practice, detail
post `s10_post' ("idx_referral_practice") ("Referral practice") ("Capacity") ///
    ("Mixed survey evidence") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Capacity: Record quality
quietly summarize idx_record_quality, detail
post `s10_post' ("idx_record_quality") ("Record quality") ("Capacity") ///
    ("Mixed survey evidence") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Capacity: Committee functioning
quietly summarize idx_committee_functioning, detail
post `s10_post' ("idx_committee_functioning") ("Committee functioning") ("Capacity") ///
    ("Mixed survey evidence") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Capacity: Chairperson-perceived legitimacy
quietly summarize idx_perceived_legitimacy, detail
post `s10_post' ("idx_perceived_legitimacy") ("Chairperson-perceived legitimacy") ("Capacity") ///
    ("Perception / confidence / attitude") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Capacity: Safeguards knowledge and perceived special-handling need
quietly summarize idx_safeguards, detail
post `s10_post' ("idx_safeguards") ("Safeguards knowledge and perceived special-handling need") ("Capacity") ///
    ("Scored knowledge / perceived need") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Capacity: Chairperson reintegration norms
quietly summarize idx_reintegration_norms, detail
post `s10_post' ("idx_reintegration_norms") ("Chairperson reintegration norms") ("Capacity") ///
    ("Perception / confidence / attitude") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Capacity: Operational capacity
quietly summarize idx_lcc_operational_capacity, detail
post `s10_post' ("idx_lcc_operational_capacity") ("Operational capacity") ("Capacity") ///
    ("Mixed survey evidence") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Capacity: Case-handling quality
quietly summarize idx_lcc_case_handling_quality, detail
post `s10_post' ("idx_lcc_case_handling_quality") ("Case-handling quality") ("Capacity") ///
    ("Mixed survey evidence") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Capacity: Legitimacy and reintegration composite
quietly summarize idx_lcc_legitimacy_and_norms, detail
post `s10_post' ("idx_lcc_legitimacy_and_norms") ("Legitimacy and reintegration composite") ("Capacity") ///
    ("Mixed survey evidence") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Capacity: Baseline mentor-readiness diagnostic
quietly summarize idx_p1_base_mentor_ready_proxy, detail
post `s10_post' ("idx_p1_base_mentor_ready_proxy") ("Baseline mentor-readiness diagnostic") ("Capacity") ///
    ("Mixed survey evidence") ("Existing locked index; mean of available components. See Annex B. Not a programme outcome.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Readiness: Operational capacity at least 0.75
quietly summarize high_operational_capacity, detail
post `s10_post' ("high_operational_capacity") ("Operational capacity at least 0.75") ("Readiness") ///
    ("Composite diagnostic") ("Existing >=0.75 descriptive threshold; not assessed graduates or final mentor eligibility.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Readiness: Case-handling quality at least 0.75
quietly summarize high_case_handling_quality, detail
post `s10_post' ("high_case_handling_quality") ("Case-handling quality at least 0.75") ("Readiness") ///
    ("Composite diagnostic") ("Existing >=0.75 descriptive threshold; not assessed graduates or final mentor eligibility.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Readiness: Legitimacy and norms at least 0.75
quietly summarize high_legitimacy_norms, detail
post `s10_post' ("high_legitimacy_norms") ("Legitimacy and norms at least 0.75") ("Readiness") ///
    ("Composite diagnostic") ("Existing >=0.75 descriptive threshold; not assessed graduates or final mentor eligibility.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Readiness: Baseline mentor proxy at least 0.75
quietly summarize high_mentor_readiness_proxy, detail
post `s10_post' ("high_mentor_readiness_proxy") ("Baseline mentor proxy at least 0.75") ("Readiness") ///
    ("Composite diagnostic") ("Existing >=0.75 descriptive threshold; not assessed graduates or final mentor eligibility.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Caseload: Cases received in past 30 days
quietly summarize caseload_30d, detail
post `s10_post' ("caseload_30d") ("Cases received in past 30 days") ("Caseload") ///
    ("Chairperson-reported case counts") ("Available responses only; no missing-to-zero replacement. Period and case scope differ across measures.") ("Cases") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Caseload: Cases received in past 3 months
quietly summarize caseload_3m, detail
post `s10_post' ("caseload_3m") ("Cases received in past 3 months") ("Caseload") ///
    ("Chairperson-reported case counts") ("Available responses only; no missing-to-zero replacement. Period and case scope differ across measures.") ("Cases") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Caseload: Cases currently pending or unresolved
quietly summarize pending_cases, detail
post `s10_post' ("pending_cases") ("Cases currently pending or unresolved") ("Caseload") ///
    ("Chairperson-reported case counts") ("Available responses only; no missing-to-zero replacement. Period and case scope differ across measures.") ("Cases") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Caseload: Reported community-brought cases - respondent scope ambiguous
quietly summarize directly_brought_cases_3m, detail
post `s10_post' ("directly_brought_cases_3m") ("Reported community-brought cases - respondent scope ambiguous") ("Caseload") ///
    ("Chairperson-reported case counts") ("Available responses only; no missing-to-zero replacement. Period and case scope differ across measures.") ("Cases") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Caseload: Reported inbound referrals in past 3 months
quietly summarize referred_to_lcc_cases_3m, detail
post `s10_post' ("referred_to_lcc_cases_3m") ("Reported inbound referrals in past 3 months") ("Caseload") ///
    ("Chairperson-reported case counts") ("Available responses only; no missing-to-zero replacement. Period and case scope differ across measures.") ("Cases") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Caseload: Reported onward referrals in past 3 months
quietly summarize referred_onward_cases_3m, detail
post `s10_post' ("referred_onward_cases_3m") ("Reported onward referrals in past 3 months") ("Caseload") ///
    ("Chairperson-reported case counts") ("Available responses only; no missing-to-zero replacement. Period and case scope differ across measures.") ("Cases") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Case ratios: Current pending stock divided by recent 3-month inflow
quietly summarize pending_share_3m, detail
post `s10_post' ("pending_share_3m") ("Current pending stock divided by recent 3-month inflow") ("Case ratios") ///
    ("Self-reported practice") ("Existing ratio/ordinal score; not a verified resolution or diversion rate.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Case ratios: Ordinal petty-case composition score
quietly summarize petty_case_share_score, detail
post `s10_post' ("petty_case_share_score") ("Ordinal petty-case composition score") ("Case ratios") ///
    ("Self-reported practice") ("Existing ratio/ordinal score; not a verified resolution or diversion rate.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Referral: Prior formal coordination
quietly summarize prior_formal_coordination, detail
post `s10_post' ("prior_formal_coordination") ("Prior formal coordination") ("Referral") ///
    ("Self-reported prior exposure") ("Separate cross-sectional items; not a longitudinal referral funnel or administrative case flow.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Referral: Reported referral frequency
quietly summarize referral_frequency_score, detail
post `s10_post' ("referral_frequency_score") ("Reported referral frequency") ("Referral") ///
    ("Self-reported practice") ("Separate cross-sectional items; not a longitudinal referral funnel or administrative case flow.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Referral: Reported referral documentation
quietly summarize referral_documentation_score, detail
post `s10_post' ("referral_documentation_score") ("Reported referral documentation") ("Referral") ///
    ("Self-reported practice") ("Separate cross-sectional items; not a longitudinal referral funnel or administrative case flow.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Referral: Reported receiving-authority feedback
quietly summarize referral_feedback_score, detail
post `s10_post' ("referral_feedback_score") ("Reported receiving-authority feedback") ("Referral") ///
    ("Self-reported practice") ("Separate cross-sectional items; not a longitudinal referral funnel or administrative case flow.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Referral: Perceived ease of police coordination
quietly summarize police_coordination_score, detail
post `s10_post' ("police_coordination_score") ("Perceived ease of police coordination") ("Referral") ///
    ("Perception / confidence / attitude") ("Normalized ordinal response, not objective referral performance.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Referral: Perceived ease of court coordination
quietly summarize court_coordination_score, detail
post `s10_post' ("court_coordination_score") ("Perceived ease of court coordination") ("Referral") ///
    ("Perception / confidence / attitude") ("Normalized ordinal response, not objective referral performance.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Referral: Confidence knowing where to refer
quietly summarize referral_path_conf_score, detail
post `s10_post' ("referral_path_conf_score") ("Confidence knowing where to refer") ("Referral") ///
    ("Perception / confidence / attitude") ("Normalized ordinal response, not objective referral performance.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Referral: Confidence explaining referral
quietly summarize referral_explain_conf_score, detail
post `s10_post' ("referral_explain_conf_score") ("Confidence explaining referral") ("Referral") ///
    ("Perception / confidence / attitude") ("Normalized ordinal response, not objective referral performance.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Referral: Verified referral record score
quietly summarize verified_referral_record_score, detail
post `s10_post' ("verified_referral_record_score") ("Verified referral record score") ("Referral") ///
    ("Verified / enumerator-observed") ("Conditional observed records; cannot generalize verification to all 129 LCs.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Referral: Verified referral destination score
quietly summarize verified_ref_dest_score, detail
post `s10_post' ("verified_ref_dest_score") ("Verified referral destination score") ("Referral") ///
    ("Verified / enumerator-observed") ("Conditional observed records; cannot generalize verification to all 129 LCs.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* ADR: Reported agreement documentation
quietly summarize m5_q06_score, detail
post `s10_post' ("m5_q06_score") ("Reported agreement documentation") ("ADR") ///
    ("Self-reported practice") ("Ordinal frequency normalized to 0-1; not a verified case-resolution or compliance rate.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* ADR: Reported follow-up of mediated agreements
quietly summarize m5_q07_score, detail
post `s10_post' ("m5_q07_score") ("Reported follow-up of mediated agreements") ("ADR") ///
    ("Self-reported practice") ("Ordinal frequency normalized to 0-1; not a verified case-resolution or compliance rate.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* ADR: Reported frequency of agreement compliance
quietly summarize m5_q14_score, detail
post `s10_post' ("m5_q14_score") ("Reported frequency of agreement compliance") ("ADR") ///
    ("Self-reported practice") ("Ordinal frequency normalized to 0-1; not a verified case-resolution or compliance rate.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* ADR: Perceived prevention of escalation to police or courts
quietly summarize m5_q16_score, detail
post `s10_post' ("m5_q16_score") ("Perceived prevention of escalation to police or courts") ("ADR") ///
    ("Perception / confidence / attitude") ("Assessment normalized to 0-1; not avoided formal-system entries or a causal estimate.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Legitimacy: Chairperson-perceived LCC fairness
quietly summarize perceived_lcc_fairness_score, detail
post `s10_post' ("perceived_lcc_fairness_score") ("Chairperson-perceived LCC fairness") ("Legitimacy") ///
    ("Perception / confidence / attitude") ("LC chairperson perceptions, not direct community respondents.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Legitimacy: Perceived willingness of community to use LCC
quietly summarize perc_willing_use_lcc_score, detail
post `s10_post' ("perc_willing_use_lcc_score") ("Perceived willingness of community to use LCC") ("Legitimacy") ///
    ("Perception / confidence / attitude") ("LC chairperson perceptions, not direct community respondents.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Legitimacy: Low perceived bypassing
quietly summarize low_bypass_score, detail
post `s10_post' ("low_bypass_score") ("Low perceived bypassing") ("Legitimacy") ///
    ("Perception / confidence / attitude") ("LC chairperson perceptions, not direct community respondents.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Legitimacy: Low perceived favoritism
quietly summarize low_favoritism_influence_score, detail
post `s10_post' ("low_favoritism_influence_score") ("Low perceived favoritism") ("Legitimacy") ///
    ("Perception / confidence / attitude") ("LC chairperson perceptions, not direct community respondents.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Legitimacy: Confidence maintaining trust when referring
quietly summarize conf_trust_when_referring, detail
post `s10_post' ("conf_trust_when_referring") ("Confidence maintaining trust when referring") ("Legitimacy") ///
    ("Perception / confidence / attitude") ("LC chairperson perceptions, not direct community respondents.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Legitimacy: Confidence in fair and respectful handling
quietly summarize conf_fair_respect_score, detail
post `s10_post' ("conf_fair_respect_score") ("Confidence in fair and respectful handling") ("Legitimacy") ///
    ("Perception / confidence / attitude") ("LC chairperson perceptions, not direct community respondents.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Reintegration: Importance of reintegration support
quietly summarize reintegration_importance_score, detail
post `s10_post' ("reintegration_importance_score") ("Importance of reintegration support") ("Reintegration") ///
    ("Perception / confidence / attitude") ("Chairperson norms or assessments; not outcomes experienced by former prisoners.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Reintegration: Willingness to support peaceful return
quietly summarize reintegration_willingness_score, detail
post `s10_post' ("reintegration_willingness_score") ("Willingness to support peaceful return") ("Reintegration") ///
    ("Perception / confidence / attitude") ("Chairperson norms or assessments; not outcomes experienced by former prisoners.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Reintegration: Fair-chance reintegration norm
quietly summarize fair_chance_reintegration_score, detail
post `s10_post' ("fair_chance_reintegration_score") ("Fair-chance reintegration norm") ("Reintegration") ///
    ("Perception / confidence / attitude") ("Chairperson norms or assessments; not outcomes experienced by former prisoners.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Reintegration: Low exclusion norm
quietly summarize low_exclusion_norm_score, detail
post `s10_post' ("low_exclusion_norm_score") ("Low exclusion norm") ("Reintegration") ///
    ("Perception / confidence / attitude") ("Chairperson norms or assessments; not outcomes experienced by former prisoners.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Reintegration: Low reoffending stigma
quietly summarize low_reoffending_stigma_score, detail
post `s10_post' ("low_reoffending_stigma_score") ("Low reoffending stigma") ("Reintegration") ///
    ("Perception / confidence / attitude") ("Chairperson norms or assessments; not outcomes experienced by former prisoners.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Reintegration: Willingness to connect returnees to support
quietly summarize connect_support_willing_score, detail
post `s10_post' ("connect_support_willing_score") ("Willingness to connect returnees to support") ("Reintegration") ///
    ("Perception / confidence / attitude") ("Chairperson norms or assessments; not outcomes experienced by former prisoners.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Reintegration: Reintegration support viewed as leadership role
quietly summarize reint_comm_justice_role, detail
post `s10_post' ("reint_comm_justice_role") ("Reintegration support viewed as leadership role") ("Reintegration") ///
    ("Perception / confidence / attitude") ("Chairperson norms or assessments; not outcomes experienced by former prisoners.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Reintegration: Confidence reducing reintegration tensions
quietly summarize reint_tension_conf_score, detail
post `s10_post' ("reint_tension_conf_score") ("Confidence reducing reintegration tensions") ("Reintegration") ///
    ("Perception / confidence / attitude") ("Chairperson norms or assessments; not outcomes experienced by former prisoners.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Reintegration: Confidence referring returnees for support
quietly summarize reint_referral_conf_score, detail
post `s10_post' ("reint_referral_conf_score") ("Confidence referring returnees for support") ("Reintegration") ///
    ("Perception / confidence / attitude") ("Chairperson norms or assessments; not outcomes experienced by former prisoners.") ("Score (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Reintegration: Reported reintegration issue in past 6 months
quietly summarize recent_reintegration_issue, detail
post `s10_post' ("recent_reintegration_issue") ("Reported reintegration issue in past 6 months") ("Reintegration") ///
    ("Self-reported practice") ("Six-month recall; distinct from the conditional three-month case-type universe.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Useful reintegration support: Family and community acceptance
quietly summarize m11_q10_1, detail
post `s10_post' ("m11_q10_1") ("Family and community acceptance") ("Useful reintegration support") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Useful reintegration support: Livelihood opportunities
quietly summarize m11_q10_2, detail
post `s10_post' ("m11_q10_2") ("Livelihood opportunities") ("Useful reintegration support") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Useful reintegration support: Psychosocial or emotional support
quietly summarize m11_q10_3, detail
post `s10_post' ("m11_q10_3") ("Psychosocial or emotional support") ("Useful reintegration support") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Useful reintegration support: Family or community mediation
quietly summarize m11_q10_4, detail
post `s10_post' ("m11_q10_4") ("Family or community mediation") ("Useful reintegration support") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Useful reintegration support: LC or community leader support
quietly summarize m11_q10_5, detail
post `s10_post' ("m11_q10_5") ("LC or community leader support") ("Useful reintegration support") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Useful reintegration support: Religious or cultural leader support
quietly summarize m11_q10_6, detail
post `s10_post' ("m11_q10_6") ("Religious or cultural leader support") ("Useful reintegration support") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Useful reintegration support: Legal or administrative support
quietly summarize m11_q10_7, detail
post `s10_post' ("m11_q10_7") ("Legal or administrative support") ("Useful reintegration support") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Useful reintegration support: Skills training or education
quietly summarize m11_q10_8, detail
post `s10_post' ("m11_q10_8") ("Skills training or education") ("Useful reintegration support") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Perceived reintegration barriers: Fear of reoffending
quietly summarize m11_q12_1, detail
post `s10_post' ("m11_q12_1") ("Fear of reoffending") ("Perceived reintegration barriers") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Perceived reintegration barriers: Fear of violence or conflict
quietly summarize m11_q12_2, detail
post `s10_post' ("m11_q12_2") ("Fear of violence or conflict") ("Perceived reintegration barriers") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Perceived reintegration barriers: Shame or stigma
quietly summarize m11_q12_3, detail
post `s10_post' ("m11_q12_3") ("Shame or stigma") ("Perceived reintegration barriers") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Perceived reintegration barriers: Lack of trust
quietly summarize m11_q12_4, detail
post `s10_post' ("m11_q12_4") ("Lack of trust") ("Perceived reintegration barriers") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Perceived reintegration barriers: Unresolved victim or family relationships
quietly summarize m11_q12_5, detail
post `s10_post' ("m11_q12_5") ("Unresolved victim or family relationships") ("Perceived reintegration barriers") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Perceived reintegration barriers: Lack of livelihood
quietly summarize m11_q12_6, detail
post `s10_post' ("m11_q12_6") ("Lack of livelihood") ("Perceived reintegration barriers") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Perceived reintegration barriers: Weak support structures
quietly summarize m11_q12_7, detail
post `s10_post' ("m11_q12_7") ("Weak support structures") ("Perceived reintegration barriers") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))

* Perceived reintegration barriers: Lack of knowledge about reintegration support
quietly summarize m11_q12_8, detail
post `s10_post' ("m11_q12_8") ("Lack of knowledge about reintegration support") ("Perceived reintegration barriers") ///
    ("Perception / confidence / attitude") ("Multiple-response: share of chairpersons selecting option; not share of former prisoners or cases.") ("Proportion (0-1)") ///
    (r(N)) (cond(r(N)>0, r(sum), .)) (r(mean)) (r(sd)) (r(p50)) (_N-r(N))
postclose `s10_post'
preserve
    use `s10_metrics', clear
    isid variable
    assert n + missing_n == 129
    assert missing(total) & missing(mean) if n == 0
    format total mean sd median %12.6f
    export excel using "`excel_ind'", sheet("section10_metrics", replace) firstrow(variables)
restore
* Stock/flow diagnostic, not an automatic error: current pending cases can have
* arrived before the three-month inflow window. Do not subtract stock from inflow
* to manufacture a count of resolved cases.
putexcel set "`excel_ind'", sheet("section10_notes", replace) modify
putexcel A1 = "Item" B1 = "Definition / interpretation"
putexcel A2 = "Population" B2 = "129 unique canonical LCs; all selected and consented."
putexcel A3 = "Mean" B3 = "Sum of observed scores/counts divided by nonmissing N; no imputation."
putexcel A4 = "Binary measure" B4 = "Total is the number selecting/meeting the criterion; proportion = total/N."
putexcel A5 = "Ordinal score" B5 = "Mean of locked normalized scores, not a percentage of cases or people achieving an outcome."
putexcel A6 = "Total" B6 = "Sum across observed LC interviews only; missing if N=0. Not population extrapolation."
putexcel A7 = "M3_Q09" B7 = "Reported community-brought cases - respondent scope ambiguous. Question excludes disputing parties; hint includes a party. Not formal diversion."
putexcel A8 = "Pending ratio" B8 = "Current pending stock/recent inflow; existing valid 0-1 ratios only. Not a closure rate."
putexcel A9 = "Petty composition" B9 = "M3_Q06 categories 0-5 divided by 5. Unequal response bands; do not multiply this score by caseload to estimate petty-case totals."
putexcel A10 = "Formal indicators" B10 = "Cross-sectional survey benchmarks cannot establish reduction/increase, remand, costs, formal-system flows, graduate performance, or replication."
quietly count if flag_pending_gt_3m == 1
putexcel A11 = "Pending stock exceeds recent inflow: count" B11 = (r(N))
quietly count if !missing(flag_pending_gt_3m)
putexcel A12 = "Pending stock/inflow comparison: N" B12 = (r(N))
putexcel A13 = "Missing referral counts" B13 = "M3_Q10/M3_Q12 have no observed final values; blank totals are not zero."
putexcel A14 = "Readiness" B14 = "Existing >=0.75 diagnostic flags only. No assessed graduates, final mentor eligibility or ranking."
putexcel A15 = "Reproducibility" B15 = "Data Analysis do-file section 21a; final phase1_baseline_analysis.dta; output sheets section10_metrics and section10_crosswalk."
putexcel clear
quietly datasignature
assert "`r(datasignature)'" == "`s10_signature_before'"
display as result "Section 10: N=129; all input values unchanged; survey benchmarks exported."

* Slide codes are retained for traceability, not used to renumber the revised SOW.
putexcel set "`excel_ind'", sheet("section10_crosswalk", replace) modify
putexcel A1 = "Slide 57 code" B1 = "Revised SOW code" C1 = "Indicator area" ///
    D1 = "Survey variable" E1 = "Statistic" F1 = "Survey benchmark value" ///
    G1 = "Observed N" H1 = "Relationship" I1 = "Limitation"
quietly summarize m5_q16_score, meanonly
putexcel A2 = "0.0.1" B2 = "0.0.1" C2 = "Reduction in petty cases entering formal justice" ///
    D2 = "m5_q16_score" E2 = "mean" F2 = (r(mean)) ///
    G2 = (r(N)) H2 = "Perception benchmark only" I2 = "Perceived prevention of escalation; no formal-system inflow or change observed."
putexcel A3 = "0.0.2" B3 = "0.0.2" C3 = "Reduction of remandees" ///
    D3 = "" E3 = "" F3 = "Not measured" ///
    G3 = "Not applicable" H3 = "Not measured" I3 = "No prison population or remand-status observations."
quietly summarize idx_reintegration_norms, meanonly
putexcel A4 = "0.0.3" B4 = "0.0.3" C4 = "Favourable reintegration conditions" ///
    D4 = "idx_reintegration_norms" E4 = "mean" F4 = (r(mean)) ///
    G4 = (r(N)) H4 = "Partial proxy" I4 = "Chairperson norms; not observed conditions or reincarceration among former prisoners."
putexcel A5 = "0.0.4" B5 = "0.0.4 (cost)" C5 = "Cost per petty case diverted" ///
    D5 = "" E5 = "" F5 = "Not measured" ///
    G5 = "Not applicable" H5 = "Not measured" I5 = "Neither programme costs nor attributable formal entries avoided are observed."
quietly summarize pending_cases, meanonly
putexcel A6 = "0.0.5" B6 = "4.1.2" C6 = "Reduction in case backlog" ///
    D6 = "pending_cases" E6 = "total" F6 = (cond(r(N)>0,r(sum),.)) ///
    G6 = (r(N)) H6 = "Context benchmark only" I6 = "Current LC pending stock, not formal-court backlog or its reduction."
quietly summarize idx_perceived_legitimacy, meanonly
putexcel A7 = "0.0.6" B7 = "0.0.4 (confidence)" C7 = "Increased community confidence" ///
    D7 = "idx_perceived_legitimacy" E7 = "mean" F7 = (r(mean)) ///
    G7 = (r(N)) H7 = "Partial proxy" I7 = "Chairperson perceptions, not community respondents or change over time. Duplicate 0.0.4 in Scope of Work remains unresolved."
quietly summarize caseload_3m, meanonly
putexcel A8 = "1.1.1" B8 = "1.1.1" C8 = "Increase in petty cases resolved through local ADR" ///
    D8 = "caseload_3m" E8 = "total" F8 = (cond(r(N)>0,r(sum),.)) ///
    G8 = (r(N)) H8 = "Context benchmark only" I8 = "Cases received of all types, not documented eligible petty-case resolutions."
quietly summarize directly_brought_cases_3m, meanonly
putexcel A9 = "1.1.2" B9 = "1.1.2" C9 = "Increase in cases formally referred to LCC ADR" ///
    D9 = "directly_brought_cases_3m" E9 = "total" F9 = (cond(r(N)>0,r(sum),.)) ///
    G9 = (r(N)) H9 = "Context benchmark only" I9 = "Reported community-brought cases: respondent scope ambiguous. Not formal diversion. Inbound referral counts have N=0."
putexcel A10 = "2.1" B10 = "2.1" C10 = "Reduction in time on remand" ///
    D10 = "" E10 = "" F10 = "Not measured" ///
    G10 = "Not applicable" H10 = "Not measured" I10 = "No individual remand durations. Scope of Work unit is hours."
putexcel A11 = "3.1.4" B11 = "3.1.5" C11 = "Use of prison-acquired skills for income after release" ///
    D11 = "" E11 = "" F11 = "Not measured" ///
    G11 = "Not applicable" H11 = "Not measured" I11 = "Chairpersons are not a sample of trained released prisoners; no income or skills-use outcome."
quietly summarize prior_formal_coordination, meanonly
putexcel A12 = "4.1.1" B12 = "4.1.1" C12 = "JLOS improvements linked to advocacy" ///
    D12 = "prior_formal_coordination" E12 = "mean" F12 = (r(mean)) ///
    G12 = (r(N)) H12 = "Mechanism benchmark only" I12 = "Prior LC coordination, not sector reform or an effect of advocacy."
quietly summarize high_mentor_readiness_proxy, meanonly
putexcel A13 = "4.1.7" B13 = "Not located in revised SOW" C13 = "LC graduates independently executing duties" ///
    D13 = "high_mentor_readiness_proxy" E13 = "mean" F13 = (r(mean)) ///
    G13 = (r(N)) H13 = "Preparatory diagnostic only" I13 = "Existing baseline >=0.75 proxy; not graduates, assessed competence or final mentor selection."
putexcel A14 = "5.1.1" B14 = "Not located in revised SOW" C14 = "Programme models scaled or replicated" ///
    D14 = "" E14 = "" F14 = "Not measured" ///
    G14 = "Not applicable" H14 = "Not measured" I14 = "No survey measure or verified replication inventory. Do not impute zero."
putexcel A15 = "Not on Slide 57" B15 = "2.2" C15 = "Legal-aid remandees heard within 60 days" ///
    D15 = "" E15 = "" F15 = "Not measured" ///
    G15 = "Not applicable" H15 = "Not measured" I15 = "No linked detention, legal-aid eligibility or first-hearing dates."
putexcel A1:I1, bold txtwrap
putexcel F2:F15, nformat("0.000")
putexcel clear

* END SECTION 10 REPRODUCIBLE BENCHMARKS


*------------------------------------------------------------------------------*
**# 22. Final validation and close
*------------------------------------------------------------------------------*

assert _N == 129
isid canonical_village_uid
assert analysis_sample == 1
assert consent == 1
local index_counter = 0
foreach v of local all_indices {
    assert inrange(`v', 0, 1) if !missing(`v')
    quietly summarize `v', meanonly
    local ++index_counter
    assert r(N) == `index_n`index_counter''
    assert abs(r(sum) - `index_sum`index_counter'') < 1e-10
}

copy "`excel_exec'" "`excel_exec_final'", replace
copy "`excel_items'" "`excel_items_final'", replace
copy "`excel_origin'" "`excel_origin_final'", replace
copy "`excel_reg'" "`excel_reg_final'", replace
copy "`excel_ind'" "`excel_ind_final'", replace
copy "`excel_jlos'" "`excel_jlos_final'", replace

local png_files : dir "`fig_dir'" files "*.png"
foreach f of local png_files {
    copy "`fig_dir'/`f'" "`fig_dir_final'/`f'", replace
}
local pdf_files : dir "`fig_dir'" files "*.pdf"
foreach f of local pdf_files {
    copy "`fig_dir'/`f'" "`fig_dir_final'/`f'", replace
}

foreach f in "`excel_exec_final'" "`excel_items_final'" "`excel_origin_final'" "`excel_reg_final'" "`excel_ind_final'" "`excel_jlos_final'" {
    confirm file `"`f'"'
}
foreach f in fig_02_core_indices_overall fig_04_priority_gaps fig_13_vignette_performance ///
    fig_14_adr_mediation fig_15_adr_barriers fig_39_jlos_referral_loop ///
    fig_40_records_committee_constraints fig_41_legitimacy_safeguards_reintegration ///
    fig_42_adjusted_origin_coefficients {
    confirm file "`fig_dir_final'/`f'.png"
    confirm file "`fig_dir_final'/`f'.pdf"
}

display as result "Final Phase 1 baseline analysis complete: N=" _N
display as result "Main workbook: `excel_exec_final'"
display as result "Supplementary workbook: `excel_items_final'"
display as result "Origin comparison workbook: `excel_origin_final'"
display as result "Regression workbook: `excel_reg_final'"
display as result "Indicator workbook: `excel_ind_final'"
display as result "Figures folder: `fig_dir_final'"
display as result "Log file: `log_dir'/phase1_baseline_executive_analysis.log"

log close

/*******************************************************************************
End of file
*******************************************************************************/




















