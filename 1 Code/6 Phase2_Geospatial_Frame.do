/* Phase 2 Milestone 2: reproducible geographic reference, not RCT assignment.
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
local original_cwd "`c(pwd)'"
local output "`project_root'/3 Data/2 Working/Phase2_Geospatial_Frame"
local admin "`project_root'/3 Data/2 Working/Phase2_Administrative_Frame"
capture mkdir "`output'"
capture log close phase2geo
log using "`output'/phase2_geographic_validation.log", name(phase2geo) text replace
preserve
clear all // Release native Sp/Mata file caches from prior runs; preserved data are restored at exit.
python:
import sys, runpy
from sfi import Macro
sys.argv = [Macro.getLocal("companion"), "--root", Macro.getLocal("project_root"),
            "--acquire" if Macro.getLocal("mode") == "acquire" else "--build"]
runpy.run_path(Macro.getLocal("companion"), run_name="__main__")
end
if `"`mode'"' == "acquire" {
    restore
    log close phase2geo
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
    import delimited using "`output'/`item'.csv", varnames(1) encoding(utf8) clear
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
