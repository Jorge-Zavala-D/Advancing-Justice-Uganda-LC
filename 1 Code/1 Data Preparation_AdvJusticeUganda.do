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
		
	clear all	
	import excel using "${input_dir}\1 Raw\Primary data\Phase 1 Baseline_Runyankore_WIDE.xlsx", sheet("data") firstrow clear
	rename *, lower
	


	* label variables
	label variable key "Unique submission ID"
	cap label variable submissiondate "Date/time submitted"
	cap label variable formdef_version "Form version used on device"
	cap label variable review_status "Review status"
	cap label variable review_comments "Comments made during review"
	cap label variable review_corrections "Corrections made during review"


	label variable enum "Enumerator Name"
	note enum: "Enumerator Name"
	label define enum 1 "Kanyesigye Linnet" 2 "Asiimwe Isaac" 3 "Ashabe Gina" 4 "Atukwase Shallon" 5 "Najib Kizito" 6 "Natuhwera Sylivia" 7 "Kagoro Meliza" 8 "Nayebare Christine" 9 "Akankwasa Ronals" 10 "Natukunda Britah"
	label values enum enum

	label variable consent "Niki rungi kugyenda omu maisho n'okubuuzibwa oku?"
	note consent: "Niki rungi kugyenda omu maisho n'okubuuzibwa oku?"
	label define consent 1 "Yes" 0 "No"
	label values consent consent

	label variable attend_cdfu_training "Orabeireho omu kutendekwa kwona okwakozirwe ekitongore kya Communication for Dev"
	note attend_cdfu_training: "Orabeireho omu kutendekwa kwona okwakozirwe ekitongore kya Communication for Development Foundation Uganda (CDFU) nainga Foundation for Human Rights Initiative (FHRI)?"
	label define attend_cdfu_training 0 "No" 1 "Yes"
	label values attend_cdfu_training attend_cdfu_training

	label variable topics_trained "Okutendekwa okwahwire kukaba nikukwata ahari nshonga ki? Select all that apply."
	note topics_trained: "Okutendekwa okwahwire kukaba nikukwata ahari nshonga ki? Select all that apply."

	label variable other_training "Other Specify other training areas"
	note other_training: "Other Specify other training areas"

	label variable rating_cdfu_training "Aha rurengo rwa 1-5, 1 eri kubarirwa ahansi kandi 5 eri ahaiguru, no renga ota o"
	note rating_cdfu_training: "Aha rurengo rwa 1-5, 1 eri kubarirwa ahansi kandi 5 eri ahaiguru, no renga ota omushoomo ogu twagambaho aheiguru omu kukuha amagezi go omu kukora aha ntongane omu kyaro kyawe?"

	label variable m0_q20 "Observe: Are any LCC records, case books, registers, or proceedings books physic"
	note m0_q20: "Observe: Are any LCC records, case books, registers, or proceedings books physically present or available for consultation during this interview?"
	label define m0_q20 1 "Yes" 0 "No"
	label values m0_q20 m0_q20

	label variable m0_q04 "District"
	note m0_q04: "District"
	label define m0_q04 1 "Bushenyi" 2 "Rubirizi" 3 "Sheema"
	label values m0_q04 m0_q04

	label variable m0_q05 "Sub-county / division"
	note m0_q05: "Sub-county / division"
	label define m0_q05 1 "Kyamuhunga Town" 2 "Kyeizooba" 3 "Kakanju" 4 "Ruhumuro" 5 "Bumbaire" 6 "Nkanga" 7 "Nyabubare" 8 "Kizinda Town Council" 9 "Bitooma" 10 "Nyakabirizi" 11 "Bushenyi central" 12 "Ibaare" 13 "Rwentuha" 14 "Kyamuhunga sub" 15 "Kyabugimbi Sub county" 16 "Kyabugimbi Town Council" 17 "Kyamuhunga Town" 18 "Kyeizooba" 19 "Kakanju" 20 "Bumbaire" 21 "Ishaka Division" 22 "Ruhumuro" 23 "Rwentuha" 24 "Bumbaire" 25 "Nyabubare" 26 "Bushenyi central" 27 "Kizinda Town Council" 28 "Kyamuhunga Town" 29 "Kakanju" 30 "Nyakabirizi" 31 "Bitooma" 32 "Ibaare" 33 "Ishaka Division" 34 "Ruhumuro" 35 "Bumbaire" 36 "Bushenyi central" 37 "Kizinda Town Council" 38 "Kyamuhunga Town" 39 "Kakanju" 40 "Nyakabirizi" 41 "Ibaare" 42 "Kicwamba" 43 "Kirugu" 44 "Katerera Town council" 45 "Ryeru" 46 "Magambo" 47 "Rutoto" 48 "Kyabakara" 49 "Katunguru" 50 "Kicwamba" 51 "Kirugu" 52 "Katerera Town council" 53 "Ryeru" 54 "Magambo" 55 "Katunguru" 56 "Kicwamba" 57 "Rutoto" 58 "Kicwamba" 59 "Katanda" 60 "Katerera Town council" 61 "Kirugu" 62 "Katerera Sub county" 63 "Kyabakara" 64 "Ryeru" 65 "Katunguru" 66 "Rutoto" 67 "Kicwamba" 68 "Katanda" 69 "Katerera Town council" 70 "Kirugu" 71 "Katerera Sub county" 72 "Bugongi" 73 "Masheruka sub county" 74 "Kyangyenyi" 75 "kagango" 76 "Kasana Sub county" 77 "Kabwohe Division" 78 "Bugongi" 79 "Masheruka TC" 80 "Kigarama Sub county" 81 "Kitagata Town counsil" 82 "Bugongi" 83 "Masheruka sub county" 84 "Kyangyenyi" 85 "kagango" 86 "kagango" 87 "Kyangyenyi" 88 "Kigarama Sub county" 89 "Bugongi" 90 "Kasana Sub county" 91 "Kabwohe Division" 92 "Kabwohe Division" 93 "Masheruka TC" 94 "kagango" 95 "Kyangyenyi" 96 "Kigarama Sub county" 97 "Bugongi" 98 "Kasana Sub county" 99 "Kabwohe Division" 100 "Kabwohe Division" 101 "Kakanju" 102 "Kizinda Town Council" 105 "Kyamuhunga" 106 "Kirugu" 107 "Kirugu" 108 "Ryeru" 109 "Kicwamba" 110 "Rubirizi town" 111 "Kirugu" 112 "Masheruka sub county" 117 "Kabwohe Division" 121 "Katerera Town council" 125 "Kyamuhunga sub county"
	label values m0_q05 m0_q05

	label variable m0_q06 "Parish / ward"
	note m0_q06: "Parish / ward"
	label define m0_q06 1 "Butare" 2 "Kararo" 3 "Katunga" 4 "Kyeibingo" 5 "Bumbaire" 6 "Birimbi" 7 "Nyabubare" 8 "Kigoma" 9 "Kimuri" 10 "Ward I" 11 "Kyeitembe" 12 "Kyamugabo" 13 "Rutooma" 14 "Kakoni" 15 "Kitwe" 16 "Kitwe" 17 "Butare" 18 "Nyamiyaga" 19 "Katunga" 20 "Bumbaire" 21 "Ishaka" 22 "Burungira" 23 "Rutooma" 24 "Bumbaire" 25 "Nyabubare" 26 "Central ward" 27 "Kizinda" 28 "Butare" 29 "Katunga" 30 "Kibaare" 31 "Nyanga" 32 "Kyamugabo" 33 "Ishaka" 34 "Bugaana" 35 "Kibaare" 36 "Ward II" 37 "Nyabubare" 38 "Bubare" 39 "Kakanju" 40 "Kibaare" 41 "Kyamugabo" 42 "Rumri" 43 "Kikumbo" 44 "Katerera ward" 45 "Bugaya" 46 "Bugaya" 47 "Rutoto" 48 "Rugarama" 49 "Kashaka" 50 "Katara" 51 "Kikumbo" 52 "Katerera ward" 53 "Bugaya" 54 "Butoha" 55 "Katunguru" 56 "Kicwamba" 57 "Rutoto" 58 "Kicwamba" 59 "kyankaranga" 60 "Nyakagyezi ward" 61 "Kirugu" 62 "katerera" 63 "Rugarama" 64 "Butoha" 65 "Kisenyi" 66 "Rutoto" 67 "Kyambura" 68 "Rwamatumba" 69 "Katerera ward" 70 "Kyenzaza" 71 "katerera" 72 "Kyamurari" 73 "Rugazi" 74 "Kashanjure" 75 "Kagango" 76 "Kasaana Central" 77 "Nyanga" 78 "Kyamurari" 79 "Kanyegayegye" 80 "Kigarama" 81 "Kyarushakara" 82 "Isingiro" 83 "Nyabwina" 84 "Kagongi" 85 "Kagango" 86 "Kagango" 87 "Masyooro" 88 "Kigarama" 89 "Kyamurari" 90 "Kasaana North" 91 "Nyanga" 92 "kabwohe" 93 "Kanyegayegye" 94 "Kagango" 95 "Kagongi" 96 "Byayegamba" 97 "Isingiro" 98 "Karugorora" 99 "Kabwohe" 100 "Nyanga" 101 "Katunga" 102 "Nyabubare" 103 "Nyabubare" 104 "Kizinda ward" 105 "Butaare" 106 "Kikumbo" 107 "Kirugu" 108 "Ndekye" 109 "Kicwamba" 110 "Nyakasharu" 111 "Kirugu" 112 "Nyakambu" 113 "Nyakambu" 114 "Mabare" 115 "Mabare" 116 "Buringo" 117 "Kabwohe" 118 "Rutoma" 119 "Nyanga ward" 120 "Kabwohe" 121 "Katerera" 122 "Katerera" 123 "Katerera" 124 "Katerera" 125 "Nsumi" 126 "Mashonga" 127 "Kibazi" 128 "Mashonga"
	label values m0_q06 m0_q06

	label variable m0_q07 "Village / LCC catchment name"
	note m0_q07: "Village / LCC catchment name"
	label define m0_q07 1 "Nyakahanga" 2 "Kitagata" 3 "Nombe B" 4 "Kansenjesa" 5 "Kisubu" 6 "Kirimbi" 7 "Nyabitote I" 8 "Ryabuganyi" 9 "Kimuri" 10 "Katungu" 11 "Bwatogo" 12 "Kibingo" 13 "Rutooma ward" 14 "Manengo" 15 "Kajunju" 16 "Buhimba A" 17 "Nyampungye" 18 "Nyamiyaga" 19 "Kakuto B" 20 "Kitakuuka" 21 "K.I.U" 22 "Orubingo A" 23 "Rwentuha Town" 24 "Bumbaire II" 25 "Nkuna I" 26 "Nyamiko" 27 "Kangaate" 28 "Nyamalembe" 29 "Bwegyeme A" 30 "Kibaare II" 31 "Kyamamari" 32 "Kyamugabo" 33 "Bassaja" 34 "Nyamyerande I" 35 "Nyabubare B" 36 "Ruhandagazi" 37 "Rushoroza" 38 "Butare ward" 39 "Nyabubare A" 40 "Kibaare I" 41 "Tandara" 42 "Rumuri II" 43 "Omukabare" 44 "Katerera I" 45 "Mubanda" 46 "Busonga II" 47 "Bururuma" 48 "Nyabubare" 49 "Kimanvu I" 50 "Katara I" 51 "Ntunga A" 52 "Katerera II" 53 "Karagara" 54 "Nyangorogo II" 55 "Kyangabukama" 56 "Kyambuzi B" 57 "Omukyeya" 58 "Mutambi IIB" 59 "Mikonabire" 60 "Nyakagyezi I" 61 "Kafuro IB" 62 "Kakindo" 63 "Kagarama" 64 "Nyakiyaza" 65 "Nyamweru" 66 "Rwemitanga" 67 "Kyambura C" 68 "Kisharu I" 69 "Kabaseeka" 70 "Kirugu IB" 71 "Katabengo" 72 "Rwenkurigo" 73 "Kabaare" 74 "Kashanjure" 75 "Kanyina" 76 "Kihanga II" 77 "Kyamatongo" 78 "Kamushasha" 79 "Bugarama" 80 "Kigarama" 81 "Bwoma" 82 "Isingiro" 83 "Nyabwina" 84 "Ryamatshya II" 85 "Kiziba" 86 "Itendero Town" 87 "Masyooro" 88 "Katanoga" 89 "Runyinya II" 90 "Mishenyi" 91 "Rushorooza west" 92 "Ishekye" 93 "Ihanda" 94 "Kihunda" 95 "Ryamatshya" 96 "Nyakasharara" 97 "Kyabuyongo" 98 "Karugorora" 99 "Kabwohe hill" 100 "Mailo IV" 101 "Kakuto A" 102 "Nyakinengo" 103 "Masya" 104 "Kitooma" 105 "Nyambugye" 106 "Omukabare B" 107 "Kirugu 2 B" 108 "Ryeru" 109 "Kyesama" 110 "Kyakabunda" 111 "Mirarikye" 112 "Nyakambu" 113 "Migera" 114 "Rwichumu" 115 "Nyakanoni" 116 "Mukono 1" 117 "Market cell" 118 "Kabwohe A" 119 "Mabaga Cell" 120 "Kabwohe central" 121 "Kikonjo" 122 "KIZIRA CELL" 123 "KACU CELL" 124 "RWENTOSHO I" 125 "NYAMPUGYE" 126 "KYAMABARE" 127 "NYAKAZINGA" 128 "Nyamabare"
	label values m0_q07 m0_q07

	label variable chairperson_name "Chairperson's Name"
	note chairperson_name: "Chairperson's Name"

	label variable tel_number "Chairperson Telephone Number"
	note tel_number: "Chairperson Telephone Number"

	label variable m1_q04 "omazire emyaka engahi omu nteebe ya lc1"
	note m1_q04: "omazire emyaka engahi omu nteebe ya lc1"

	label variable m1_q06 "Ori wa buhangwa ki?"
	note m1_q06: "Ori wa buhangwa ki?"
	label define m1_q06 1 "Male" 2 "Female" 98 "Other / prefer to self-describe" 99 "Prefer not to say"
	label values m1_q06 m1_q06

	label variable m1_q07 "Oine emyaka engahi?"
	note m1_q07: "Oine emyaka engahi?"
	label define m1_q07 1 "18–24 years" 2 "25–34 years" 3 "35–44 years" 4 "45–54 years" 5 "55–64 years" 6 "65 years or older" 99 "Prefer not to say"
	label values m1_q07 m1_q07

	label variable m1_q08 "Oine obwegyese ki obuwakomire ho?"
	note m1_q08: "Oine obwegyese ki obuwakomire ho?"
	label define m1_q08 0 "No formal education" 1 "Some primary" 2 "Completed primary" 3 "Some secondary" 4 "Completed secondary" 5 "Vocational / technical training, other than University" 6 "Tertiary / university" 98 "Other"
	label values m1_q08 m1_q08

	label variable other_education "Specify other Education levels"
	note other_education: "Specify other Education levels"

	label variable m1_q09 "No ye kakaasa ota mu ota (Confident) omu kushoma n'okuhandiika emishango ya koot"
	note m1_q09: "No ye kakaasa ota mu ota (Confident) omu kushoma n'okuhandiika emishango ya kooti ya LC?"
	label define m1_q09 0 "Not comfortable at all" 1 "Slightly comfortable" 2 "Moderately comfortable" 3 "Very comfortable" 4 "Completely comfortable"
	label values m1_q09 m1_q09

	label variable m1_q10 "Ni rurimi ki orwo'kubasa kuhandika ebihandiiko bya LCC. Select all that apply."
	note m1_q10: "Ni rurimi ki orwo'kubasa kuhandika ebihandiiko bya LCC. Select all that apply."

	label variable m1_q10_other "Specify other other language they record court cases"
	note m1_q10_other: "Specify other other language they record court cases"

	label variable m1_q11 "Waratungire ho okutendekwa kwona aha by'oburingaaniza, okushuganisa, Okushare em"
	note m1_q11: "Waratungire ho okutendekwa kwona aha by'oburingaaniza, okushuganisa, Okushare emishango kitaaka, ebiragiro, okukora aha mishango, nari okwohereza emishango omu kooti?"
	label define m1_q11 1 "Yes" 0 "No" 98 "Do not know / cannot remember"
	label values m1_q11 m1_q11

	label variable m1_q13 "Warakozi ho hamwe n'abakozi b'ebiragiro nka pooriisi, kooti, abarikureeberera em"
	note m1_q13: "Warakozi ho hamwe n'abakozi b'ebiragiro nka pooriisi, kooti, abarikureeberera emishango, abarikureeberera abaana, nari abandi abarikukora aha by'oburingaaniza ?"
	label define m1_q13 1 "Yes" 0 "No"
	label values m1_q13 m1_q13

	label variable m1_q14 "Ni nshonga ki aha ziri ahaifo ezi orakozireho nari ezi orakoziremu nk'omwebembez"
	note m1_q14: "Ni nshonga ki aha ziri ahaifo ezi orakozireho nari ezi orakoziremu nk'omwebembezi w'ekyaro kuruga okwezi kw'okubanza 2025 kuhisya hati?"

	label variable m1_q14_specify "specify other cases or disputes"
	note m1_q14_specify: "specify other cases or disputes"

	label variable m1_q14_other "Specify other cases handled since January 2025"
	note m1_q14_other: "Specify other cases handled since January 2025"

	label variable m1_q15 "Omu sande eya buriijo, noomara obwire burikwingana ki aha mirimo ya Local Counci"
	note m1_q15: "Omu sande eya buriijo, noomara obwire burikwingana ki aha mirimo ya Local Council nainga Local Council Court?"
	label define m1_q15 0 "Less than 1 hour" 1 "1–3 hours" 2 "4–7 hours" 3 "8–14 hours" 4 "15 hours or more"
	label values m1_q15 m1_q15

	label variable m2_q01 "Ni abantu bangahi abari memba ba kooti ya Local Council obwahati abarikukora aha"
	note m2_q01: "Ni abantu bangahi abari memba ba kooti ya Local Council obwahati abarikukora aha mishango?"

	label variable m2_q03 "Hariho emyanya etarimu bantu omu kooti ya Local Council nainga akakiiko ka LC?"
	note m2_q03: "Hariho emyanya etarimu bantu omu kooti ya Local Council nainga akakiiko ka LC?"
	label define m2_q03 1 "Yes" 0 "No" 98 "Do not know"
	label values m2_q03 m2_q03

	label variable m2_q04 "Ni emyanya engahi eriho obwahati etarimu bantu?"
	note m2_q04: "Ni emyanya engahi eriho obwahati etarimu bantu?"

	label variable m2_q05 "Ni abakazi bangahi abari ba memba ba kooti y'ekyaro abarikukora aha mishango"
	note m2_q05: "Ni abakazi bangahi abari ba memba ba kooti y'ekyaro abarikukora aha mishango"

	label variable m2_q06 "Ni mirundi engahi ei waashutamiire omu kooti y'ekyaro okukora aha mishango omu k"
	note m2_q06: "Ni mirundi engahi ei waashutamiire omu kooti y'ekyaro okukora aha mishango omu kyaro kyawe omu myezi 12 ehwaire?"

	label variable m2_q07 "Kooti y'ekyaro kyaawe neekunda ku shitama emirundi eingahi okukora aha mishango?"
	note m2_q07: "Kooti y'ekyaro kyaawe neekunda ku shitama emirundi eingahi okukora aha mishango?"
	label define m2_q07 1 "At least once per week" 2 "Two to three times per month" 3 "About once per month" 4 "Less than once per month" 5 "Only when a case arises" 6 "It does not currently meet or sit"
	label values m2_q07 m2_q07

	label variable m2_q08 "Kooti y'ekyaro ku yaba ne kora aha mishango, nekiragiro ngu abantu abarikwetengw"
	note m2_q08: "Kooti y'ekyaro ku yaba ne kora aha mishango, nekiragiro ngu abantu abarikwetengwa (quoram) babebariho?"
	label define m2_q08 1 "Yes, always or almost always" 2 "Yes, sometimes" 3 "Rarely" 4 "Never" 98 "Do not know"
	label values m2_q08 m2_q08

	label variable m2_q09 "Kooti ya LC ya nyu eine omwanya gwayo gwetogwire ogu eri kushariraho emishango?"
	note m2_q09: "Kooti ya LC ya nyu eine omwanya gwayo gwetogwire ogu eri kushariraho emishango?"
	label define m2_q09 1 "Yes, a regular fixed place" 2 "Sometimes, but not always the same place" 3 "No regular place"
	label values m2_q09 m2_q09

	label variable m2_q12 "Kooti ya LC eine ekitabo ekyerikuhandika emishango??"
	note m2_q12: "Kooti ya LC eine ekitabo ekyerikuhandika emishango??"
	label define m2_q12 1 "Yes, formal register/case book exists" 2 "Records are kept, but not in a formal register/case book" 3 "No case records are kept" 98 "Do not know"
	label values m2_q12 m2_q12

	label variable m2_q13 "Ebihandiiko bya LC ebirikukwata aha mishango byagire omukitabo obwahati (up to d"
	note m2_q13: "Ebihandiiko bya LC ebirikukwata aha mishango byagire omukitabo obwahati (up to date)?"
	label define m2_q13 1 "Yes, Our case records are fully up to date" 2 "Our case records are partly up to date" 3 "Our case records are not up to date" 98 "Do not know (Don't read)"
	label values m2_q13 m2_q13

	label variable m2_q14 "Kooti ya LC eine eby'okukoresa ebirikwetengwa kuhurira emishango n'okukora ebiha"
	note m2_q14: "Kooti ya LC eine eby'okukoresa ebirikwetengwa kuhurira emishango n'okukora ebihandiiko?"
	label define m2_q14 1 "Yes, We have enough materials are available for case handleing and record keepin" 2 "Some materials are available, but not enough" 3 "No basic materials are available" 98 "Do not know"
	label values m2_q14 m2_q14

	label variable m2_q15 "Ni bintu ki ebirikuburaho nari ebitarikumara? select all that apply."
	note m2_q15: "Ni bintu ki ebirikuburaho nari ebitarikumara? select all that apply."

	label variable m2_q15_specify "Specify other materials missing or insufficient"
	note m2_q15_specify: "Specify other materials missing or insufficient"

	label variable m2_q16 "Enumerator verification: Did you see a case register, case book, or other writte"
	note m2_q16: "Enumerator verification: Did you see a case register, case book, or other written LCC record during the interview?"
	label define m2_q16 1 "Yes, formal register/case book seen" 2 "Yes, informal written records seen" 0 "No records seen"
	label values m2_q16 m2_q16

	label variable m2_q17 "Enumerator verification: Based on the records seen, do the most recent entries a"
	note m2_q17: "Enumerator verification: Based on the records seen, do the most recent entries appear to be up to date?"
	label define m2_q17 1 "Yes, entries appear up to date" 2 "Partly up to date" 3 "Not up to date" 98 "Cannot determine"
	label values m2_q17 m2_q17

	label variable m2_q18 "Enumerator notes on LCC institutional set-up or records"
	note m2_q18: "Enumerator notes on LCC institutional set-up or records"

	label variable m3_q02 "Omubiro 30 ebihingwire, otungire emishango engahi omu Kooti yaawe?"
	note m3_q02: "Omubiro 30 ebihingwire, otungire emishango engahi omu Kooti yaawe?"

	label variable m3_q03 "Omu myeezi eshatu ehingwire, Kooti y'Ekyaro etungire emishango engahi?"
	note m3_q03: "Omu myeezi eshatu ehingwire, Kooti y'Ekyaro etungire emishango engahi?"

	label variable m3_q04 "Ni miringo ki y'emishango eyi Kooti etungire omu myeezi eshatu ehingwire?select "
	note m3_q04: "Ni miringo ki y'emishango eyi Kooti etungire omu myeezi eshatu ehingwire?select all that apply."

	label variable m3_q05 "Ni muringo ki gw'omushango ogukirizeyo munonga kuhababirwa omu myeezi eshatu ehi"
	note m3_q05: "Ni muringo ki gw'omushango ogukirizeyo munonga kuhababirwa omu myeezi eshatu ehingwire?"
	label define m3_q05 1 "Land or boundary disputes" 2 "Family or marital disputes" 3 "Debt, loan, or money-related disputes" 4 "Neighbor disputes, insults, threats, or verbal conflicts" 5 "Minor assault or physical fight" 6 "Property damage or theft-related matter" 7 "Child-related case" 8 "Sexual violence or gender-based violence case" 9 "Alcohol, disorderly conduct, or public disturbance" 10 "Reintegration or conflict involving a formerly incarcerated person" 98 "Other"
	label values m3_q05 m3_q05

	label variable m3_q06 "Watekateeka aha mishango eyi otungire omu mwezi eshatu ehingwire, emishango emik"
	note m3_q06: "Watekateeka aha mishango eyi otungire omu mwezi eshatu ehingwire, emishango emikye eyi mwakozireho neyingana obuucweeka bungahi ahari igana ?"
	label define m3_q06 0 "None" 1 "Less than one-quarter" 2 "About one-quarter" 3 "About half" 4 "About three-quarters" 5 "Almost all or all cases" 98 "Do not know"
	label values m3_q06 m3_q06

	label variable m3_q08 "Nemishango engahi etakakozirweho omu Kooti yaawe?"
	note m3_q08: "Nemishango engahi etakakozirweho omu Kooti yaawe?"

	label variable m3_q09 "Aha mishango eyi otungire omu myezi eshatu ehingwire, ni emishango engahi eresir"
	note m3_q09: "Aha mishango eyi otungire omu myezi eshatu ehingwire, ni emishango engahi eresirwe abantu ababurijo nari abataine kakwate n'omushango?"

	label variable m3_q14 "Ku orikugyeragyeranisa obwiire obwenyima y'emyeezi eshatu ehingwire na hati, ena"
	note m3_q14: "Ku orikugyeragyeranisa obwiire obwenyima y'emyeezi eshatu ehingwire na hati, enamba y'emishango eresirwe omu Kooti yaawe eyeyongire , ekyendiire , ninga tehindukire ?"
	label define m3_q14 1 "Increased" 2 "Remained the same" 3 "Declined"
	label values m3_q14 m3_q14

	label variable m3_q15 "Notekateeka nikintu ki ekyareetsire enamba y'emishango omu Kooti yaawe kweyongir"
	note m3_q15: "Notekateeka nikintu ki ekyareetsire enamba y'emishango omu Kooti yaawe kweyongira?Select up to three."

	label variable m3_q16 "Notekateeka ni kintu ki ekyareetsire enamba y'emishango omu Kooti yaawe yakyende"
	note m3_q16: "Notekateeka ni kintu ki ekyareetsire enamba y'emishango omu Kooti yaawe yakyendera?Select up to three."

	label variable m3_q17 "Omuri byona, Noyekakasa ota ngu ebiwangambira ebikukwata aha mishango eyibahabah"
	note m3_q17: "Omuri byona, Noyekakasa ota ngu ebiwangambira ebikukwata aha mishango eyibahabahire, gubihikire?"
	label define m3_q17 1 "Not confident" 2 "Slightly confident" 3 "Moderately confident" 4 "Very confident" 5 "Completely confident"
	label values m3_q17 m3_q17

	label variable m3_q18 "Enumerator notes on recent caseload and case mix"
	note m3_q18: "Enumerator notes on recent caseload and case mix"

	label variable m4_q01 "Ni mishango ki eyi kooti ya LC1 eshemerire kukoraho kandi ekagihendera?Select al"
	note m4_q01: "Ni mishango ki eyi kooti ya LC1 eshemerire kukoraho kandi ekagihendera?Select all that apply."

	label variable m4_q02 "Ni mishango ki eyi oshemereire kwohereza omubanyamateka abandi okukira okungekor"
	note m4_q02: "Ni mishango ki eyi oshemereire kwohereza omubanyamateka abandi okukira okungekoreraho omu Kooti y'Ekyaro?Select all that apply."

	label variable m4_q04 "Omushango gwaba guri aheeru y'obushoboorozi bwa Kooti y'Ekyaro, niki eki court y"
	note m4_q04: "Omushango gwaba guri aheeru y'obushoboorozi bwa Kooti y'Ekyaro, niki eki court ya LC eshemerire okukoora? (Read all options)"
	label define m4_q04 1 "Try to resolve it locally to avoid delays" 2 "Refer or direct it to the appropriate authority" 3 "Ignore the case because it is not the LCC's responsibility" 4 "Ask the parties to settle privately without recording anything" 98 "Do not know"
	label values m4_q04 m4_q04

	label variable m4_q05 "Nebiki ebishemerirwe kuhandikwa kooti LC yaba neyakyiira ninga nesharamu emishan"
	note m4_q05: "Nebiki ebishemerirwe kuhandikwa kooti LC yaba neyakyiira ninga nesharamu emishango? Select all that apply."

	label variable m4_q06 "Nimitendera ki Kooti z'ebyaro zishemereire kubanza kukora ki zitakacwiremu omush"
	note m4_q06: "Nimitendera ki Kooti z'ebyaro zishemereire kubanza kukora ki zitakacwiremu omushango?Select all that apply."

	label variable m4_q07 "Nogira ngu niryari obu kooti yakukozesa omuringo ogundi gw'omaririza omushango e"
	note m4_q07: "Nogira ngu niryari obu kooti yakukozesa omuringo ogundi gw'omaririza omushango etagwiherize aha poolisi ninga kooti"
	label define m4_q07 1 "For any case, including serious violence, if the parties agree" 2 "For eligible petty or minor disputes where local resolution is allowed and safe" 3 "Only after police or court have already decided the case" 4 "Never; mediation should not be used by LCCs" 98 "Do not know"
	label values m4_q07 m4_q07

	label variable m4_q08 "Ni mbeera ki eyi Kooti eza baramuzi, Police, hamwe nezindi Kooti neinga abantun "
	note m4_q08: "Ni mbeera ki eyi Kooti eza baramuzi, Police, hamwe nezindi Kooti neinga abantun nka abarashuganisa ebya'maaka, na'baana bashemerire kwejumbira omukucwa emishango? Select all that apply."

	label variable m4_q10 "Oye kakaasa ekikwinganaki omu kumanya gye emishango ei kooti y'ebyaro erikubaasa"
	note m4_q10: "Oye kakaasa ekikwinganaki omu kumanya gye emishango ei kooti y'ebyaro erikubaasa kusharamu hamwe n'emishango ei eshemereire kwoherezibwa omu kooti enkuru?"
	label define m4_q10 0 "Not confident at all" 1 "Slightly confident" 2 "Moderately confident" 3 "Very confident" 4 "Completely confident"
	label values m4_q10 m4_q10

	label variable m4_v01_q1 "Omuri ryo'kureberaho ki, Kooti y'Ekyaro neebaasa kukora aha mushango ogu egumare"
	note m4_v01_q1: "Omuri ryo'kureberaho ki, Kooti y'Ekyaro neebaasa kukora aha mushango ogu egumare kitaka?"
	label define m4_v01_q1 1 "Yes, the LCC can handle or help resolve it locally" 2 "The LCC can take initial steps but should also involve another authority" 3 "No, the LCC should refer immediately and not attempt local handling" 98 "Do not know"
	label values m4_v01_q1 m4_v01_q1

	label variable m4_v01_q2 "Kooti y'Ekyaro eshemereire kubanza kukora ki omuri eki?"
	note m4_v01_q2: "Kooti y'Ekyaro eshemereire kubanza kukora ki omuri eki?"
	label define m4_v01_q2 1 "Record the case, summon or invite both parties, and attempt local mediation/ADR" 2 "Decide immediately in favor of the person who came first" 3 "Refer immediately to police" 4 "Refer immediately to court" 5 "Refer to probation/child protection" 98 "Do not know"
	label values m4_v01_q2 m4_v01_q2

	label variable m4_v01_q3 "Ni bobushoborozi ki abandi abashemereire kubanza kwejumbira ninga kumanyisibwa o"
	note m4_v01_q3: "Ni bobushoborozi ki abandi abashemereire kubanza kwejumbira ninga kumanyisibwa omu mushango ogu?Select all that apply."

	label variable m4_v02_q1 "Omuri kyo kureberaho ki, Kooti y'Ekyaro neebaasa kukora aha mushango ogu egumare"
	note m4_v02_q1: "Omuri kyo kureberaho ki, Kooti y'Ekyaro neebaasa kukora aha mushango ogu egumare kitaka?"
	label define m4_v02_q1 1 "Yes, the LCC can handle or help resolve it locally" 2 "The LCC can take initial steps but should also involve another authority" 3 "No, the LCC should refer immediately and not attempt local handling" 98 "Do not know"
	label values m4_v02_q1 m4_v02_q1

	label variable m4_v02_q2 "Kooti y'Ekyaro eshemereire kubanza kukora ki omuri eki?"
	note m4_v02_q2: "Kooti y'Ekyaro eshemereire kubanza kukora ki omuri eki?"
	label define m4_v02_q2 1 "Record the case, hear both sides, and attempt mediation/ADR if safe and appropri" 2 "Decide immediately based on which spouse is more convincing" 3 "Refer immediately to police" 4 "Refer immediately to court" 5 "Refer to probation/child protection" 98 "Do not know"
	label values m4_v02_q2 m4_v02_q2

	label variable m4_v02_q3 "Ni bobushoborozi ki abandi abashemereire kubanza kwejumbira ninga kumanyisibwa o"
	note m4_v02_q3: "Ni bobushoborozi ki abandi abashemereire kubanza kwejumbira ninga kumanyisibwa omu mushango ogu?Select all that apply."

	label variable m4_v05_q1 "Omuri kyo kureberaho ki, ekyokureberaho Kooti y'Ekyaro neebaasa kukora aha musha"
	note m4_v05_q1: "Omuri kyo kureberaho ki, ekyokureberaho Kooti y'Ekyaro neebaasa kukora aha mushango ogu egumare kitaka?"
	label define m4_v05_q1 1 "Yes, the LCC can resolve it locally without referral" 2 "The LCC can take protective initial steps but should involve the appropriate aut" 3 "No, the LCC should refer immediately and not attempt local resolution" 98 "Do not know"
	label values m4_v05_q1 m4_v05_q1

	label variable m4_v05_q2 "Kooti y'Ekyaro eshemereire kubanza kukora ki omuri eki?"
	note m4_v05_q2: "Kooti y'Ekyaro eshemereire kubanza kukora ki omuri eki?"
	label define m4_v05_q2 1 "Try to reconcile the family privately without recording or referring" 2 "Record the concern, ensure immediate safety, and refer or notify the appropriate" 3 "Wait until the child personally brings the case" 4 "Treat it only as a family disagreement for local mediation" 98 "Do not know"
	label values m4_v05_q2 m4_v05_q2

	label variable m4_v05_q3 "Ni bobushoborozi ki abandi abashemereire kubanza kwejumbira ninga kumanyisibwa o"
	note m4_v05_q3: "Ni bobushoborozi ki abandi abashemereire kubanza kwejumbira ninga kumanyisibwa omu mushango ogu?Select all that apply."

	label variable m4_v06_q1 "Omu ky'okureeberaho eki, kooti ya Local Council neebaasa kukora aha mushango ogu"
	note m4_v06_q1: "Omu ky'okureeberaho eki, kooti ya Local Council neebaasa kukora aha mushango ogu omu kyaro kurabira omu okushunganisa aba babiri?"
	label define m4_v06_q1 1 "Yes, the LCC can resolve it locally through mediation" 2 "The LCC can only provide initial support and should refer immediately to appropr" 3 "No, the LCC should do nothing because it is outside its mandate" 98 "Do not know"
	label values m4_v06_q1 m4_v06_q1

	label variable m4_v06_q2 "Kooti y'Ekyaro eshemereire kubanza kukora ki omuri eki?"
	note m4_v06_q2: "Kooti y'Ekyaro eshemereire kubanza kukora ki omuri eki?"
	label define m4_v06_q2 1 "Mediate between the woman and the alleged perpetrator" 2 "Keep the matter private and ask the families to settle it" 3 "Support the survivor's safety and refer or notify the appropriate police/medical" 4 "Wait until the alleged perpetrator also comes to the LCC" 98 "Do not know"
	label values m4_v06_q2 m4_v06_q2

	label variable m4_v06_q3 "Ni bobushoborozi ki abandi abashemereire kubanza kwejumbira ninga kumanyisibwa o"
	note m4_v06_q3: "Ni bobushoborozi ki abandi abashemereire kubanza kwejumbira ninga kumanyisibwa omu mushango ogu?Select all that apply."

	label variable m4_q11 "Okutwariza hamwe, kyaba kikugumira kita kusharamu eki kooti y'ebyaro eshemereire"
	note m4_q11: "Okutwariza hamwe, kyaba kikugumira kita kusharamu eki kooti y'ebyaro eshemereire kukora omu by'okureeberaho ebi ebinamaara kukushomera?"
	label define m4_q11 1 "Very difficult" 2 "Somewhat difficult" 3 "Neither difficult nor easy" 4 "Somewhat easy" 5 "Very easy"
	label values m4_q11 m4_q11

	label variable m4_q12 "Enumerator notes on mandate, jurisdiction, and classification knowledge"
	note m4_q12: "Enumerator notes on mandate, jurisdiction, and classification knowledge"

	label variable m5_q01 "omushango omukye kubarikugureeta omukooti yaawe , niryari obu kooti erikubanza k"
	note m5_q01: "omushango omukye kubarikugureeta omukooti yaawe , niryari obu kooti erikubanza kushuganisa , kuganira, kugarukanisa ninga kukozesa emiringo endijo gutaka shakiire?"
	label define m5_q01 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 98 "Do not know"
	label values m5_q01 m5_q01

	label variable m5_q02 "Omu kugarukanisa, niryaari obu embaju zoona niziheebwa omugisha gw'okushoborora "
	note m5_q02: "Omu kugarukanisa, niryaari obu embaju zoona niziheebwa omugisha gw'okushoborora enshonga zaabo?"
	label define m5_q02 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 98 "Do not know"
	label values m5_q02 m5_q02

	label variable m5_q03 "Omu kuteisa, niburi ryari obu abantu bakwe gamba ho bataine ekirikubateganisa, b"
	note m5_q03: "Omu kuteisa, niburi ryari obu abantu bakwe gamba ho bataine ekirikubateganisa, barikushoboorora enshonga zaabo?"
	label define m5_q03 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 98 "Do not know"
	label values m5_q03 m5_q03

	label variable m5_q06 "Obu emitendera yo kuramura kyitaka kwekuhika ahamuheru. Niryari obu ebikweikiriz"
	note m5_q06: "Obu emitendera yo kuramura kyitaka kwekuhika ahamuheru. Niryari obu ebikweikirizingana ho mukubihandika omundagano?"
	label define m5_q06 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 97 "No agreements have been reached recently" 98 "Do not know"
	label values m5_q06 m5_q06

	label variable m5_q07 "Bwanyima y'okuhika aha ndagaano, niryari obu LCC ekukuratiriza (follow-up) okure"
	note m5_q07: "Bwanyima y'okuhika aha ndagaano, niryari obu LCC ekukuratiriza (follow-up) okureeba ngu embaju zahikiriza ebyaragainwe omu endagaano?"
	label define m5_q07 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 97 "No agreements have been reached recently" 98 "Do not know"
	label values m5_q07 m5_q07

	label variable m5_q09 "Noyekakasa ota omu kushoborora entongane ezishemerire oba ezirimumateeka kushobo"
	note m5_q09: "Noyekakasa ota omu kushoborora entongane ezishemerire oba ezirimumateeka kushobororwa omu kooti ey ekyaaro?"
	label define m5_q09 0 "Not confident at all" 1 "Slightly confident" 2 "Moderately confident" 3 "Very confident" 4 "Completely confident"
	label values m5_q09 m5_q09

	label variable m5_q10 "Noyekakasa ota omu kucureeza nari okukyendeeza obutaikirizana ahagati y'abantu e"
	note m5_q10: "Noyekakasa ota omu kucureeza nari okukyendeeza obutaikirizana ahagati y'abantu entongane zabo zitabeire mbi munonga?"
	label define m5_q10 0 "Not confident at all" 1 "Slightly confident" 2 "Moderately confident" 3 "Very confident" 4 "Completely confident"
	label values m5_q10 m5_q10

	label variable m5_q11 "Ni bintu ki ebirikuremesa okugarukanisa abantu kitaaka omu kooti z'ebyaro? Selec"
	note m5_q11: "Ni bintu ki ebirikuremesa okugarukanisa abantu kitaaka omu kooti z'ebyaro? Select up to three. ."

	label variable m5_q13 "Ni miringo ki ei LCC erikukozesa omu kushoborora obutaikirizana obutari bwa maan"
	note m5_q13: "Ni miringo ki ei LCC erikukozesa omu kushoborora obutaikirizana obutari bwa maani?Select all that apply"

	label variable m5_q14 "Kooti yekyaro kwekwihika endagano omumishonga etari mihango munonga, Niryari obu"
	note m5_q14: "Kooti yekyaro kwekwihika endagano omumishonga etari mihango munonga, Niryari obu abantu bari omumishango egyo, bakugendera aha ndangano ya Kooti egi."
	label define m5_q14 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 97 "No mediated agreements have been reached recently" 98 "Do not know"
	label values m5_q14 m5_q14

	label variable m5_q15 "Omuntu omwe ku arikuremwa kukuratira endagaano, kooti ya LCC nekiira kukora ki?"
	note m5_q15: "Omuntu omwe ku arikuremwa kukuratira endagaano, kooti ya LCC nekiira kukora ki?"
	label define m5_q15 1 "Follow up with the parties and try to resolve the non-compliance" 2 "Record the non-compliance and consider referral if appropriate" 3 "Ignore the matter because the LCC already mediated" 4 "Punish the non-complying party directly without further process" 5 "Immediately refer every case of non-compliance to police" 97 "This has not happened recently" 98 "Do not know"
	label values m5_q15 m5_q15

	label variable m5_q16 "Omu kuteekateeka kwawe, kooti ya LCC nikihwera kita okuzibira entongane z'omunda"
	note m5_q16: "Omu kuteekateeka kwawe, kooti ya LCC nikihwera kita okuzibira entongane z'omunda kweyongyera kuhika aha pooriisi nainga omu kooti?"
	label define m5_q16 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 98 "Do not know"
	label values m5_q16 m5_q16

	label variable m5_q17 "Enumerator notes on ADR and mediation practice"
	note m5_q17: "Enumerator notes on ADR and mediation practice"

	label variable m6_q01 "Omushango gwaba guri muhango aha kooti ya LC nainga guri ogw'amaani munonga, nir"
	note m6_q01: "Omushango gwaba guri muhango aha kooti ya LC nainga guri ogw'amaani munonga, niryari obu LCC ekuha ab'obushoborozi abahikire omushango?"
	label define m6_q01 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 97 "No such cases have been received recently" 98 "Do not know"
	label values m6_q01 m6_q01

	label variable m3_q10 "Aha mishango eyatungirwe omu myezi eshatu ehwaire, ni engahi eyahairweyo omu koo"
	note m3_q10: "Aha mishango eyatungirwe omu myezi eshatu ehwaire, ni engahi eyahairweyo omu kooti z'ebyaro, ab'eby'okwerinda, kooti, ab'ebyaro abandi, abebembezi b'ebyanga, nainga ebitongore ebindi?"

	label variable m3_q11 "Ni muntu ki owahaireyo emishango omu kitongore eki omu myezi eshatu ehwaire? Too"
	note m3_q11: "Ni muntu ki owahaireyo emishango omu kitongore eki omu myezi eshatu ehwaire? Toorana ebyo byona ebirikukwataho."

	label variable m3_q12 "Aha mishango eyatungirwe omu myezi eshatu ehwaire, ni engahi eyahereize pooriisi"
	note m3_q12: "Aha mishango eyatungirwe omu myezi eshatu ehwaire, ni engahi eyahereize pooriisi, kooti, okurabura, okurinda abaana, nainga ekitongore ekindi?"

	label variable m3_q13 "Ekitongore kya LCC kikatwara nkahi emishango omu myezi eshatu ehwaire? Toorana e"
	note m3_q13: "Ekitongore kya LCC kikatwara nkahi emishango omu myezi eshatu ehwaire? Toorana ebyo byona ebirikukwataho."

	label variable m6_q04 "Ni nshonga ki enkuru ezareesire okwohereza emishango egi omubanyamateeka neinga "
	note m6_q04: "Ni nshonga ki enkuru ezareesire okwohereza emishango egi omubanyamateeka neinga obobushoborozi abandi omu myezi eshatu ehwaire? Toorana zoona ezirikukora"

	label variable m6_q05 "LC yaawe ku erikuheereza omushango omu kitongore ekindi, niryari obu okwoherezib"
	note m6_q05: "LC yaawe ku erikuheereza omushango omu kitongore ekindi, niryari obu okwoherezibwa oku kuri kuhandikwa omubitabo rya LC yaawe?"
	label define m6_q05 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 98 "Do not know"
	label values m6_q05 m6_q05

	label variable m6_q08 "Bwanyima y'okuhayo emishango owa banyamateeka nainga abobushoborozi abandi aba h"
	note m6_q08: "Bwanyima y'okuhayo emishango owa banyamateeka nainga abobushoborozi abandi aba heiguru, naryari obwo kukira kutunga okugarukwamui?"
	label define m6_q08 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 98 "Do not know"
	label values m6_q08 m6_q08

	label variable m6_q09 "Okutwariza hamwe, kyanguhi nari kigumire ekitongore kya LCC kukwatanisa na poori"
	note m6_q09: "Okutwariza hamwe, kyanguhi nari kigumire ekitongore kya LCC kukwatanisa na pooriisi omushango gwaba nigwetenga pooriisi okugwejumbira mu?"
	label define m6_q09 1 "Very difficult" 2 "Somewhat difficult" 3 "Neither easy nor difficult" 4 "Somewhat easy" 5 "Very easy" 97 "LCC has not needed to coordinate with police recently" 98 "Do not know"
	label values m6_q09 m6_q09

	label variable m6_q10 "Okutwarira hamwe, kyanguhi nari kigumire ekitongore kya LCC kukwatanisa na kooti"
	note m6_q10: "Okutwarira hamwe, kyanguhi nari kigumire ekitongore kya LCC kukwatanisa na kooti ezaheiguru omushango gwaba nigwetenga okwejumbiramu kwa kooti ezo?"
	label define m6_q10 1 "Very difficult" 2 "Somewhat difficult" 3 "Neither easy nor difficult" 4 "Somewhat easy" 5 "Very easy" 97 "LCC has not needed to coordinate with courts recently" 98 "Do not know"
	label values m6_q10 m6_q10

	label variable m6_q12 "Ni bizibuki eiwe owa LCC ebyorikubugana waba noyohereza emishango omu kooti nein"
	note m6_q12: "Ni bizibuki eiwe owa LCC ebyorikubugana waba noyohereza emishango omu kooti neinga abobushoborozi abaheiguru aha mishango oyo takubasa kukoraho aha kooti ya LC"

	label variable m6_q14 "Noyekakasa ota omukumanya nkahi ohoine kwohereza emishango eya mateeka gatakwiki"
	note m6_q14: "Noyekakasa ota omukumanya nkahi ohoine kwohereza emishango eya mateeka gatakwikiriza kushagwo aha rurengo rya kooti yaawe?"
	label define m6_q14 0 "Not confident at all" 1 "Slightly confident" 2 "Moderately confident" 3 "Very confident" 4 "Completely confident"
	label values m6_q14 m6_q14

	label variable m6_q15 "Nowekaakasa ota omumagezi no'kumanya o kushoboororera abantu ahabwenki emishango"
	note m6_q15: "Nowekaakasa ota omumagezi no'kumanya o kushoboororera abantu ahabwenki emishango emwe eshemereire kutwarwa omu kooti ezindi omu mwanya gw'okugikorera omu kooti kyaro kyaawe?"
	label define m6_q15 0 "Not confident at all" 1 "Slightly confident" 2 "Moderately confident" 3 "Very confident" 4 "Completely confident"
	label values m6_q15 m6_q15

	label variable m6_q16 "Enumerator verification: In the records seen today, is there any written evidenc"
	note m6_q16: "Enumerator verification: In the records seen today, is there any written evidence that referred cases are recorded as referrals?"
	label define m6_q16 1 "Yes, referrals are clearly recorded" 2 "Some referrals appear to be recorded, but not clearly or consistently" 3 "Records were seen, but no referral information was visible" 4 "Records were seen, but there were no referred cases in the visible records" 98 "Cannot determine"
	label values m6_q16 m6_q16

	label variable m6_q17 "Enumerator verification: In the records seen today, is the destination of referr"
	note m6_q17: "Enumerator verification: In the records seen today, is the destination of referral usually recorded?"
	label define m6_q17 1 "Yes, referral destination is usually recorded" 2 "Sometimes recorded" 3 "Not recorded" 4 "No referred cases visible in records" 98 "Cannot determine"
	label values m6_q17 m6_q17

	label variable m6_q18 "Enumerator notes on referral practice and coordination"
	note m6_q18: "Enumerator notes on referral practice and coordination"

	label variable m7_q01 "Kooti ya LC eriho obwahati eine ekitabo ky'okuhandikamu emishango?"
	note m7_q01: "Kooti ya LC eriho obwahati eine ekitabo ky'okuhandikamu emishango?"
	label define m7_q01 1 "Yes, formal case register/case book" 2 "Yes, informal notebook or written list" 3 "No written case register or case book"
	label values m7_q01 m7_q01

	label variable m7_q03 "Ni bihandiiko ki ebyahandikirwe ebi LCC erikubiika? Toorana byona ebirikukwataho"
	note m7_q03: "Ni bihandiiko ki ebyahandikirwe ebi LCC erikubiika? Toorana byona ebirikukwataho."

	label variable m7_q04 "Ebihandiiko bya LCC obwahati bihikire?"
	note m7_q04: "Ebihandiiko bya LCC obwahati bihikire?"
	label define m7_q04 1 "Yes, fully up to date" 2 "Partly up to date" 3 "Not up to date" 98 "Do not know"
	label values m7_q04 m7_q04

	label variable m7_q05 "Omushango ogwahererukireyo kutaaha omu bihandiiko bya LCC gukataahamu ryari?"
	note m7_q05: "Omushango ogwahererukireyo kutaaha omu bihandiiko bya LCC gukataahamu ryari?"
	label define m7_q05 1 "Within the last 7 days" 2 "Within the last 30 days" 3 "Within the last 3 months" 4 "More than 3 months ago" 5 "No case has ever been entered" 98 "Do not know / cannot verify"
	label values m7_q05 m7_q05

	label variable m7_q06 "Omushango ku gurikuhandiikwa, ni makuru ki agarikukira kuba garimu? Toorana goon"
	note m7_q06: "Omushango ku gurikuhandiikwa, ni makuru ki agarikukira kuba garimu? Toorana goona agarikukora."

	label variable m7_q08 "Ebirugire omu kusharamu, nari okukirizana nibihandiikwa buri ryari?"
	note m7_q08: "Ebirugire omu kusharamu, nari okukirizana nibihandiikwa buri ryari?"
	label define m7_q08 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 98 "Do not know"
	label values m7_q08 m7_q08

	label variable m7_q12 "Omuntu ku yaakushaba ebikukwata aha mushango gu washazire omu myezi eshatu ehwai"
	note m7_q12: "Omuntu ku yaakushaba ebikukwata aha mushango gu washazire omu myezi eshatu ehwaire, kyanguhi kita gufuuna kuruga omu bihandiiko byawe?"
	label define m7_q12 1 "Very difficult" 2 "Somewhat difficult" 3 "Neither easy nor difficult" 4 "Somewhat easy" 5 "Very easy" 98 "Do not know"
	label values m7_q12 m7_q12

	label variable m7_q13 "Ebihandiiko by'amishango ya Kooti yaawe nibibiikwa omu mwanya ogurinzirwe gye ku"
	note m7_q13: "Ebihandiiko by'amishango ya Kooti yaawe nibibiikwa omu mwanya ogurinzirwe gye kugira ngu bitabura, bitasiisikara, kandi bitahikwaho abantu abatashemereire?"
	label define m7_q13 1 "Yes, secure storage" 2 "Partly secure" 3 "Not secure" 98 "Do not know"
	label values m7_q13 m7_q13

	label variable m7_q14 "N'oha orikubaasa kuhikwaho aha bihandiiko by'omushango gwa LCC? Select all that "
	note m7_q14: "N'oha orikubaasa kuhikwaho aha bihandiiko by'omushango gwa LCC? Select all that apply."

	label variable m7_q15 "Ni buremeezi ki oburikukirayo obuhango obu kooti yaawe erikushanga omu kubika eb"
	note m7_q15: "Ni buremeezi ki oburikukirayo obuhango obu kooti yaawe erikushanga omu kubika ebihandiko bya kooti ebihweire nka bikikire? Select all that apply"

	label variable m7_v01 "Enumerator verification: Did you see a case register or case book?"
	note m7_v01: "Enumerator verification: Did you see a case register or case book?"
	label define m7_v01 1 "Yes, formal case register/case book seen" 2 "Yes, informal case notebook/list seen" 0 "No case register/case book seen"
	label values m7_v01 m7_v01

	label variable m7_v02 "Enumerator verification: Did you see a proceedings book or hearing/mediation not"
	note m7_v02: "Enumerator verification: Did you see a proceedings book or hearing/mediation notes?"
	label define m7_v02 1 "Yes, formal proceedings book seen" 2 "Yes, informal hearing/mediation notes seen" 0 "No proceedings book or hearing notes seen"
	label values m7_v02 m7_v02

	label variable m7_v12 "Enumerator verification: Where were the records stored at the time of the interv"
	note m7_v12: "Enumerator verification: Where were the records stored at the time of the interview?"
	label define m7_v12 1 "Locked cabinet, box, or room" 2 "Unlocked but protected location" 3 "Open/public location" 4 "With one LC/LCC member personally" 5 "Records were present but storage location unclear" 98 "Other"
	label values m7_v12 m7_v12

	label variable m7_v13 "Enumerator verification: Overall, how complete and usable did the available LCC "
	note m7_v13: "Enumerator verification: Overall, how complete and usable did the available LCC records appear for monitoring case flow?"
	label define m7_v13 1 "Very poor: not usable" 2 "Poor: limited usability" 3 "Moderate: usable with important limitations" 4 "Good: mostly usable" 5 "Very good: complete and easy to use" 98 "Cannot determine"
	label values m7_v13 m7_v13

	label variable m7_v14 "Enumerator verification: Why could records not be verified during this interview"
	note m7_v14: "Enumerator verification: Why could records not be verified during this interview?"
	label define m7_v14 1 "Records exist but were not physically present" 2 "Records are kept by another person who was absent" 3 "Records are locked or inaccessible" 4 "Respondent reports that no records exist" 5 "Respondent refused record verification" 98 "Other reason"
	label values m7_v14 m7_v14

	label variable m7_q16 "Enumerator notes on record-keeping and case management quality"
	note m7_q16: "Enumerator notes on record-keeping and case management quality"

	label variable m8_q01 "Kooti y'ekyaro kyanyu neshaara eta emishango obutosha?"
	note m8_q01: "Kooti y'ekyaro kyanyu neshaara eta emishango obutosha?"
	label define m8_q01 1 "By the full committee or most members together" 2 "By a smaller group of committee members" 3 "Mostly by the chairperson alone"
	label values m8_q01 m8_q01

	label variable m8_q03 "Omu kuhanuura aha mishango, niryari obu abanyakakiiko abataribamwe na bamwe baku"
	note m8_q03: "Omu kuhanuura aha mishango, niryari obu abanyakakiiko abataribamwe na bamwe bakuherezayo ebitekateko byaabo okira oku rekyera okuteisa obantu bamwe?"
	label define m8_q03 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 98 "Do not know"
	label values m8_q03 m8_q03

	label variable m8_q04 "Batakatungire encwamu, okwikirizana, nainga okwohereza omushango omu kooti, niry"
	note m8_q04: "Batakatungire encwamu, okwikirizana, nainga okwohereza omushango omu kooti, niryari obu akakiiko kakugamba aha mishango haamwe nka ka kiiko?"
	label define m8_q04 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 98 "Do not know"
	label values m8_q04 m8_q04

	label variable m8_q06 "Abakazi ku barikuba bari abanyakakiiko, ryari obu bakweejumbira omu kugaaniira n"
	note m8_q06: "Abakazi ku barikuba bari abanyakakiiko, ryari obu bakweejumbira omu kugaaniira n'okusharamu emishango?"
	label define m8_q06 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 97 "No women currently serve on the LCC/committee" 98 "Do not know"
	label values m8_q06 m8_q06

	label variable m8_q07 "Hariho enkora yona neinga enteekateeka y'okureeba ngu ebitekyerezo ne nshonga za"
	note m8_q07: "Hariho enkora yona neinga enteekateeka y'okureeba ngu ebitekyerezo ne nshonga zabakazi ba ka kiiko omuku kushara emishango bya tekwa omunkoora?"
	label define m8_q07 1 "Yes, through women LC representatives or other local women leaders" 2 "Yes, through consultation with affected women or parties" 3 "Yes, through another mechanism" 4 "No mechanism" 98 "Do not know"
	label values m8_q07 m8_q07

	label variable m8_q08 "Omushango ku gurikushwarwa, kwogyegwa yo omu kooti ezindi, niryari obu ebihandii"
	note m8_q08: "Omushango ku gurikushwarwa, kwogyegwa yo omu kooti ezindi, niryari obu ebihandiiko bikuteerwaho omukono, sitampu, nari nibikahamibwa abanyakakiiko ba LCC abarikurenga ahari omwe?"
	label define m8_q08 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 97 "Records are not signed or validated at all" 98 "Do not know"
	label values m8_q08 m8_q08

	label variable m8_q09 "Aka kiiko ka court ya LC nikashitama okushwijuma emishango etakahweire, etakasha"
	note m8_q09: "Aka kiiko ka court ya LC nikashitama okushwijuma emishango etakahweire, etakashazigwe mu, neinga eyayongirwe yo omu kooti ezindi?"
	label define m8_q09 1 "Yes, regularly" 2 "Yes, sometimes" 3 "Rarely" 4 "Never" 98 "Do not know"
	label values m8_q09 m8_q09

	label variable m8_q11 "Ba memba b'akakiiko ku barikuhakana aha ku bashemereire kukora aha mushango, eki"
	note m8_q11: "Ba memba b'akakiiko ku barikuhakana aha ku bashemereire kukora aha mushango, ekirikukira kubaho n'enki?"
	label define m8_q11 1 "Members discuss until they reach agreement" 2 "The chairperson or one senior member decides" 3 "The case is postponed for further discussion" 4 "The case is referred to another authority" 5 "Disagreements rarely or never happen" 98 "Do not know"
	label values m8_q11 m8_q11

	label variable m8_q12 "Nenkyuro zingahi ezi ab'akakiiko barikuhakana yaaba omushango gushemereire kusha"
	note m8_q12: "Nenkyuro zingahi ezi ab'akakiiko barikuhakana yaaba omushango gushemereire kushagwa mu kooti egi yekyaaro nainga gusindikwe omu b'obushoborozi abandi?"
	label define m8_q12 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 98 "Do not know"
	label values m8_q12 m8_q12

	label variable m8_q13 "Okusharaho kwa LCC nikuhikaana kuta omu mishango erikushushana?"
	note m8_q13: "Okusharaho kwa LCC nikuhikaana kuta omu mishango erikushushana?"
	label define m8_q13 1 "Not consistent at all" 2 "Slightly consistent" 3 "Moderately consistent" 4 "Very consistent" 5 "Completely consistent" 98 "Do not know"
	label values m8_q13 m8_q13

	label variable m8_q14 "Noye kakaasa ota ngu kooti ya LC egi nikikuratira engyenderwaho niyo emwe omu ku"
	note m8_q14: "Noye kakaasa ota ngu kooti ya LC egi nikikuratira engyenderwaho niyo emwe omu kukora aha mishango ekushushwana?"
	label define m8_q14 0 "Not confident at all" 1 "Slightly confident" 2 "Moderately confident" 3 "Very confident" 4 "Completely confident"
	label values m8_q14 m8_q14

	label variable m8_q15 "Ni buremeezi ki oburikukirayo obwingi oburi kuremesa akakiiko ka court yekyaro k"
	note m8_q15: "Ni buremeezi ki oburikukirayo obwingi oburi kuremesa akakiiko ka court yekyaro kyaawe okukoora emirimo ya ko?"

	label variable m8_v01 "Enumerator verification: In the records seen today, is there evidence that more "
	note m8_v01: "Enumerator verification: In the records seen today, is there evidence that more than one LCC member participates in hearings, mediation, decisions, or referrals?"
	label define m8_v01 1 "Yes, clearly shown in records" 2 "Some evidence, but not consistent" 3 "No evidence visible" 4 "Records seen, but no relevant cases/entries available" 98 "Cannot determine"
	label values m8_v01 m8_v01

	label variable m8_v02 "Enumerator verification: In the records seen today, is there evidence that decis"
	note m8_v02: "Enumerator verification: In the records seen today, is there evidence that decisions, agreements, or referrals are signed or validated by more than one member?"
	label define m8_v02 1 "Yes, clearly shown in records" 2 "Some evidence, but not consistent" 3 "No evidence visible" 4 "Records seen, but no decisions/agreements/referrals available" 98 "Cannot determine"
	label values m8_v02 m8_v02

	label variable m8_q16 "Enumerator notes on committee sitting and decision-making process"
	note m8_q16: "Enumerator notes on committee sitting and decision-making process"

	label variable m9_q12 "Omu nteekateka yaawe, abantu b'omukyaaro kyaawe nibateekateeka ngu kooti z'ebyar"
	note m9_q12: "Omu nteekateka yaawe, abantu b'omukyaaro kyaawe nibateekateeka ngu kooti z'ebyaro zeine oburinganiza omu kushoboorora entongane zitari zimwe na zimwe?"
	label define m9_q12 1 "Not fair at all" 2 "Slightly fair" 3 "Moderately fair" 4 "Very fair" 5 "Completely fair" 98 "Do not know"
	label values m9_q12 m9_q12

	label variable m9_q14 "Omu kuteekateeka kwawe, abantu b'omukyaaro kyaawe ni bejumbira okureeta emishang"
	note m9_q14: "Omu kuteekateeka kwawe, abantu b'omukyaaro kyaawe ni bejumbira okureeta emishango emikye omu kooti ya LC omumwanya goku gitwaara aha police nainga omu kooti za heiguru?"
	label define m9_q14 1 "Not willing at all" 2 "Slightly willing" 3 "Moderately willing" 4 "Very willing" 5 "Completely willing" 98 "Do not know"
	label values m9_q14 m9_q14

	label variable m9_q15 "Omu kuteekateeka kwawe, abantu nibakira kuhingura bata akakiiko k'eby'obutegyeki"
	note m9_q15: "Omu kuteekateeka kwawe, abantu nibakira kuhingura bata akakiiko k'eby'obutegyeki bakaza omu pooriisi nari omu kooti omu mwanya gw'okugyenda omu kooti z'ebyaro?"
	label define m9_q15 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Often" 4 "Always or almost always" 98 "Do not know"
	label values m9_q15 m9_q15

	label variable m9_q16 "Ni nshonga ki enkuru ahabw'enki abantu abamwe barikubaasa kuhingura aho okukores"
	note m9_q16: "Ni nshonga ki enkuru ahabw'enki abantu abamwe barikubaasa kuhingura aho okukoresa kooti y ekyaaro bakaza omu pooriisi nainga omu kooti omu mwanya gw'okukoresa kooti y ekyaaro? Select up to three."

	label variable m9_q17 "Omu kuteekateeka kwawe, okumanyangana kwa'bantu, okushoroora, ebiconco, esente, "
	note m9_q17: "Omu kuteekateeka kwawe, okumanyangana kwa'bantu, okushoroora, ebiconco, esente, nainga okugyemeserezibwa nibibaasa kureeta ho akaabi aha obwenganiza aha kukoora aha mishango omu kooti ye'kyaaro?"
	label define m9_q17 1 "No inffluence atall" 2 "Small extent" 3 "Moderate extent" 4 "High extent" 5 "Very highextent" 98 "Do not know"
	label values m9_q17 m9_q17

	label variable m9_q18 "Oine obukakafu bukwingana ki ngu kooti y'ekyaaro eiine obwesigye bw'abantu okush"
	note m9_q18: "Oine obukakafu bukwingana ki ngu kooti y'ekyaaro eiine obwesigye bw'abantu okushara emishango na n'okwohereza emishango emihango omu kooti za heiguru omubwenganiza?"
	label define m9_q18 0 "Not confident at all" 1 "Slightly confident" 2 "Moderately confident" 3 "Very confident" 4 "Completely confident"
	label values m9_q18 m9_q18

	label variable m9_q19 "Okutwariza hamwe, noyekakasa ota ngu kooti yekyaaro neshaara emishango muburinga"
	note m9_q19: "Okutwariza hamwe, noyekakasa ota ngu kooti yekyaaro neshaara emishango muburingaaniza na nomuringo oguri kugihereza ekitiinisa?"
	label define m9_q19 0 "Not confident at all" 1 "Slightly confident" 2 "Moderately confident" 3 "Very confident" 4 "Completely confident"
	label values m9_q19 m9_q19

	label variable m9_q20 "Enumerator notes on procedural fairness and perceived local legitimacy"
	note m9_q20: "Enumerator notes on procedural fairness and perceived local legitimacy"

	label variable m10_q07 "Omu kuteekateeka kwawe, emishango erimu abaana, abahonokireho obutabanguko, abai"
	note m10_q07: "Omu kuteekateeka kwawe, emishango erimu abaana, abahonokireho obutabanguko, abaine oburema, nari abandi abatarikwebaasa, neeyetenga okukorwaho omu muringo gw'omutaano omu kooti ya LC?"
	label define m10_q07 1 "Yes" 0 "No" 98 "Do not know"
	label values m10_q07 m10_q07

	label variable m10_q08 "Ni bujanjabi ki obw'omutaano oburikubaasa kwetengwa ahabw'emishango egi? Toorana"
	note m10_q08: "Ni bujanjabi ki obw'omutaano oburikubaasa kwetengwa ahabw'emishango egi? Toorana ebyo byona ebirikukora."

	label variable m10_v01 "Enumerator verification: In the records seen today, is there evidence that sensi"
	note m10_v01: "Enumerator verification: In the records seen today, is there evidence that sensitive or serious cases are marked as referred or directed to another authority when applicable?"
	label define m10_v01 1 "Yes, clearly shown in records" 2 "Some evidence, but not clear or consistent" 3 "No evidence visible" 4 "No sensitive or serious cases visible in records reviewed" 98 "Cannot determine"
	label values m10_v01 m10_v01

	label variable m10_v02 "Enumerator verification: Based on the records seen today, do sensitive case reco"
	note m10_v02: "Enumerator verification: Based on the records seen today, do sensitive case records appear to be stored or written in a way that protects confidentiality?"
	label define m10_v02 1 "Yes, confidentiality appears protected" 2 "Partly protected" 3 "Not protected" 4 "No sensitive case records visible" 98 "Cannot determine"
	label values m10_v02 m10_v02

	label variable m10_q15 "Enumerator notes on gender, child protection, and serious-case safeguards"
	note m10_q15: "Enumerator notes on gender, child protection, and serious-case safeguards"

	label variable m11_q02 "Ni kikuru kita abebembezi b'ebyanga, otwariiremu n'abebembezi ba LC, okushagika "
	note m11_q02: "Ni kikuru kita abebembezi b'ebyanga, otwariiremu n'abebembezi ba LC, okushagika okugaruka omu byaro kw'abantu abarikuruga omu bihome?"
	label define m11_q02 0 "Not important at all" 1 "Slightly important" 2 "Moderately important" 3 "Very important" 4 "Essential"
	label values m11_q02 m11_q02

	label variable m11_q03 "Iwe nka chairpersons wa LC egi, nohangira ekyo muntu owaabaire ari omu kihome ok"
	note m11_q03: "Iwe nka chairpersons wa LC egi, nohangira ekyo muntu owaabaire ari omu kihome okugaruka omu kyaaro eki omubusingye?"
	label define m11_q03 0 "Not willing at all" 1 "Slightly willing" 2 "Moderately willing" 3 "Very willing" 4 "Completely willing"
	label values m11_q03 m11_q03

	label variable m11_q04 "Naba ninkushaba ngu ongambire waba noyikiriza ninga ori kuhakanisa ekihandiiko e"
	note m11_q04: "Naba ninkushaba ngu ongambire waba noyikiriza ninga ori kuhakanisa ekihandiiko eki: Abantu abarikurekurwa kuruga omu bihome bashemereire kuheebwa omugisha gw'okugaruka kwejumba omu by'obuhangwa?"
	label define m11_q04 1 "Strongly disagree" 2 "Disagree" 3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree" 98 "Do not know"
	label values m11_q04 m11_q04

	label variable m11_q05 "Naba ninkushaba ngu ongambire waba noyikiriza ninga ori kuhakanisa ekihandiiko e"
	note m11_q05: "Naba ninkushaba ngu ongambire waba noyikiriza ninga ori kuhakanisa ekihandiiko eki: Abantu abarikurekurwa kuruga omu bihome bashemereire kwetantarwa abantu b'omukyanga?"
	label define m11_q05 1 "Strongly disagree" 2 "Disagree" 3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree" 98 "Do not know"
	label values m11_q05 m11_q05

	label variable m11_q06 "Naba ninkushaba ngu ongambire waba noyikiriza ninga ori kuhakanisa ekihandiiko e"
	note m11_q06: "Naba ninkushaba ngu ongambire waba noyikiriza ninga ori kuhakanisa ekihandiiko eki: Abantu abarikukiira obwingi abarikurekurwa kuruga omu bihome nibaza kugaruka bakore ebihagaro ebindi?"
	label define m11_q06 1 "Strongly disagree" 2 "Disagree" 3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree" 98 "Do not know"
	label values m11_q06 m11_q06

	label variable m11_q07 "Naba ninkushaba ngu ongambire waba noyikiriza ninga ori kuhakanisa ekihandiiko e"
	note m11_q07: "Naba ninkushaba ngu ongambire waba noyikiriza ninga ori kuhakanisa ekihandiiko eki: Abantu baine obuvunanizibwa kuhwera abo abarikuruga omu bihome okwetantara okugaruka okugaruka kukora ebihagaro.'"
	label define m11_q07 1 "Strongly disagree" 2 "Disagree" 3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree" 98 "Do not know"
	label values m11_q07 m11_q07

	label variable m11_q08 "Noye kaakaza ota okushara omushango gurimu owabaire ari omusibe hamwe n'omuntu o"
	note m11_q08: "Noye kaakaza ota okushara omushango gurimu owabaire ari omusibe hamwe n'omuntu ondiijo wa burijo omu LC yaawe?"
	label define m11_q08 0 "Not comfortable at all" 1 "Slightly comfortable" 2 "Moderately comfortable" 3 "Very comfortable" 4 "Completely comfortable" 98 "Do not know"
	label values m11_q08 m11_q08

	label variable m11_q09 "Noobaasa kuhwera omuntu owaabaire ari omu kihome kuhikaana n'abantu abandi, obuh"
	note m11_q09: "Noobaasa kuhwera omuntu owaabaire ari omu kihome kuhikaana n'abantu abandi, obuheereza nka PDM, nari abebembezi b'ekyaro?"
	label define m11_q09 0 "Not willing at all" 1 "Slightly willing" 2 "Moderately willing" 3 "Very willing" 4 "Completely willing" 98 "Do not know where to connect them"
	label values m11_q09 m11_q09

	label variable m11_q10 "Ni buhwezi ki oburikubaasa kuhwera omuntu orikuruga omu kihome kugaruka omu bant"
	note m11_q10: "Ni buhwezi ki oburikubaasa kuhwera omuntu orikuruga omu kihome kugaruka omu bantu? Toorana oburikukora."

	label variable m11_q11 "Omu kureeba kwawe, okujumwa nari okutwarizibwa kubi omu bantu abarikugaruka omu "
	note m11_q11: "Omu kureeba kwawe, okujumwa nari okutwarizibwa kubi omu bantu abarikugaruka omu byanga byabo bwanyima y'okuruga omu bihome nari okukomwa, nikukira kubaho?"
	label define m11_q11 1 "Not common at all" 2 "Slightly common" 3 "Moderately common" 4 "Very common" 5 "Extremely common" 98 "Do not know"
	label values m11_q11 m11_q11

	label variable m11_q12 "Ni nshonga ki enkuru ezirikubaasa kureetera abantu kutenda kwikiriza nari kushag"
	note m11_q12: "Ni nshonga ki enkuru ezirikubaasa kureetera abantu kutenda kwikiriza nari kushagika omuntu owaabaire ari omu kihome? Toorana enshonga ishatu."

	label variable m11_q13 "Omu myezi mukaaga ehwaire, akakiiko k'ebyaro/akakiiko k'ebyaro kashoboroire ensh"
	note m11_q13: "Omu myezi mukaaga ehwaire, akakiiko k'ebyaro/akakiiko k'ebyaro kashoboroire enshonga zoona, obunkenke, nari okwerarikirira kw'abantu abarikugaruka omu byaro kuruga omu bihome?"
	label define m11_q13 1 "Yes" 0 "No" 98 "Do not know / cannot remember"
	label values m11_q13 m11_q13

	label variable m11_q14 "Ni shonga ki eyakozirweho akakiiko k'ebyaro? Toorana zoona ezirikukora."
	note m11_q14: "Ni shonga ki eyakozirweho akakiiko k'ebyaro? Toorana zoona ezirikukora."

	label variable m11_q15 "Abakuru b'ekyaro bakakora ki aha nshonga ezirikukwata aha muntu owaabaire ari om"
	note m11_q15: "Abakuru b'ekyaro bakakora ki aha nshonga ezirikukwata aha muntu owaabaire ari omu kihome?"
	label define m11_q15 1 "Mediated or facilitated dialogue locally" 2 "Referred the matter to police or court" 3 "Referred or connected the person to social, livelihood, psychosocial, or communi" 4 "Consulted family, elders, religious, clan, or community leaders" 5 "Took no action" 6 "Response is still ongoing" 98 "Other"
	label values m11_q15 m11_q15

	label variable m11_q16 "Oine obwesigye ki ngu akakiiko k'ebyaro nikabaasa kuhwera omu kukyendeeza obunke"
	note m11_q16: "Oine obwesigye ki ngu akakiiko k'ebyaro nikabaasa kuhwera omu kukyendeeza obunkenke omu bantu abarikukwata aha bantu abarikuba bararekwirwe kuruga omu bihome, enshonga egi yaaba eri omu nshonga zaabo?"
	label define m11_q16 0 "Not confident at all" 1 "Slightly confident" 2 "Moderately confident" 3 "Very confident" 4 "Completely confident"
	label values m11_q16 m11_q16

	label variable m11_q17 "Oine obwesigye ki ngu nomanya ahu orikuza kutwara omuntu owabaire ari omu kihome"
	note m11_q17: "Oine obwesigye ki ngu nomanya ahu orikuza kutwara omuntu owabaire ari omu kihome orikwenda obuhwezi oburengire obu abakuru b'ebyaro barikubaasa kuheereza?"
	label define m11_q17 0 "Not confident at all" 1 "Slightly confident" 2 "Moderately confident" 3 "Very confident" 4 "Completely confident"
	label values m11_q17 m11_q17

	label variable m11_q18 "Omu kuteekateeka kwawe, obuhwezi bw'ababaireho abasibe bushemereire kuba buri om"
	note m11_q18: "Omu kuteekateeka kwawe, obuhwezi bw'ababaireho abasibe bushemereire kuba buri omu mirimo y'oburingaaniza n'obwebembezi bw'ekyaro?"
	label define m11_q18 1 "Yes" 0 "No" 98 "Do not know"
	label values m11_q18 m11_q18

	label variable m11_q19 "Abakuru b'ebyaro bashemereire kukora ki kuhwera abantu kugaruka omu byaro byabo?"
	note m11_q19: "Abakuru b'ebyaro bashemereire kukora ki kuhwera abantu kugaruka omu byaro byabo? Tooranaho bishatu."

	label variable m11_q20 "Enumerator notes on perceptions toward incarcerated and formerly incarcerated pe"
	note m11_q20: "Enumerator notes on perceptions toward incarcerated and formerly incarcerated persons"




	

