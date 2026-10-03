/* Phase 2 Milestones 2-6: reproducible geographic reference, not RCT assignment.
   Execute this entry point ONLY through stata_run_selection MCP.
   External source files and all geographic outputs are stored in Dropbox.
   Python is limited to HTTP/format conversion/geometric QA; final inputs,
   geographic joins and datasets are imported and validated below in Stata.
   No Phase 1 source, score, report, randomization or Master file is modified.
*/
version 19
args project_root mode companion
if `"`project_root'"' == "" {
    local project_root "C:/Users/jzava/Dropbox (Personal)/Research & Consulting/1 Research/Legatum Uganda Advancing Justice"
}
if `"`companion'"' == "" local companion "`c(pwd)'/1 Code/6 Phase2_Geospatial_Frame.py"
if !inlist(`"`mode'"', "", "build", "acquire", "reconcile", "neighbors", "auditfix", "coverage", "verification") {
    di as error "Unknown Phase2 mode. Use build, acquire, reconcile, neighbors, auditfix, coverage or verification."
    exit 198
}
local original_cwd "`c(pwd)'"
local output "`project_root'/3 Data/2 Working/Phase2_Geospatial_Frame"
local admin "`project_root'/3 Data/2 Working/Phase2_Administrative_Frame"
capture mkdir "`output'"
capture log close phase2geo
local validation_log "phase2_geographic_validation.log"
if `"`mode'"' == "reconcile" local validation_log "phase2_geographic_reconciliation_validation.log"
if `"`mode'"' == "neighbors" local validation_log "phase2_neighbor_validation.log"
if `"`mode'"' == "auditfix" local validation_log "phase2_metadata_import_correction.log"
if `"`mode'"' == "coverage" local validation_log "phase2_coverage_validation.log"
if `"`mode'"' == "verification" local validation_log "phase2_verification_validation.log"
log using "`output'/`validation_log'", name(phase2geo) text replace
preserve
clear all // Release native Sp/Mata file caches from prior runs; preserved data are restored at exit.
/* Only repair the mis-detected delimiter in the 22-row metadata inventory. */
if `"`mode'"' == "auditfix" {
    python:
import hashlib, json
from pathlib import Path
from sfi import Macro
out = Path(Macro.getLocal("output"))
manifest = json.loads((out / "phase2_geographic_manifest.json").read_text())
target = out / "phase2_source_layer_inventory.dta"
key = next(k for k in manifest["product_sha256"] if k.endswith("phase2_source_layer_inventory.dta"))
old_hash = hashlib.sha256(target.read_bytes()).hexdigest()
assert old_hash == manifest["product_sha256"][key], "Native metadata changed outside accepted receipt"
Macro.setLocal("old_inventory_hash", old_hash)
end
    import delimited using "`output'/phase2_source_layer_inventory.csv", ///
        delimiters(",") varnames(1) encoding(utf8) stringcols(_all) clear
    assert _N == 22
    confirm variable raw_path sublayer feature_rows geometry_type crs bounds fields retained_primary_layer role
    destring feature_rows retained_primary_layer, replace
    save "`output'/phase2_source_layer_inventory.dta", replace
    python:
import runpy
from sfi import Macro
module = runpy.run_path(Macro.getLocal("companion"))
module["repair_inventory_receipt"](Path(Macro.getLocal("project_root")), Macro.getLocal("old_inventory_hash"))
end
    restore
    log close phase2geo
    exit
}
python:
import sys, runpy
from sfi import Macro
sys.argv = [Macro.getLocal("companion"), "--root", Macro.getLocal("project_root"),
            "--acquire" if Macro.getLocal("mode") == "acquire" else
            "--reconcile" if Macro.getLocal("mode") == "reconcile" else
            "--coverage" if Macro.getLocal("mode") == "coverage" else
            "--verification" if Macro.getLocal("mode") == "verification" else
            "--neighbors" if Macro.getLocal("mode") == "neighbors" else "--build"]
runpy.run_path(Macro.getLocal("companion"), run_name="__main__")
end
if `"`mode'"' == "acquire" {
    restore
    log close phase2geo
    exit
}

/* M6: supplementary dated OSM context and a local-verification collection
   packet. Native imports are pending/reference inputs, never an RCT release. */
