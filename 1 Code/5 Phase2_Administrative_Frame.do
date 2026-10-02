/* Phase 2 administrative census source extraction and final Stata validation.
   Run ONLY through stata_run_selection MCP. No Phase 1 workflow is executed.
   All existing sources are read only. No survey responses or respondent PII
   are exported. The Python companion builds the administrative reference CSV.
*/
version 19
args project_root export_only
if `"`project_root'"' == "" {
    local project_root "C:/Users/jzava/Dropbox (Personal)/Research & Consulting/1 Research/Legatum Uganda Advancing Justice"
}
local raw "`project_root'/3 Data/1 Raw/Secondary data"
local snapshots "`raw'/Phase2_Administrative_Sources"
local output "`project_root'/3 Data/2 Working/Phase2_Administrative_Frame"
capture mkdir "`snapshots'"
capture mkdir "`output'"

preserve
    import excel using "`raw'/BUSHENYI - Updated Admn Units as at 1st June 2024 (1).xls", ///
        sheet("Sheet1") allstring clear
    gen long excel_row = _n
    export delimited using "`snapshots'/bushenyi_2024_sheet1.csv", replace quote
restore

preserve
    use "`project_root'/3 Data/3 Coded/phase1_baseline_analysis.dta", clear
    keep canonical_village_uid canonical_district canonical_subcounty ///
        canonical_parish canonical_village p1_admin_origin ///
        selected_fvl100_observed selected100_frame_uid baseline_wave
    isid canonical_village_uid
    export delimited using "`snapshots'/phase1_geographic_reference.csv", replace quote nolabel
restore

preserve
    use "`project_root'/3 Data/2 Working/phase1_sampling_frame_full.dta", clear
    keep village_uid district subcounty parish village phase1_selected
    isid village_uid
    export delimited using "`snapshots'/phase1_sampling_geographic_reference.csv", replace quote nolabel
restore

if `"`export_only'"' == "export_only" {
    display as result "Phase 2 source extraction complete. Phase 1 inputs unchanged."
    exit
}

capture log close phase2check
log using "`output'/phase2_administrative_validation.log", name(phase2check) text replace
preserve
    import delimited using "`output'/phase2_administrative_village_frame.csv", ///
        varnames(1) stringcols(_all) encoding(utf8) clear
    destring anchor_pdf_page linked_phase1_records unresolved_candidate_rows source_evidence_rows, replace
    isid phase2_lc_uid
    assert _N == 1483 // Audited EC 2022 publication total, not an RCT sample target.
    assert district != "" & subcounty != "" & parish != "" & village != ""
    assert phase2_lc_uid == "UGA_" + district_code + "_" + constituency_code + ///
        "_" + subcounty_code + "_" + parish_code + "_" + village_code
    assert subcounty_uid == "UGA_SC_" + district_code + "_" + constituency_code + "_" + subcounty_code
    assert parish_uid == "UGA_P_" + district_code + "_" + constituency_code + "_" + subcounty_code + "_" + parish_code
    foreach code in district_code constituency_code subcounty_code parish_code village_code {
        assert strlen(`code') == 3
    }
    bysort subcounty_uid: assert district == district[1] & subcounty == subcounty[1]
    bysort parish_uid: assert subcounty_uid == subcounty_uid[1] & parish == parish[1]
    count if district == "BUSHENYI"
    assert r(N) == 571
    count if district == "RUBIRIZI"
    assert r(N) == 293
    count if district == "SHEEMA"
    assert r(N) == 619
    egen byte sc_tag = tag(subcounty_uid)
    count if sc_tag
    assert r(N) == 43
    egen byte parish_tag = tag(parish_uid)
    count if parish_tag
    assert r(N) == 199
    assert release_status == "ADMIN_REFERENCE_ONLY_NOT_RCT_ASSIGNMENT_FRAME"
    foreach excluded in respondent_name chairperson_name phone telephone uuid submission_key key treatment wave mentor_selected {
        capture confirm variable `excluded'
        assert _rc != 0
    }
    label variable phase2_lc_uid "Phase 2 reference LC ID derived from EC 2022 hierarchy"
    label variable linked_phase1_records "Documentary geographic links; not trained/mentor eligibility"
    label variable unresolved_candidate_rows "Overlapping review candidates, not missing LC count"
    drop sc_tag parish_tag
    sort phase2_lc_uid
    save "`output'/phase2_administrative_village_frame.dta", replace
    tab district
    summarize linked_phase1_records unresolved_candidate_rows
restore

preserve
    import delimited using "`output'/phase2_administrative_source_crosswalk.csv", ///
        varnames(1) stringcols(_all) encoding(utf8) clear
    isid source_row_id
    assert _N == 4155 // Rows in the pinned official/local/project snapshots.
    assert phase2_lc_uid != "" if inlist(match_status, ///
        "official_code_match", "full_hierarchy_match", "unique_admin_shorthand_match")
    assert phase2_lc_uid == "" if !inlist(match_status, ///
        "official_code_match", "full_hierarchy_match", "unique_admin_shorthand_match")
    merge m:1 phase2_lc_uid using "`output'/phase2_administrative_village_frame.dta", ///
        keepusing(anchor_source_id) keep(master match) generate(reference_merge)
    assert reference_merge == 3 if phase2_lc_uid != ""
    assert reference_merge == 1 if phase2_lc_uid == ""
    drop reference_merge anchor_source_id
    sort source_id source_row_id
    save "`output'/phase2_administrative_source_crosswalk.dta", replace
    tab source_id match_status, missing
restore
log close phase2check
display as result "Phase 2 administrative reference and crosswalk validated. No Phase 1 file changed."
