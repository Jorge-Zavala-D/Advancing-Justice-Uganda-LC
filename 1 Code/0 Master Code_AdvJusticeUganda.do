/*------------------------------------------------------------------------------*
| Title: 			Master Code													|
| Project: 			Advancing Justice Uganda LC training for case diversion		|
| Authors:			Jorge Zavala 												|
| 					  									                        |
|																				|
| Description:		This .do sets up file paths and runs codes of the project	|
|                                                                               |
| Date created: 24/04/2026			 					                        |
|																			    |
| Version: Stata 19 	                    							 	    |
*-------------------------------------------------------------------------------*/

/*--------------------------*
*           INDEX           *
*---------------------------*


*-------------------------------------------------------------------------------*/


*-----------------------------------*
**#		0. Setup and directory		*
*-----------------------------------*
	clear all
	clear mata
	set more off
	version 19

*-----------------------------------*
**#		1. Define paths				*
*-----------------------------------*

* check what your username is in Stata by typing "di c(username)"
if "`c(username)'" == "jzava" { // Jorge's personal laptop
    global dropbox 	"C:\Users\jzava\Dropbox (Personal)\Research & Consulting\1 Research\Legatum Uganda Advancing Justice"
	global git 		"C:\Users\jzava\Documents\GitHub\Advancing-Justice-Uganda-LC"
	local os        "windows"
}


* Mac-based macros (template to be changed for Mac users)
	 if "`c(username)'" == ""{
	    global dropbox 	"" // for data/output
		global git 		"" // for dofiles
		local os       "mac"
	 }

* Set globals for sub-folders 
	global input_dir 	"${dropbox}/3 Data"
	global code_dir 	"${git}/1 Code"
	global output_dir 	"${git}/2 Output"
	
	sysdir set PLUS "${code_dir}/ado"


	* Install packages 
	local user_commands	randomize randtreat repkit ietoolkit iefieldkit winsor sumstats estout keeporder outreg2 //Add required user-written commands

	foreach command of local user_commands {
	   capture which `command'
	   if _rc == 111 {
		   capture noisily ssc install `command'
		   if _rc display as error "Warning: could not install `command'; continuing with available commands."
	   }
	}
	* Install plotplain scheme for graphs formatting
	*net install gr0070, from(http://www.stata-journal.com/software/sj17-3)		

	* Run do files 
	* Switch to 0/1 to not-run/run do-files 
	if (0) do "${code_dir}/1 Data Preparation_AdvJusticeUganda.do"
	if (0) do "${code_dir}/2 Data Analysis_AdvJusticeUganda.do"
	if (0) do "${code_dir}/3 Baseline Data Quality_AdvJusticeUganda.do"
	if (0) do "${code_dir}/4 Key Baseline Regressions_AdvJusticeUganda.do"
	if (0) do "${code_dir}/5 QA Presentation Assets_AdvJusticeUganda.do"
	if (0) do "${code_dir}/6 Quick Alternative Outcome Regression_AdvJusticeUganda.do"