*------------------------------------------------------------------------------*
**# II.B Phase 1 baseline survey: cleaning, derived variables, and indices
*------------------------------------------------------------------------------*
* Paste this block after the SurveyCTO-generated rename / value-label / variable-
* label block for Phase 1 Baseline_Runyankore_WIDE.xlsx, and before the closing
* brace of the Phase 1 baseline section.
*
* The code intentionally keeps the original raw SurveyCTO variables and creates
* clean analysis variables, flags, and composite indices on top of them.
*------------------------------------------------------------------------------*

	*-------------------------------*
	**# 1. Basic structure and IDs  *
	*-------------------------------*
	compress
	label data "Advancing Justice Uganda - Phase 1 baseline, cleaned analysis file"

	* Harmonize key identifiers from SurveyCTO export
	capture confirm variable key
	if !_rc {
		clonevar submission_key = key
	}
	else {
		gen str80 submission_key = ""
	}
	capture confirm variable instanceid
	if !_rc {
		clonevar instance_id = instanceid
		replace submission_key = instanceid if missing(submission_key) & !missing(instanceid)
	}
	label var submission_key "SurveyCTO submission key / unique record ID"
	label var instance_id    "SurveyCTO instance ID"

	gen long survey_record_id = _n
	label var survey_record_id "Sequential row ID in imported SurveyCTO WIDE export"

	duplicates tag submission_key, gen(flag_duplicate_submission_key)
	label var flag_duplicate_submission_key "Duplicate SurveyCTO submission key flag"

	gen byte flag_no_consent = consent != 1 if !missing(consent)
	replace flag_no_consent = 1 if missing(consent)
	label var flag_no_consent "Respondent did not consent or consent is missing"

	gen byte analysis_sample = (consent == 1 & !missing(submission_key))
	label define yesno 0 "No" 1 "Yes", replace
	label values flag_no_consent analysis_sample yesno
	label var analysis_sample "Record belongs to consented Phase 1 baseline analysis sample"

	* Clean obvious string variables: trim spaces and convert literal missing strings to blank
	ds, has(type string)
	local stringvars `r(varlist)'
	foreach v of local stringvars {
		replace `v' = itrim(strtrim(`v')) if !missing(`v')
		replace `v' = "" if inlist(lower(`v'), "na", "n/a", "none", ".")
	}

	* Destring any string variable that is purely numeric; select_multiple raw vars remain string
	ds, has(type string)
	local stringvars2 `r(varlist)'
	foreach v of local stringvars2 {
		capture destring `v', replace ignore(",")
	}

	*-------------------------------*
	**# 2. Date/time variables      *
	*-------------------------------*
	foreach v in submissiondate starttime endtime {
		capture confirm variable `v'
		if !_rc {
			capture confirm numeric variable `v'
			if !_rc {
				quietly summarize `v', meanonly
				if r(max) < 100000 {
					gen double `v'_dt = (`v' - 21916) * 86400000
				}
				else {
					gen double `v'_dt = `v'
				}
			}
			else {
				gen double `v'_dt = clock(`v', "YMDhms#")
				replace `v'_dt = clock(`v', "YMDhms") if missing(`v'_dt)
				replace `v'_dt = clock(`v', "MDYhms#") if missing(`v'_dt)
			}
			format `v'_dt %tc
			label var `v'_dt "Clean Stata datetime: `v'"
		}
	}

	capture confirm variable starttime_dt
	if !_rc {
		gen double interview_date = dofc(starttime_dt)
		format interview_date %td
		gen byte interview_hour = hh(starttime_dt)
		gen byte interview_dow  = dow(interview_date)
		label var interview_date "Interview date from SurveyCTO start time"
		label var interview_hour "Interview start hour"
		label var interview_dow  "Interview day of week; 0=Sunday"
	}

	capture confirm variable duration
	if !_rc {
		destring duration, replace force
		gen double duration_min = duration / 60
		gen double duration_hr  = duration / 3600
		gen byte flag_duration_short = duration_min < 20 if !missing(duration_min)
		gen byte flag_duration_long  = duration_min > 120 if !missing(duration_min)
		label var duration_min "Survey duration in minutes"
		label var duration_hr  "Survey duration in hours"
		label var flag_duration_short "Interview lasted less than 20 minutes"
		label var flag_duration_long  "Interview lasted more than 120 minutes"
		label values flag_duration_short flag_duration_long yesno
	}

	capture confirm variable interview_date
	if !_rc {
		gen byte flag_date_outside_fieldwork = ///
			(interview_date < td(18may2026) | interview_date > td(05jun2026)) if !missing(interview_date)
		label var flag_date_outside_fieldwork "Interview date outside expected Phase 1 baseline fieldwork window"
		label values flag_date_outside_fieldwork yesno
	}


	*-------------------------------*
	**# 3. Decode geography         *
	*-------------------------------*
	* Decode SurveyCTO-selected administrative geography.
	* The final Runyankore export contains M0_Q04-M0_Q07 before rename lower,
	* and m0_q04-m0_q07 after rename lower. This block does not rely on
	* complex quoted macro lists, which can break when copied across editors.

	local geo1 "district m0_q04"
	local geo2 "subcounty m0_q05"
	local geo3 "parish m0_q06"
	local geo4 "village m0_q07"

	forvalues i = 1/4 {
		local pair "`geo`i''"
		local out = word("`pair'", 1)
		local raw = word("`pair'", 2)

		capture drop `out'_scto

		local raw_found ""
		capture confirm variable `raw'
		if !_rc local raw_found "`raw'"

		if "`raw_found'" == "" {
			local raw_uc = upper("`raw'")
			capture confirm variable `raw_uc'
			if !_rc local raw_found "`raw_uc'"
		}

		if "`raw_found'" != "" {
			capture confirm numeric variable `raw_found'
			if !_rc {
				capture decode `raw_found', gen(`out'_scto)
				if _rc {
					tostring `raw_found', gen(`out'_scto) force usedisplayformat
				}
			}
			else {
				gen strL `out'_scto = `raw_found'
			}
		}
		else {
			gen strL `out'_scto = ""
			display as error "Warning: source variable for `out'_scto was not found. Created empty `out'_scto."
		}

		replace `out'_scto = "" if trim(`out'_scto) == "."
		label var `out'_scto "SurveyCTO selected `out' label"
	}

	foreach v in district_scto subcounty_scto parish_scto village_scto {
		capture confirm variable `v'
		if _rc {
			display as error "Critical warning: `v' was not created. Creating empty field so pipeline can continue."
			gen strL `v' = ""
		}

		capture drop `v'_key
		gen str244 `v'_key = lower(substr(`v', 1, 244))
		replace `v'_key = subinstr(`v'_key, char(160), " ", .)
		replace `v'_key = ustrregexra(`v'_key, "[\u2018\u2019]", "'")
		replace `v'_key = ustrregexra(`v'_key, "[\u201C\u201D]", "")
		replace `v'_key = ustrregexra(`v'_key, "[\u2013\u2014]", "-")
		replace `v'_key = ustrregexra(`v'_key, "\s+", " ")
		replace `v'_key = itrim(strtrim(`v'_key))
		replace `v'_key = subinstr(`v'_key, "'", "", .)
		replace `v'_key = subinstr(`v'_key, char(96), "", .)
		replace `v'_key = subinstr(`v'_key, ".", "", .)
		replace `v'_key = subinstr(`v'_key, ",", "", .)
		replace `v'_key = subinstr(`v'_key, "-", "_", .)
		replace `v'_key = subinstr(`v'_key, "/", "_", .)
		replace `v'_key = subinstr(`v'_key, "(", "", .)
		replace `v'_key = subinstr(`v'_key, ")", "", .)
		replace `v'_key = subinstr(`v'_key, " ", "_", .)
		replace `v'_key = strtoname(`v'_key)
	}

	capture drop survey_village_uid survey_village_id n_duplicate_scto_village flag_duplicate_scto_village
	gen str244 survey_village_uid = substr(district_scto_key + "_" + subcounty_scto_key + "_" + parish_scto_key + "_" + village_scto_key, 1, 244)
	replace survey_village_uid = "" if survey_village_uid == "___"
	egen survey_village_id = group(survey_village_uid), label
	label var survey_village_uid "Unique village key from SurveyCTO-selected admin labels"
	label var survey_village_id  "Numeric SurveyCTO-selected village ID"

	duplicates tag survey_village_uid if survey_village_uid != "", gen(n_duplicate_scto_village)
	gen byte flag_duplicate_scto_village = (n_duplicate_scto_village > 0) if survey_village_uid != ""
	replace flag_duplicate_scto_village = 0 if survey_village_uid != "" & missing(flag_duplicate_scto_village)
	label var n_duplicate_scto_village "Number of additional submissions with same SurveyCTO-selected village key"
	label var flag_duplicate_scto_village "SurveyCTO-selected village appears in multiple submissions"
	capture label values flag_duplicate_scto_village yesno

	* Placeholder fields for the replacement correction file that Sharon/Ivan will complete.
	capture drop actual_district actual_subcounty actual_parish actual_village is_replacement_village replacement_notes
	gen strL actual_district   = district_scto
	gen strL actual_subcounty = subcounty_scto
	gen strL actual_parish    = parish_scto
	gen strL actual_village   = village_scto
	gen byte is_replacement_village = .
	gen strL replacement_notes = ""
	label var actual_district "Actual district visited; updated after record-level replacement mapping"
	label var actual_subcounty "Actual subcounty/division visited; updated after record-level replacement mapping"
	label var actual_parish "Actual parish/ward visited; updated after record-level replacement mapping"
	label var actual_village "Actual village visited; updated after record-level replacement mapping"
	label var is_replacement_village "Actual record corresponds to a replacement village"

	* Optional future merge: completed record-level replacement file.
	* Sharon/Ivan will complete this file later. Until then, actual_* variables
	* remain equal to the SurveyCTO-selected geography. The merge is record-level,
	* by submission_key, because several replacement villages were not programmed
	* in SurveyCTO and enumerators selected the original village instead.
	local repl_xlsx "${input_dir}/1 Raw/Primary data/phase1_baseline_replacement_verification_file_completed.xlsx"
	capture confirm file "`repl_xlsx'"
	if !_rc {
		preserve
			import excel using "`repl_xlsx'", sheet("Survey_records_to_complete") firstrow clear
			rename *, lower

			capture confirm variable submission_key
			if _rc {
				dis as error "Replacement file found but submission_key variable is missing. Merge skipped."
				clear
				set obs 0
				gen str80 submission_key = ""
			}

			capture rename actual_village_visited actual_village_completed
			capture rename replacement_village_name replacement_village_completed
			capture rename is_replacement_village is_replacement_village_completed
			capture rename replacement_notes replacement_notes_completed

			foreach v in actual_village_completed replacement_village_completed replacement_notes_completed {
				capture confirm variable `v'
				if _rc gen strL `v' = ""
			}
			capture confirm variable is_replacement_village_completed
			if _rc gen str20 is_replacement_village_completed = ""

			gen byte is_replacement_village_completed_num = .
			capture confirm numeric variable is_replacement_village_completed
			if !_rc {
				replace is_replacement_village_completed_num = is_replacement_village_completed if inlist(is_replacement_village_completed,0,1)
			}
			else {
				replace is_replacement_village_completed = lower(itrim(strtrim(is_replacement_village_completed)))
				replace is_replacement_village_completed_num = 1 if inlist(is_replacement_village_completed,"yes","y","1","replacement")
				replace is_replacement_village_completed_num = 0 if inlist(is_replacement_village_completed,"no","n","0","original")
			}

			keep submission_key actual_village_completed replacement_village_completed ///
				is_replacement_village_completed_num replacement_notes_completed
			drop if missing(submission_key)
			duplicates drop submission_key, force

			tempfile replmap
			save `replmap'
		restore

		capture drop merge_replacement_map
		merge 1:1 submission_key using `replmap', gen(merge_replacement_map) keep(master match)
		label var merge_replacement_map "Merge status with completed record-level replacement map"

		replace actual_village = actual_village_completed if !missing(actual_village_completed)
		replace actual_village = replacement_village_completed if is_replacement_village_completed_num == 1 & !missing(replacement_village_completed)
		replace is_replacement_village = is_replacement_village_completed_num if !missing(is_replacement_village_completed_num)
		replace replacement_notes = replacement_notes_completed if !missing(replacement_notes_completed)
	}

	*-------------------------------*
	**# 4. Merge sampling metadata  *
	*-------------------------------*
	* Merge original randomized sampling-frame metadata when possible.
	* Important: keep only master SurveyCTO records so the baseline dataset is not
	* expanded by using-only observations from the sampling frame. As of the first
	* Phase 1 baseline cleaning, this merge is expected to have limited/no matches
	* until the record-level replacement-village correction file is completed.

	capture confirm file "${input_dir}/2 Working/phase1_sampling_frame_full.dta"
	if !_rc {
		preserve
			use "${input_dir}/2 Working/phase1_sampling_frame_full.dta", clear

			keep district subcounty parish village village_uid number_of_cases ///
				case_rank_district case_share_district hotspot_p75_district hotspot_p90_district ///
				phase1_selected phase1_replacement sample_role replacement_rank_stratum district_fallback_rank

			rename district sample_district
			rename subcounty sample_subcounty
			rename parish sample_parish
			rename village sample_village
			rename village_uid survey_village_uid
			rename number_of_cases sample_number_of_cases
			rename case_rank_district sample_case_rank_district
			rename case_share_district sample_case_share_district
			rename hotspot_p75_district sample_hotspot_p75
			rename hotspot_p90_district sample_hotspot_p90

			* Stata cannot merge on strL keys. Force fixed-length string key.
			capture confirm strL variable survey_village_uid
			if !_rc {
				gen str244 survey_village_uid_tmp = substr(survey_village_uid, 1, 244)
				drop survey_village_uid
				rename survey_village_uid_tmp survey_village_uid
			}
			else {
				capture confirm string variable survey_village_uid
				if _rc tostring survey_village_uid, replace force
				gen str244 survey_village_uid_tmp = substr(survey_village_uid, 1, 244)
				drop survey_village_uid
				rename survey_village_uid_tmp survey_village_uid
			}

			duplicates drop survey_village_uid, force

			tempfile sampleframe
			save `sampleframe'
		restore

		capture drop merge_sampling_frame
		foreach v in sample_district sample_subcounty sample_parish sample_village ///
			sample_number_of_cases sample_case_rank_district sample_case_share_district ///
			sample_hotspot_p75 sample_hotspot_p90 phase1_selected phase1_replacement ///
			sample_role replacement_rank_stratum district_fallback_rank {
			capture drop `v'
		}

		merge m:1 survey_village_uid using `sampleframe', ///
			gen(merge_sampling_frame) keep(master match)

		label var merge_sampling_frame "Merge status with original randomized sampling frame"

		* After this merge, the dataset must still contain only SurveyCTO submissions.
		assert !missing(survey_record_id)
		tab merge_sampling_frame, missing
	}

	*-------------------------------*
	**# 5. Correct simple skips     *
	*-------------------------------*
	* Keep original raw variables. Create clean versions for analysis where needed.
	gen byte prior_cdfu_fhri_training = attend_cdfu_training == 1 if !missing(attend_cdfu_training)
	label var prior_cdfu_fhri_training "Respondent reports prior CDFU/FHRI training before/at baseline"
	label values prior_cdfu_fhri_training yesno

	gen rating_cdfu_training_clean = rating_cdfu_training if attend_cdfu_training == 1 & inrange(rating_cdfu_training,1,5)
	label var rating_cdfu_training_clean "Training usefulness rating, cleaned; only if prior CDFU/FHRI training reported"

	foreach j in 1 2 3 4 5 6 7 98 {
		capture confirm variable topics_trained_`j'
		if !_rc replace topics_trained_`j' = . if attend_cdfu_training != 1
	}
	egen n_prior_training_topics = rowtotal(topics_trained_1 topics_trained_2 topics_trained_3 topics_trained_4 topics_trained_5 topics_trained_6 topics_trained_7) if attend_cdfu_training == 1
	label var n_prior_training_topics "Number of prior CDFU/FHRI training topics reported"

	*-------------------------------*
	**# 6. Module 1: respondent     *
	*-------------------------------*
	gen byte respondent_female = m1_q06 == 2 if inlist(m1_q06,1,2)
	label var respondent_female "Respondent is female"
	label values respondent_female yesno

	gen byte respondent_age_cat = m1_q07 if inrange(m1_q07,1,6)
	label var respondent_age_cat "Respondent age category"

	gen byte education_level = m1_q08 if inrange(m1_q08,0,6)
	gen byte completed_secondary_or_above = inrange(m1_q08,4,6) if inrange(m1_q08,0,6)
	gen double education_score = education_level / 6 if inrange(education_level,0,6)
	label var education_level "Highest education level, cleaned"
	label var completed_secondary_or_above "Completed secondary education or above"
	label var education_score "Education score normalized 0-1"
	label values completed_secondary_or_above yesno

	gen double lc_experience_years = m1_q04 if m1_q04 >= 0 & m1_q04 < .
	gen double lc_experience_score = min(lc_experience_years,10) / 10 if !missing(lc_experience_years)
	label var lc_experience_years "Years in LC1 position"
	label var lc_experience_score "LC experience score capped at 10 years, normalized 0-1"

	gen double record_literacy_score = m1_q09 / 4 if inrange(m1_q09,0,4)
	label var record_literacy_score "Comfort reading/writing LCC case records, normalized 0-1"

	gen byte can_record_english     = m1_q10_1 == 1 if !missing(m1_q10_1)
	gen byte can_record_runyankore  = m1_q10_2 == 1 if !missing(m1_q10_2)
	gen byte cannot_complete_records = m1_q10_95 == 1 if !missing(m1_q10_95)
	label var can_record_english "Can complete LCC records in English"
	label var can_record_runyankore "Can complete LCC records in Runyankore/Runyakitara"
	label var cannot_complete_records "Cannot comfortably complete written LCC records"
	label values can_record_english can_record_runyankore cannot_complete_records yesno

	gen byte prior_justice_training = m1_q11 == 1 if inlist(m1_q11,0,1,98)
	gen byte prior_formal_coordination = m1_q13 == 1 if inlist(m1_q13,0,1)
	label var prior_justice_training "Prior training on justice, mediation, mandate, records, or referrals"
	label var prior_formal_coordination "Prior coordination with police/courts/probation/child protection/justice actors"
	label values prior_justice_training prior_formal_coordination yesno

	egen n_case_types_handled = rowtotal(m1_q14_1 m1_q14_2 m1_q14_3 m1_q14_4 m1_q14_5 m1_q14_6 m1_q14_7 m1_q14_8)
	gen double case_experience_score = min(n_case_types_handled,5) / 5 if !missing(n_case_types_handled)
	gen byte handled_child_or_sgbv_case = (m1_q14_7 == 1 | m1_q14_8 == 1) if !missing(n_case_types_handled)
	label var n_case_types_handled "Number of dispute/case types handled since Jan 2025"
	label var case_experience_score "Breadth of case experience, capped at 5 types, normalized 0-1"
	label var handled_child_or_sgbv_case "Handled child-related or SGBV case since Jan 2025"
	label values handled_child_or_sgbv_case yesno

	gen double weekly_lc_time_score = m1_q15 / 4 if inrange(m1_q15,0,4)
	label var weekly_lc_time_score "Weekly time spent on LC/LCC duties, normalized 0-1"

	egen idx_respondent_capacity = rowmean(lc_experience_score education_score record_literacy_score ///
		prior_justice_training prior_formal_coordination case_experience_score weekly_lc_time_score)
	label var idx_respondent_capacity "Index: respondent LC/LCC capacity and prior experience, 0-1"

	*-------------------------------*
	**# 7. Module 2: institution    *
	*-------------------------------*
	gen double lcc_members_total = m2_q01 if m2_q01 >= 0 & m2_q01 < .
	gen double lcc_women_members = m2_q05 if m2_q05 >= 0 & m2_q05 < .
	gen double lcc_women_share = lcc_women_members / lcc_members_total if lcc_members_total > 0
	gen byte lcc_has_woman_member = lcc_women_members > 0 if !missing(lcc_women_members)
	gen byte lcc_has_vacancy = m2_q03 == 1 if inlist(m2_q03,0,1,98)
	gen double lcc_vacancies_count = m2_q04 if m2_q04 >= 0 & m2_q04 < .
	label var lcc_members_total "Number of current LCC/LC committee members"
	label var lcc_women_members "Number of women LCC/LC committee members"
	label var lcc_women_share "Share of current LCC/LC committee members who are women"
	label var lcc_has_woman_member "LCC/LC committee has at least one woman member"
	label var lcc_has_vacancy "LCC/LC committee has vacancies"
	label values lcc_has_woman_member lcc_has_vacancy yesno

	gen double lcc_sittings_12m = m2_q06 if m2_q06 >= 0 & m2_q06 < .
	label var lcc_sittings_12m "Number of LCC sittings/hearings in the past 12 months"

	gen double meeting_frequency_score = .
	replace meeting_frequency_score = 1.00 if m2_q07 == 1
	replace meeting_frequency_score = 0.80 if m2_q07 == 2
	replace meeting_frequency_score = 0.60 if m2_q07 == 3
	replace meeting_frequency_score = 0.40 if m2_q07 == 4
	replace meeting_frequency_score = 0.50 if m2_q07 == 5
	replace meeting_frequency_score = 0.00 if m2_q07 == 6
	label var meeting_frequency_score "LCC meeting/sitting frequency score, 0-1"

	gen double quorum_score = .
	replace quorum_score = 1.00 if m2_q08 == 1
	replace quorum_score = 0.50 if m2_q08 == 2
	replace quorum_score = 0.25 if m2_q08 == 3
	replace quorum_score = 0.00 if m2_q08 == 4
	label var quorum_score "Quorum achievement score, 0-1"

	gen double fixed_place_score = .
	replace fixed_place_score = 1.0 if m2_q09 == 1
	replace fixed_place_score = 0.5 if m2_q09 == 2
	replace fixed_place_score = 0.0 if m2_q09 == 3
	label var fixed_place_score "LCC has fixed/regular hearing place score, 0-1"

	gen double inst_record_exist_score = .
	replace inst_record_exist_score = 1.0 if m2_q12 == 1
	replace inst_record_exist_score = 0.5 if m2_q12 == 2
	replace inst_record_exist_score = 0.0 if m2_q12 == 3
	label var inst_record_exist_score "Institutional record existence score from M2, 0-1"

	gen double inst_record_uptodate_score = .
	replace inst_record_uptodate_score = 1.0 if m2_q13 == 1
	replace inst_record_uptodate_score = 0.5 if m2_q13 == 2
	replace inst_record_uptodate_score = 0.0 if m2_q13 == 3
	label var inst_record_uptodate_score "Institutional record up-to-date score from M2, 0-1"

	gen double materials_score = .
	replace materials_score = 1.0 if m2_q14 == 1
	replace materials_score = 0.5 if m2_q14 == 2
	replace materials_score = 0.0 if m2_q14 == 3
	label var materials_score "Availability of basic materials score, 0-1"

	egen n_materials_missing = rowtotal(m2_q15_1 m2_q15_2 m2_q15_3 m2_q15_4 m2_q15_5 m2_q15_6)
	label var n_materials_missing "Number of basic LCC materials reported missing or insufficient"

	gen double record_seen_score_m2 = .
	replace record_seen_score_m2 = 1.0 if m2_q16 == 1
	replace record_seen_score_m2 = 0.5 if m2_q16 == 2
	replace record_seen_score_m2 = 0.0 if m2_q16 == 0
	label var record_seen_score_m2 "Enumerator saw LCC records score from M2, 0-1"

	gen double recent_entries_uptodate_score_m2 = .
	replace recent_entries_uptodate_score_m2 = 1.0 if m2_q17 == 1
	replace recent_entries_uptodate_score_m2 = 0.5 if m2_q17 == 2
	replace recent_entries_uptodate_score_m2 = 0.0 if m2_q17 == 3
	label var recent_entries_uptodate_score_m2 "Enumerator-verified recent entries up-to-date score, 0-1"

	egen idx_institutional_functioning = rowmean(meeting_frequency_score quorum_score fixed_place_score ///
		inst_record_exist_score inst_record_uptodate_score materials_score ///
		record_seen_score_m2 recent_entries_uptodate_score_m2)
	label var idx_institutional_functioning "Index: LCC institutional functioning, 0-1"

	*-------------------------------*
	**# 8. Module 3: caseload       *
	*-------------------------------*
	foreach v in m3_q02 m3_q03 m3_q08 m3_q09 m3_q10 m3_q12 {
		capture confirm variable `v'
		if !_rc {
			replace `v' = . if `v' < 0
		}
	}

	gen double caseload_30d = m3_q02
	gen double caseload_3m  = m3_q03
	gen double pending_cases = m3_q08
	gen double directly_brought_cases_3m = m3_q09
	gen double referred_to_lcc_cases_3m = m3_q10
	gen double referred_onward_cases_3m = m3_q12
	label var caseload_30d "Cases received by LCC in past 30 days"
	label var caseload_3m  "Cases received by LCC in past 3 months"
	label var pending_cases "Pending/unresolved LCC cases"
	label var directly_brought_cases_3m "Cases brought directly by community/parties in past 3 months"
	label var referred_to_lcc_cases_3m "Cases referred to LCC by another actor in past 3 months"
	label var referred_onward_cases_3m "Cases referred onward by LCC in past 3 months"

	gen byte flag_caseload_30d_gt_3m = caseload_30d > caseload_3m if !missing(caseload_30d, caseload_3m)
	gen byte flag_pending_gt_3m      = pending_cases > caseload_3m if !missing(pending_cases, caseload_3m)
	gen byte flag_direct_gt_3m       = directly_brought_cases_3m > caseload_3m if !missing(directly_brought_cases_3m, caseload_3m)
	gen byte flag_referred_to_lcc_gt_3m = referred_to_lcc_cases_3m > caseload_3m if !missing(referred_to_lcc_cases_3m, caseload_3m)
	gen byte flag_referred_onward_gt_3m = referred_onward_cases_3m > caseload_3m if !missing(referred_onward_cases_3m, caseload_3m)
	label values flag_caseload_30d_gt_3m flag_pending_gt_3m flag_direct_gt_3m ///
		flag_referred_to_lcc_gt_3m flag_referred_onward_gt_3m yesno

	gen double pending_share_3m = pending_cases / caseload_3m if caseload_3m > 0
	gen double directly_brought_share_3m = directly_brought_cases_3m / caseload_3m if caseload_3m > 0
	gen double referred_to_lcc_share_3m = referred_to_lcc_cases_3m / caseload_3m if caseload_3m > 0
	gen double referred_onward_share_3m = referred_onward_cases_3m / caseload_3m if caseload_3m > 0
	foreach v in pending_share_3m directly_brought_share_3m referred_to_lcc_share_3m referred_onward_share_3m {
		replace `v' = . if `v' < 0 | `v' > 1
	}
	label var pending_share_3m "Pending cases as share of 3-month caseload"
	label var directly_brought_share_3m "Directly brought cases as share of 3-month caseload"
	label var referred_to_lcc_share_3m "Cases referred to LCC as share of 3-month caseload"
	label var referred_onward_share_3m "Cases referred onward as share of 3-month caseload"

	egen n_case_types_received_3m = rowtotal(m3_q04_1 m3_q04_2 m3_q04_3 m3_q04_4 m3_q04_5 ///
		m3_q04_6 m3_q04_7 m3_q04_8 m3_q04_9 m3_q04_10)
	gen byte any_child_or_sgbv_case_3m = (m3_q04_7 == 1 | m3_q04_8 == 1) if !missing(n_case_types_received_3m)
	gen byte any_reintegration_case_3m = m3_q04_10 == 1 if !missing(m3_q04_10)
	gen byte any_serious_or_sensitive_case_3m = any_child_or_sgbv_case_3m == 1
	gen double petty_case_share_score = m3_q06 / 5 if inrange(m3_q06,0,5)
	gen double caseload_accuracy_score = (m3_q17 - 1) / 4 if inrange(m3_q17,1,5)
	label var n_case_types_received_3m "Number of case/dispute types received in past 3 months"
	label var any_child_or_sgbv_case_3m "LCC received child-related or SGBV case in past 3 months"
	label var any_reintegration_case_3m "LCC received reintegration-related case in past 3 months"
	label var petty_case_share_score "Perceived share of cases that are petty/minor and locally handleable, 0-1"
	label var caseload_accuracy_score "Respondent confidence in reported caseload, 0-1"
	label values any_child_or_sgbv_case_3m any_reintegration_case_3m any_serious_or_sensitive_case_3m yesno

	*-------------------------------*
	**# 9. Module 4: knowledge      *
	*-------------------------------*
	* M4_Q01: cases the LCC should handle locally. Positive: 1-6; negative: 7-10.
	egen m4_q01_pos = rowmean(m4_q01_1 m4_q01_2 m4_q01_3 m4_q01_4 m4_q01_5 m4_q01_6)
	gen double m4_q01_no_7  = 1 - m4_q01_7  if !missing(m4_q01_7)
	gen double m4_q01_no_8  = 1 - m4_q01_8  if !missing(m4_q01_8)
	gen double m4_q01_no_9  = 1 - m4_q01_9  if !missing(m4_q01_9)
	gen double m4_q01_no_10 = 1 - m4_q01_10 if !missing(m4_q01_10)
	egen m4_q01_local_scope_score = rowmean(m4_q01_pos m4_q01_no_7 m4_q01_no_8 m4_q01_no_9 m4_q01_no_10)
	drop m4_q01_pos m4_q01_no_7 m4_q01_no_8 m4_q01_no_9 m4_q01_no_10
	label var m4_q01_local_scope_score "Knowledge score: cases LCC can handle locally, 0-1"

	* M4_Q02: cases that should be referred. Positive: 1-6; negative: 7-8.
	egen m4_q02_ref_pos = rowmean(m4_q02_1 m4_q02_2 m4_q02_3 m4_q02_4 m4_q02_5 m4_q02_6)
	gen double m4_q02_no_7 = 1 - m4_q02_7 if !missing(m4_q02_7)
	gen double m4_q02_no_8 = 1 - m4_q02_8 if !missing(m4_q02_8)
	egen m4_q02_referral_scope_score = rowmean(m4_q02_ref_pos m4_q02_no_7 m4_q02_no_8)
	drop m4_q02_ref_pos m4_q02_no_7 m4_q02_no_8
	label var m4_q02_referral_scope_score "Knowledge score: cases requiring referral, 0-1"

	gen byte m4_q04_correct_refer = m4_q04 == 2 if inrange(m4_q04,1,4) | m4_q04 == 98
	label var m4_q04_correct_refer "Correct response: outside mandate cases should be referred"
	label values m4_q04_correct_refer yesno

	* M4_Q05: documentation knowledge. Positive: 1-6; negative: 7.
	egen m4_q05_record_pos = rowmean(m4_q05_1 m4_q05_2 m4_q05_3 m4_q05_4 m4_q05_5 m4_q05_6)
	gen double m4_q05_no_7 = 1 - m4_q05_7 if !missing(m4_q05_7)
	egen m4_q05_documentation_score = rowmean(m4_q05_record_pos m4_q05_no_7)
	drop m4_q05_record_pos m4_q05_no_7
	label var m4_q05_documentation_score "Knowledge score: what should be documented, 0-1"

	* M4_Q06: procedural step knowledge. Positive: 1-5 and 7; negative: 6.
	egen m4_q06_steps_pos = rowmean(m4_q06_1 m4_q06_2 m4_q06_3 m4_q06_4 m4_q06_5 m4_q06_7)
	gen double m4_q06_no_6 = 1 - m4_q06_6 if !missing(m4_q06_6)
	egen m4_q06_procedure_score = rowmean(m4_q06_steps_pos m4_q06_no_6)
	drop m4_q06_steps_pos m4_q06_no_6
	label var m4_q06_procedure_score "Knowledge score: LCC procedural steps before resolution, 0-1"

	gen byte m4_q07_correct_adr_scope = m4_q07 == 2 if inrange(m4_q07,1,4) | m4_q07 == 98
	label var m4_q07_correct_adr_scope "Correct response: ADR for eligible petty/minor disputes only"
	label values m4_q07_correct_adr_scope yesno

	* M4_Q08: when formal institutions/authorities should be involved. Positive: 1-5; negative: 6-7.
	egen m4_q08_auth_pos = rowmean(m4_q08_1 m4_q08_2 m4_q08_3 m4_q08_4 m4_q08_5)
	gen double m4_q08_no_6 = 1 - m4_q08_6 if !missing(m4_q08_6)
	gen double m4_q08_no_7 = 1 - m4_q08_7 if !missing(m4_q08_7)
	egen m4_q08_authority_score = rowmean(m4_q08_auth_pos m4_q08_no_6 m4_q08_no_7)
	drop m4_q08_auth_pos m4_q08_no_6 m4_q08_no_7
	label var m4_q08_authority_score "Knowledge score: when formal authority involvement is needed, 0-1"

	gen double classification_confidence_score = m4_q10 / 4 if inrange(m4_q10,0,4)
	label var classification_confidence_score "Self-confidence distinguishing handle vs refer cases, 0-1"

	* Vignettes: scoring based on legally/pedagogically expected responses in current questionnaire.
	gen byte v01_boundary_q1_correct = m4_v01_q1 == 1 if inrange(m4_v01_q1,1,3) | m4_v01_q1 == 98
	gen byte v01_boundary_q2_correct = m4_v01_q2 == 1 if inrange(m4_v01_q2,1,5) | m4_v01_q2 == 98
	gen byte v01_boundary_q3_correct = (m4_v01_q3_1 == 1 & m4_v01_q3_2 != 1 & m4_v01_q3_3 != 1 & ///
		m4_v01_q3_4 != 1 & m4_v01_q3_5 != 1) if !missing(m4_v01_q3_1)

	gen byte v02_family_q1_correct = m4_v02_q1 == 1 if inrange(m4_v02_q1,1,3) | m4_v02_q1 == 98
	gen byte v02_family_q2_correct = m4_v02_q2 == 1 if inrange(m4_v02_q2,1,5) | m4_v02_q2 == 98
	gen byte v02_family_q3_correct = (m4_v02_q3_1 == 1 & m4_v02_q3_2 != 1 & m4_v02_q3_3 != 1 & ///
		m4_v02_q3_4 != 1 & m4_v02_q3_5 != 1) if !missing(m4_v02_q3_1)

	gen byte v05_child_q1_correct = m4_v05_q1 == 2 if inrange(m4_v05_q1,1,3) | m4_v05_q1 == 98
	gen byte v05_child_q2_correct = m4_v05_q2 == 2 if inrange(m4_v05_q2,1,4) | m4_v05_q2 == 98
	gen byte v05_child_q3_correct = (m4_v05_q3_4 == 1 & m4_v05_q3_1 != 1) if !missing(m4_v05_q3_4)

	gen byte v06_sgbv_q1_correct = m4_v06_q1 == 2 if inrange(m4_v06_q1,1,3) | m4_v06_q1 == 98
	gen byte v06_sgbv_q2_correct = m4_v06_q2 == 3 if inrange(m4_v06_q2,1,4) | m4_v06_q2 == 98
	gen byte v06_sgbv_q3_correct = ((m4_v06_q3_2 == 1 | m4_v06_q3_3 == 1 | m4_v06_q3_5 == 1) & m4_v06_q3_1 != 1) ///
		if !missing(m4_v06_q3_2)

	egen idx_vignette_classification = rowmean(v01_boundary_q1_correct v01_boundary_q2_correct v01_boundary_q3_correct ///
		v02_family_q1_correct v02_family_q2_correct v02_family_q3_correct ///
		v05_child_q1_correct v05_child_q2_correct v05_child_q3_correct ///
		v06_sgbv_q1_correct v06_sgbv_q2_correct v06_sgbv_q3_correct)
	label var idx_vignette_classification "Index: case-vignette classification/referral performance, 0-1"

	egen idx_legal_classif_knowledge = rowmean(m4_q01_local_scope_score m4_q02_referral_scope_score ///
		m4_q04_correct_refer m4_q05_documentation_score m4_q06_procedure_score ///
		m4_q07_correct_adr_scope m4_q08_authority_score idx_vignette_classification)
	label var idx_legal_classif_knowledge "Index: legal mandate, classification, referral, and procedure knowledge, 0-1"

	egen idx_safeguard_classif_know = rowmean(m4_q02_referral_scope_score ///
		m4_q04_correct_refer v05_child_q1_correct v05_child_q2_correct v05_child_q3_correct ///
		v06_sgbv_q1_correct v06_sgbv_q2_correct v06_sgbv_q3_correct)
	label var idx_safeguard_classif_know "Index: serious/sensitive-case classification and referral knowledge, 0-1"

	*-------------------------------*
	**# 10. Module 5: ADR           *
	*-------------------------------*
	foreach v in m5_q01 m5_q02 m5_q03 m5_q06 m5_q07 m5_q14 m5_q16 {
		gen double `v'_score = `v' / 4 if inrange(`v',0,4)
	}
	gen double adr_confidence_score = m5_q09 / 4 if inrange(m5_q09,0,4)
	gen double deescalation_confidence_score = m5_q10 / 4 if inrange(m5_q10,0,4)
	gen byte noncomp_response_app = inlist(m5_q15,1,2) if inrange(m5_q15,1,5) | m5_q15 == 97 | m5_q15 == 98
	egen n_adr_barriers = rowtotal(m5_q11_1 m5_q11_2 m5_q11_3 m5_q11_4 m5_q11_5 m5_q11_6 m5_q11_7 m5_q11_8 m5_q11_9)
	egen n_adr_methods = rowtotal(m5_q13_1 m5_q13_2 m5_q13_3 m5_q13_4 m5_q13_5 m5_q13_6 m5_q13_7 m5_q13_8)
	gen double adr_methods_score = min(n_adr_methods,5) / 5 if !missing(n_adr_methods)
	label var n_adr_barriers "Number of reported barriers to local mediation/ADR"
	label var n_adr_methods "Number of ADR/local resolution methods used by LCC"
	label var adr_methods_score "ADR method breadth score, capped at 5 methods, normalized 0-1"
	label var noncomp_response_app "Appropriate response to noncompliance with mediated agreement"
	label values noncomp_response_app yesno

	egen idx_adr_mediation_practice = rowmean(m5_q01_score m5_q02_score m5_q03_score m5_q06_score ///
		m5_q07_score adr_confidence_score deescalation_confidence_score m5_q14_score ///
		noncomp_response_app m5_q16_score adr_methods_score)
	label var idx_adr_mediation_practice "Index: ADR/mediation practice quality and confidence, 0-1"

	*-------------------------------*
	**# 11. Module 6: referrals     *
	*-------------------------------*
	gen double referral_frequency_score = m6_q01 / 4 if inrange(m6_q01,0,4)
	gen double referral_documentation_score = m6_q05 / 4 if inrange(m6_q05,0,4)
	gen double referral_feedback_score = m6_q08 / 4 if inrange(m6_q08,0,4)
	gen double police_coordination_score = (m6_q09 - 1) / 4 if inrange(m6_q09,1,5)
	gen double court_coordination_score  = (m6_q10 - 1) / 4 if inrange(m6_q10,1,5)
	gen double referral_path_conf_score = m6_q14 / 4 if inrange(m6_q14,0,4)
	gen double referral_explain_conf_score = m6_q15 / 4 if inrange(m6_q15,0,4)

	gen double verified_referral_record_score = .
	replace verified_referral_record_score = 1.0 if m6_q16 == 1
	replace verified_referral_record_score = 0.5 if m6_q16 == 2
	replace verified_referral_record_score = 0.0 if m6_q16 == 3
	label var verified_referral_record_score "Enumerator-verified referred cases are recorded, 0-1"

	gen double verified_ref_dest_score = .
	replace verified_ref_dest_score = 1.0 if m6_q17 == 1
	replace verified_ref_dest_score = 0.5 if m6_q17 == 2
	replace verified_ref_dest_score = 0.0 if m6_q17 == 3
	label var verified_ref_dest_score "Enumerator-verified referral destination is recorded, 0-1"

	egen n_referral_reasons = rowtotal(m6_q04_1 m6_q04_2 m6_q04_3 m6_q04_4 m6_q04_5 m6_q04_6 m6_q04_7 m6_q04_8)
	egen n_referral_barriers = rowtotal(m6_q12_1 m6_q12_2 m6_q12_3 m6_q12_4 m6_q12_5 m6_q12_6 ///
		m6_q12_7 m6_q12_8 m6_q12_9 m6_q12_10)
	gen byte no_major_referral_barriers = m6_q12_11 == 1 if !missing(m6_q12_11)
	label var n_referral_reasons "Number of reasons for onward referral reported"
	label var n_referral_barriers "Number of referral barriers reported"
	label var no_major_referral_barriers "Respondent reports no major referral barriers"
	label values no_major_referral_barriers yesno

	egen idx_referral_practice = rowmean(referral_frequency_score referral_documentation_score referral_feedback_score ///
		police_coordination_score court_coordination_score referral_path_conf_score ///
		referral_explain_conf_score verified_referral_record_score verified_ref_dest_score)
	label var idx_referral_practice "Index: referral practice, coordination, and documentation, 0-1"

	*-------------------------------*
	**# 12. Module 7: records       *
	*-------------------------------*
	gen double case_register_score = .
	replace case_register_score = 1.0 if m7_q01 == 1
	replace case_register_score = 0.5 if m7_q01 == 2
	replace case_register_score = 0.0 if m7_q01 == 3
	label var case_register_score "Current case register/case book score, 0-1"

	egen n_record_types = rowtotal(m7_q03_1 m7_q03_2 m7_q03_3 m7_q03_4 m7_q03_5 m7_q03_6)
	gen double record_type_breadth_score = min(n_record_types,6) / 6 if !missing(n_record_types)
	label var n_record_types "Number of written record types kept by LCC"
	label var record_type_breadth_score "Breadth of written record types kept, 0-1"

	gen double record_uptodate_score = .
	replace record_uptodate_score = 1.0 if m7_q04 == 1
	replace record_uptodate_score = 0.5 if m7_q04 == 2
	replace record_uptodate_score = 0.0 if m7_q04 == 3
	label var record_uptodate_score "Self-reported record up-to-date score, 0-1"

	gen double most_recent_entry_score = .
	replace most_recent_entry_score = 1.00 if m7_q05 == 1
	replace most_recent_entry_score = 0.75 if m7_q05 == 2
	replace most_recent_entry_score = 0.50 if m7_q05 == 3
	replace most_recent_entry_score = 0.25 if m7_q05 == 4
	replace most_recent_entry_score = 0.00 if m7_q05 == 5
	label var most_recent_entry_score "Recency of most recent case entry score, 0-1"

	egen n_record_fields = rowtotal(m7_q06_1 m7_q06_2 m7_q06_3 m7_q06_4 m7_q06_5 m7_q06_6 ///
		m7_q06_7 m7_q06_8 m7_q06_9 m7_q06_10 m7_q06_11 m7_q06_12)
	gen double record_fields_score = n_record_fields / 12 if !missing(n_record_fields)
	label var n_record_fields "Number of core fields usually included in case records"
	label var record_fields_score "Completeness of fields usually included in case records, 0-1"

	gen double outcome_recorded_score = m7_q08 / 4 if inrange(m7_q08,0,4)
	gen double record_retrieval_score = (m7_q12 - 1) / 4 if inrange(m7_q12,1,5)
	gen double secure_storage_score = .
	replace secure_storage_score = 1.0 if m7_q13 == 1
	replace secure_storage_score = 0.5 if m7_q13 == 2
	replace secure_storage_score = 0.0 if m7_q13 == 3
	label var outcome_recorded_score "Outcome/resolution/decision usually recorded, 0-1"
	label var record_retrieval_score "Ease of retrieving a recent case record, 0-1"
	label var secure_storage_score "Secure/confidential record storage score, 0-1"

	gen byte records_access_open_to_community = m7_q14_6 == 1 if !missing(m7_q14_6)
	label var records_access_open_to_community "Any community member can access records upon request"
	label values records_access_open_to_community yesno

	egen n_record_challenges = rowtotal(m7_q15_1 m7_q15_2 m7_q15_3 m7_q15_4 m7_q15_5 m7_q15_6 m7_q15_7 m7_q15_8)
	gen byte no_major_record_challenges = m7_q15_9 == 1 if !missing(m7_q15_9)
	label var n_record_challenges "Number of reported record-keeping challenges"
	label var no_major_record_challenges "Respondent reports no major record-keeping challenges"
	label values no_major_record_challenges yesno

	gen double verified_case_register_score = .
	replace verified_case_register_score = 1.0 if m7_v01 == 1
	replace verified_case_register_score = 0.5 if m7_v01 == 2
	replace verified_case_register_score = 0.0 if m7_v01 == 0
	gen double verified_proceedings_score = .
	replace verified_proceedings_score = 1.0 if m7_v02 == 1
	replace verified_proceedings_score = 0.5 if m7_v02 == 2
	replace verified_proceedings_score = 0.0 if m7_v02 == 0
	gen double verified_storage_score = .
	replace verified_storage_score = 1.0 if m7_v12 == 1
	replace verified_storage_score = 0.5 if m7_v12 == 2
	replace verified_storage_score = 0.0 if inlist(m7_v12,3,4,5)
	gen double verified_record_usability_score = (m7_v13 - 1) / 4 if inrange(m7_v13,1,5)
	label var verified_case_register_score "Enumerator-verified case register score, 0-1"
	label var verified_proceedings_score "Enumerator-verified proceedings book/notes score, 0-1"
	label var verified_storage_score "Enumerator-verified storage security score, 0-1"
	label var verified_record_usability_score "Enumerator-rated overall record usability score, 0-1"

	egen idx_record_quality = rowmean(case_register_score record_type_breadth_score record_uptodate_score ///
		most_recent_entry_score record_fields_score outcome_recorded_score record_retrieval_score ///
		secure_storage_score verified_case_register_score verified_proceedings_score verified_storage_score ///
		verified_record_usability_score)
	label var idx_record_quality "Index: LCC record-keeping and case-management quality, 0-1"

	*-------------------------------*
	**# 13. Module 8: committee     *
	*-------------------------------*
	gen double collective_handling_score = .
	replace collective_handling_score = 1.0 if m8_q01 == 1
	replace collective_handling_score = 0.5 if m8_q01 == 2
	replace collective_handling_score = 0.0 if m8_q01 == 3
	label var collective_handling_score "Collective rather than chair-alone case handling score, 0-1"

	gen double active_member_part_score = m8_q03 / 4 if inrange(m8_q03,0,4)
	gen double collective_discussion_score = m8_q04 / 4 if inrange(m8_q04,0,4)
	gen double women_participation_score = m8_q06 / 4 if inrange(m8_q06,0,4)
	gen byte women_perspective_mechanism = inlist(m8_q07,1,2,3) if inrange(m8_q07,1,4) | m8_q07 == 98
	gen double record_validation_score = m8_q08 / 4 if inrange(m8_q08,0,4)
	label var active_member_part_score "Different members actively participate, 0-1"
	label var collective_discussion_score "Committee discusses collectively before decision/referral, 0-1"
	label var women_participation_score "Women members participate actively when present, 0-1"
	label var women_perspective_mechanism "Mechanism exists to consider women's perspectives where no women serve"
	label var record_validation_score "Decision/agreement/referral validated by more than one member, 0-1"
	label values women_perspective_mechanism yesno

	gen double case_review_score = .
	replace case_review_score = 1.00 if m8_q09 == 1
	replace case_review_score = 0.66 if m8_q09 == 2
	replace case_review_score = 0.33 if m8_q09 == 3
	replace case_review_score = 0.00 if m8_q09 == 4
	label var case_review_score "LCC case review meetings for pending/referral/follow-up cases, 0-1"

	gen double decision_process_score = .
	replace decision_process_score = 1.0 if m8_q11 == 1
	replace decision_process_score = 0.0 if m8_q11 == 2
	replace decision_process_score = 0.5 if m8_q11 == 3
	replace decision_process_score = 0.8 if m8_q11 == 4
	replace decision_process_score = 0.6 if m8_q11 == 5
	label var decision_process_score "Decision process when committee members disagree, 0-1"

	gen double similar_case_consistency_score = (m8_q13 - 1) / 4 if inrange(m8_q13,1,5)
	gen double procedure_confidence_score = m8_q14 / 4 if inrange(m8_q14,0,4)
	label var similar_case_consistency_score "Consistency across similar cases, 0-1"
	label var procedure_confidence_score "Confidence LCC follows same basic procedure across similar cases, 0-1"

	egen n_committee_challenges = rowtotal(m8_q15_1 m8_q15_2 m8_q15_3 m8_q15_4 m8_q15_5 ///
		m8_q15_6 m8_q15_7 m8_q15_8 m8_q15_9)
	gen byte no_major_committee_challenges = m8_q15_10 == 1 if !missing(m8_q15_10)
	label var n_committee_challenges "Number of committee-functioning challenges reported"
	label var no_major_committee_challenges "Respondent reports no major committee-functioning challenges"
	label values no_major_committee_challenges yesno

	gen double verified_member_part_score = .
	replace verified_member_part_score = 1.0 if m8_v01 == 1
	replace verified_member_part_score = 0.5 if m8_v01 == 2
	replace verified_member_part_score = 0.0 if m8_v01 == 3
	gen double verified_multimember_val_score = .
	replace verified_multimember_val_score = 1.0 if m8_v02 == 1
	replace verified_multimember_val_score = 0.5 if m8_v02 == 2
	replace verified_multimember_val_score = 0.0 if m8_v02 == 3
	label var verified_member_part_score "Enumerator-verified more than one member participates, 0-1"
	label var verified_multimember_val_score "Enumerator-verified decisions validated by more than one member, 0-1"

	egen idx_committee_functioning = rowmean(collective_handling_score active_member_part_score ///
		collective_discussion_score women_participation_score women_perspective_mechanism ///
		record_validation_score case_review_score decision_process_score similar_case_consistency_score ///
		procedure_confidence_score verified_member_part_score verified_multimember_val_score)
	label var idx_committee_functioning "Index: LCC committee sitting and collective decision-making, 0-1"

	*-------------------------------*
	**# 14. Module 9: legitimacy    *
	*-------------------------------*
	gen double perceived_lcc_fairness_score = (m9_q12 - 1) / 4 if inrange(m9_q12,1,5)
	gen double perc_willing_use_lcc_score = (m9_q14 - 1) / 4 if inrange(m9_q14,1,5)
	gen double bypass_frequency_score = m9_q15 / 4 if inrange(m9_q15,0,4)
	gen double low_bypass_score = 1 - bypass_frequency_score if !missing(bypass_frequency_score)
	gen double perc_favor_influence_score = (m9_q17 - 1) / 4 if inrange(m9_q17,1,5)
	gen double low_favoritism_influence_score = 1 - perc_favor_influence_score if !missing(perc_favor_influence_score)
	gen double conf_trust_when_referring = m9_q18 / 4 if inrange(m9_q18,0,4)
	gen double conf_fair_respect_score = m9_q19 / 4 if inrange(m9_q19,0,4)
	label var perceived_lcc_fairness_score "Perceived community view of LCC fairness, 0-1"
	label var perc_willing_use_lcc_score "Perceived willingness of community to use LCC for eligible petty disputes, 0-1"
	label var bypass_frequency_score "Perceived frequency of bypassing LCC for eligible petty disputes, 0-1"
	label var low_bypass_score "Inverse bypass score: higher means less perceived bypass, 0-1"
	label var perc_favor_influence_score "Perceived influence of connections/favoritism/gifts/pressure, 0-1"
	label var low_favoritism_influence_score "Inverse favoritism/corruption-risk score, 0-1"
	label var conf_trust_when_referring "Confidence maintaining trust while referring serious/ineligible cases, 0-1"
	label var conf_fair_respect_score "Confidence LCC handles petty disputes fairly/respectfully, 0-1"

	gen byte bypass_due_distrust = m9_q16_3 == 1 if !missing(m9_q16_3)
	gen byte bypass_due_bias = m9_q16_4 == 1 if !missing(m9_q16_4)
	gen byte bypass_due_enforcement = m9_q16_5 == 1 if !missing(m9_q16_5)
	gen byte bypass_due_mandate_uncertainty = m9_q16_6 == 1 if !missing(m9_q16_6)
	gen byte bypass_due_serious_case = m9_q16_7 == 1 if !missing(m9_q16_7)
	gen byte eligible_cases_rarely_bypass = m9_q16_11 == 1 if !missing(m9_q16_11)
	label var bypass_due_distrust "Bypass reason: community does not trust LCC"
	label var bypass_due_bias "Bypass reason: perceived LCC bias/favoritism"
	label var bypass_due_enforcement "Bypass reason: LCC cannot enforce agreements/decisions"
	label var bypass_due_mandate_uncertainty "Bypass reason: people do not know which cases LCC can handle"
	label var bypass_due_serious_case "Bypass reason: case is serious and should go to police/court"
	label var eligible_cases_rarely_bypass "Respondent says people rarely bypass LCC for eligible petty cases"
	label values bypass_due_distrust bypass_due_bias bypass_due_enforcement bypass_due_mandate_uncertainty ///
		bypass_due_serious_case eligible_cases_rarely_bypass yesno

	egen idx_perceived_legitimacy = rowmean(perceived_lcc_fairness_score perc_willing_use_lcc_score ///
		low_bypass_score low_favoritism_influence_score conf_trust_when_referring ///
		conf_fair_respect_score)
	label var idx_perceived_legitimacy "Index: perceived LCC fairness, legitimacy, and low bypass/corruption risk, 0-1"

	*-------------------------------*
	**# 15. Module 10: safeguards   *
	*-------------------------------*
	* The fielded baseline did not collect usable values for M10_Q08 and M10_V01/V02
	* in the raw WIDE export. These variables must remain missing and must not be
	* converted into zeros. The safeguards index therefore uses the observed M10_Q07
	* item and the serious/sensitive-case classification knowledge index from Module 4.

	foreach v in m10_q07 m10_v01 m10_v02 {
		capture confirm variable `v'
		if _rc gen double `v' = .
	}

	foreach v in m10_q08_1 m10_q08_2 m10_q08_3 m10_q08_4 m10_q08_5 m10_q08_6 m10_q08_7 {
		capture confirm variable `v'
		if _rc gen double `v' = .
	}

	capture drop vulnerable_need_sh
	gen byte vulnerable_need_sh = m10_q07 == 1 if inlist(m10_q07,0,1,98)
	label var vulnerable_need_sh "Respondent says vulnerable/sensitive cases require special handling"
	label values vulnerable_need_sh yesno

	capture drop n_m10_q08_nonmiss n_special_handling_practices special_handling_practices_score ///
		sh_includes_confidentiality sh_includes_referral sh_avoid_unsafe_mediation
	egen n_m10_q08_nonmiss = rownonmiss(m10_q08_1 m10_q08_2 m10_q08_3 m10_q08_4 m10_q08_5 m10_q08_6 m10_q08_7)
	label var n_m10_q08_nonmiss "Number of non-missing M10_Q08 special-handling items"

	egen n_special_handling_practices = rowtotal(m10_q08_1 m10_q08_2 m10_q08_3 m10_q08_4 m10_q08_5 m10_q08_6 m10_q08_7), missing
	replace n_special_handling_practices = . if m10_q07 != 1 | n_m10_q08_nonmiss == 0
	gen double special_handling_practices_score = n_special_handling_practices / 7 if !missing(n_special_handling_practices)
	label var n_special_handling_practices "Number of special-handling practices identified for vulnerable/sensitive cases"
	label var special_handling_practices_score "Special-handling knowledge breadth score, 0-1"

	gen byte sh_includes_confidentiality = m10_q08_1 == 1 if m10_q07 == 1 & n_m10_q08_nonmiss > 0
	gen byte sh_includes_referral        = m10_q08_3 == 1 if m10_q07 == 1 & n_m10_q08_nonmiss > 0
	gen byte sh_avoid_unsafe_mediation   = m10_q08_4 == 1 if m10_q07 == 1 & n_m10_q08_nonmiss > 0
	label var sh_includes_confidentiality "Special handling includes confidentiality"
	label var sh_includes_referral "Special handling includes referral"
	label var sh_avoid_unsafe_mediation "Special handling includes avoiding unsafe mediation"
	label values sh_includes_confidentiality sh_includes_referral sh_avoid_unsafe_mediation yesno

	capture drop verif_sensitive_ref_score verif_sensitive_conf_score
	gen double verif_sensitive_ref_score = .
	replace verif_sensitive_ref_score = 1.0 if m10_v01 == 1
	replace verif_sensitive_ref_score = 0.5 if m10_v01 == 2
	replace verif_sensitive_ref_score = 0.0 if m10_v01 == 3
	label var verif_sensitive_ref_score "Enumerator-verified sensitive/serious cases marked as referred, 0-1"

	gen double verif_sensitive_conf_score = .
	replace verif_sensitive_conf_score = 1.0 if m10_v02 == 1
	replace verif_sensitive_conf_score = 0.5 if m10_v02 == 2
	replace verif_sensitive_conf_score = 0.0 if m10_v02 == 3
	label var verif_sensitive_conf_score "Enumerator-verified sensitive case record confidentiality, 0-1"

	capture confirm variable idx_safeguard_classif_know
	if _rc {
		gen double idx_safeguard_classif_know = .
		label var idx_safeguard_classif_know "Index: sensitive-case classification knowledge, 0-1"
	}

	capture drop idx_safeguards
	egen idx_safeguards = rowmean(idx_safeguard_classif_know vulnerable_need_sh)
	label var idx_safeguards "Index: sensitive-case safeguards and referral knowledge, 0-1"

	*-------------------------------*
	**# 16. Module 11: reintegration
	*-------------------------------*
	gen double reintegration_importance_score = m11_q02 / 4 if inrange(m11_q02,0,4)
	gen double reintegration_willingness_score = m11_q03 / 4 if inrange(m11_q03,0,4)
	gen double fair_chance_reintegration_score = (m11_q04 - 1) / 4 if inrange(m11_q04,1,5)
	gen double exclusion_norm_score = (m11_q05 - 1) / 4 if inrange(m11_q05,1,5)
	gen double low_exclusion_norm_score = 1 - exclusion_norm_score if !missing(exclusion_norm_score)
	gen double perceived_reoffending_risk_score = (m11_q06 - 1) / 4 if inrange(m11_q06,1,5)
	gen double low_reoffending_stigma_score = 1 - perceived_reoffending_risk_score if !missing(perceived_reoffending_risk_score)
	gen double comm_role_reint_score = (m11_q07 - 1) / 4 if inrange(m11_q07,1,5)
	gen double reint_mediation_comfort = m11_q08 / 4 if inrange(m11_q08,0,4)
	gen double connect_support_willing_score = m11_q09 / 4 if inrange(m11_q09,0,4)
	gen double community_stigma_level_score = (m11_q11 - 1) / 4 if inrange(m11_q11,1,5)
	label var reintegration_importance_score "Importance of community leaders supporting reintegration, 0-1"
	label var reintegration_willingness_score "Willingness to support peaceful return of formerly incarcerated persons, 0-1"
	label var fair_chance_reintegration_score "Agreement that formerly incarcerated persons deserve fair chance, 0-1"
	label var low_exclusion_norm_score "Reverse-coded norm against avoiding formerly incarcerated persons, 0-1"
	label var low_reoffending_stigma_score "Reverse-coded belief that most formerly incarcerated persons reoffend, 0-1"
	label var comm_role_reint_score "Agreement community has role in avoiding future conflict/offending, 0-1"
	label var reint_mediation_comfort "Comfort mediating eligible disputes involving formerly incarcerated persons, 0-1"
	label var connect_support_willing_score "Willingness to connect formerly incarcerated person to support/resources, 0-1"
	label var community_stigma_level_score "Perceived level of community stigma toward formerly incarcerated persons, 0-1"

	egen n_reintegration_support_types = rowtotal(m11_q10_1 m11_q10_2 m11_q10_3 m11_q10_4 m11_q10_5 m11_q10_6 m11_q10_7 m11_q10_8)
	gen double reint_support_breadth_score = n_reintegration_support_types / 8 if !missing(n_reintegration_support_types)
	gen byte no_reintegration_support_needed = m11_q10_9 == 1 if !missing(m11_q10_9)
	label var n_reintegration_support_types "Number of support types identified for successful reintegration"
	label var reint_support_breadth_score "Breadth of reintegration support identified, 0-1"
	label var no_reintegration_support_needed "Respondent says formerly incarcerated persons should manage on their own"
	label values no_reintegration_support_needed yesno

	egen n_reintegration_barriers = rowtotal(m11_q12_1 m11_q12_2 m11_q12_3 m11_q12_4 m11_q12_5 m11_q12_6 m11_q12_7 m11_q12_8)
	gen byte comm_accepts_ex_prisoner = m11_q12_9 == 1 if !missing(m11_q12_9)
	label var n_reintegration_barriers "Number of perceived barriers to accepting/supporting formerly incarcerated persons"
	label var comm_accepts_ex_prisoner "Respondent says community members are usually willing to accept them"
	label values comm_accepts_ex_prisoner yesno

	gen byte recent_reintegration_issue = m11_q13 == 1 if inlist(m11_q13,0,1,98)
	label var recent_reintegration_issue "LCC handled reintegration-related dispute/tension/concern in past 6 months"
	label values recent_reintegration_issue yesno

	* M11_Q14 was not observed in the fielded baseline WIDE export. Do not treat
	* missing split select-multiple items as zeros.
	foreach v in m11_q14_1 m11_q14_2 m11_q14_3 m11_q14_4 m11_q14_5 m11_q14_6 m11_q14_7 m11_q14_8 {
		capture confirm variable `v'
		if _rc gen double `v' = .
	}
	capture drop n_m11_q14_nonmiss n_reintegration_issue_types recent_reint_stigma recent_reint_serious_ref
	egen n_m11_q14_nonmiss = rownonmiss(m11_q14_1 m11_q14_2 m11_q14_3 m11_q14_4 m11_q14_5 m11_q14_6 m11_q14_7 m11_q14_8)
	egen n_reintegration_issue_types = rowtotal(m11_q14_1 m11_q14_2 m11_q14_3 m11_q14_4 m11_q14_5 m11_q14_6 m11_q14_7 m11_q14_8), missing
	replace n_reintegration_issue_types = . if m11_q13 != 1 | n_m11_q14_nonmiss == 0
	gen byte recent_reint_stigma = m11_q14_4 == 1 if m11_q13 == 1 & n_m11_q14_nonmiss > 0
	gen byte recent_reint_serious_ref = m11_q14_8 == 1 if m11_q13 == 1 & n_m11_q14_nonmiss > 0
	label var n_m11_q14_nonmiss "Number of non-missing M11_Q14 reintegration issue-type items"
	label var n_reintegration_issue_types "Number of recent reintegration-related issue types handled"
	label var recent_reint_stigma "Recent reintegration issue involved stigma/exclusion/refusal to accept"
	label var recent_reint_serious_ref "Recent reintegration issue involved serious allegation requiring referral"
	label values recent_reint_stigma recent_reint_serious_ref yesno

	gen byte reint_response_supportive = inlist(m11_q15,1,2,3,4,6) if m11_q13 == 1 & (inrange(m11_q15,1,6) | m11_q15 == 98)
	label var reint_response_supportive "LCC response to recent reintegration issue was active/supportive or referral-oriented"
	label values reint_response_supportive yesno

	gen double reint_tension_conf_score = m11_q16 / 4 if inrange(m11_q16,0,4)
	gen double reint_referral_conf_score = m11_q17 / 4 if inrange(m11_q17,0,4)
	gen byte reint_comm_justice_role = m11_q18 == 1 if inlist(m11_q18,0,1,98)
	label var reint_tension_conf_score "Confidence LCC can reduce reintegration-related community tensions, 0-1"
	label var reint_referral_conf_score "Confidence knowing where to refer formerly incarcerated persons for support, 0-1"
	label var reint_comm_justice_role "Support for reintegration is part of community justice/local leadership role"
	label values reint_comm_justice_role yesno

	* M11_Q19 was not observed in the fielded baseline WIDE export. Do not treat
	* missing split select-multiple items as zeros.
	foreach v in m11_q19_1 m11_q19_2 m11_q19_3 m11_q19_4 m11_q19_5 m11_q19_6 m11_q19_7 {
		capture confirm variable `v'
		if _rc gen double `v' = .
	}
	capture drop n_m11_q19_nonmiss n_reintegration_leadership_roles reint_leadership_role_score
	egen n_m11_q19_nonmiss = rownonmiss(m11_q19_1 m11_q19_2 m11_q19_3 m11_q19_4 m11_q19_5 m11_q19_6 m11_q19_7)
	egen n_reintegration_leadership_roles = rowtotal(m11_q19_1 m11_q19_2 m11_q19_3 m11_q19_4 m11_q19_5 m11_q19_6 m11_q19_7), missing
	replace n_reintegration_leadership_roles = . if m11_q18 != 1 | n_m11_q19_nonmiss == 0
	gen double reint_leadership_role_score = n_reintegration_leadership_roles / 7 if !missing(n_reintegration_leadership_roles)
	label var n_m11_q19_nonmiss "Number of non-missing M11_Q19 reintegration leadership-role items"
	label var n_reintegration_leadership_roles "Number of reintegration roles identified for LC/community leaders"
	label var reint_leadership_role_score "Breadth of LC/community leader reintegration roles identified, 0-1"

	egen idx_reintegration_norms = rowmean(reintegration_importance_score reintegration_willingness_score ///
		fair_chance_reintegration_score low_exclusion_norm_score low_reoffending_stigma_score ///
		comm_role_reint_score reint_mediation_comfort connect_support_willing_score ///
		reint_support_breadth_score reint_tension_conf_score ///
		reint_referral_conf_score reint_comm_justice_role reint_leadership_role_score)
	label var idx_reintegration_norms "Index: pro-reintegration attitudes, willingness, and perceived support capacity, 0-1"

	*-------------------------------*
	**# 17. Cross-module indices    *
	*-------------------------------*
	* Composite indices are recomputed after all module-level corrections. Each
	* source index is scaled 0-1. rowmean() keeps observations when at least one
	* component is non-missing.

	foreach v in idx_respondent_capacity idx_institutional_functioning idx_legal_classif_knowledge ///
		idx_adr_mediation_practice idx_referral_practice idx_record_quality idx_committee_functioning ///
		idx_perceived_legitimacy idx_safeguards idx_reintegration_norms {
		capture confirm variable `v'
		if _rc {
			gen double `v' = .
			label var `v' "Missing placeholder for module index: `v'"
		}
	}

	foreach v in idx_lcc_operational_capacity idx_lcc_case_handling_quality ///
		idx_lcc_legitimacy_and_norms idx_p1_base_mentor_ready_proxy ///
		high_operational_capacity high_case_handling_quality high_legitimacy_norms high_mentor_readiness_proxy {
		capture drop `v'
	}

	egen idx_lcc_operational_capacity = rowmean(idx_institutional_functioning idx_record_quality idx_committee_functioning)
	label var idx_lcc_operational_capacity "Composite index: LCC operational capacity, 0-1"

	egen idx_lcc_case_handling_quality = rowmean(idx_legal_classif_knowledge idx_adr_mediation_practice ///
		idx_referral_practice idx_safeguards)
	label var idx_lcc_case_handling_quality "Composite index: LCC case-handling quality, 0-1"

	egen idx_lcc_legitimacy_and_norms = rowmean(idx_perceived_legitimacy idx_reintegration_norms)
	label var idx_lcc_legitimacy_and_norms "Composite index: perceived legitimacy and reintegration norms, 0-1"

	egen idx_p1_base_mentor_ready_proxy = rowmean(idx_respondent_capacity idx_lcc_operational_capacity ///
		idx_lcc_case_handling_quality idx_lcc_legitimacy_and_norms)
	label var idx_p1_base_mentor_ready_proxy "Baseline proxy index for potential mentor readiness, 0-1"

	* Useful binary markers for descriptive subgroup analysis. The .75 cutoff is a
	* descriptive flag, not a final mentor eligibility rule.
	gen byte high_operational_capacity = idx_lcc_operational_capacity >= .75 if !missing(idx_lcc_operational_capacity)
	gen byte high_case_handling_quality = idx_lcc_case_handling_quality >= .75 if !missing(idx_lcc_case_handling_quality)
	gen byte high_legitimacy_norms = idx_lcc_legitimacy_and_norms >= .75 if !missing(idx_lcc_legitimacy_and_norms)
	gen byte high_mentor_readiness_proxy = idx_p1_base_mentor_ready_proxy >= .75 if !missing(idx_p1_base_mentor_ready_proxy)
	label values high_operational_capacity high_case_handling_quality high_legitimacy_norms high_mentor_readiness_proxy yesno
	label var high_operational_capacity "Operational capacity index >= 0.75"
	label var high_case_handling_quality "Case-handling quality index >= 0.75"
	label var high_legitimacy_norms "Legitimacy and reintegration norms index >= 0.75"
	label var high_mentor_readiness_proxy "Baseline mentor-readiness proxy index >= 0.75"

	foreach v in idx_respondent_capacity idx_institutional_functioning idx_legal_classif_knowledge ///
		idx_adr_mediation_practice idx_referral_practice idx_record_quality idx_committee_functioning ///
		idx_perceived_legitimacy idx_safeguards idx_reintegration_norms ///
		idx_lcc_operational_capacity idx_lcc_case_handling_quality idx_lcc_legitimacy_and_norms ///
		idx_p1_base_mentor_ready_proxy {
		quietly count if !missing(`v') & (`v' < 0 | `v' > 1)
		if r(N) > 0 {
			dis as error "Warning: `v' has values outside [0,1]. Check scoring."
		}
	}

	*-------------------------------*
	**# 18. Data-quality flags      *
	*-------------------------------*
	egen n_inconsistency_flags = rowtotal(flag_duplicate_submission_key flag_duplicate_scto_village ///
		flag_duration_short flag_duration_long flag_date_outside_fieldwork flag_caseload_30d_gt_3m ///
		flag_pending_gt_3m flag_direct_gt_3m flag_referred_to_lcc_gt_3m flag_referred_onward_gt_3m)
	label var n_inconsistency_flags "Number of automated data-quality/inconsistency flags"

	gen byte flag_any_data_quality_issue = n_inconsistency_flags > 0 if !missing(n_inconsistency_flags)
	label var flag_any_data_quality_issue "Record has at least one automated data-quality/inconsistency flag"
	label values flag_any_data_quality_issue yesno

	* Missingness across main analytic indices
	egen n_missing_core_indices = rowmiss(idx_respondent_capacity idx_institutional_functioning idx_legal_classif_knowledge ///
		idx_adr_mediation_practice idx_referral_practice idx_record_quality idx_committee_functioning ///
		idx_perceived_legitimacy idx_safeguards idx_reintegration_norms)
	label var n_missing_core_indices "Number of missing main module indices"

	*-------------------------------*
	**# 19. Order and notes         *
	*-------------------------------*
	order survey_record_id submission_key instance_id analysis_sample submissiondate_dt starttime_dt endtime_dt ///
		interview_date interview_hour duration duration_min enum consent ///
		district_scto subcounty_scto parish_scto village_scto survey_village_uid survey_village_id ///
		actual_district actual_subcounty actual_parish actual_village is_replacement_village ///
		prior_cdfu_fhri_training n_prior_training_topics rating_cdfu_training_clean ///
		idx_respondent_capacity idx_institutional_functioning idx_legal_classif_knowledge ///
		idx_adr_mediation_practice idx_referral_practice idx_record_quality idx_committee_functioning ///
		idx_perceived_legitimacy idx_safeguards idx_reintegration_norms ///
		idx_lcc_operational_capacity idx_lcc_case_handling_quality idx_lcc_legitimacy_and_norms ///
		idx_p1_base_mentor_ready_proxy high_mentor_readiness_proxy ///
		n_inconsistency_flags flag_any_data_quality_issue n_missing_core_indices, first

	note: Phase 1 baseline is a pre-training/direct-training and mentor-readiness survey, not the causal RCT stage.
	note: Original SurveyCTO variables are preserved; cleaned analysis variables and indices are added by this data-preparation block.
	note: Replacement village corrections require a future record-level mapping from SurveyCTO submission key to actual replacement village visited.
	note: Module 9 and Module 10 were shortened in the fielded Runyankore instrument; indices use only fielded items.

