/*------------------------------------------------------------------------------*
| Title:            Phase 1 baseline data-quality pipeline                      |
| Project:          Advancing Justice Uganda LC training for case diversion     |
| Purpose:          Audit the cleaned Phase 1 baseline without changing source  |
| Version:          Stata 19                                                    |
|                                                                                |
| Main outputs (all written to ${baseline_qa_output_dir}):                       |
|   phase1_baseline_dq_report.xlsx       Human-readable QA workbook              |
|   phase1_baseline_dq_issues.dta/.csv   One row per record x issue              |
|   phase1_baseline_dq_record_flags.dta  De-identified record review file        |
|   phase1_baseline_dq_tagged.dta        Analysis data plus qa_* flags           |
|   phase1_baseline_dq_check_summary.dta One row per automated check             |
|   phase1_baseline_dq_release_status.txt Release gate                           |
|   phase1_baseline_dq.log               Reproducible Stata log                  |
|                                                                                |
| The source data are never overwritten. Data problems block the release gate   |
| but do not stop the pipeline. Only structural failures (for example a missing |
| input file) stop execution.                                                    |
*-------------------------------------------------------------------------------*/

version 19
set more off

*------------------------------------------------------------------------------*
**# 0. Configuration and preflight
*------------------------------------------------------------------------------*

if `"${input_dir}"' == "" {
    display as error "Global input_dir is not defined. Run the master code first."
    exit 198
}

* These globals can be defined before this do-file to override the defaults.
if `"${baseline_qa_input}"' == "" {
    global baseline_qa_input "${input_dir}/2 Working/phase1_baseline_clean.dta"
}
if `"${baseline_qa_raw_input}"' == "" {
    global baseline_qa_raw_input "${input_dir}/1 Raw/Primary data/Phase 1 Baseline_Runyankore_WIDE.xlsx"
}
if `"${baseline_qa_output_dir}"' == "" {
    global baseline_qa_output_dir "${input_dir}/3 Coded/Phase1_Baseline_QA"
}
if `"${baseline_qa_expected_n}"' == "" global baseline_qa_expected_n 128
if `"${baseline_qa_expected_villages}"' == "" global baseline_qa_expected_villages 128
if `"${baseline_qa_expected_admin_added}"' == "" global baseline_qa_expected_admin_added 28
if `"${baseline_qa_field_start}"' == "" global baseline_qa_field_start "18may2026"
if `"${baseline_qa_field_end}"' == "" global baseline_qa_field_end "05jun2026"
if `"${baseline_qa_min_duration}"' == "" global baseline_qa_min_duration 20
if `"${baseline_qa_max_duration}"' == "" global baseline_qa_max_duration 120
if `"${baseline_qa_early_hour}"' == "" global baseline_qa_early_hour 6
if `"${baseline_qa_late_hour}"' == "" global baseline_qa_late_hour 20

local qa_input `"${baseline_qa_input}"'
local qa_raw_input `"${baseline_qa_raw_input}"'
local qa_dir   `"${baseline_qa_output_dir}"'

capture confirm file `"`qa_input'"'
if _rc {
    display as error "Baseline QA input not found: `qa_input'"
    exit 601
}

local qa_raw_available = 1
capture confirm file `"`qa_raw_input'"'
if _rc local qa_raw_available = 0

capture mkdir `"`qa_dir'"'
capture log close baseline_qa
log using `"`qa_dir'/phase1_baseline_dq.log"', text replace name(baseline_qa)

display as text "------------------------------------------------------------"
display as text "Phase 1 baseline data-quality pipeline"
display as result "Input:  `qa_input'"
display as result "Raw:    `qa_raw_input'"
display as result "Output: `qa_dir'"
display as result "Run:    $S_DATE $S_TIME"
display as text "------------------------------------------------------------"

use `"`qa_input'"', clear
if _N == 0 {
    display as error "The baseline QA input contains no observations."
    log close baseline_qa
    exit 2000
}

local qa_source_n = _N
local qa_source_k = c(k)

*------------------------------------------------------------------------------*
**# 1. Internal issue-registry programs
*------------------------------------------------------------------------------*

tempfile qa_issues_acc qa_checks_acc
global QA_ISSUES_ACC `"`qa_issues_acc'"'
global QA_CHECKS_ACC `"`qa_checks_acc'"'

preserve
    clear
    gen long   qa_row_id = .
    gen str80  qa_record_id = ""
    gen str80  qa_enumerator = ""
    gen str80  qa_district = ""
    gen str100 qa_subcounty = ""
    gen str100 qa_parish = ""
    gen str120 qa_village = ""
    gen str40  check_id = ""
    gen str8   severity = ""
    gen str24  domain = ""
    gen str16  module = ""
    gen str64  variable = ""
    gen str244 issue = ""
    gen str244 observed_value = ""
    save "${QA_ISSUES_ACC}", replace
restore

preserve
    clear
    gen str40  check_id = ""
    gen str8   severity = ""
    gen str24  domain = ""
    gen str16  module = ""
    gen str64  variable = ""
    gen str244 issue = ""
    gen long   n_tested = .
    gen long   n_issues = .
    gen double issue_rate = .
    gen str8   status = ""
    save "${QA_CHECKS_ACC}", replace
restore

capture program drop _qa_register
program define _qa_register
    version 19
    syntax, CHECKID(string) SEVERITY(string) DOMAIN(string) MODULE(string) ///
        VARIABLE(string) MESSAGE(string) NTESTED(integer) NISSUES(integer)

    preserve
        clear
        set obs 1
        gen str40  check_id = substr(`"`checkid'"', 1, 40)
        gen str8   severity = upper(substr(`"`severity'"', 1, 8))
        gen str24  domain = substr(`"`domain'"', 1, 24)
        gen str16  module = substr(`"`module'"', 1, 16)
        gen str64  variable = substr(`"`variable'"', 1, 64)
        gen str244 issue = substr(`"`message'"', 1, 244)
        gen long   n_tested = `ntested'
        gen long   n_issues = `nissues'
        gen double issue_rate = n_issues / n_tested if n_tested > 0
        gen str8 status = "PASS"
        replace status = "FAIL" if n_issues > 0 & severity == "ERROR"
        replace status = "REVIEW" if n_issues > 0 & severity == "WARNING"
        replace status = "INFO" if n_issues > 0 & severity == "INFO"
        append using "${QA_CHECKS_ACC}"
        save "${QA_CHECKS_ACC}", replace
    restore
end

