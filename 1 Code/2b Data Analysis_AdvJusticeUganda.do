/*------------------------------------------------------------------------------*
| Title: 			Data Analysis												|
| Project: 			Transitional Justice Information RCT Peru				   	|
| Authors:			Jorge Zavala 												|
| 					  									                        |
|																				|
| Description:		This .do performs statistical analysis of cleaned data		|
|                                                                               |
| Date created: 16/12/2025			 					                        |										          
|																			    |
| Version: Stata 13/16 	                    							 	    |
*-------------------------------------------------------------------------------*/

/*--------------------------*
*           INDEX           *
*---------------------------*


		

*-------------------------------------------------------------------------------*/


*-------------------------------*
**#		Baseline analysis		*
*-------------------------------*

use "${input_dir}/2 Working/Peru TJ RCT_Baseline.dta", clear	
	
	*-------------------*
	**#		Balance		*
	*-------------------*