*------------------------------------------------------------------------------*
**# X. Administrative Phase 1 origin: new vs previously contacted villages
*------------------------------------------------------------------------------*
* Source of truth:
*   Final Village List.xlsx
*
* Definition:
*   Previously contacted / added villages are those marked as:
*       Last_CDFU_phase == 1 OR Ineherited_FHRI == 1
*
* Important:
*   This block DOES NOT use the self-reported survey question on prior CDFU/FHRI
*   training. It hard-codes the administrative classification using the matched
*   SurveyCTO submission_key for each of the 28 admin-added villages.
*
* Resulting variables:
*   p1_admin_last_cdfu              = 1 if village was part of the last CDFU phase
*   p1_admin_inherited_fhri         = 1 if village was inherited from FHRI
*   p1_admin_previously_contacted   = 1 if either of the two above is true
*   p1_admin_new                    = 1 if not previously contacted/admin-added
*   p1_admin_origin                 = categorical version for graphs/tables
*------------------------------------------------------------------------------*

capture confirm variable submission_key
if _rc {
    display as error "submission_key not found. Run this block after SurveyCTO metadata cleaning."
    exit 111
}

capture drop p1_admin_last_cdfu
capture drop p1_admin_inherited_fhri
capture drop p1_admin_previously_contacted
capture drop p1_admin_new
capture drop p1_admin_origin
capture drop p1_admin_origin_detail
capture drop p1_admin_match_note