capture program drop _qa_add_issue
program define _qa_add_issue
    version 19
    syntax, CONDITION(string) CHECKID(string) SEVERITY(string) DOMAIN(string) ///
        MODULE(string) VARIABLE(string) MESSAGE(string) [ELIGIBLE(string) OBSERVED(varname)]

    quietly count if `condition'
    local n_issues = r(N)
    local n_tested = _N
    if `"`eligible'"' != "" {
        quietly count if `eligible'
        local n_tested = r(N)
    }

    _qa_register, checkid(`"`checkid'"') severity(`"`severity'"') ///
        domain(`"`domain'"') module(`"`module'"') variable(`"`variable'"') ///
        message(`"`message'"') ntested(`n_tested') nissues(`n_issues')

    if `n_issues' == 0 exit

    preserve
        keep if `condition'
        gen str40  check_id = substr(`"`checkid'"', 1, 40)
        gen str8   severity = upper(substr(`"`severity'"', 1, 8))
        gen str24  domain = substr(`"`domain'"', 1, 24)
        gen str16  module = substr(`"`module'"', 1, 16)
        gen str64  variable = substr(`"`variable'"', 1, 64)
        gen str244 issue = substr(`"`message'"', 1, 244)
        gen str244 observed_value = ""

        if `"`observed'"' != "" {
            capture confirm string variable `observed'
            if !_rc replace observed_value = substr(`observed', 1, 244)
            else {
                local observed_format : format `observed'
                replace observed_value = string(`observed', `"`observed_format'"')
            }
        }

        keep qa_row_id qa_record_id qa_enumerator qa_district qa_subcounty ///
            qa_parish qa_village check_id severity domain module variable issue observed_value
        append using "${QA_ISSUES_ACC}"
        save "${QA_ISSUES_ACC}", replace
    restore
end

capture program drop _qa_check_vallabel
program define _qa_check_vallabel
    version 19
    syntax varname

    local vlabel : value label `varlist'
    if `"`vlabel'"' == "" exit

    local qamodule "metadata"
    if regexm(lower(`"`varlist'"'), "^m([0-9]+)_") local qamodule = "M" + regexs(1)
    local checkid = substr("VALUE_LABEL_`varlist'", 1, 40)
    tempfile valid_values

    preserve
        capture quietly uselabel `vlabel', clear
        if _rc {
            restore
            exit
        }
        keep value
        duplicates drop value, force
        rename value __qa_valid_value
        save `valid_values', replace
    restore

    preserve
        keep qa_row_id qa_record_id qa_enumerator qa_district qa_subcounty ///
            qa_parish qa_village `varlist'
        drop if missing(`varlist')
        gen double __qa_valid_value = `varlist'
        merge m:1 __qa_valid_value using `valid_values', keep(master match) gen(__qa_vlmerge)
        _qa_add_issue, condition("__qa_vlmerge == 1") checkid(`"`checkid'"') ///
            severity("ERROR") domain("range") module(`"`qamodule'"') ///
            variable(`"`varlist'"') message("Observed code has no definition in its attached value label") ///
            observed(`varlist')
    restore
end

capture program drop _qa_exclusive
program define _qa_exclusive
    version 19
    syntax, EXCLUSIVE(varname) OTHERS(varlist) CHECKID(string) MODULE(string) MESSAGE(string)
    tempvar qa_other_count
    egen double `qa_other_count' = rowtotal(`others')
    _qa_add_issue, condition("`exclusive' == 1 & `qa_other_count' > 0") ///
        checkid(`"`checkid'"') severity("ERROR") domain("select_multiple") ///
        module(`"`module'"') variable(`"`exclusive'"') message(`"`message'"') ///
        eligible("qa_eligible == 1") observed(`exclusive')
end

capture program drop _qa_maxselect
program define _qa_maxselect
    version 19
    syntax varlist, MAX(integer) CHECKID(string) MODULE(string) MESSAGE(string)
    tempvar qa_selected_count
    egen double `qa_selected_count' = rowtotal(`varlist')
    _qa_add_issue, condition("`qa_selected_count' > `max'") ///
        checkid(`"`checkid'"') severity("ERROR") domain("select_multiple") ///
        module(`"`module'"') variable("`varlist'") message(`"`message'"') ///
        eligible("qa_eligible == 1") observed(`qa_selected_count')
end

capture program drop _qa_other_specify
program define _qa_other_specify
    version 19
    syntax, TRIGGER(varname) OTHER(varname) CHECKID(string) MODULE(string)
    _qa_add_issue, condition("`trigger' == 1 & missing(`other')") ///
        checkid(`"`checkid'_MISS"') severity("WARNING") domain("skip_logic") ///
        module(`"`module'"') variable(`"`other'"') ///
        message("Other was selected but the specify field is empty") ///
        eligible("qa_eligible == 1 & `trigger' == 1") observed(`other')
    _qa_add_issue, condition("`trigger' != 1 & !missing(`trigger') & !missing(`other')") ///
        checkid(`"`checkid'_STRAY"') severity("WARNING") domain("skip_logic") ///
        module(`"`module'"') variable(`"`other'"') ///
        message("Specify text or value is present although Other was not selected") ///
        eligible("qa_eligible == 1 & `trigger' != 1 & !missing(`trigger')") observed(`other')
end

*------------------------------------------------------------------------------*
**# 2. Stable QA identifiers and schema checks
*------------------------------------------------------------------------------*

capture drop qa_*
gen long qa_row_id = _n

gen str80 qa_record_id = ""
capture confirm variable submission_key
if !_rc {
    capture confirm string variable submission_key
    if !_rc replace qa_record_id = substr(submission_key, 1, 80)
    else replace qa_record_id = string(submission_key, "%21.0g") if !missing(submission_key)
}
replace qa_record_id = "row:" + string(qa_row_id, "%09.0f") if missing(qa_record_id)

gen str80 qa_enumerator = ""
capture confirm variable enum
if !_rc {
    capture confirm numeric variable enum
    if !_rc {
        capture decode enum, gen(__qa_enum_decoded)
        if !_rc {
            replace qa_enumerator = substr(__qa_enum_decoded, 1, 80)
            drop __qa_enum_decoded
        }
        else replace qa_enumerator = string(enum, "%21.0g") if !missing(enum)
    }
    else replace qa_enumerator = substr(enum, 1, 80)
}

foreach geo in district subcounty parish village {
    local width = cond("`geo'" == "village", 120, 100)
    gen str`width' qa_`geo' = ""
    capture confirm variable `geo'_scto
    if !_rc {
        capture confirm string variable `geo'_scto
        if !_rc replace qa_`geo' = substr(`geo'_scto, 1, `width')
        else {
            capture decode `geo'_scto, gen(__qa_`geo'_decoded)
            if !_rc {
                replace qa_`geo' = substr(__qa_`geo'_decoded, 1, `width')
                drop __qa_`geo'_decoded
            }
            else replace qa_`geo' = string(`geo'_scto, "%21.0g") if !missing(`geo'_scto)
        }
    }
}

gen byte qa_eligible = 1
capture confirm variable consent
if !_rc replace qa_eligible = consent == 1
label var qa_eligible "Consented record eligible for baseline QA"

gen str244 qa_village_key = ""
capture confirm variable survey_village_uid
if !_rc {
    capture confirm string variable survey_village_uid
    if !_rc replace qa_village_key = substr(survey_village_uid, 1, 244)
    else replace qa_village_key = string(survey_village_uid, "%21.0g") if !missing(survey_village_uid)
}
replace qa_village_key = lower(qa_district + "|" + qa_subcounty + "|" + qa_parish + "|" + qa_village) ///
    if missing(qa_village_key)

local critical_vars "submission_key consent enum district_scto subcounty_scto parish_scto village_scto duration_min interview_date"
foreach v of local critical_vars {
    capture confirm variable `v'
    local absent = _rc != 0
    local schema_id = substr("SCHEMA_`v'", 1, 40)
    _qa_register, checkid(`"`schema_id'"') severity("ERROR") domain("schema") ///
        module("metadata") variable(`"`v'"') message("Required baseline QA variable is present") ///
        ntested(1) nissues(`absent')
}

local module_anchor_vars "m1_q04 m2_q01 m3_q02 m4_q01_1 m5_q01 m6_q01 m7_q01 m8_q01 m9_q12 m10_q07 m11_q02"
foreach v of local module_anchor_vars {
    capture confirm variable `v'
    local absent = _rc != 0
    local schema_id = substr("SCHEMA_`v'", 1, 40)
    local qamodule "survey"
    if regexm("`v'", "^m([0-9]+)_") local qamodule = "M" + regexs(1)
    _qa_register, checkid(`"`schema_id'"') severity("WARNING") domain("schema") ///
        module(`"`qamodule'"') variable(`"`v'"') message("Expected module anchor variable is present") ///
        ntested(1) nissues(`absent')
}

local n_mismatch = (`qa_source_n' != ${baseline_qa_expected_n})
_qa_register, checkid("EXPECTED_RECORD_COUNT") severity("ERROR") domain("sample") ///
    module("sample") variable("_N") message("Record count equals the planned Phase 1 baseline sample") ///
    ntested(1) nissues(`n_mismatch')

tempvar qa_unique_village_tag
egen byte `qa_unique_village_tag' = tag(qa_village_key) if !missing(qa_village_key)
quietly count if `qa_unique_village_tag'
local qa_unique_villages = r(N)
local village_mismatch = (`qa_unique_villages' != ${baseline_qa_expected_villages})
_qa_register, checkid("EXPECTED_UNIQUE_VILLAGES") severity("ERROR") domain("sample") ///
    module("sample") variable("survey_village_uid") ///
    message("Unique surveyed village count equals the planned Phase 1 village count") ///
    ntested(1) nissues(`village_mismatch')

* Optional but enabled-by-default lineage audit against the raw SurveyCTO export.
local qa_raw_import_ok = 0
if `qa_raw_available' {
    tempfile qa_raw_lineage
    preserve
        capture noisily import excel using `"`qa_raw_input'"', sheet("data") firstrow clear
        if !_rc {
            rename *, lower
            capture confirm variable key
            if !_rc {
                local qa_raw_import_ok = 1
                local qa_raw_n = _N
                clonevar submission_key = key
                local raw_keep "submission_key"
                foreach v in consent enum m0_q04 m0_q05 m0_q06 m0_q07 duration {
                    capture confirm variable `v'
                    if !_rc local raw_keep "`raw_keep' `v'"
                }
                keep `raw_keep'
                foreach v in consent enum m0_q04 m0_q05 m0_q06 m0_q07 duration {
                    capture confirm variable `v'
                    if !_rc rename `v' raw_`v'
                }
                gen byte raw_present = 1
                duplicates tag submission_key, gen(__qa_raw_duplicate)
                quietly count if __qa_raw_duplicate > 0 & !missing(submission_key)
                local qa_raw_duplicate_records = r(N)
                quietly count if missing(submission_key)
                local qa_raw_missing_keys = r(N)
                drop if missing(submission_key)
                tempvar qa_raw_unique_tag
                egen byte `qa_raw_unique_tag' = tag(submission_key)
                quietly count if `qa_raw_unique_tag'
                local qa_raw_unique_keys = r(N)
                bysort submission_key: keep if _n == 1
                drop __qa_raw_duplicate `qa_raw_unique_tag'
                save `qa_raw_lineage', replace
            }
        }
    restore
}

local raw_availability_issue = (`qa_raw_import_ok' == 0)
_qa_register, checkid("RAW_INPUT_AVAILABLE") severity("WARNING") domain("lineage") ///
    module("metadata") variable("raw SurveyCTO export") ///
    message("Raw SurveyCTO workbook is available and contains a submission key") ///
    ntested(1) nissues(`raw_availability_issue')

if `qa_raw_import_ok' {
    local raw_count_diff = abs(`qa_raw_n' - `qa_source_n')
    _qa_register, checkid("RAW_CLEAN_RECORD_COUNT") severity("ERROR") domain("lineage") ///
        module("metadata") variable("_N") ///
        message("Raw and cleaned baseline files contain the same number of records") ///
        ntested(`qa_raw_n') nissues(`raw_count_diff')
    _qa_register, checkid("RAW_DUPLICATE_KEYS") severity("ERROR") domain("lineage") ///
        module("metadata") variable("submission_key") ///
        message("Raw SurveyCTO submission keys are unique") ///
        ntested(`qa_raw_n') nissues(`qa_raw_duplicate_records')
    _qa_register, checkid("RAW_MISSING_KEYS") severity("ERROR") domain("lineage") ///
        module("metadata") variable("submission_key") ///
        message("Raw SurveyCTO submission keys are nonmissing") ///
        ntested(`qa_raw_n') nissues(`qa_raw_missing_keys')

    capture drop qa_raw_merge raw_present raw_*
    merge m:1 submission_key using `qa_raw_lineage', keep(master match) gen(qa_raw_merge)
    label var qa_raw_merge "Match status against raw SurveyCTO export"

    _qa_add_issue, condition("qa_raw_merge == 1") checkid("CLEAN_KEY_NOT_IN_RAW") ///
        severity("ERROR") domain("lineage") module("metadata") variable("submission_key") ///
        message("Cleaned record submission key does not exist in the raw SurveyCTO export") ///
        observed(submission_key)

    tempvar qa_matched_raw_key
    egen byte `qa_matched_raw_key' = tag(submission_key) if qa_raw_merge == 3
    quietly count if `qa_matched_raw_key'
    local qa_matched_raw_keys = r(N)
    local qa_raw_only_keys = max(0, `qa_raw_unique_keys' - `qa_matched_raw_keys')
    _qa_register, checkid("RAW_KEY_NOT_IN_CLEAN") severity("ERROR") domain("lineage") ///
        module("metadata") variable("submission_key") ///
        message("Every raw SurveyCTO submission key is retained in the cleaned file") ///
        ntested(`qa_raw_unique_keys') nissues(`qa_raw_only_keys')

    foreach v in consent enum m0_q04 m0_q05 m0_q06 m0_q07 duration {
        capture confirm variable `v'
        local clean_exists = !_rc
        capture confirm variable raw_`v'
        local raw_exists = !_rc
        if `clean_exists' & `raw_exists' {
            capture confirm numeric variable `v'
            local clean_numeric = !_rc
            capture confirm numeric variable raw_`v'
            local raw_numeric = !_rc
            local type_mismatch = (`clean_numeric' != `raw_numeric')
            local type_checkid = substr("RAW_TYPE_`v'", 1, 40)
            _qa_register, checkid(`"`type_checkid'"') severity("ERROR") domain("lineage") ///
                module("metadata") variable(`"`v'"') ///
                message("Raw and cleaned lineage fields have compatible storage types") ///
                ntested(1) nissues(`type_mismatch')
            if !`type_mismatch' {
                tempvar qa_raw_value_mismatch
                gen byte `qa_raw_value_mismatch' = missing(`v') != missing(raw_`v') if qa_raw_merge == 3
                replace `qa_raw_value_mismatch' = 1 if qa_raw_merge == 3 & ///
                    !missing(`v') & !missing(raw_`v') & `v' != raw_`v'
                local value_checkid = substr("RAW_VALUE_`v'", 1, 40)
                _qa_add_issue, condition("`qa_raw_value_mismatch' == 1") ///
                    checkid(`"`value_checkid'"') severity("ERROR") domain("lineage") ///
                    module("metadata") variable(`"`v'"') ///
                    message("Cleaned lineage field differs from its raw SurveyCTO value") ///
                    eligible("qa_raw_merge == 3") observed(`v')
            }
        }
    }
    capture drop raw_*
}

*------------------------------------------------------------------------------*
**# 3. IDs consent duplicates and sample structure
*------------------------------------------------------------------------------*

capture confirm variable submission_key
if !_rc {
    _qa_add_issue, condition("missing(submission_key)") checkid("MISSING_SUBMISSION_KEY") ///
        severity("ERROR") domain("identity") module("metadata") variable("submission_key") ///
        message("Submission key is missing") eligible("qa_eligible == 1") observed(submission_key)

    tempvar qa_dup_submission
    bysort submission_key: gen byte `qa_dup_submission' = (_N > 1) if !missing(submission_key)
    _qa_add_issue, condition("`qa_dup_submission' == 1") checkid("DUPLICATE_SUBMISSION_KEY") ///
        severity("ERROR") domain("identity") module("metadata") variable("submission_key") ///
        message("Submission key appears in more than one record") observed(submission_key)
}

capture confirm variable instance_id
if !_rc {
    _qa_add_issue, condition("missing(instance_id)") checkid("MISSING_INSTANCE_ID") ///
        severity("WARNING") domain("identity") module("metadata") variable("instance_id") ///
        message("SurveyCTO instance ID is missing") eligible("qa_eligible == 1") observed(instance_id)
    tempvar qa_dup_instance
    bysort instance_id: gen byte `qa_dup_instance' = (_N > 1) if !missing(instance_id)
    _qa_add_issue, condition("`qa_dup_instance' == 1") checkid("DUPLICATE_INSTANCE_ID") ///
        severity("ERROR") domain("identity") module("metadata") variable("instance_id") ///
        message("SurveyCTO instance ID appears in more than one record") observed(instance_id)
}

tempvar qa_dup_village
bysort qa_village_key: gen byte `qa_dup_village' = (_N > 1) if !missing(qa_village_key)
_qa_add_issue, condition("`qa_dup_village' == 1") checkid("DUPLICATE_SURVEY_VILLAGE") ///
    severity("ERROR") domain("sample") module("geography") variable("survey_village_uid") ///
    message("More than one submission uses the same SurveyCTO village key") ///
    eligible("qa_eligible == 1") observed(qa_village_key)

capture confirm variable analysis_sample
if !_rc {
    _qa_add_issue, condition("analysis_sample != qa_eligible & !missing(analysis_sample)") ///
        checkid("ANALYSIS_SAMPLE_MISMATCH") severity("ERROR") domain("consent") ///
        module("metadata") variable("analysis_sample") ///
        message("Analysis-sample flag does not match consent status") observed(analysis_sample)
}

capture confirm variable m1_q04
if !_rc {
    _qa_add_issue, condition("qa_eligible == 0 & !missing(m1_q04)") ///
        checkid("RESPONSES_WITHOUT_CONSENT") severity("ERROR") domain("consent") ///
        module("M1") variable("m1_q04") ///
        message("Substantive responses are present although consent was not recorded") observed(m1_q04)
}

capture confirm variable p1_admin_previously_contacted
if !_rc {
    quietly count if p1_admin_previously_contacted == 1
    local qa_admin_n = r(N)
    local admin_mismatch = (`qa_admin_n' != ${baseline_qa_expected_admin_added})
    _qa_register, checkid("EXPECTED_ADMIN_ADDED_COUNT") severity("ERROR") domain("sample") ///
        module("sample") variable("p1_admin_previously_contacted") ///
        message("Administrative previously-contacted count matches the approved Phase 1 list") ///
        ntested(1) nissues(`admin_mismatch')
}

capture confirm variable merge_sampling_frame
if !_rc {
    _qa_add_issue, condition("merge_sampling_frame == 1") checkid("UNMATCHED_SAMPLING_FRAME") ///
        severity("INFO") domain("sample") module("geography") variable("merge_sampling_frame") ///
        message("Survey record did not match the original randomized sampling frame") ///
        eligible("qa_eligible == 1") observed(merge_sampling_frame)
}

*------------------------------------------------------------------------------*
**# 4. Paradata dates duration and enumerator overlap
*------------------------------------------------------------------------------*

gen double qa_start_dt = .
capture confirm variable starttime_dt
if !_rc replace qa_start_dt = starttime_dt
else {
    capture confirm numeric variable starttime
    if !_rc replace qa_start_dt = starttime
}
format qa_start_dt %tc

gen double qa_end_dt = .
capture confirm variable endtime_dt
if !_rc replace qa_end_dt = endtime_dt
else {
    capture confirm numeric variable endtime
    if !_rc replace qa_end_dt = endtime
}
format qa_end_dt %tc

gen double qa_submission_dt = .
capture confirm variable submissiondate_dt
if !_rc replace qa_submission_dt = submissiondate_dt
else {
    capture confirm numeric variable submissiondate
    if !_rc replace qa_submission_dt = submissiondate
}
format qa_submission_dt %tc

gen double qa_duration_min = .
capture confirm variable duration_min
if !_rc replace qa_duration_min = duration_min
else {
    capture confirm numeric variable duration
    if !_rc replace qa_duration_min = duration / 60
}

gen double qa_interview_date = dofc(qa_start_dt) if !missing(qa_start_dt)
capture confirm variable interview_date
if !_rc replace qa_interview_date = interview_date if missing(qa_interview_date)
format qa_interview_date %td

gen byte qa_interview_hour = hh(qa_start_dt) if !missing(qa_start_dt)
capture confirm variable interview_hour
if !_rc replace qa_interview_hour = interview_hour if missing(qa_interview_hour)

_qa_add_issue, condition("missing(qa_start_dt)") checkid("MISSING_START_TIME") ///
    severity("WARNING") domain("paradata") module("metadata") variable("starttime_dt") ///
    message("Interview start time is missing") eligible("qa_eligible == 1") observed(qa_start_dt)
_qa_add_issue, condition("missing(qa_end_dt)") checkid("MISSING_END_TIME") ///
    severity("WARNING") domain("paradata") module("metadata") variable("endtime_dt") ///
    message("Interview end time is missing") eligible("qa_eligible == 1") observed(qa_end_dt)
_qa_add_issue, condition("missing(qa_duration_min)") checkid("MISSING_DURATION") ///
    severity("WARNING") domain("paradata") module("metadata") variable("duration_min") ///
    message("Interview duration is missing") eligible("qa_eligible == 1") observed(qa_duration_min)
_qa_add_issue, condition("qa_duration_min <= 0 & !missing(qa_duration_min)") ///
    checkid("NONPOSITIVE_DURATION") severity("ERROR") domain("paradata") ///
    module("metadata") variable("duration_min") message("Interview duration is zero or negative") ///
    eligible("qa_eligible == 1 & !missing(qa_duration_min)") observed(qa_duration_min)
_qa_add_issue, condition("qa_duration_min < ${baseline_qa_min_duration} & !missing(qa_duration_min)") ///
    checkid("SHORT_DURATION") severity("WARNING") domain("paradata") ///
    module("metadata") variable("duration_min") message("Interview duration is below the configured minimum") ///
    eligible("qa_eligible == 1 & !missing(qa_duration_min)") observed(qa_duration_min)
_qa_add_issue, condition("qa_duration_min > ${baseline_qa_max_duration} & !missing(qa_duration_min)") ///
    checkid("LONG_DURATION") severity("WARNING") domain("paradata") ///
    module("metadata") variable("duration_min") message("Interview duration is above the configured maximum") ///
    eligible("qa_eligible == 1 & !missing(qa_duration_min)") observed(qa_duration_min)

_qa_add_issue, condition("qa_end_dt < qa_start_dt & !missing(qa_start_dt, qa_end_dt)") ///
    checkid("END_BEFORE_START") severity("ERROR") domain("paradata") ///
    module("metadata") variable("endtime_dt") message("Interview end time precedes start time") ///
    eligible("qa_eligible == 1 & !missing(qa_start_dt, qa_end_dt)") observed(qa_end_dt)

gen double qa_elapsed_min = (qa_end_dt - qa_start_dt) / 60000 if !missing(qa_start_dt, qa_end_dt)
gen double qa_duration_gap_min = abs(qa_elapsed_min - qa_duration_min) ///
    if !missing(qa_elapsed_min, qa_duration_min)
_qa_add_issue, condition("qa_duration_gap_min > 5 & !missing(qa_duration_gap_min)") ///
    checkid("DURATION_TIMESTAMP_MISMATCH") severity("WARNING") domain("paradata") ///
    module("metadata") variable("duration_min") ///
    message("Recorded duration differs from start-to-end elapsed time by more than five minutes") ///
    eligible("qa_eligible == 1 & !missing(qa_duration_gap_min)") observed(qa_duration_gap_min)

_qa_add_issue, condition("qa_submission_dt < qa_end_dt & !missing(qa_submission_dt, qa_end_dt)") ///
    checkid("SUBMISSION_BEFORE_END") severity("ERROR") domain("paradata") ///
    module("metadata") variable("submissiondate_dt") message("Submission time precedes interview end time") ///
    eligible("qa_eligible == 1 & !missing(qa_submission_dt, qa_end_dt)") observed(qa_submission_dt)

local field_start = daily("${baseline_qa_field_start}", "DMY")
local field_end   = daily("${baseline_qa_field_end}", "DMY")
_qa_add_issue, condition("(qa_interview_date < `field_start' | qa_interview_date > `field_end') & !missing(qa_interview_date)") ///
    checkid("OUTSIDE_FIELDWORK_WINDOW") severity("WARNING") domain("paradata") ///
    module("metadata") variable("interview_date") message("Interview date falls outside the configured fieldwork window") ///
    eligible("qa_eligible == 1 & !missing(qa_interview_date)") observed(qa_interview_date)

_qa_add_issue, condition("(qa_interview_hour < ${baseline_qa_early_hour} | qa_interview_hour > ${baseline_qa_late_hour}) & !missing(qa_interview_hour)") ///
    checkid("UNUSUAL_INTERVIEW_HOUR") severity("WARNING") domain("paradata") ///
    module("metadata") variable("interview_hour") message("Interview started outside configured daytime hours") ///
    eligible("qa_eligible == 1 & !missing(qa_interview_hour)") observed(qa_interview_hour)

tempvar qa_duplicate_start qa_previous_end qa_overlap
bysort qa_enumerator qa_start_dt: gen byte `qa_duplicate_start' = (_N > 1) ///
    if !missing(qa_enumerator) & !missing(qa_start_dt)
_qa_add_issue, condition("`qa_duplicate_start' == 1") checkid("DUPLICATE_ENUM_START_TIME") ///
    severity("ERROR") domain("paradata") module("metadata") variable("starttime_dt") ///
    message("Enumerator has more than one interview with the same start time") observed(qa_start_dt)

sort qa_enumerator qa_start_dt
by qa_enumerator (qa_start_dt): gen double `qa_previous_end' = qa_end_dt[_n-1]
gen byte `qa_overlap' = qa_start_dt < (`qa_previous_end' - 60000) ///
    if !missing(qa_enumerator, qa_start_dt, `qa_previous_end')
_qa_add_issue, condition("`qa_overlap' == 1") checkid("ENUMERATOR_OVERLAP") ///
    severity("ERROR") domain("paradata") module("metadata") variable("starttime_dt") ///
    message("Interview starts before the same enumerator's previous interview ended") observed(qa_start_dt)

*------------------------------------------------------------------------------*
**# 5. Required-field and module response-density checks
*------------------------------------------------------------------------------*

local required_vars "submission_key enum consent district_scto subcounty_scto parish_scto village_scto m1_q04 m1_q06 m1_q07 m1_q08"
foreach v of local required_vars {
    capture confirm variable `v'
    if !_rc {
        local checkid = substr("MISSING_REQUIRED_`v'", 1, 40)
        local qamodule "metadata"
        if regexm("`v'", "^m([0-9]+)_") local qamodule = "M" + regexs(1)
        _qa_add_issue, condition("qa_eligible == 1 & missing(`v')") ///
            checkid(`"`checkid'"') severity("ERROR") domain("completeness") ///
            module(`"`qamodule'"') variable(`"`v'"') message("Required field is missing for a consented record") ///
            eligible("qa_eligible == 1") observed(`v')
    }
}

forvalues m = 1/11 {
    local module_vars ""
    capture ds m`m'_q* m`m'_v*
    if !_rc {
        foreach v of varlist `r(varlist)' {
            if !regexm("`v'", "(_score|_correct|_nonmiss)$") & ///
                !regexm("`v'", "^(n_|idx_)") local module_vars "`module_vars' `v'"
        }
    }

    local n_module_vars : word count `module_vars'
    gen int qa_m`m'_answered = 0
    if `n_module_vars' > 0 {
        foreach v of local module_vars {
            capture confirm string variable `v'
            if !_rc replace qa_m`m'_answered = qa_m`m'_answered + !missing(`v')
            else replace qa_m`m'_answered = qa_m`m'_answered + !missing(`v')
        }
    }
    gen int qa_m`m'_field_count = `n_module_vars'
    gen double qa_m`m'_response_density = qa_m`m'_answered / qa_m`m'_field_count if qa_m`m'_field_count > 0

    local sev "ERROR"
    if `m' == 10 local sev "WARNING"
    _qa_add_issue, condition("qa_eligible == 1 & qa_m`m'_field_count > 0 & qa_m`m'_answered == 0") ///
        checkid("MODULE_`m'_ALL_MISSING") severity(`"`sev'"') domain("completeness") ///
        module("M`m'") variable("m`m'_*") message("All fields in this survey module are missing") ///
        eligible("qa_eligible == 1") observed(qa_m`m'_answered)
}

local core_indices "idx_respondent_capacity idx_institutional_functioning idx_legal_classif_knowledge idx_adr_mediation_practice idx_referral_practice idx_record_quality idx_committee_functioning idx_perceived_legitimacy idx_safeguards idx_reintegration_norms"
local core_present ""
foreach v of local core_indices {
    capture confirm variable `v'
    if !_rc {
        local core_present "`core_present' `v'"
        local checkid = substr("MISSING_INDEX_`v'", 1, 40)
        _qa_add_issue, condition("qa_eligible == 1 & missing(`v')") ///
            checkid(`"`checkid'"') severity("WARNING") domain("completeness") ///
            module("indices") variable(`"`v'"') message("Core module index is missing") ///
            eligible("qa_eligible == 1") observed(`v')
    }
}
if `: word count `core_present'' > 0 {
    egen int qa_n_missing_core_indices = rowmiss(`core_present')
}
else gen int qa_n_missing_core_indices = .

*------------------------------------------------------------------------------*
**# 6. Exact value-label binary range and count checks
*------------------------------------------------------------------------------*

capture ds, has(vallabel)
if !_rc {
    foreach v of varlist `r(varlist)' {
        capture confirm numeric variable `v'
        if !_rc _qa_check_vallabel `v'
    }
}

capture ds m*_q*_* m*_v*_* topics_trained_*
if !_rc {
    local multi_vars `r(varlist)'
    local multi_vars : list uniq multi_vars
    foreach v of local multi_vars {
        if regexm("`v'", "_[0-9]+$") {
            capture confirm numeric variable `v'
            if !_rc {
                local checkid = substr("MULTI_BINARY_`v'", 1, 40)
                local qamodule "survey"
                if regexm("`v'", "^m([0-9]+)_") local qamodule = "M" + regexs(1)
                _qa_add_issue, condition("!missing(`v') & `v' != 0 & `v' != 1") ///
                    checkid(`"`checkid'"') severity("ERROR") domain("range") ///
                    module(`"`qamodule'"') variable(`"`v'"') ///
                    message("Select-multiple indicator must equal zero or one") ///
                    eligible("qa_eligible == 1 & !missing(`v')") observed(`v')
            }
        }
    }
}

capture ds *_score idx_*
if !_rc {
    foreach v of varlist `r(varlist)' {
        capture confirm numeric variable `v'
        if !_rc {
            local checkid = substr("SCORE_RANGE_`v'", 1, 40)
            _qa_add_issue, condition("!missing(`v') & (`v' < 0 | `v' > 1)") ///
                checkid(`"`checkid'"') severity("ERROR") domain("range") ///
                module("derived") variable(`"`v'"') message("Derived score or index is outside zero to one") ///
                eligible("qa_eligible == 1 & !missing(`v')") observed(`v')
        }
    }
}

local count_vars "m1_q04 m2_q01 m2_q04 m2_q05 m2_q06 m3_q02 m3_q03 m3_q08 m3_q09 m3_q10 m3_q12"
foreach v of local count_vars {
    capture confirm numeric variable `v'
    if !_rc {
        local checkid = substr("COUNT_RANGE_`v'", 1, 40)
        local qamodule "survey"
        if regexm("`v'", "^m([0-9]+)_") local qamodule = "M" + regexs(1)
        _qa_add_issue, condition("!missing(`v') & (`v' < 0 | `v' != int(`v'))") ///
            checkid(`"`checkid'"') severity("ERROR") domain("range") ///
            module(`"`qamodule'"') variable(`"`v'"') ///
            message("Count must be a nonnegative integer") eligible("qa_eligible == 1 & !missing(`v')") observed(`v')
    }
}

foreach pair in "m1_q04 50" "m2_q01 20" "m2_q04 20" "m2_q05 20" "m2_q06 365" ///
    "m3_q02 200" "m3_q03 500" "m3_q08 500" "m3_q09 500" "m3_q10 500" "m3_q12 500" {
    local v = word(`"`pair'"', 1)
    local ceiling = real(word(`"`pair'"', 2))
    capture confirm numeric variable `v'
    if !_rc {
        local checkid = substr("PLAUSIBILITY_`v'", 1, 40)
        _qa_add_issue, condition("!missing(`v') & `v' > `ceiling'") ///
            checkid(`"`checkid'"') severity("WARNING") domain("outlier") ///
            module("survey") variable(`"`v'"') message("Count exceeds the configured plausibility ceiling") ///
            eligible("qa_eligible == 1 & !missing(`v')") observed(`v')
    }
}

*------------------------------------------------------------------------------*
**# 7. Skip logic select-multiple exclusivity and other-specify checks
*------------------------------------------------------------------------------*

capture confirm variable attend_cdfu_training
if !_rc {
    capture confirm variable rating_cdfu_training
    if !_rc {
        _qa_add_issue, condition("attend_cdfu_training == 1 & missing(rating_cdfu_training)") ///
            checkid("TRAINING_RATING_MISSING") severity("WARNING") domain("skip_logic") ///
            module("training") variable("rating_cdfu_training") ///
            message("Prior training reported but usefulness rating is missing") ///
            eligible("qa_eligible == 1 & attend_cdfu_training == 1") observed(rating_cdfu_training)
        _qa_add_issue, condition("attend_cdfu_training != 1 & !missing(attend_cdfu_training) & !missing(rating_cdfu_training)") ///
            checkid("TRAINING_RATING_STRAY") severity("WARNING") domain("skip_logic") ///
            module("training") variable("rating_cdfu_training") ///
            message("Training rating is present although prior training was not reported") ///
            eligible("qa_eligible == 1 & attend_cdfu_training != 1 & !missing(attend_cdfu_training)") observed(rating_cdfu_training)
    }

    capture confirm variable topics_trained_1 topics_trained_2 topics_trained_3 topics_trained_4 ///
        topics_trained_5 topics_trained_6 topics_trained_7 topics_trained_98
    if !_rc {
        tempvar qa_training_topics
        egen double `qa_training_topics' = rowtotal(topics_trained_1 topics_trained_2 topics_trained_3 ///
            topics_trained_4 topics_trained_5 topics_trained_6 topics_trained_7 topics_trained_98)
        _qa_add_issue, condition("attend_cdfu_training == 1 & `qa_training_topics' == 0") ///
            checkid("TRAINING_TOPICS_MISSING") severity("WARNING") domain("skip_logic") ///
            module("training") variable("topics_trained_*") ///
            message("Prior training reported but no training topic was selected") ///
            eligible("qa_eligible == 1 & attend_cdfu_training == 1") observed(`qa_training_topics')
        _qa_add_issue, condition("attend_cdfu_training != 1 & !missing(attend_cdfu_training) & `qa_training_topics' > 0") ///
            checkid("TRAINING_TOPICS_STRAY") severity("ERROR") domain("skip_logic") ///
            module("training") variable("topics_trained_*") ///
            message("Training topics are selected although prior training was not reported") ///
            eligible("qa_eligible == 1 & attend_cdfu_training != 1 & !missing(attend_cdfu_training)") observed(`qa_training_topics')
    }
}

capture confirm variable m1_q10_98 m1_q10_other
if !_rc _qa_other_specify, trigger(m1_q10_98) other(m1_q10_other) checkid("M1_Q10_OTHER") module("M1")
capture confirm variable m1_q14_98 m1_q14_specify
if !_rc _qa_other_specify, trigger(m1_q14_98) other(m1_q14_specify) checkid("M1_Q14_OTHER") module("M1")
capture confirm variable m2_q15_98 m2_q15_specify
if !_rc _qa_other_specify, trigger(m2_q15_98) other(m2_q15_specify) checkid("M2_Q15_OTHER") module("M2")
capture confirm variable topics_trained_98 other_training
if !_rc _qa_other_specify, trigger(topics_trained_98) other(other_training) checkid("TRAINING_OTHER") module("training")
capture confirm variable m1_q08 other_education
if !_rc {
    tempvar qa_other_education_trigger
    gen byte `qa_other_education_trigger' = m1_q08 == 98 if !missing(m1_q08)
    _qa_other_specify, trigger(`qa_other_education_trigger') other(other_education) checkid("M1_Q08_OTHER") module("M1")
}

capture confirm variable m1_q10_95 m1_q10_1 m1_q10_2 m1_q10_3 m1_q10_4 m1_q10_98
if !_rc _qa_exclusive, exclusive(m1_q10_95) others(m1_q10_1 m1_q10_2 m1_q10_3 m1_q10_4 m1_q10_98) ///
    checkid("M1_Q10_EXCLUSIVE") module("M1") message("Cannot complete records is selected with a language option")
capture confirm variable m1_q14_95 m1_q14_1 m1_q14_2 m1_q14_3 m1_q14_4 m1_q14_5 m1_q14_6 m1_q14_7 m1_q14_8 m1_q14_98
if !_rc _qa_exclusive, exclusive(m1_q14_95) others(m1_q14_1 m1_q14_2 m1_q14_3 m1_q14_4 m1_q14_5 m1_q14_6 m1_q14_7 m1_q14_8 m1_q14_98) ///
    checkid("M1_Q14_EXCLUSIVE") module("M1") message("No case type is selected with a substantive case type")
capture confirm variable m5_q11_10 m5_q11_1 m5_q11_2 m5_q11_3 m5_q11_4 m5_q11_5 m5_q11_6 m5_q11_7 m5_q11_8 m5_q11_9 m5_q11_98
if !_rc _qa_exclusive, exclusive(m5_q11_10) others(m5_q11_1 m5_q11_2 m5_q11_3 m5_q11_4 m5_q11_5 m5_q11_6 m5_q11_7 m5_q11_8 m5_q11_9 m5_q11_98) ///
    checkid("M5_Q11_EXCLUSIVE") module("M5") message("No ADR barrier is selected with a substantive barrier")
capture confirm variable m6_q12_11 m6_q12_1 m6_q12_2 m6_q12_3 m6_q12_4 m6_q12_5 m6_q12_6 m6_q12_7 m6_q12_8 m6_q12_9 m6_q12_10 m6_q12_98
if !_rc _qa_exclusive, exclusive(m6_q12_11) others(m6_q12_1 m6_q12_2 m6_q12_3 m6_q12_4 m6_q12_5 m6_q12_6 m6_q12_7 m6_q12_8 m6_q12_9 m6_q12_10 m6_q12_98) ///
    checkid("M6_Q12_EXCLUSIVE") module("M6") message("No referral barrier is selected with a substantive barrier")
capture confirm variable m7_q03_95 m7_q03_1 m7_q03_2 m7_q03_3 m7_q03_4 m7_q03_5 m7_q03_6 m7_q03_98
if !_rc _qa_exclusive, exclusive(m7_q03_95) others(m7_q03_1 m7_q03_2 m7_q03_3 m7_q03_4 m7_q03_5 m7_q03_6 m7_q03_98) ///
    checkid("M7_Q03_EXCLUSIVE") module("M7") message("No written record is selected with a record type")
capture confirm variable m7_q15_9 m7_q15_1 m7_q15_2 m7_q15_3 m7_q15_4 m7_q15_5 m7_q15_6 m7_q15_7 m7_q15_8 m7_q15_98
if !_rc _qa_exclusive, exclusive(m7_q15_9) others(m7_q15_1 m7_q15_2 m7_q15_3 m7_q15_4 m7_q15_5 m7_q15_6 m7_q15_7 m7_q15_8 m7_q15_98) ///
    checkid("M7_Q15_EXCLUSIVE") module("M7") message("No record challenge is selected with a substantive challenge")
capture confirm variable m8_q15_10 m8_q15_1 m8_q15_2 m8_q15_3 m8_q15_4 m8_q15_5 m8_q15_6 m8_q15_7 m8_q15_8 m8_q15_9 m8_q15_98
if !_rc _qa_exclusive, exclusive(m8_q15_10) others(m8_q15_1 m8_q15_2 m8_q15_3 m8_q15_4 m8_q15_5 m8_q15_6 m8_q15_7 m8_q15_8 m8_q15_9 m8_q15_98) ///
    checkid("M8_Q15_EXCLUSIVE") module("M8") message("No committee challenge is selected with a substantive challenge")
capture confirm variable m9_q16_11 m9_q16_1 m9_q16_2 m9_q16_3 m9_q16_4 m9_q16_5 m9_q16_6 m9_q16_7 m9_q16_8 m9_q16_9 m9_q16_10 m9_q16_98
if !_rc {
    _qa_exclusive, exclusive(m9_q16_11) others(m9_q16_1 m9_q16_2 m9_q16_3 m9_q16_4 m9_q16_5 m9_q16_6 m9_q16_7 m9_q16_8 m9_q16_9 m9_q16_10 m9_q16_98) ///
        checkid("M9_Q16_EXCLUSIVE") module("M9") message("Rarely bypass is selected with a substantive bypass reason")
    _qa_maxselect m9_q16_1 m9_q16_2 m9_q16_3 m9_q16_4 m9_q16_5 m9_q16_6 m9_q16_7 m9_q16_8 m9_q16_9 m9_q16_10 m9_q16_11 m9_q16_98, ///
        max(3) checkid("M9_Q16_MAX_THREE") module("M9") message("More than three bypass reasons were selected")
}
capture confirm variable m11_q10_9 m11_q10_1 m11_q10_2 m11_q10_3 m11_q10_4 m11_q10_5 m11_q10_6 m11_q10_7 m11_q10_8 m11_q10_98
if !_rc _qa_exclusive, exclusive(m11_q10_9) others(m11_q10_1 m11_q10_2 m11_q10_3 m11_q10_4 m11_q10_5 m11_q10_6 m11_q10_7 m11_q10_8 m11_q10_98) ///
    checkid("M11_Q10_EXCLUSIVE") module("M11") message("No support needed is selected with a support type")
capture confirm variable m11_q12_9 m11_q12_1 m11_q12_2 m11_q12_3 m11_q12_4 m11_q12_5 m11_q12_6 m11_q12_7 m11_q12_8 m11_q12_98
if !_rc {
    _qa_exclusive, exclusive(m11_q12_9) others(m11_q12_1 m11_q12_2 m11_q12_3 m11_q12_4 m11_q12_5 m11_q12_6 m11_q12_7 m11_q12_8 m11_q12_98) ///
        checkid("M11_Q12_EXCLUSIVE") module("M11") message("Community acceptance is selected with a reintegration barrier")
    _qa_maxselect m11_q12_1 m11_q12_2 m11_q12_3 m11_q12_4 m11_q12_5 m11_q12_6 m11_q12_7 m11_q12_8 m11_q12_9 m11_q12_98, ///
        max(3) checkid("M11_Q12_MAX_THREE") module("M11") message("More than three reintegration barriers were selected")
}

*------------------------------------------------------------------------------*
**# 8. Cross-variable consistency checks
*------------------------------------------------------------------------------*

capture confirm variable m2_q01 m2_q05
if !_rc {
    _qa_add_issue, condition("m2_q05 > m2_q01 & !missing(m2_q01, m2_q05)") ///
        checkid("WOMEN_MEMBERS_GT_TOTAL") severity("ERROR") domain("consistency") ///
        module("M2") variable("m2_q05") message("Women committee members exceed total committee members") ///
        eligible("qa_eligible == 1 & !missing(m2_q01, m2_q05)") observed(m2_q05)
}

capture confirm variable m2_q03 m2_q04
if !_rc {
    _qa_add_issue, condition("m2_q03 == 1 & (missing(m2_q04) | m2_q04 <= 0)") ///
        checkid("VACANCY_COUNT_MISSING") severity("ERROR") domain("skip_logic") ///
        module("M2") variable("m2_q04") message("Vacancies reported but the number of vacancies is missing or zero") ///
        eligible("qa_eligible == 1 & m2_q03 == 1") observed(m2_q04)
    _qa_add_issue, condition("(m2_q03 == 0 | m2_q03 == 98) & m2_q04 > 0 & !missing(m2_q04)") ///
        checkid("VACANCY_COUNT_STRAY") severity("ERROR") domain("skip_logic") ///
        module("M2") variable("m2_q04") message("Positive vacancy count is present although vacancies were not reported") ///
        eligible("qa_eligible == 1 & (m2_q03 == 0 | m2_q03 == 98)") observed(m2_q04)
}

capture confirm variable m2_q12 m2_q13
if !_rc {
    _qa_add_issue, condition("m2_q12 == 3 & !missing(m2_q13)") ///
        checkid("M2_RECORD_UPTODATE_STRAY") severity("WARNING") domain("skip_logic") ///
        module("M2") variable("m2_q13") message("Record-up-to-date response is present although no records are kept") ///
        eligible("qa_eligible == 1 & m2_q12 == 3") observed(m2_q13)
}

capture confirm variable m2_q16 m2_q17
if !_rc {
    _qa_add_issue, condition("m2_q16 == 0 & !missing(m2_q17)") ///
        checkid("M2_VERIFICATION_STRAY") severity("ERROR") domain("skip_logic") ///
        module("M2") variable("m2_q17") message("Record quality was verified although the enumerator saw no record") ///
        eligible("qa_eligible == 1 & m2_q16 == 0") observed(m2_q17)
    _qa_add_issue, condition("(m2_q16 == 1 | m2_q16 == 2) & missing(m2_q17)") ///
        checkid("M2_VERIFICATION_MISSING") severity("WARNING") domain("skip_logic") ///
        module("M2") variable("m2_q17") message("Enumerator saw a record but the follow-up verification is missing") ///
        eligible("qa_eligible == 1 & (m2_q16 == 1 | m2_q16 == 2)") observed(m2_q17)
}

capture confirm variable m3_q02 m3_q03
if !_rc _qa_add_issue, condition("m3_q02 > m3_q03 & !missing(m3_q02, m3_q03)") ///
    checkid("CASELOAD_30D_GT_3M") severity("ERROR") domain("consistency") module("M3") ///
    variable("m3_q02") message("Thirty-day caseload exceeds three-month caseload") ///
    eligible("qa_eligible == 1 & !missing(m3_q02, m3_q03)") observed(m3_q02)

foreach v in m3_q08 m3_q09 m3_q10 m3_q12 {
    capture confirm variable m3_q03 `v'
    if !_rc {
        local checkid = substr("`v'_GT_CASELOAD", 1, 40)
        _qa_add_issue, condition("`v' > m3_q03 & !missing(`v', m3_q03)") ///
            checkid(`"`checkid'"') severity("ERROR") domain("consistency") ///
            module("M3") variable(`"`v'"') message("Case component exceeds the reported three-month caseload") ///
            eligible("qa_eligible == 1 & !missing(`v', m3_q03)") observed(`v')
    }
}

capture confirm variable m3_q03 m3_q09 m3_q10
if !_rc {
    gen double qa_case_source_sum = m3_q09 + m3_q10 if !missing(m3_q09, m3_q10)
    _qa_add_issue, condition("qa_case_source_sum > m3_q03 & !missing(qa_case_source_sum, m3_q03)") ///
        checkid("CASE_SOURCES_GT_CASELOAD") severity("WARNING") domain("consistency") ///
        module("M3") variable("m3_q09 m3_q10") ///
        message("Directly brought plus referred-in cases exceed three-month caseload") ///
        eligible("qa_eligible == 1 & !missing(qa_case_source_sum, m3_q03)") observed(qa_case_source_sum)
}

capture confirm variable m7_q01 m7_q04
if !_rc _qa_add_issue, condition("m7_q01 == 3 & !missing(m7_q04)") ///
    checkid("M7_UPTODATE_WITH_NO_REGISTER") severity("ERROR") domain("skip_logic") ///
    module("M7") variable("m7_q04") message("Record status is answered although no written case register exists") ///
    eligible("qa_eligible == 1 & m7_q01 == 3") observed(m7_q04)

capture confirm variable m11_q13 m11_q15
if !_rc {
    _qa_add_issue, condition("m11_q13 == 1 & missing(m11_q15)") ///
        checkid("M11_RESPONSE_MISSING") severity("WARNING") domain("skip_logic") ///
        module("M11") variable("m11_q15") message("Recent reintegration issue reported but LCC response is missing") ///
        eligible("qa_eligible == 1 & m11_q13 == 1") observed(m11_q15)
    _qa_add_issue, condition("m11_q13 != 1 & !missing(m11_q13) & !missing(m11_q15)") ///
        checkid("M11_RESPONSE_STRAY") severity("WARNING") domain("skip_logic") ///
        module("M11") variable("m11_q15") message("LCC reintegration response is present although no recent issue was reported") ///
        eligible("qa_eligible == 1 & m11_q13 != 1 & !missing(m11_q13)") observed(m11_q15)
}

capture confirm variable p1_admin_previously_contacted p1_admin_new
if !_rc _qa_add_issue, condition("p1_admin_previously_contacted + p1_admin_new != 1 & !missing(p1_admin_previously_contacted, p1_admin_new)") ///
    checkid("ADMIN_ORIGIN_COMPLEMENT") severity("ERROR") domain("consistency") ///
    module("sample") variable("p1_admin_new") message("Administrative new and previously-contacted flags are not complements") ///
    observed(p1_admin_new)

* Conservative straightlining screens. They flag records for review only.
capture confirm variable m5_q01_score m5_q02_score m5_q03_score m5_q06_score m5_q07_score ///
    adr_confidence_score deescalation_confidence_score m5_q14_score m5_q16_score
if !_rc {
    egen int qa_m5_scale_nonmissing = rownonmiss(m5_q01_score m5_q02_score m5_q03_score ///
        m5_q06_score m5_q07_score adr_confidence_score deescalation_confidence_score m5_q14_score m5_q16_score)
    egen double qa_m5_scale_sd = rowsd(m5_q01_score m5_q02_score m5_q03_score ///
        m5_q06_score m5_q07_score adr_confidence_score deescalation_confidence_score m5_q14_score m5_q16_score)
    _qa_add_issue, condition("qa_m5_scale_nonmissing >= 8 & qa_m5_scale_sd == 0") ///
        checkid("M5_STRAIGHTLINE") severity("WARNING") domain("response_pattern") ///
        module("M5") variable("m5 scales") message("At least eight ADR scale items have exactly the same normalized response") ///
        eligible("qa_eligible == 1 & qa_m5_scale_nonmissing >= 8") observed(qa_m5_scale_sd)
}

capture confirm variable reintegration_importance_score reintegration_willingness_score fair_chance_reintegration_score ///
    low_exclusion_norm_score low_reoffending_stigma_score comm_role_reint_score reint_mediation_comfort ///
    connect_support_willing_score
if !_rc {
    egen int qa_m11_scale_nonmissing = rownonmiss(reintegration_importance_score reintegration_willingness_score ///
        fair_chance_reintegration_score low_exclusion_norm_score low_reoffending_stigma_score ///
        comm_role_reint_score reint_mediation_comfort connect_support_willing_score)
    egen double qa_m11_scale_sd = rowsd(reintegration_importance_score reintegration_willingness_score ///
        fair_chance_reintegration_score low_exclusion_norm_score low_reoffending_stigma_score ///
        comm_role_reint_score reint_mediation_comfort connect_support_willing_score)
    _qa_add_issue, condition("qa_m11_scale_nonmissing >= 8 & qa_m11_scale_sd == 0") ///
        checkid("M11_STRAIGHTLINE") severity("WARNING") domain("response_pattern") ///
        module("M11") variable("m11 scales") message("Eight reintegration scale items have exactly the same normalized response") ///
        eligible("qa_eligible == 1 & qa_m11_scale_nonmissing >= 8") observed(qa_m11_scale_sd)
}

*------------------------------------------------------------------------------*
**# 9. Merge issue counts back to records and save tagged files
*------------------------------------------------------------------------------*

tempfile qa_audited_records qa_issue_counts qa_record_flags
save `qa_audited_records', replace

preserve
    use "${QA_ISSUES_ACC}", clear
    gen byte __qa_any = 1
    gen byte __qa_error = severity == "ERROR"
    gen byte __qa_warning = severity == "WARNING"
    gen byte __qa_info = severity == "INFO"
    collapse (sum) qa_n_issues=__qa_any qa_n_errors=__qa_error ///
        qa_n_warnings=__qa_warning qa_n_info=__qa_info, by(qa_row_id)
    save `qa_issue_counts', replace
restore

use `qa_audited_records', clear
merge 1:1 qa_row_id using `qa_issue_counts', nogen
foreach v in qa_n_issues qa_n_errors qa_n_warnings qa_n_info {
    replace `v' = 0 if missing(`v')
}

gen str8 qa_review_priority = "PASS"
replace qa_review_priority = "REVIEW" if qa_n_warnings > 0
replace qa_review_priority = "HIGH" if qa_n_warnings >= 3
replace qa_review_priority = "ERROR" if qa_n_errors > 0
label var qa_review_priority "Automated QA review priority"

gen byte qa_release_blocker = qa_n_errors > 0
label define qa_yesno 0 "No" 1 "Yes", replace
label values qa_release_blocker qa_yesno
label var qa_release_blocker "Record has at least one error-severity QA issue"

* Remove direct identifiers and device fields from every saved QA record file.
capture drop chairperson_name tel_number devicephonenum deviceid device_info username
compress
save `"`qa_dir'/phase1_baseline_dq_tagged.dta"', replace

preserve
    keep qa_row_id qa_record_id qa_enumerator qa_district qa_subcounty qa_parish qa_village ///
        qa_village_key qa_interview_date qa_interview_hour qa_duration_min qa_elapsed_min ///
        qa_duration_gap_min qa_n_missing_core_indices qa_n_issues qa_n_errors qa_n_warnings ///
        qa_n_info qa_review_priority qa_release_blocker
    sort qa_review_priority qa_district qa_subcounty qa_village qa_row_id
    save `qa_record_flags', replace
    save `"`qa_dir'/phase1_baseline_dq_record_flags.dta"', replace
restore

*------------------------------------------------------------------------------*
**# 10. Build machine-readable summary datasets
*------------------------------------------------------------------------------*

tempfile qa_variable_summary qa_module_summary qa_enumerator_summary qa_district_summary ///
    qa_date_summary qa_check_summary qa_issues_final qa_overview

* Variable-level completeness and numeric distribution inventory.
tempname qa_varpost
postfile `qa_varpost' str32 variable str12 storage_type str12 display_format ///
    str32 value_label str244 variable_label long n_missing long n_nonmissing ///
    double pct_missing double mean double sd double min double max double n_unique ///
    using `qa_variable_summary', replace

foreach v of varlist _all {
    if substr("`v'", 1, 3) != "qa_" {
        local vartype : type `v'
        local varformat : format `v'
        local vallabel : value label `v'
        local varlabel : variable label `v'
        quietly count if missing(`v')
        local nmiss = r(N)
        quietly count if !missing(`v')
        local nnonmiss = r(N)
        local pmiss = 100 * `nmiss' / _N
        local vmean = .
        local vsd = .
        local vmin = .
        local vmax = .
        capture confirm numeric variable `v'
        if !_rc {
            quietly summarize `v'
            local vmean = r(mean)
            local vsd = r(sd)
            local vmin = r(min)
            local vmax = r(max)
        }
        local nunique = .
        if "`vartype'" != "strL" {
            tempvar qa_value_tag
            quietly egen byte `qa_value_tag' = tag(`v')
            quietly count if `qa_value_tag' == 1 & !missing(`v')
            local nunique = r(N)
            drop `qa_value_tag'
        }
        post `qa_varpost' (`"`v'"') (`"`vartype'"') (`"`varformat'"') ///
            (`"`vallabel'"') (`"`varlabel'"') (`nmiss') (`nnonmiss') (`pmiss') ///
            (`vmean') (`vsd') (`vmin') (`vmax') (`nunique')
    }
}
postclose `qa_varpost'

* Module response density. This is descriptive because skip patterns are valid.
tempname qa_modpost
postfile `qa_modpost' byte module_number str12 module long n_fields long n_eligible ///
    long n_all_missing double pct_all_missing double mean_response_density ///
    using `qa_module_summary', replace
forvalues m = 1/11 {
    quietly summarize qa_m`m'_field_count, meanonly
    local nf = r(max)
    quietly count if qa_eligible == 1
    local ne = r(N)
    quietly count if qa_eligible == 1 & qa_m`m'_answered == 0
    local nz = r(N)
    local pz = cond(`ne' > 0, 100 * `nz' / `ne', .)
    quietly summarize qa_m`m'_response_density if qa_eligible == 1, meanonly
    local md = r(mean)
    post `qa_modpost' (`m') ("M`m'") (`nf') (`ne') (`nz') (`pz') (`md')
}
postclose `qa_modpost'

* Enumerator monitoring summary.
preserve
    gen byte qa_record_with_error = qa_n_errors > 0
    gen byte qa_record_with_warning = qa_n_warnings > 0
    gen byte qa_short = qa_duration_min < ${baseline_qa_min_duration} if !missing(qa_duration_min)
    gen byte qa_long = qa_duration_min > ${baseline_qa_max_duration} if !missing(qa_duration_min)
    gen byte qa_outside_date = (qa_interview_date < `field_start' | qa_interview_date > `field_end') if !missing(qa_interview_date)
    collapse (count) n_interviews=qa_row_id ///
        (p50) median_duration_min=qa_duration_min ///
        (p10) p10_duration_min=qa_duration_min ///
        (p90) p90_duration_min=qa_duration_min ///
        (sum) total_issues=qa_n_issues total_errors=qa_n_errors total_warnings=qa_n_warnings ///
        n_records_with_error=qa_record_with_error n_records_with_warning=qa_record_with_warning ///
        n_short=qa_short n_long=qa_long n_outside_fieldwork=qa_outside_date, by(qa_enumerator)
    gen double pct_records_with_error = 100 * n_records_with_error / n_interviews
    gen double pct_short = 100 * n_short / n_interviews
    gsort -total_errors -total_warnings qa_enumerator
    save `qa_enumerator_summary', replace
restore

* District summary.
preserve
    gen byte qa_record_with_error = qa_n_errors > 0
    gen byte qa_record_with_warning = qa_n_warnings > 0
    collapse (count) n_records=qa_row_id ///
        (sum) total_issues=qa_n_issues total_errors=qa_n_errors total_warnings=qa_n_warnings ///
        n_records_with_error=qa_record_with_error n_records_with_warning=qa_record_with_warning, ///
        by(qa_district)
    gen double pct_records_with_error = 100 * n_records_with_error / n_records
    sort qa_district
    save `qa_district_summary', replace
restore

* Fieldwork-date summary.
preserve
    keep if !missing(qa_interview_date)
    gen byte qa_record_with_error = qa_n_errors > 0
    collapse (count) n_interviews=qa_row_id (p50) median_duration_min=qa_duration_min ///
        (sum) total_issues=qa_n_issues total_errors=qa_n_errors ///
        n_records_with_error=qa_record_with_error, by(qa_interview_date)
    format qa_interview_date %td
    sort qa_interview_date
    save `qa_date_summary', replace
restore

* Final issue file.
preserve
    use "${QA_ISSUES_ACC}", clear
    sort severity domain check_id qa_district qa_subcounty qa_village qa_row_id
    compress
    save `qa_issues_final', replace
    save `"`qa_dir'/phase1_baseline_dq_issues.dta"', replace
    export delimited using `"`qa_dir'/phase1_baseline_dq_issues.csv"', replace
    quietly count
    local qa_total_issues = r(N)
    quietly count if severity == "ERROR"
    local qa_total_errors = r(N)
    quietly count if severity == "WARNING"
    local qa_total_warnings = r(N)
    quietly count if severity == "INFO"
    local qa_total_info = r(N)
restore

* Final check catalog and release gate.
preserve
    use "${QA_CHECKS_ACC}", clear
    gen byte severity_order = 3
    replace severity_order = 1 if severity == "ERROR"
    replace severity_order = 2 if severity == "WARNING"
    sort severity_order status domain module variable check_id
    drop severity_order
    compress
    save `qa_check_summary', replace
    save `"`qa_dir'/phase1_baseline_dq_check_summary.dta"', replace
    quietly count if severity == "ERROR" & n_issues > 0
    local qa_failed_error_checks = r(N)
restore

local qa_release_status "READY"
if `qa_failed_error_checks' > 0 local qa_release_status "BLOCKED"

quietly count if qa_eligible == 1
local qa_n_eligible = r(N)
quietly count if qa_n_errors > 0
local qa_records_with_error = r(N)
quietly count if qa_n_warnings > 0
local qa_records_with_warning = r(N)

preserve
    clear
    set obs 1
    gen str244 source_file = `"`qa_input'"'
    gen str30 run_date = "$S_DATE $S_TIME"
    gen str12 stata_version = "Stata " + string(c(stata_version), "%4.1f")
    gen long n_source_records = `qa_source_n'
    gen long n_source_variables = `qa_source_k'
    gen long n_consented_records = `qa_n_eligible'
    gen long n_unique_villages = `qa_unique_villages'
    gen long n_issue_rows = `qa_total_issues'
    gen long n_error_issue_rows = `qa_total_errors'
    gen long n_warning_issue_rows = `qa_total_warnings'
    gen long n_info_issue_rows = `qa_total_info'
    gen long n_records_with_error = `qa_records_with_error'
    gen long n_records_with_warning = `qa_records_with_warning'
    gen str8 release_status = "`qa_release_status'"
    save `qa_overview', replace
restore

*------------------------------------------------------------------------------*
**# 11. Excel report and release-status text file
*------------------------------------------------------------------------------*

local qa_workbook `"`qa_dir'/phase1_baseline_dq_report.xlsx"'
capture erase `"`qa_workbook'"'

putexcel set `"`qa_workbook'"', replace sheet("README")
putexcel A1 = "Advancing Justice Uganda - Phase 1 baseline data-quality report"
putexcel A3 = "Release status" B3 = "`qa_release_status'"
putexcel A4 = "Meaning" B4 = "READY means no error-severity automated check failed. WARNING and INFO items still require review."
putexcel A6 = "Source file" B6 = `"`qa_input'"'
putexcel A7 = "Run date" B7 = "$S_DATE $S_TIME"
putexcel A8 = "Source records" B8 = `qa_source_n'
putexcel A9 = "Planned records" B9 = ${baseline_qa_expected_n}
putexcel A10 = "Unique surveyed village keys" B10 = `qa_unique_villages'
putexcel A11 = "Planned unique villages" B11 = ${baseline_qa_expected_villages}
putexcel A12 = "Issue rows" B12 = `qa_total_issues'
putexcel A13 = "Error issue rows" B13 = `qa_total_errors'
putexcel A14 = "Warning issue rows" B14 = `qa_total_warnings'
putexcel A15 = "Info issue rows" B15 = `qa_total_info'
putexcel A17 = "Severity definitions"
putexcel A18 = "ERROR" B18 = "Must be resolved or explicitly adjudicated before analytical release."
putexcel A19 = "WARNING" B19 = "Plausibility or completeness concern requiring review."
putexcel A20 = "INFO" B20 = "Expected diagnostic or monitoring item that may need documentation."
putexcel A22 = "Important interpretation note"
putexcel B22 = "Module response density includes conditional and select-multiple fields. It is a screening metric and not a skip-adjusted missingness rate."
putexcel A24 = "Workflow"
putexcel B24 = "Review check_summary first then issues and record_flags. Record every adjudication outside the raw data and rerun after corrections."

foreach item in "qa_overview overview" "qa_check_summary check_summary" ///
    "qa_issues_final issues" "qa_record_flags record_flags" ///
    "qa_variable_summary variable_quality" "qa_module_summary module_completeness" ///
    "qa_enumerator_summary enumerator_summary" "qa_district_summary district_summary" ///
    "qa_date_summary date_summary" {
    local dataref = word(`"`item'"', 1)
    local sheet = word(`"`item'"', 2)
    use ``dataref'', clear
    export excel using `"`qa_workbook'"', sheet(`"`sheet'"', replace) firstrow(variables)
}

tempname qa_gate
file open `qa_gate' using `"`qa_dir'/phase1_baseline_dq_release_status.txt"', write replace text
file write `qa_gate' "Advancing Justice Uganda - Phase 1 baseline QA" _n
file write `qa_gate' "Run: $S_DATE $S_TIME" _n
file write `qa_gate' "Source: `qa_input'" _n
file write `qa_gate' "Release status: `qa_release_status'" _n
file write `qa_gate' "Failed error-severity checks: `qa_failed_error_checks'" _n
file write `qa_gate' "Error issue rows: `qa_total_errors'" _n
file write `qa_gate' "Warning issue rows: `qa_total_warnings'" _n
file write `qa_gate' "Info issue rows: `qa_total_info'" _n
file write `qa_gate' "The pipeline does not edit source responses. Resolve or adjudicate issues and rerun." _n
file close `qa_gate'

display as text "------------------------------------------------------------"
display as result "Baseline QA complete"
display as result "Release status: `qa_release_status'"
display as result "Error rows: `qa_total_errors'; warning rows: `qa_total_warnings'; info rows: `qa_total_info'"
display as result "Workbook: `qa_workbook'"
display as result "Tagged data: `qa_dir'/phase1_baseline_dq_tagged.dta"
display as text "------------------------------------------------------------"

macro drop QA_ISSUES_ACC QA_CHECKS_ACC
capture program drop _qa_register
capture program drop _qa_add_issue
capture program drop _qa_check_vallabel
capture program drop _qa_exclusive
capture program drop _qa_maxselect
capture program drop _qa_other_specify

log close baseline_qa

/*******************************************************************************
End of file
*******************************************************************************/
