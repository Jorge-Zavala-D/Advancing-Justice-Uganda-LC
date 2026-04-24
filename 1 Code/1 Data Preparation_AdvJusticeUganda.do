/*------------------------------------------------------------------------------*
| Title: 			Data preparation											|
| Project: 			Advancing Justice Uganda LC training for case diversion		|
| Authors:			Jorge Zavala 												|
| 					  									                        |
|																				|
| Description:		This .do imports, cleans and prepares data for analysis 	|
|                                                                               |
| Date created: 24/04/2026			 					                        |
|																			    |
| Version: Stata 19 	                    							 	    |
*-------------------------------------------------------------------------------*/

/*--------------------------*
*           INDEX           *
*---------------------------*



*-------------------------------------------------------------------------------*/


*-----------------------------------------------*
**#		0. Admin Case Data at village level		*
*-----------------------------------------------*
{
clear all
import excel "${input_dir}/Secondary data/Number of cases per sub-county Jan - Dec 2025 cleaned.xlsx", firstrow sheet("Sheet1")
	
	rename Numberofcases number_of_cases
	rename District district
	rename Subcounty subcounty
	rename Parish parish
	rename Village village
		
	* Basic string cleaning
	foreach var in district subcounty parish village {
		replace `var' = subinstr(`var', char(160), " ", .) if !missing(`var')
		replace `var' = ustrregexra(`var', "[\u2018\u2019]", "'") if !missing(`var')
		replace `var' = ustrregexra(`var', "[\u201C\u201D]", `"""') if !missing(`var')
		replace `var' = ustrregexra(`var', "[\u2013\u2014]", "-") if !missing(`var')
		replace `var' = ustrregexra(`var', "\s+", " ") if !missing(`var')
		replace `var' = itrim(strtrim(`var')) if !missing(`var')
	}
	
	* Clean numeric case variable
	destring number_of_cases, replace force
	assert !missing(number_of_cases)
	assert number_of_cases > 0
	assert number_of_cases == int(number_of_cases)
	recast long number_of_cases	
	
	* Create aux standardized key variables
	foreach var in district subcounty parish village {
		gen `var'_key = lower(`var')
		replace `var'_key = subinstr(`var'_key, "'", "", .)
		replace `var'_key = subinstr(`var'_key, "`", "", .)
		replace `var'_key = subinstr(`var'_key, ".", "", .)
		replace `var'_key = subinstr(`var'_key, ",", "", .)
		replace `var'_key = subinstr(`var'_key, "-", "_", .)
		replace `var'_key = subinstr(`var'_key, "/", "_", .)
		replace `var'_key = subinstr(`var'_key, "(", "", .)
		replace `var'_key = subinstr(`var'_key, ")", "", .)
		replace `var'_key = subinstr(`var'_key, " ", "_", .)
		replace `var'_key = strtoname(`var'_key)
	}

	egen village_uid = concat(district_key subcounty_key parish_key village_key), punct("_")

	* Create numeric IDs for villages
	egen district_id  = group(district), label
	egen subcounty_id = group(district subcounty), label
	egen parish_id    = group(district subcounty parish), label
	egen village_id   = group(district subcounty parish village), label
	

	* Create aux variables for sampling
	bysort district: egen district_total_cases = total(number_of_cases)
	bysort district: egen n_villages_district  = count(village_id)

	gen case_share_district = number_of_cases / district_total_cases
	format case_share_district %9.4f

		* District-specific case ranking
	gsort district -number_of_cases village
	by district: gen case_rank_district = _n
	sort district subcounty parish village

		* District-specific percentile cutoffs (useful for later hotspot definitions)
	bysort district: egen p50_cases_district = pctile(number_of_cases), p(50)
	bysort district: egen p75_cases_district = pctile(number_of_cases), p(75)
	bysort district: egen p90_cases_district = pctile(number_of_cases), p(90)

	gen hotspot_p75_district = number_of_cases >= p75_cases_district
	gen hotspot_p90_district = number_of_cases >= p90_cases_district

	label define yesno 0 "No" 1 "Yes"
	label values hotspot_p75_district yesno
	label values hotspot_p90_district yesno	
		
	* Label variables and create annotations
	label var district              "District"
	label var subcounty             "Subcounty"
	label var parish                "Parish/Ward"
	label var village               "Village"
	label var number_of_cases       "Police-recorded reported cases, Jan-Dec 2025"
	label var district_id           "Numeric district identifier"
	label var subcounty_id          "Numeric subcounty identifier"
	label var parish_id             "Numeric parish identifier"
	label var village_id            "Numeric village identifier"
	label var village_uid           "Unique village key from standardized strings"
	label var district_total_cases  "Total recorded cases within district"
	label var n_villages_district   "Number of villages in district sampling frame"
	label var case_share_district   "Village share of district total cases"
	label var case_rank_district    "Village rank by cases within district (descending)"
	label var p50_cases_district    "District-specific p50 of village cases"
	label var p75_cases_district    "District-specific p75 of village cases"
	label var p90_cases_district    "District-specific p90 of village cases"
	label var hotspot_p75_district  "Village is at/above district p75 case threshold"
	label var hotspot_p90_district  "Village is at/above district p90 case threshold"

	label data "Village-level police-recorded case frame, Jan-Dec 2025"

	note: Sampling universe is NOT the full administrative village universe.
	note: Sampling universe includes only villages appearing in police records with reported cases during Jan-Dec 2025.
	note: Dataset cleaned from Excel file 'Number of cases per sub-county Jan - Dec 2025 cleaned.xlsx'.

	order district district_id subcounty subcounty_id parish parish_id village village_id village_uid ///
		number_of_cases district_total_cases n_villages_district case_share_district case_rank_district ///
		p50_cases_district p75_cases_district p90_cases_district hotspot_p75_district hotspot_p90_district
	
		
	save "${input_dir}/2 Working/village_cases_2025_clean.dta", ///
		replace

	
}