gen byte p1_admin_last_cdfu = 0
gen byte p1_admin_inherited_fhri = 0
gen byte p1_admin_previously_contacted = 0
gen byte p1_admin_new = .
gen byte p1_admin_origin = 0
gen str35 p1_admin_origin_detail = "New / randomly selected"
gen strL p1_admin_match_note = ""

label var p1_admin_last_cdfu ///
    "Admin list: village belongs to last CDFU phase"

label var p1_admin_inherited_fhri ///
    "Admin list: village inherited from FHRI"

label var p1_admin_previously_contacted ///
    "Admin list: previously contacted/added village"

label var p1_admin_new ///
    "Admin list: new/randomly selected Phase 1 village"

label var p1_admin_origin ///
    "Admin list Phase 1 origin group"

label var p1_admin_origin_detail ///
    "Text label for admin Phase 1 origin group"

label var p1_admin_match_note ///
    "Audit note: admin village matched to SurveyCTO submission"

*-------------------------------*
* 1. Last CDFU phase villages   *
*-------------------------------*
* 20 records marked Last_CDFU_phase == 1 in the admin list.

* 1. Bushenyi / Kakanju / Katunga / Kakuto A
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:2f6ce7c1-25ca-4f25-b5bc-32d4514ea791"
replace p1_admin_match_note = "Last CDFU: Bushenyi / Kakanju / Katunga / Kakuto A" ///
    if submission_key == "uuid:2f6ce7c1-25ca-4f25-b5bc-32d4514ea791"

