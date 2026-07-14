/*------------------------------------------------------------------------------*
| Title: 			Data Analysis												|
| Project: 			Advancing Justice Uganda LC training RCT				   	|
| Authors:			Jorge Zavala 												|
| 					  									                        |
|																				|
| Description:		This .do performs statistical analysis of cleaned data		|
|                                                                               |
| Date created: 24/04/2026			 					                        |										          
|																			    |
| Version: Stata 13/16 	                    							 	    |
*-------------------------------------------------------------------------------*/

/*--------------------------*
*           INDEX           *
*---------------------------*


		

*-------------------------------------------------------------------------------*/

clear all


*-------------------------------*
**#		Baseline analysis		*
*-------------------------------*
{
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
local fig_dir  "`exec_dir'/figures"
local tab_dir  "`exec_dir'/tables"
local log_dir  "`exec_dir'/logs"

capture mkdir "`exec_dir'"
capture mkdir "`fig_dir'"
capture mkdir "`tab_dir'"
capture mkdir "`log_dir'"

local excel_exec  "`tab_dir'/phase1_baseline_executive_results.xlsx"
local excel_items "`tab_dir'/phase1_baseline_all_item_tabulations.xlsx"

capture erase "`excel_exec'"
capture erase "`excel_items'"

capture log close _all
log using "`log_dir'/phase1_baseline_executive_analysis.log", replace text

set scheme plotplain
graph set window fontface "Arial"

use "`analysis_data'", clear

keep if analysis_sample == 1

* Basic integrity checks
isid survey_record_id
capture isid submission_key
if _rc {
    display as error "Warning: submission_key is not unique. Review before using item-level exports."
}

* Encode district for regressions/tables where needed
capture drop district_id
encode district_scto, gen(district_id)
label var district_id "District numeric ID from SurveyCTO-selected district"

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
capture label var m5_q14_score "Appropriate response to non-compliance with mediated agreement"
capture label var m5_q16_score "Knowledge of when ADR is not appropriate"

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
putexcel A1 = "Advancing Justice Uganda - Phase 1 Baseline Executive Analysis"
putexcel A3 = "Purpose"
putexcel B3 = "Targeted pre-intervention descriptive analysis for CDFU/FCDU meeting with implementation team."
putexcel A4 = "Input dataset"
putexcel B4 = "`analysis_data'"
putexcel A5 = "Analysis sample"
putexcel B5 = "Consented SurveyCTO submissions only."
putexcel A6 = "Causal status"
putexcel B6 = "Descriptive baseline analysis only. Phase 1 is not the causal RCT stage."
putexcel A7 = "Main caveat"
putexcel B7 = "Replacement-village corrections are pending record-level mapping; sample-frame metadata should not yet be used substantively."
putexcel A8 = "Generated outputs"
putexcel B8 = "Executive workbook, all-item workbook, figures, and analysis log."
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

*------------------------------------------------------------------------------*
**# 2. Sample, fieldwork, and data-quality profile
*------------------------------------------------------------------------------*

* 2.1 District distribution
preserve
    contract district_scto
    rename _freq n_records
    gen percent = 100 * n_records / _N
    quietly summarize n_records, meanonly
    replace percent = 100 * n_records / r(sum)
    export excel using "`excel_exec'", sheet("sample_district", replace) firstrow(variables)

    graph bar n_records, over(district_scto, label(angle(0))) ///
        blabel(bar, format(%9.0f)) ///
        ytitle("Number of interviews") ///
        title("Phase 1 baseline sample by district", size(medsmall))
    graph export "`fig_dir'/fig_01_sample_by_district.png", width(2400) replace
    graph export "`fig_dir'/fig_01_sample_by_district.pdf", replace
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
    keep duration_min interview_date district_scto
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
    keep district_scto duration_min
    collapse (count) n=duration_min ///
        (mean) mean=duration_min ///
        (p50) median=duration_min ///
        (min) min=duration_min ///
        (max) max=duration_min, by(district_scto)
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
    keep survey_record_id submission_key interview_date enum district_scto subcounty_scto parish_scto village_scto ///
        actual_village duration_min
    sort district_scto subcounty_scto parish_scto village_scto interview_date
    export excel using "`excel_exec'", sheet("duplicate_villages", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 3. Executive index dashboard and mentor-readiness profile
*------------------------------------------------------------------------------*

* 3.1 Overall index summary and graph
aju_mean_table `all_indices', sheet("index_summary") module("Core and composite indices") ///
    graph("fig_02_core_indices_overall") ///
    title("Average baseline scores across core domains") gap

* 3.2 Index means by district
preserve
    keep survey_record_id district_scto `all_indices'
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

    collapse (count) n=index_value (mean) mean=index_value (sd) sd=index_value, by(district_scto domain)
    export excel using "`excel_exec'", sheet("index_by_district", replace) firstrow(variables)

    keep if inlist(domain,"Operational capacity","Case-handling quality","Legitimacy and reintegration","Mentor-readiness proxy")
    graph bar mean, over(domain, label(angle(35) labsize(vsmall))) over(district_scto) ///
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

    graph hbar gap_to_full_score, over(domain, sort(gap_to_full_score) label(labsize(vsmall))) ///
        blabel(bar, format(%4.2f) size(vsmall)) ///
        ytitle("Gap to full score: 1 - mean") ///
        title("Training priority gaps by baseline domain", size(medsmall)) ///
        note("Higher values identify domains where pre-training scores leave more room for improvement.", size(vsmall))
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
    keep district_scto `chair_profile'
    collapse (count) n=idx_respondent_capacity (mean) `chair_profile', by(district_scto)
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
    keep district_scto `institutional_vars'
    collapse (count) n=idx_institutional_functioning (mean) `institutional_vars', by(district_scto)
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
    keep district_scto `caseload_vars'
    collapse (count) n=caseload_3m (mean) `caseload_vars' ///
        (p50) median_caseload_3m=caseload_3m, by(district_scto)
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
    keep survey_record_id submission_key interview_date enum district_scto subcounty_scto parish_scto village_scto ///
        actual_village duration_min caseload_30d caseload_3m pending_cases flag_pending_gt_3m flag_any_data_quality_issue
    gsort -caseload_3m district_scto subcounty_scto parish_scto village_scto
    export excel using "`excel_exec'", sheet("caseload_outliers", replace) firstrow(variables)
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
* This workbook is intentionally broader than the executive presentation. It gives
* Ivan/CDFU and the internal team a complete reference of item-level responses.

putexcel set "`excel_items'", replace sheet("README")
putexcel A1 = "Advancing Justice Uganda - Phase 1 baseline all-item tabulations"
putexcel A3 = "Purpose"
putexcel B3 = "Complete internal reference workbook: numeric summaries and categorical tabulations for SurveyCTO raw items and constructed analysis variables."
putexcel A4 = "Caveat"
putexcel B4 = "String/free-text notes are summarized for missingness only, not fully tabulated. Fully missing/not-fielded numeric variables are flagged in numeric_field_status."
putexcel A5 = "Input"
putexcel B5 = "`analysis_data'"

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
**# 17. Final notes and close
*------------------------------------------------------------------------------*

display as result "Executive analysis complete."
display as result "Executive workbook: `excel_exec'"
display as result "All-item workbook: `excel_items'"
display as result "Figures folder: `fig_dir'"
display as result "Log file: `log_dir'/phase1_baseline_executive_analysis.log"

log close


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

*-------------------------------*
**# 18.0 Setup
*-------------------------------*

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
local fig_dir  "`exec_dir'/figures"
local tab_dir  "`exec_dir'/tables"
local log_dir  "`exec_dir'/logs"

capture mkdir "`exec_dir'"
capture mkdir "`fig_dir'"
capture mkdir "`tab_dir'"
capture mkdir "`log_dir'"

local excel_origin "`tab_dir'/phase1_baseline_origin_comparison.xlsx"

use "`analysis_data'", clear

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
tab district_scto p1_admin_previously_contacted, row missing

count if p1_admin_previously_contacted == 1
display as result "Previously contacted records: " r(N)
if r(N) != 28 {
    display as error "WARNING: Expected 28 previously contacted records."
}

count if p1_admin_previously_contacted == 0
display as result "New/randomly selected records: " r(N)

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
putexcel B6 = "Descriptive baseline differences only. These are not causal effects of prior exposure."
putexcel A7 = "Recommended use"
putexcel B7 = "Use for 3-4 presentation slides comparing key readiness, JLOS collaboration, priority gaps, and mentor-readiness flags."

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
    contract district_scto p1_admin_previously_contacted, freq(n)
    bysort district_scto: egen district_total = total(n)
    gen district_share = n / district_total
    format district_share %9.3f
    decode p1_admin_previously_contacted, gen(origin_group)
    order district_scto p1_admin_previously_contacted origin_group n district_total district_share
    export excel using "`excel_origin'", sheet("sample_by_district_origin", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 18.2 Candidate high-level variable list for differential analysis
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
    export excel using "`excel_origin'", sheet("candidate_diff_table", replace) firstrow(variables)

    * Ranked table across all domains
    gsort -abs_diff
    export excel using "`excel_origin'", sheet("ranked_abs_differences", replace) firstrow(variables)

    * More conservative presentation candidate table: high-level outcomes only
    keep if inlist(domain, "Core composites", "Domain indices", "JLOS/referral collaboration", ///
        "Records and safeguards", "Legitimacy and reintegration", "Mentor-readiness flags")
    gsort -abs_diff
    export excel using "`excel_origin'", sheet("presentation_candidates", replace) firstrow(variables)
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
    idx_referral_practice ///
    idx_record_quality ///
    idx_perceived_legitimacy ///
    idx_safeguards ///
    idx_reintegration_norms ///
    prior_formal_coordination ///
    police_coordination_score ///
    court_coordination_score ///
    referral_feedback_score ///
    verified_referral_record_score ///
    high_mentor_readiness_proxy

foreach y of local regression_outcomes {
    capture confirm numeric variable `y'
    if !_rc {
        quietly count if !missing(`y', p1_admin_previously_contacted, district_scto)
        local n = r(N)

        quietly summarize `y' if p1_admin_previously_contacted == 0, meanonly
        local mean0 = r(mean)

        quietly summarize `y' if p1_admin_previously_contacted == 1, meanonly
        local mean1 = r(mean)

        local b = .
        local se = .
        local p = .

        if `n' > 5 {
            capture quietly regress `y' i.p1_admin_previously_contacted i.district_scto, vce(robust)
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
    format coef_prev_contacted se p_value mean_new mean_prev raw_diff_prev_minus_new %9.3f
    order outcome label n mean_new mean_prev raw_diff_prev_minus_new coef_prev_contacted se p_value
    export excel using "`excel_origin'", sheet("district_adjusted_diagnostics", replace) firstrow(variables)
restore


*------------------------------------------------------------------------------*
**# 18.9 Console summary for presentation notes
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

display as text "Recommended presentation use:"
display as text "1. One slide on core baseline profile differences."
display as text "2. One slide on JLOS collaboration and referral pathways."
display as text "3. One slide on priority implementation gaps."
display as text "4. One slide on mentor-readiness / high-capacity flags."
display as text "------------------------------------------------------------"



*------------------------------------------------------------------------------*
**# 19. Annex analysis: expanded JLOS collaboration and referral pathways
*------------------------------------------------------------------------------*
* Purpose:
*   Produce 4 slide-ready figures expanding the analysis of collaboration with
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
**# 19.0 Setup
*-------------------------------*

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
local fig_dir  "`exec_dir'/figures"
local tab_dir  "`exec_dir'/tables"

capture mkdir "`exec_dir'"
capture mkdir "`fig_dir'"
capture mkdir "`tab_dir'"

local excel_jlos "`tab_dir'/phase1_baseline_jlos_expanded_analysis.xlsx"

use "`analysis_data'", clear

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
    local l6  "Knows where to refer"
    local v7  referral_explain_conf_score
    local l7  "Can explain referral"
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
        6 "Knows where to refer" ///
        7 "Can explain referral" ///
        8 "Referral documentation" ///
        9 "Feedback after referral", replace
    label values item_id jlos_snap_lbl

    export excel using "`excel_jlos'", sheet("fig36_jlos_snapshot", replace) firstrow(variables)

graph hbar (asis) value, ///
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
    local l5  "Knows/explains referral pathway"
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
        5 "Knows/explains pathway" ///
        6 "Documentation and feedback" ///
        7 "Verified referral record", replace
    label values item_id jlos_path_lbl

    export excel using "`excel_jlos'", sheet("fig39_referral_loop", replace) firstrow(variables)

graph hbar (asis) value, ///
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
    keep district_scto ///
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
        by(district_scto)

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
display as text "Recommended placement: Referrals and Coordination section, immediately after the current Referral Practice and Coordination slide."
display as text "------------------------------------------------------------"







/*******************************************************************************
End of file
*******************************************************************************/	
}




