*---------------------------------------------------*
**#		I. Sampling of 100 villages for Phase I		*
*---------------------------------------------------*
{
use "${input_dir}/2 Working/village_cases_2025_clean.dta", ///
	clear
	
	* Parameters for the Phase I sampling process
	local N_phase1                = 100
	local seed_phase1             = 26042026
	local hotspot_min_share       = 0.50   // minimum share of hotspots within each district quota, if feasible
	local replacement_ratio       = 1      // 1 = one-for-one reserve list within each district-hotspot stratum
	
	* Define district quotas: Prop. allocation across police-case village frame
	preserve
		keep district district_id village_id
		collapse (count) n_frame_district = village_id, by(district district_id)

		egen N_frame_total = total(n_frame_district)
		gen target_select_district = `N_phase1' * n_frame_district / N_frame_total

		gen n_select_district = floor(target_select_district)
		gen remainder_district = target_select_district - n_select_district

		quietly summarize n_select_district, meanonly
		local allocated_floor = r(sum)
		local n_leftover = `N_phase1' - `allocated_floor'

		gsort -remainder_district district_id
		replace n_select_district = n_select_district + 1 in 1/`n_leftover'
		sort district_id

		quietly summarize n_select_district, meanonly
		assert r(sum) == `N_phase1'

		tempfile district_quota
		save `district_quota'
	restore
	
	* Define district x Hotspot quotas: Hotsposts are oversampled to a minimum share within district when feasible
	preserve
		keep district district_id hotspot_p75_district village_id
		collapse (count) n_frame_stratum = village_id, by(district district_id hotspot_p75_district)

		reshape wide n_frame_stratum, i(district district_id) j(hotspot_p75_district)

		capture confirm variable n_frame_stratum0
		if _rc gen n_frame_stratum0 = 0
		capture confirm variable n_frame_stratum1
		if _rc gen n_frame_stratum1 = 0

		rename n_frame_stratum0 n_nonhot_frame
		rename n_frame_stratum1 n_hot_frame

		replace n_nonhot_frame = 0 if missing(n_nonhot_frame)
		replace n_hot_frame    = 0 if missing(n_hot_frame)

		merge 1:1 district district_id using `district_quota', nogen assert(match)

		gen hot_obs_share = cond((n_hot_frame + n_nonhot_frame) > 0, ///
								 n_hot_frame / (n_hot_frame + n_nonhot_frame), 0)

		gen n_hot_quota_prop = round(n_select_district * hot_obs_share)
		gen n_hot_quota_min  = ceil(n_select_district * `hotspot_min_share')

		gen n_select_hot = max(n_hot_quota_prop, n_hot_quota_min)
		replace n_select_hot = n_hot_frame if n_select_hot > n_hot_frame

		gen n_select_nonhot = n_select_district - n_select_hot
		replace n_select_nonhot = n_nonhot_frame if n_select_nonhot > n_nonhot_frame

		* Backfill to ensure district totals still add up after capacity constraints
		replace n_select_hot = n_select_district - n_select_nonhot

		assert n_select_hot + n_select_nonhot == n_select_district

		* One-for-one reserve list within district x hotspot strata where feasible
		gen n_reserve_hot    = min(n_select_hot    * `replacement_ratio', n_hot_frame    - n_select_hot)
		gen n_reserve_nonhot = min(n_select_nonhot * `replacement_ratio', n_nonhot_frame - n_select_nonhot)

		tempfile stratum_quota_wide
		save `stratum_quota_wide'
	restore	
	/* Convert stratum quotas to long format for merge back to village-level frame */
	preserve
		use `stratum_quota_wide', clear
		keep district district_id n_select_hot n_reserve_hot
		gen hotspot_p75_district = 1
		rename n_select_hot    n_select_stratum
		rename n_reserve_hot   n_reserve_stratum
		tempfile hot_quota
		save `hot_quota'
	restore

	preserve
		use `stratum_quota_wide', clear
		keep district district_id n_select_nonhot n_reserve_nonhot
		gen hotspot_p75_district = 0
		rename n_select_nonhot  n_select_stratum
		rename n_reserve_nonhot n_reserve_stratum
		tempfile nonhot_quota
		save `nonhot_quota'
	restore

	use "${input_dir}/2 Working/village_cases_2025_clean.dta", clear
	merge m:1 district district_id using `district_quota', nogen assert(match)
	merge m:1 district district_id hotspot_p75_district using `hot_quota', nogen keep(master match)
	merge m:1 district district_id hotspot_p75_district using `nonhot_quota', nogen update replace

	assert !missing(n_select_stratum, n_reserve_stratum)	
	
	* Replicable randomization draws (fixed seed, random order within subcounty)
	set seed `seed_phase1'

	* Random ordering within subcounty
	gen double u_village = runiform()

	sort district_id hotspot_p75_district subcounty_id u_village village_id
	by district_id hotspot_p75_district subcounty_id: gen within_subcounty_order = _n

	* Random ordering of subcounties within each district x hotspot stratum
	sort district_id hotspot_p75_district subcounty_id village_id
	by district_id hotspot_p75_district subcounty_id: gen double u_subcounty = runiform() if _n == 1
	by district_id hotspot_p75_district subcounty_id: replace u_subcounty = u_subcounty[1]

	* Final interleaved order:
	* first village from each subcounty, then second village from each subcounty, etc.
	sort district_id hotspot_p75_district within_subcounty_order u_subcounty u_village village_id
	by district_id hotspot_p75_district: gen rank_in_stratum = _n	
	
	* Select primary sample and replacement list
	gen byte phase1_selected = rank_in_stratum <= n_select_stratum

	gen replacement_rank_stratum = rank_in_stratum - n_select_stratum if !phase1_selected
	gen byte phase1_replacement = inrange(replacement_rank_stratum, 1, n_reserve_stratum)

	* Secondary district-level fallback reserve after stratum-specific reserves
	sort district_id hotspot_p75_district rank_in_stratum village_id
	by district_id: gen district_fallback_rank = sum(!phase1_selected & !phase1_replacement)
	replace district_fallback_rank = . if phase1_selected | phase1_replacement

	* Final mutually exclusive sample role
	gen str18 sample_role = "Not selected"
	replace sample_role = "Primary sample"   if phase1_selected
	replace sample_role = "Replacement"      if phase1_replacement

	label var phase1_selected           "Selected in Phase I primary sample"
	label var phase1_replacement        "Selected in Phase I replacement list"
	label var replacement_rank_stratum  "Replacement priority within district x hotspot stratum"
	label var district_fallback_rank    "Fallback replacement priority within district"
	label var within_subcounty_order    "Order within subcounty for implicit balance"
	label var rank_in_stratum           "Primary randomization order within district x hotspot stratum"
	label var u_village                 "Village-level random draw"
	label var u_subcounty               "Subcounty-level random draw for implicit balancing"
	label var sample_role               "Sampling role in Phase I"	
	
	* Create priority ranks for reporting
	gen selected_order = rank_in_stratum if phase1_selected
	label var selected_order "Selection priority/order within district x hotspot stratum"

	egen total_selected_by_district = total(phase1_selected), by(district_id)
	egen total_repl_by_district     = total(phase1_replacement), by(district_id)

	label var total_selected_by_district "Total selected villages in district"
	label var total_repl_by_district     "Total replacement villages in district"

	order district district_id subcounty subcounty_id parish parish_id village village_id ///
		  number_of_cases hotspot_p75_district ///
		  n_select_district n_select_stratum n_reserve_stratum ///
		  u_subcounty u_village within_subcounty_order rank_in_stratum ///
		  phase1_selected selected_order ///
		  phase1_replacement replacement_rank_stratum district_fallback_rank ///
		  sample_role

	sort district_id hotspot_p75_district rank_in_stratum village_id
		
	save "${input_dir}/2 Working/phase1_sampling_frame_full.dta", ///
		replace

		
	* Save primary sample and replacement datasets
	preserve
		keep if phase1_selected
		sort district_id hotspot_p75_district selected_order village_id
		save "${input_dir}/2 Working/phase1_selected_100.dta", ///
			replace
	restore

	preserve
		keep if phase1_replacement
		sort district_id hotspot_p75_district replacement_rank_stratum village_id
		save "${input_dir}/2 Working/phase1_replacements.dta", ///
			replace
	restore	

	* Export Excel files for documentation
	* Sheet 1: selected villages
	preserve
		keep if phase1_selected
		sort district_id hotspot_p75_district selected_order village_id
		export excel district subcounty parish village number_of_cases hotspot_p75_district ///
			selected_order n_select_district n_select_stratum ///
			using "${input_dir}/3 Coded/Phase1_sampling_randomization.xlsx", sheet("selected_100", replace) firstrow(variables)
	restore

	* Sheet 2: replacement list
	preserve
		keep if phase1_replacement
		sort district_id hotspot_p75_district replacement_rank_stratum village_id
		export excel district subcounty parish village number_of_cases hotspot_p75_district ///
			replacement_rank_stratum district_fallback_rank ///
			using "${input_dir}/3 Coded/Phase1_sampling_randomization.xlsx", sheet("replacement_list", modify) firstrow(variables)
	restore	
	
	* Sheet 3: allocation summary by district x hotspot
	preserve
		collapse (count) n_frame=village_id ///
				 (sum) n_selected=phase1_selected ///
				 (sum) n_replacement=phase1_replacement ///
				 (mean) mean_cases=number_of_cases, ///
				 by(district district_id hotspot_p75_district n_select_district n_select_stratum n_reserve_stratum)
		sort district_id hotspot_p75_district
		export excel using "${input_dir}/3 Coded/Phase1_sampling_randomization.xlsx", sheet("allocation_summary", modify) firstrow(variables)
	restore

	* Sheet 4: district totals
	preserve
		collapse (count) n_frame=village_id ///
				 (sum) n_selected=phase1_selected ///
				 (sum) n_replacement=phase1_replacement ///
				 (sum) n_hotspots=hotspot_p75_district ///
				 (mean) mean_cases=number_of_cases ///
				 (p50) p50_cases=number_of_cases ///
				 (max) max_cases=number_of_cases, by(district district_id)
		sort district_id
		export excel using "${input_dir}/3 Coded/Phase1_sampling_randomization.xlsx", sheet("district_totals", modify) firstrow(variables)
	restore	
		
	
}
	
*---------------------------*
**#		II. Baseline		*
*---------------------------*	
{
	
}
*-----------------------------------*
**#		III. Biscate Admin data		*
*-----------------------------------*
{
	
}
*---------------------------------------*
**#		IV. ComHector Admin data		*
*---------------------------------------*
{
	
}
*-------------------------------------------*
**#		V. Final Dataset for analysis		*
*-------------------------------------------*
	
	
	
	
	
	
	
	
	