* 2. Bushenyi / Kizinda Town Council / Nyabubare / Nyakinengo
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:2190d328-1a42-4f7b-874d-a670dda437fe"
replace p1_admin_match_note = "Last CDFU: Bushenyi / Kizinda Town Council / Nyabubare / Nyakinengo" ///
    if submission_key == "uuid:2190d328-1a42-4f7b-874d-a670dda437fe"

* 3. Bushenyi / Kizinda Town Council / Nyabubare / Masya
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:e82dde24-05b4-42f0-b13d-f6a2feae07c8"
replace p1_admin_match_note = "Last CDFU: Bushenyi / Kizinda Town Council / Nyabubare / Masya" ///
    if submission_key == "uuid:e82dde24-05b4-42f0-b13d-f6a2feae07c8"

* 4. Bushenyi / Kizinda Town Council / Kizinda ward / Kitooma
* SurveyCTO parish appears as Kizinda.
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:e4eba94b-b137-4abe-b8b2-115029c6562d"
replace p1_admin_match_note = "Last CDFU: Bushenyi / Kizinda Town Council / Kizinda ward / Kitooma; SurveyCTO parish=Kizinda" ///
    if submission_key == "uuid:e4eba94b-b137-4abe-b8b2-115029c6562d"

* 5. Bushenyi / Kyamuhunga / Butaare / Nyambugye
* Matched to SurveyCTO: Kyamuhunga Town / Butare / Nyampungye.
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:b137e053-2461-47a4-acc5-71b556a9d5c6"
replace p1_admin_match_note = "Last CDFU: Bushenyi / Kyamuhunga / Butaare / Nyambugye; matched to SurveyCTO Kyamuhunga Town / Butare / Nyampungye" ///
    if submission_key == "uuid:b137e053-2461-47a4-acc5-71b556a9d5c6"