if `"`mode'"' == "verification" {
    foreach stem in phase2_osm_bulk_places phase2_osm_bulk_roads ///
        phase2_osm_bulk_waterways phase2_osm_bulk_areas phase2_osm_bulk_candidates ///
        phase2_osm_geometry_issues phase2_field_villages phase2_field_neighbors ///
        phase2_field_additions phase2_source_followup phase2_rule_decisions ///
        phase2_verification_summary {
        import delimited using "`output'/`stem'.csv", delimiters(",") ///
            varnames(1) encoding(utf8) stringcols(_all) bindquotes(strict) maxquotedrows(1000) clear
        gen long __source_order = _n
        foreach x in geo_id lon lat length_m spatial_parent_count same_district ///
            same_subcounty original100_flag historical_geo_id osm_name_candidate_count ///
            osm_same_parent_count historical_polygon_distance_m historical_point_distance_m ///
            historical_queen historical_rook identity_candidate_rows candidate_geo_id ///
            current_boundary_certified rct_geographic_release reference_lon reference_lat ///
            gps_accuracy_m travel_minutes count {
            capture confirm variable `x'
            if !_rc destring `x', replace
        }
        capture confirm variable rct_geographic_release
        if !_rc assert rct_geographic_release == 0
        capture confirm variable current_boundary_certified
        if !_rc assert current_boundary_certified == 0
        if inlist("`stem'", "phase2_osm_bulk_places", "phase2_osm_bulk_roads", ///
            "phase2_osm_bulk_waterways", "phase2_osm_bulk_areas") {
            if _N > 0 {
                isid geo_id
                isid osm_uid
                assert evidence_status == "OSM_UNVERIFIED_CONTEXT"
            }
        }
        if "`stem'" == "phase2_osm_bulk_places" {
            assert !missing(lon,lat) & inrange(lon,28,36) & inrange(lat,-3,6)
        }
        if "`stem'" == "phase2_osm_bulk_candidates" {
            if _N > 0 isid reference_row_id osm_uid
            assert identity_status == "UNCONFIRMED"
        }
        if "`stem'" == "phase2_field_villages" {
            assert _N == 1741
            isid review_row_id
            count if reference_group == "EC_2022_FRAME"
            assert r(N) == 1483
            count if original100_flag == 1
            assert r(N) == 100
            assert local_identity_status == "PENDING"
            assert mentor_status == "NOT_ASSESSED"
            assert missing(reference_lon, reference_lat)
        }
        if "`stem'" == "phase2_field_neighbors" {
            isid edge_review_id
            isid anchor_reference_row_id candidate_geo_id
            assert evidence_status == "HISTORICAL_REVIEW_CANDIDATE_NOT_ELIGIBLE"
            assert inrange(historical_polygon_distance_m,0,5000.000001)
            assert local_neighbor_status == ""
        }
        if "`stem'" == "phase2_field_additions" {
            assert _N == 40
            isid addition_row_id
            assert record_status == "BLANK_TEMPLATE_NOT_A_VILLAGE"
            assert candidate_ec_uid == "" & candidate_village == ""
        }
        if "`stem'" == "phase2_source_followup" {
            isid source_id
            assert !missing(verified_email, sent_message_id, sent_thread_id, sent_utc) ///
                if acquisition_status == "SENT_AWAITING_RESPONSE"
            assert !missing(delivery_notice_id, sent_message_id) if delivery_status == "FAILED"
            assert !missing(form_sent_utc, form_url, form_confirmation, form_proof_path, form_proof_sha256) ///
                if acquisition_status == "WEB_FORM_SUBMITTED_AWAITING_RESPONSE"
            assert availability == "UNKNOWN" if inlist(acquisition_status, ///
                "SENT_AWAITING_RESPONSE", "WEB_FORM_SUBMITTED_AWAITING_RESPONSE", ///
                "DELIVERY_FAILED_CONTACT_FOLLOWUP_REQUIRED")
        }
        foreach forbidden in chairperson_name respondent_name phone telephone ///
            submission_key uuid assigned_wave mentor_selected treatment {
            capture confirm variable `forbidden'
            assert _rc != 0
        }
        sort __source_order
        drop __source_order
        save "`output'/`stem'.dta", replace
    }
    cd "`output'/gis"
    foreach layer in places roads waterways areas {
        use "`output'/phase2_osm_bulk_`layer'.dta", clear
        if _N == 0 continue
        local shape "osm_`layer'_utm36s"
        spshape2dta `shape', replace saving(`shape')
        use "`output'/gis/`shape'.dta", clear
        isid geo_id
        isid _ID
        merge 1:1 geo_id using "`output'/phase2_osm_bulk_`layer'.dta", assert(match) nogen
        label variable geo_id "Source-specific OSM feature ID; not canonical LC ID"
        // Dropbox may briefly lock an owned generated file during sync.
        // Retry only r(608); do not alter permissions or bypass other errors.
        capture noisily save "`output'/gis/`shape'.dta", replace
        local save_rc = _rc
        forvalues attempt = 1/3 {
            if `save_rc' != 608 continue, break
            sleep 1000
            capture noisily save "`output'/gis/`shape'.dta", replace
            local save_rc = _rc
        }
        if `save_rc' exit `save_rc'
        spset, clear
        use "`output'/gis/`shape'_shp.dta", clear
        gen long source_vertex_order = _n
        assert missing(_X) == missing(_Y)
        assert inrange(_X,100000,900000) & inrange(_Y,9600000,10800000) if !missing(_X,_Y)
        merge m:1 _ID using "`output'/gis/`shape'.dta", keepusing(geo_id) assert(match) nogen
        sort _ID source_vertex_order
        capture noisily save "`output'/gis/`shape'_shp.dta", replace
        local save_rc = _rc
        forvalues attempt = 1/3 {
            if `save_rc' != 608 continue, break
            sleep 1000
            capture noisily save "`output'/gis/`shape'_shp.dta", replace
            local save_rc = _rc
        }
        if `save_rc' exit `save_rc'
    }
    cd "`original_cwd'"
    python:
import sys, runpy
from sfi import Macro
sys.argv = [Macro.getLocal("companion"), "--root", Macro.getLocal("project_root"), "--verification", "--review-workbook", "--verify"]
runpy.run_path(Macro.getLocal("companion"), run_name="__main__")
end
    di as result "M6 complete: dated public OSM context and pending local-verification packet. RCT release = 0."
    restore
    log close phase2geo
    exit
}

/* Milestone 5: exhaustive source-row coverage, dated reference geometries,
   transparent unknowns. Does not alter earlier products or approve neighbors. */
if `"`mode'"' == "coverage" {
    foreach stem in phase2_village_linkage_register phase2_lc_geometry_coverage ///
        phase2_linkage_candidates phase2_area_gazetteer phase2_gazetteer_discrepancies ///
        phase2_mapping_area_attributes phase2_partner_area_attributes ///
        phase2_mapping_parent_attributes phase2_project_map_points ///
        phase2_project_geo_neighbors phase2_project_geo_sensitivity ///
        phase2_boundary_source_audit phase2_coverage_summary ///
        phase2_osm_settlement_reference phase2_osm_name_candidates {
        import delimited using "`output'/`stem'.csv", delimiters(",") ///
            varnames(1) encoding(utf8) stringcols(_all) bindquotes(strict) maxquotedrows(1000) clear
        gen long __source_order = _n
        foreach x in original100_flag historical_geo_id historical_lon historical_lat ///
            historical_candidate_rows point_in_named_parent possible_level_error ///
            current_boundary_certified rct_geographic_release candidate_geo_id ///
            full_hierarchy_agrees same_name same_subcounty name_similarity ///
            retained_hist_reference duplicate_hierarchy_rows geo_id pop2002 hh2002 ///
            pop2010 hh2010 ele_access area_km2 shape_leng shape_area source_invalid ///
            same_geom_rows same_hierarchy_rows nonsettlement_name_flag geom_area_sqkm ///
            ref_lon ref_lat in_mapping_extent fid lon lat map_x_m map_y_m ///
            anchor_geo_id candidate_identity_rows polygon_distance_m point_distance_m ///
            queen_exact rook_exact same_district source_quality_flag point_le_1000m ///
            point_le_2000m point_le_3000m point_le_5000m historical_neighbor_rows ///
            identity_linked_neighbor_rows feature_rows reference_rows ec_identity_links ///
            historical_geometry_links missing_geometry_rows current_certified_boundaries {
            capture confirm variable `x', exact
            if !_rc {
                gen double __number = real(`x')
                assert !missing(__number) if `x' != ""
                drop `x'
                rename __number `x'
            }
        }
        capture confirm variable current_boundary_certified
        if !_rc assert current_boundary_certified == 0
        capture confirm variable rct_geographic_release
        if !_rc assert rct_geographic_release == 0
        if "`stem'" == "phase2_village_linkage_register" {
            assert _N == 258
            isid reference_row_id
            count if original100_flag == 1
            assert r(N) == 100
            count if reference_group == "PROJECT_PHASE1"
            assert r(N) == 130
            count if reference_group == "PROJECT_FVL"
            assert r(N) == 128
            assert mentor_status == "NOT_ASSESSED"
            assert missing(historical_lon) & missing(historical_lat) if missing(historical_geo_id)
            assert !missing(historical_lon,historical_lat) if !missing(historical_geo_id)
            assert original100_flag == 0 if reference_group == "PROJECT_PHASE1"
        }
        if "`stem'" == "phase2_lc_geometry_coverage" {
            assert _N == 1483
            isid phase2_lc_uid
        }
        if "`stem'" == "phase2_linkage_candidates" isid reference_row_id candidate_geo_id
        if "`stem'" == "phase2_area_gazetteer" {
            assert _N == 71230
            isid supplementary_row_id
        }
        if "`stem'" == "phase2_gazetteer_discrepancies" {
            assert _N == 3
            isid source_row_id
        }
        if inlist("`stem'", "phase2_mapping_area_attributes", "phase2_partner_area_attributes", "phase2_mapping_parent_attributes") isid geo_id
        if "`stem'" == "phase2_partner_area_attributes" assert _N == 740
        if "`stem'" == "phase2_mapping_parent_attributes" assert _N == 43
        if "`stem'" == "phase2_project_map_points" {
            isid reference_row_id
            assert !missing(lon,lat,map_x_m,map_y_m,historical_geo_id)
            assert inrange(lon,28,36) & inrange(lat,-3,6)
        }
        if "`stem'" == "phase2_project_geo_neighbors" {
            isid reference_row_id candidate_geo_id
            assert anchor_geo_id != candidate_geo_id
            assert inrange(polygon_distance_m,0,5000)
            assert point_distance_m >= polygon_distance_m - 0.000001
            assert rook_exact <= queen_exact
            assert point_le_1000m <= point_le_2000m & point_le_2000m <= point_le_3000m
            assert point_le_3000m <= point_le_5000m
        }
        if "`stem'" == "phase2_project_geo_sensitivity" {
            assert _N == 1548
            isid reference_row_id scenario
            bysort reference_row_id: assert _N == 6
            assert missing(historical_neighbor_rows,identity_linked_neighbor_rows) if missing(historical_geo_id)
            assert !missing(historical_neighbor_rows,identity_linked_neighbor_rows) if !missing(historical_geo_id)
            assert current_eligible_neighbors == "UNKNOWN"
        }
        if "`stem'" == "phase2_boundary_source_audit" isid source_id
        if "`stem'" == "phase2_osm_settlement_reference" isid osm_element_id
        if "`stem'" == "phase2_osm_name_candidates" isid reference_row_id osm_element_id
        if "`stem'" == "phase2_coverage_summary" {
            isid reference_group district
            assert historical_geometry_links + missing_geometry_rows == reference_rows
            assert current_certified_boundaries == 0
        }
        foreach forbidden in respondent_name chairperson_name phone telephone uuid submission_key mentor_selected treatment assigned_wave {
            capture confirm variable `forbidden'
            assert _rc != 0
        }
        sort __source_order
        drop __source_order
        save "`output'/`stem'.dta", replace
    }
    cd "`output'/gis"
    foreach stem in mapping_area_utm36s partner_area_utm36s mapping_parent_utm36s {
        local attributes "phase2_mapping_area_attributes"
        if "`stem'" == "partner_area_utm36s" local attributes "phase2_partner_area_attributes"
        if "`stem'" == "mapping_parent_utm36s" local attributes "phase2_mapping_parent_attributes"
        spshape2dta `stem', replace
        use "`output'/gis/`stem'.dta", clear
        isid _ID
        isid geo_id
        merge 1:1 geo_id using "`output'/`attributes'.dta", assert(match) nogen
        spset, modify coordsys(planar)
        label variable geo_id "Source-specific feature row; not a certified current LC identifier"
        save "`output'/gis/`stem'.dta", replace
        spset, clear
        use "`output'/gis/`stem'_shp.dta", clear
        gen long source_vertex_order = _n
        assert missing(_X) == missing(_Y)
        assert inrange(_X,100000,900000) & inrange(_Y,9600000,10800000) if !missing(_X,_Y)
        merge m:1 _ID using "`output'/gis/`stem'.dta", keepusing(geo_id) assert(match) nogen
        sort _ID source_vertex_order
        save "`output'/gis/`stem'_shp.dta", replace
    }

    /* Maps deliberately display only dated historical reference positions.
       Unlinked source rows remain in the register, never placed at a centroid. */
    use "`output'/gis/mapping_area_utm36s_shp.dta", clear
    merge m:1 geo_id using "`output'/phase2_mapping_area_attributes.dta", ///
        keepusing(district) assert(match) nogen
    gen byte map_layer = 1
    tempfile map_area
    save `map_area'
    use "`output'/gis/mapping_parent_utm36s_shp.dta", clear
    merge m:1 geo_id using "`output'/phase2_mapping_parent_attributes.dta", ///
        keepusing(district) assert(match) nogen
    gen byte map_layer = 2
    append using `map_area'
    tempfile map_shapes
    save `map_shapes'
    use "`output'/phase2_project_map_points.dta", clear
    gen byte map_layer = cond(original100_flag == 1, 3, 4)
    rename map_x_m _X
    rename map_y_m _Y
    append using `map_shapes'
    gen double map_x_km = _X / 1000
    gen double map_y_km = _Y / 1000
    sort map_layer _ID source_vertex_order
    tempfile complete_map
    save `complete_map'
    set scheme s2color
    foreach district in ALL BUSHENYI RUBIRIZI SHEEMA {
        use `complete_map', clear
        if "`district'" != "ALL" keep if upper(district) == "`district'"
        quietly summarize map_y_km
        local y0 = r(min)
        local dy = r(max) - r(min)
        quietly summarize map_x_km
        local x0 = r(min)
        local dx = r(max) - r(min)
        local aspect = `dy'/`dx'
        local sy = `y0' + .04*`dy'
        local sx = `x0' + .05*`dx'
        local sx1 = `sx'+10
        local sxmid = `sx'+5
        local sly = `sy'+.035*`dy'
        local nx = `x0'+.94*`dx'
        local ny0 = `y0'+.81*`dy'
        local ny1 = `y0'+.92*`dy'
        local nt = `y0'+.96*`dy'
        // Sheema is narrow in the north and west: use its open map margins.
        if "`district'" == "SHEEMA" {
            local sx = `x0'+.05*`dx'
            local sy = `y0'+.45*`dy'
            local sx1 = `sx'+10
            local sxmid = `sx'+5
            local sly = `sy'+.035*`dy'
            local nx = `x0'+1.08*`dx'
        }
        twoway (line map_y_km map_x_km if map_layer == 1, cmissing(n) lcolor(gs13) lwidth(vthin)) ///
            (line map_y_km map_x_km if map_layer == 2, cmissing(n) lcolor("31 78 121") lwidth(thin)) ///
            (scatter map_y_km map_x_km if map_layer == 3, mcolor("43 122 111") msymbol(D) msize(small)) ///
            (scatter map_y_km map_x_km if map_layer == 4, mcolor("187 109 31") msymbol(O) msize(vsmall)) ///
            (pci `sy' `sx' `sy' `sx1', lcolor(gs4) lwidth(medium)) ///
            (pcarrowi `ny0' `nx' `ny1' `nx', lcolor(gs4) mcolor(gs4)), ///
            title("Available village mapping references: `district'", size(medium)) ///
            subtitle("Historical village polygons and 2024 census subcounty context", size(small)) ///
            xtitle("") ytitle("") xlabel(none) ylabel(none) xscale(noline) yscale(noline) aspectratio(`aspect') ///
            text(`sly' `sxmid' "10 km", size(small)) text(`nt' `nx' "N", size(small)) ///
            legend(order(1 "Historical village polygons" 2 "2024 census subcounty context" ///
                         3 "Original 100: historical references" 4 "Other project historical references") size(small) rows(2)) ///
            note("Sources: NPA nominal UBOS 2011/2016; UBOS census 2024. Projection: EPSG32736 (metres)." ///
                 "Points are polygon interior references, not GPS or current village certification. Unlinked villages are not plotted." ///
                 "Source groups overlap. No mentor eligibility, approved neighbors or assignment is represented.", size(vsmall)) ///
            graphregion(color(white)) plotregion(color(white)) name(phase2coverage, replace)
        graph export "`output'/phase2_village_mapping_`district'.png", width(2400) replace
    }
    python:
sys.argv = [Macro.getLocal("companion"), "--root", Macro.getLocal("project_root"), "--coverage", "--review-workbook", "--verify"]
runpy.run_path(Macro.getLocal("companion"), run_name="__main__")
end
    cd "`original_cwd'"
    restore
    log close phase2geo
    di as result "Milestone 5 mapping references and coverage verified. Current LC coverage is incomplete; not an RCT release."
    exit
}

/* Historical scenarios, not current LC eligibility or assessed mentor status. */
if `"`mode'"' == "neighbors" {
    foreach stem in phase2_neighbor_edges phase2_neighbor_sensitivity ///
        phase2_neighbor_project_coverage phase2_neighbor_shared_candidates ///
        phase2_neighbor_rules phase2_milestone_audit {
        import delimited using "`output'/`stem'.csv", delimiters(",") ///
            varnames(1) encoding(utf8) stringcols(_all) clear
        foreach x in anchor_geo_id project_anchor candidate_geo_id candidate_in_study ///
            same_district candidate_project_identity candidate_geometry_copies ///
            candidate_name_repeats candidate_nonsettlement candidate_source_invalid ///
            point_distance_m polygon_distance_m shared_border_m overlap_area_m2 ///
            positive_area_overlap queen_exact rook_exact short_border_review ///
            point_le_1000m point_le_2000m point_le_3000m point_le_5000m ///
            current_boundary_certified rct_geographic_release historical_polygon_rows ///
            identity_linked_lcs known_project_identities outside_study_rows ///
            cross_district_rows overlap_rows source_quality_flag_rows ///
            hist_rows_at_least_6 hist_rows_at_least_8 historical_geo_id ///
            queen_exact_rows rook_exact_rows point_1000m_rows point_2000m_rows ///
            point_3000m_rows point_5000m_rows mapped_project_anchors observed {
            capture confirm variable `x', exact
            if !_rc {
                gen double __number = real(`x')
                assert !missing(__number) if `x' != ""
                drop `x'
                rename __number `x'
            }
        }
        capture confirm variable rct_geographic_release
        if !_rc assert rct_geographic_release == 0 & current_boundary_certified == 0
        if "`stem'" == "phase2_neighbor_edges" {
            isid anchor_lc_uid candidate_geo_id
            assert anchor_geo_id != candidate_geo_id
            assert polygon_distance_m >= 0 & polygon_distance_m <= 5000
            assert point_distance_m >= polygon_distance_m - 0.000001
            assert rook_exact <= queen_exact
            assert positive_area_overlap == 0 if queen_exact == 1
            assert point_le_1000m <= point_le_2000m & point_le_2000m <= point_le_3000m
            assert point_le_3000m <= point_le_5000m
            assert point_le_1000m == (point_distance_m <= 1000)
            assert point_le_2000m == (point_distance_m <= 2000)
            assert point_le_3000m == (point_distance_m <= 3000)
            assert point_le_5000m == (point_distance_m <= 5000)
        }
        if "`stem'" == "phase2_neighbor_sensitivity" {
            assert _N == 1896
            isid anchor_lc_uid scenario
            bysort anchor_lc_uid: assert _N == 6
            assert identity_linked_lcs <= historical_polygon_rows
            assert current_eligible_neighbors == "UNKNOWN"
            assert hist_rows_at_least_6 == (historical_polygon_rows >= 6)
            assert hist_rows_at_least_8 == (historical_polygon_rows >= 8)
        }
        if "`stem'" == "phase2_neighbor_project_coverage" {
            assert _N == 130
            isid project_source_row_id
            count if !missing(historical_geo_id)
            assert r(N) == 10
            count if linked_ec_uid != ""
            assert r(N) == 37
            assert mentor_status == "NOT_ASSESSED" & neighbors_status == "NOT_APPROVED"
            foreach x in queen_exact_rows rook_exact_rows point_1000m_rows ///
                point_2000m_rows point_3000m_rows point_5000m_rows {
                assert missing(`x') if missing(historical_geo_id)
            }
        }
        if "`stem'" == "phase2_neighbor_shared_candidates" {
            isid scenario candidate_geo_id
            assert mapped_project_anchors >= 2
            assert ownership_status == "NOT_ASSIGNED"
        }
        if "`stem'" == "phase2_neighbor_rules" {
            assert _N == 6
            isid scenario
        }
        if "`stem'" == "phase2_milestone_audit" isid check
        save "`output'/`stem'.dta", replace
    }
    python:
sys.argv = [Macro.getLocal("companion"), "--root", Macro.getLocal("project_root"), "--neighbors", "--review-workbook", "--verify"]
runpy.run_path(Macro.getLocal("companion"), run_name="__main__")
end
    restore
    log close phase2geo
    di as result "Historical neighbor scenarios and cumulative audit verified. NOT an eligible RCT frame."
    exit
}

/* Milestone 3 is an isolated continuation: preserve all Milestone 2 products,
   source identifiers and held release decisions. No neighbor rule is applied. */
if `"`mode'"' == "reconcile" {
    use "`admin'/phase2_administrative_village_frame.dta", clear
    keep phase2_lc_uid
    isid phase2_lc_uid
    tempfile census_ids
    save `census_ids'

    import delimited using "`output'/phase2_reconciled_lc_reference.csv", ///
        varnames(1) encoding(utf8) stringcols(_all) clear
    destring current_boundary_certified rct_geographic_release, replace
    assert _N == 1483
    foreach metric in hist_ref_lon hist_ref_lat historical_point_in_census_sc ///
        candidate_geometry_rows hist_source_invalid hist_same_geometry_rows hist_point_in_district {
        destring `metric', replace
    }
    isid phase2_lc_uid
    assert current_boundary_certified == 0 & rct_geographic_release == 0
    count if historical_geo_id != ""
    assert r(N) == 316
    merge 1:1 phase2_lc_uid using `census_ids', generate(__census_match)
    tab __census_match, missing
    assert __census_match == 3
    drop __census_match
    save "`output'/phase2_reconciled_lc_reference.dta", replace

    import delimited using "`output'/phase2_reconciled_project_reference.csv", ///
        varnames(1) encoding(utf8) stringcols(_all) clear
    destring current_boundary_certified rct_geographic_release, replace
    assert _N == 130
    isid source_row_id
    bysort linked_ec_uid: assert _N == 1 if linked_ec_uid != ""
    count if linked_ec_uid != ""
    assert r(N) == 37
    assert !missing(district)
    assert current_boundary_certified == 0 & rct_geographic_release == 0
    tab district, missing
    save "`output'/phase2_reconciled_project_reference.dta", replace

    import delimited using "`output'/phase2_ubos2024_parish_context.csv", ///
        varnames(1) encoding(utf8) stringcols(_all) clear
    destring current_boundary_certified rct_geographic_release, replace
    assert _N == 199
    isid ubos_parish_code
    assert current_boundary_certified == 0 & rct_geographic_release == 0
    save "`output'/phase2_ubos2024_parish_context.dta", replace

    import delimited using "`output'/phase2_ubos2024_subcounty_context.csv", ///
        varnames(1) encoding(utf8) stringcols(_all) clear
    destring geo_id current_boundary_certified rct_geographic_release, replace
    foreach numeric in ref_lon ref_lat source_invalid geom_area_sqkm {
        capture confirm variable `numeric'
        if !_rc destring `numeric', replace
    }
    assert _N == 43
    isid geo_id
    isid ubos_subcounty_code
    assert current_boundary_certified == 0 & rct_geographic_release == 0
    tempfile census_sc_attributes
    save `census_sc_attributes'
    cd "`output'/gis"
    spshape2dta ubos2024_subcounties, saving(ubos2024_subcounty_attr) replace
    use "`output'/gis/ubos2024_subcounty_attr.dta", clear
    assert _N == 43
    isid geo_id
    isid _ID
    merge 1:1 geo_id using `census_sc_attributes', generate(__shape_match)
    tab __shape_match, missing
    assert __shape_match == 3
    drop __shape_match
    spset, modify shpfile(ubos2024_subcounty_attr_shp) ///
        coordsys(latlong, kilometers)
    spset
    label variable geo_id "UBOS context source feature row; not an LC or respondent ID"
    save "`output'/gis/ubos2024_subcounty_attr.dta", replace
    spset, clear // Release Windows mapped coordinate file before reloading it.
    save "`output'/phase2_ubos2024_subcounty_context.dta", replace
    use "`output'/gis/ubos2024_subcounty_attr_shp.dta", clear
    gen long source_vertex_order = _n
    assert missing(_X) == missing(_Y)
    assert inrange(_X, 28, 36) & inrange(_Y, -3, 6) if !missing(_X, _Y)
    merge m:1 _ID using "`output'/gis/ubos2024_subcounty_attr.dta", ///
        keepusing(geo_id) generate(__vertex_match)
    tab __vertex_match, missing
    assert __vertex_match == 3
    drop __vertex_match
    sort _ID source_vertex_order
    save "`output'/gis/ubos2024_subcounty_attr_shp.dta", replace

    import delimited using "`output'/phase2_reconciliation_geometry_candidates.csv", ///
        varnames(1) encoding(utf8) stringcols(_all) clear
    destring candidate_inside_census_sc candidate_parent_name_agrees accepted_documentary_link, replace
    if _N > 0 isid phase2_lc_uid candidate_geo_id
    assert inlist(candidate_inside_census_sc, 0, 1)
    merge m:1 phase2_lc_uid using `census_ids', keep(master match) generate(__candidate_match)
    tab __candidate_match, missing
    assert __candidate_match == 3
    drop __candidate_match
    save "`output'/phase2_reconciliation_geometry_candidates.dta", replace

    python: sys.argv = [Macro.getLocal("companion"), "--root", Macro.getLocal("project_root"), "--reconcile", "--review-workbook", "--verify"]; runpy.run_path(Macro.getLocal("companion"), run_name="__main__")
    cd "`original_cwd'"
    restore
    log close phase2geo
    display as result "Milestone 3 documentary reconciliation and native Stata validation complete. NOT an RCT release."
    exit
}

/* Every retained GIS layer enters Stata. Original geometries remain archived;
   these native linked Sp datasets use explicit WGS84 longitude/latitude. */
foreach layer in district_context subcounty_context historical_villages parish_context {
    import delimited using "`output'/`layer'_attributes.csv", ///
        varnames(1) encoding(utf8) stringcols(_all) clear
    // Codes are strings: preserve leading zeros and source-specific namespaces.
    destring geo_id ref_lon ref_lat source_invalid same_geom_rows, replace
    foreach numeric in same_hierarchy_rows nonsettlement_name_flag geom_area_sqkm ///
        pop2002 hh2002 pop2010 hh2010 ele_access area_km2 shape_leng shape_area ///
        area_sqkm center_lon center_lat male female {
        capture confirm variable `numeric'
        if !_rc destring `numeric', replace
    }
    isid geo_id
    assert inrange(ref_lon, 28, 36) & inrange(ref_lat, -3, 6)
    local expected = _N
    tempfile attributes
    save `attributes'
    cd "`output'/stata_bridge"
    spshape2dta `layer', replace
    use "`output'/stata_bridge/`layer'.dta", clear
    assert _N == `expected'
    isid geo_id
    assert _ID == geo_id
    merge 1:1 geo_id using `attributes', assert(match) nogen
    spset, modify coordsys(latlong, kilometers)
    spset
    label variable geo_id "Source feature row ID; not an LC or survey ID"
    label variable ref_lon "Derived polygon interior longitude, not interview GPS"
    label variable ref_lat "Derived polygon interior latitude, not interview GPS"
    save "`output'/stata_bridge/`layer'.dta", replace
    spset, clear // Free mapped shapefile before loading its coordinate dataset (Windows file locking).
    use "`output'/stata_bridge/`layer'_shp.dta", clear
    gen long source_vertex_order = _n
    assert inrange(_X, 28, 36) & inrange(_Y, -3, 6) if !missing(_X, _Y)
    merge m:1 _ID using "`output'/stata_bridge/`layer'.dta", keepusing(study_district) assert(match) nogen
    sort _ID source_vertex_order
    save "`output'/stata_bridge/`layer'_shp.dta", replace
}

import delimited using "`output'/historical_points_attributes.csv", ///
    varnames(1) encoding(utf8) stringcols(_all) clear
destring geo_id ref_lon ref_lat source_invalid same_geom_rows inside_study_geometry, replace
assert _N == 5330
isid geo_id
assert inrange(ref_lon,28,36) & inrange(ref_lat,-3,6)
spset geo_id, coord(ref_lon ref_lat) coordsys(latlong, kilometers)
label variable inside_study_geometry "Inside dated district context; not an LC identity link"
save "`output'/historical_points.dta", replace

import delimited using "`output'/phase2_geometry_links.csv", varnames(1) encoding(utf8) asdouble clear
isid phase2_lc_uid
assert _N == 1483
assert current_lc_boundary_verified == 0 & rct_assignment_frame_released == 0
assert !missing(hist_ref_lon, hist_ref_lat) if !missing(village_geo_id)
assert missing(hist_ref_lon) & missing(hist_ref_lat) if missing(village_geo_id)
tempfile links
save `links'
use "`admin'/phase2_administrative_village_frame.dta", clear
merge 1:1 phase2_lc_uid using `links', assert(match) nogen
isid phase2_lc_uid
assert _N == 1483
gen str80 geographic_release_status = "HISTORICAL_REFERENCE_ONLY_NOT_RCT_ASSIGNMENT_FRAME"
label variable hist_ref_lon "Historical polygon interior longitude; not survey GPS"
label variable hist_ref_lat "Historical polygon interior latitude; not survey GPS"
label variable village_geo_id "NPA historical feature ID; not proof of current LC geometry"
label variable parish_geo_id "NBRB contextual parish feature ID; not village geometry"
foreach forbidden in respondent_name chairperson_name phone telephone uuid submission_key key mentor_selected treatment assigned_wave {
    capture confirm variable `forbidden'
    assert _rc != 0
}
sort phase2_lc_uid
save "`output'/phase2_geographic_lc_reference.dta", replace
export delimited using "`output'/phase2_geographic_lc_reference.csv", replace quote
keep if !missing(village_geo_id)
isid village_geo_id
use "`output'/phase2_geographic_lc_reference.dta", clear
tab district geometry_link_status, missing
tab district parish_link_status, missing
count if !missing(village_geo_id)
assert r(N) == 316 // Derived conservative links, independently audited; not a target sample.
count if !missing(parish_geo_id)
assert r(N) == 1461

foreach item in phase2_geometry_candidates phase2_geometry_issues phase2_geographic_layers ///
    phase2_geographic_sources phase2_spatial_checks phase2_geographic_coverage ///
    phase2_source_layer_inventory phase2_geographic_dictionary {
    import delimited using "`output'/`item'.csv", delimiters(",") varnames(1) encoding(utf8) clear
    save "`output'/`item'.dta", replace
}
import delimited using "`output'/phase2_project_geometry_crosswalk.csv", ///
    varnames(1) stringcols(_all) encoding(utf8) clear
isid phase1_uid
assert _N == 130
merge m:1 phase2_lc_uid using "`output'/phase2_geographic_lc_reference.dta", ///
    keepusing(geographic_release_status) keep(master match) generate(geo_merge)
assert geo_merge == 3 if phase2_lc_uid != ""
assert geo_merge == 1 if phase2_lc_uid == ""
drop geo_merge
save "`output'/phase2_project_geometry_crosswalk.dta", replace
tab match_status geometry_link_status, missing

/* Diagnostic maps only. No adjacency or neighborhood rule is computed. */
use "`output'/stata_bridge/historical_villages_shp.dta", clear
keep if study_district != ""
gen byte map_layer = 1
append using "`output'/stata_bridge/district_context_shp.dta"
replace map_layer = 2 if missing(map_layer)
keep if study_district != ""
tempfile map_shapes
save `map_shapes'
use "`output'/phase2_geographic_lc_reference.dta", clear
keep if !missing(village_geo_id)
gen str32 study_district = district
gen byte map_layer = 3
rename hist_ref_lon _X
rename hist_ref_lat _Y
append using `map_shapes'
sort map_layer _ID source_vertex_order
tempfile complete_map
save `complete_map'
set scheme s2color
foreach district in ALL BUSHENYI RUBIRIZI SHEEMA {
    use `complete_map', clear
    if "`district'" != "ALL" keep if study_district == "`district'"
    quietly summarize _Y
    local dy = r(max) - r(min)
    quietly summarize _X
    local aspect = `dy' / (r(max) - r(min))
    twoway (line _Y _X if map_layer == 1, cmissing(n) lcolor(gs12) lwidth(vthin)) ///
        (line _Y _X if map_layer == 2, cmissing(n) lcolor("31 78 121") lwidth(medium)) ///
        (scatter _Y _X if map_layer == 3, mcolor("187 109 31") msymbol(O) msize(vsmall)), ///
        title("Historical geographic coverage: `district'", size(medium)) ///
        subtitle("Documentary LC links to nominal UBOS 2011 polygons", size(small)) ///
        xtitle("Longitude (WGS84)") ytitle("Latitude (WGS84)") aspectratio(`aspect') ///
        legend(order(1 "Historical village polygons" 2 "Dated district context" 3 "Hierarchy-linked interior points") size(small) rows(3)) ///
        note("Diagnostic only. Interior points are not survey GPS or verified current LC locations." ///
             "No mentor eligibility, neighbor selection or treatment assignment is represented.", size(vsmall)) ///
        graphregion(color(white)) plotregion(color(white)) name(phase2geo, replace)
    graph export "`output'/phase2_geographic_coverage_`district'.png", width(2400) replace
}
python:
sys.argv = [Macro.getLocal("companion"), "--root", Macro.getLocal("project_root"), "--review-workbook", "--verify"]
runpy.run_path(Macro.getLocal("companion"), run_name="__main__")
end
cd "`original_cwd'"
restore
log close phase2geo
display as result "Milestone 2 GIS import and reference validation complete. NOT an RCT release."