* 6. Rubirizi / Kirugu / Kikumbo / Omukabare B
* SurveyCTO records this as Omukabare. There are duplicate Omukabare records;
* this submission key is the admin-added Omukabare B match.
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:eb7cfbf9-785f-4af3-9d19-0fbcb8028a1e"
replace p1_admin_match_note = "Last CDFU: Rubirizi / Kirugu / Kikumbo / Omukabare B; matched to duplicate SurveyCTO Omukabare record by submission key" ///
    if submission_key == "uuid:eb7cfbf9-785f-4af3-9d19-0fbcb8028a1e"

* 7. Rubirizi / Kirugu / Kirugu / Kirugu 2 B
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:8a21f548-2b3c-47f0-ae07-34354de0b0f5"
replace p1_admin_match_note = "Last CDFU: Rubirizi / Kirugu / Kirugu / Kirugu 2 B" ///
    if submission_key == "uuid:8a21f548-2b3c-47f0-ae07-34354de0b0f5"

* 8. Rubirizi / Ryeru / Ndekye / Ryeru
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:d2517598-b6eb-4885-9e14-c67dcfca649b"
replace p1_admin_match_note = "Last CDFU: Rubirizi / Ryeru / Ndekye / Ryeru" ///
    if submission_key == "uuid:d2517598-b6eb-4885-9e14-c67dcfca649b"

* 9. Rubirizi / Kicwamba / Kicwamba / Kyesama
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:b8cecd9f-74bb-4ed8-b18c-bd0cda597f51"
replace p1_admin_match_note = "Last CDFU: Rubirizi / Kicwamba / Kicwamba / Kyesama" ///
    if submission_key == "uuid:b8cecd9f-74bb-4ed8-b18c-bd0cda597f51"

* 10. Rubirizi / Rubirizi Town / Nyakasharu / Kyakabunda
* SurveyCTO subcounty appears as Katerera Town council.
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:fb35c3d3-798e-416a-b9a8-369376d34615"
replace p1_admin_match_note = "Last CDFU: Rubirizi / Rubirizi Town / Nyakasharu / Kyakabunda; SurveyCTO subcounty=Katerera Town council" ///
    if submission_key == "uuid:fb35c3d3-798e-416a-b9a8-369376d34615"

* 11. Rubirizi / Kirugu / Kirugu / Mirarikye
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:4dee5693-f48a-40c7-824b-4d3c8d139419"
replace p1_admin_match_note = "Last CDFU: Rubirizi / Kirugu / Kirugu / Mirarikye" ///
    if submission_key == "uuid:4dee5693-f48a-40c7-824b-4d3c8d139419"

* 12. Sheema / Masheruka sub county / Nyakambu / Nyakambu
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:351c6894-28fb-4dab-8acb-b2113d20e1d1"
replace p1_admin_match_note = "Last CDFU: Sheema / Masheruka sub county / Nyakambu / Nyakambu" ///
    if submission_key == "uuid:351c6894-28fb-4dab-8acb-b2113d20e1d1"

* 13. Sheema / Masheruka sub county / Nyakambu / Migera
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:6fc4e7f6-3f62-45b5-9d68-5125574a73fa"
replace p1_admin_match_note = "Last CDFU: Sheema / Masheruka sub county / Nyakambu / Migera" ///
    if submission_key == "uuid:6fc4e7f6-3f62-45b5-9d68-5125574a73fa"

* 14. Sheema / Masheruka sub county / Mabare / Rwichumu
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:b1999bec-89d4-477b-b49e-15838313a589"
replace p1_admin_match_note = "Last CDFU: Sheema / Masheruka sub county / Mabare / Rwichumu" ///
    if submission_key == "uuid:b1999bec-89d4-477b-b49e-15838313a589"

* 15. Sheema / Masheruka sub county / Mabare / Nyakanoni
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:53f4f023-bebc-4bc6-abc3-ccb212d97b7d"
replace p1_admin_match_note = "Last CDFU: Sheema / Masheruka sub county / Mabare / Nyakanoni" ///
    if submission_key == "uuid:53f4f023-bebc-4bc6-abc3-ccb212d97b7d"

* 16. Sheema / Masheruka sub county / Buringo / Mukono 1
* SurveyCTO subcounty appears as Masheruka TC.
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:d722a4c7-2bfb-49ab-8858-646fb94e9475"
replace p1_admin_match_note = "Last CDFU: Sheema / Masheruka sub county / Buringo / Mukono 1; SurveyCTO subcounty=Masheruka TC" ///
    if submission_key == "uuid:d722a4c7-2bfb-49ab-8858-646fb94e9475"

* 17. Sheema / Kabwohe Division / Kabwohe / Market cell
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:adb21efa-2e1c-48b5-9caa-f6875cdfefa0"
replace p1_admin_match_note = "Last CDFU: Sheema / Kabwohe Division / Kabwohe / Market cell" ///
    if submission_key == "uuid:adb21efa-2e1c-48b5-9caa-f6875cdfefa0"

* 18. Sheema / Kabwohe Division / Rutoma / Kabwohe A
* SurveyCTO parish appears as Kabwohe.
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:b445a616-8864-4508-a15c-f8f3deccabb3"
replace p1_admin_match_note = "Last CDFU: Sheema / Kabwohe Division / Rutoma / Kabwohe A; SurveyCTO parish=Kabwohe" ///
    if submission_key == "uuid:b445a616-8864-4508-a15c-f8f3deccabb3"

* 19. Sheema / Kabwohe Division / Nyanga ward / Mabaga Cell
* SurveyCTO parish appears as Nyanga.
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:175fe80a-15d4-4f74-92b5-619f94854830"
replace p1_admin_match_note = "Last CDFU: Sheema / Kabwohe Division / Nyanga ward / Mabaga Cell; SurveyCTO parish=Nyanga" ///
    if submission_key == "uuid:175fe80a-15d4-4f74-92b5-619f94854830"

* 20. Sheema / Kabwohe Division / Kabwohe / Kabwohe central
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:9bf5edc8-e555-40e1-8e3f-589f03b4a8ce"
replace p1_admin_match_note = "Last CDFU: Sheema / Kabwohe Division / Kabwohe / Kabwohe central" ///
    if submission_key == "uuid:9bf5edc8-e555-40e1-8e3f-589f03b4a8ce"

* 21. Rubirizi / Katerera Town council / Katerera / Kikonjo
* SurveyCTO records this as Bushenyi / Katerera Town council / Katerera ward / Kikonjo.
replace p1_admin_last_cdfu = 1 if submission_key == "uuid:2b9d305d-d058-42db-a4d8-b98643c9570c"
replace p1_admin_match_note = "Last CDFU: Rubirizi / Katerera Town council / Katerera / Kikonjo; SurveyCTO records district as Bushenyi and parish as Katerera ward" ///
    if submission_key == "uuid:2b9d305d-d058-42db-a4d8-b98643c9570c"

*-------------------------------*
* 2. Inherited FHRI villages    *
*-------------------------------*
* 8 records marked Ineherited_FHRI == 1 in the admin list.

* 22. Rubirizi / Katerera Town council / Katerera / KIZIRA CELL
* SurveyCTO parish appears as Katerera ward.
replace p1_admin_inherited_fhri = 1 if submission_key == "uuid:330d6791-29c9-4ce9-9f0c-e5a516a88665"
replace p1_admin_match_note = "Inherited FHRI: Rubirizi / Katerera Town council / Katerera / KIZIRA CELL; SurveyCTO parish=Katerera ward" ///
    if submission_key == "uuid:330d6791-29c9-4ce9-9f0c-e5a516a88665"

* 23. Rubirizi / Katerera Town council / Katerera / KACU CELL
* SurveyCTO subcounty appears as Kizinda Town Council and parish as Katerera ward.
replace p1_admin_inherited_fhri = 1 if submission_key == "uuid:2c4d99f2-3f5f-4e44-93e4-337b40b98c7f"
replace p1_admin_match_note = "Inherited FHRI: Rubirizi / Katerera Town council / Katerera / KACU CELL; SurveyCTO subcounty=Kizinda Town Council, parish=Katerera ward" ///
    if submission_key == "uuid:2c4d99f2-3f5f-4e44-93e4-337b40b98c7f"

* 24. Rubirizi / Katerera Town council / Katerera / RWENTOSHO I
* SurveyCTO subcounty appears as Kizinda Town Council and parish as Katerera ward.
replace p1_admin_inherited_fhri = 1 if submission_key == "uuid:db45a481-5312-4553-a9fc-85343aa34e88"
replace p1_admin_match_note = "Inherited FHRI: Rubirizi / Katerera Town council / Katerera / RWENTOSHO I; SurveyCTO subcounty=Kizinda Town Council, parish=Katerera ward" ///
    if submission_key == "uuid:db45a481-5312-4553-a9fc-85343aa34e88"

* 25. Bushenyi / Kyamuhunga sub county / Nsumi / NYAMPUGYE
* SurveyCTO village spelling appears as Nyampungye.
replace p1_admin_inherited_fhri = 1 if submission_key == "uuid:694df33a-02e6-4c3c-a2cd-112001068039"
replace p1_admin_match_note = "Inherited FHRI: Bushenyi / Kyamuhunga sub county / Nsumi / NYAMPUGYE; SurveyCTO village=Nyampungye" ///
    if submission_key == "uuid:694df33a-02e6-4c3c-a2cd-112001068039"

* 26. Bushenyi / Kyamuhunga sub county / Mashonga / KYAMABARE
* SurveyCTO subcounty appears as Kyamuhunga Town.
replace p1_admin_inherited_fhri = 1 if submission_key == "uuid:19a8b7cb-3020-4b6a-9334-8082aa9e84e2"
replace p1_admin_match_note = "Inherited FHRI: Bushenyi / Kyamuhunga sub county / Mashonga / KYAMABARE; SurveyCTO subcounty=Kyamuhunga Town" ///
    if submission_key == "uuid:19a8b7cb-3020-4b6a-9334-8082aa9e84e2"

* 27. Bushenyi / Kyamuhunga sub county / Kibazi / NYAKAZINGA
* SurveyCTO parish appears as Mashonga.
replace p1_admin_inherited_fhri = 1 if submission_key == "uuid:e797533b-8e6d-44fd-9acb-730d417beac9"
replace p1_admin_match_note = "Inherited FHRI: Bushenyi / Kyamuhunga sub county / Kibazi / NYAKAZINGA; SurveyCTO subcounty=Kyamuhunga Town, parish=Mashonga" ///
    if submission_key == "uuid:e797533b-8e6d-44fd-9acb-730d417beac9"

* 28. Bushenyi / Kyamuhunga sub county / Mashonga / Nyamabare
* SurveyCTO subcounty appears as Kyamuhunga Town.
replace p1_admin_inherited_fhri = 1 if submission_key == "uuid:1b6b6511-7ad1-4574-8313-ff38b799c6fd"
replace p1_admin_match_note = "Inherited FHRI: Bushenyi / Kyamuhunga sub county / Mashonga / Nyamabare; SurveyCTO subcounty=Kyamuhunga Town" ///
    if submission_key == "uuid:1b6b6511-7ad1-4574-8313-ff38b799c6fd"

*-------------------------------*
* 3. Final grouped variables    *
*-------------------------------*

replace p1_admin_previously_contacted = ///
    (p1_admin_last_cdfu == 1 | p1_admin_inherited_fhri == 1)

replace p1_admin_new = 1 - p1_admin_previously_contacted

replace p1_admin_origin = 1 if p1_admin_last_cdfu == 1
replace p1_admin_origin = 2 if p1_admin_inherited_fhri == 1

replace p1_admin_origin_detail = "Last CDFU phase" ///
    if p1_admin_last_cdfu == 1

replace p1_admin_origin_detail = "Inherited FHRI" ///
    if p1_admin_inherited_fhri == 1

capture label drop p1_admin_origin_lbl
label define p1_admin_origin_lbl ///
    0 "New / randomly selected" ///
    1 "Last CDFU phase" ///
    2 "Inherited FHRI"

label values p1_admin_origin p1_admin_origin_lbl

capture label define yesno 0 "No" 1 "Yes", replace
label values p1_admin_last_cdfu yesno
label values p1_admin_inherited_fhri yesno
label values p1_admin_previously_contacted yesno
label values p1_admin_new yesno

*-------------------------------*
* 4. Validation checks          *
*-------------------------------*

display as text "------------------------------------------------------------"
display as text "Administrative Phase 1 origin classification checks"
display as text "------------------------------------------------------------"

count if p1_admin_last_cdfu == 1
display as result "Last CDFU phase records flagged: " r(N)
if r(N) != 21 {
    display as error "WARNING: Expected 21 Last CDFU phase records based on admin list."
}

count if p1_admin_inherited_fhri == 1
display as result "Inherited FHRI records flagged: " r(N)
if r(N) != 7 {
    display as error "WARNING: Expected 7 inherited FHRI records based on admin list."
}

count if p1_admin_previously_contacted == 1
display as result "Total previously contacted/admin-added records flagged: " r(N)
if r(N) != 28 {
    display as error "WARNING: Expected 28 previously contacted/admin-added records."
}

count if p1_admin_last_cdfu == 1 & p1_admin_inherited_fhri == 1
display as result "Records flagged as both Last CDFU and inherited FHRI: " r(N)
if r(N) > 0 {
    display as error "WARNING: Some records are flagged as both Last CDFU and inherited FHRI."
}

tab p1_admin_origin, missing
tab district_scto p1_admin_origin, row missing

* Optional comparison against the self-reported survey item.
* This is diagnostic only; it is NOT used to create the admin dummy.
capture confirm variable prior_cdfu_fhri_training
if !_rc {
    tab p1_admin_previously_contacted prior_cdfu_fhri_training, row missing
}

* List records for audit
list district_scto subcounty_scto parish_scto village_scto ///
     p1_admin_origin_detail p1_admin_match_note ///
     if p1_admin_previously_contacted == 1, sepby(district_scto) noobs abbreviate(24)

display as text "Administrative Phase 1 origin classification completed."
display as text "Use p1_admin_previously_contacted or p1_admin_origin for baseline comparisons."
display as text "------------------------------------------------------------"
	
	*-------------------------------*
	**# 20. Save outputs and QA     *
	*-------------------------------*
	* Save the final corrected outputs. The QA workbook is erased and recreated so
	* stale rows from previous failed runs cannot remain in any sheet.

	save "${input_dir}/2 Working/phase1_baseline_clean.dta", replace

	* Main de-identified analysis export; keeps no phone numbers, chairperson names,
	* or device-level identifiers.
	preserve
		capture drop chairperson_name tel_number devicephonenum deviceid username device_info
		save "${input_dir}/3 Coded/phase1_baseline_analysis.dta", replace
	restore

	local qa_file "${input_dir}/3 Coded/phase1_baseline_data_quality.xlsx"
	capture erase "`qa_file'"

	* QA workbook: record-level flags.
	preserve
		keep survey_record_id submission_key instance_id interview_date duration_min enum ///
			district_scto subcounty_scto parish_scto village_scto actual_village ///
			flag_duplicate_submission_key flag_duplicate_scto_village flag_duration_short flag_duration_long ///
			flag_caseload_30d_gt_3m flag_pending_gt_3m flag_direct_gt_3m flag_referred_to_lcc_gt_3m ///
			flag_referred_onward_gt_3m n_inconsistency_flags flag_any_data_quality_issue
		sort district_scto subcounty_scto parish_scto village_scto survey_record_id
		export excel using "`qa_file'", sheet("record_flags", replace) firstrow(variables)
	restore

	* QA workbook: duplicate SurveyCTO-selected villages.
	preserve
		keep if flag_duplicate_scto_village > 0
		keep survey_record_id submission_key interview_date enum district_scto subcounty_scto parish_scto village_scto ///
			actual_village flag_duplicate_scto_village duration_min
		sort district_scto subcounty_scto parish_scto village_scto interview_date
		export excel using "`qa_file'", sheet("duplicate_scto_villages", replace) firstrow(variables)
	restore

	* QA workbook: corrected index distributions.
	preserve
		keep idx_respondent_capacity idx_institutional_functioning idx_legal_classif_knowledge ///
			idx_adr_mediation_practice idx_referral_practice idx_record_quality idx_committee_functioning ///
			idx_perceived_legitimacy idx_safeguards idx_reintegration_norms ///
			idx_lcc_operational_capacity idx_lcc_case_handling_quality idx_lcc_legitimacy_and_norms ///
			idx_p1_base_mentor_ready_proxy

		gen obs_id = _n
		reshape long idx_, i(obs_id) j(index_name) string
		rename idx_ index_value

		collapse (count) n=index_value ///
			(mean) mean=index_value ///
			(sd) sd=index_value ///
			(p25) p25=index_value ///
			(p50) p50=index_value ///
			(p75) p75=index_value ///
			(min) min=index_value ///
			(max) max=index_value, by(index_name)

		export excel using "`qa_file'", sheet("index_summary", replace) firstrow(variables)
	restore

	* QA workbook: missingness of core variables and indices.
	preserve
		tempname memhold
		tempfile missings
		postfile `memhold' str64 variable long n_missing long n_nonmissing using `missings', replace

		foreach v of varlist submission_key enum consent m0_q04 m0_q05 m0_q06 m0_q07 ///
			idx_respondent_capacity idx_institutional_functioning idx_legal_classif_knowledge ///
			idx_adr_mediation_practice idx_referral_practice idx_record_quality idx_committee_functioning ///
			idx_perceived_legitimacy idx_safeguards idx_reintegration_norms ///
			idx_lcc_operational_capacity idx_lcc_case_handling_quality idx_lcc_legitimacy_and_norms ///
			idx_p1_base_mentor_ready_proxy {

			quietly count if missing(`v')
			local nmiss = r(N)
			quietly count if !missing(`v')
			local nnonmiss = r(N)
			post `memhold' ("`v'") (`nmiss') (`nnonmiss')
		}

		postclose `memhold'
		use `missings', clear
		export excel using "`qa_file'", sheet("missingness", replace) firstrow(variables)
	restore

	* QA workbook: sampling-frame merge status.
	capture confirm variable merge_sampling_frame
	if !_rc {
		preserve
			contract merge_sampling_frame
			rename _freq n_records
			export excel using "`qa_file'", sheet("sampling_merge_status", replace) firstrow(variables)
		restore
	}

	* QA workbook: final district distribution.
	preserve
		contract district_scto
		rename _freq n_records
		export excel using "`qa_file'", sheet("district_distribution", replace) firstrow(variables)
	restore

	* Final internal consistency checks.
	capture assert !missing(survey_record_id)
	if _rc {
		dis as error "Warning: survey_record_id has missing values. Check record construction."
	}

	capture isid survey_record_id
	if _rc {
		dis as error "Warning: survey_record_id is not unique. Check duplicate records."
	}
	else {
		dis as result "survey_record_id uniquely identifies all records."
	}

	capture isid submission_key
	if _rc {
		dis as error "Warning: submission_key is not unique. Check duplicate submissions."
	}
	else {
		dis as result "submission_key uniquely identifies all records."
	}

	dis as result "Phase 1 baseline cleaning complete. Corrected outputs saved in 2 Working and 3 Coded."

	
		
*------------------------------------------------------------------------------*
**# End Phase 1 baseline cleaning block
*------------------------------------------------------------------------------*

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
	
	
	
	
	
	
	
	
	