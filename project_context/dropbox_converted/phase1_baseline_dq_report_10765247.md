<!-- converted from phase1_baseline_dq_report.xlsx -->

## Sheet: README
| Advancing Justice Uganda - Phase 1 baseline data-quality report |  |
| --- | --- |
| Release status | BLOCKED |
| Meaning | READY means no error-severity automated check failed. WARNING and INFO items still require review. |
| Source file | C:\Users\jzava\Dropbox (Personal)\Research & Consulting\1 Research\Legatum Uganda Advancing Justice/3 Data/2 Working/phase1_baseline_clean.dta |
| Run date | 16 Jul 2026 11:27:38 |
| Source records | 133 |
| Planned records | 128 |
| Unique surveyed village keys | 128 |
| Planned unique villages | 128 |
| Issue rows | 442 |
| Error issue rows | 134 |
| Warning issue rows | 175 |
| Info issue rows | 133 |
| Severity definitions |  |
| ERROR | Must be resolved or explicitly adjudicated before analytical release. |
| WARNING | Plausibility or completeness concern requiring review. |
| INFO | Expected diagnostic or monitoring item that may need documentation. |
| Important interpretation note | Module response density includes conditional and select-multiple fields. It is a screening metric and not a skip-adjusted missingness rate. |
| Workflow | Review check_summary first then issues and record_flags. Record every adjudication outside the raw data and rerun after corrections. |
## Sheet: overview
| source_file | run_date | stata_version | n_source_records | n_source_variables | n_consented_records | n_unique_villages | n_issue_rows | n_error_issue_rows | n_warning_issue_rows | n_info_issue_rows | n_records_with_error | n_records_with_warning | release_status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| C:\Users\jzava\Dropbox (Personal)\Research & Consulting\1 Research\Legatum Uganda Advancing Justice/3 Data/2 Working/phase1_baseline_clean.dta | 16 Jul 2026 11:27:37 | Stata 19.0 | 133 | 738 | 133 | 128 | 442 | 134 | 175 | 133 | 105 | 110 | BLOCKED |
## Sheet: check_summary
| check_id | severity | domain | module | variable | issue | n_tested | n_issues | issue_rate | status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| m3_q08_GT_CASELOAD | ERROR | consistency | M3 | m3_q08 | Case component exceeds the reported three-month caseload | 133 | 6 | 0.045112781954887216 | FAIL |
| ENUMERATOR_OVERLAP | ERROR | paradata | metadata | starttime_dt | Interview starts before the same enumerator's previous interview ended | 133 | 10 | 0.07518796992481203 | FAIL |
| VALUE_LABEL_enum | ERROR | range | metadata | enum | Observed code has no definition in its attached value label | 133 | 5 | 0.03759398496240601 | FAIL |
| DUPLICATE_SURVEY_VILLAGE | ERROR | sample | geography | survey_village_uid | More than one submission uses the same SurveyCTO village key | 133 | 10 | 0.07518796992481203 | FAIL |
| EXPECTED_RECORD_COUNT | ERROR | sample | sample | _N | Record count equals the planned Phase 1 baseline sample | 1 | 1 | 1 | FAIL |
| M5_Q11_EXCLUSIVE | ERROR | select_multiple | M5 | m5_q11_10 | No ADR barrier is selected with a substantive barrier | 133 | 2 | 0.015037593984962405 | FAIL |
| M6_Q12_EXCLUSIVE | ERROR | select_multiple | M6 | m6_q12_11 | No referral barrier is selected with a substantive barrier | 133 | 4 | 0.03007518796992481 | FAIL |
| M8_Q15_EXCLUSIVE | ERROR | select_multiple | M8 | m8_q15_10 | No committee challenge is selected with a substantive challenge | 133 | 2 | 0.015037593984962405 | FAIL |
| M9_Q16_EXCLUSIVE | ERROR | select_multiple | M9 | m9_q16_11 | Rarely bypass is selected with a substantive bypass reason | 133 | 2 | 0.015037593984962405 | FAIL |
| VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | 91 | 91 | 1 | FAIL |
| M2_VERIFICATION_STRAY | ERROR | skip_logic | M2 | m2_q17 | Record quality was verified although the enumerator saw no record | 10 | 2 | 0.2 | FAIL |
| MODULE_1_ALL_MISSING | ERROR | completeness | M1 | m1_* | All fields in this survey module are missing | 133 | 0 | 0 | PASS |
| MISSING_REQUIRED_m1_q04 | ERROR | completeness | M1 | m1_q04 | Required field is missing for a consented record | 133 | 0 | 0 | PASS |
| MISSING_REQUIRED_m1_q06 | ERROR | completeness | M1 | m1_q06 | Required field is missing for a consented record | 133 | 0 | 0 | PASS |
| MISSING_REQUIRED_m1_q07 | ERROR | completeness | M1 | m1_q07 | Required field is missing for a consented record | 133 | 0 | 0 | PASS |
| MISSING_REQUIRED_m1_q08 | ERROR | completeness | M1 | m1_q08 | Required field is missing for a consented record | 133 | 0 | 0 | PASS |
| MODULE_11_ALL_MISSING | ERROR | completeness | M11 | m11_* | All fields in this survey module are missing | 133 | 0 | 0 | PASS |
| MODULE_2_ALL_MISSING | ERROR | completeness | M2 | m2_* | All fields in this survey module are missing | 133 | 0 | 0 | PASS |
| MODULE_3_ALL_MISSING | ERROR | completeness | M3 | m3_* | All fields in this survey module are missing | 133 | 0 | 0 | PASS |
| MODULE_4_ALL_MISSING | ERROR | completeness | M4 | m4_* | All fields in this survey module are missing | 133 | 0 | 0 | PASS |
| MODULE_5_ALL_MISSING | ERROR | completeness | M5 | m5_* | All fields in this survey module are missing | 133 | 0 | 0 | PASS |
| MODULE_6_ALL_MISSING | ERROR | completeness | M6 | m6_* | All fields in this survey module are missing | 133 | 0 | 0 | PASS |
| MODULE_7_ALL_MISSING | ERROR | completeness | M7 | m7_* | All fields in this survey module are missing | 133 | 0 | 0 | PASS |
| MODULE_8_ALL_MISSING | ERROR | completeness | M8 | m8_* | All fields in this survey module are missing | 133 | 0 | 0 | PASS |
| MODULE_9_ALL_MISSING | ERROR | completeness | M9 | m9_* | All fields in this survey module are missing | 133 | 0 | 0 | PASS |
| MISSING_REQUIRED_consent | ERROR | completeness | metadata | consent | Required field is missing for a consented record | 133 | 0 | 0 | PASS |
| MISSING_REQUIRED_district_scto | ERROR | completeness | metadata | district_scto | Required field is missing for a consented record | 133 | 0 | 0 | PASS |
| MISSING_REQUIRED_enum | ERROR | completeness | metadata | enum | Required field is missing for a consented record | 133 | 0 | 0 | PASS |
| MISSING_REQUIRED_parish_scto | ERROR | completeness | metadata | parish_scto | Required field is missing for a consented record | 133 | 0 | 0 | PASS |
| MISSING_REQUIRED_subcounty_scto | ERROR | completeness | metadata | subcounty_scto | Required field is missing for a consented record | 133 | 0 | 0 | PASS |
| MISSING_REQUIRED_submission_key | ERROR | completeness | metadata | submission_key | Required field is missing for a consented record | 133 | 0 | 0 | PASS |
| MISSING_REQUIRED_village_scto | ERROR | completeness | metadata | village_scto | Required field is missing for a consented record | 133 | 0 | 0 | PASS |
| RESPONSES_WITHOUT_CONSENT | ERROR | consent | M1 | m1_q04 | Substantive responses are present although consent was not recorded | 133 | 0 | 0 | PASS |
| ANALYSIS_SAMPLE_MISMATCH | ERROR | consent | metadata | analysis_sample | Analysis-sample flag does not match consent status | 133 | 0 | 0 | PASS |
| WOMEN_MEMBERS_GT_TOTAL | ERROR | consistency | M2 | m2_q05 | Women committee members exceed total committee members | 132 | 0 | 0 | PASS |
| CASELOAD_30D_GT_3M | ERROR | consistency | M3 | m3_q02 | Thirty-day caseload exceeds three-month caseload | 133 | 0 | 0 | PASS |
| m3_q09_GT_CASELOAD | ERROR | consistency | M3 | m3_q09 | Case component exceeds the reported three-month caseload | 95 | 0 | 0 | PASS |
| m3_q10_GT_CASELOAD | ERROR | consistency | M3 | m3_q10 | Case component exceeds the reported three-month caseload | 0 | 0 |  | PASS |
| m3_q12_GT_CASELOAD | ERROR | consistency | M3 | m3_q12 | Case component exceeds the reported three-month caseload | 0 | 0 |  | PASS |
| ADMIN_ORIGIN_COMPLEMENT | ERROR | consistency | sample | p1_admin_new | Administrative new and previously-contacted flags are not complements | 133 | 0 | 0 | PASS |
| DUPLICATE_INSTANCE_ID | ERROR | identity | metadata | instance_id | SurveyCTO instance ID appears in more than one record | 133 | 0 | 0 | PASS |
| DUPLICATE_SUBMISSION_KEY | ERROR | identity | metadata | submission_key | Submission key appears in more than one record | 133 | 0 | 0 | PASS |
| MISSING_SUBMISSION_KEY | ERROR | identity | metadata | submission_key | Submission key is missing | 133 | 0 | 0 | PASS |
| RAW_CLEAN_RECORD_COUNT | ERROR | lineage | metadata | _N | Raw and cleaned baseline files contain the same number of records | 133 | 0 | 0 | PASS |
| RAW_TYPE_consent | ERROR | lineage | metadata | consent | Raw and cleaned lineage fields have compatible storage types | 1 | 0 | 0 | PASS |
| RAW_VALUE_consent | ERROR | lineage | metadata | consent | Cleaned lineage field differs from its raw SurveyCTO value | 133 | 0 | 0 | PASS |
| RAW_TYPE_duration | ERROR | lineage | metadata | duration | Raw and cleaned lineage fields have compatible storage types | 1 | 0 | 0 | PASS |
| RAW_VALUE_duration | ERROR | lineage | metadata | duration | Cleaned lineage field differs from its raw SurveyCTO value | 133 | 0 | 0 | PASS |
| RAW_TYPE_enum | ERROR | lineage | metadata | enum | Raw and cleaned lineage fields have compatible storage types | 1 | 0 | 0 | PASS |
| RAW_VALUE_enum | ERROR | lineage | metadata | enum | Cleaned lineage field differs from its raw SurveyCTO value | 133 | 0 | 0 | PASS |
| RAW_TYPE_m0_q04 | ERROR | lineage | metadata | m0_q04 | Raw and cleaned lineage fields have compatible storage types | 1 | 0 | 0 | PASS |
| RAW_VALUE_m0_q04 | ERROR | lineage | metadata | m0_q04 | Cleaned lineage field differs from its raw SurveyCTO value | 133 | 0 | 0 | PASS |
| RAW_TYPE_m0_q05 | ERROR | lineage | metadata | m0_q05 | Raw and cleaned lineage fields have compatible storage types | 1 | 0 | 0 | PASS |
| RAW_VALUE_m0_q05 | ERROR | lineage | metadata | m0_q05 | Cleaned lineage field differs from its raw SurveyCTO value | 133 | 0 | 0 | PASS |
| RAW_TYPE_m0_q06 | ERROR | lineage | metadata | m0_q06 | Raw and cleaned lineage fields have compatible storage types | 1 | 0 | 0 | PASS |
| RAW_VALUE_m0_q06 | ERROR | lineage | metadata | m0_q06 | Cleaned lineage field differs from its raw SurveyCTO value | 133 | 0 | 0 | PASS |
| RAW_TYPE_m0_q07 | ERROR | lineage | metadata | m0_q07 | Raw and cleaned lineage fields have compatible storage types | 1 | 0 | 0 | PASS |
| RAW_VALUE_m0_q07 | ERROR | lineage | metadata | m0_q07 | Cleaned lineage field differs from its raw SurveyCTO value | 133 | 0 | 0 | PASS |
| CLEAN_KEY_NOT_IN_RAW | ERROR | lineage | metadata | submission_key | Cleaned record submission key does not exist in the raw SurveyCTO export | 133 | 0 | 0 | PASS |
| RAW_DUPLICATE_KEYS | ERROR | lineage | metadata | submission_key | Raw SurveyCTO submission keys are unique | 133 | 0 | 0 | PASS |
| RAW_KEY_NOT_IN_CLEAN | ERROR | lineage | metadata | submission_key | Every raw SurveyCTO submission key is retained in the cleaned file | 133 | 0 | 0 | PASS |
| RAW_MISSING_KEYS | ERROR | lineage | metadata | submission_key | Raw SurveyCTO submission keys are nonmissing | 133 | 0 | 0 | PASS |
| NONPOSITIVE_DURATION | ERROR | paradata | metadata | duration_min | Interview duration is zero or negative | 133 | 0 | 0 | PASS |
| END_BEFORE_START | ERROR | paradata | metadata | endtime_dt | Interview end time precedes start time | 133 | 0 | 0 | PASS |
| DUPLICATE_ENUM_START_TIME | ERROR | paradata | metadata | starttime_dt | Enumerator has more than one interview with the same start time | 133 | 0 | 0 | PASS |
| SUBMISSION_BEFORE_END | ERROR | paradata | metadata | submissiondate_dt | Submission time precedes interview end time | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m0_q04 | ERROR | range | M0 | m0_q04 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m0_q05 | ERROR | range | M0 | m0_q05 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m0_q06 | ERROR | range | M0 | m0_q06 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m0_q07 | ERROR | range | M0 | m0_q07 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m0_q20 | ERROR | range | M0 | m0_q20 | Observed code has no definition in its attached value label | 132 | 0 | 0 | PASS |
| COUNT_RANGE_m1_q04 | ERROR | range | M1 | m1_q04 | Count must be a nonnegative integer | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m1_q06 | ERROR | range | M1 | m1_q06 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m1_q07 | ERROR | range | M1 | m1_q07 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m1_q08 | ERROR | range | M1 | m1_q08 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m1_q09 | ERROR | range | M1 | m1_q09 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q10_1 | ERROR | range | M1 | m1_q10_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q10_2 | ERROR | range | M1 | m1_q10_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q10_3 | ERROR | range | M1 | m1_q10_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q10_4 | ERROR | range | M1 | m1_q10_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q10_95 | ERROR | range | M1 | m1_q10_95 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q10_98 | ERROR | range | M1 | m1_q10_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m1_q11 | ERROR | range | M1 | m1_q11 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m1_q13 | ERROR | range | M1 | m1_q13 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q14_1 | ERROR | range | M1 | m1_q14_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q14_2 | ERROR | range | M1 | m1_q14_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q14_3 | ERROR | range | M1 | m1_q14_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q14_4 | ERROR | range | M1 | m1_q14_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q14_5 | ERROR | range | M1 | m1_q14_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q14_6 | ERROR | range | M1 | m1_q14_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q14_7 | ERROR | range | M1 | m1_q14_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q14_8 | ERROR | range | M1 | m1_q14_8 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q14_95 | ERROR | range | M1 | m1_q14_95 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m1_q14_98 | ERROR | range | M1 | m1_q14_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m1_q15 | ERROR | range | M1 | m1_q15 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m10_q07 | ERROR | range | M10 | m10_q07 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m10_q08_1 | ERROR | range | M10 | m10_q08_1 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m10_q08_2 | ERROR | range | M10 | m10_q08_2 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m10_q08_3 | ERROR | range | M10 | m10_q08_3 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m10_q08_4 | ERROR | range | M10 | m10_q08_4 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m10_q08_5 | ERROR | range | M10 | m10_q08_5 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m10_q08_6 | ERROR | range | M10 | m10_q08_6 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m10_q08_7 | ERROR | range | M10 | m10_q08_7 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m10_q08_98 | ERROR | range | M10 | m10_q08_98 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| VALUE_LABEL_m10_v01 | ERROR | range | M10 | m10_v01 | Observed code has no definition in its attached value label | 0 | 0 |  | PASS |
| VALUE_LABEL_m10_v02 | ERROR | range | M10 | m10_v02 | Observed code has no definition in its attached value label | 0 | 0 |  | PASS |
| VALUE_LABEL_m11_q02 | ERROR | range | M11 | m11_q02 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m11_q03 | ERROR | range | M11 | m11_q03 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m11_q04 | ERROR | range | M11 | m11_q04 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m11_q05 | ERROR | range | M11 | m11_q05 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m11_q06 | ERROR | range | M11 | m11_q06 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m11_q07 | ERROR | range | M11 | m11_q07 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m11_q08 | ERROR | range | M11 | m11_q08 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m11_q09 | ERROR | range | M11 | m11_q09 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q10_1 | ERROR | range | M11 | m11_q10_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q10_2 | ERROR | range | M11 | m11_q10_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q10_3 | ERROR | range | M11 | m11_q10_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q10_4 | ERROR | range | M11 | m11_q10_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q10_5 | ERROR | range | M11 | m11_q10_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q10_6 | ERROR | range | M11 | m11_q10_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q10_7 | ERROR | range | M11 | m11_q10_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q10_8 | ERROR | range | M11 | m11_q10_8 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q10_9 | ERROR | range | M11 | m11_q10_9 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q10_98 | ERROR | range | M11 | m11_q10_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m11_q11 | ERROR | range | M11 | m11_q11 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q12_1 | ERROR | range | M11 | m11_q12_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q12_2 | ERROR | range | M11 | m11_q12_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q12_3 | ERROR | range | M11 | m11_q12_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q12_4 | ERROR | range | M11 | m11_q12_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q12_5 | ERROR | range | M11 | m11_q12_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q12_6 | ERROR | range | M11 | m11_q12_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q12_7 | ERROR | range | M11 | m11_q12_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q12_8 | ERROR | range | M11 | m11_q12_8 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q12_9 | ERROR | range | M11 | m11_q12_9 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q12_98 | ERROR | range | M11 | m11_q12_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m11_q13 | ERROR | range | M11 | m11_q13 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q14_1 | ERROR | range | M11 | m11_q14_1 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q14_2 | ERROR | range | M11 | m11_q14_2 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q14_3 | ERROR | range | M11 | m11_q14_3 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q14_4 | ERROR | range | M11 | m11_q14_4 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q14_5 | ERROR | range | M11 | m11_q14_5 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q14_6 | ERROR | range | M11 | m11_q14_6 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q14_7 | ERROR | range | M11 | m11_q14_7 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q14_8 | ERROR | range | M11 | m11_q14_8 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q14_98 | ERROR | range | M11 | m11_q14_98 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| VALUE_LABEL_m11_q15 | ERROR | range | M11 | m11_q15 | Observed code has no definition in its attached value label | 0 | 0 |  | PASS |
| VALUE_LABEL_m11_q16 | ERROR | range | M11 | m11_q16 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m11_q17 | ERROR | range | M11 | m11_q17 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m11_q18 | ERROR | range | M11 | m11_q18 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m11_q19_1 | ERROR | range | M11 | m11_q19_1 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q19_2 | ERROR | range | M11 | m11_q19_2 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q19_3 | ERROR | range | M11 | m11_q19_3 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q19_4 | ERROR | range | M11 | m11_q19_4 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q19_5 | ERROR | range | M11 | m11_q19_5 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q19_6 | ERROR | range | M11 | m11_q19_6 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q19_7 | ERROR | range | M11 | m11_q19_7 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m11_q19_98 | ERROR | range | M11 | m11_q19_98 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| COUNT_RANGE_m2_q01 | ERROR | range | M2 | m2_q01 | Count must be a nonnegative integer | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m2_q03 | ERROR | range | M2 | m2_q03 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| COUNT_RANGE_m2_q04 | ERROR | range | M2 | m2_q04 | Count must be a nonnegative integer | 0 | 0 |  | PASS |
| COUNT_RANGE_m2_q05 | ERROR | range | M2 | m2_q05 | Count must be a nonnegative integer | 132 | 0 | 0 | PASS |
| COUNT_RANGE_m2_q06 | ERROR | range | M2 | m2_q06 | Count must be a nonnegative integer | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m2_q07 | ERROR | range | M2 | m2_q07 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m2_q08 | ERROR | range | M2 | m2_q08 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m2_q09 | ERROR | range | M2 | m2_q09 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m2_q12 | ERROR | range | M2 | m2_q12 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m2_q13 | ERROR | range | M2 | m2_q13 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m2_q14 | ERROR | range | M2 | m2_q14 | Observed code has no definition in its attached value label | 130 | 0 | 0 | PASS |
| MULTI_BINARY_m2_q15_1 | ERROR | range | M2 | m2_q15_1 | Select-multiple indicator must equal zero or one | 72 | 0 | 0 | PASS |
| MULTI_BINARY_m2_q15_2 | ERROR | range | M2 | m2_q15_2 | Select-multiple indicator must equal zero or one | 72 | 0 | 0 | PASS |
| MULTI_BINARY_m2_q15_3 | ERROR | range | M2 | m2_q15_3 | Select-multiple indicator must equal zero or one | 72 | 0 | 0 | PASS |
| MULTI_BINARY_m2_q15_4 | ERROR | range | M2 | m2_q15_4 | Select-multiple indicator must equal zero or one | 72 | 0 | 0 | PASS |
| MULTI_BINARY_m2_q15_5 | ERROR | range | M2 | m2_q15_5 | Select-multiple indicator must equal zero or one | 72 | 0 | 0 | PASS |
| MULTI_BINARY_m2_q15_6 | ERROR | range | M2 | m2_q15_6 | Select-multiple indicator must equal zero or one | 72 | 0 | 0 | PASS |
| MULTI_BINARY_m2_q15_98 | ERROR | range | M2 | m2_q15_98 | Select-multiple indicator must equal zero or one | 72 | 0 | 0 | PASS |
| VALUE_LABEL_m2_q16 | ERROR | range | M2 | m2_q16 | Observed code has no definition in its attached value label | 114 | 0 | 0 | PASS |
| VALUE_LABEL_m2_q17 | ERROR | range | M2 | m2_q17 | Observed code has no definition in its attached value label | 106 | 0 | 0 | PASS |
| COUNT_RANGE_m3_q02 | ERROR | range | M3 | m3_q02 | Count must be a nonnegative integer | 133 | 0 | 0 | PASS |
| COUNT_RANGE_m3_q03 | ERROR | range | M3 | m3_q03 | Count must be a nonnegative integer | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q04_1 | ERROR | range | M3 | m3_q04_1 | Select-multiple indicator must equal zero or one | 96 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q04_10 | ERROR | range | M3 | m3_q04_10 | Select-multiple indicator must equal zero or one | 96 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q04_2 | ERROR | range | M3 | m3_q04_2 | Select-multiple indicator must equal zero or one | 96 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q04_3 | ERROR | range | M3 | m3_q04_3 | Select-multiple indicator must equal zero or one | 96 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q04_4 | ERROR | range | M3 | m3_q04_4 | Select-multiple indicator must equal zero or one | 96 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q04_5 | ERROR | range | M3 | m3_q04_5 | Select-multiple indicator must equal zero or one | 96 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q04_6 | ERROR | range | M3 | m3_q04_6 | Select-multiple indicator must equal zero or one | 96 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q04_7 | ERROR | range | M3 | m3_q04_7 | Select-multiple indicator must equal zero or one | 96 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q04_8 | ERROR | range | M3 | m3_q04_8 | Select-multiple indicator must equal zero or one | 96 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q04_9 | ERROR | range | M3 | m3_q04_9 | Select-multiple indicator must equal zero or one | 96 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q04_98 | ERROR | range | M3 | m3_q04_98 | Select-multiple indicator must equal zero or one | 96 | 0 | 0 | PASS |
| VALUE_LABEL_m3_q05 | ERROR | range | M3 | m3_q05 | Observed code has no definition in its attached value label | 96 | 0 | 0 | PASS |
| VALUE_LABEL_m3_q06 | ERROR | range | M3 | m3_q06 | Observed code has no definition in its attached value label | 96 | 0 | 0 | PASS |
| COUNT_RANGE_m3_q08 | ERROR | range | M3 | m3_q08 | Count must be a nonnegative integer | 133 | 0 | 0 | PASS |
| COUNT_RANGE_m3_q09 | ERROR | range | M3 | m3_q09 | Count must be a nonnegative integer | 95 | 0 | 0 | PASS |
| COUNT_RANGE_m3_q10 | ERROR | range | M3 | m3_q10 | Count must be a nonnegative integer | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q11_1 | ERROR | range | M3 | m3_q11_1 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q11_2 | ERROR | range | M3 | m3_q11_2 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q11_3 | ERROR | range | M3 | m3_q11_3 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q11_4 | ERROR | range | M3 | m3_q11_4 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q11_5 | ERROR | range | M3 | m3_q11_5 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q11_6 | ERROR | range | M3 | m3_q11_6 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q11_98 | ERROR | range | M3 | m3_q11_98 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| COUNT_RANGE_m3_q12 | ERROR | range | M3 | m3_q12 | Count must be a nonnegative integer | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q13_1 | ERROR | range | M3 | m3_q13_1 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q13_2 | ERROR | range | M3 | m3_q13_2 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q13_3 | ERROR | range | M3 | m3_q13_3 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q13_4 | ERROR | range | M3 | m3_q13_4 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q13_5 | ERROR | range | M3 | m3_q13_5 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q13_6 | ERROR | range | M3 | m3_q13_6 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q13_98 | ERROR | range | M3 | m3_q13_98 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| VALUE_LABEL_m3_q14 | ERROR | range | M3 | m3_q14 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q15_1 | ERROR | range | M3 | m3_q15_1 | Select-multiple indicator must equal zero or one | 12 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q15_2 | ERROR | range | M3 | m3_q15_2 | Select-multiple indicator must equal zero or one | 12 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q15_3 | ERROR | range | M3 | m3_q15_3 | Select-multiple indicator must equal zero or one | 12 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q15_4 | ERROR | range | M3 | m3_q15_4 | Select-multiple indicator must equal zero or one | 12 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q15_5 | ERROR | range | M3 | m3_q15_5 | Select-multiple indicator must equal zero or one | 12 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q15_6 | ERROR | range | M3 | m3_q15_6 | Select-multiple indicator must equal zero or one | 12 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q15_7 | ERROR | range | M3 | m3_q15_7 | Select-multiple indicator must equal zero or one | 12 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q15_98 | ERROR | range | M3 | m3_q15_98 | Select-multiple indicator must equal zero or one | 12 | 0 | 0 | PASS |
| MULTI_BINARY_m3_q16_1 | ERROR | range | M3 | m3_q16_1 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q16_2 | ERROR | range | M3 | m3_q16_2 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q16_3 | ERROR | range | M3 | m3_q16_3 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q16_4 | ERROR | range | M3 | m3_q16_4 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q16_5 | ERROR | range | M3 | m3_q16_5 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q16_6 | ERROR | range | M3 | m3_q16_6 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q16_7 | ERROR | range | M3 | m3_q16_7 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| MULTI_BINARY_m3_q16_98 | ERROR | range | M3 | m3_q16_98 | Select-multiple indicator must equal zero or one | 0 | 0 |  | PASS |
| VALUE_LABEL_m3_q17 | ERROR | range | M3 | m3_q17 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q01_1 | ERROR | range | M4 | m4_q01_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q01_10 | ERROR | range | M4 | m4_q01_10 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q01_2 | ERROR | range | M4 | m4_q01_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q01_3 | ERROR | range | M4 | m4_q01_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q01_4 | ERROR | range | M4 | m4_q01_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q01_5 | ERROR | range | M4 | m4_q01_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q01_6 | ERROR | range | M4 | m4_q01_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q01_7 | ERROR | range | M4 | m4_q01_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q01_8 | ERROR | range | M4 | m4_q01_8 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q01_9 | ERROR | range | M4 | m4_q01_9 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q01_98 | ERROR | range | M4 | m4_q01_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q02_1 | ERROR | range | M4 | m4_q02_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q02_2 | ERROR | range | M4 | m4_q02_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q02_3 | ERROR | range | M4 | m4_q02_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q02_4 | ERROR | range | M4 | m4_q02_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q02_5 | ERROR | range | M4 | m4_q02_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q02_6 | ERROR | range | M4 | m4_q02_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q02_7 | ERROR | range | M4 | m4_q02_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q02_8 | ERROR | range | M4 | m4_q02_8 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q02_98 | ERROR | range | M4 | m4_q02_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_q04 | ERROR | range | M4 | m4_q04 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_q04_correct_refer | ERROR | range | M4 | m4_q04_correct_refer | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q05_1 | ERROR | range | M4 | m4_q05_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q05_2 | ERROR | range | M4 | m4_q05_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q05_3 | ERROR | range | M4 | m4_q05_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q05_4 | ERROR | range | M4 | m4_q05_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q05_5 | ERROR | range | M4 | m4_q05_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q05_6 | ERROR | range | M4 | m4_q05_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q05_7 | ERROR | range | M4 | m4_q05_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q05_98 | ERROR | range | M4 | m4_q05_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q06_1 | ERROR | range | M4 | m4_q06_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q06_2 | ERROR | range | M4 | m4_q06_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q06_3 | ERROR | range | M4 | m4_q06_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q06_4 | ERROR | range | M4 | m4_q06_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q06_5 | ERROR | range | M4 | m4_q06_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q06_6 | ERROR | range | M4 | m4_q06_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q06_7 | ERROR | range | M4 | m4_q06_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q06_98 | ERROR | range | M4 | m4_q06_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_q07 | ERROR | range | M4 | m4_q07 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_q07_correct_adr_scope | ERROR | range | M4 | m4_q07_correct_adr_scope | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q08_1 | ERROR | range | M4 | m4_q08_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q08_2 | ERROR | range | M4 | m4_q08_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q08_3 | ERROR | range | M4 | m4_q08_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q08_4 | ERROR | range | M4 | m4_q08_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q08_5 | ERROR | range | M4 | m4_q08_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q08_6 | ERROR | range | M4 | m4_q08_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q08_7 | ERROR | range | M4 | m4_q08_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_q08_98 | ERROR | range | M4 | m4_q08_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_q10 | ERROR | range | M4 | m4_q10 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_q11 | ERROR | range | M4 | m4_q11 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_v01_q1 | ERROR | range | M4 | m4_v01_q1 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_v01_q2 | ERROR | range | M4 | m4_v01_q2 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v01_q3_1 | ERROR | range | M4 | m4_v01_q3_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v01_q3_2 | ERROR | range | M4 | m4_v01_q3_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v01_q3_3 | ERROR | range | M4 | m4_v01_q3_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v01_q3_4 | ERROR | range | M4 | m4_v01_q3_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v01_q3_5 | ERROR | range | M4 | m4_v01_q3_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v01_q3_6 | ERROR | range | M4 | m4_v01_q3_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v01_q3_98 | ERROR | range | M4 | m4_v01_q3_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_v02_q1 | ERROR | range | M4 | m4_v02_q1 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_v02_q2 | ERROR | range | M4 | m4_v02_q2 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v02_q3_1 | ERROR | range | M4 | m4_v02_q3_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v02_q3_2 | ERROR | range | M4 | m4_v02_q3_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v02_q3_3 | ERROR | range | M4 | m4_v02_q3_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v02_q3_4 | ERROR | range | M4 | m4_v02_q3_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v02_q3_5 | ERROR | range | M4 | m4_v02_q3_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v02_q3_6 | ERROR | range | M4 | m4_v02_q3_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v02_q3_98 | ERROR | range | M4 | m4_v02_q3_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_v05_q1 | ERROR | range | M4 | m4_v05_q1 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_v05_q2 | ERROR | range | M4 | m4_v05_q2 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v05_q3_1 | ERROR | range | M4 | m4_v05_q3_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v05_q3_2 | ERROR | range | M4 | m4_v05_q3_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v05_q3_3 | ERROR | range | M4 | m4_v05_q3_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v05_q3_4 | ERROR | range | M4 | m4_v05_q3_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v05_q3_5 | ERROR | range | M4 | m4_v05_q3_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v05_q3_6 | ERROR | range | M4 | m4_v05_q3_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v05_q3_98 | ERROR | range | M4 | m4_v05_q3_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_v06_q1 | ERROR | range | M4 | m4_v06_q1 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m4_v06_q2 | ERROR | range | M4 | m4_v06_q2 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v06_q3_1 | ERROR | range | M4 | m4_v06_q3_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v06_q3_2 | ERROR | range | M4 | m4_v06_q3_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v06_q3_3 | ERROR | range | M4 | m4_v06_q3_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v06_q3_4 | ERROR | range | M4 | m4_v06_q3_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v06_q3_5 | ERROR | range | M4 | m4_v06_q3_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v06_q3_6 | ERROR | range | M4 | m4_v06_q3_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m4_v06_q3_98 | ERROR | range | M4 | m4_v06_q3_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m5_q01 | ERROR | range | M5 | m5_q01 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m5_q02 | ERROR | range | M5 | m5_q02 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m5_q03 | ERROR | range | M5 | m5_q03 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m5_q06 | ERROR | range | M5 | m5_q06 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m5_q07 | ERROR | range | M5 | m5_q07 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m5_q09 | ERROR | range | M5 | m5_q09 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m5_q10 | ERROR | range | M5 | m5_q10 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q11_1 | ERROR | range | M5 | m5_q11_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q11_10 | ERROR | range | M5 | m5_q11_10 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q11_2 | ERROR | range | M5 | m5_q11_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q11_3 | ERROR | range | M5 | m5_q11_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q11_4 | ERROR | range | M5 | m5_q11_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q11_5 | ERROR | range | M5 | m5_q11_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q11_6 | ERROR | range | M5 | m5_q11_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q11_7 | ERROR | range | M5 | m5_q11_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q11_8 | ERROR | range | M5 | m5_q11_8 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q11_9 | ERROR | range | M5 | m5_q11_9 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q11_98 | ERROR | range | M5 | m5_q11_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q13_1 | ERROR | range | M5 | m5_q13_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q13_2 | ERROR | range | M5 | m5_q13_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q13_3 | ERROR | range | M5 | m5_q13_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q13_4 | ERROR | range | M5 | m5_q13_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q13_5 | ERROR | range | M5 | m5_q13_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q13_6 | ERROR | range | M5 | m5_q13_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q13_7 | ERROR | range | M5 | m5_q13_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q13_8 | ERROR | range | M5 | m5_q13_8 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q13_95 | ERROR | range | M5 | m5_q13_95 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m5_q13_98 | ERROR | range | M5 | m5_q13_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m5_q14 | ERROR | range | M5 | m5_q14 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m5_q15 | ERROR | range | M5 | m5_q15 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m5_q16 | ERROR | range | M5 | m5_q16 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m6_q01 | ERROR | range | M6 | m6_q01 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q04_1 | ERROR | range | M6 | m6_q04_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q04_2 | ERROR | range | M6 | m6_q04_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q04_3 | ERROR | range | M6 | m6_q04_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q04_4 | ERROR | range | M6 | m6_q04_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q04_5 | ERROR | range | M6 | m6_q04_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q04_6 | ERROR | range | M6 | m6_q04_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q04_7 | ERROR | range | M6 | m6_q04_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q04_8 | ERROR | range | M6 | m6_q04_8 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q04_98 | ERROR | range | M6 | m6_q04_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m6_q05 | ERROR | range | M6 | m6_q05 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m6_q08 | ERROR | range | M6 | m6_q08 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m6_q09 | ERROR | range | M6 | m6_q09 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m6_q10 | ERROR | range | M6 | m6_q10 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q12_1 | ERROR | range | M6 | m6_q12_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q12_10 | ERROR | range | M6 | m6_q12_10 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q12_11 | ERROR | range | M6 | m6_q12_11 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q12_2 | ERROR | range | M6 | m6_q12_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q12_3 | ERROR | range | M6 | m6_q12_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q12_4 | ERROR | range | M6 | m6_q12_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q12_5 | ERROR | range | M6 | m6_q12_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q12_6 | ERROR | range | M6 | m6_q12_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q12_7 | ERROR | range | M6 | m6_q12_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q12_8 | ERROR | range | M6 | m6_q12_8 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q12_9 | ERROR | range | M6 | m6_q12_9 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m6_q12_98 | ERROR | range | M6 | m6_q12_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m6_q14 | ERROR | range | M6 | m6_q14 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m6_q15 | ERROR | range | M6 | m6_q15 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m6_q16 | ERROR | range | M6 | m6_q16 | Observed code has no definition in its attached value label | 114 | 0 | 0 | PASS |
| VALUE_LABEL_m6_q17 | ERROR | range | M6 | m6_q17 | Observed code has no definition in its attached value label | 114 | 0 | 0 | PASS |
| VALUE_LABEL_m7_q01 | ERROR | range | M7 | m7_q01 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q03_1 | ERROR | range | M7 | m7_q03_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q03_2 | ERROR | range | M7 | m7_q03_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q03_3 | ERROR | range | M7 | m7_q03_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q03_4 | ERROR | range | M7 | m7_q03_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q03_5 | ERROR | range | M7 | m7_q03_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q03_6 | ERROR | range | M7 | m7_q03_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q03_95 | ERROR | range | M7 | m7_q03_95 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q03_98 | ERROR | range | M7 | m7_q03_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m7_q04 | ERROR | range | M7 | m7_q04 | Observed code has no definition in its attached value label | 123 | 0 | 0 | PASS |
| VALUE_LABEL_m7_q05 | ERROR | range | M7 | m7_q05 | Observed code has no definition in its attached value label | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q06_1 | ERROR | range | M7 | m7_q06_1 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q06_10 | ERROR | range | M7 | m7_q06_10 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q06_11 | ERROR | range | M7 | m7_q06_11 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q06_12 | ERROR | range | M7 | m7_q06_12 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q06_2 | ERROR | range | M7 | m7_q06_2 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q06_3 | ERROR | range | M7 | m7_q06_3 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q06_4 | ERROR | range | M7 | m7_q06_4 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q06_5 | ERROR | range | M7 | m7_q06_5 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q06_6 | ERROR | range | M7 | m7_q06_6 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q06_7 | ERROR | range | M7 | m7_q06_7 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q06_8 | ERROR | range | M7 | m7_q06_8 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q06_9 | ERROR | range | M7 | m7_q06_9 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q06_98 | ERROR | range | M7 | m7_q06_98 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| VALUE_LABEL_m7_q08 | ERROR | range | M7 | m7_q08 | Observed code has no definition in its attached value label | 123 | 0 | 0 | PASS |
| VALUE_LABEL_m7_q12 | ERROR | range | M7 | m7_q12 | Observed code has no definition in its attached value label | 123 | 0 | 0 | PASS |
| VALUE_LABEL_m7_q13 | ERROR | range | M7 | m7_q13 | Observed code has no definition in its attached value label | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q14_1 | ERROR | range | M7 | m7_q14_1 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q14_2 | ERROR | range | M7 | m7_q14_2 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q14_3 | ERROR | range | M7 | m7_q14_3 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q14_4 | ERROR | range | M7 | m7_q14_4 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q14_5 | ERROR | range | M7 | m7_q14_5 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q14_6 | ERROR | range | M7 | m7_q14_6 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q14_7 | ERROR | range | M7 | m7_q14_7 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q14_98 | ERROR | range | M7 | m7_q14_98 | Select-multiple indicator must equal zero or one | 123 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q15_1 | ERROR | range | M7 | m7_q15_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q15_2 | ERROR | range | M7 | m7_q15_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q15_3 | ERROR | range | M7 | m7_q15_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q15_4 | ERROR | range | M7 | m7_q15_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q15_5 | ERROR | range | M7 | m7_q15_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q15_6 | ERROR | range | M7 | m7_q15_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q15_7 | ERROR | range | M7 | m7_q15_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q15_8 | ERROR | range | M7 | m7_q15_8 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q15_9 | ERROR | range | M7 | m7_q15_9 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m7_q15_98 | ERROR | range | M7 | m7_q15_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m7_v01 | ERROR | range | M7 | m7_v01 | Observed code has no definition in its attached value label | 114 | 0 | 0 | PASS |
| VALUE_LABEL_m7_v02 | ERROR | range | M7 | m7_v02 | Observed code has no definition in its attached value label | 114 | 0 | 0 | PASS |
| VALUE_LABEL_m7_v12 | ERROR | range | M7 | m7_v12 | Observed code has no definition in its attached value label | 96 | 0 | 0 | PASS |
| VALUE_LABEL_m7_v13 | ERROR | range | M7 | m7_v13 | Observed code has no definition in its attached value label | 114 | 0 | 0 | PASS |
| VALUE_LABEL_m7_v14 | ERROR | range | M7 | m7_v14 | Observed code has no definition in its attached value label | 19 | 0 | 0 | PASS |
| VALUE_LABEL_m8_q01 | ERROR | range | M8 | m8_q01 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m8_q03 | ERROR | range | M8 | m8_q03 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m8_q04 | ERROR | range | M8 | m8_q04 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m8_q06 | ERROR | range | M8 | m8_q06 | Observed code has no definition in its attached value label | 132 | 0 | 0 | PASS |
| VALUE_LABEL_m8_q07 | ERROR | range | M8 | m8_q07 | Observed code has no definition in its attached value label | 132 | 0 | 0 | PASS |
| VALUE_LABEL_m8_q08 | ERROR | range | M8 | m8_q08 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m8_q09 | ERROR | range | M8 | m8_q09 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m8_q11 | ERROR | range | M8 | m8_q11 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m8_q12 | ERROR | range | M8 | m8_q12 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m8_q13 | ERROR | range | M8 | m8_q13 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m8_q14 | ERROR | range | M8 | m8_q14 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m8_q15_1 | ERROR | range | M8 | m8_q15_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m8_q15_10 | ERROR | range | M8 | m8_q15_10 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m8_q15_2 | ERROR | range | M8 | m8_q15_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m8_q15_3 | ERROR | range | M8 | m8_q15_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m8_q15_4 | ERROR | range | M8 | m8_q15_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m8_q15_5 | ERROR | range | M8 | m8_q15_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m8_q15_6 | ERROR | range | M8 | m8_q15_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m8_q15_7 | ERROR | range | M8 | m8_q15_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m8_q15_8 | ERROR | range | M8 | m8_q15_8 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m8_q15_9 | ERROR | range | M8 | m8_q15_9 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m8_q15_98 | ERROR | range | M8 | m8_q15_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m8_v01 | ERROR | range | M8 | m8_v01 | Observed code has no definition in its attached value label | 114 | 0 | 0 | PASS |
| VALUE_LABEL_m8_v02 | ERROR | range | M8 | m8_v02 | Observed code has no definition in its attached value label | 114 | 0 | 0 | PASS |
| VALUE_LABEL_m9_q12 | ERROR | range | M9 | m9_q12 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m9_q14 | ERROR | range | M9 | m9_q14 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m9_q15 | ERROR | range | M9 | m9_q15 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m9_q16_1 | ERROR | range | M9 | m9_q16_1 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m9_q16_10 | ERROR | range | M9 | m9_q16_10 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m9_q16_11 | ERROR | range | M9 | m9_q16_11 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m9_q16_2 | ERROR | range | M9 | m9_q16_2 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m9_q16_3 | ERROR | range | M9 | m9_q16_3 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m9_q16_4 | ERROR | range | M9 | m9_q16_4 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m9_q16_5 | ERROR | range | M9 | m9_q16_5 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m9_q16_6 | ERROR | range | M9 | m9_q16_6 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m9_q16_7 | ERROR | range | M9 | m9_q16_7 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m9_q16_8 | ERROR | range | M9 | m9_q16_8 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m9_q16_9 | ERROR | range | M9 | m9_q16_9 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| MULTI_BINARY_m9_q16_98 | ERROR | range | M9 | m9_q16_98 | Select-multiple indicator must equal zero or one | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m9_q17 | ERROR | range | M9 | m9_q17 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m9_q18 | ERROR | range | M9 | m9_q18 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_m9_q19 | ERROR | range | M9 | m9_q19 | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| SCORE_RANGE_active_member_part_score | ERROR | range | derived | active_member_part_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_adr_confidence_score | ERROR | range | derived | adr_confidence_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_adr_methods_score | ERROR | range | derived | adr_methods_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_bypass_frequency_score | ERROR | range | derived | bypass_frequency_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_case_experience_score | ERROR | range | derived | case_experience_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_case_register_score | ERROR | range | derived | case_register_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_case_review_score | ERROR | range | derived | case_review_score | Derived score or index is outside zero to one | 132 | 0 | 0 | PASS |
| SCORE_RANGE_caseload_accuracy_score | ERROR | range | derived | caseload_accuracy_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_classification_confidence_sc | ERROR | range | derived | classification_confidence_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_collective_discussion_score | ERROR | range | derived | collective_discussion_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_collective_handling_score | ERROR | range | derived | collective_handling_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_comm_role_reint_score | ERROR | range | derived | comm_role_reint_score | Derived score or index is outside zero to one | 132 | 0 | 0 | PASS |
| SCORE_RANGE_community_stigma_level_score | ERROR | range | derived | community_stigma_level_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_conf_fair_respect_score | ERROR | range | derived | conf_fair_respect_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_connect_support_willing_scor | ERROR | range | derived | connect_support_willing_score | Derived score or index is outside zero to one | 132 | 0 | 0 | PASS |
| SCORE_RANGE_court_coordination_score | ERROR | range | derived | court_coordination_score | Derived score or index is outside zero to one | 130 | 0 | 0 | PASS |
| SCORE_RANGE_decision_process_score | ERROR | range | derived | decision_process_score | Derived score or index is outside zero to one | 132 | 0 | 0 | PASS |
| SCORE_RANGE_deescalation_confidence_scor | ERROR | range | derived | deescalation_confidence_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_education_score | ERROR | range | derived | education_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_exclusion_norm_score | ERROR | range | derived | exclusion_norm_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_fair_chance_reintegration_sc | ERROR | range | derived | fair_chance_reintegration_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_fixed_place_score | ERROR | range | derived | fixed_place_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_adr_mediation_practice | ERROR | range | derived | idx_adr_mediation_practice | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_committee_functioning | ERROR | range | derived | idx_committee_functioning | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_institutional_functionin | ERROR | range | derived | idx_institutional_functioning | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_lcc_case_handling_qualit | ERROR | range | derived | idx_lcc_case_handling_quality | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_lcc_legitimacy_and_norms | ERROR | range | derived | idx_lcc_legitimacy_and_norms | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_lcc_operational_capacity | ERROR | range | derived | idx_lcc_operational_capacity | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_legal_classif_knowledge | ERROR | range | derived | idx_legal_classif_knowledge | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_p1_base_mentor_ready_pro | ERROR | range | derived | idx_p1_base_mentor_ready_proxy | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_perceived_legitimacy | ERROR | range | derived | idx_perceived_legitimacy | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_record_quality | ERROR | range | derived | idx_record_quality | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_referral_practice | ERROR | range | derived | idx_referral_practice | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_reintegration_norms | ERROR | range | derived | idx_reintegration_norms | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_respondent_capacity | ERROR | range | derived | idx_respondent_capacity | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_safeguard_classif_know | ERROR | range | derived | idx_safeguard_classif_know | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_safeguards | ERROR | range | derived | idx_safeguards | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_idx_vignette_classification | ERROR | range | derived | idx_vignette_classification | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_inst_record_exist_score | ERROR | range | derived | inst_record_exist_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_inst_record_uptodate_score | ERROR | range | derived | inst_record_uptodate_score | Derived score or index is outside zero to one | 131 | 0 | 0 | PASS |
| SCORE_RANGE_lc_experience_score | ERROR | range | derived | lc_experience_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_low_bypass_score | ERROR | range | derived | low_bypass_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_low_exclusion_norm_score | ERROR | range | derived | low_exclusion_norm_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_low_favoritism_influence_sco | ERROR | range | derived | low_favoritism_influence_score | Derived score or index is outside zero to one | 131 | 0 | 0 | PASS |
| SCORE_RANGE_low_reoffending_stigma_score | ERROR | range | derived | low_reoffending_stigma_score | Derived score or index is outside zero to one | 132 | 0 | 0 | PASS |
| SCORE_RANGE_m4_q01_local_scope_score | ERROR | range | derived | m4_q01_local_scope_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_m4_q02_referral_scope_score | ERROR | range | derived | m4_q02_referral_scope_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_m4_q05_documentation_score | ERROR | range | derived | m4_q05_documentation_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_m4_q06_procedure_score | ERROR | range | derived | m4_q06_procedure_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_m4_q08_authority_score | ERROR | range | derived | m4_q08_authority_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_m5_q01_score | ERROR | range | derived | m5_q01_score | Derived score or index is outside zero to one | 131 | 0 | 0 | PASS |
| SCORE_RANGE_m5_q02_score | ERROR | range | derived | m5_q02_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_m5_q03_score | ERROR | range | derived | m5_q03_score | Derived score or index is outside zero to one | 132 | 0 | 0 | PASS |
| SCORE_RANGE_m5_q06_score | ERROR | range | derived | m5_q06_score | Derived score or index is outside zero to one | 132 | 0 | 0 | PASS |
| SCORE_RANGE_m5_q07_score | ERROR | range | derived | m5_q07_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_m5_q14_score | ERROR | range | derived | m5_q14_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_m5_q16_score | ERROR | range | derived | m5_q16_score | Derived score or index is outside zero to one | 131 | 0 | 0 | PASS |
| SCORE_RANGE_materials_score | ERROR | range | derived | materials_score | Derived score or index is outside zero to one | 130 | 0 | 0 | PASS |
| SCORE_RANGE_meeting_frequency_score | ERROR | range | derived | meeting_frequency_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_most_recent_entry_score | ERROR | range | derived | most_recent_entry_score | Derived score or index is outside zero to one | 122 | 0 | 0 | PASS |
| SCORE_RANGE_outcome_recorded_score | ERROR | range | derived | outcome_recorded_score | Derived score or index is outside zero to one | 123 | 0 | 0 | PASS |
| SCORE_RANGE_perc_favor_influence_score | ERROR | range | derived | perc_favor_influence_score | Derived score or index is outside zero to one | 131 | 0 | 0 | PASS |
| SCORE_RANGE_perc_willing_use_lcc_score | ERROR | range | derived | perc_willing_use_lcc_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_perceived_lcc_fairness_score | ERROR | range | derived | perceived_lcc_fairness_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_perceived_reoffending_risk_s | ERROR | range | derived | perceived_reoffending_risk_score | Derived score or index is outside zero to one | 132 | 0 | 0 | PASS |
| SCORE_RANGE_petty_case_share_score | ERROR | range | derived | petty_case_share_score | Derived score or index is outside zero to one | 96 | 0 | 0 | PASS |
| SCORE_RANGE_police_coordination_score | ERROR | range | derived | police_coordination_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_procedure_confidence_score | ERROR | range | derived | procedure_confidence_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_quorum_score | ERROR | range | derived | quorum_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_record_fields_score | ERROR | range | derived | record_fields_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_record_literacy_score | ERROR | range | derived | record_literacy_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_record_retrieval_score | ERROR | range | derived | record_retrieval_score | Derived score or index is outside zero to one | 123 | 0 | 0 | PASS |
| SCORE_RANGE_record_type_breadth_score | ERROR | range | derived | record_type_breadth_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_record_uptodate_score | ERROR | range | derived | record_uptodate_score | Derived score or index is outside zero to one | 122 | 0 | 0 | PASS |
| SCORE_RANGE_record_validation_score | ERROR | range | derived | record_validation_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_referral_documentation_score | ERROR | range | derived | referral_documentation_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_referral_explain_conf_score | ERROR | range | derived | referral_explain_conf_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_referral_feedback_score | ERROR | range | derived | referral_feedback_score | Derived score or index is outside zero to one | 130 | 0 | 0 | PASS |
| SCORE_RANGE_referral_frequency_score | ERROR | range | derived | referral_frequency_score | Derived score or index is outside zero to one | 131 | 0 | 0 | PASS |
| SCORE_RANGE_referral_path_conf_score | ERROR | range | derived | referral_path_conf_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_reint_leadership_role_score | ERROR | range | derived | reint_leadership_role_score | Derived score or index is outside zero to one | 0 | 0 |  | PASS |
| SCORE_RANGE_reint_referral_conf_score | ERROR | range | derived | reint_referral_conf_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_reint_support_breadth_score | ERROR | range | derived | reint_support_breadth_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_reint_tension_conf_score | ERROR | range | derived | reint_tension_conf_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_reintegration_importance_sco | ERROR | range | derived | reintegration_importance_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_reintegration_willingness_sc | ERROR | range | derived | reintegration_willingness_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_secure_storage_score | ERROR | range | derived | secure_storage_score | Derived score or index is outside zero to one | 122 | 0 | 0 | PASS |
| SCORE_RANGE_similar_case_consistency_sco | ERROR | range | derived | similar_case_consistency_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_special_handling_practices_s | ERROR | range | derived | special_handling_practices_score | Derived score or index is outside zero to one | 0 | 0 |  | PASS |
| SCORE_RANGE_verif_sensitive_conf_score | ERROR | range | derived | verif_sensitive_conf_score | Derived score or index is outside zero to one | 0 | 0 |  | PASS |
| SCORE_RANGE_verif_sensitive_ref_score | ERROR | range | derived | verif_sensitive_ref_score | Derived score or index is outside zero to one | 0 | 0 |  | PASS |
| SCORE_RANGE_verified_case_register_score | ERROR | range | derived | verified_case_register_score | Derived score or index is outside zero to one | 114 | 0 | 0 | PASS |
| SCORE_RANGE_verified_member_part_score | ERROR | range | derived | verified_member_part_score | Derived score or index is outside zero to one | 105 | 0 | 0 | PASS |
| SCORE_RANGE_verified_multimember_val_sco | ERROR | range | derived | verified_multimember_val_score | Derived score or index is outside zero to one | 103 | 0 | 0 | PASS |
| SCORE_RANGE_verified_proceedings_score | ERROR | range | derived | verified_proceedings_score | Derived score or index is outside zero to one | 114 | 0 | 0 | PASS |
| SCORE_RANGE_verified_record_usability_sc | ERROR | range | derived | verified_record_usability_score | Derived score or index is outside zero to one | 107 | 0 | 0 | PASS |
| SCORE_RANGE_verified_ref_dest_score | ERROR | range | derived | verified_ref_dest_score | Derived score or index is outside zero to one | 99 | 0 | 0 | PASS |
| SCORE_RANGE_verified_referral_record_sco | ERROR | range | derived | verified_referral_record_score | Derived score or index is outside zero to one | 96 | 0 | 0 | PASS |
| SCORE_RANGE_verified_storage_score | ERROR | range | derived | verified_storage_score | Derived score or index is outside zero to one | 96 | 0 | 0 | PASS |
| SCORE_RANGE_weekly_lc_time_score | ERROR | range | derived | weekly_lc_time_score | Derived score or index is outside zero to one | 133 | 0 | 0 | PASS |
| SCORE_RANGE_women_participation_score | ERROR | range | derived | women_participation_score | Derived score or index is outside zero to one | 132 | 0 | 0 | PASS |
| VALUE_LABEL_analysis_sample | ERROR | range | metadata | analysis_sample | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_any_child_or_sgbv_case_3m | ERROR | range | metadata | any_child_or_sgbv_case_3m | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_any_reintegration_case_3m | ERROR | range | metadata | any_reintegration_case_3m | Observed code has no definition in its attached value label | 96 | 0 | 0 | PASS |
| VALUE_LABEL_any_serious_or_sensitive_cas | ERROR | range | metadata | any_serious_or_sensitive_case_3m | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_attend_cdfu_training | ERROR | range | metadata | attend_cdfu_training | Observed code has no definition in its attached value label | 132 | 0 | 0 | PASS |
| VALUE_LABEL_bypass_due_bias | ERROR | range | metadata | bypass_due_bias | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_bypass_due_distrust | ERROR | range | metadata | bypass_due_distrust | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_bypass_due_enforcement | ERROR | range | metadata | bypass_due_enforcement | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_bypass_due_mandate_uncertain | ERROR | range | metadata | bypass_due_mandate_uncertainty | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_bypass_due_serious_case | ERROR | range | metadata | bypass_due_serious_case | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_can_record_english | ERROR | range | metadata | can_record_english | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_can_record_runyankore | ERROR | range | metadata | can_record_runyankore | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_cannot_complete_records | ERROR | range | metadata | cannot_complete_records | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_comm_accepts_ex_prisoner | ERROR | range | metadata | comm_accepts_ex_prisoner | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_completed_secondary_or_above | ERROR | range | metadata | completed_secondary_or_above | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_consent | ERROR | range | metadata | consent | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_eligible_cases_rarely_bypass | ERROR | range | metadata | eligible_cases_rarely_bypass | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_flag_any_data_quality_issue | ERROR | range | metadata | flag_any_data_quality_issue | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_flag_caseload_30d_gt_3m | ERROR | range | metadata | flag_caseload_30d_gt_3m | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_flag_date_outside_fieldwork | ERROR | range | metadata | flag_date_outside_fieldwork | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_flag_direct_gt_3m | ERROR | range | metadata | flag_direct_gt_3m | Observed code has no definition in its attached value label | 95 | 0 | 0 | PASS |
| VALUE_LABEL_flag_duplicate_scto_village | ERROR | range | metadata | flag_duplicate_scto_village | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_flag_duration_long | ERROR | range | metadata | flag_duration_long | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_flag_duration_short | ERROR | range | metadata | flag_duration_short | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_flag_no_consent | ERROR | range | metadata | flag_no_consent | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_flag_pending_gt_3m | ERROR | range | metadata | flag_pending_gt_3m | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_flag_referred_onward_gt_3m | ERROR | range | metadata | flag_referred_onward_gt_3m | Observed code has no definition in its attached value label | 0 | 0 |  | PASS |
| VALUE_LABEL_flag_referred_to_lcc_gt_3m | ERROR | range | metadata | flag_referred_to_lcc_gt_3m | Observed code has no definition in its attached value label | 0 | 0 |  | PASS |
| VALUE_LABEL_handled_child_or_sgbv_case | ERROR | range | metadata | handled_child_or_sgbv_case | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_high_case_handling_quality | ERROR | range | metadata | high_case_handling_quality | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_high_legitimacy_norms | ERROR | range | metadata | high_legitimacy_norms | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_high_mentor_readiness_proxy | ERROR | range | metadata | high_mentor_readiness_proxy | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_high_operational_capacity | ERROR | range | metadata | high_operational_capacity | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_lcc_has_vacancy | ERROR | range | metadata | lcc_has_vacancy | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_lcc_has_woman_member | ERROR | range | metadata | lcc_has_woman_member | Observed code has no definition in its attached value label | 132 | 0 | 0 | PASS |
| VALUE_LABEL_merge_sampling_frame | ERROR | range | metadata | merge_sampling_frame | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_no_major_committee_challenge | ERROR | range | metadata | no_major_committee_challenges | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_no_major_record_challenges | ERROR | range | metadata | no_major_record_challenges | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_no_major_referral_barriers | ERROR | range | metadata | no_major_referral_barriers | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_no_reintegration_support_nee | ERROR | range | metadata | no_reintegration_support_needed | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_noncomp_response_app | ERROR | range | metadata | noncomp_response_app | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_p1_admin_inherited_fhri | ERROR | range | metadata | p1_admin_inherited_fhri | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_p1_admin_last_cdfu | ERROR | range | metadata | p1_admin_last_cdfu | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_p1_admin_new | ERROR | range | metadata | p1_admin_new | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_p1_admin_origin | ERROR | range | metadata | p1_admin_origin | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_p1_admin_previously_contacte | ERROR | range | metadata | p1_admin_previously_contacted | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_prior_cdfu_fhri_training | ERROR | range | metadata | prior_cdfu_fhri_training | Observed code has no definition in its attached value label | 132 | 0 | 0 | PASS |
| VALUE_LABEL_prior_formal_coordination | ERROR | range | metadata | prior_formal_coordination | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_prior_justice_training | ERROR | range | metadata | prior_justice_training | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_qa_raw_merge | ERROR | range | metadata | qa_raw_merge | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_recent_reint_serious_ref | ERROR | range | metadata | recent_reint_serious_ref | Observed code has no definition in its attached value label | 0 | 0 |  | PASS |
| VALUE_LABEL_recent_reint_stigma | ERROR | range | metadata | recent_reint_stigma | Observed code has no definition in its attached value label | 0 | 0 |  | PASS |
| VALUE_LABEL_recent_reintegration_issue | ERROR | range | metadata | recent_reintegration_issue | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_records_access_open_to_commu | ERROR | range | metadata | records_access_open_to_community | Observed code has no definition in its attached value label | 123 | 0 | 0 | PASS |
| VALUE_LABEL_reint_comm_justice_role | ERROR | range | metadata | reint_comm_justice_role | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_reint_response_supportive | ERROR | range | metadata | reint_response_supportive | Observed code has no definition in its attached value label | 0 | 0 |  | PASS |
| VALUE_LABEL_respondent_female | ERROR | range | metadata | respondent_female | Observed code has no definition in its attached value label | 132 | 0 | 0 | PASS |
| VALUE_LABEL_sample_hotspot_p75 | ERROR | range | metadata | sample_hotspot_p75 | Observed code has no definition in its attached value label | 0 | 0 |  | PASS |
| VALUE_LABEL_sample_hotspot_p90 | ERROR | range | metadata | sample_hotspot_p90 | Observed code has no definition in its attached value label | 0 | 0 |  | PASS |
| VALUE_LABEL_sh_avoid_unsafe_mediation | ERROR | range | metadata | sh_avoid_unsafe_mediation | Observed code has no definition in its attached value label | 0 | 0 |  | PASS |
| VALUE_LABEL_sh_includes_confidentiality | ERROR | range | metadata | sh_includes_confidentiality | Observed code has no definition in its attached value label | 0 | 0 |  | PASS |
| VALUE_LABEL_sh_includes_referral | ERROR | range | metadata | sh_includes_referral | Observed code has no definition in its attached value label | 0 | 0 |  | PASS |
| VALUE_LABEL_survey_village_id | ERROR | range | metadata | survey_village_id | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_vulnerable_need_sh | ERROR | range | metadata | vulnerable_need_sh | Observed code has no definition in its attached value label | 133 | 0 | 0 | PASS |
| VALUE_LABEL_women_perspective_mechanism | ERROR | range | metadata | women_perspective_mechanism | Observed code has no definition in its attached value label | 132 | 0 | 0 | PASS |
| MULTI_BINARY_topics_trained_1 | ERROR | range | survey | topics_trained_1 | Select-multiple indicator must equal zero or one | 41 | 0 | 0 | PASS |
| MULTI_BINARY_topics_trained_2 | ERROR | range | survey | topics_trained_2 | Select-multiple indicator must equal zero or one | 41 | 0 | 0 | PASS |
| MULTI_BINARY_topics_trained_3 | ERROR | range | survey | topics_trained_3 | Select-multiple indicator must equal zero or one | 41 | 0 | 0 | PASS |
| MULTI_BINARY_topics_trained_4 | ERROR | range | survey | topics_trained_4 | Select-multiple indicator must equal zero or one | 41 | 0 | 0 | PASS |
| MULTI_BINARY_topics_trained_5 | ERROR | range | survey | topics_trained_5 | Select-multiple indicator must equal zero or one | 41 | 0 | 0 | PASS |
| MULTI_BINARY_topics_trained_6 | ERROR | range | survey | topics_trained_6 | Select-multiple indicator must equal zero or one | 41 | 0 | 0 | PASS |
| MULTI_BINARY_topics_trained_7 | ERROR | range | survey | topics_trained_7 | Select-multiple indicator must equal zero or one | 41 | 0 | 0 | PASS |
| MULTI_BINARY_topics_trained_98 | ERROR | range | survey | topics_trained_98 | Select-multiple indicator must equal zero or one | 41 | 0 | 0 | PASS |
| EXPECTED_ADMIN_ADDED_COUNT | ERROR | sample | sample | p1_admin_previously_contacted | Administrative previously-contacted count matches the approved Phase 1 list | 1 | 0 | 0 | PASS |
| EXPECTED_UNIQUE_VILLAGES | ERROR | sample | sample | survey_village_uid | Unique surveyed village count equals the planned Phase 1 village count | 1 | 0 | 0 | PASS |
| SCHEMA_consent | ERROR | schema | metadata | consent | Required baseline QA variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_district_scto | ERROR | schema | metadata | district_scto | Required baseline QA variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_duration_min | ERROR | schema | metadata | duration_min | Required baseline QA variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_enum | ERROR | schema | metadata | enum | Required baseline QA variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_interview_date | ERROR | schema | metadata | interview_date | Required baseline QA variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_parish_scto | ERROR | schema | metadata | parish_scto | Required baseline QA variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_subcounty_scto | ERROR | schema | metadata | subcounty_scto | Required baseline QA variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_submission_key | ERROR | schema | metadata | submission_key | Required baseline QA variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_village_scto | ERROR | schema | metadata | village_scto | Required baseline QA variable is present | 1 | 0 | 0 | PASS |
| M1_Q10_EXCLUSIVE | ERROR | select_multiple | M1 | m1_q10_95 | Cannot complete records is selected with a language option | 133 | 0 | 0 | PASS |
| M1_Q14_EXCLUSIVE | ERROR | select_multiple | M1 | m1_q14_95 | No case type is selected with a substantive case type | 133 | 0 | 0 | PASS |
| M11_Q10_EXCLUSIVE | ERROR | select_multiple | M11 | m11_q10_9 | No support needed is selected with a support type | 133 | 0 | 0 | PASS |
| M11_Q12_MAX_THREE | ERROR | select_multiple | M11 | m11_q12_1 m11_q12_2 m11_q12_3 m11_q12_4 m11_q12_5 m11_q12_6 m11_ | More than three reintegration barriers were selected | 133 | 0 | 0 | PASS |
| M11_Q12_EXCLUSIVE | ERROR | select_multiple | M11 | m11_q12_9 | Community acceptance is selected with a reintegration barrier | 133 | 0 | 0 | PASS |
| M7_Q03_EXCLUSIVE | ERROR | select_multiple | M7 | m7_q03_95 | No written record is selected with a record type | 133 | 0 | 0 | PASS |
| M7_Q15_EXCLUSIVE | ERROR | select_multiple | M7 | m7_q15_9 | No record challenge is selected with a substantive challenge | 133 | 0 | 0 | PASS |
| M9_Q16_MAX_THREE | ERROR | select_multiple | M9 | m9_q16_1 m9_q16_2 m9_q16_3 m9_q16_4 m9_q16_5 m9_q16_6 m9_q16_7 m | More than three bypass reasons were selected | 133 | 0 | 0 | PASS |
| VACANCY_COUNT_STRAY | ERROR | skip_logic | M2 | m2_q04 | Positive vacancy count is present although vacancies were not reported | 42 | 0 | 0 | PASS |
| M7_UPTODATE_WITH_NO_REGISTER | ERROR | skip_logic | M7 | m7_q04 | Record status is answered although no written case register exists | 10 | 0 | 0 | PASS |
| TRAINING_TOPICS_STRAY | ERROR | skip_logic | training | topics_trained_* | Training topics are selected although prior training was not reported | 91 | 0 | 0 | PASS |
| MODULE_10_ALL_MISSING | WARNING | completeness | M10 | m10_* | All fields in this survey module are missing | 133 | 0 | 0 | PASS |
| MISSING_INDEX_idx_adr_mediation_practice | WARNING | completeness | indices | idx_adr_mediation_practice | Core module index is missing | 133 | 0 | 0 | PASS |
| MISSING_INDEX_idx_committee_functioning | WARNING | completeness | indices | idx_committee_functioning | Core module index is missing | 133 | 0 | 0 | PASS |
| MISSING_INDEX_idx_institutional_function | WARNING | completeness | indices | idx_institutional_functioning | Core module index is missing | 133 | 0 | 0 | PASS |
| MISSING_INDEX_idx_legal_classif_knowledg | WARNING | completeness | indices | idx_legal_classif_knowledge | Core module index is missing | 133 | 0 | 0 | PASS |
| MISSING_INDEX_idx_perceived_legitimacy | WARNING | completeness | indices | idx_perceived_legitimacy | Core module index is missing | 133 | 0 | 0 | PASS |
| MISSING_INDEX_idx_record_quality | WARNING | completeness | indices | idx_record_quality | Core module index is missing | 133 | 0 | 0 | PASS |
| MISSING_INDEX_idx_referral_practice | WARNING | completeness | indices | idx_referral_practice | Core module index is missing | 133 | 0 | 0 | PASS |
| MISSING_INDEX_idx_reintegration_norms | WARNING | completeness | indices | idx_reintegration_norms | Core module index is missing | 133 | 0 | 0 | PASS |
| MISSING_INDEX_idx_respondent_capacity | WARNING | completeness | indices | idx_respondent_capacity | Core module index is missing | 133 | 0 | 0 | PASS |
| MISSING_INDEX_idx_safeguards | WARNING | completeness | indices | idx_safeguards | Core module index is missing | 133 | 0 | 0 | PASS |
| CASE_SOURCES_GT_CASELOAD | WARNING | consistency | M3 | m3_q09 m3_q10 | Directly brought plus referred-in cases exceed three-month caseload | 0 | 0 |  | PASS |
| MISSING_INSTANCE_ID | WARNING | identity | metadata | instance_id | SurveyCTO instance ID is missing | 133 | 0 | 0 | PASS |
| RAW_INPUT_AVAILABLE | WARNING | lineage | metadata | raw SurveyCTO export | Raw SurveyCTO workbook is available and contains a submission key | 1 | 0 | 0 | PASS |
| PLAUSIBILITY_m1_q04 | WARNING | outlier | survey | m1_q04 | Count exceeds the configured plausibility ceiling | 133 | 0 | 0 | PASS |
| PLAUSIBILITY_m2_q01 | WARNING | outlier | survey | m2_q01 | Count exceeds the configured plausibility ceiling | 133 | 0 | 0 | PASS |
| PLAUSIBILITY_m2_q04 | WARNING | outlier | survey | m2_q04 | Count exceeds the configured plausibility ceiling | 0 | 0 |  | PASS |
| PLAUSIBILITY_m2_q05 | WARNING | outlier | survey | m2_q05 | Count exceeds the configured plausibility ceiling | 132 | 0 | 0 | PASS |
| PLAUSIBILITY_m2_q06 | WARNING | outlier | survey | m2_q06 | Count exceeds the configured plausibility ceiling | 133 | 0 | 0 | PASS |
| PLAUSIBILITY_m3_q02 | WARNING | outlier | survey | m3_q02 | Count exceeds the configured plausibility ceiling | 133 | 0 | 0 | PASS |
| PLAUSIBILITY_m3_q03 | WARNING | outlier | survey | m3_q03 | Count exceeds the configured plausibility ceiling | 133 | 0 | 0 | PASS |
| PLAUSIBILITY_m3_q08 | WARNING | outlier | survey | m3_q08 | Count exceeds the configured plausibility ceiling | 133 | 0 | 0 | PASS |
| PLAUSIBILITY_m3_q09 | WARNING | outlier | survey | m3_q09 | Count exceeds the configured plausibility ceiling | 95 | 0 | 0 | PASS |
| PLAUSIBILITY_m3_q10 | WARNING | outlier | survey | m3_q10 | Count exceeds the configured plausibility ceiling | 0 | 0 |  | PASS |
| PLAUSIBILITY_m3_q12 | WARNING | outlier | survey | m3_q12 | Count exceeds the configured plausibility ceiling | 0 | 0 |  | PASS |
| MISSING_DURATION | WARNING | paradata | metadata | duration_min | Interview duration is missing | 133 | 0 | 0 | PASS |
| MISSING_END_TIME | WARNING | paradata | metadata | endtime_dt | Interview end time is missing | 133 | 0 | 0 | PASS |
| OUTSIDE_FIELDWORK_WINDOW | WARNING | paradata | metadata | interview_date | Interview date falls outside the configured fieldwork window | 133 | 0 | 0 | PASS |
| UNUSUAL_INTERVIEW_HOUR | WARNING | paradata | metadata | interview_hour | Interview started outside configured daytime hours | 133 | 0 | 0 | PASS |
| MISSING_START_TIME | WARNING | paradata | metadata | starttime_dt | Interview start time is missing | 133 | 0 | 0 | PASS |
| SCHEMA_m1_q04 | WARNING | schema | M1 | m1_q04 | Expected module anchor variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_m10_q07 | WARNING | schema | M10 | m10_q07 | Expected module anchor variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_m11_q02 | WARNING | schema | M11 | m11_q02 | Expected module anchor variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_m2_q01 | WARNING | schema | M2 | m2_q01 | Expected module anchor variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_m3_q02 | WARNING | schema | M3 | m3_q02 | Expected module anchor variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_m4_q01_1 | WARNING | schema | M4 | m4_q01_1 | Expected module anchor variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_m5_q01 | WARNING | schema | M5 | m5_q01 | Expected module anchor variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_m6_q01 | WARNING | schema | M6 | m6_q01 | Expected module anchor variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_m7_q01 | WARNING | schema | M7 | m7_q01 | Expected module anchor variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_m8_q01 | WARNING | schema | M8 | m8_q01 | Expected module anchor variable is present | 1 | 0 | 0 | PASS |
| SCHEMA_m9_q12 | WARNING | schema | M9 | m9_q12 | Expected module anchor variable is present | 1 | 0 | 0 | PASS |
| M1_Q10_OTHER_MISS | WARNING | skip_logic | M1 | m1_q10_other | Other was selected but the specify field is empty | 0 | 0 |  | PASS |
| M1_Q10_OTHER_STRAY | WARNING | skip_logic | M1 | m1_q10_other | Specify text or value is present although Other was not selected | 133 | 0 | 0 | PASS |
| M1_Q14_OTHER_STRAY | WARNING | skip_logic | M1 | m1_q14_specify | Specify text or value is present although Other was not selected | 130 | 0 | 0 | PASS |
| M1_Q08_OTHER_MISS | WARNING | skip_logic | M1 | other_education | Other was selected but the specify field is empty | 0 | 0 |  | PASS |
| M1_Q08_OTHER_STRAY | WARNING | skip_logic | M1 | other_education | Specify text or value is present although Other was not selected | 133 | 0 | 0 | PASS |
| M11_RESPONSE_STRAY | WARNING | skip_logic | M11 | m11_q15 | LCC reintegration response is present although no recent issue was reported | 51 | 0 | 0 | PASS |
| M2_Q15_OTHER_STRAY | WARNING | skip_logic | M2 | m2_q15_specify | Specify text or value is present although Other was not selected | 70 | 0 | 0 | PASS |
| M2_VERIFICATION_MISSING | WARNING | skip_logic | M2 | m2_q17 | Enumerator saw a record but the follow-up verification is missing | 104 | 0 | 0 | PASS |
| TRAINING_OTHER_MISS | WARNING | skip_logic | training | other_training | Other was selected but the specify field is empty | 0 | 0 |  | PASS |
| TRAINING_OTHER_STRAY | WARNING | skip_logic | training | other_training | Specify text or value is present although Other was not selected | 41 | 0 | 0 | PASS |
| TRAINING_RATING_MISSING | WARNING | skip_logic | training | rating_cdfu_training | Prior training reported but usefulness rating is missing | 41 | 0 | 0 | PASS |
| TRAINING_TOPICS_MISSING | WARNING | skip_logic | training | topics_trained_* | Prior training reported but no training topic was selected | 41 | 0 | 0 | PASS |
| DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 133 | 46 | 0.3458646616541353 | REVIEW |
| LONG_DURATION | WARNING | paradata | metadata | duration_min | Interview duration is above the configured maximum | 133 | 3 | 0.022556390977443608 | REVIEW |
| SHORT_DURATION | WARNING | paradata | metadata | duration_min | Interview duration is below the configured minimum | 133 | 7 | 0.05263157894736842 | REVIEW |
| M11_STRAIGHTLINE | WARNING | response_pattern | M11 | m11 scales | Eight reintegration scale items have exactly the same normalized response | 130 | 2 | 0.015384615384615385 | REVIEW |
| M5_STRAIGHTLINE | WARNING | response_pattern | M5 | m5 scales | At least eight ADR scale items have exactly the same normalized response | 133 | 5 | 0.03759398496240601 | REVIEW |
| M1_Q14_OTHER_MISS | WARNING | skip_logic | M1 | m1_q14_specify | Other was selected but the specify field is empty | 3 | 2 | 0.6666666666666666 | REVIEW |
| M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | 82 | 82 | 1 | REVIEW |
| M2_RECORD_UPTODATE_STRAY | WARNING | skip_logic | M2 | m2_q13 | Record-up-to-date response is present although no records are kept | 3 | 3 | 1 | REVIEW |
| M2_Q15_OTHER_MISS | WARNING | skip_logic | M2 | m2_q15_specify | Other was selected but the specify field is empty | 2 | 1 | 0.5 | REVIEW |
| TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 91 | 24 | 0.26373626373626374 | REVIEW |
| UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 133 | 133 | 1 | INFO |
## Sheet: issues
| qa_row_id | qa_record_id | qa_enumerator | qa_district | qa_subcounty | qa_parish | qa_village | check_id | severity | domain | module | variable | issue | observed_value |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 61 | uuid:9b2951b5-9998-4409-a291-3e8ad115dcdd | Nayebare Christine | Rubirizi | Katerera Town council | Katerera ward | Katabengo | m3_q08_GT_CASELOAD | ERROR | consistency | M3 | m3_q08 | Case component exceeds the reported three-month caseload | 1 |
| 76 | uuid:1e7692a5-c876-47e9-9554-df0026d76452 | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Ntunga A | m3_q08_GT_CASELOAD | ERROR | consistency | M3 | m3_q08 | Case component exceeds the reported three-month caseload | 3 |
| 127 | uuid:b1999bec-89d4-477b-b49e-15838313a589 | Natukunda Britah | Sheema | Masheruka sub county | Mabare | Rwichumu | m3_q08_GT_CASELOAD | ERROR | consistency | M3 | m3_q08 | Case component exceeds the reported three-month caseload | 3 |
| 112 | uuid:9cc25ab4-3f37-41c7-875c-e0373445bdc4 | Natukunda Britah | Sheema | kagango | Kagango | Kanyina | m3_q08_GT_CASELOAD | ERROR | consistency | M3 | m3_q08 | Case component exceeds the reported three-month caseload | 2 |
| 113 | uuid:1b082c5b-eb05-4fac-b2c9-7c9726482325 | Natukunda Britah | Sheema | kagango | Kagango | Kihunda | m3_q08_GT_CASELOAD | ERROR | consistency | M3 | m3_q08 | Case component exceeds the reported three-month caseload | 1 |
| 114 | uuid:eaffe867-85ef-4432-91ff-51ba954becbb | Natukunda Britah | Sheema | kagango | Kagango | Kiziba | m3_q08_GT_CASELOAD | ERROR | consistency | M3 | m3_q08 | Case component exceeds the reported three-month caseload | 2 |
| 4 | uuid:8d48e301-d2fa-409b-8702-c516833d1413 | Akankwasa Ronals | Bushenyi | Bumbaire | Bumbaire | Kibaare II | ENUMERATOR_OVERLAP | ERROR | paradata | metadata | starttime_dt | Interview starts before the same enumerator's previous interview ended | 30may2026 15:32:47 |
| 15 | uuid:3723f508-9574-49d2-85e8-8749e75302da | Natukunda Britah | Bushenyi | Ishaka Division | Ishaka | K.I.U | ENUMERATOR_OVERLAP | ERROR | paradata | metadata | starttime_dt | Interview starts before the same enumerator's previous interview ended | 19may2026 16:04:41 |
| 16 | uuid:d44d3c96-36e1-4c51-af3d-17df55309d0c | Akankwasa Ronals | Bushenyi | Kakanju | Kakanju | Kakuto B | ENUMERATOR_OVERLAP | ERROR | paradata | metadata | starttime_dt | Interview starts before the same enumerator's previous interview ended | 18may2026 13:07:26 |
| 27 | uuid:2190d328-1a42-4f7b-874d-a670dda437fe | Natukunda Britah | Bushenyi | Kizinda Town Council | Nyabubare | Nyakinengo | ENUMERATOR_OVERLAP | ERROR | paradata | metadata | starttime_dt | Interview starts before the same enumerator's previous interview ended | 19may2026 12:35:02 |
| 23 | uuid:14af339d-a5db-42c6-8b92-00c591eea57c | Natukunda Britah | Bushenyi | Kizinda Town Council | Kigoma | Ryabuganyi | ENUMERATOR_OVERLAP | ERROR | paradata | metadata | starttime_dt | Interview starts before the same enumerator's previous interview ended | 19may2026 09:26:52 |
| 52 | uuid:169749d4-c6a2-497c-87f8-aaf62383ecc2 | Akankwasa Ronals | Bushenyi | Ruhumuro | Burungira | Orubingo A | ENUMERATOR_OVERLAP | ERROR | paradata | metadata | starttime_dt | Interview starts before the same enumerator's previous interview ended | 30may2026 11:24:33 |
| 88 | uuid:c1cc92c3-2823-4c09-a104-5f6962c22859 | Nayebare Christine | Rubirizi | Kyabakara | Rugarama | Nyabubare | ENUMERATOR_OVERLAP | ERROR | paradata | metadata | starttime_dt | Interview starts before the same enumerator's previous interview ended | 20may2026 15:09:25 |
| 89 | uuid:a4206fdb-447d-4ad9-8638-8e4f3f348321 | Nayebare Christine | Rubirizi | Magambo | Bugaya | Busonga II | ENUMERATOR_OVERLAP | ERROR | paradata | metadata | starttime_dt | Interview starts before the same enumerator's previous interview ended | 20may2026 09:42:56 |
| 95 | uuid:52263d60-be6d-4e58-b163-301a9db00945 | Nayebare Christine | Rubirizi | Ryeru | Butoha | Nyakiyaza | ENUMERATOR_OVERLAP | ERROR | paradata | metadata | starttime_dt | Interview starts before the same enumerator's previous interview ended | 20may2026 11:48:16 |
| 115 | uuid:a0e54d95-462a-4ca7-bd6e-690f32651880 | Nayebare Christine | Sheema | Kasana Sub county | Karugorora | Karugorora | ENUMERATOR_OVERLAP | ERROR | paradata | metadata | starttime_dt | Interview starts before the same enumerator's previous interview ended | 21may2026 15:05:55 |
| 7 | uuid:b544facc-28d8-4fd3-b224-77092facdf73 |  | Bushenyi | Bumbaire | Nyabubare | Bumbaire II | VALUE_LABEL_enum | ERROR | range | metadata | enum | Observed code has no definition in its attached value label | 11 |
| 5 | uuid:923cc8d1-ce02-42bc-b7d6-999bd8956e14 |  | Bushenyi | Bumbaire | Bumbaire | Kisubu | VALUE_LABEL_enum | ERROR | range | metadata | enum | Observed code has no definition in its attached value label | 11 |
| 9 | uuid:fe9ea2c4-1f7c-4020-80fd-b9bdaabb20a3 |  | Bushenyi | Bushenyi central | Kyeitembe | Bwatogo | VALUE_LABEL_enum | ERROR | range | metadata | enum | Observed code has no definition in its attached value label | 11 |
| 10 | uuid:f65ed9f8-26f6-4753-b289-857c81fa117e |  | Bushenyi | Bushenyi central | Ward II | Ruhandagazi | VALUE_LABEL_enum | ERROR | range | metadata | enum | Observed code has no definition in its attached value label | 11 |
| 50 | uuid:c1a0be42-3215-4961-a0bb-04cbfb5baca4 |  | Bushenyi | Nyakabirizi | Ward II | Katungu | VALUE_LABEL_enum | ERROR | range | metadata | enum | Observed code has no definition in its attached value label | 11 |
| 33 | uuid:476cec79-33e1-43cf-a0ee-3f319d1606f9 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Nyakahanga | DUPLICATE_SURVEY_VILLAGE | ERROR | sample | geography | survey_village_uid | More than one submission uses the same SurveyCTO village key | bushenyi_kyamuhunga_town_butare_nyakahanga |
| 34 | uuid:195cf6b6-333c-44b9-8453-f711db689316 | Akankwasa Ronals | Bushenyi | Kyamuhunga Town | Butare | Nyakahanga | DUPLICATE_SURVEY_VILLAGE | ERROR | sample | geography | survey_village_uid | More than one submission uses the same SurveyCTO village key | bushenyi_kyamuhunga_town_butare_nyakahanga |
| 44 | uuid:86b3a17b-9d55-4f6c-bde5-0299dd14635c | Natukunda Britah | Bushenyi | Nyabubare | Nyabubare | Nkuna I | DUPLICATE_SURVEY_VILLAGE | ERROR | sample | geography | survey_village_uid | More than one submission uses the same SurveyCTO village key | bushenyi_nyabubare_nyabubare_nkuna_i |
| 45 | uuid:4cf28c10-e49b-444d-b057-f2db81dad958 | Natuhwera Sylivia | Bushenyi | Nyabubare | Nyabubare | Nkuna I | DUPLICATE_SURVEY_VILLAGE | ERROR | sample | geography | survey_village_uid | More than one submission uses the same SurveyCTO village key | bushenyi_nyabubare_nyabubare_nkuna_i |
| 46 | uuid:239af270-8302-4dcc-bb26-521630f1a56b | Natukunda Britah | Bushenyi | Nyabubare | Nyabubare | Nyabitote I | DUPLICATE_SURVEY_VILLAGE | ERROR | sample | geography | survey_village_uid | More than one submission uses the same SurveyCTO village key | bushenyi_nyabubare_nyabubare_nyabitote_i |
| 47 | uuid:6d7153e4-543a-453b-ac2c-3ddf46a92f49 | Natuhwera Sylivia | Bushenyi | Nyabubare | Nyabubare | Nyabitote I | DUPLICATE_SURVEY_VILLAGE | ERROR | sample | geography | survey_village_uid | More than one submission uses the same SurveyCTO village key | bushenyi_nyabubare_nyabubare_nyabitote_i |
| 66 | uuid:60d430c3-8d7f-46db-abf7-c3e67b003ae8 | Nayebare Christine | Rubirizi | Katunguru | Katunguru | Kyangabukama | DUPLICATE_SURVEY_VILLAGE | ERROR | sample | geography | survey_village_uid | More than one submission uses the same SurveyCTO village key | rubirizi_katunguru_katunguru_kyangabukama |
| 67 | uuid:38d2aaeb-79b2-48df-9bfe-2c02ca36ab63 | Akankwasa Ronals | Rubirizi | Katunguru | Katunguru | Kyangabukama | DUPLICATE_SURVEY_VILLAGE | ERROR | sample | geography | survey_village_uid | More than one submission uses the same SurveyCTO village key | rubirizi_katunguru_katunguru_kyangabukama |
| 77 | uuid:eb7cfbf9-785f-4af3-9d19-0fbcb8028a1e | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Omukabare | DUPLICATE_SURVEY_VILLAGE | ERROR | sample | geography | survey_village_uid | More than one submission uses the same SurveyCTO village key | rubirizi_kirugu_kikumbo_omukabare |
| 78 | uuid:1d9d1643-ebce-47c7-9ff1-ae41e373f414 | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Omukabare | DUPLICATE_SURVEY_VILLAGE | ERROR | sample | geography | survey_village_uid | More than one submission uses the same SurveyCTO village key | rubirizi_kirugu_kikumbo_omukabare |
| 19 | uuid:2f6ce7c1-25ca-4f25-b5bc-32d4514ea791 | Ashabe Gina | Bushenyi | Kakanju | Katunga | Kakuto A | M5_Q11_EXCLUSIVE | ERROR | select_multiple | M5 | m5_q11_10 | No ADR barrier is selected with a substantive barrier | 1 |
| 21 | uuid:2b9d305d-d058-42db-a4d8-b98643c9570c | Ashabe Gina | Bushenyi | Katerera Town council | Katerera ward | Kikonjo | M5_Q11_EXCLUSIVE | ERROR | select_multiple | M5 | m5_q11_10 | No ADR barrier is selected with a substantive barrier | 1 |
| 92 | uuid:efba04c9-32e1-4300-b89e-096e7cc7a049 | Ashabe Gina | Rubirizi | Rutoto | Rutoma | Bururuma | M6_Q12_EXCLUSIVE | ERROR | select_multiple | M6 | m6_q12_11 | No referral barrier is selected with a substantive barrier | 1 |
| 91 | uuid:caaee3f0-585d-4a65-b19b-9440d5fef788 | Ashabe Gina | Rubirizi | Rutoto | Nyabubare | Omukyeya | M6_Q12_EXCLUSIVE | ERROR | select_multiple | M6 | m6_q12_11 | No referral barrier is selected with a substantive barrier | 1 |
| 93 | uuid:e7c5124e-05d4-4b15-946c-52eaad7f399f | Ashabe Gina | Rubirizi | Rutoto | Rutoto | Rwemitanga | M6_Q12_EXCLUSIVE | ERROR | select_multiple | M6 | m6_q12_11 | No referral barrier is selected with a substantive barrier | 1 |
| 96 | uuid:36bdaa5e-7a1b-4d15-b28b-9d02d9b87618 | Akankwasa Ronals | Rubirizi | Ryeru | Ndekye | Mubanda | M6_Q12_EXCLUSIVE | ERROR | select_multiple | M6 | m6_q12_11 | No referral barrier is selected with a substantive barrier | 1 |
| 105 | uuid:6ad56b9d-2710-40f1-ba26-6321f8a0e07c | Kagoro Meliza | Sheema | Kabwohe Division | kabwohe | Kabwohe hill | M8_Q15_EXCLUSIVE | ERROR | select_multiple | M8 | m8_q15_10 | No committee challenge is selected with a substantive challenge | 1 |
| 106 | uuid:bb4497b7-a4d1-48ad-b75c-edc9dfedd36b | Kagoro Meliza | Sheema | Kabwohe Division | Kabwohe | Kyamatongo | M8_Q15_EXCLUSIVE | ERROR | select_multiple | M8 | m8_q15_10 | No committee challenge is selected with a substantive challenge | 1 |
| 63 | uuid:330d6791-29c9-4ce9-9f0c-e5a516a88665 | Atukwase Shallon | Rubirizi | Katerera Town council | Katerera ward | KIZIRA CELL | M9_Q16_EXCLUSIVE | ERROR | select_multiple | M9 | m9_q16_11 | Rarely bypass is selected with a substantive bypass reason | 1 |
| 64 | uuid:81a9878f-fccd-435e-89fa-29bd380740d6 | Atukwase Shallon | Rubirizi | Katerera Town council | Katerera ward | Nyamabare | M9_Q16_EXCLUSIVE | ERROR | select_multiple | M9 | m9_q16_11 | Rarely bypass is selected with a substantive bypass reason | 1 |
| 78 | uuid:1d9d1643-ebce-47c7-9ff1-ae41e373f414 | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Omukabare | M2_VERIFICATION_STRAY | ERROR | skip_logic | M2 | m2_q17 | Record quality was verified although the enumerator saw no record | 1 |
| 94 | uuid:8b60a0aa-959f-40c3-a9d1-af45e18ab8b7 | Akankwasa Ronals | Rubirizi | Ryeru | Bugaya | Karagara | M2_VERIFICATION_STRAY | ERROR | skip_logic | M2 | m2_q17 | Record quality was verified although the enumerator saw no record | 3 |
| 1 | uuid:b6b65544-0277-49af-b0f1-5a404d45bc7b | Natuhwera Sylivia | Bushenyi | Bitooma | Kimuri | Kimuri | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 7 | uuid:b544facc-28d8-4fd3-b224-77092facdf73 |  | Bushenyi | Bumbaire | Nyabubare | Bumbaire II | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 4 | uuid:8d48e301-d2fa-409b-8702-c516833d1413 | Akankwasa Ronals | Bushenyi | Bumbaire | Bumbaire | Kibaare II | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 5 | uuid:923cc8d1-ce02-42bc-b7d6-999bd8956e14 |  | Bushenyi | Bumbaire | Bumbaire | Kisubu | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 9 | uuid:fe9ea2c4-1f7c-4020-80fd-b9bdaabb20a3 |  | Bushenyi | Bushenyi central | Kyeitembe | Bwatogo | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 8 | uuid:f6f99181-465b-4020-a5c6-a569e6e97e8f | Akankwasa Ronals | Bushenyi | Bushenyi central | Central ward | Nyamiko | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 13 | uuid:503ec58a-67ec-4dde-ae84-d2aab1a12767 | Natukunda Britah | Bushenyi | Ibaare | Kyamugabo | Tandara | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 14 | uuid:c8173274-23db-47f8-a1ac-af39543db00e | Natukunda Britah | Bushenyi | Ishaka Division | Ishaka | Bassaja | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 18 | uuid:4e33e3e3-86bf-4fef-ad2c-7fc111ffd675 | Ashabe Gina | Bushenyi | Kakanju | Katunga | Bwegyeme A | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 19 | uuid:2f6ce7c1-25ca-4f25-b5bc-32d4514ea791 | Ashabe Gina | Bushenyi | Kakanju | Katunga | Kakuto A | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 16 | uuid:d44d3c96-36e1-4c51-af3d-17df55309d0c | Akankwasa Ronals | Bushenyi | Kakanju | Kakanju | Kakuto B | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 20 | uuid:d3dc2c65-3ad4-4483-afb7-3fda4a145b5b | Ashabe Gina | Bushenyi | Kakanju | Katunga | Nombe B | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 17 | uuid:b070c3e6-33ba-4892-adba-79940c4e238d | Akankwasa Ronals | Bushenyi | Kakanju | Kakanju | Nyabubare A | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 21 | uuid:2b9d305d-d058-42db-a4d8-b98643c9570c | Ashabe Gina | Bushenyi | Katerera Town council | Katerera ward | Kikonjo | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 24 | uuid:45b7a882-8980-44ed-a068-444689caedd2 | Natukunda Britah | Bushenyi | Kizinda Town Council | Kizinda | Kangaate | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 22 | uuid:c0ed8cb3-3e22-4fa1-b87e-271f36d78a88 | Ashabe Gina | Bushenyi | Kizinda Town Council | Katerera ward | Katerera II | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 25 | uuid:e4eba94b-b137-4abe-b8b2-115029c6562d | Ashabe Gina | Bushenyi | Kizinda Town Council | Kizinda | Kitooma | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 26 | uuid:e82dde24-05b4-42f0-b13d-f6a2feae07c8 | Akankwasa Ronals | Bushenyi | Kizinda Town Council | Nyabubare | Masya | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 28 | uuid:88a20d13-2e15-40a2-9603-84fe82e34e49 | Natukunda Britah | Bushenyi | Kizinda Town Council | Nyabubare | Rushoroza | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 23 | uuid:14af339d-a5db-42c6-8b92-00c591eea57c | Natukunda Britah | Bushenyi | Kizinda Town Council | Kigoma | Ryabuganyi | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 29 | uuid:67d835c9-9295-4549-b8a1-b7febfc94cd9 | Nayebare Christine | Bushenyi | Kyabugimbi Sub county | Kitwe | Kajunju | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 30 | uuid:2101bb2c-523c-4bb6-938e-e0200a12f76e | Nayebare Christine | Bushenyi | Kyabugimbi Town Council | Kitwe | Buhimba A | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 32 | uuid:33e352a4-c479-4508-9357-94a75d437c81 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Butare ward | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 38 | uuid:19a8b7cb-3020-4b6a-9334-8082aa9e84e2 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Mashonga | KYAMABARE | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 33 | uuid:476cec79-33e1-43cf-a0ee-3f319d1606f9 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Nyakahanga | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 40 | uuid:1b6b6511-7ad1-4574-8313-ff38b799c6fd | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Mashonga | Nyamabare | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 36 | uuid:b137e053-2461-47a4-acc5-71b556a9d5c6 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Nyampungye | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 31 | uuid:694df33a-02e6-4c3c-a2cd-112001068039 | Nayebare Christine | Bushenyi | Kyamuhunga sub | Nsumi | Nyampungye | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 41 | uuid:04ae9f2d-79e1-442f-ab07-b071ff294f7e | Nayebare Christine | Bushenyi | Kyeizooba | Kararo | Kitagata | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 42 | uuid:ee74a7a6-e7e4-4a57-b3cb-eb60f2a8c486 | Nayebare Christine | Bushenyi | Kyeizooba | Nyamiyaga | Nyamiyaga | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 43 | uuid:f0af6878-e298-4b0f-9099-83b18305f37e | Akankwasa Ronals | Bushenyi | Nkanga | Birimbi | Kirimbi | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 50 | uuid:c1a0be42-3215-4961-a0bb-04cbfb5baca4 |  | Bushenyi | Nyakabirizi | Ward II | Katungu | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 53 | uuid:0539ed9a-11e1-4d3d-9839-361b0b55a49d | Nayebare Christine | Bushenyi | Ruhumuro | Kyeibingo | Kansenjesa | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 51 | uuid:39877f26-c133-4b17-8033-901974f6a9ef | Nayebare Christine | Bushenyi | Ruhumuro | Bugaana | Nyamyerande I | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 52 | uuid:169749d4-c6a2-497c-87f8-aaf62383ecc2 | Akankwasa Ronals | Bushenyi | Ruhumuro | Burungira | Orubingo A | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 55 | uuid:9fac6fe3-6e1b-4dd5-ac62-19b7d099a55f | Nayebare Christine | Bushenyi | Rwentuha | Rutooma | Rwentuha Town | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 57 | uuid:ada3c911-6942-4e8d-85a8-8f1247924c22 | Nayebare Christine | Rubirizi | Katanda | Rwamatumba | Kisharu I | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 56 | uuid:b1910163-9f25-4920-ba0b-325287f8b2b5 | Akankwasa Ronals | Rubirizi | Katanda | kyankaranga | Mikonabire | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 58 | uuid:920f98be-7e8b-4293-abd0-9a75b13bc222 | Akankwasa Ronals | Rubirizi | Katerera Sub county | katerera | Kakindo | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 61 | uuid:9b2951b5-9998-4409-a291-3e8ad115dcdd | Nayebare Christine | Rubirizi | Katerera Town council | Katerera ward | Katabengo | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 62 | uuid:4bcc0328-e8f3-4a56-be09-6613e55f730a | Ashabe Gina | Rubirizi | Katerera Town council | Katerera ward | Katerera I | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 64 | uuid:81a9878f-fccd-435e-89fa-29bd380740d6 | Atukwase Shallon | Rubirizi | Katerera Town council | Katerera ward | Nyamabare | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 66 | uuid:60d430c3-8d7f-46db-abf7-c3e67b003ae8 | Nayebare Christine | Rubirizi | Katunguru | Katunguru | Kyangabukama | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 67 | uuid:38d2aaeb-79b2-48df-9bfe-2c02ca36ab63 | Akankwasa Ronals | Rubirizi | Katunguru | Katunguru | Kyangabukama | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 74 | uuid:fada9fc9-d202-4ebd-a50a-507f3b861281 | Nayebare Christine | Rubirizi | Kicwamba | Kyambura | Kyambura C | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 70 | uuid:da19adbf-707f-4d00-93db-9db55685bf60 | Ashabe Gina | Rubirizi | Kicwamba | Kicwamba | Kyambuzi B | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 73 | uuid:ca5869ec-248c-4e5b-b7bc-e4e5f9d8fc57 | Nayebare Christine | Rubirizi | Kicwamba | Kicwamba | Nyakambu | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 79 | uuid:2ba53609-89d0-47fa-a930-fc82aa40c9cd | Nayebare Christine | Rubirizi | Kirugu | Kirugu | Kafuro IB | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 80 | uuid:8a21f548-2b3c-47f0-ae07-34354de0b0f5 | Akankwasa Ronals | Rubirizi | Kirugu | Kirugu | Kirugu 2 B | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 84 | uuid:363f8a01-9abe-400c-9e1c-6ac0d323bcd0 | Akankwasa Ronals | Rubirizi | Kirugu | Kyenzaza | Kirugu IB | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 81 | uuid:4dee5693-f48a-40c7-824b-4d3c8d139419 | Akankwasa Ronals | Rubirizi | Kirugu | Kirugu | Mirarikye | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 76 | uuid:1e7692a5-c876-47e9-9554-df0026d76452 | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Ntunga A | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 83 | uuid:752263e8-2373-4e77-9c0a-564dae2df964 | Nayebare Christine | Rubirizi | Kirugu | Kisenyi | Nyamweru | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 77 | uuid:eb7cfbf9-785f-4af3-9d19-0fbcb8028a1e | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Omukabare | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 82 | uuid:354a5f12-ff42-4c80-b70f-12769bfb6bff | Akankwasa Ronals | Rubirizi | Kirugu | Kirugu | Omukabare | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 85 | uuid:2c4d99f2-3f5f-4e44-93e4-337b40b98c7f | Ashabe Gina | Rubirizi | Kizinda Town Council | Katerera ward | KACU CELL | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 86 | uuid:db45a481-5312-4553-a9fc-85343aa34e88 | Ashabe Gina | Rubirizi | Kizinda Town Council | Katerera ward | RWENTOSHO I | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 88 | uuid:c1cc92c3-2823-4c09-a104-5f6962c22859 | Nayebare Christine | Rubirizi | Kyabakara | Rugarama | Nyabubare | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 89 | uuid:a4206fdb-447d-4ad9-8638-8e4f3f348321 | Nayebare Christine | Rubirizi | Magambo | Bugaya | Busonga II | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 90 | uuid:10a8b3f0-4ff6-463e-adc0-40f2c21228d9 | Ashabe Gina | Rubirizi | Magambo | Butoha | Nyangorogo II | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 92 | uuid:efba04c9-32e1-4300-b89e-096e7cc7a049 | Ashabe Gina | Rubirizi | Rutoto | Rutoma | Bururuma | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 91 | uuid:caaee3f0-585d-4a65-b19b-9440d5fef788 | Ashabe Gina | Rubirizi | Rutoto | Nyabubare | Omukyeya | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 94 | uuid:8b60a0aa-959f-40c3-a9d1-af45e18ab8b7 | Akankwasa Ronals | Rubirizi | Ryeru | Bugaya | Karagara | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 96 | uuid:36bdaa5e-7a1b-4d15-b28b-9d02d9b87618 | Akankwasa Ronals | Rubirizi | Ryeru | Ndekye | Mubanda | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 95 | uuid:52263d60-be6d-4e58-b163-301a9db00945 | Nayebare Christine | Rubirizi | Ryeru | Butoha | Nyakiyaza | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 97 | uuid:d2517598-b6eb-4885-9e14-c67dcfca649b | Akankwasa Ronals | Rubirizi | Ryeru | Ndekye | Ryeru | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 98 | uuid:6a36702c-f1e8-40f9-b5dd-dc3bf9a7ee22 | Ashabe Gina | Sheema | Bugongi | Isingiro | Kyabuyongo | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 100 | uuid:43980d04-5a15-49b4-b8f1-0e897465da22 | Ashabe Gina | Sheema | Bugongi | Kyamurari | Runyinya II | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 99 | uuid:8e9ad66a-3b97-4d44-a155-a9847997022e | Nayebare Christine | Sheema | Bugongi | Kagongi | Rwenkurigo | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 102 | uuid:6005d963-965c-4ba4-89b7-bc58c969c875 | Kagoro Meliza | Sheema | Kabwohe Division | Kabwohe | Ishekye | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 103 | uuid:b445a616-8864-4508-a15c-f8f3deccabb3 | Kagoro Meliza | Sheema | Kabwohe Division | Kabwohe | Kabwohe A | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 104 | uuid:9bf5edc8-e555-40e1-8e3f-589f03b4a8ce | Natuhwera Sylivia | Sheema | Kabwohe Division | kabwohe | Kabwohe central | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 108 | uuid:175fe80a-15d4-4f74-92b5-619f94854830 | Natuhwera Sylivia | Sheema | Kabwohe Division | Nyanga | Mabaga Cell | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 109 | uuid:868bec7f-1ce9-4ea4-a204-a2e5fd59187c | Kagoro Meliza | Sheema | Kabwohe Division | Nyanga | Mailo IV | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 107 | uuid:adb21efa-2e1c-48b5-9caa-f6875cdfefa0 | Natuhwera Sylivia | Sheema | Kabwohe Division | kabwohe | Market cell | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 110 | uuid:91a71c36-ddab-4bff-b95e-396a5171d7ca | Kagoro Meliza | Sheema | Kabwohe Division | Nyanga | Rushoroza | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 115 | uuid:a0e54d95-462a-4ca7-bd6e-690f32651880 | Nayebare Christine | Sheema | Kasana Sub county | Karugorora | Karugorora | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 116 | uuid:5aa7ff72-afed-4b3d-9bf1-328fa8f1fac2 | Nayebare Christine | Sheema | Kasana Sub county | Kasaana Central | Kihanga II | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 117 | uuid:f57f5dfb-9e0f-4f9a-bfc6-759c0dc5cb0b | Akankwasa Ronals | Sheema | Kasana Sub county | Kasaana North | Mishenyi | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 120 | uuid:d2aa797e-a3cc-4167-97bc-32a251a8c846 | Natuhwera Sylivia | Sheema | Kigarama Sub county | Kigarama | Katanoga | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 118 | uuid:f224fa56-9614-46e3-8680-eff3993e90b1 | Natuhwera Sylivia | Sheema | Kigarama Sub county | Byayegamba | Nyakasharara | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 121 | uuid:534a4dc1-74c0-4810-8847-9c7624322cc4 | Nayebare Christine | Sheema | Kitagata Town counsil | Kyarushakara | Bwoma | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 124 | uuid:e0b54bf6-b9b5-4a1c-b223-2ee1f182036b | Nayebare Christine | Sheema | Kyangyenyi | Kashanjure | Kashanjure | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 125 | uuid:ff031e71-5a42-4fa3-93f8-ef295c630f00 | Nayebare Christine | Sheema | Kyangyenyi | Masyooro | Masyooro | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 122 | uuid:54ac1f3f-18a3-4703-909f-046b1edd7d2f | Akankwasa Ronals | Sheema | Kyangyenyi | Kagongi | Ryamatshya | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 123 | uuid:8d388b30-2bdd-47e1-9ce4-3af0393ac878 | Akankwasa Ronals | Sheema | Kyangyenyi | Kagongi | Ryamatshya II | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 128 | uuid:bbc1c66b-1296-48b6-a4aa-d056e31ad956 | Akankwasa Ronals | Sheema | Masheruka sub county | Nyabwina | Bwoma | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 126 | uuid:53f4f023-bebc-4bc6-abc3-ccb212d97b7d | Natukunda Britah | Sheema | Masheruka sub county | Mabare | Nyakanoni | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 127 | uuid:b1999bec-89d4-477b-b49e-15838313a589 | Natukunda Britah | Sheema | Masheruka sub county | Mabare | Rwichumu | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 112 | uuid:9cc25ab4-3f37-41c7-875c-e0373445bdc4 | Natukunda Britah | Sheema | kagango | Kagango | Kanyina | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 114 | uuid:eaffe867-85ef-4432-91ff-51ba954becbb | Natukunda Britah | Sheema | kagango | Kagango | Kiziba | VACANCY_COUNT_MISSING | ERROR | skip_logic | M2 | m2_q04 | Vacancies reported but the number of vacancies is missing or zero | . |
| 1 | uuid:b6b65544-0277-49af-b0f1-5a404d45bc7b | Natuhwera Sylivia | Bushenyi | Bitooma | Kimuri | Kimuri | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 2 | uuid:8e344c68-c753-419f-ad61-acdc57e20989 | Natuhwera Sylivia | Bushenyi | Bitooma | Nyanga ward | Kyamamari | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 3 | uuid:5b1df098-f640-43fc-91e0-a6e46262338f | Atukwase Shallon | Bushenyi | Bumbaire | Bumbaire | Bumbaire II | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 7 | uuid:b544facc-28d8-4fd3-b224-77092facdf73 |  | Bushenyi | Bumbaire | Nyabubare | Bumbaire II | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 4 | uuid:8d48e301-d2fa-409b-8702-c516833d1413 | Akankwasa Ronals | Bushenyi | Bumbaire | Bumbaire | Kibaare II | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 5 | uuid:923cc8d1-ce02-42bc-b7d6-999bd8956e14 |  | Bushenyi | Bumbaire | Bumbaire | Kisubu | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 6 | uuid:2883eeb0-9366-4a9f-8de0-3c2dc7f9b5ca | Atukwase Shallon | Bushenyi | Bumbaire | Bumbaire | Kitakuuka | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 9 | uuid:fe9ea2c4-1f7c-4020-80fd-b9bdaabb20a3 |  | Bushenyi | Bushenyi central | Kyeitembe | Bwatogo | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 8 | uuid:f6f99181-465b-4020-a5c6-a569e6e97e8f | Akankwasa Ronals | Bushenyi | Bushenyi central | Central ward | Nyamiko | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 10 | uuid:f65ed9f8-26f6-4753-b289-857c81fa117e |  | Bushenyi | Bushenyi central | Ward II | Ruhandagazi | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 11 | uuid:de8ac1f2-ff18-41e0-91c8-180a394218d9 | Natukunda Britah | Bushenyi | Ibaare | Kyamugabo | Kibingo | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 12 | uuid:3da795bc-f111-4ee4-9407-702eeba682c1 | Natukunda Britah | Bushenyi | Ibaare | Kyamugabo | Kyamugabo | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 13 | uuid:503ec58a-67ec-4dde-ae84-d2aab1a12767 | Natukunda Britah | Bushenyi | Ibaare | Kyamugabo | Tandara | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 14 | uuid:c8173274-23db-47f8-a1ac-af39543db00e | Natukunda Britah | Bushenyi | Ishaka Division | Ishaka | Bassaja | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 15 | uuid:3723f508-9574-49d2-85e8-8749e75302da | Natukunda Britah | Bushenyi | Ishaka Division | Ishaka | K.I.U | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 18 | uuid:4e33e3e3-86bf-4fef-ad2c-7fc111ffd675 | Ashabe Gina | Bushenyi | Kakanju | Katunga | Bwegyeme A | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 19 | uuid:2f6ce7c1-25ca-4f25-b5bc-32d4514ea791 | Ashabe Gina | Bushenyi | Kakanju | Katunga | Kakuto A | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 16 | uuid:d44d3c96-36e1-4c51-af3d-17df55309d0c | Akankwasa Ronals | Bushenyi | Kakanju | Kakanju | Kakuto B | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 20 | uuid:d3dc2c65-3ad4-4483-afb7-3fda4a145b5b | Ashabe Gina | Bushenyi | Kakanju | Katunga | Nombe B | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 17 | uuid:b070c3e6-33ba-4892-adba-79940c4e238d | Akankwasa Ronals | Bushenyi | Kakanju | Kakanju | Nyabubare A | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 21 | uuid:2b9d305d-d058-42db-a4d8-b98643c9570c | Ashabe Gina | Bushenyi | Katerera Town council | Katerera ward | Kikonjo | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 24 | uuid:45b7a882-8980-44ed-a068-444689caedd2 | Natukunda Britah | Bushenyi | Kizinda Town Council | Kizinda | Kangaate | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 22 | uuid:c0ed8cb3-3e22-4fa1-b87e-271f36d78a88 | Ashabe Gina | Bushenyi | Kizinda Town Council | Katerera ward | Katerera II | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 25 | uuid:e4eba94b-b137-4abe-b8b2-115029c6562d | Ashabe Gina | Bushenyi | Kizinda Town Council | Kizinda | Kitooma | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 26 | uuid:e82dde24-05b4-42f0-b13d-f6a2feae07c8 | Akankwasa Ronals | Bushenyi | Kizinda Town Council | Nyabubare | Masya | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 27 | uuid:2190d328-1a42-4f7b-874d-a670dda437fe | Natukunda Britah | Bushenyi | Kizinda Town Council | Nyabubare | Nyakinengo | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 28 | uuid:88a20d13-2e15-40a2-9603-84fe82e34e49 | Natukunda Britah | Bushenyi | Kizinda Town Council | Nyabubare | Rushoroza | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 23 | uuid:14af339d-a5db-42c6-8b92-00c591eea57c | Natukunda Britah | Bushenyi | Kizinda Town Council | Kigoma | Ryabuganyi | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 29 | uuid:67d835c9-9295-4549-b8a1-b7febfc94cd9 | Nayebare Christine | Bushenyi | Kyabugimbi Sub county | Kitwe | Kajunju | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 30 | uuid:2101bb2c-523c-4bb6-938e-e0200a12f76e | Nayebare Christine | Bushenyi | Kyabugimbi Town Council | Kitwe | Buhimba A | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 32 | uuid:33e352a4-c479-4508-9357-94a75d437c81 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Butare ward | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 38 | uuid:19a8b7cb-3020-4b6a-9334-8082aa9e84e2 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Mashonga | KYAMABARE | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 37 | uuid:14c2cf8f-a846-4283-be6b-65a03bfa0f2f | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Kakoni | Manengo | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 39 | uuid:e797533b-8e6d-44fd-9acb-730d417beac9 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Mashonga | NYAKAZINGA | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 33 | uuid:476cec79-33e1-43cf-a0ee-3f319d1606f9 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Nyakahanga | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 34 | uuid:195cf6b6-333c-44b9-8453-f711db689316 | Akankwasa Ronals | Bushenyi | Kyamuhunga Town | Butare | Nyakahanga | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 40 | uuid:1b6b6511-7ad1-4574-8313-ff38b799c6fd | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Mashonga | Nyamabare | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 35 | uuid:5e65e5ca-2cd4-4774-8639-72a360423bf0 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Nyamalembe | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 36 | uuid:b137e053-2461-47a4-acc5-71b556a9d5c6 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Nyampungye | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 31 | uuid:694df33a-02e6-4c3c-a2cd-112001068039 | Nayebare Christine | Bushenyi | Kyamuhunga sub | Nsumi | Nyampungye | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 41 | uuid:04ae9f2d-79e1-442f-ab07-b071ff294f7e | Nayebare Christine | Bushenyi | Kyeizooba | Kararo | Kitagata | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 42 | uuid:ee74a7a6-e7e4-4a57-b3cb-eb60f2a8c486 | Nayebare Christine | Bushenyi | Kyeizooba | Nyamiyaga | Nyamiyaga | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 43 | uuid:f0af6878-e298-4b0f-9099-83b18305f37e | Akankwasa Ronals | Bushenyi | Nkanga | Birimbi | Kirimbi | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 44 | uuid:86b3a17b-9d55-4f6c-bde5-0299dd14635c | Natukunda Britah | Bushenyi | Nyabubare | Nyabubare | Nkuna I | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 45 | uuid:4cf28c10-e49b-444d-b057-f2db81dad958 | Natuhwera Sylivia | Bushenyi | Nyabubare | Nyabubare | Nkuna I | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 46 | uuid:239af270-8302-4dcc-bb26-521630f1a56b | Natukunda Britah | Bushenyi | Nyabubare | Nyabubare | Nyabitote I | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 47 | uuid:6d7153e4-543a-453b-ac2c-3ddf46a92f49 | Natuhwera Sylivia | Bushenyi | Nyabubare | Nyabubare | Nyabitote I | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 50 | uuid:c1a0be42-3215-4961-a0bb-04cbfb5baca4 |  | Bushenyi | Nyakabirizi | Ward II | Katungu | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 48 | uuid:d1fcaec8-9bc6-4100-a81c-8649c52e99af | Atukwase Shallon | Bushenyi | Nyakabirizi | Kibaare | Kibaare I | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 49 | uuid:8c23d6d7-99d7-4bfa-9cb1-79ae221fa890 | Atukwase Shallon | Bushenyi | Nyakabirizi | Kibaare | Kibaare II | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 53 | uuid:0539ed9a-11e1-4d3d-9839-361b0b55a49d | Nayebare Christine | Bushenyi | Ruhumuro | Kyeibingo | Kansenjesa | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 51 | uuid:39877f26-c133-4b17-8033-901974f6a9ef | Nayebare Christine | Bushenyi | Ruhumuro | Bugaana | Nyamyerande I | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 52 | uuid:169749d4-c6a2-497c-87f8-aaf62383ecc2 | Akankwasa Ronals | Bushenyi | Ruhumuro | Burungira | Orubingo A | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 54 | uuid:247b3a9d-310a-47a7-8cca-9c435a9cdd2f | Nayebare Christine | Bushenyi | Rwentuha | Rutooma | Rutooma ward | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 55 | uuid:9fac6fe3-6e1b-4dd5-ac62-19b7d099a55f | Nayebare Christine | Bushenyi | Rwentuha | Rutooma | Rwentuha Town | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 57 | uuid:ada3c911-6942-4e8d-85a8-8f1247924c22 | Nayebare Christine | Rubirizi | Katanda | Rwamatumba | Kisharu I | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 56 | uuid:b1910163-9f25-4920-ba0b-325287f8b2b5 | Akankwasa Ronals | Rubirizi | Katanda | kyankaranga | Mikonabire | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 58 | uuid:920f98be-7e8b-4293-abd0-9a75b13bc222 | Akankwasa Ronals | Rubirizi | Katerera Sub county | katerera | Kakindo | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 63 | uuid:330d6791-29c9-4ce9-9f0c-e5a516a88665 | Atukwase Shallon | Rubirizi | Katerera Town council | Katerera ward | KIZIRA CELL | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 59 | uuid:0e4fc0f5-d89d-4739-ab70-2778ab95b10f | Atukwase Shallon | Rubirizi | Katerera Town council | katerera | Kabaseeka | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 61 | uuid:9b2951b5-9998-4409-a291-3e8ad115dcdd | Nayebare Christine | Rubirizi | Katerera Town council | Katerera ward | Katabengo | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 62 | uuid:4bcc0328-e8f3-4a56-be09-6613e55f730a | Ashabe Gina | Rubirizi | Katerera Town council | Katerera ward | Katerera I | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 65 | uuid:fb35c3d3-798e-416a-b9a8-369376d34615 | Atukwase Shallon | Rubirizi | Katerera Town council | Nyakasharu | Kyakabunda | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 60 | uuid:8a4d03ff-d8b3-4749-8eed-b199e80f77ed | Atukwase Shallon | Rubirizi | Katerera Town council | katerera | Nyakagyezi I | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 64 | uuid:81a9878f-fccd-435e-89fa-29bd380740d6 | Atukwase Shallon | Rubirizi | Katerera Town council | Katerera ward | Nyamabare | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 66 | uuid:60d430c3-8d7f-46db-abf7-c3e67b003ae8 | Nayebare Christine | Rubirizi | Katunguru | Katunguru | Kyangabukama | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 67 | uuid:38d2aaeb-79b2-48df-9bfe-2c02ca36ab63 | Akankwasa Ronals | Rubirizi | Katunguru | Katunguru | Kyangabukama | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 68 | uuid:4df180f3-5809-4e60-98a5-2a277378818f | Atukwase Shallon | Rubirizi | Katunguru | Kisenyi | Nyamabare | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 69 | uuid:d9b98bc1-3533-4349-a12b-a36e785e493f | Atukwase Shallon | Rubirizi | Kicwamba | Kicwamba | Katara I | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 74 | uuid:fada9fc9-d202-4ebd-a50a-507f3b861281 | Nayebare Christine | Rubirizi | Kicwamba | Kyambura | Kyambura C | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 70 | uuid:da19adbf-707f-4d00-93db-9db55685bf60 | Ashabe Gina | Rubirizi | Kicwamba | Kicwamba | Kyambuzi B | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 71 | uuid:b8cecd9f-74bb-4ed8-b18c-bd0cda597f51 | Atukwase Shallon | Rubirizi | Kicwamba | Kicwamba | Kyesama | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 72 | uuid:f8c0c408-5770-48bf-ae83-1db7ae081129 | Atukwase Shallon | Rubirizi | Kicwamba | Kicwamba | Mutambi IIB | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 73 | uuid:ca5869ec-248c-4e5b-b7bc-e4e5f9d8fc57 | Nayebare Christine | Rubirizi | Kicwamba | Kicwamba | Nyakambu | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 75 | uuid:882b0617-3187-434f-ab9a-272b9129dce4 | Akankwasa Ronals | Rubirizi | Kicwamba | Rumri | Rumuri II | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 79 | uuid:2ba53609-89d0-47fa-a930-fc82aa40c9cd | Nayebare Christine | Rubirizi | Kirugu | Kirugu | Kafuro IB | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 80 | uuid:8a21f548-2b3c-47f0-ae07-34354de0b0f5 | Akankwasa Ronals | Rubirizi | Kirugu | Kirugu | Kirugu 2 B | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 84 | uuid:363f8a01-9abe-400c-9e1c-6ac0d323bcd0 | Akankwasa Ronals | Rubirizi | Kirugu | Kyenzaza | Kirugu IB | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 81 | uuid:4dee5693-f48a-40c7-824b-4d3c8d139419 | Akankwasa Ronals | Rubirizi | Kirugu | Kirugu | Mirarikye | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 76 | uuid:1e7692a5-c876-47e9-9554-df0026d76452 | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Ntunga A | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 83 | uuid:752263e8-2373-4e77-9c0a-564dae2df964 | Nayebare Christine | Rubirizi | Kirugu | Kisenyi | Nyamweru | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 77 | uuid:eb7cfbf9-785f-4af3-9d19-0fbcb8028a1e | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Omukabare | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 78 | uuid:1d9d1643-ebce-47c7-9ff1-ae41e373f414 | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Omukabare | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 82 | uuid:354a5f12-ff42-4c80-b70f-12769bfb6bff | Akankwasa Ronals | Rubirizi | Kirugu | Kirugu | Omukabare | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 85 | uuid:2c4d99f2-3f5f-4e44-93e4-337b40b98c7f | Ashabe Gina | Rubirizi | Kizinda Town Council | Katerera ward | KACU CELL | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 86 | uuid:db45a481-5312-4553-a9fc-85343aa34e88 | Ashabe Gina | Rubirizi | Kizinda Town Council | Katerera ward | RWENTOSHO I | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 87 | uuid:0d6e187f-2e96-422b-98cd-194c4705a344 | Atukwase Shallon | Rubirizi | Kyabakara | Rugarama | Bugarama | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 88 | uuid:c1cc92c3-2823-4c09-a104-5f6962c22859 | Nayebare Christine | Rubirizi | Kyabakara | Rugarama | Nyabubare | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 89 | uuid:a4206fdb-447d-4ad9-8638-8e4f3f348321 | Nayebare Christine | Rubirizi | Magambo | Bugaya | Busonga II | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 90 | uuid:10a8b3f0-4ff6-463e-adc0-40f2c21228d9 | Ashabe Gina | Rubirizi | Magambo | Butoha | Nyangorogo II | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 92 | uuid:efba04c9-32e1-4300-b89e-096e7cc7a049 | Ashabe Gina | Rubirizi | Rutoto | Rutoma | Bururuma | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 91 | uuid:caaee3f0-585d-4a65-b19b-9440d5fef788 | Ashabe Gina | Rubirizi | Rutoto | Nyabubare | Omukyeya | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 93 | uuid:e7c5124e-05d4-4b15-946c-52eaad7f399f | Ashabe Gina | Rubirizi | Rutoto | Rutoto | Rwemitanga | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 94 | uuid:8b60a0aa-959f-40c3-a9d1-af45e18ab8b7 | Akankwasa Ronals | Rubirizi | Ryeru | Bugaya | Karagara | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 96 | uuid:36bdaa5e-7a1b-4d15-b28b-9d02d9b87618 | Akankwasa Ronals | Rubirizi | Ryeru | Ndekye | Mubanda | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 95 | uuid:52263d60-be6d-4e58-b163-301a9db00945 | Nayebare Christine | Rubirizi | Ryeru | Butoha | Nyakiyaza | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 97 | uuid:d2517598-b6eb-4885-9e14-c67dcfca649b | Akankwasa Ronals | Rubirizi | Ryeru | Ndekye | Ryeru | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 98 | uuid:6a36702c-f1e8-40f9-b5dd-dc3bf9a7ee22 | Ashabe Gina | Sheema | Bugongi | Isingiro | Kyabuyongo | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 100 | uuid:43980d04-5a15-49b4-b8f1-0e897465da22 | Ashabe Gina | Sheema | Bugongi | Kyamurari | Runyinya II | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 99 | uuid:8e9ad66a-3b97-4d44-a155-a9847997022e | Nayebare Christine | Sheema | Bugongi | Kagongi | Rwenkurigo | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 101 | uuid:bbf19eca-3224-43ef-af4a-72cf65fbe86e | Akankwasa Ronals | Sheema | Bugongi | Kyamurari | Rwenkurigo | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 102 | uuid:6005d963-965c-4ba4-89b7-bc58c969c875 | Kagoro Meliza | Sheema | Kabwohe Division | Kabwohe | Ishekye | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 103 | uuid:b445a616-8864-4508-a15c-f8f3deccabb3 | Kagoro Meliza | Sheema | Kabwohe Division | Kabwohe | Kabwohe A | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 104 | uuid:9bf5edc8-e555-40e1-8e3f-589f03b4a8ce | Natuhwera Sylivia | Sheema | Kabwohe Division | kabwohe | Kabwohe central | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 105 | uuid:6ad56b9d-2710-40f1-ba26-6321f8a0e07c | Kagoro Meliza | Sheema | Kabwohe Division | kabwohe | Kabwohe hill | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 106 | uuid:bb4497b7-a4d1-48ad-b75c-edc9dfedd36b | Kagoro Meliza | Sheema | Kabwohe Division | Kabwohe | Kyamatongo | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 108 | uuid:175fe80a-15d4-4f74-92b5-619f94854830 | Natuhwera Sylivia | Sheema | Kabwohe Division | Nyanga | Mabaga Cell | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 109 | uuid:868bec7f-1ce9-4ea4-a204-a2e5fd59187c | Kagoro Meliza | Sheema | Kabwohe Division | Nyanga | Mailo IV | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 107 | uuid:adb21efa-2e1c-48b5-9caa-f6875cdfefa0 | Natuhwera Sylivia | Sheema | Kabwohe Division | kabwohe | Market cell | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 110 | uuid:91a71c36-ddab-4bff-b95e-396a5171d7ca | Kagoro Meliza | Sheema | Kabwohe Division | Nyanga | Rushoroza | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 115 | uuid:a0e54d95-462a-4ca7-bd6e-690f32651880 | Nayebare Christine | Sheema | Kasana Sub county | Karugorora | Karugorora | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 116 | uuid:5aa7ff72-afed-4b3d-9bf1-328fa8f1fac2 | Nayebare Christine | Sheema | Kasana Sub county | Kasaana Central | Kihanga II | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 117 | uuid:f57f5dfb-9e0f-4f9a-bfc6-759c0dc5cb0b | Akankwasa Ronals | Sheema | Kasana Sub county | Kasaana North | Mishenyi | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 119 | uuid:100b5afe-d2d5-4a17-b542-289a7c522bcc | Natuhwera Sylivia | Sheema | Kigarama Sub county | Kigarama | Kagarama | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 120 | uuid:d2aa797e-a3cc-4167-97bc-32a251a8c846 | Natuhwera Sylivia | Sheema | Kigarama Sub county | Kigarama | Katanoga | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 118 | uuid:f224fa56-9614-46e3-8680-eff3993e90b1 | Natuhwera Sylivia | Sheema | Kigarama Sub county | Byayegamba | Nyakasharara | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 121 | uuid:534a4dc1-74c0-4810-8847-9c7624322cc4 | Nayebare Christine | Sheema | Kitagata Town counsil | Kyarushakara | Bwoma | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 124 | uuid:e0b54bf6-b9b5-4a1c-b223-2ee1f182036b | Nayebare Christine | Sheema | Kyangyenyi | Kashanjure | Kashanjure | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 125 | uuid:ff031e71-5a42-4fa3-93f8-ef295c630f00 | Nayebare Christine | Sheema | Kyangyenyi | Masyooro | Masyooro | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 122 | uuid:54ac1f3f-18a3-4703-909f-046b1edd7d2f | Akankwasa Ronals | Sheema | Kyangyenyi | Kagongi | Ryamatshya | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 123 | uuid:8d388b30-2bdd-47e1-9ce4-3af0393ac878 | Akankwasa Ronals | Sheema | Kyangyenyi | Kagongi | Ryamatshya II | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 132 | uuid:56a06269-2c70-4120-9ddc-23e58491134f | Atukwase Shallon | Sheema | Masheruka TC | Kanyegayegye | Bugarama | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 131 | uuid:d722a4c7-2bfb-49ab-8858-646fb94e9475 | Atukwase Shallon | Sheema | Masheruka TC | Buringo | Mukono 1 | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 133 | uuid:b786aa05-2d4c-4ed4-901e-ec6bfe4cac01 | Atukwase Shallon | Sheema | Masheruka TC | Kanyegayegye | Nyamabare | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 128 | uuid:bbc1c66b-1296-48b6-a4aa-d056e31ad956 | Akankwasa Ronals | Sheema | Masheruka sub county | Nyabwina | Bwoma | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 129 | uuid:6fc4e7f6-3f62-45b5-9d68-5125574a73fa | Ashabe Gina | Sheema | Masheruka sub county | Nyakambu | Migera | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 130 | uuid:351c6894-28fb-4dab-8acb-b2113d20e1d1 | Ashabe Gina | Sheema | Masheruka sub county | Nyakambu | Nyakambu | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 126 | uuid:53f4f023-bebc-4bc6-abc3-ccb212d97b7d | Natukunda Britah | Sheema | Masheruka sub county | Mabare | Nyakanoni | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 127 | uuid:b1999bec-89d4-477b-b49e-15838313a589 | Natukunda Britah | Sheema | Masheruka sub county | Mabare | Rwichumu | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 111 | uuid:639b3dfc-67c1-4247-8573-794bf87192be | Natukunda Britah | Sheema | kagango | Kagango | Itendero Town | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 112 | uuid:9cc25ab4-3f37-41c7-875c-e0373445bdc4 | Natukunda Britah | Sheema | kagango | Kagango | Kanyina | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 113 | uuid:1b082c5b-eb05-4fac-b2c9-7c9726482325 | Natukunda Britah | Sheema | kagango | Kagango | Kihunda | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 114 | uuid:eaffe867-85ef-4432-91ff-51ba954becbb | Natukunda Britah | Sheema | kagango | Kagango | Kiziba | UNMATCHED_SAMPLING_FRAME | INFO | sample | geography | merge_sampling_frame | Survey record did not match the original randomized sampling frame | 1 |
| 2 | uuid:8e344c68-c753-419f-ad61-acdc57e20989 | Natuhwera Sylivia | Bushenyi | Bitooma | Nyanga ward | Kyamamari | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 51.82865 |
| 3 | uuid:5b1df098-f640-43fc-91e0-a6e46262338f | Atukwase Shallon | Bushenyi | Bumbaire | Bumbaire | Bumbaire II | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 5.92705 |
| 7 | uuid:b544facc-28d8-4fd3-b224-77092facdf73 |  | Bushenyi | Bumbaire | Nyabubare | Bumbaire II | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 2510.9654 |
| 4 | uuid:8d48e301-d2fa-409b-8702-c516833d1413 | Akankwasa Ronals | Bushenyi | Bumbaire | Bumbaire | Kibaare II | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 46.1417 |
| 5 | uuid:923cc8d1-ce02-42bc-b7d6-999bd8956e14 |  | Bushenyi | Bumbaire | Bumbaire | Kisubu | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 1080.2726 |
| 6 | uuid:2883eeb0-9366-4a9f-8de0-3c2dc7f9b5ca | Atukwase Shallon | Bushenyi | Bumbaire | Bumbaire | Kitakuuka | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 10.68205 |
| 9 | uuid:fe9ea2c4-1f7c-4020-80fd-b9bdaabb20a3 |  | Bushenyi | Bushenyi central | Kyeitembe | Bwatogo | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 14.1387 |
| 10 | uuid:f65ed9f8-26f6-4753-b289-857c81fa117e |  | Bushenyi | Bushenyi central | Ward II | Ruhandagazi | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 2372.9207 |
| 12 | uuid:3da795bc-f111-4ee4-9407-702eeba682c1 | Natukunda Britah | Bushenyi | Ibaare | Kyamugabo | Kyamugabo | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 10.4323 |
| 15 | uuid:3723f508-9574-49d2-85e8-8749e75302da | Natukunda Britah | Bushenyi | Ishaka Division | Ishaka | K.I.U | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 94.241017 |
| 17 | uuid:b070c3e6-33ba-4892-adba-79940c4e238d | Akankwasa Ronals | Bushenyi | Kakanju | Kakanju | Nyabubare A | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 102.03637 |
| 24 | uuid:45b7a882-8980-44ed-a068-444689caedd2 | Natukunda Britah | Bushenyi | Kizinda Town Council | Kizinda | Kangaate | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 575.88003 |
| 26 | uuid:e82dde24-05b4-42f0-b13d-f6a2feae07c8 | Akankwasa Ronals | Bushenyi | Kizinda Town Council | Nyabubare | Masya | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 5.8474167 |
| 27 | uuid:2190d328-1a42-4f7b-874d-a670dda437fe | Natukunda Britah | Bushenyi | Kizinda Town Council | Nyabubare | Nyakinengo | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 293.21005 |
| 28 | uuid:88a20d13-2e15-40a2-9603-84fe82e34e49 | Natukunda Britah | Bushenyi | Kizinda Town Council | Nyabubare | Rushoroza | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 369.81878 |
| 33 | uuid:476cec79-33e1-43cf-a0ee-3f319d1606f9 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Nyakahanga | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 662.27745 |
| 34 | uuid:195cf6b6-333c-44b9-8453-f711db689316 | Akankwasa Ronals | Bushenyi | Kyamuhunga Town | Butare | Nyakahanga | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 33.171417 |
| 41 | uuid:04ae9f2d-79e1-442f-ab07-b071ff294f7e | Nayebare Christine | Bushenyi | Kyeizooba | Kararo | Kitagata | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 18.9735 |
| 42 | uuid:ee74a7a6-e7e4-4a57-b3cb-eb60f2a8c486 | Nayebare Christine | Bushenyi | Kyeizooba | Nyamiyaga | Nyamiyaga | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 197.02703 |
| 50 | uuid:c1a0be42-3215-4961-a0bb-04cbfb5baca4 |  | Bushenyi | Nyakabirizi | Ward II | Katungu | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 875.84147 |
| 48 | uuid:d1fcaec8-9bc6-4100-a81c-8649c52e99af | Atukwase Shallon | Bushenyi | Nyakabirizi | Kibaare | Kibaare I | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 72.025033 |
| 53 | uuid:0539ed9a-11e1-4d3d-9839-361b0b55a49d | Nayebare Christine | Bushenyi | Ruhumuro | Kyeibingo | Kansenjesa | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 12.270967 |
| 51 | uuid:39877f26-c133-4b17-8033-901974f6a9ef | Nayebare Christine | Bushenyi | Ruhumuro | Bugaana | Nyamyerande I | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 8.0423167 |
| 52 | uuid:169749d4-c6a2-497c-87f8-aaf62383ecc2 | Akankwasa Ronals | Bushenyi | Ruhumuro | Burungira | Orubingo A | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 8.6126333 |
| 54 | uuid:247b3a9d-310a-47a7-8cca-9c435a9cdd2f | Nayebare Christine | Bushenyi | Rwentuha | Rutooma | Rutooma ward | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 96.656583 |
| 57 | uuid:ada3c911-6942-4e8d-85a8-8f1247924c22 | Nayebare Christine | Rubirizi | Katanda | Rwamatumba | Kisharu I | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 22.69235 |
| 63 | uuid:330d6791-29c9-4ce9-9f0c-e5a516a88665 | Atukwase Shallon | Rubirizi | Katerera Town council | Katerera ward | KIZIRA CELL | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 16.968917 |
| 62 | uuid:4bcc0328-e8f3-4a56-be09-6613e55f730a | Ashabe Gina | Rubirizi | Katerera Town council | Katerera ward | Katerera I | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 99.19225 |
| 65 | uuid:fb35c3d3-798e-416a-b9a8-369376d34615 | Atukwase Shallon | Rubirizi | Katerera Town council | Nyakasharu | Kyakabunda | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 12.656683 |
| 60 | uuid:8a4d03ff-d8b3-4749-8eed-b199e80f77ed | Atukwase Shallon | Rubirizi | Katerera Town council | katerera | Nyakagyezi I | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 5.0724833 |
| 68 | uuid:4df180f3-5809-4e60-98a5-2a277378818f | Atukwase Shallon | Rubirizi | Katunguru | Kisenyi | Nyamabare | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 19.871983 |
| 69 | uuid:d9b98bc1-3533-4349-a12b-a36e785e493f | Atukwase Shallon | Rubirizi | Kicwamba | Kicwamba | Katara I | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 8.2643167 |
| 74 | uuid:fada9fc9-d202-4ebd-a50a-507f3b861281 | Nayebare Christine | Rubirizi | Kicwamba | Kyambura | Kyambura C | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 26.366767 |
| 73 | uuid:ca5869ec-248c-4e5b-b7bc-e4e5f9d8fc57 | Nayebare Christine | Rubirizi | Kicwamba | Kicwamba | Nyakambu | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 220.16188 |
| 79 | uuid:2ba53609-89d0-47fa-a930-fc82aa40c9cd | Nayebare Christine | Rubirizi | Kirugu | Kirugu | Kafuro IB | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 23.352883 |
| 80 | uuid:8a21f548-2b3c-47f0-ae07-34354de0b0f5 | Akankwasa Ronals | Rubirizi | Kirugu | Kirugu | Kirugu 2 B | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 13.8571 |
| 87 | uuid:0d6e187f-2e96-422b-98cd-194c4705a344 | Atukwase Shallon | Rubirizi | Kyabakara | Rugarama | Bugarama | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 22.044467 |
| 88 | uuid:c1cc92c3-2823-4c09-a104-5f6962c22859 | Nayebare Christine | Rubirizi | Kyabakara | Rugarama | Nyabubare | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 29.825683 |
| 89 | uuid:a4206fdb-447d-4ad9-8638-8e4f3f348321 | Nayebare Christine | Rubirizi | Magambo | Bugaya | Busonga II | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 121.38953 |
| 95 | uuid:52263d60-be6d-4e58-b163-301a9db00945 | Nayebare Christine | Rubirizi | Ryeru | Butoha | Nyakiyaza | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 15.656283 |
| 99 | uuid:8e9ad66a-3b97-4d44-a155-a9847997022e | Nayebare Christine | Sheema | Bugongi | Kagongi | Rwenkurigo | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 177.14035 |
| 115 | uuid:a0e54d95-462a-4ca7-bd6e-690f32651880 | Nayebare Christine | Sheema | Kasana Sub county | Karugorora | Karugorora | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 51.0102 |
| 122 | uuid:54ac1f3f-18a3-4703-909f-046b1edd7d2f | Akankwasa Ronals | Sheema | Kyangyenyi | Kagongi | Ryamatshya | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 20.696167 |
| 132 | uuid:56a06269-2c70-4120-9ddc-23e58491134f | Atukwase Shallon | Sheema | Masheruka TC | Kanyegayegye | Bugarama | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 40.667117 |
| 131 | uuid:d722a4c7-2bfb-49ab-8858-646fb94e9475 | Atukwase Shallon | Sheema | Masheruka TC | Buringo | Mukono 1 | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 5.8836167 |
| 133 | uuid:b786aa05-2d4c-4ed4-901e-ec6bfe4cac01 | Atukwase Shallon | Sheema | Masheruka TC | Kanyegayegye | Nyamabare | DURATION_TIMESTAMP_MISMATCH | WARNING | paradata | metadata | duration_min | Recorded duration differs from start-to-end elapsed time by more than five minutes | 10.19845 |
| 29 | uuid:67d835c9-9295-4549-b8a1-b7febfc94cd9 | Nayebare Christine | Bushenyi | Kyabugimbi Sub county | Kitwe | Kajunju | LONG_DURATION | WARNING | paradata | metadata | duration_min | Interview duration is above the configured maximum | 120.28333 |
| 34 | uuid:195cf6b6-333c-44b9-8453-f711db689316 | Akankwasa Ronals | Bushenyi | Kyamuhunga Town | Butare | Nyakahanga | LONG_DURATION | WARNING | paradata | metadata | duration_min | Interview duration is above the configured maximum | 461.73333 |
| 48 | uuid:d1fcaec8-9bc6-4100-a81c-8649c52e99af | Atukwase Shallon | Bushenyi | Nyakabirizi | Kibaare | Kibaare I | LONG_DURATION | WARNING | paradata | metadata | duration_min | Interview duration is above the configured maximum | 205.8 |
| 46 | uuid:239af270-8302-4dcc-bb26-521630f1a56b | Natukunda Britah | Bushenyi | Nyabubare | Nyabubare | Nyabitote I | SHORT_DURATION | WARNING | paradata | metadata | duration_min | Interview duration is below the configured minimum | 19.1 |
| 58 | uuid:920f98be-7e8b-4293-abd0-9a75b13bc222 | Akankwasa Ronals | Rubirizi | Katerera Sub county | katerera | Kakindo | SHORT_DURATION | WARNING | paradata | metadata | duration_min | Interview duration is below the configured minimum | 18.1 |
| 61 | uuid:9b2951b5-9998-4409-a291-3e8ad115dcdd | Nayebare Christine | Rubirizi | Katerera Town council | Katerera ward | Katabengo | SHORT_DURATION | WARNING | paradata | metadata | duration_min | Interview duration is below the configured minimum | 17.95 |
| 67 | uuid:38d2aaeb-79b2-48df-9bfe-2c02ca36ab63 | Akankwasa Ronals | Rubirizi | Katunguru | Katunguru | Kyangabukama | SHORT_DURATION | WARNING | paradata | metadata | duration_min | Interview duration is below the configured minimum | 17.816667 |
| 116 | uuid:5aa7ff72-afed-4b3d-9bf1-328fa8f1fac2 | Nayebare Christine | Sheema | Kasana Sub county | Kasaana Central | Kihanga II | SHORT_DURATION | WARNING | paradata | metadata | duration_min | Interview duration is below the configured minimum | 17.8 |
| 124 | uuid:e0b54bf6-b9b5-4a1c-b223-2ee1f182036b | Nayebare Christine | Sheema | Kyangyenyi | Kashanjure | Kashanjure | SHORT_DURATION | WARNING | paradata | metadata | duration_min | Interview duration is below the configured minimum | 16.983333 |
| 113 | uuid:1b082c5b-eb05-4fac-b2c9-7c9726482325 | Natukunda Britah | Sheema | kagango | Kagango | Kihunda | SHORT_DURATION | WARNING | paradata | metadata | duration_min | Interview duration is below the configured minimum | 19.266667 |
| 45 | uuid:4cf28c10-e49b-444d-b057-f2db81dad958 | Natuhwera Sylivia | Bushenyi | Nyabubare | Nyabubare | Nkuna I | M11_STRAIGHTLINE | WARNING | response_pattern | M11 | m11 scales | Eight reintegration scale items have exactly the same normalized response | 0 |
| 104 | uuid:9bf5edc8-e555-40e1-8e3f-589f03b4a8ce | Natuhwera Sylivia | Sheema | Kabwohe Division | kabwohe | Kabwohe central | M11_STRAIGHTLINE | WARNING | response_pattern | M11 | m11 scales | Eight reintegration scale items have exactly the same normalized response | 0 |
| 34 | uuid:195cf6b6-333c-44b9-8453-f711db689316 | Akankwasa Ronals | Bushenyi | Kyamuhunga Town | Butare | Nyakahanga | M5_STRAIGHTLINE | WARNING | response_pattern | M5 | m5 scales | At least eight ADR scale items have exactly the same normalized response | 0 |
| 31 | uuid:694df33a-02e6-4c3c-a2cd-112001068039 | Nayebare Christine | Bushenyi | Kyamuhunga sub | Nsumi | Nyampungye | M5_STRAIGHTLINE | WARNING | response_pattern | M5 | m5 scales | At least eight ADR scale items have exactly the same normalized response | 0 |
| 126 | uuid:53f4f023-bebc-4bc6-abc3-ccb212d97b7d | Natukunda Britah | Sheema | Masheruka sub county | Mabare | Nyakanoni | M5_STRAIGHTLINE | WARNING | response_pattern | M5 | m5 scales | At least eight ADR scale items have exactly the same normalized response | 0 |
| 127 | uuid:b1999bec-89d4-477b-b49e-15838313a589 | Natukunda Britah | Sheema | Masheruka sub county | Mabare | Rwichumu | M5_STRAIGHTLINE | WARNING | response_pattern | M5 | m5 scales | At least eight ADR scale items have exactly the same normalized response | 0 |
| 113 | uuid:1b082c5b-eb05-4fac-b2c9-7c9726482325 | Natukunda Britah | Sheema | kagango | Kagango | Kihunda | M5_STRAIGHTLINE | WARNING | response_pattern | M5 | m5 scales | At least eight ADR scale items have exactly the same normalized response | 0 |
| 4 | uuid:8d48e301-d2fa-409b-8702-c516833d1413 | Akankwasa Ronals | Bushenyi | Bumbaire | Bumbaire | Kibaare II | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 8 | uuid:f6f99181-465b-4020-a5c6-a569e6e97e8f | Akankwasa Ronals | Bushenyi | Bushenyi central | Central ward | Nyamiko | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 13 | uuid:503ec58a-67ec-4dde-ae84-d2aab1a12767 | Natukunda Britah | Bushenyi | Ibaare | Kyamugabo | Tandara | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 14 | uuid:c8173274-23db-47f8-a1ac-af39543db00e | Natukunda Britah | Bushenyi | Ishaka Division | Ishaka | Bassaja | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 15 | uuid:3723f508-9574-49d2-85e8-8749e75302da | Natukunda Britah | Bushenyi | Ishaka Division | Ishaka | K.I.U | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 18 | uuid:4e33e3e3-86bf-4fef-ad2c-7fc111ffd675 | Ashabe Gina | Bushenyi | Kakanju | Katunga | Bwegyeme A | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 19 | uuid:2f6ce7c1-25ca-4f25-b5bc-32d4514ea791 | Ashabe Gina | Bushenyi | Kakanju | Katunga | Kakuto A | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 16 | uuid:d44d3c96-36e1-4c51-af3d-17df55309d0c | Akankwasa Ronals | Bushenyi | Kakanju | Kakanju | Kakuto B | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 20 | uuid:d3dc2c65-3ad4-4483-afb7-3fda4a145b5b | Ashabe Gina | Bushenyi | Kakanju | Katunga | Nombe B | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 17 | uuid:b070c3e6-33ba-4892-adba-79940c4e238d | Akankwasa Ronals | Bushenyi | Kakanju | Kakanju | Nyabubare A | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 21 | uuid:2b9d305d-d058-42db-a4d8-b98643c9570c | Ashabe Gina | Bushenyi | Katerera Town council | Katerera ward | Kikonjo | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 24 | uuid:45b7a882-8980-44ed-a068-444689caedd2 | Natukunda Britah | Bushenyi | Kizinda Town Council | Kizinda | Kangaate | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 22 | uuid:c0ed8cb3-3e22-4fa1-b87e-271f36d78a88 | Ashabe Gina | Bushenyi | Kizinda Town Council | Katerera ward | Katerera II | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 25 | uuid:e4eba94b-b137-4abe-b8b2-115029c6562d | Ashabe Gina | Bushenyi | Kizinda Town Council | Kizinda | Kitooma | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 26 | uuid:e82dde24-05b4-42f0-b13d-f6a2feae07c8 | Akankwasa Ronals | Bushenyi | Kizinda Town Council | Nyabubare | Masya | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 28 | uuid:88a20d13-2e15-40a2-9603-84fe82e34e49 | Natukunda Britah | Bushenyi | Kizinda Town Council | Nyabubare | Rushoroza | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 23 | uuid:14af339d-a5db-42c6-8b92-00c591eea57c | Natukunda Britah | Bushenyi | Kizinda Town Council | Kigoma | Ryabuganyi | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 29 | uuid:67d835c9-9295-4549-b8a1-b7febfc94cd9 | Nayebare Christine | Bushenyi | Kyabugimbi Sub county | Kitwe | Kajunju | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 30 | uuid:2101bb2c-523c-4bb6-938e-e0200a12f76e | Nayebare Christine | Bushenyi | Kyabugimbi Town Council | Kitwe | Buhimba A | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 34 | uuid:195cf6b6-333c-44b9-8453-f711db689316 | Akankwasa Ronals | Bushenyi | Kyamuhunga Town | Butare | Nyakahanga | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 40 | uuid:1b6b6511-7ad1-4574-8313-ff38b799c6fd | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Mashonga | Nyamabare | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 36 | uuid:b137e053-2461-47a4-acc5-71b556a9d5c6 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Nyampungye | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 31 | uuid:694df33a-02e6-4c3c-a2cd-112001068039 | Nayebare Christine | Bushenyi | Kyamuhunga sub | Nsumi | Nyampungye | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 41 | uuid:04ae9f2d-79e1-442f-ab07-b071ff294f7e | Nayebare Christine | Bushenyi | Kyeizooba | Kararo | Kitagata | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 42 | uuid:ee74a7a6-e7e4-4a57-b3cb-eb60f2a8c486 | Nayebare Christine | Bushenyi | Kyeizooba | Nyamiyaga | Nyamiyaga | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 43 | uuid:f0af6878-e298-4b0f-9099-83b18305f37e | Akankwasa Ronals | Bushenyi | Nkanga | Birimbi | Kirimbi | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 44 | uuid:86b3a17b-9d55-4f6c-bde5-0299dd14635c | Natukunda Britah | Bushenyi | Nyabubare | Nyabubare | Nkuna I | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 46 | uuid:239af270-8302-4dcc-bb26-521630f1a56b | Natukunda Britah | Bushenyi | Nyabubare | Nyabubare | Nyabitote I | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 53 | uuid:0539ed9a-11e1-4d3d-9839-361b0b55a49d | Nayebare Christine | Bushenyi | Ruhumuro | Kyeibingo | Kansenjesa | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 51 | uuid:39877f26-c133-4b17-8033-901974f6a9ef | Nayebare Christine | Bushenyi | Ruhumuro | Bugaana | Nyamyerande I | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 52 | uuid:169749d4-c6a2-497c-87f8-aaf62383ecc2 | Akankwasa Ronals | Bushenyi | Ruhumuro | Burungira | Orubingo A | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 54 | uuid:247b3a9d-310a-47a7-8cca-9c435a9cdd2f | Nayebare Christine | Bushenyi | Rwentuha | Rutooma | Rutooma ward | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 55 | uuid:9fac6fe3-6e1b-4dd5-ac62-19b7d099a55f | Nayebare Christine | Bushenyi | Rwentuha | Rutooma | Rwentuha Town | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 57 | uuid:ada3c911-6942-4e8d-85a8-8f1247924c22 | Nayebare Christine | Rubirizi | Katanda | Rwamatumba | Kisharu I | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 56 | uuid:b1910163-9f25-4920-ba0b-325287f8b2b5 | Akankwasa Ronals | Rubirizi | Katanda | kyankaranga | Mikonabire | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 58 | uuid:920f98be-7e8b-4293-abd0-9a75b13bc222 | Akankwasa Ronals | Rubirizi | Katerera Sub county | katerera | Kakindo | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 61 | uuid:9b2951b5-9998-4409-a291-3e8ad115dcdd | Nayebare Christine | Rubirizi | Katerera Town council | Katerera ward | Katabengo | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 62 | uuid:4bcc0328-e8f3-4a56-be09-6613e55f730a | Ashabe Gina | Rubirizi | Katerera Town council | Katerera ward | Katerera I | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 66 | uuid:60d430c3-8d7f-46db-abf7-c3e67b003ae8 | Nayebare Christine | Rubirizi | Katunguru | Katunguru | Kyangabukama | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 67 | uuid:38d2aaeb-79b2-48df-9bfe-2c02ca36ab63 | Akankwasa Ronals | Rubirizi | Katunguru | Katunguru | Kyangabukama | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 74 | uuid:fada9fc9-d202-4ebd-a50a-507f3b861281 | Nayebare Christine | Rubirizi | Kicwamba | Kyambura | Kyambura C | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 70 | uuid:da19adbf-707f-4d00-93db-9db55685bf60 | Ashabe Gina | Rubirizi | Kicwamba | Kicwamba | Kyambuzi B | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 73 | uuid:ca5869ec-248c-4e5b-b7bc-e4e5f9d8fc57 | Nayebare Christine | Rubirizi | Kicwamba | Kicwamba | Nyakambu | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 79 | uuid:2ba53609-89d0-47fa-a930-fc82aa40c9cd | Nayebare Christine | Rubirizi | Kirugu | Kirugu | Kafuro IB | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 80 | uuid:8a21f548-2b3c-47f0-ae07-34354de0b0f5 | Akankwasa Ronals | Rubirizi | Kirugu | Kirugu | Kirugu 2 B | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 84 | uuid:363f8a01-9abe-400c-9e1c-6ac0d323bcd0 | Akankwasa Ronals | Rubirizi | Kirugu | Kyenzaza | Kirugu IB | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 76 | uuid:1e7692a5-c876-47e9-9554-df0026d76452 | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Ntunga A | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 83 | uuid:752263e8-2373-4e77-9c0a-564dae2df964 | Nayebare Christine | Rubirizi | Kirugu | Kisenyi | Nyamweru | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 77 | uuid:eb7cfbf9-785f-4af3-9d19-0fbcb8028a1e | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Omukabare | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 82 | uuid:354a5f12-ff42-4c80-b70f-12769bfb6bff | Akankwasa Ronals | Rubirizi | Kirugu | Kirugu | Omukabare | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 85 | uuid:2c4d99f2-3f5f-4e44-93e4-337b40b98c7f | Ashabe Gina | Rubirizi | Kizinda Town Council | Katerera ward | KACU CELL | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 86 | uuid:db45a481-5312-4553-a9fc-85343aa34e88 | Ashabe Gina | Rubirizi | Kizinda Town Council | Katerera ward | RWENTOSHO I | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 87 | uuid:0d6e187f-2e96-422b-98cd-194c4705a344 | Atukwase Shallon | Rubirizi | Kyabakara | Rugarama | Bugarama | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 88 | uuid:c1cc92c3-2823-4c09-a104-5f6962c22859 | Nayebare Christine | Rubirizi | Kyabakara | Rugarama | Nyabubare | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 89 | uuid:a4206fdb-447d-4ad9-8638-8e4f3f348321 | Nayebare Christine | Rubirizi | Magambo | Bugaya | Busonga II | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 90 | uuid:10a8b3f0-4ff6-463e-adc0-40f2c21228d9 | Ashabe Gina | Rubirizi | Magambo | Butoha | Nyangorogo II | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 92 | uuid:efba04c9-32e1-4300-b89e-096e7cc7a049 | Ashabe Gina | Rubirizi | Rutoto | Rutoma | Bururuma | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 91 | uuid:caaee3f0-585d-4a65-b19b-9440d5fef788 | Ashabe Gina | Rubirizi | Rutoto | Nyabubare | Omukyeya | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 93 | uuid:e7c5124e-05d4-4b15-946c-52eaad7f399f | Ashabe Gina | Rubirizi | Rutoto | Rutoto | Rwemitanga | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 94 | uuid:8b60a0aa-959f-40c3-a9d1-af45e18ab8b7 | Akankwasa Ronals | Rubirizi | Ryeru | Bugaya | Karagara | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 96 | uuid:36bdaa5e-7a1b-4d15-b28b-9d02d9b87618 | Akankwasa Ronals | Rubirizi | Ryeru | Ndekye | Mubanda | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 95 | uuid:52263d60-be6d-4e58-b163-301a9db00945 | Nayebare Christine | Rubirizi | Ryeru | Butoha | Nyakiyaza | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 97 | uuid:d2517598-b6eb-4885-9e14-c67dcfca649b | Akankwasa Ronals | Rubirizi | Ryeru | Ndekye | Ryeru | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 98 | uuid:6a36702c-f1e8-40f9-b5dd-dc3bf9a7ee22 | Ashabe Gina | Sheema | Bugongi | Isingiro | Kyabuyongo | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 100 | uuid:43980d04-5a15-49b4-b8f1-0e897465da22 | Ashabe Gina | Sheema | Bugongi | Kyamurari | Runyinya II | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 99 | uuid:8e9ad66a-3b97-4d44-a155-a9847997022e | Nayebare Christine | Sheema | Bugongi | Kagongi | Rwenkurigo | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 101 | uuid:bbf19eca-3224-43ef-af4a-72cf65fbe86e | Akankwasa Ronals | Sheema | Bugongi | Kyamurari | Rwenkurigo | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 102 | uuid:6005d963-965c-4ba4-89b7-bc58c969c875 | Kagoro Meliza | Sheema | Kabwohe Division | Kabwohe | Ishekye | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 115 | uuid:a0e54d95-462a-4ca7-bd6e-690f32651880 | Nayebare Christine | Sheema | Kasana Sub county | Karugorora | Karugorora | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 116 | uuid:5aa7ff72-afed-4b3d-9bf1-328fa8f1fac2 | Nayebare Christine | Sheema | Kasana Sub county | Kasaana Central | Kihanga II | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 117 | uuid:f57f5dfb-9e0f-4f9a-bfc6-759c0dc5cb0b | Akankwasa Ronals | Sheema | Kasana Sub county | Kasaana North | Mishenyi | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 121 | uuid:534a4dc1-74c0-4810-8847-9c7624322cc4 | Nayebare Christine | Sheema | Kitagata Town counsil | Kyarushakara | Bwoma | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 124 | uuid:e0b54bf6-b9b5-4a1c-b223-2ee1f182036b | Nayebare Christine | Sheema | Kyangyenyi | Kashanjure | Kashanjure | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 125 | uuid:ff031e71-5a42-4fa3-93f8-ef295c630f00 | Nayebare Christine | Sheema | Kyangyenyi | Masyooro | Masyooro | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 122 | uuid:54ac1f3f-18a3-4703-909f-046b1edd7d2f | Akankwasa Ronals | Sheema | Kyangyenyi | Kagongi | Ryamatshya | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 123 | uuid:8d388b30-2bdd-47e1-9ce4-3af0393ac878 | Akankwasa Ronals | Sheema | Kyangyenyi | Kagongi | Ryamatshya II | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 128 | uuid:bbc1c66b-1296-48b6-a4aa-d056e31ad956 | Akankwasa Ronals | Sheema | Masheruka sub county | Nyabwina | Bwoma | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 129 | uuid:6fc4e7f6-3f62-45b5-9d68-5125574a73fa | Ashabe Gina | Sheema | Masheruka sub county | Nyakambu | Migera | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 130 | uuid:351c6894-28fb-4dab-8acb-b2113d20e1d1 | Ashabe Gina | Sheema | Masheruka sub county | Nyakambu | Nyakambu | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 126 | uuid:53f4f023-bebc-4bc6-abc3-ccb212d97b7d | Natukunda Britah | Sheema | Masheruka sub county | Mabare | Nyakanoni | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 127 | uuid:b1999bec-89d4-477b-b49e-15838313a589 | Natukunda Britah | Sheema | Masheruka sub county | Mabare | Rwichumu | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 114 | uuid:eaffe867-85ef-4432-91ff-51ba954becbb | Natukunda Britah | Sheema | kagango | Kagango | Kiziba | M11_RESPONSE_MISSING | WARNING | skip_logic | M11 | m11_q15 | Recent reintegration issue reported but LCC response is missing | . |
| 25 | uuid:e4eba94b-b137-4abe-b8b2-115029c6562d | Ashabe Gina | Bushenyi | Kizinda Town Council | Kizinda | Kitooma | M1_Q14_OTHER_MISS | WARNING | skip_logic | M1 | m1_q14_specify | Other was selected but the specify field is empty |  |
| 34 | uuid:195cf6b6-333c-44b9-8453-f711db689316 | Akankwasa Ronals | Bushenyi | Kyamuhunga Town | Butare | Nyakahanga | M1_Q14_OTHER_MISS | WARNING | skip_logic | M1 | m1_q14_specify | Other was selected but the specify field is empty |  |
| 50 | uuid:c1a0be42-3215-4961-a0bb-04cbfb5baca4 |  | Bushenyi | Nyakabirizi | Ward II | Katungu | M2_Q15_OTHER_MISS | WARNING | skip_logic | M2 | m2_q15_specify | Other was selected but the specify field is empty |  |
| 3 | uuid:5b1df098-f640-43fc-91e0-a6e46262338f | Atukwase Shallon | Bushenyi | Bumbaire | Bumbaire | Bumbaire II | M2_RECORD_UPTODATE_STRAY | WARNING | skip_logic | M2 | m2_q13 | Record-up-to-date response is present although no records are kept | 3 |
| 94 | uuid:8b60a0aa-959f-40c3-a9d1-af45e18ab8b7 | Akankwasa Ronals | Rubirizi | Ryeru | Bugaya | Karagara | M2_RECORD_UPTODATE_STRAY | WARNING | skip_logic | M2 | m2_q13 | Record-up-to-date response is present although no records are kept | 3 |
| 98 | uuid:6a36702c-f1e8-40f9-b5dd-dc3bf9a7ee22 | Ashabe Gina | Sheema | Bugongi | Isingiro | Kyabuyongo | M2_RECORD_UPTODATE_STRAY | WARNING | skip_logic | M2 | m2_q13 | Record-up-to-date response is present although no records are kept | 3 |
| 1 | uuid:b6b65544-0277-49af-b0f1-5a404d45bc7b | Natuhwera Sylivia | Bushenyi | Bitooma | Kimuri | Kimuri | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 4 |
| 2 | uuid:8e344c68-c753-419f-ad61-acdc57e20989 | Natuhwera Sylivia | Bushenyi | Bitooma | Nyanga ward | Kyamamari | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 4 |
| 3 | uuid:5b1df098-f640-43fc-91e0-a6e46262338f | Atukwase Shallon | Bushenyi | Bumbaire | Bumbaire | Bumbaire II | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 3 |
| 6 | uuid:2883eeb0-9366-4a9f-8de0-3c2dc7f9b5ca | Atukwase Shallon | Bushenyi | Bumbaire | Bumbaire | Kitakuuka | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 3 |
| 10 | uuid:f65ed9f8-26f6-4753-b289-857c81fa117e |  | Bushenyi | Bushenyi central | Ward II | Ruhandagazi | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 0 |
| 18 | uuid:4e33e3e3-86bf-4fef-ad2c-7fc111ffd675 | Ashabe Gina | Bushenyi | Kakanju | Katunga | Bwegyeme A | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 2 |
| 16 | uuid:d44d3c96-36e1-4c51-af3d-17df55309d0c | Akankwasa Ronals | Bushenyi | Kakanju | Kakanju | Kakuto B | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 0 |
| 20 | uuid:d3dc2c65-3ad4-4483-afb7-3fda4a145b5b | Ashabe Gina | Bushenyi | Kakanju | Katunga | Nombe B | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 3 |
| 48 | uuid:d1fcaec8-9bc6-4100-a81c-8649c52e99af | Atukwase Shallon | Bushenyi | Nyakabirizi | Kibaare | Kibaare I | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 5 |
| 49 | uuid:8c23d6d7-99d7-4bfa-9cb1-79ae221fa890 | Atukwase Shallon | Bushenyi | Nyakabirizi | Kibaare | Kibaare II | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 5 |
| 63 | uuid:330d6791-29c9-4ce9-9f0c-e5a516a88665 | Atukwase Shallon | Rubirizi | Katerera Town council | Katerera ward | KIZIRA CELL | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 4 |
| 60 | uuid:8a4d03ff-d8b3-4749-8eed-b199e80f77ed | Atukwase Shallon | Rubirizi | Katerera Town council | katerera | Nyakagyezi I | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 3 |
| 64 | uuid:81a9878f-fccd-435e-89fa-29bd380740d6 | Atukwase Shallon | Rubirizi | Katerera Town council | Katerera ward | Nyamabare | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 4 |
| 68 | uuid:4df180f3-5809-4e60-98a5-2a277378818f | Atukwase Shallon | Rubirizi | Katunguru | Kisenyi | Nyamabare | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 5 |
| 69 | uuid:d9b98bc1-3533-4349-a12b-a36e785e493f | Atukwase Shallon | Rubirizi | Kicwamba | Kicwamba | Katara I | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 3 |
| 70 | uuid:da19adbf-707f-4d00-93db-9db55685bf60 | Ashabe Gina | Rubirizi | Kicwamba | Kicwamba | Kyambuzi B | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 2 |
| 71 | uuid:b8cecd9f-74bb-4ed8-b18c-bd0cda597f51 | Atukwase Shallon | Rubirizi | Kicwamba | Kicwamba | Kyesama | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 3 |
| 72 | uuid:f8c0c408-5770-48bf-ae83-1db7ae081129 | Atukwase Shallon | Rubirizi | Kicwamba | Kicwamba | Mutambi IIB | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 4 |
| 86 | uuid:db45a481-5312-4553-a9fc-85343aa34e88 | Ashabe Gina | Rubirizi | Kizinda Town Council | Katerera ward | RWENTOSHO I | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 2 |
| 87 | uuid:0d6e187f-2e96-422b-98cd-194c4705a344 | Atukwase Shallon | Rubirizi | Kyabakara | Rugarama | Bugarama | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 3 |
| 90 | uuid:10a8b3f0-4ff6-463e-adc0-40f2c21228d9 | Ashabe Gina | Rubirizi | Magambo | Butoha | Nyangorogo II | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 2 |
| 92 | uuid:efba04c9-32e1-4300-b89e-096e7cc7a049 | Ashabe Gina | Rubirizi | Rutoto | Rutoma | Bururuma | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 2 |
| 91 | uuid:caaee3f0-585d-4a65-b19b-9440d5fef788 | Ashabe Gina | Rubirizi | Rutoto | Nyabubare | Omukyeya | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 3 |
| 93 | uuid:e7c5124e-05d4-4b15-946c-52eaad7f399f | Ashabe Gina | Rubirizi | Rutoto | Rutoto | Rwemitanga | TRAINING_RATING_STRAY | WARNING | skip_logic | training | rating_cdfu_training | Training rating is present although prior training was not reported | 3 |
## Sheet: record_flags
| qa_row_id | qa_record_id | qa_enumerator | qa_district | qa_subcounty | qa_parish | qa_village | qa_village_key | qa_duration_min | qa_interview_date | qa_interview_hour | qa_elapsed_min | qa_duration_gap_min | qa_n_missing_core_indices | qa_n_issues | qa_n_errors | qa_n_warnings | qa_n_info | qa_review_priority | qa_release_blocker |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | uuid:b6b65544-0277-49af-b0f1-5a404d45bc7b | Natuhwera Sylivia | Bushenyi | Bitooma | Kimuri | Kimuri | bushenyi_bitooma_kimuri_kimuri | 49.68333333333333 | 2026-05-19 00:00:00 | 14 | 49.675166662597654 | 0.008166670735676007 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 7 | uuid:b544facc-28d8-4fd3-b224-77092facdf73 |  | Bushenyi | Bumbaire | Nyabubare | Bumbaire II | bushenyi_bumbaire_nyabubare_bumbaire_ii | 71.68333333333334 | 2026-05-19 00:00:00 | 10 | 2582.648699995931 | 2510.9653666625977 | 0 | 4 | 2 | 1 | 1 | ERROR | Yes |
| 4 | uuid:8d48e301-d2fa-409b-8702-c516833d1413 | Akankwasa Ronals | Bushenyi | Bumbaire | Bumbaire | Kibaare II | bushenyi_bumbaire_bumbaire_kibaare_ii | 35.983333333333334 | 2026-05-30 00:00:00 | 15 | 82.12503332926433 | 46.14169999593099 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 5 | uuid:923cc8d1-ce02-42bc-b7d6-999bd8956e14 |  | Bushenyi | Bumbaire | Bumbaire | Kisubu | bushenyi_bumbaire_bumbaire_kisubu | 67.2 | 2026-05-20 00:00:00 | 10 | 1147.4726333333333 | 1080.2726333333333 | 0 | 4 | 2 | 1 | 1 | ERROR | Yes |
| 9 | uuid:fe9ea2c4-1f7c-4020-80fd-b9bdaabb20a3 |  | Bushenyi | Bushenyi central | Kyeitembe | Bwatogo | bushenyi_bushenyi_central_kyeitembe_bwatogo | 106.65 | 2026-05-18 00:00:00 | 9 | 120.7887 | 14.1387 | 0 | 4 | 2 | 1 | 1 | ERROR | Yes |
| 8 | uuid:f6f99181-465b-4020-a5c6-a569e6e97e8f | Akankwasa Ronals | Bushenyi | Bushenyi central | Central ward | Nyamiko | bushenyi_bushenyi_central_central_ward_nyamiko | 41.53333333333333 | 2026-06-05 00:00:00 | 11 | 42.99903332926432 | 1.46569999593099 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 10 | uuid:f65ed9f8-26f6-4753-b289-857c81fa117e |  | Bushenyi | Bushenyi central | Ward II | Ruhandagazi | bushenyi_bushenyi_central_ward_ii_ruhandagazi | 75.7 | 2026-05-19 00:00:00 | 13 | 2448.620700004069 | 2372.920700004069 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 13 | uuid:503ec58a-67ec-4dde-ae84-d2aab1a12767 | Natukunda Britah | Bushenyi | Ibaare | Kyamugabo | Tandara | bushenyi_ibaare_kyamugabo_tandara | 27.333333333333332 | 2026-05-20 00:00:00 | 14 | 27.338966662597656 | 0.005633329264323805 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 14 | uuid:c8173274-23db-47f8-a1ac-af39543db00e | Natukunda Britah | Bushenyi | Ishaka Division | Ishaka | Bassaja | bushenyi_ishaka_division_ishaka_bassaja | 32.93333333333333 | 2026-05-20 00:00:00 | 12 | 34.26926667480469 | 1.3359333414713603 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 15 | uuid:3723f508-9574-49d2-85e8-8749e75302da | Natukunda Britah | Bushenyi | Ishaka Division | Ishaka | K.I.U | bushenyi_ishaka_division_ishaka_kiu | 46.38333333333333 | 2026-05-19 00:00:00 | 16 | 140.62434999186198 | 94.24101665852865 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 18 | uuid:4e33e3e3-86bf-4fef-ad2c-7fc111ffd675 | Ashabe Gina | Bushenyi | Kakanju | Katunga | Bwegyeme A | bushenyi_kakanju_katunga_bwegyeme_a | 29.366666666666667 | 2026-05-18 00:00:00 | 17 | 29.373083333333334 | 0.006416666666666515 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 19 | uuid:2f6ce7c1-25ca-4f25-b5bc-32d4514ea791 | Ashabe Gina | Bushenyi | Kakanju | Katunga | Kakuto A | bushenyi_kakanju_katunga_kakuto_a | 45.166666666666664 | 2026-05-18 00:00:00 | 14 | 45.16981666666667 | 0.003150000000005093 | 0 | 4 | 2 | 1 | 1 | ERROR | Yes |
| 16 | uuid:d44d3c96-36e1-4c51-af3d-17df55309d0c | Akankwasa Ronals | Bushenyi | Kakanju | Kakanju | Kakuto B | bushenyi_kakanju_kakanju_kakuto_b | 84.11666666666666 | 2026-05-18 00:00:00 | 13 | 84.10851666259765 | 0.008150004069008787 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 20 | uuid:d3dc2c65-3ad4-4483-afb7-3fda4a145b5b | Ashabe Gina | Bushenyi | Kakanju | Katunga | Nombe B | bushenyi_kakanju_katunga_nombe_b | 62.483333333333334 | 2026-05-18 00:00:00 | 16 | 62.488266658528644 | 0.00493332519531009 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 17 | uuid:b070c3e6-33ba-4892-adba-79940c4e238d | Akankwasa Ronals | Bushenyi | Kakanju | Kakanju | Nyabubare A | bushenyi_kakanju_kakanju_nyabubare_a | 77.03333333333333 | 2026-05-30 00:00:00 | 10 | 179.069699995931 | 102.03636666259766 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 21 | uuid:2b9d305d-d058-42db-a4d8-b98643c9570c | Ashabe Gina | Bushenyi | Katerera Town council | Katerera ward | Kikonjo | bushenyi_katerera_town_council_katerera_ward_kikonjo | 54.516666666666666 | 2026-05-19 00:00:00 | 12 | 54.52219999186198 | 0.005533325195315797 | 0 | 4 | 2 | 1 | 1 | ERROR | Yes |
| 24 | uuid:45b7a882-8980-44ed-a068-444689caedd2 | Natukunda Britah | Bushenyi | Kizinda Town Council | Kizinda | Kangaate | bushenyi_kizinda_town_council_kizinda_kangaate | 65.56666666666666 | 2026-05-19 00:00:00 | 7 | 641.446700008138 | 575.8800333414713 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 22 | uuid:c0ed8cb3-3e22-4fa1-b87e-271f36d78a88 | Ashabe Gina | Bushenyi | Kizinda Town Council | Katerera ward | Katerera II | bushenyi_kizinda_town_council_katerera_ward_katerera_ii | 30.433333333333334 | 2026-05-19 00:00:00 | 13 | 30.429999995930988 | 0.0033333374023456486 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 25 | uuid:e4eba94b-b137-4abe-b8b2-115029c6562d | Ashabe Gina | Bushenyi | Kizinda Town Council | Kizinda | Kitooma | bushenyi_kizinda_town_council_kizinda_kitooma | 74.1 | 2026-05-18 00:00:00 | 10 | 74.09881666259766 | 0.0011833374023382248 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 26 | uuid:e82dde24-05b4-42f0-b13d-f6a2feae07c8 | Akankwasa Ronals | Bushenyi | Kizinda Town Council | Nyabubare | Masya | bushenyi_kizinda_town_council_nyabubare_masya | 28.45 | 2026-05-30 00:00:00 | 15 | 34.29741665852865 | 5.847416658528648 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 27 | uuid:2190d328-1a42-4f7b-874d-a670dda437fe | Natukunda Britah | Bushenyi | Kizinda Town Council | Nyabubare | Nyakinengo | bushenyi_kizinda_town_council_nyabubare_nyakinengo | 56.833333333333336 | 2026-05-19 00:00:00 | 12 | 350.04338333333334 | 293.21005 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 28 | uuid:88a20d13-2e15-40a2-9603-84fe82e34e49 | Natukunda Britah | Bushenyi | Kizinda Town Council | Nyabubare | Rushoroza | bushenyi_kizinda_town_council_nyabubare_rushoroza | 55.333333333333336 | 2026-05-19 00:00:00 | 11 | 425.15211665445963 | 369.8187833211263 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 23 | uuid:14af339d-a5db-42c6-8b92-00c591eea57c | Natukunda Britah | Bushenyi | Kizinda Town Council | Kigoma | Ryabuganyi | bushenyi_kizinda_town_council_kigoma_ryabuganyi | 91.8 | 2026-05-19 00:00:00 | 9 | 91.80423333740234 | 0.004233337402339998 | 0 | 4 | 2 | 1 | 1 | ERROR | Yes |
| 29 | uuid:67d835c9-9295-4549-b8a1-b7febfc94cd9 | Nayebare Christine | Bushenyi | Kyabugimbi Sub county | Kitwe | Kajunju | bushenyi_kyabugimbi_sub_county_kitwe_kajunju | 120.28333333333333 | 2026-05-19 00:00:00 | 10 | 122.78971666259766 | 2.506383329264324 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 30 | uuid:2101bb2c-523c-4bb6-938e-e0200a12f76e | Nayebare Christine | Bushenyi | Kyabugimbi Town Council | Kitwe | Buhimba A | bushenyi_kyabugimbi_town_council_kitwe_buhimba_a | 53.35 | 2026-05-19 00:00:00 | 13 | 54.01993333740234 | 0.6699333374023411 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 32 | uuid:33e352a4-c479-4508-9357-94a75d437c81 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Butare ward | bushenyi_kyamuhunga_town_butare_butare_ward | 63.28333333333333 | 2026-05-18 00:00:00 | 12 | 63.288383337402344 | 0.005050004069012459 | 0 | 2 | 1 | 0 | 1 | ERROR | Yes |
| 38 | uuid:19a8b7cb-3020-4b6a-9334-8082aa9e84e2 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Mashonga | KYAMABARE | bushenyi_kyamuhunga_town_mashonga_kyamabare | 36.266666666666666 | 2026-05-20 00:00:00 | 8 | 41.17706666259765 | 4.910399995930987 | 0 | 2 | 1 | 0 | 1 | ERROR | Yes |
| 33 | uuid:476cec79-33e1-43cf-a0ee-3f319d1606f9 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Nyakahanga | bushenyi_kyamuhunga_town_butare_nyakahanga | 70.88333333333334 | 2026-05-18 00:00:00 | 19 | 733.1607833292643 | 662.277449995931 | 0 | 4 | 2 | 1 | 1 | ERROR | Yes |
| 34 | uuid:195cf6b6-333c-44b9-8453-f711db689316 | Akankwasa Ronals | Bushenyi | Kyamuhunga Town | Butare | Nyakahanga | bushenyi_kyamuhunga_town_butare_nyakahanga | 461.73333333333335 | 2026-05-18 00:00:00 | 8 | 494.904750004069 | 33.17141667073565 | 0 | 7 | 1 | 5 | 1 | ERROR | Yes |
| 40 | uuid:1b6b6511-7ad1-4574-8313-ff38b799c6fd | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Mashonga | Nyamabare | bushenyi_kyamuhunga_town_mashonga_nyamabare | 59.35 | 2026-05-18 00:00:00 | 15 | 59.347583345540365 | 0.002416654459636902 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 36 | uuid:b137e053-2461-47a4-acc5-71b556a9d5c6 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Nyampungye | bushenyi_kyamuhunga_town_butare_nyampungye | 100.76666666666667 | 2026-05-18 00:00:00 | 10 | 101.01178333740235 | 0.24511667073568333 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 31 | uuid:694df33a-02e6-4c3c-a2cd-112001068039 | Nayebare Christine | Bushenyi | Kyamuhunga sub | Nsumi | Nyampungye | bushenyi_kyamuhunga_sub_nsumi_nyampungye | 42.55 | 2026-05-30 00:00:00 | 12 | 44.255116670735674 | 1.705116670735677 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 41 | uuid:04ae9f2d-79e1-442f-ab07-b071ff294f7e | Nayebare Christine | Bushenyi | Kyeizooba | Kararo | Kitagata | bushenyi_kyeizooba_kararo_kitagata | 71.73333333333333 | 2026-05-19 00:00:00 | 8 | 90.70683333333334 | 18.9735 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 42 | uuid:ee74a7a6-e7e4-4a57-b3cb-eb60f2a8c486 | Nayebare Christine | Bushenyi | Kyeizooba | Nyamiyaga | Nyamiyaga | bushenyi_kyeizooba_nyamiyaga_nyamiyaga | 20.083333333333332 | 2026-05-20 00:00:00 | 12 | 217.11036666259767 | 197.02703332926433 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 43 | uuid:f0af6878-e298-4b0f-9099-83b18305f37e | Akankwasa Ronals | Bushenyi | Nkanga | Birimbi | Kirimbi | bushenyi_nkanga_birimbi_kirimbi | 21.116666666666667 | 2026-05-30 00:00:00 | 14 | 21.122966674804687 | 0.006300008138019564 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 44 | uuid:86b3a17b-9d55-4f6c-bde5-0299dd14635c | Natukunda Britah | Bushenyi | Nyabubare | Nyabubare | Nkuna I | bushenyi_nyabubare_nyabubare_nkuna_i | 44.43333333333333 | 2026-05-20 00:00:00 | 8 | 45.605483329264324 | 1.1721499959309938 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 45 | uuid:4cf28c10-e49b-444d-b057-f2db81dad958 | Natuhwera Sylivia | Bushenyi | Nyabubare | Nyabubare | Nkuna I | bushenyi_nyabubare_nyabubare_nkuna_i | 33.9 | 2026-05-20 00:00:00 | 12 | 33.897233325195316 | 0.002766674804682623 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 46 | uuid:239af270-8302-4dcc-bb26-521630f1a56b | Natukunda Britah | Bushenyi | Nyabubare | Nyabubare | Nyabitote I | bushenyi_nyabubare_nyabubare_nyabitote_i | 19.1 | 2026-05-20 00:00:00 | 10 | 19.10055 | 0.0005499999999969418 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 47 | uuid:6d7153e4-543a-453b-ac2c-3ddf46a92f49 | Natuhwera Sylivia | Bushenyi | Nyabubare | Nyabubare | Nyabitote I | bushenyi_nyabubare_nyabubare_nyabitote_i | 51.9 | 2026-05-20 00:00:00 | 13 | 51.89173332519531 | 0.008266674804687568 | 0 | 2 | 1 | 0 | 1 | ERROR | Yes |
| 50 | uuid:c1a0be42-3215-4961-a0bb-04cbfb5baca4 |  | Bushenyi | Nyakabirizi | Ward II | Katungu | bushenyi_nyakabirizi_ward_ii_katungu | 68.96666666666667 | 2026-05-20 00:00:00 | 14 | 944.8081333333333 | 875.8414666666666 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 53 | uuid:0539ed9a-11e1-4d3d-9839-361b0b55a49d | Nayebare Christine | Bushenyi | Ruhumuro | Kyeibingo | Kansenjesa | bushenyi_ruhumuro_kyeibingo_kansenjesa | 37.583333333333336 | 2026-05-30 00:00:00 | 9 | 49.85430000406901 | 12.270966670735675 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 51 | uuid:39877f26-c133-4b17-8033-901974f6a9ef | Nayebare Christine | Bushenyi | Ruhumuro | Bugaana | Nyamyerande I | bushenyi_ruhumuro_bugaana_nyamyerande_i | 40.983333333333334 | 2026-05-30 00:00:00 | 8 | 49.02565000406901 | 8.042316670735673 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 52 | uuid:169749d4-c6a2-497c-87f8-aaf62383ecc2 | Akankwasa Ronals | Bushenyi | Ruhumuro | Burungira | Orubingo A | bushenyi_ruhumuro_burungira_orubingo_a | 44.56666666666667 | 2026-05-30 00:00:00 | 11 | 53.17930001220703 | 8.61263334554036 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 55 | uuid:9fac6fe3-6e1b-4dd5-ac62-19b7d099a55f | Nayebare Christine | Bushenyi | Rwentuha | Rutooma | Rwentuha Town | bushenyi_rwentuha_rutooma_rwentuha_town | 20.416666666666668 | 2026-05-30 00:00:00 | 16 | 25.35745 | 4.940783333333332 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 57 | uuid:ada3c911-6942-4e8d-85a8-8f1247924c22 | Nayebare Christine | Rubirizi | Katanda | Rwamatumba | Kisharu I | rubirizi_katanda_rwamatumba_kisharu_i | 64.13333333333334 | 2026-05-29 00:00:00 | 14 | 86.82568332926432 | 22.692349995930982 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 56 | uuid:b1910163-9f25-4920-ba0b-325287f8b2b5 | Akankwasa Ronals | Rubirizi | Katanda | kyankaranga | Mikonabire | rubirizi_katanda_kyankaranga_mikonabire | 26.283333333333335 | 2026-05-29 00:00:00 | 14 | 26.28113332926432 | 0.0022000040690137723 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 58 | uuid:920f98be-7e8b-4293-abd0-9a75b13bc222 | Akankwasa Ronals | Rubirizi | Katerera Sub county | katerera | Kakindo | rubirizi_katerera_sub_county_katerera_kakindo | 18.1 | 2026-05-29 00:00:00 | 14 | 18.103733329264323 | 0.003733329264321128 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 63 | uuid:330d6791-29c9-4ce9-9f0c-e5a516a88665 | Atukwase Shallon | Rubirizi | Katerera Town council | Katerera ward | KIZIRA CELL | rubirizi_katerera_town_council_katerera_ward_kizira_cell | 55.516666666666666 | 2026-05-19 00:00:00 | 14 | 72.48558332926433 | 16.968916662597664 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 61 | uuid:9b2951b5-9998-4409-a291-3e8ad115dcdd | Nayebare Christine | Rubirizi | Katerera Town council | Katerera ward | Katabengo | rubirizi_katerera_town_council_katerera_ward_katabengo | 17.95 | 2026-05-29 00:00:00 | 11 | 17.952716674804687 | 0.0027166748046880684 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 62 | uuid:4bcc0328-e8f3-4a56-be09-6613e55f730a | Ashabe Gina | Rubirizi | Katerera Town council | Katerera ward | Katerera I | rubirizi_katerera_town_council_katerera_ward_katerera_i | 86.06666666666666 | 2026-05-19 00:00:00 | 8 | 185.25891667480468 | 99.19225000813802 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 64 | uuid:81a9878f-fccd-435e-89fa-29bd380740d6 | Atukwase Shallon | Rubirizi | Katerera Town council | Katerera ward | Nyamabare | rubirizi_katerera_town_council_katerera_ward_nyamabare | 44.28333333333333 | 2026-05-19 00:00:00 | 12 | 46.00271667073568 | 1.7193833374023484 | 0 | 4 | 2 | 1 | 1 | ERROR | Yes |
| 66 | uuid:60d430c3-8d7f-46db-abf7-c3e67b003ae8 | Nayebare Christine | Rubirizi | Katunguru | Katunguru | Kyangabukama | rubirizi_katunguru_katunguru_kyangabukama | 41.6 | 2026-05-29 00:00:00 | 9 | 42.10689999593099 | 0.5068999959309863 | 0 | 4 | 2 | 1 | 1 | ERROR | Yes |
| 67 | uuid:38d2aaeb-79b2-48df-9bfe-2c02ca36ab63 | Akankwasa Ronals | Rubirizi | Katunguru | Katunguru | Kyangabukama | rubirizi_katunguru_katunguru_kyangabukama | 17.816666666666666 | 2026-05-29 00:00:00 | 13 | 17.817433333333334 | 0.0007666666666672484 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 74 | uuid:fada9fc9-d202-4ebd-a50a-507f3b861281 | Nayebare Christine | Rubirizi | Kicwamba | Kyambura | Kyambura C | rubirizi_kicwamba_kyambura_kyambura_c | 51.56666666666667 | 2026-05-29 00:00:00 | 12 | 77.93343332926432 | 26.366766662597648 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 70 | uuid:da19adbf-707f-4d00-93db-9db55685bf60 | Ashabe Gina | Rubirizi | Kicwamba | Kicwamba | Kyambuzi B | rubirizi_kicwamba_kicwamba_kyambuzi_b | 51.06666666666667 | 2026-05-20 00:00:00 | 8 | 51.06408332519531 | 0.0025833414713574143 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 73 | uuid:ca5869ec-248c-4e5b-b7bc-e4e5f9d8fc57 | Nayebare Christine | Rubirizi | Kicwamba | Kicwamba | Nyakambu | rubirizi_kicwamba_kicwamba_nyakambu | 24.85 | 2026-05-20 00:00:00 | 8 | 245.01188334147136 | 220.16188334147137 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 79 | uuid:2ba53609-89d0-47fa-a930-fc82aa40c9cd | Nayebare Christine | Rubirizi | Kirugu | Kirugu | Kafuro IB | rubirizi_kirugu_kirugu_kafuro_ib | 61.666666666666664 | 2026-05-29 00:00:00 | 10 | 85.01954999593099 | 23.352883329264323 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 80 | uuid:8a21f548-2b3c-47f0-ae07-34354de0b0f5 | Akankwasa Ronals | Rubirizi | Kirugu | Kirugu | Kirugu 2 B | rubirizi_kirugu_kirugu_kirugu_2_b | 55.86666666666667 | 2026-05-29 00:00:00 | 8 | 69.72376666666666 | 13.857099999999996 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 84 | uuid:363f8a01-9abe-400c-9e1c-6ac0d323bcd0 | Akankwasa Ronals | Rubirizi | Kirugu | Kyenzaza | Kirugu IB | rubirizi_kirugu_kyenzaza_kirugu_ib | 42.6 | 2026-05-19 00:00:00 | 15 | 44.39891666259766 | 1.7989166625976551 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 81 | uuid:4dee5693-f48a-40c7-824b-4d3c8d139419 | Akankwasa Ronals | Rubirizi | Kirugu | Kirugu | Mirarikye | rubirizi_kirugu_kirugu_mirarikye | 76.51666666666667 | 2026-05-19 00:00:00 | 13 | 76.52306667073567 | 0.006400004069007537 | 0 | 2 | 1 | 0 | 1 | ERROR | Yes |
| 76 | uuid:1e7692a5-c876-47e9-9554-df0026d76452 | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Ntunga A | rubirizi_kirugu_kikumbo_ntunga_a | 56.166666666666664 | 2026-05-19 00:00:00 | 9 | 56.1725 | 0.005833333333335133 | 0 | 4 | 2 | 1 | 1 | ERROR | Yes |
| 83 | uuid:752263e8-2373-4e77-9c0a-564dae2df964 | Nayebare Christine | Rubirizi | Kirugu | Kisenyi | Nyamweru | rubirizi_kirugu_kisenyi_nyamweru | 53.85 | 2026-05-29 00:00:00 | 8 | 56.629699991861976 | 2.7796999918619747 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 77 | uuid:eb7cfbf9-785f-4af3-9d19-0fbcb8028a1e | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Omukabare | rubirizi_kirugu_kikumbo_omukabare | 27.733333333333334 | 2026-05-29 00:00:00 | 12 | 27.734816666666667 | 0.001483333333332837 | 0 | 4 | 2 | 1 | 1 | ERROR | Yes |
| 78 | uuid:1d9d1643-ebce-47c7-9ff1-ae41e373f414 | Akankwasa Ronals | Rubirizi | Kirugu | Kikumbo | Omukabare | rubirizi_kirugu_kikumbo_omukabare | 45.25 | 2026-05-19 00:00:00 | 12 | 45.252916666666664 | 0.002916666666664014 | 0 | 3 | 2 | 0 | 1 | ERROR | Yes |
| 82 | uuid:354a5f12-ff42-4c80-b70f-12769bfb6bff | Akankwasa Ronals | Rubirizi | Kirugu | Kirugu | Omukabare | rubirizi_kirugu_kirugu_omukabare | 67.06666666666666 | 2026-05-19 00:00:00 | 11 | 67.07265000813803 | 0.005983341471363701 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 85 | uuid:2c4d99f2-3f5f-4e44-93e4-337b40b98c7f | Ashabe Gina | Rubirizi | Kizinda Town Council | Katerera ward | KACU CELL | rubirizi_kizinda_town_council_katerera_ward_kacu_cell | 49.78333333333333 | 2026-05-19 00:00:00 | 13 | 49.77778333333333 | 0.0055499999999995 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 86 | uuid:db45a481-5312-4553-a9fc-85343aa34e88 | Ashabe Gina | Rubirizi | Kizinda Town Council | Katerera ward | RWENTOSHO I | rubirizi_kizinda_town_council_katerera_ward_rwentosho_i | 29.55 | 2026-05-19 00:00:00 | 15 | 29.54994999593099 | 5.0004069009901286e-05 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 88 | uuid:c1cc92c3-2823-4c09-a104-5f6962c22859 | Nayebare Christine | Rubirizi | Kyabakara | Rugarama | Nyabubare | rubirizi_kyabakara_rugarama_nyabubare | 41.266666666666666 | 2026-05-20 00:00:00 | 15 | 71.09234999186198 | 29.825683325195314 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 89 | uuid:a4206fdb-447d-4ad9-8638-8e4f3f348321 | Nayebare Christine | Rubirizi | Magambo | Bugaya | Busonga II | rubirizi_magambo_bugaya_busonga_ii | 57.95 | 2026-05-20 00:00:00 | 9 | 179.33953333333332 | 121.38953333333332 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 90 | uuid:10a8b3f0-4ff6-463e-adc0-40f2c21228d9 | Ashabe Gina | Rubirizi | Magambo | Butoha | Nyangorogo II | rubirizi_magambo_butoha_nyangorogo_ii | 63.4 | 2026-05-20 00:00:00 | 9 | 63.4079 | 0.007899999999999352 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 92 | uuid:efba04c9-32e1-4300-b89e-096e7cc7a049 | Ashabe Gina | Rubirizi | Rutoto | Rutoma | Bururuma | rubirizi_rutoto_rutoma_bururuma | 42.95 | 2026-05-20 00:00:00 | 14 | 42.95076666259766 | 0.0007666625976554542 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 91 | uuid:caaee3f0-585d-4a65-b19b-9440d5fef788 | Ashabe Gina | Rubirizi | Rutoto | Nyabubare | Omukyeya | rubirizi_rutoto_nyabubare_omukyeya | 31.233333333333334 | 2026-05-20 00:00:00 | 15 | 31.235616666666665 | 0.0022833333333309724 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 93 | uuid:e7c5124e-05d4-4b15-946c-52eaad7f399f | Ashabe Gina | Rubirizi | Rutoto | Rutoto | Rwemitanga | rubirizi_rutoto_rutoto_rwemitanga | 31.366666666666667 | 2026-05-20 00:00:00 | 12 | 31.373533333333334 | 0.006866666666667243 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 94 | uuid:8b60a0aa-959f-40c3-a9d1-af45e18ab8b7 | Akankwasa Ronals | Rubirizi | Ryeru | Bugaya | Karagara | rubirizi_ryeru_bugaya_karagara | 65.9 | 2026-05-20 00:00:00 | 9 | 65.90636666666667 | 0.006366666666664855 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 96 | uuid:36bdaa5e-7a1b-4d15-b28b-9d02d9b87618 | Akankwasa Ronals | Rubirizi | Ryeru | Ndekye | Mubanda | rubirizi_ryeru_ndekye_mubanda | 56.65 | 2026-05-20 00:00:00 | 12 | 56.64954999593099 | 0.00045000406900896905 | 0 | 4 | 2 | 1 | 1 | ERROR | Yes |
| 95 | uuid:52263d60-be6d-4e58-b163-301a9db00945 | Nayebare Christine | Rubirizi | Ryeru | Butoha | Nyakiyaza | rubirizi_ryeru_butoha_nyakiyaza | 38.21666666666667 | 2026-05-20 00:00:00 | 11 | 53.87295000406901 | 15.656283337402343 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 97 | uuid:d2517598-b6eb-4885-9e14-c67dcfca649b | Akankwasa Ronals | Rubirizi | Ryeru | Ndekye | Ryeru | rubirizi_ryeru_ndekye_ryeru | 30.2 | 2026-05-20 00:00:00 | 16 | 30.19465000406901 | 0.005349995930988172 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 98 | uuid:6a36702c-f1e8-40f9-b5dd-dc3bf9a7ee22 | Ashabe Gina | Sheema | Bugongi | Isingiro | Kyabuyongo | sheema_bugongi_isingiro_kyabuyongo | 44.016666666666666 | 2026-05-21 00:00:00 | 13 | 44.01929999593099 | 0.0026333292643272443 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 100 | uuid:43980d04-5a15-49b4-b8f1-0e897465da22 | Ashabe Gina | Sheema | Bugongi | Kyamurari | Runyinya II | sheema_bugongi_kyamurari_runyinya_ii | 27.8 | 2026-05-21 00:00:00 | 14 | 27.795183329264322 | 0.0048166707356784855 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 99 | uuid:8e9ad66a-3b97-4d44-a155-a9847997022e | Nayebare Christine | Sheema | Bugongi | Kagongi | Rwenkurigo | sheema_bugongi_kagongi_rwenkurigo | 23.416666666666668 | 2026-05-21 00:00:00 | 13 | 200.55701666259765 | 177.140349995931 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 102 | uuid:6005d963-965c-4ba4-89b7-bc58c969c875 | Kagoro Meliza | Sheema | Kabwohe Division | Kabwohe | Ishekye | sheema_kabwohe_division_kabwohe_ishekye | 59.1 | 2026-05-21 00:00:00 | 7 | 60.208083333333335 | 1.108083333333333 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 103 | uuid:b445a616-8864-4508-a15c-f8f3deccabb3 | Kagoro Meliza | Sheema | Kabwohe Division | Kabwohe | Kabwohe A | sheema_kabwohe_division_kabwohe_kabwohe_a | 30.15 | 2026-05-21 00:00:00 | 12 | 30.787466666666667 | 0.6374666666666684 | 0 | 2 | 1 | 0 | 1 | ERROR | Yes |
| 104 | uuid:9bf5edc8-e555-40e1-8e3f-589f03b4a8ce | Natuhwera Sylivia | Sheema | Kabwohe Division | kabwohe | Kabwohe central | sheema_kabwohe_division_kabwohe_kabwohe_central | 51.03333333333333 | 2026-05-21 00:00:00 | 15 | 51.03855000406901 | 0.005216670735677553 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 105 | uuid:6ad56b9d-2710-40f1-ba26-6321f8a0e07c | Kagoro Meliza | Sheema | Kabwohe Division | kabwohe | Kabwohe hill | sheema_kabwohe_division_kabwohe_kabwohe_hill | 44.68333333333333 | 2026-05-21 00:00:00 | 8 | 44.677783341471354 | 0.005549991861975911 | 0 | 2 | 1 | 0 | 1 | ERROR | Yes |
| 106 | uuid:bb4497b7-a4d1-48ad-b75c-edc9dfedd36b | Kagoro Meliza | Sheema | Kabwohe Division | Kabwohe | Kyamatongo | sheema_kabwohe_division_kabwohe_kyamatongo | 36.96666666666667 | 2026-05-21 00:00:00 | 10 | 39.15998333333334 | 2.193316666666668 | 0 | 2 | 1 | 0 | 1 | ERROR | Yes |
| 108 | uuid:175fe80a-15d4-4f74-92b5-619f94854830 | Natuhwera Sylivia | Sheema | Kabwohe Division | Nyanga | Mabaga Cell | sheema_kabwohe_division_nyanga_mabaga_cell | 45.81666666666667 | 2026-05-21 00:00:00 | 11 | 47.66144999186198 | 1.8447833251953085 | 0 | 2 | 1 | 0 | 1 | ERROR | Yes |
| 109 | uuid:868bec7f-1ce9-4ea4-a204-a2e5fd59187c | Kagoro Meliza | Sheema | Kabwohe Division | Nyanga | Mailo IV | sheema_kabwohe_division_nyanga_mailo_iv | 34.96666666666667 | 2026-05-21 00:00:00 | 11 | 34.962350008138024 | 0.004316658528644268 | 0 | 2 | 1 | 0 | 1 | ERROR | Yes |
| 107 | uuid:adb21efa-2e1c-48b5-9caa-f6875cdfefa0 | Natuhwera Sylivia | Sheema | Kabwohe Division | kabwohe | Market cell | sheema_kabwohe_division_kabwohe_market_cell | 20.766666666666666 | 2026-05-21 00:00:00 | 12 | 20.76170000406901 | 0.004966662597656324 | 0 | 2 | 1 | 0 | 1 | ERROR | Yes |
| 110 | uuid:91a71c36-ddab-4bff-b95e-396a5171d7ca | Kagoro Meliza | Sheema | Kabwohe Division | Nyanga | Rushoroza | sheema_kabwohe_division_nyanga_rushoroza | 35.45 | 2026-05-21 00:00:00 | 10 | 39.44269999186198 | 3.9926999918619757 | 0 | 2 | 1 | 0 | 1 | ERROR | Yes |
| 115 | uuid:a0e54d95-462a-4ca7-bd6e-690f32651880 | Nayebare Christine | Sheema | Kasana Sub county | Karugorora | Karugorora | sheema_kasana_sub_county_karugorora_karugorora | 55.2 | 2026-05-21 00:00:00 | 15 | 106.21019999593099 | 51.01019999593099 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 116 | uuid:5aa7ff72-afed-4b3d-9bf1-328fa8f1fac2 | Nayebare Christine | Sheema | Kasana Sub county | Kasaana Central | Kihanga II | sheema_kasana_sub_county_kasaana_central_kihanga_ii | 17.8 | 2026-05-21 00:00:00 | 16 | 17.79719999593099 | 0.002800004069012374 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 117 | uuid:f57f5dfb-9e0f-4f9a-bfc6-759c0dc5cb0b | Akankwasa Ronals | Sheema | Kasana Sub county | Kasaana North | Mishenyi | sheema_kasana_sub_county_kasaana_north_mishenyi | 22.65 | 2026-05-21 00:00:00 | 16 | 22.648933337402344 | 0.001066662597654755 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 120 | uuid:d2aa797e-a3cc-4167-97bc-32a251a8c846 | Natuhwera Sylivia | Sheema | Kigarama Sub county | Kigarama | Katanoga | sheema_kigarama_sub_county_kigarama_katanoga | 45.86666666666667 | 2026-05-21 00:00:00 | 7 | 45.864216662597656 | 0.0024500040690114133 | 0 | 2 | 1 | 0 | 1 | ERROR | Yes |
| 118 | uuid:f224fa56-9614-46e3-8680-eff3993e90b1 | Natuhwera Sylivia | Sheema | Kigarama Sub county | Byayegamba | Nyakasharara | sheema_kigarama_sub_county_byayegamba_nyakasharara | 38.05 | 2026-05-21 00:00:00 | 10 | 38.04296665852865 | 0.00703334147134882 | 0 | 2 | 1 | 0 | 1 | ERROR | Yes |
| 121 | uuid:534a4dc1-74c0-4810-8847-9c7624322cc4 | Nayebare Christine | Sheema | Kitagata Town counsil | Kyarushakara | Bwoma | sheema_kitagata_town_counsil_kyarushakara_bwoma | 23.5 | 2026-05-21 00:00:00 | 17 | 23.50416667073568 | 0.004166670735678224 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 124 | uuid:e0b54bf6-b9b5-4a1c-b223-2ee1f182036b | Nayebare Christine | Sheema | Kyangyenyi | Kashanjure | Kashanjure | sheema_kyangyenyi_kashanjure_kashanjure | 16.983333333333334 | 2026-05-21 00:00:00 | 9 | 16.9762 | 0.007133333333335656 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 125 | uuid:ff031e71-5a42-4fa3-93f8-ef295c630f00 | Nayebare Christine | Sheema | Kyangyenyi | Masyooro | Masyooro | sheema_kyangyenyi_masyooro_masyooro | 26.35 | 2026-05-21 00:00:00 | 10 | 26.346116674804687 | 0.0038833251953143133 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 122 | uuid:54ac1f3f-18a3-4703-909f-046b1edd7d2f | Akankwasa Ronals | Sheema | Kyangyenyi | Kagongi | Ryamatshya | sheema_kyangyenyi_kagongi_ryamatshya | 33.61666666666667 | 2026-05-21 00:00:00 | 10 | 54.31283332926432 | 20.696166662597655 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 123 | uuid:8d388b30-2bdd-47e1-9ce4-3af0393ac878 | Akankwasa Ronals | Sheema | Kyangyenyi | Kagongi | Ryamatshya II | sheema_kyangyenyi_kagongi_ryamatshya_ii | 28.7 | 2026-05-21 00:00:00 | 9 | 28.702616662597656 | 0.0026166625976564717 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 128 | uuid:bbc1c66b-1296-48b6-a4aa-d056e31ad956 | Akankwasa Ronals | Sheema | Masheruka sub county | Nyabwina | Bwoma | sheema_masheruka_sub_county_nyabwina_bwoma | 24.6 | 2026-05-21 00:00:00 | 7 | 26.82764999186198 | 2.227649991861977 | 0 | 3 | 1 | 1 | 1 | ERROR | Yes |
| 126 | uuid:53f4f023-bebc-4bc6-abc3-ccb212d97b7d | Natukunda Britah | Sheema | Masheruka sub county | Mabare | Nyakanoni | sheema_masheruka_sub_county_mabare_nyakanoni | 24.533333333333335 | 2026-05-21 00:00:00 | 7 | 24.53740000813802 | 0.0040666748046866985 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 127 | uuid:b1999bec-89d4-477b-b49e-15838313a589 | Natukunda Britah | Sheema | Masheruka sub county | Mabare | Rwichumu | sheema_masheruka_sub_county_mabare_rwichumu | 23.333333333333332 | 2026-05-21 00:00:00 | 8 | 23.33095 | 0.0023833333333307394 | 0 | 5 | 2 | 2 | 1 | ERROR | Yes |
| 112 | uuid:9cc25ab4-3f37-41c7-875c-e0373445bdc4 | Natukunda Britah | Sheema | kagango | Kagango | Kanyina | sheema_kagango_kagango_kanyina | 36.15 | 2026-05-21 00:00:00 | 13 | 36.713283337402345 | 0.5632833374023463 | 0 | 3 | 2 | 0 | 1 | ERROR | Yes |
| 113 | uuid:1b082c5b-eb05-4fac-b2c9-7c9726482325 | Natukunda Britah | Sheema | kagango | Kagango | Kihunda | sheema_kagango_kagango_kihunda | 19.266666666666666 | 2026-05-21 00:00:00 | 11 | 19.260316662597656 | 0.0063500040690094295 | 0 | 4 | 1 | 2 | 1 | ERROR | Yes |
| 114 | uuid:eaffe867-85ef-4432-91ff-51ba954becbb | Natukunda Britah | Sheema | kagango | Kagango | Kiziba | sheema_kagango_kagango_kiziba | 32.483333333333334 | 2026-05-21 00:00:00 | 12 | 33.746416674804685 | 1.2630833414713507 | 0 | 4 | 2 | 1 | 1 | ERROR | Yes |
| 3 | uuid:5b1df098-f640-43fc-91e0-a6e46262338f | Atukwase Shallon | Bushenyi | Bumbaire | Bumbaire | Bumbaire II | bushenyi_bumbaire_bumbaire_bumbaire_ii | 69.9 | 2026-05-18 00:00:00 | 18 | 75.82704999593099 | 5.927049995930986 | 0 | 4 | 0 | 3 | 1 | HIGH | No |
| 48 | uuid:d1fcaec8-9bc6-4100-a81c-8649c52e99af | Atukwase Shallon | Bushenyi | Nyakabirizi | Kibaare | Kibaare I | bushenyi_nyakabirizi_kibaare_kibaare_i | 205.8 | 2026-05-18 00:00:00 | 13 | 277.82503334554036 | 72.02503334554035 | 0 | 4 | 0 | 3 | 1 | HIGH | No |
| 87 | uuid:0d6e187f-2e96-422b-98cd-194c4705a344 | Atukwase Shallon | Rubirizi | Kyabakara | Rugarama | Bugarama | rubirizi_kyabakara_rugarama_bugarama | 56.85 | 2026-05-20 00:00:00 | 15 | 78.89446666259765 | 22.04446666259765 | 0 | 4 | 0 | 3 | 1 | HIGH | No |
| 11 | uuid:de8ac1f2-ff18-41e0-91c8-180a394218d9 | Natukunda Britah | Bushenyi | Ibaare | Kyamugabo | Kibingo | bushenyi_ibaare_kyamugabo_kibingo | 33.43333333333333 | 2026-05-20 00:00:00 | 13 | 33.43756666666667 | 0.004233333333338862 | 0 | 1 | 0 | 0 | 1 | PASS | No |
| 37 | uuid:14c2cf8f-a846-4283-be6b-65a03bfa0f2f | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Kakoni | Manengo | bushenyi_kyamuhunga_town_kakoni_manengo | 36.266666666666666 | 2026-05-19 00:00:00 | 16 | 36.264416662597654 | 0.0022500040690118794 | 0 | 1 | 0 | 0 | 1 | PASS | No |
| 39 | uuid:e797533b-8e6d-44fd-9acb-730d417beac9 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Mashonga | NYAKAZINGA | bushenyi_kyamuhunga_town_mashonga_nyakazinga | 40.7 | 2026-05-20 00:00:00 | 9 | 40.70231666666667 | 0.0023166666666654123 | 0 | 1 | 0 | 0 | 1 | PASS | No |
| 35 | uuid:5e65e5ca-2cd4-4774-8639-72a360423bf0 | Natuhwera Sylivia | Bushenyi | Kyamuhunga Town | Butare | Nyamalembe | bushenyi_kyamuhunga_town_butare_nyamalembe | 46.85 | 2026-05-20 00:00:00 | 6 | 46.9125 | 0.0625 | 0 | 1 | 0 | 0 | 1 | PASS | No |
| 59 | uuid:0e4fc0f5-d89d-4739-ab70-2778ab95b10f | Atukwase Shallon | Rubirizi | Katerera Town council | katerera | Kabaseeka | rubirizi_katerera_town_council_katerera_kabaseeka | 60.416666666666664 | 2026-05-19 00:00:00 | 11 | 62.22706665852865 | 1.8103999918619849 | 0 | 1 | 0 | 0 | 1 | PASS | No |
| 75 | uuid:882b0617-3187-434f-ab9a-272b9129dce4 | Akankwasa Ronals | Rubirizi | Kicwamba | Rumri | Rumuri II | rubirizi_kicwamba_rumri_rumuri_ii | 44.85 | 2026-05-20 00:00:00 | 8 | 44.84639999593099 | 0.0036000040690140622 | 0 | 1 | 0 | 0 | 1 | PASS | No |
| 119 | uuid:100b5afe-d2d5-4a17-b542-289a7c522bcc | Natuhwera Sylivia | Sheema | Kigarama Sub county | Kigarama | Kagarama | sheema_kigarama_sub_county_kigarama_kagarama | 28.416666666666668 | 2026-05-21 00:00:00 | 9 | 28.410466666666668 | 0.006199999999999761 | 0 | 1 | 0 | 0 | 1 | PASS | No |
| 111 | uuid:639b3dfc-67c1-4247-8573-794bf87192be | Natukunda Britah | Sheema | kagango | Kagango | Itendero Town | sheema_kagango_kagango_itendero_town | 23.866666666666667 | 2026-05-21 00:00:00 | 13 | 24.03419999186198 | 0.16753332519531128 | 0 | 1 | 0 | 0 | 1 | PASS | No |
| 2 | uuid:8e344c68-c753-419f-ad61-acdc57e20989 | Natuhwera Sylivia | Bushenyi | Bitooma | Nyanga ward | Kyamamari | bushenyi_bitooma_nyanga_ward_kyamamari | 29.833333333333332 | 2026-05-19 00:00:00 | 11 | 81.66198333333334 | 51.82865000000001 | 0 | 3 | 0 | 2 | 1 | REVIEW | No |
| 6 | uuid:2883eeb0-9366-4a9f-8de0-3c2dc7f9b5ca | Atukwase Shallon | Bushenyi | Bumbaire | Bumbaire | Kitakuuka | bushenyi_bumbaire_bumbaire_kitakuuka | 93.3 | 2026-05-18 00:00:00 | 10 | 103.98205 | 10.682050000000004 | 0 | 3 | 0 | 2 | 1 | REVIEW | No |
| 12 | uuid:3da795bc-f111-4ee4-9407-702eeba682c1 | Natukunda Britah | Bushenyi | Ibaare | Kyamugabo | Kyamugabo | bushenyi_ibaare_kyamugabo_kyamugabo | 21.266666666666666 | 2026-05-20 00:00:00 | 16 | 31.698966658528647 | 10.432299991861981 | 0 | 2 | 0 | 1 | 1 | REVIEW | No |
| 49 | uuid:8c23d6d7-99d7-4bfa-9cb1-79ae221fa890 | Atukwase Shallon | Bushenyi | Nyakabirizi | Kibaare | Kibaare II | bushenyi_nyakabirizi_kibaare_kibaare_ii | 52.88333333333333 | 2026-05-18 00:00:00 | 19 | 52.89106666259766 | 0.0077333292643260165 | 0 | 2 | 0 | 1 | 1 | REVIEW | No |
| 54 | uuid:247b3a9d-310a-47a7-8cca-9c435a9cdd2f | Nayebare Christine | Bushenyi | Rwentuha | Rutooma | Rutooma ward | bushenyi_rwentuha_rutooma_rutooma_ward | 35.1 | 2026-05-19 00:00:00 | 14 | 131.75658334147136 | 96.65658334147136 | 0 | 3 | 0 | 2 | 1 | REVIEW | No |
| 65 | uuid:fb35c3d3-798e-416a-b9a8-369376d34615 | Atukwase Shallon | Rubirizi | Katerera Town council | Nyakasharu | Kyakabunda | rubirizi_katerera_town_council_nyakasharu_kyakabunda | 55.35 | 2026-05-19 00:00:00 | 8 | 68.00668333333333 | 12.656683333333326 | 0 | 2 | 0 | 1 | 1 | REVIEW | No |
| 60 | uuid:8a4d03ff-d8b3-4749-8eed-b199e80f77ed | Atukwase Shallon | Rubirizi | Katerera Town council | katerera | Nyakagyezi I | rubirizi_katerera_town_council_katerera_nyakagyezi_i | 62.1 | 2026-05-19 00:00:00 | 15 | 67.17248332519532 | 5.072483325195314 | 0 | 3 | 0 | 2 | 1 | REVIEW | No |
| 68 | uuid:4df180f3-5809-4e60-98a5-2a277378818f | Atukwase Shallon | Rubirizi | Katunguru | Kisenyi | Nyamabare | rubirizi_katunguru_kisenyi_nyamabare | 87.35 | 2026-05-20 00:00:00 | 13 | 107.22198333333333 | 19.871983333333333 | 0 | 3 | 0 | 2 | 1 | REVIEW | No |
| 69 | uuid:d9b98bc1-3533-4349-a12b-a36e785e493f | Atukwase Shallon | Rubirizi | Kicwamba | Kicwamba | Katara I | rubirizi_kicwamba_kicwamba_katara_i | 58.38333333333333 | 2026-05-20 00:00:00 | 9 | 66.64765 | 8.264316666666666 | 0 | 3 | 0 | 2 | 1 | REVIEW | No |
| 71 | uuid:b8cecd9f-74bb-4ed8-b18c-bd0cda597f51 | Atukwase Shallon | Rubirizi | Kicwamba | Kicwamba | Kyesama | rubirizi_kicwamba_kicwamba_kyesama | 69.05 | 2026-05-20 00:00:00 | 11 | 73.99216665852865 | 4.942166658528649 | 0 | 2 | 0 | 1 | 1 | REVIEW | No |
| 72 | uuid:f8c0c408-5770-48bf-ae83-1db7ae081129 | Atukwase Shallon | Rubirizi | Kicwamba | Kicwamba | Mutambi IIB | rubirizi_kicwamba_kicwamba_mutambi_iib | 38.38333333333333 | 2026-05-20 00:00:00 | 8 | 40.908516662597656 | 2.5251833292643227 | 0 | 2 | 0 | 1 | 1 | REVIEW | No |
| 101 | uuid:bbf19eca-3224-43ef-af4a-72cf65fbe86e | Akankwasa Ronals | Sheema | Bugongi | Kyamurari | Rwenkurigo | sheema_bugongi_kyamurari_rwenkurigo | 29.15 | 2026-05-21 00:00:00 | 13 | 29.15003332926432 | 3.332926432264571e-05 | 0 | 2 | 0 | 1 | 1 | REVIEW | No |
| 132 | uuid:56a06269-2c70-4120-9ddc-23e58491134f | Atukwase Shallon | Sheema | Masheruka TC | Kanyegayegye | Bugarama | sheema_masheruka_tc_kanyegayegye_bugarama | 84.03333333333333 | 2026-05-21 00:00:00 | 7 | 124.70045000813802 | 40.66711667480469 | 0 | 2 | 0 | 1 | 1 | REVIEW | No |
| 131 | uuid:d722a4c7-2bfb-49ab-8858-646fb94e9475 | Atukwase Shallon | Sheema | Masheruka TC | Buringo | Mukono 1 | sheema_masheruka_tc_buringo_mukono_1 | 57.166666666666664 | 2026-05-21 00:00:00 | 10 | 63.050283329264325 | 5.88361666259766 | 0 | 2 | 0 | 1 | 1 | REVIEW | No |
| 133 | uuid:b786aa05-2d4c-4ed4-901e-ec6bfe4cac01 | Atukwase Shallon | Sheema | Masheruka TC | Kanyegayegye | Nyamabare | sheema_masheruka_tc_kanyegayegye_nyamabare | 60.88333333333333 | 2026-05-21 00:00:00 | 11 | 71.08178333740234 | 10.19845000406901 | 0 | 2 | 0 | 1 | 1 | REVIEW | No |
| 129 | uuid:6fc4e7f6-3f62-45b5-9d68-5125574a73fa | Ashabe Gina | Sheema | Masheruka sub county | Nyakambu | Migera | sheema_masheruka_sub_county_nyakambu_migera | 48.333333333333336 | 2026-05-21 00:00:00 | 8 | 48.326066662597654 | 0.007266670735681657 | 0 | 2 | 0 | 1 | 1 | REVIEW | No |
| 130 | uuid:351c6894-28fb-4dab-8acb-b2113d20e1d1 | Ashabe Gina | Sheema | Masheruka sub county | Nyakambu | Nyakambu | sheema_masheruka_sub_county_nyakambu_nyakambu | 39.43333333333333 | 2026-05-21 00:00:00 | 7 | 39.436233333333334 | 0.0029000000000038995 | 0 | 2 | 0 | 1 | 1 | REVIEW | No |
## Sheet: variable_quality
| variable | storage_type | display_format | value_label | variable_label | n_missing | n_nonmissing | pct_missing | mean | sd | min | max | n_unique |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| survey_record_id | int | %12.0g |  | Sequential row ID in imported SurveyCTO WIDE export | 0 | 133 | 0 | 67 | 38.53786017238978 | 1 | 133 | 133 |
| submission_key | str41 | %41s |  | SurveyCTO submission key / unique record ID | 0 | 133 | 0 |  |  |  |  | 133 |
| instance_id | str41 | %41s |  | SurveyCTO instance ID | 0 | 133 | 0 |  |  |  |  | 133 |
| analysis_sample | byte | %8.0g | yesno | Record belongs to consented Phase 1 baseline analysis sample | 0 | 133 | 0 | 1 | 0 | 1 | 1 | 1 |
| submissiondate_dt | double | %tc |  | Clean Stata datetime: submissiondate | 0 | 133 | 0 | 2095041015286.654 | 325712661.4675989 | 2094743631902 | 2096281387516 | 133 |
| starttime_dt | double | %tc |  | Clean Stata datetime: starttime | 0 | 133 | 0 | 2095016217269.895 | 329294067.0714585 | 2094713901265 | 2096278786696 | 133 |
| endtime_dt | double | %tc |  | Clean Stata datetime: endtime | 0 | 133 | 0 | 2095024045178.677 | 326998995.0721844 | 2094722621328 | 2096281366638 | 133 |
| interview_date | int | %td |  | Interview date from SurveyCTO start time | 0 | 133 | 0 | 24247.36842105263 | 3.816776531852354 | 24244 | 24262 | 7 |
| interview_hour | byte | %8.0g |  | Interview start hour | 0 | 133 | 0 | 11.60902255639098 | 2.902022770168812 | 6 | 19 | 14 |
| duration | int | %10.0g |  | duration | 0 | 133 | 0 | 3072.428571428572 | 2611.864672017879 | 1019 | 27704 | 132 |
| duration_min | double | %10.0g |  | Survey duration in minutes | 0 | 133 | 0 | 51.20714285714286 | 43.53107786696466 | 16.98333333333333 | 461.7333333333333 | 132 |
| enum | byte | %18.0g | enum | Enumerator Name | 0 | 133 | 0 | 7.067669172932331 | 2.499077068190298 | 3 | 11 | 8 |
| consent | byte | %10.0g | consent | Niki rungi kugyenda omu maisho n'okubuuzibwa oku? | 0 | 133 | 0 | 1 | 0 | 1 | 1 | 1 |
| district_scto | str8 | %9s |  | SurveyCTO selected district label | 0 | 133 | 0 |  |  |  |  | 3 |
| subcounty_scto | str23 | %23s |  | SurveyCTO selected subcounty label | 0 | 133 | 0 |  |  |  |  | 36 |
| parish_scto | str15 | %15s |  | SurveyCTO selected parish label | 0 | 133 | 0 |  |  |  |  | 65 |
| village_scto | str15 | %15s |  | SurveyCTO selected village label | 0 | 133 | 0 |  |  |  |  | 116 |
| survey_village_uid | str56 | %56s |  | Unique village key from SurveyCTO-selected admin labels | 0 | 133 | 0 |  |  |  |  | 128 |
| survey_village_id | int | %56.0g | survey_village_id | Numeric SurveyCTO-selected village ID | 0 | 133 | 0 | 64 | 36.584066742148 | 1 | 128 | 128 |
| actual_district | str8 | %9s |  | Actual district visited; updated after record-level replacement mapping | 0 | 133 | 0 |  |  |  |  | 3 |
| actual_subcounty | str23 | %23s |  | Actual subcounty/division visited; updated after record-level replacement mappin | 0 | 133 | 0 |  |  |  |  | 36 |
| actual_parish | str15 | %15s |  | Actual parish/ward visited; updated after record-level replacement mapping | 0 | 133 | 0 |  |  |  |  | 65 |
| actual_village | str15 | %15s |  | Actual village visited; updated after record-level replacement mapping | 0 | 133 | 0 |  |  |  |  | 116 |
| is_replacement_village | byte | %8.0g |  | Actual record corresponds to a replacement village | 133 | 0 | 100 |  |  |  |  | 0 |
| prior_cdfu_fhri_training | byte | %8.0g | yesno | Respondent reports prior CDFU/FHRI training before/at baseline | 1 | 132 | 0.7518796992481203 | 0.3106060606060606 | 0.4645045913474226 | 0 | 1 | 2 |
| n_prior_training_topics | byte | %9.0g |  | Number of prior CDFU/FHRI training topics reported | 92 | 41 | 69.17293233082707 | 2.780487804878049 | 1.457947103326304 | 1 | 7 | 7 |
| rating_cdfu_training_clean | byte | %9.0g |  | Training usefulness rating, cleaned; only if prior CDFU/FHRI training reported | 92 | 41 | 69.17293233082707 | 3.585365853658537 | 0.9993900578877489 | 2 | 5 | 4 |
| idx_respondent_capacity | float | %9.0g |  | Index: respondent LC/LCC capacity and prior experience, 0-1 | 0 | 133 | 0 | 0.6419620487026703 | 0.1035901260377948 | 0.3095238208770752 | 0.8523809313774109 | 83 |
| idx_institutional_functioning | float | %9.0g |  | Index: LCC institutional functioning, 0-1 | 0 | 133 | 0 | 0.8057845548579567 | 0.1569253316829283 | 0 | 1 | 38 |
| idx_legal_classif_knowledge | float | %9.0g |  | Index: legal mandate, classification, referral, and procedure knowledge, 0-1 | 0 | 133 | 0 | 0.6780701783814824 | 0.1366141648095026 | 0.4229166507720947 | 0.9263889193534851 | 116 |
| idx_adr_mediation_practice | float | %9.0g |  | Index: ADR/mediation practice quality and confidence, 0-1 | 0 | 133 | 0 | 0.6649931668675035 | 0.1759290923948351 | 0.119999997317791 | 0.9363636374473572 | 71 |
| idx_referral_practice | float | %9.0g |  | Index: referral practice, coordination, and documentation, 0-1 | 0 | 133 | 0 | 0.651697695591396 | 0.1507594978470225 | 0.2222222238779068 | 0.9444444179534912 | 43 |
| idx_record_quality | float | %9.0g |  | Index: LCC record-keeping and case-management quality, 0-1 | 0 | 133 | 0 | 0.5987906934119257 | 0.2142513467104656 | 0 | 0.9166666865348816 | 74 |
| idx_committee_functioning | float | %9.0g |  | Index: LCC committee sitting and collective decision-making, 0-1 | 0 | 133 | 0 | 0.75157378221813 | 0.1110306932636813 | 0.4650000035762787 | 0.9508333206176758 | 70 |
| idx_perceived_legitimacy | float | %9.0g |  | Index: perceived LCC fairness, legitimacy, and low bypass/corruption risk, 0-1 | 0 | 133 | 0 | 0.5945488723148977 | 0.1323195559573269 | 0.25 | 1 | 19 |
| idx_safeguards | float | %9.0g |  | Index: sensitive-case safeguards and referral knowledge, 0-1 | 0 | 133 | 0 | 0.6533521365626414 | 0.2008508284583844 | 0.1770833283662796 | 0.9965277910232544 | 49 |
| idx_reintegration_norms | float | %9.0g |  | Index: pro-reintegration attitudes, willingness, and perceived support capacity, | 0 | 133 | 0 | 0.6072923762905866 | 0.1053958201017429 | 0.28125 | 0.8020833134651184 | 42 |
| idx_lcc_operational_capacity | float | %9.0g |  | Composite index: LCC operational capacity, 0-1 | 0 | 133 | 0 | 0.7187163462316183 | 0.1245018552300284 | 0.1583333313465118 | 0.944444477558136 | 125 |
| idx_lcc_case_handling_quality | float | %9.0g |  | Composite index: LCC case-handling quality, 0-1 | 0 | 133 | 0 | 0.6620282954291293 | 0.1213194380957595 | 0.4048264026641846 | 0.9256786704063416 | 133 |
| idx_lcc_legitimacy_and_norms | float | %9.0g |  | Composite index: perceived legitimacy and reintegration norms, 0-1 | 0 | 133 | 0 | 0.6009206247508974 | 0.106372262616266 | 0.3072916865348816 | 0.8333333730697632 | 86 |
| idx_p1_base_mentor_ready_proxy | float | %9.0g |  | Baseline proxy index for potential mentor readiness, 0-1 | 0 | 133 | 0 | 0.6559068273780937 | 0.0753310319968982 | 0.4165043234825134 | 0.8363132476806641 | 133 |
| high_mentor_readiness_proxy | byte | %8.0g | yesno | Baseline mentor-readiness proxy index >= 0.75 | 0 | 133 | 0 | 0.1203007518796992 | 0.3265428178560505 | 0 | 1 | 2 |
| n_inconsistency_flags | byte | %9.0g |  | Number of automated data-quality/inconsistency flags | 0 | 133 | 0 | 0.1954887218045113 | 0.4839647904883627 | 0 | 2 | 3 |
| flag_any_data_quality_issue | byte | %8.0g | yesno | Record has at least one automated data-quality/inconsistency flag | 0 | 133 | 0 | 0.1578947368421053 | 0.3660208899312015 | 0 | 1 | 2 |
| n_missing_core_indices | byte | %9.0g |  | Number of missing main module indices | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| submissiondate | double | %tc |  | Date/time submitted | 0 | 133 | 0 | 2095041015286.654 | 325712661.4675989 | 2094743631902 | 2096281387516 | 133 |
| starttime | double | %tc |  | starttime | 0 | 133 | 0 | 2095016217269.895 | 329294067.0714585 | 2094713901265 | 2096278786696 | 133 |
| endtime | double | %tc |  | endtime | 0 | 133 | 0 | 2095024045178.677 | 326998995.0721844 | 2094722621328 | 2096281366638 | 133 |
| caseid | byte | %10.0g |  | caseid | 133 | 0 | 100 |  |  |  |  | 0 |
| attend_cdfu_training | byte | %10.0g | attend_cdfu_training | Orabeireho omu kutendekwa kwona okwakozirwe ekitongore kya Communication for Dev | 1 | 132 | 0.7518796992481203 | 0.3106060606060606 | 0.4645045913474226 | 0 | 1 | 2 |
| topics_trained | str13 | %13s |  | Okutendekwa okwahwire kukaba nikukwata ahari nshonga ki? Select all that apply. | 92 | 41 | 69.17293233082707 |  |  |  |  | 18 |
| topics_trained_1 | byte | %10.0g |  | Topics_Trained_1 | 92 | 41 | 69.17293233082707 | 0.6341463414634146 | 0.4876524151983465 | 0 | 1 | 2 |
| topics_trained_2 | byte | %10.0g |  | Topics_Trained_2 | 92 | 41 | 69.17293233082707 | 0.9024390243902439 | 0.3004062290283349 | 0 | 1 | 2 |
| topics_trained_3 | byte | %10.0g |  | Topics_Trained_3 | 92 | 41 | 69.17293233082707 | 0.5609756097560976 | 0.5024331043932554 | 0 | 1 | 2 |
| topics_trained_4 | byte | %10.0g |  | Topics_Trained_4 | 92 | 41 | 69.17293233082707 | 0.3414634146341464 | 0.4800914547021731 | 0 | 1 | 2 |
| topics_trained_5 | byte | %10.0g |  | Topics_Trained_5 | 92 | 41 | 69.17293233082707 | 0.1219512195121951 | 0.3312945782245397 | 0 | 1 | 2 |
| topics_trained_6 | byte | %10.0g |  | Topics_Trained_6 | 92 | 41 | 69.17293233082707 | 0.0975609756097561 | 0.3004062290283349 | 0 | 1 | 2 |
| topics_trained_7 | byte | %10.0g |  | Topics_Trained_7 | 92 | 41 | 69.17293233082707 | 0.1219512195121951 | 0.3312945782245397 | 0 | 1 | 2 |
| topics_trained_98 | byte | %10.0g |  | Topics_Trained_98 | 92 | 41 | 69.17293233082707 | 0 | 0 | 0 | 0 | 1 |
| other_training | byte | %10.0g |  | Other Specify other training areas | 133 | 0 | 100 |  |  |  |  | 0 |
| rating_cdfu_training | byte | %10.0g |  | Aha rurengo rwa 1-5, 1 eri kubarirwa ahansi kandi 5 eri ahaiguru, no renga ota o | 68 | 65 | 51.12781954887217 | 3.369230769230769 | 1.153381316624498 | 0 | 5 | 5 |
| m0_q20 | byte | %10.0g | m0_q20 | Observe: Are any LCC records, case books, registers, or proceedings books physic | 1 | 132 | 0.7518796992481203 | 0.8636363636363636 | 0.3444816278846155 | 0 | 1 | 2 |
| m0_q04 | byte | %10.0g | m0_q04 | District | 0 | 133 | 0 | 1.857142857142857 | 0.8178209882554793 | 1 | 3 | 3 |
| m0_q05 | int | %23.0g | m0_q05 | Sub-county / division | 0 | 133 | 0 | 44.96240601503759 | 34.43007978740735 | 1 | 121 | 72 |
| m0_q06 | int | %15.0g | m0_q06 | Parish / ward | 0 | 133 | 0 | 54.76691729323309 | 38.6518820777488 | 1 | 126 | 79 |
| m0_q07 | int | %15.0g | m0_q07 | Village / LCC catchment name | 0 | 133 | 0 | 62.15037593984962 | 38.32427354874997 | 1 | 128 | 116 |
| m1_q04 | byte | %10.0g |  | omazire emyaka engahi omu nteebe ya lc1 | 0 | 133 | 0 | 16.92481203007519 | 11.05812745131612 | 1 | 42 | 31 |
| m1_q06 | byte | %31.0g | m1_q06 | Ori wa buhangwa ki? | 0 | 133 | 0 | 1.857142857142857 | 8.406475549767046 | 1 | 98 | 3 |
| m1_q07 | byte | %17.0g | m1_q07 | Oine emyaka engahi? | 0 | 133 | 0 | 4.887218045112782 | 0.9016326549767327 | 3 | 6 | 4 |
| m1_q08 | byte | %54.0g | m1_q08 | Oine obwegyese ki obuwakomire ho? | 0 | 133 | 0 | 2.398496240601504 | 1.236685756759011 | 0 | 6 | 7 |
| other_education | byte | %10.0g |  | Specify other Education levels | 133 | 0 | 100 |  |  |  |  | 0 |
| m1_q09 | byte | %22.0g | m1_q09 | No ye kakaasa ota mu ota (Confident) omu kushoma n'okuhandiika emishango ya koot | 0 | 133 | 0 | 2.541353383458647 | 0.8484502645687599 | 1 | 4 | 4 |
| m1_q10 | str5 | %9s |  | Ni rurimi ki orwo'kubasa kuhandika ebihandiiko bya LCC. Select all that apply. | 0 | 133 | 0 |  |  |  |  | 6 |
| m1_q10_1 | byte | %10.0g |  | M1_Q10_1 | 0 | 133 | 0 | 0.2180451127819549 | 0.414479335023521 | 0 | 1 | 2 |
| m1_q10_2 | byte | %10.0g |  | M1_Q10_2 | 0 | 133 | 0 | 0.9699248120300752 | 0.1714399631667259 | 0 | 1 | 2 |
| m1_q10_3 | byte | %10.0g |  | M1_Q10_3 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m1_q10_4 | byte | %10.0g |  | M1_Q10_4 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m1_q10_95 | byte | %10.0g |  | M1_Q10_95 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m1_q10_98 | byte | %10.0g |  | M1_Q10_98 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m1_q10_other | byte | %10.0g |  | Specify other other language they record court cases | 133 | 0 | 100 |  |  |  |  | 0 |
| m1_q11 | byte | %29.0g | m1_q11 | Waratungire ho okutendekwa kwona aha by'oburingaaniza, okushuganisa, Okushare em | 0 | 133 | 0 | 2.218045112781955 | 11.88731074530843 | 0 | 98 | 3 |
| m1_q13 | byte | %10.0g | m1_q13 | Warakozi ho hamwe n'abakozi b'ebiragiro nka pooriisi, kooti, abarikureeberera em | 0 | 133 | 0 | 0.9548872180451128 | 0.2083361813430304 | 0 | 1 | 2 |
| m1_q14 | str15 | %15s |  | Ni nshonga ki aha ziri ahaifo ezi orakozireho nari ezi orakoziremu nk'omwebembez | 0 | 133 | 0 |  |  |  |  | 43 |
| m1_q14_1 | byte | %10.0g |  | M1_Q14_1 | 0 | 133 | 0 | 0.8195488721804511 | 0.3860166911559539 | 0 | 1 | 2 |
| m1_q14_2 | byte | %10.0g |  | M1_Q14_2 | 0 | 133 | 0 | 0.7518796992481203 | 0.43355498476206 | 0 | 1 | 2 |
| m1_q14_3 | byte | %10.0g |  | M1_Q14_3 | 0 | 133 | 0 | 0.7368421052631579 | 0.4420122177473814 | 0 | 1 | 2 |
| m1_q14_4 | byte | %10.0g |  | M1_Q14_4 | 0 | 133 | 0 | 0.4360902255639098 | 0.4977735803075746 | 0 | 1 | 2 |
| m1_q14_5 | byte | %10.0g |  | M1_Q14_5 | 0 | 133 | 0 | 0.2706766917293233 | 0.445989189107868 | 0 | 1 | 2 |
| m1_q14_6 | byte | %10.0g |  | M1_Q14_6 | 0 | 133 | 0 | 0.1578947368421053 | 0.3660208899312015 | 0 | 1 | 2 |
| m1_q14_7 | byte | %10.0g |  | M1_Q14_7 | 0 | 133 | 0 | 0.075187969924812 | 0.2646913625903545 | 0 | 1 | 2 |
| m1_q14_8 | byte | %10.0g |  | M1_Q14_8 | 0 | 133 | 0 | 0.0225563909774436 | 0.149045722775883 | 0 | 1 | 2 |
| m1_q14_95 | byte | %10.0g |  | M1_Q14_95 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m1_q14_98 | byte | %10.0g |  | M1_Q14_98 | 0 | 133 | 0 | 0.0225563909774436 | 0.149045722775883 | 0 | 1 | 2 |
| m1_q14_specify | str16 | %16s |  | specify other cases or disputes | 132 | 1 | 99.24812030075188 |  |  |  |  | 1 |
| m1_q14_other | byte | %10.0g |  | Specify other cases handled since January 2025 | 133 | 0 | 100 |  |  |  |  | 0 |
| m1_q15 | byte | %16.0g | m1_q15 | Omu sande eya buriijo, noomara obwire burikwingana ki aha mirimo ya Local Counci | 0 | 133 | 0 | 1.097744360902256 | 0.3866064801800431 | 0 | 3 | 4 |
| m2_q01 | byte | %10.0g |  | Ni abantu bangahi abari memba ba kooti ya Local Council obwahati abarikukora aha | 0 | 133 | 0 | 9.210526315789474 | 2.153406855317756 | 5 | 11 | 7 |
| m2_q03 | byte | %11.0g | m2_q03 | Hariho emyanya etarimu bantu omu kooti ya Local Council nainga akakiiko ka LC? | 0 | 133 | 0 | 0.6842105263157895 | 0.4665869150354483 | 0 | 1 | 2 |
| m2_q04 | byte | %10.0g |  | Ni emyanya engahi eriho obwahati etarimu bantu? | 133 | 0 | 100 |  |  |  |  | 0 |
| m2_q05 | byte | %10.0g |  | Ni abakazi bangahi abari ba memba ba kooti y'ekyaro abarikukora aha mishango | 1 | 132 | 0.7518796992481203 | 3.272727272727273 | 1.254554506197922 | 1 | 9 | 7 |
| m2_q06 | byte | %10.0g |  | Ni mirundi engahi ei waashutamiire omu kooti y'ekyaro okukora aha mishango omu k | 0 | 133 | 0 | 5.142857142857143 | 6.919606374711814 | 0 | 47 | 18 |
| m2_q07 | byte | %33.0g | m2_q07 | Kooti y'ekyaro kyaawe neekunda ku shitama emirundi eingahi okukora aha mishango? | 0 | 133 | 0 | 3.338345864661654 | 1.664637634810946 | 1 | 6 | 6 |
| m2_q08 | byte | %28.0g | m2_q08 | Kooti y'ekyaro ku yaba ne kora aha mishango, nekiragiro ngu abantu abarikwetengw | 0 | 133 | 0 | 1.390977443609023 | 0.6835134995249247 | 1 | 4 | 4 |
| m2_q09 | byte | %40.0g | m2_q09 | Kooti ya LC ya nyu eine omwanya gwayo gwetogwire ogu eri kushariraho emishango? | 0 | 133 | 0 | 1.203007518796992 | 0.4886499412611799 | 1 | 3 | 3 |
| m2_q12 | byte | %56.0g | m2_q12 | Kooti ya LC eine ekitabo ekyerikuhandika emishango?? | 0 | 133 | 0 | 1.293233082706767 | 0.5042539476749072 | 1 | 3 | 3 |
| m2_q13 | byte | %42.0g | m2_q13 | Ebihandiiko bya LC ebirikukwata aha mishango byagire omukitabo obwahati (up to d | 0 | 133 | 0 | 2.714285714285714 | 11.8299641566681 | 1 | 98 | 4 |
| m2_q14 | byte | %80.0g | m2_q14 | Kooti ya LC eine eby'okukoresa ebirikwetengwa kuhurira emishango n'okukora ebiha | 3 | 130 | 2.255639097744361 | 1.623076923076923 | 0.6133575738643942 | 1 | 3 | 3 |
| m2_q15 | str11 | %11s |  | Ni bintu ki ebirikuburaho nari ebitarikumara? select all that apply. | 61 | 72 | 45.86466165413533 |  |  |  |  | 29 |
| m2_q15_1 | byte | %10.0g |  | M2_Q15_1 | 61 | 72 | 45.86466165413533 | 0.6111111111111112 | 0.4909191022411197 | 0 | 1 | 2 |
| m2_q15_2 | byte | %10.0g |  | M2_Q15_2 | 61 | 72 | 45.86466165413533 | 0.375 | 0.4875203137696194 | 0 | 1 | 2 |
| m2_q15_3 | byte | %10.0g |  | M2_Q15_3 | 61 | 72 | 45.86466165413533 | 0.7222222222222222 | 0.4510464272103455 | 0 | 1 | 2 |
| m2_q15_4 | byte | %10.0g |  | M2_Q15_4 | 61 | 72 | 45.86466165413533 | 0.7638888888888888 | 0.4276715718818954 | 0 | 1 | 2 |
| m2_q15_5 | byte | %10.0g |  | M2_Q15_5 | 61 | 72 | 45.86466165413533 | 0.2638888888888889 | 0.4438327167280311 | 0 | 1 | 2 |
| m2_q15_6 | byte | %10.0g |  | M2_Q15_6 | 61 | 72 | 45.86466165413533 | 0.2638888888888889 | 0.4438327167280311 | 0 | 1 | 2 |
| m2_q15_98 | byte | %10.0g |  | M2_Q15_98 | 61 | 72 | 45.86466165413533 | 0.0277777777777778 | 0.1654887956057706 | 0 | 1 | 2 |
| m2_q15_specify | str22 | %22s |  | Specify other materials missing or insufficient | 132 | 1 | 99.24812030075188 |  |  |  |  | 1 |
| m2_q16 | byte | %35.0g | m2_q16 | Enumerator verification: Did you see a case register, case book, or other writte | 19 | 114 | 14.28571428571428 | 1.12280701754386 | 0.5344809884644769 | 0 | 2 | 3 |
| m2_q17 | byte | %30.0g | m2_q17 | Enumerator verification: Based on the records seen, do the most recent entries a | 27 | 106 | 20.30075187969925 | 1.150943396226415 | 0.4318829830535268 | 1 | 3 | 3 |
| m2_q18 | str144 | %144s |  | Enumerator notes on LCC institutional set-up or records | 32 | 101 | 24.06015037593985 |  |  |  |  | 93 |
| m3_q02 | byte | %10.0g |  | Omubiro 30 ebihingwire, otungire emishango engahi omu Kooti yaawe? | 0 | 133 | 0 | 1.233082706766917 | 2.865381718833098 | 0 | 30 | 8 |
| m3_q03 | byte | %10.0g |  | Omu myeezi eshatu ehingwire, Kooti y'Ekyaro etungire emishango engahi? | 0 | 133 | 0 | 2.684210526315789 | 5.645282853923039 | 0 | 60 | 12 |
| m3_q04 | str11 | %11s |  | Ni miringo ki y'emishango eyi Kooti etungire omu myeezi eshatu ehingwire?select  | 37 | 96 | 27.81954887218045 |  |  |  |  | 40 |
| m3_q04_1 | byte | %10.0g |  | M3_Q04_1 | 37 | 96 | 27.81954887218045 | 0.6979166666666666 | 0.4615714956689105 | 0 | 1 | 2 |
| m3_q04_2 | byte | %10.0g |  | M3_Q04_2 | 37 | 96 | 27.81954887218045 | 0.5833333333333334 | 0.4955946277833521 | 0 | 1 | 2 |
| m3_q04_3 | byte | %10.0g |  | M3_Q04_3 | 37 | 96 | 27.81954887218045 | 0.6354166666666666 | 0.4838397226282506 | 0 | 1 | 2 |
| m3_q04_4 | byte | %10.0g |  | M3_Q04_4 | 37 | 96 | 27.81954887218045 | 0.3541666666666667 | 0.480770580295002 | 0 | 1 | 2 |
| m3_q04_5 | byte | %10.0g |  | M3_Q04_5 | 37 | 96 | 27.81954887218045 | 0.1666666666666667 | 0.3746343246326776 | 0 | 1 | 2 |
| m3_q04_6 | byte | %10.0g |  | M3_Q04_6 | 37 | 96 | 27.81954887218045 | 0.1875 | 0.3923612728354477 | 0 | 1 | 2 |
| m3_q04_7 | byte | %10.0g |  | M3_Q04_7 | 37 | 96 | 27.81954887218045 | 0.03125 | 0.1749059897863932 | 0 | 1 | 2 |
| m3_q04_8 | byte | %10.0g |  | M3_Q04_8 | 37 | 96 | 27.81954887218045 | 0.03125 | 0.1749059897863932 | 0 | 1 | 2 |
| m3_q04_9 | byte | %10.0g |  | M3_Q04_9 | 37 | 96 | 27.81954887218045 | 0.0208333333333333 | 0.143575886163796 | 0 | 1 | 2 |
| m3_q04_10 | byte | %10.0g |  | M3_Q04_10 | 37 | 96 | 27.81954887218045 | 0 | 0 | 0 | 0 | 1 |
| m3_q04_98 | byte | %10.0g |  | M3_Q04_98 | 37 | 96 | 27.81954887218045 | 0 | 0 | 0 | 0 | 1 |
| m3_q05 | byte | %66.0g | m3_q05 | Ni muringo ki gw'omushango ogukirizeyo munonga kuhababirwa omu myeezi eshatu ehi | 37 | 96 | 27.81954887218045 | 2.947916666666667 | 1.825952046794489 | 1 | 9 | 9 |
| m3_q06 | byte | %23.0g | m3_q06 | Watekateeka aha mishango eyi otungire omu mwezi eshatu ehingwire, emishango emik | 37 | 96 | 27.81954887218045 | 3.010416666666667 | 1.657485677745007 | 1 | 5 | 5 |
| m3_q08 | byte | %10.0g |  | Nemishango engahi etakakozirweho omu Kooti yaawe? | 0 | 133 | 0 | 0.3233082706766917 | 0.7542693854084302 | 0 | 5 | 5 |
| m3_q09 | byte | %10.0g |  | Aha mishango eyi otungire omu myezi eshatu ehingwire, ni emishango engahi eresir | 38 | 95 | 28.57142857142857 | 0.2315789473684211 | 0.5147325597460394 | 0 | 2 | 3 |
| m3_q14 | byte | %17.0g | m3_q14 | Ku orikugyeragyeranisa obwiire obwenyima y'emyeezi eshatu ehingwire na hati, ena | 0 | 133 | 0 | 2.729323308270676 | 0.6170287988572944 | 1 | 3 | 3 |
| m3_q15 | str5 | %9s |  | Notekateeka nikintu ki ekyareetsire enamba y'emishango omu Kooti yaawe kweyongir | 121 | 12 | 90.97744360902256 |  |  |  |  | 7 |
| m3_q15_1 | byte | %10.0g |  | M3_Q15_1 | 121 | 12 | 90.97744360902256 | 0.8333333333333334 | 0.3892494720807615 | 0 | 1 | 2 |
| m3_q15_2 | byte | %10.0g |  | M3_Q15_2 | 121 | 12 | 90.97744360902256 | 0.1666666666666667 | 0.3892494720807615 | 0 | 1 | 2 |
| m3_q15_3 | byte | %10.0g |  | M3_Q15_3 | 121 | 12 | 90.97744360902256 | 0.25 | 0.4522670168666454 | 0 | 1 | 2 |
| m3_q15_4 | byte | %10.0g |  | M3_Q15_4 | 121 | 12 | 90.97744360902256 | 0 | 0 | 0 | 0 | 1 |
| m3_q15_5 | byte | %10.0g |  | M3_Q15_5 | 121 | 12 | 90.97744360902256 | 0 | 0 | 0 | 0 | 1 |
| m3_q15_6 | byte | %10.0g |  | M3_Q15_6 | 121 | 12 | 90.97744360902256 | 0.0833333333333333 | 0.2886751345948129 | 0 | 1 | 2 |
| m3_q15_7 | byte | %10.0g |  | M3_Q15_7 | 121 | 12 | 90.97744360902256 | 0.1666666666666667 | 0.3892494720807615 | 0 | 1 | 2 |
| m3_q15_98 | byte | %10.0g |  | M3_Q15_98 | 121 | 12 | 90.97744360902256 | 0.0833333333333333 | 0.2886751345948129 | 0 | 1 | 2 |
| m3_q16 | byte | %10.0g |  | Notekateeka ni kintu ki ekyareetsire enamba y'emishango omu Kooti yaawe yakyende | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q16_1 | byte | %10.0g |  | M3_Q16_1 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q16_2 | byte | %10.0g |  | M3_Q16_2 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q16_3 | byte | %10.0g |  | M3_Q16_3 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q16_4 | byte | %10.0g |  | M3_Q16_4 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q16_5 | byte | %10.0g |  | M3_Q16_5 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q16_6 | byte | %10.0g |  | M3_Q16_6 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q16_7 | byte | %10.0g |  | M3_Q16_7 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q16_98 | byte | %10.0g |  | M3_Q16_98 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q17 | byte | %20.0g | m3_q17 | Omuri byona, Noyekakasa ota ngu ebiwangambira ebikukwata aha mishango eyibahabah | 0 | 133 | 0 | 3.714285714285714 | 0.7544959040737526 | 1 | 5 | 5 |
| m3_q18 | str163 | %163s |  | Enumerator notes on recent caseload and case mix | 3 | 130 | 2.255639097744361 |  |  |  |  | 114 |
| m4_q01 | str13 | %13s |  | Ni mishango ki eyi kooti ya LC1 eshemerire kukoraho kandi ekagihendera?Select al | 0 | 133 | 0 |  |  |  |  | 34 |
| m4_q01_1 | byte | %10.0g |  | M4_Q01_1 | 0 | 133 | 0 | 0.8195488721804511 | 0.3860166911559539 | 0 | 1 | 2 |
| m4_q01_2 | byte | %10.0g |  | M4_Q01_2 | 0 | 133 | 0 | 0.7443609022556391 | 0.4378690709655921 | 0 | 1 | 2 |
| m4_q01_3 | byte | %10.0g |  | M4_Q01_3 | 0 | 133 | 0 | 0.7744360902255639 | 0.4195333149155044 | 0 | 1 | 2 |
| m4_q01_4 | byte | %10.0g |  | M4_Q01_4 | 0 | 133 | 0 | 0.4511278195488722 | 0.4994870916755633 | 0 | 1 | 2 |
| m4_q01_5 | byte | %10.0g |  | M4_Q01_5 | 0 | 133 | 0 | 0.3909774436090225 | 0.4898142267840758 | 0 | 1 | 2 |
| m4_q01_6 | byte | %10.0g |  | M4_Q01_6 | 0 | 133 | 0 | 0.1879699248120301 | 0.3921652392120015 | 0 | 1 | 2 |
| m4_q01_7 | byte | %10.0g |  | M4_Q01_7 | 0 | 133 | 0 | 0.0300751879699248 | 0.1714399631667259 | 0 | 1 | 2 |
| m4_q01_8 | byte | %10.0g |  | M4_Q01_8 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m4_q01_9 | byte | %10.0g |  | M4_Q01_9 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m4_q01_10 | byte | %10.0g |  | M4_Q01_10 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m4_q01_98 | byte | %10.0g |  | M4_Q01_98 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m4_q02 | str13 | %13s |  | Ni mishango ki eyi oshemereire kwohereza omubanyamateka abandi okukira okungekor | 0 | 133 | 0 |  |  |  |  | 36 |
| m4_q02_1 | byte | %10.0g |  | M4_Q02_1 | 0 | 133 | 0 | 0.7669172932330827 | 0.4243929362276081 | 0 | 1 | 2 |
| m4_q02_2 | byte | %10.0g |  | M4_Q02_2 | 0 | 133 | 0 | 0.7593984962406015 | 0.4290648029718084 | 0 | 1 | 2 |
| m4_q02_3 | byte | %10.0g |  | M4_Q02_3 | 0 | 133 | 0 | 0.6466165413533834 | 0.4798277582665458 | 0 | 1 | 2 |
| m4_q02_4 | byte | %10.0g |  | M4_Q02_4 | 0 | 133 | 0 | 0.706766917293233 | 0.4569655329356718 | 0 | 1 | 2 |
| m4_q02_5 | byte | %10.0g |  | M4_Q02_5 | 0 | 133 | 0 | 0.4135338345864661 | 0.4943287390549321 | 0 | 1 | 2 |
| m4_q02_6 | byte | %10.0g |  | M4_Q02_6 | 0 | 133 | 0 | 0.0902255639097744 | 0.2875878420888012 | 0 | 1 | 2 |
| m4_q02_7 | byte | %10.0g |  | M4_Q02_7 | 0 | 133 | 0 | 0.0451127819548872 | 0.2083361813430304 | 0 | 1 | 2 |
| m4_q02_8 | byte | %10.0g |  | M4_Q02_8 | 0 | 133 | 0 | 0.0300751879699248 | 0.1714399631667259 | 0 | 1 | 2 |
| m4_q02_98 | byte | %10.0g |  | M4_Q02_98 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m4_q04 | byte | %62.0g | m4_q04 | Omushango gwaba guri aheeru y'obushoboorozi bwa Kooti y'Ekyaro, niki eki court y | 0 | 133 | 0 | 2.962406015037594 | 11.7984372456679 | 1 | 98 | 4 |
| m4_q05 | str11 | %11s |  | Nebiki ebishemerirwe kuhandikwa kooti LC yaba neyakyiira ninga nesharamu emishan | 0 | 133 | 0 |  |  |  |  | 23 |
| m4_q05_1 | byte | %10.0g |  | M4_Q05_1 | 0 | 133 | 0 | 0.9473684210526315 | 0.2241411038827122 | 0 | 1 | 2 |
| m4_q05_2 | byte | %10.0g |  | M4_Q05_2 | 0 | 133 | 0 | 0.8721804511278195 | 0.3351511155001681 | 0 | 1 | 2 |
| m4_q05_3 | byte | %10.0g |  | M4_Q05_3 | 0 | 133 | 0 | 0.7894736842105263 | 0.4092237955355674 | 0 | 1 | 2 |
| m4_q05_4 | byte | %10.0g |  | M4_Q05_4 | 0 | 133 | 0 | 0.4060150375939849 | 0.4929440619958883 | 0 | 1 | 2 |
| m4_q05_5 | byte | %10.0g |  | M4_Q05_5 | 0 | 133 | 0 | 0.1954887218045113 | 0.398075800162317 | 0 | 1 | 2 |
| m4_q05_6 | byte | %10.0g |  | M4_Q05_6 | 0 | 133 | 0 | 0.1503759398496241 | 0.3587909115412519 | 0 | 1 | 2 |
| m4_q05_7 | byte | %10.0g |  | M4_Q05_7 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m4_q05_98 | byte | %10.0g |  | M4_Q05_98 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m4_q06 | str11 | %11s |  | Nimitendera ki Kooti z'ebyaro zishemereire kubanza kukora ki zitakacwiremu omush | 0 | 133 | 0 |  |  |  |  | 24 |
| m4_q06_1 | byte | %10.0g |  | M4_Q06_1 | 0 | 133 | 0 | 0.9398496240601504 | 0.2386641642064697 | 0 | 1 | 2 |
| m4_q06_2 | byte | %10.0g |  | M4_Q06_2 | 0 | 133 | 0 | 0.706766917293233 | 0.4569655329356718 | 0 | 1 | 2 |
| m4_q06_3 | byte | %10.0g |  | M4_Q06_3 | 0 | 133 | 0 | 0.5112781954887218 | 0.5017626710722586 | 0 | 1 | 2 |
| m4_q06_4 | byte | %10.0g |  | M4_Q06_4 | 0 | 133 | 0 | 0.4210526315789473 | 0.4955946277833521 | 0 | 1 | 2 |
| m4_q06_5 | byte | %10.0g |  | M4_Q06_5 | 0 | 133 | 0 | 0.1578947368421053 | 0.3660208899312015 | 0 | 1 | 2 |
| m4_q06_6 | byte | %10.0g |  | M4_Q06_6 | 0 | 133 | 0 | 0.0300751879699248 | 0.1714399631667259 | 0 | 1 | 2 |
| m4_q06_7 | byte | %10.0g |  | M4_Q06_7 | 0 | 133 | 0 | 0.0225563909774436 | 0.149045722775883 | 0 | 1 | 2 |
| m4_q06_98 | byte | %10.0g |  | M4_Q06_98 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m4_q07 | byte | %79.0g | m4_q07 | Nogira ngu niryari obu kooti yakukozesa omuringo ogundi gw'omaririza omushango e | 0 | 133 | 0 | 1.240601503759398 | 0.4290648029718084 | 1 | 2 | 2 |
| m4_q08 | str11 | %11s |  | Ni mbeera ki eyi Kooti eza baramuzi, Police, hamwe nezindi Kooti neinga abantun  | 0 | 133 | 0 |  |  |  |  | 15 |
| m4_q08_1 | byte | %10.0g |  | M4_Q08_1 | 0 | 133 | 0 | 0.9473684210526315 | 0.2241411038827122 | 0 | 1 | 2 |
| m4_q08_2 | byte | %10.0g |  | M4_Q08_2 | 0 | 133 | 0 | 0.8345864661654135 | 0.372958100007095 | 0 | 1 | 2 |
| m4_q08_3 | byte | %10.0g |  | M4_Q08_3 | 0 | 133 | 0 | 0.5939849624060151 | 0.4929440619958883 | 0 | 1 | 2 |
| m4_q08_4 | byte | %10.0g |  | M4_Q08_4 | 0 | 133 | 0 | 0.1879699248120301 | 0.3921652392120015 | 0 | 1 | 2 |
| m4_q08_5 | byte | %10.0g |  | M4_Q08_5 | 0 | 133 | 0 | 0.0451127819548872 | 0.2083361813430304 | 0 | 1 | 2 |
| m4_q08_6 | byte | %10.0g |  | M4_Q08_6 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m4_q08_7 | byte | %10.0g |  | M4_Q08_7 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m4_q08_98 | byte | %10.0g |  | M4_Q08_98 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m4_q10 | byte | %20.0g | m4_q10 | Oye kakaasa ekikwinganaki omu kumanya gye emishango ei kooti y'ebyaro erikubaasa | 0 | 133 | 0 | 2.451127819548872 | 0.856933976219287 | 0 | 4 | 5 |
| m4_v01_q1 | byte | %72.0g | m4_v01_q1 | Omuri ryo'kureberaho ki, Kooti y'Ekyaro neebaasa kukora aha mushango ogu egumare | 0 | 133 | 0 | 1.037593984962406 | 0.2271701750855374 | 1 | 3 | 3 |
| m4_v01_q2 | byte | %79.0g | m4_v01_q2 | Kooti y'Ekyaro eshemereire kubanza kukora ki omuri eki? | 0 | 133 | 0 | 1.090225563909774 | 0.4344736735153228 | 1 | 4 | 4 |
| m4_v01_q3 | str5 | %9s |  | Ni bobushoborozi ki abandi abashemereire kubanza kwejumbira ninga kumanyisibwa o | 0 | 133 | 0 |  |  |  |  | 9 |
| m4_v01_q3_1 | byte | %10.0g |  | M4_V01_Q3_1 | 0 | 133 | 0 | 0.9323308270676691 | 0.2521269738374536 | 0 | 1 | 2 |
| m4_v01_q3_2 | byte | %10.0g |  | M4_V01_Q3_2 | 0 | 133 | 0 | 0.2406015037593985 | 0.4290648029718084 | 0 | 1 | 2 |
| m4_v01_q3_3 | byte | %10.0g |  | M4_V01_Q3_3 | 0 | 133 | 0 | 0.0225563909774436 | 0.149045722775883 | 0 | 1 | 2 |
| m4_v01_q3_4 | byte | %10.0g |  | M4_V01_Q3_4 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m4_v01_q3_5 | byte | %10.0g |  | M4_V01_Q3_5 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m4_v01_q3_6 | byte | %10.0g |  | M4_V01_Q3_6 | 0 | 133 | 0 | 0.0526315789473684 | 0.2241411038827122 | 0 | 1 | 2 |
| m4_v01_q3_98 | byte | %10.0g |  | M4_V01_Q3_98 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m4_v02_q1 | byte | %72.0g | m4_v02_q1 | Omuri kyo kureberaho ki, Kooti y'Ekyaro neebaasa kukora aha mushango ogu egumare | 0 | 133 | 0 | 1.045112781954887 | 0.2419823952441813 | 1 | 3 | 3 |
| m4_v02_q2 | byte | %80.0g | m4_v02_q2 | Kooti y'Ekyaro eshemereire kubanza kukora ki omuri eki? | 0 | 133 | 0 | 1.090225563909774 | 0.4166723626860607 | 1 | 4 | 4 |
| m4_v02_q3 | str4 | %9s |  | Ni bobushoborozi ki abandi abashemereire kubanza kwejumbira ninga kumanyisibwa o | 0 | 133 | 0 |  |  |  |  | 10 |
| m4_v02_q3_1 | byte | %10.0g |  | M4_V02_Q3_1 | 0 | 133 | 0 | 0.9398496240601504 | 0.2386641642064697 | 0 | 1 | 2 |
| m4_v02_q3_2 | byte | %10.0g |  | M4_V02_Q3_2 | 0 | 133 | 0 | 0.1654135338345865 | 0.372958100007095 | 0 | 1 | 2 |
| m4_v02_q3_3 | byte | %10.0g |  | M4_V02_Q3_3 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m4_v02_q3_4 | byte | %10.0g |  | M4_V02_Q3_4 | 0 | 133 | 0 | 0.0451127819548872 | 0.2083361813430304 | 0 | 1 | 2 |
| m4_v02_q3_5 | byte | %10.0g |  | M4_V02_Q3_5 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m4_v02_q3_6 | byte | %10.0g |  | M4_V02_Q3_6 | 0 | 133 | 0 | 0.0225563909774436 | 0.149045722775883 | 0 | 1 | 2 |
| m4_v02_q3_98 | byte | %10.0g |  | M4_V02_Q3_98 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m4_v05_q1 | byte | %80.0g | m4_v05_q1 | Omuri kyo kureberaho ki, ekyokureberaho Kooti y'Ekyaro neebaasa kukora aha musha | 0 | 133 | 0 | 1.398496240601504 | 0.5066205564752931 | 1 | 3 | 3 |
| m4_v05_q2 | byte | %80.0g | m4_v05_q2 | Kooti y'Ekyaro eshemereire kubanza kukora ki omuri eki? | 0 | 133 | 0 | 1.451127819548872 | 0.4994870916755633 | 1 | 2 | 2 |
| m4_v05_q3 | str7 | %9s |  | Ni bobushoborozi ki abandi abashemereire kubanza kwejumbira ninga kumanyisibwa o | 0 | 133 | 0 |  |  |  |  | 13 |
| m4_v05_q3_1 | byte | %10.0g |  | M4_V05_Q3_1 | 0 | 133 | 0 | 0.6616541353383458 | 0.4749356901459776 | 0 | 1 | 2 |
| m4_v05_q3_2 | byte | %10.0g |  | M4_V05_Q3_2 | 0 | 133 | 0 | 0.4360902255639098 | 0.4977735803075746 | 0 | 1 | 2 |
| m4_v05_q3_3 | byte | %10.0g |  | M4_V05_Q3_3 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m4_v05_q3_4 | byte | %10.0g |  | M4_V05_Q3_4 | 0 | 133 | 0 | 0.2406015037593985 | 0.4290648029718084 | 0 | 1 | 2 |
| m4_v05_q3_5 | byte | %10.0g |  | M4_V05_Q3_5 | 0 | 133 | 0 | 0.0827067669172932 | 0.2764798415018575 | 0 | 1 | 2 |
| m4_v05_q3_6 | byte | %10.0g |  | M4_V05_Q3_6 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m4_v05_q3_98 | byte | %10.0g |  | M4_V05_Q3_98 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m4_v06_q1 | byte | %80.0g | m4_v06_q1 | Omu ky'okureeberaho eki, kooti ya Local Council neebaasa kukora aha mushango ogu | 0 | 133 | 0 | 2.18796992481203 | 8.386632921301873 | 1 | 98 | 4 |
| m4_v06_q2 | byte | %80.0g | m4_v06_q2 | Kooti y'Ekyaro eshemereire kubanza kukora ki omuri eki? | 0 | 133 | 0 | 3.368421052631579 | 11.77920206448285 | 1 | 98 | 5 |
| m4_v06_q3 | str5 | %9s |  | Ni bobushoborozi ki abandi abashemereire kubanza kwejumbira ninga kumanyisibwa o | 0 | 133 | 0 |  |  |  |  | 11 |
| m4_v06_q3_1 | byte | %10.0g |  | M4_V06_Q3_1 | 0 | 133 | 0 | 0.5112781954887218 | 0.5017626710722586 | 0 | 1 | 2 |
| m4_v06_q3_2 | byte | %10.0g |  | M4_V06_Q3_2 | 0 | 133 | 0 | 0.5864661654135338 | 0.494328739054932 | 0 | 1 | 2 |
| m4_v06_q3_3 | byte | %10.0g |  | M4_V06_Q3_3 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m4_v06_q3_4 | byte | %10.0g |  | M4_V06_Q3_4 | 0 | 133 | 0 | 0.112781954887218 | 0.317522018762762 | 0 | 1 | 2 |
| m4_v06_q3_5 | byte | %10.0g |  | M4_V06_Q3_5 | 0 | 133 | 0 | 0.1804511278195489 | 0.3860166911559539 | 0 | 1 | 2 |
| m4_v06_q3_6 | byte | %10.0g |  | M4_V06_Q3_6 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m4_v06_q3_98 | byte | %10.0g |  | M4_V06_Q3_98 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m4_q11 | byte | %26.0g | m4_q11 | Okutwariza hamwe, kyaba kikugumira kita kusharamu eki kooti y'ebyaro eshemereire | 0 | 133 | 0 | 3.37593984962406 | 1.105094975757935 | 1 | 5 | 5 |
| m4_q12 | str221 | %221s |  | Enumerator notes on mandate, jurisdiction, and classification knowledge | 6 | 127 | 4.511278195488721 |  |  |  |  | 119 |
| m5_q01 | byte | %23.0g | m5_q01 | omushango omukye kubarikugureeta omukooti yaawe , niryari obu kooti erikubanza k | 0 | 133 | 0 | 4.172932330827067 | 11.69207921356571 | 0 | 98 | 6 |
| m5_q02 | byte | %23.0g | m5_q02 | Omu kugarukanisa, niryaari obu embaju zoona niziheebwa omugisha gw'okushoborora  | 0 | 133 | 0 | 3.022556390977444 | 1.076372734623755 | 0 | 4 | 5 |
| m5_q03 | byte | %23.0g | m5_q03 | Omu kuteisa, niburi ryari obu abantu bakwe gamba ho bataine ekirikubateganisa, b | 0 | 133 | 0 | 3.556390977443609 | 8.336133045303972 | 0 | 98 | 6 |
| m5_q06 | byte | %40.0g | m5_q06 | Obu emitendera yo kuramura kyitaka kwekuhika ahamuheru. Niryari obu ebikweikiriz | 0 | 133 | 0 | 3.360902255639098 | 8.272204595918629 | 0 | 97 | 6 |
| m5_q07 | byte | %40.0g | m5_q07 | Bwanyima y'okuhika aha ndagaano, niryari obu LCC ekukuratiriza (follow-up) okure | 0 | 133 | 0 | 2.556390977443609 | 1.214892025596255 | 0 | 4 | 5 |
| m5_q09 | byte | %20.0g | m5_q09 | Noyekakasa ota omu kushoborora entongane ezishemerire oba ezirimumateeka kushobo | 0 | 133 | 0 | 2.458646616541353 | 0.8119493770185049 | 0 | 4 | 5 |
| m5_q10 | byte | %20.0g | m5_q10 | Noyekakasa ota omu kucureeza nari okukyendeeza obutaikirizana ahagati y'abantu e | 0 | 133 | 0 | 2.541353383458647 | 0.82122670803637 | 0 | 4 | 5 |
| m5_q11 | str6 | %9s |  | Ni bintu ki ebirikuremesa okugarukanisa abantu kitaaka omu kooti z'ebyaro? Selec | 1 | 132 | 0.7518796992481203 |  |  |  |  | 29 |
| m5_q11_1 | byte | %10.0g |  | M5_Q11_1 | 0 | 133 | 0 | 0.7593984962406015 | 0.4290648029718084 | 0 | 1 | 2 |
| m5_q11_2 | byte | %10.0g |  | M5_Q11_2 | 0 | 133 | 0 | 0.4586466165413534 | 0.5001708525592321 | 0 | 1 | 2 |
| m5_q11_3 | byte | %10.0g |  | M5_Q11_3 | 0 | 133 | 0 | 0.3834586466165413 | 0.4880667569726408 | 0 | 1 | 2 |
| m5_q11_4 | byte | %10.0g |  | M5_Q11_4 | 0 | 133 | 0 | 0.1578947368421053 | 0.3660208899312015 | 0 | 1 | 2 |
| m5_q11_5 | byte | %10.0g |  | M5_Q11_5 | 0 | 133 | 0 | 0.0902255639097744 | 0.2875878420888012 | 0 | 1 | 2 |
| m5_q11_6 | byte | %10.0g |  | M5_Q11_6 | 0 | 133 | 0 | 0.0451127819548872 | 0.2083361813430304 | 0 | 1 | 2 |
| m5_q11_7 | byte | %10.0g |  | M5_Q11_7 | 0 | 133 | 0 | 0.0601503759398496 | 0.2386641642064697 | 0 | 1 | 2 |
| m5_q11_8 | byte | %10.0g |  | M5_Q11_8 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m5_q11_9 | byte | %10.0g |  | M5_Q11_9 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m5_q11_10 | byte | %10.0g |  | M5_Q11_10 | 0 | 133 | 0 | 0.1278195488721804 | 0.3351511155001681 | 0 | 1 | 2 |
| m5_q11_98 | byte | %10.0g |  | M5_Q11_98 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m5_q13 | str9 | %9s |  | Ni miringo ki ei LCC erikukozesa omu kushoborora obutaikirizana obutari bwa maan | 0 | 133 | 0 |  |  |  |  | 43 |
| m5_q13_1 | byte | %10.0g |  | M5_Q13_1 | 0 | 133 | 0 | 0.7894736842105263 | 0.4092237955355674 | 0 | 1 | 2 |
| m5_q13_2 | byte | %10.0g |  | M5_Q13_2 | 0 | 133 | 0 | 0.7443609022556391 | 0.4378690709655921 | 0 | 1 | 2 |
| m5_q13_3 | byte | %10.0g |  | M5_Q13_3 | 0 | 133 | 0 | 0.5037593984962406 | 0.5018761791997308 | 0 | 1 | 2 |
| m5_q13_4 | byte | %10.0g |  | M5_Q13_4 | 0 | 133 | 0 | 0.1654135338345865 | 0.372958100007095 | 0 | 1 | 2 |
| m5_q13_5 | byte | %10.0g |  | M5_Q13_5 | 0 | 133 | 0 | 0.2180451127819549 | 0.414479335023521 | 0 | 1 | 2 |
| m5_q13_6 | byte | %10.0g |  | M5_Q13_6 | 0 | 133 | 0 | 0.0977443609022556 | 0.298091445551766 | 0 | 1 | 2 |
| m5_q13_7 | byte | %10.0g |  | M5_Q13_7 | 0 | 133 | 0 | 0.0902255639097744 | 0.2875878420888012 | 0 | 1 | 2 |
| m5_q13_8 | byte | %10.0g |  | M5_Q13_8 | 0 | 133 | 0 | 0.0300751879699248 | 0.1714399631667259 | 0 | 1 | 2 |
| m5_q13_95 | byte | %10.0g |  | M5_Q13_95 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m5_q13_98 | byte | %10.0g |  | M5_Q13_98 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m5_q14 | byte | %49.0g | m5_q14 | Kooti yekyaro kwekwihika endagano omumishonga etari mihango munonga, Niryari obu | 0 | 133 | 0 | 2.62406015037594 | 1.21606359332939 | 0 | 4 | 5 |
| m5_q15 | byte | %64.0g | m5_q15 | Omuntu omwe ku arikuremwa kukuratira endagaano, kooti ya LCC nekiira kukora ki? | 0 | 133 | 0 | 5.81203007518797 | 19.91578876318221 | 1 | 97 | 6 |
| m5_q16 | byte | %23.0g | m5_q16 | Omu kuteekateeka kwawe, kooti ya LCC nikihwera kita okuzibira entongane z'omunda | 0 | 133 | 0 | 3.616541353383459 | 11.76584798712917 | 0 | 98 | 6 |
| m5_q17 | str147 | %147s |  | Enumerator notes on ADR and mediation practice | 7 | 126 | 5.263157894736842 |  |  |  |  | 121 |
| m6_q01 | byte | %41.0g | m6_q01 | Omushango gwaba guri muhango aha kooti ya LC nainga guri ogw'amaani munonga, nir | 0 | 133 | 0 | 4.240601503759398 | 11.55628543126145 | 0 | 97 | 6 |
| m3_q10 | byte | %10.0g |  | Aha mishango eyatungirwe omu myezi eshatu ehwaire, ni engahi eyahairweyo omu koo | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q11 | byte | %10.0g |  | Ni muntu ki owahaireyo emishango omu kitongore eki omu myezi eshatu ehwaire? Too | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q11_1 | byte | %10.0g |  | M3_Q11_1 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q11_2 | byte | %10.0g |  | M3_Q11_2 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q11_3 | byte | %10.0g |  | M3_Q11_3 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q11_4 | byte | %10.0g |  | M3_Q11_4 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q11_5 | byte | %10.0g |  | M3_Q11_5 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q11_6 | byte | %10.0g |  | M3_Q11_6 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q11_98 | byte | %10.0g |  | M3_Q11_98 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q12 | byte | %10.0g |  | Aha mishango eyatungirwe omu myezi eshatu ehwaire, ni engahi eyahereize pooriisi | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q13 | byte | %10.0g |  | Ekitongore kya LCC kikatwara nkahi emishango omu myezi eshatu ehwaire? Toorana e | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q13_1 | byte | %10.0g |  | M3_Q13_1 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q13_2 | byte | %10.0g |  | M3_Q13_2 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q13_3 | byte | %10.0g |  | M3_Q13_3 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q13_4 | byte | %10.0g |  | M3_Q13_4 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q13_5 | byte | %10.0g |  | M3_Q13_5 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q13_6 | byte | %10.0g |  | M3_Q13_6 | 133 | 0 | 100 |  |  |  |  | 0 |
| m3_q13_98 | byte | %10.0g |  | M3_Q13_98 | 133 | 0 | 100 |  |  |  |  | 0 |
| m6_q04 | str11 | %11s |  | Ni nshonga ki enkuru ezareesire okwohereza emishango egi omubanyamateeka neinga  | 0 | 133 | 0 |  |  |  |  | 24 |
| m6_q04_1 | byte | %10.0g |  | M6_Q04_1 | 0 | 133 | 0 | 0.849624060150376 | 0.3587909115412519 | 0 | 1 | 2 |
| m6_q04_2 | byte | %10.0g |  | M6_Q04_2 | 0 | 133 | 0 | 0.6917293233082706 | 0.4635248861911063 | 0 | 1 | 2 |
| m6_q04_3 | byte | %10.0g |  | M6_Q04_3 | 0 | 133 | 0 | 0.4060150375939849 | 0.4929440619958883 | 0 | 1 | 2 |
| m6_q04_4 | byte | %10.0g |  | M6_Q04_4 | 0 | 133 | 0 | 0.1804511278195489 | 0.3860166911559539 | 0 | 1 | 2 |
| m6_q04_5 | byte | %10.0g |  | M6_Q04_5 | 0 | 133 | 0 | 0.075187969924812 | 0.2646913625903545 | 0 | 1 | 2 |
| m6_q04_6 | byte | %10.0g |  | M6_Q04_6 | 0 | 133 | 0 | 0.0451127819548872 | 0.2083361813430304 | 0 | 1 | 2 |
| m6_q04_7 | byte | %10.0g |  | M6_Q04_7 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m6_q04_8 | byte | %10.0g |  | M6_Q04_8 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m6_q04_98 | byte | %10.0g |  | M6_Q04_98 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m6_q05 | byte | %23.0g | m6_q05 | LC yaawe ku erikuheereza omushango omu kitongore ekindi, niryari obu okwoherezib | 0 | 133 | 0 | 2.165413533834586 | 1.109056732214359 | 0 | 4 | 5 |
| m6_q08 | byte | %23.0g | m6_q08 | Bwanyima y'okuhayo emishango owa banyamateeka nainga abobushoborozi abandi aba h | 0 | 133 | 0 | 4.165413533834586 | 14.35226750701247 | 0 | 98 | 6 |
| m6_q09 | byte | %53.0g | m6_q09 | Okutwariza hamwe, kyanguhi nari kigumire ekitongore kya LCC kukwatanisa na poori | 0 | 133 | 0 | 4.112781954887218 | 1.125827206575612 | 1 | 5 | 5 |
| m6_q10 | byte | %53.0g | m6_q10 | Okutwarira hamwe, kyanguhi nari kigumire ekitongore kya LCC kukwatanisa na kooti | 0 | 133 | 0 | 6.037593984962406 | 13.97910020895783 | 1 | 98 | 7 |
| m6_q12 | str7 | %9s |  | Ni bizibuki eiwe owa LCC ebyorikubugana waba noyohereza emishango omu kooti nein | 0 | 133 | 0 |  |  |  |  | 28 |
| m6_q12_1 | byte | %10.0g |  | M6_Q12_1 | 0 | 133 | 0 | 0.6917293233082706 | 0.4635248861911063 | 0 | 1 | 2 |
| m6_q12_2 | byte | %10.0g |  | M6_Q12_2 | 0 | 133 | 0 | 0.6015037593984962 | 0.4914395925155201 | 0 | 1 | 2 |
| m6_q12_3 | byte | %10.0g |  | M6_Q12_3 | 0 | 133 | 0 | 0.3007518796992481 | 0.4603187697542939 | 0 | 1 | 2 |
| m6_q12_4 | byte | %10.0g |  | M6_Q12_4 | 0 | 133 | 0 | 0.2406015037593985 | 0.4290648029718084 | 0 | 1 | 2 |
| m6_q12_5 | byte | %10.0g |  | M6_Q12_5 | 0 | 133 | 0 | 0.0225563909774436 | 0.149045722775883 | 0 | 1 | 2 |
| m6_q12_6 | byte | %10.0g |  | M6_Q12_6 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m6_q12_7 | byte | %10.0g |  | M6_Q12_7 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m6_q12_8 | byte | %10.0g |  | M6_Q12_8 | 0 | 133 | 0 | 0.0526315789473684 | 0.2241411038827122 | 0 | 1 | 2 |
| m6_q12_9 | byte | %10.0g |  | M6_Q12_9 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m6_q12_10 | byte | %10.0g |  | M6_Q12_10 | 0 | 133 | 0 | 0.0300751879699248 | 0.1714399631667259 | 0 | 1 | 2 |
| m6_q12_11 | byte | %10.0g |  | M6_Q12_11 | 0 | 133 | 0 | 0.1503759398496241 | 0.3587909115412519 | 0 | 1 | 2 |
| m6_q12_98 | byte | %10.0g |  | M6_Q12_98 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m6_q14 | byte | %20.0g | m6_q14 | Noyekakasa ota omukumanya nkahi ohoine kwohereza emishango eya mateeka gatakwiki | 0 | 133 | 0 | 2.383458646616541 | 0.859190991143291 | 0 | 4 | 5 |
| m6_q15 | byte | %20.0g | m6_q15 | Nowekaakasa ota omumagezi no'kumanya o kushoboororera abantu ahabwenki emishango | 0 | 133 | 0 | 2.360902255639098 | 0.890508416789904 | 0 | 4 | 5 |
| m6_q16 | byte | %74.0g | m6_q16 | Enumerator verification: In the records seen today, is there any written evidenc | 19 | 114 | 14.28571428571428 | 12.64912280701754 | 30.76861475742741 | 1 | 98 | 5 |
| m6_q17 | byte | %45.0g | m6_q17 | Enumerator verification: In the records seen today, is the destination of referr | 19 | 114 | 14.28571428571428 | 7.614035087719298 | 23.23961706382216 | 1 | 98 | 5 |
| m6_q18 | str117 | %117s |  | Enumerator notes on referral practice and coordination | 2 | 131 | 1.503759398496241 |  |  |  |  | 127 |
| m7_q01 | byte | %38.0g | m7_q01 | Kooti ya LC eriho obwahati eine ekitabo ky'okuhandikamu emishango? | 0 | 133 | 0 | 1.368421052631579 | 0.6212607441973955 | 1 | 3 | 3 |
| m7_q03 | str7 | %9s |  | Ni bihandiiko ki ebyahandikirwe ebi LCC erikubiika? Toorana byona ebirikukwataho | 0 | 133 | 0 |  |  |  |  | 21 |
| m7_q03_1 | byte | %10.0g |  | M7_Q03_1 | 0 | 133 | 0 | 0.7669172932330827 | 0.4243929362276081 | 0 | 1 | 2 |
| m7_q03_2 | byte | %10.0g |  | M7_Q03_2 | 0 | 133 | 0 | 0.5864661654135338 | 0.494328739054932 | 0 | 1 | 2 |
| m7_q03_3 | byte | %10.0g |  | M7_Q03_3 | 0 | 133 | 0 | 0.4210526315789473 | 0.4955946277833521 | 0 | 1 | 2 |
| m7_q03_4 | byte | %10.0g |  | M7_Q03_4 | 0 | 133 | 0 | 0.1203007518796992 | 0.3265428178560505 | 0 | 1 | 2 |
| m7_q03_5 | byte | %10.0g |  | M7_Q03_5 | 0 | 133 | 0 | 0.0526315789473684 | 0.2241411038827122 | 0 | 1 | 2 |
| m7_q03_6 | byte | %10.0g |  | M7_Q03_6 | 0 | 133 | 0 | 0.0225563909774436 | 0.149045722775883 | 0 | 1 | 2 |
| m7_q03_95 | byte | %10.0g |  | M7_Q03_95 | 0 | 133 | 0 | 0.0676691729323308 | 0.2521269738374536 | 0 | 1 | 2 |
| m7_q03_98 | byte | %10.0g |  | M7_Q03_98 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m7_q04 | byte | %21.0g | m7_q04 | Ebihandiiko bya LCC obwahati bihikire? | 10 | 123 | 7.518796992481203 | 2.260162601626016 | 8.728920649831164 | 1 | 98 | 4 |
| m7_q05 | byte | %29.0g | m7_q05 | Omushango ogwahererukireyo kutaaha omu bihandiiko bya LCC gukataahamu ryari? | 10 | 123 | 7.518796992481203 | 3.024390243902439 | 8.691868646486373 | 1 | 98 | 6 |
| m7_q06 | str24 | %24s |  | Omushango ku gurikuhandiikwa, ni makuru ki agarikukira kuba garimu? Toorana goon | 10 | 123 | 7.518796992481203 |  |  |  |  | 27 |
| m7_q06_1 | byte | %10.0g |  | M7_Q06_1 | 10 | 123 | 7.518796992481203 | 0.983739837398374 | 0.1269916634283574 | 0 | 1 | 2 |
| m7_q06_2 | byte | %10.0g |  | M7_Q06_2 | 10 | 123 | 7.518796992481203 | 0.926829268292683 | 0.2614816455119253 | 0 | 1 | 2 |
| m7_q06_3 | byte | %10.0g |  | M7_Q06_3 | 10 | 123 | 7.518796992481203 | 0.6585365853658537 | 0.4761400175090208 | 0 | 1 | 2 |
| m7_q06_4 | byte | %10.0g |  | M7_Q06_4 | 10 | 123 | 7.518796992481203 | 0.5447154471544715 | 0.5000333188951824 | 0 | 1 | 2 |
| m7_q06_5 | byte | %10.0g |  | M7_Q06_5 | 10 | 123 | 7.518796992481203 | 0.2276422764227642 | 0.4210254485918737 | 0 | 1 | 2 |
| m7_q06_6 | byte | %10.0g |  | M7_Q06_6 | 10 | 123 | 7.518796992481203 | 0.0894308943089431 | 0.2865318361649869 | 0 | 1 | 2 |
| m7_q06_7 | byte | %10.0g |  | M7_Q06_7 | 10 | 123 | 7.518796992481203 | 0.0731707317073171 | 0.2614816455119253 | 0 | 1 | 2 |
| m7_q06_8 | byte | %10.0g |  | M7_Q06_8 | 10 | 123 | 7.518796992481203 | 0.008130081300813 | 0.0901669634667432 | 0 | 1 | 2 |
| m7_q06_9 | byte | %10.0g |  | M7_Q06_9 | 10 | 123 | 7.518796992481203 | 0.0650406504065041 | 0.2476061586661559 | 0 | 1 | 2 |
| m7_q06_10 | byte | %10.0g |  | M7_Q06_10 | 10 | 123 | 7.518796992481203 | 0.032520325203252 | 0.1781029058586727 | 0 | 1 | 2 |
| m7_q06_11 | byte | %10.0g |  | M7_Q06_11 | 10 | 123 | 7.518796992481203 | 0.040650406504065 | 0.1982866770381132 | 0 | 1 | 2 |
| m7_q06_12 | byte | %10.0g |  | M7_Q06_12 | 10 | 123 | 7.518796992481203 | 0.016260162601626 | 0.1269916634283574 | 0 | 1 | 2 |
| m7_q06_98 | byte | %10.0g |  | M7_Q06_98 | 10 | 123 | 7.518796992481203 | 0.008130081300813 | 0.0901669634667432 | 0 | 1 | 2 |
| m7_q08 | byte | %23.0g | m7_q08 | Ebirugire omu kusharamu, nari okukirizana nibihandiikwa buri ryari? | 10 | 123 | 7.518796992481203 | 2.552845528455284 | 1.139479691677844 | 0 | 4 | 5 |
| m7_q12 | byte | %26.0g | m7_q12 | Omuntu ku yaakushaba ebikukwata aha mushango gu washazire omu myezi eshatu ehwai | 10 | 123 | 7.518796992481203 | 3.715447154471545 | 1.218170660223912 | 1 | 5 | 5 |
| m7_q13 | byte | %19.0g | m7_q13 | Ebihandiiko by'amishango ya Kooti yaawe nibibiikwa omu mwanya ogurinzirwe gye ku | 10 | 123 | 7.518796992481203 | 2.357723577235773 | 8.720740381883298 | 1 | 98 | 4 |
| m7_q14 | str8 | %9s |  | N'oha orikubaasa kuhikwaho aha bihandiiko by'omushango gwa LCC? Select all that  | 10 | 123 | 7.518796992481203 |  |  |  |  | 18 |
| m7_q14_1 | byte | %10.0g |  | M7_Q14_1 | 10 | 123 | 7.518796992481203 | 0.8373983739837398 | 0.3705110281281078 | 0 | 1 | 2 |
| m7_q14_2 | byte | %10.0g |  | M7_Q14_2 | 10 | 123 | 7.518796992481203 | 0.8211382113821138 | 0.3848039808679954 | 0 | 1 | 2 |
| m7_q14_3 | byte | %10.0g |  | M7_Q14_3 | 10 | 123 | 7.518796992481203 | 0.2926829268292683 | 0.4568550244822115 | 0 | 1 | 2 |
| m7_q14_4 | byte | %10.0g |  | M7_Q14_4 | 10 | 123 | 7.518796992481203 | 0.0569105691056911 | 0.2326191923678487 | 0 | 1 | 2 |
| m7_q14_5 | byte | %10.0g |  | M7_Q14_5 | 10 | 123 | 7.518796992481203 | 0.0894308943089431 | 0.2865318361649869 | 0 | 1 | 2 |
| m7_q14_6 | byte | %10.0g |  | M7_Q14_6 | 10 | 123 | 7.518796992481203 | 0.008130081300813 | 0.0901669634667432 | 0 | 1 | 2 |
| m7_q14_7 | byte | %10.0g |  | M7_Q14_7 | 10 | 123 | 7.518796992481203 | 0.008130081300813 | 0.0901669634667432 | 0 | 1 | 2 |
| m7_q14_98 | byte | %10.0g |  | M7_Q14_98 | 10 | 123 | 7.518796992481203 | 0.016260162601626 | 0.1269916634283574 | 0 | 1 | 2 |
| m7_q15 | str5 | %9s |  | Ni buremeezi ki oburikukirayo obuhango obu kooti yaawe erikushanga omu kubika eb | 0 | 133 | 0 |  |  |  |  | 22 |
| m7_q15_1 | byte | %10.0g |  | M7_Q15_1 | 0 | 133 | 0 | 0.7744360902255639 | 0.4195333149155044 | 0 | 1 | 2 |
| m7_q15_2 | byte | %10.0g |  | M7_Q15_2 | 0 | 133 | 0 | 0.7669172932330827 | 0.4243929362276081 | 0 | 1 | 2 |
| m7_q15_3 | byte | %10.0g |  | M7_Q15_3 | 0 | 133 | 0 | 0.4210526315789473 | 0.4955946277833521 | 0 | 1 | 2 |
| m7_q15_4 | byte | %10.0g |  | M7_Q15_4 | 0 | 133 | 0 | 0.075187969924812 | 0.2646913625903545 | 0 | 1 | 2 |
| m7_q15_5 | byte | %10.0g |  | M7_Q15_5 | 0 | 133 | 0 | 0.112781954887218 | 0.317522018762762 | 0 | 1 | 2 |
| m7_q15_6 | byte | %10.0g |  | M7_Q15_6 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m7_q15_7 | byte | %10.0g |  | M7_Q15_7 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m7_q15_8 | byte | %10.0g |  | M7_Q15_8 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m7_q15_9 | byte | %10.0g |  | M7_Q15_9 | 0 | 133 | 0 | 0.0676691729323308 | 0.2521269738374536 | 0 | 1 | 2 |
| m7_q15_98 | byte | %10.0g |  | M7_Q15_98 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m7_v01 | byte | %40.0g | m7_v01 | Enumerator verification: Did you see a case register or case book? | 19 | 114 | 14.28571428571428 | 1.078947368421053 | 0.5666972602863211 | 0 | 2 | 3 |
| m7_v02 | byte | %42.0g | m7_v02 | Enumerator verification: Did you see a proceedings book or hearing/mediation not | 19 | 114 | 14.28571428571428 | 1.043859649122807 | 0.585825956171088 | 0 | 2 | 3 |
| m7_v12 | byte | %49.0g | m7_v12 | Enumerator verification: Where were the records stored at the time of the interv | 37 | 96 | 27.81954887218045 | 1.875 | 1.048808848170152 | 1 | 5 | 5 |
| m7_v13 | byte | %43.0g | m7_v13 | Enumerator verification: Overall, how complete and usable did the available LCC  | 19 | 114 | 14.28571428571428 | 9.210526315789474 | 22.83432972258727 | 1 | 98 | 6 |
| m7_v14 | byte | %49.0g | m7_v14 | Enumerator verification: Why could records not be verified during this interview | 114 | 19 | 85.71428571428571 | 2.315789473684211 | 1.249561326535008 | 1 | 5 | 4 |
| m7_q16 | str99 | %99s |  | Enumerator notes on record-keeping and case management quality | 5 | 128 | 3.759398496240602 |  |  |  |  | 113 |
| m8_q01 | byte | %46.0g | m8_q01 | Kooti y'ekyaro kyanyu neshaara eta emishango obutosha? | 0 | 133 | 0 | 1.240601503759398 | 0.4290648029718084 | 1 | 2 | 2 |
| m8_q03 | byte | %23.0g | m8_q03 | Omu kuhanuura aha mishango, niryari obu abanyakakiiko abataribamwe na bamwe baku | 0 | 133 | 0 | 2.571428571428572 | 1.150004705429861 | 0 | 4 | 5 |
| m8_q04 | byte | %23.0g | m8_q04 | Batakatungire encwamu, okwikirizana, nainga okwohereza omushango omu kooti, niry | 0 | 133 | 0 | 2.62406015037594 | 1.084334062911835 | 0 | 4 | 5 |
| m8_q06 | byte | %45.0g | m8_q06 | Abakazi ku barikuba bari abanyakakiiko, ryari obu bakweejumbira omu kugaaniira n | 1 | 132 | 0.7518796992481203 | 2.946969696969697 | 1.12103001940993 | 0 | 4 | 5 |
| m8_q07 | byte | %66.0g | m8_q07 | Hariho enkora yona neinga enteekateeka y'okureeba ngu ebitekyerezo ne nshonga za | 1 | 132 | 0.7518796992481203 | 1.840909090909091 | 8.446354781259728 | 1 | 98 | 5 |
| m8_q08 | byte | %42.0g | m8_q08 | Omushango ku gurikushwarwa, kwogyegwa yo omu kooti ezindi, niryari obu ebihandii | 0 | 133 | 0 | 2.781954887218045 | 1.220645295466033 | 0 | 4 | 5 |
| m8_q09 | byte | %14.0g | m8_q09 | Aka kiiko ka court ya LC nikashitama okushwijuma emishango etakahweire, etakasha | 0 | 133 | 0 | 2.706766917293233 | 8.37907020487901 | 1 | 98 | 5 |
| m8_q11 | byte | %44.0g | m8_q11 | Ba memba b'akakiiko ku barikuhakana aha ku bashemereire kukora aha mushango, eki | 0 | 133 | 0 | 1.962406015037594 | 8.4148191927114 | 1 | 98 | 5 |
| m8_q12 | byte | %23.0g | m8_q12 | Nenkyuro zingahi ezi ab'akakiiko barikuhakana yaaba omushango gushemereire kusha | 0 | 133 | 0 | 2 | 1.212310591266516 | 0 | 4 | 5 |
| m8_q13 | byte | %21.0g | m8_q13 | Okusharaho kwa LCC nikuhikaana kuta omu mishango erikushushana? | 0 | 133 | 0 | 3.503759398496241 | 0.8929357450022178 | 1 | 5 | 5 |
| m8_q14 | byte | %20.0g | m8_q14 | Noye kakaasa ota ngu kooti ya LC egi nikikuratira engyenderwaho niyo emwe omu ku | 0 | 133 | 0 | 2.345864661654135 | 0.8352563821779594 | 0 | 4 | 5 |
| m8_q15 | str6 | %9s |  | Ni buremeezi ki oburikukirayo obwingi oburi kuremesa akakiiko ka court yekyaro k | 3 | 130 | 2.255639097744361 |  |  |  |  | 22 |
| m8_q15_1 | byte | %10.0g |  | M8_Q15_1 | 0 | 133 | 0 | 0.6917293233082706 | 0.4635248861911063 | 0 | 1 | 2 |
| m8_q15_2 | byte | %10.0g |  | M8_Q15_2 | 0 | 133 | 0 | 0.5939849624060151 | 0.4929440619958883 | 0 | 1 | 2 |
| m8_q15_3 | byte | %10.0g |  | M8_Q15_3 | 0 | 133 | 0 | 0.2857142857142857 | 0.4534619119922925 | 0 | 1 | 2 |
| m8_q15_4 | byte | %10.0g |  | M8_Q15_4 | 0 | 133 | 0 | 0.0300751879699248 | 0.1714399631667259 | 0 | 1 | 2 |
| m8_q15_5 | byte | %10.0g |  | M8_Q15_5 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m8_q15_6 | byte | %10.0g |  | M8_Q15_6 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m8_q15_7 | byte | %10.0g |  | M8_Q15_7 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m8_q15_8 | byte | %10.0g |  | M8_Q15_8 | 0 | 133 | 0 | 0.075187969924812 | 0.2646913625903545 | 0 | 1 | 2 |
| m8_q15_9 | byte | %10.0g |  | M8_Q15_9 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m8_q15_10 | byte | %10.0g |  | M8_Q15_10 | 0 | 133 | 0 | 0.1203007518796992 | 0.3265428178560505 | 0 | 1 | 2 |
| m8_q15_98 | byte | %10.0g |  | M8_Q15_98 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m8_v01 | byte | %53.0g | m8_v01 | Enumerator verification: In the records seen today, is there evidence that more  | 19 | 114 | 14.28571428571428 | 7.298245614035087 | 23.31163628481328 | 1 | 98 | 5 |
| m8_v02 | byte | %61.0g | m8_v02 | Enumerator verification: In the records seen today, is there evidence that decis | 19 | 114 | 14.28571428571428 | 8.157894736842104 | 24.80171951909516 | 1 | 98 | 5 |
| m8_q16 | str134 | %134s |  | Enumerator notes on committee sitting and decision-making process | 5 | 128 | 3.759398496240602 |  |  |  |  | 123 |
| m9_q12 | byte | %15.0g | m9_q12 | Omu nteekateka yaawe, abantu b'omukyaaro kyaawe nibateekateeka ngu kooti z'ebyar | 0 | 133 | 0 | 3.729323308270676 | 1.00096786153772 | 1 | 5 | 5 |
| m9_q14 | byte | %18.0g | m9_q14 | Omu kuteekateeka kwawe, abantu b'omukyaaro kyaawe ni bejumbira okureeta emishang | 0 | 133 | 0 | 3.639097744360902 | 0.9401671826237886 | 1 | 5 | 5 |
| m9_q15 | byte | %23.0g | m9_q15 | Omu kuteekateeka kwawe, abantu nibakira kuhingura bata akakiiko k'eby'obutegyeki | 0 | 133 | 0 | 2.233082706766917 | 1.205336731808653 | 0 | 4 | 5 |
| m9_q16 | str6 | %9s |  | Ni nshonga ki enkuru ahabw'enki abantu abamwe barikubaasa kuhingura aho okukores | 0 | 133 | 0 |  |  |  |  | 25 |
| m9_q16_1 | byte | %10.0g |  | M9_Q16_1 | 0 | 133 | 0 | 0.6842105263157895 | 0.4665869150354483 | 0 | 1 | 2 |
| m9_q16_2 | byte | %10.0g |  | M9_Q16_2 | 0 | 133 | 0 | 0.4887218045112782 | 0.5017626710722586 | 0 | 1 | 2 |
| m9_q16_3 | byte | %10.0g |  | M9_Q16_3 | 0 | 133 | 0 | 0.1203007518796992 | 0.3265428178560505 | 0 | 1 | 2 |
| m9_q16_4 | byte | %10.0g |  | M9_Q16_4 | 0 | 133 | 0 | 0.0601503759398496 | 0.2386641642064697 | 0 | 1 | 2 |
| m9_q16_5 | byte | %10.0g |  | M9_Q16_5 | 0 | 133 | 0 | 0.0300751879699248 | 0.1714399631667259 | 0 | 1 | 2 |
| m9_q16_6 | byte | %10.0g |  | M9_Q16_6 | 0 | 133 | 0 | 0.0300751879699248 | 0.1714399631667259 | 0 | 1 | 2 |
| m9_q16_7 | byte | %10.0g |  | M9_Q16_7 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m9_q16_8 | byte | %10.0g |  | M9_Q16_8 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m9_q16_9 | byte | %10.0g |  | M9_Q16_9 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m9_q16_10 | byte | %10.0g |  | M9_Q16_10 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m9_q16_11 | byte | %10.0g |  | M9_Q16_11 | 0 | 133 | 0 | 0.1503759398496241 | 0.3587909115412519 | 0 | 1 | 2 |
| m9_q16_98 | byte | %10.0g |  | M9_Q16_98 | 0 | 133 | 0 | 0.0526315789473684 | 0.2241411038827122 | 0 | 1 | 2 |
| m9_q17 | byte | %19.0g | m9_q17 | Omu kuteekateeka kwawe, okumanyangana kwa'bantu, okushoroora, ebiconco, esente,  | 0 | 133 | 0 | 4.360902255639098 | 11.66407223048406 | 1 | 98 | 6 |
| m9_q18 | byte | %20.0g | m9_q18 | Oine obukakafu bukwingana ki ngu kooti y'ekyaaro eiine obwesigye bw'abantu okush | 0 | 133 | 0 | 2.496240601503759 | 0.7941458166080074 | 0 | 4 | 5 |
| m9_q19 | byte | %20.0g | m9_q19 | Okutwariza hamwe, noyekakasa ota ngu kooti yekyaaro neshaara emishango muburinga | 0 | 133 | 0 | 2.556390977443609 | 0.820324527749273 | 0 | 4 | 5 |
| m9_q20 | str134 | %134s |  | Enumerator notes on procedural fairness and perceived local legitimacy | 5 | 128 | 3.759398496240602 |  |  |  |  | 118 |
| m10_q07 | byte | %11.0g | m10_q07 | Omu kuteekateeka kwawe, emishango erimu abaana, abahonokireho obutabanguko, abai | 0 | 133 | 0 | 3.06015037593985 | 14.48079156053425 | 0 | 98 | 3 |
| m10_q08 | byte | %10.0g |  | Ni bujanjabi ki obw'omutaano oburikubaasa kwetengwa ahabw'emishango egi? Toorana | 133 | 0 | 100 |  |  |  |  | 0 |
| m10_q08_1 | byte | %10.0g |  | M10_Q08_1 | 133 | 0 | 100 |  |  |  |  | 0 |
| m10_q08_2 | byte | %10.0g |  | M10_Q08_2 | 133 | 0 | 100 |  |  |  |  | 0 |
| m10_q08_3 | byte | %10.0g |  | M10_Q08_3 | 133 | 0 | 100 |  |  |  |  | 0 |
| m10_q08_4 | byte | %10.0g |  | M10_Q08_4 | 133 | 0 | 100 |  |  |  |  | 0 |
| m10_q08_5 | byte | %10.0g |  | M10_Q08_5 | 133 | 0 | 100 |  |  |  |  | 0 |
| m10_q08_6 | byte | %10.0g |  | M10_Q08_6 | 133 | 0 | 100 |  |  |  |  | 0 |
| m10_q08_7 | byte | %10.0g |  | M10_Q08_7 | 133 | 0 | 100 |  |  |  |  | 0 |
| m10_q08_98 | byte | %10.0g |  | M10_Q08_98 | 133 | 0 | 100 |  |  |  |  | 0 |
| m10_v01 | byte | %57.0g | m10_v01 | Enumerator verification: In the records seen today, is there evidence that sensi | 133 | 0 | 100 |  |  |  |  | 0 |
| m10_v02 | byte | %38.0g | m10_v02 | Enumerator verification: Based on the records seen today, do sensitive case reco | 133 | 0 | 100 |  |  |  |  | 0 |
| m10_q15 | str108 | %108s |  | Enumerator notes on gender, child protection, and serious-case safeguards | 4 | 129 | 3.007518796992481 |  |  |  |  | 124 |
| m11_q02 | byte | %20.0g | m11_q02 | Ni kikuru kita abebembezi b'ebyanga, otwariiremu n'abebembezi ba LC, okushagika  | 0 | 133 | 0 | 2.488721804511278 | 0.8670442768864619 | 0 | 4 | 5 |
| m11_q03 | byte | %18.0g | m11_q03 | Iwe nka chairpersons wa LC egi, nohangira ekyo muntu owaabaire ari omu kihome ok | 0 | 133 | 0 | 2.488721804511278 | 0.8221971797105557 | 0 | 4 | 5 |
| m11_q04 | byte | %26.0g | m11_q04 | Naba ninkushaba ngu ongambire waba noyikiriza ninga ori kuhakanisa ekihandiiko e | 0 | 133 | 0 | 4.105263157894737 | 0.618688224889746 | 1 | 5 | 5 |
| m11_q05 | byte | %26.0g | m11_q05 | Naba ninkushaba ngu ongambire waba noyikiriza ninga ori kuhakanisa ekihandiiko e | 0 | 133 | 0 | 3.225563909774436 | 1.240824147879286 | 1 | 5 | 5 |
| m11_q06 | byte | %26.0g | m11_q06 | Naba ninkushaba ngu ongambire waba noyikiriza ninga ori kuhakanisa ekihandiiko e | 0 | 133 | 0 | 4.270676691729324 | 8.235297109273787 | 1 | 98 | 6 |
| m11_q07 | byte | %26.0g | m11_q07 | Naba ninkushaba ngu ongambire waba noyikiriza ninga ori kuhakanisa ekihandiiko e | 0 | 133 | 0 | 4.488721804511278 | 8.204411730202699 | 1 | 98 | 6 |
| m11_q08 | byte | %22.0g | m11_q08 | Noye kaakaza ota okushara omushango gurimu owabaire ari omusibe hamwe n'omuntu o | 0 | 133 | 0 | 2.789473684210526 | 0.8443451073388661 | 0 | 4 | 5 |
| m11_q09 | byte | %33.0g | m11_q09 | Noobaasa kuhwera omuntu owaabaire ari omu kihome kuhikaana n'abantu abandi, obuh | 0 | 133 | 0 | 3.62406015037594 | 8.281598352315923 | 0 | 98 | 6 |
| m11_q10 | str7 | %9s |  | Ni buhwezi ki oburikubaasa kuhwera omuntu orikuruga omu kihome kugaruka omu bant | 0 | 133 | 0 |  |  |  |  | 26 |
| m11_q10_1 | byte | %10.0g |  | M11_Q10_1 | 0 | 133 | 0 | 0.8721804511278195 | 0.3351511155001681 | 0 | 1 | 2 |
| m11_q10_2 | byte | %10.0g |  | M11_Q10_2 | 0 | 133 | 0 | 0.4210526315789473 | 0.4955946277833521 | 0 | 1 | 2 |
| m11_q10_3 | byte | %10.0g |  | M11_Q10_3 | 0 | 133 | 0 | 0.518796992481203 | 0.5015355777494375 | 0 | 1 | 2 |
| m11_q10_4 | byte | %10.0g |  | M11_Q10_4 | 0 | 133 | 0 | 0.075187969924812 | 0.2646913625903545 | 0 | 1 | 2 |
| m11_q10_5 | byte | %10.0g |  | M11_Q10_5 | 0 | 133 | 0 | 0.1503759398496241 | 0.3587909115412519 | 0 | 1 | 2 |
| m11_q10_6 | byte | %10.0g |  | M11_Q10_6 | 0 | 133 | 0 | 0.0827067669172932 | 0.2764798415018575 | 0 | 1 | 2 |
| m11_q10_7 | byte | %10.0g |  | M11_Q10_7 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m11_q10_8 | byte | %10.0g |  | M11_Q10_8 | 0 | 133 | 0 | 0.037593984962406 | 0.1909313313651758 | 0 | 1 | 2 |
| m11_q10_9 | byte | %10.0g |  | M11_Q10_9 | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| m11_q10_98 | byte | %10.0g |  | M11_Q10_98 | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| m11_q11 | byte | %17.0g | m11_q11 | Omu kureeba kwawe, okujumwa nari okutwarizibwa kubi omu bantu abarikugaruka omu  | 0 | 133 | 0 | 2.571428571428572 | 1.226510906730554 | 1 | 5 | 5 |
| m11_q12 | str5 | %9s |  | Ni nshonga ki enkuru ezirikubaasa kureetera abantu kutenda kwikiriza nari kushag | 0 | 133 | 0 |  |  |  |  | 27 |
| m11_q12_1 | byte | %10.0g |  | M11_Q12_1 | 0 | 133 | 0 | 0.7293233082706767 | 0.445989189107868 | 0 | 1 | 2 |
| m11_q12_2 | byte | %10.0g |  | M11_Q12_2 | 0 | 133 | 0 | 0.4736842105263158 | 0.5011947448335865 | 0 | 1 | 2 |
| m11_q12_3 | byte | %10.0g |  | M11_Q12_3 | 0 | 133 | 0 | 0.2030075187969925 | 0.4037588257078461 | 0 | 1 | 2 |
| m11_q12_4 | byte | %10.0g |  | M11_Q12_4 | 0 | 133 | 0 | 0.1954887218045113 | 0.398075800162317 | 0 | 1 | 2 |
| m11_q12_5 | byte | %10.0g |  | M11_Q12_5 | 0 | 133 | 0 | 0.0451127819548872 | 0.2083361813430304 | 0 | 1 | 2 |
| m11_q12_6 | byte | %10.0g |  | M11_Q12_6 | 0 | 133 | 0 | 0.0676691729323308 | 0.2521269738374536 | 0 | 1 | 2 |
| m11_q12_7 | byte | %10.0g |  | M11_Q12_7 | 0 | 133 | 0 | 0.037593984962406 | 0.1909313313651758 | 0 | 1 | 2 |
| m11_q12_8 | byte | %10.0g |  | M11_Q12_8 | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| m11_q12_9 | byte | %10.0g |  | M11_Q12_9 | 0 | 133 | 0 | 0.0902255639097744 | 0.2875878420888012 | 0 | 1 | 2 |
| m11_q12_98 | byte | %10.0g |  | M11_Q12_98 | 0 | 133 | 0 | 0.037593984962406 | 0.1909313313651758 | 0 | 1 | 2 |
| m11_q13 | byte | %29.0g | m11_q13 | Omu myezi mukaaga ehwaire, akakiiko k'ebyaro/akakiiko k'ebyaro kashoboroire ensh | 0 | 133 | 0 | 2.827067669172932 | 14.52036776299619 | 0 | 98 | 3 |
| m11_q14 | byte | %10.0g |  | Ni shonga ki eyakozirweho akakiiko k'ebyaro? Toorana zoona ezirikukora. | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q14_1 | byte | %10.0g |  | M11_Q14_1 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q14_2 | byte | %10.0g |  | M11_Q14_2 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q14_3 | byte | %10.0g |  | M11_Q14_3 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q14_4 | byte | %10.0g |  | M11_Q14_4 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q14_5 | byte | %10.0g |  | M11_Q14_5 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q14_6 | byte | %10.0g |  | M11_Q14_6 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q14_7 | byte | %10.0g |  | M11_Q14_7 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q14_8 | byte | %10.0g |  | M11_Q14_8 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q14_98 | byte | %10.0g |  | M11_Q14_98 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q15 | byte | %80.0g | m11_q15 | Abakuru b'ekyaro bakakora ki aha nshonga ezirikukwata aha muntu owaabaire ari om | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q16 | byte | %20.0g | m11_q16 | Oine obwesigye ki ngu akakiiko k'ebyaro nikabaasa kuhwera omu kukyendeeza obunke | 0 | 133 | 0 | 2.270676691729324 | 0.8971995111800384 | 0 | 4 | 5 |
| m11_q17 | byte | %20.0g | m11_q17 | Oine obwesigye ki ngu nomanya ahu orikuza kutwara omuntu owabaire ari omu kihome | 0 | 133 | 0 | 2.406015037593985 | 0.8351881840654001 | 0 | 4 | 5 |
| m11_q18 | byte | %11.0g | m11_q18 | Omu kuteekateeka kwawe, obuhwezi bw'ababaireho abasibe bushemereire kuba buri om | 0 | 133 | 0 | 2.37593984962406 | 11.86323675986436 | 0 | 98 | 3 |
| m11_q19 | byte | %10.0g |  | Abakuru b'ebyaro bashemereire kukora ki kuhwera abantu kugaruka omu byaro byabo? | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q19_1 | byte | %10.0g |  | M11_Q19_1 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q19_2 | byte | %10.0g |  | M11_Q19_2 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q19_3 | byte | %10.0g |  | M11_Q19_3 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q19_4 | byte | %10.0g |  | M11_Q19_4 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q19_5 | byte | %10.0g |  | M11_Q19_5 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q19_6 | byte | %10.0g |  | M11_Q19_6 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q19_7 | byte | %10.0g |  | M11_Q19_7 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q19_98 | byte | %10.0g |  | M11_Q19_98 | 133 | 0 | 100 |  |  |  |  | 0 |
| m11_q20 | str222 | %222s |  | Enumerator notes on perceptions toward incarcerated and formerly incarcerated pe | 2 | 131 | 1.503759398496241 |  |  |  |  | 125 |
| instanceid | str41 | %41s |  | instanceID | 0 | 133 | 0 |  |  |  |  | 133 |
| formdef_version | double | %10.0g |  | Form version used on device | 0 | 133 | 0 | 2605180773.781955 | 3839.096317550457 | 2605161529 | 2605181811 | 3 |
| key | str41 | %41s |  | Unique submission ID | 0 | 133 | 0 |  |  |  |  | 133 |
| flag_duplicate_submission_key | byte | %12.0g |  | Duplicate SurveyCTO submission key flag | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| flag_no_consent | byte | %8.0g | yesno | Respondent did not consent or consent is missing | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| interview_dow | byte | %8.0g |  | Interview day of week; 0=Sunday | 0 | 133 | 0 | 3.210526315789474 | 1.370979696039933 | 1 | 6 | 6 |
| duration_hr | double | %10.0g |  | Survey duration in hours | 0 | 133 | 0 | 0.853452380952381 | 0.725517964449411 | 0.2830555555555556 | 7.695555555555556 | 132 |
| flag_duration_short | byte | %8.0g | yesno | Interview lasted less than 20 minutes | 0 | 133 | 0 | 0.0526315789473684 | 0.2241411038827122 | 0 | 1 | 2 |
| flag_duration_long | byte | %8.0g | yesno | Interview lasted more than 120 minutes | 0 | 133 | 0 | 0.0225563909774436 | 0.149045722775883 | 0 | 1 | 2 |
| flag_date_outside_fieldwork | byte | %8.0g | yesno | Interview date outside expected Phase 1 baseline fieldwork window | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| district_scto_key | str8 | %9s |  |  | 0 | 133 | 0 |  |  |  |  | 3 |
| subcounty_scto_key | str23 | %23s |  |  | 0 | 133 | 0 |  |  |  |  | 36 |
| parish_scto_key | str15 | %15s |  |  | 0 | 133 | 0 |  |  |  |  | 64 |
| village_scto_key | str15 | %15s |  |  | 0 | 133 | 0 |  |  |  |  | 116 |
| n_duplicate_scto_village | byte | %12.0g |  | Number of additional submissions with same SurveyCTO-selected village key | 0 | 133 | 0 | 0.075187969924812 | 0.2646913625903545 | 0 | 1 | 2 |
| flag_duplicate_scto_village | byte | %8.0g | yesno | SurveyCTO-selected village appears in multiple submissions | 0 | 133 | 0 | 0.075187969924812 | 0.2646913625903545 | 0 | 1 | 2 |
| replacement_notes | str1 | %9s |  |  | 133 | 0 | 100 |  |  |  |  | 0 |
| sample_district | str1 | %9s |  | District | 133 | 0 | 100 |  |  |  |  | 0 |
| sample_subcounty | str1 | %9s |  | Subcounty | 133 | 0 | 100 |  |  |  |  | 0 |
| sample_parish | str1 | %9s |  | Parish/Ward | 133 | 0 | 100 |  |  |  |  | 0 |
| sample_village | str1 | %9s |  | Village | 133 | 0 | 100 |  |  |  |  | 0 |
| sample_number_of_cases | byte | %10.0g |  | Police-recorded reported cases, Jan-Dec 2025 | 133 | 0 | 100 |  |  |  |  | 0 |
| sample_hotspot_p75 | byte | %9.0g | yesno | Village is at/above district p75 case threshold | 133 | 0 | 100 |  |  |  |  | 0 |
| phase1_selected | byte | %8.0g |  | Selected in Phase I primary sample | 133 | 0 | 100 |  |  |  |  | 0 |
| phase1_replacement | byte | %8.0g |  | Selected in Phase I replacement list | 133 | 0 | 100 |  |  |  |  | 0 |
| replacement_rank_stratum | byte | %9.0g |  | Replacement priority within district x hotspot stratum | 133 | 0 | 100 |  |  |  |  | 0 |
| district_fallback_rank | byte | %9.0g |  | Fallback replacement priority within district | 133 | 0 | 100 |  |  |  |  | 0 |
| sample_role | str1 | %9s |  | Sampling role in Phase I | 133 | 0 | 100 |  |  |  |  | 0 |
| sample_case_share_district | byte | %9.4f |  | Village share of district total cases | 133 | 0 | 100 |  |  |  |  | 0 |
| sample_case_rank_district | byte | %9.0g |  | Village rank by cases within district (descending) | 133 | 0 | 100 |  |  |  |  | 0 |
| sample_hotspot_p90 | byte | %9.0g | yesno | Village is at/above district p90 case threshold | 133 | 0 | 100 |  |  |  |  | 0 |
| merge_sampling_frame | byte | %23.0g | _merge | Merge status with original randomized sampling frame | 0 | 133 | 0 | 1 | 0 | 1 | 1 | 1 |
| respondent_female | byte | %8.0g | yesno | Respondent is female | 1 | 132 | 0.7518796992481203 | 0.1287878787878788 | 0.3362410765081268 | 0 | 1 | 2 |
| respondent_age_cat | byte | %8.0g |  | Respondent age category | 0 | 133 | 0 | 4.887218045112782 | 0.9016326549767327 | 3 | 6 | 4 |
| education_level | byte | %8.0g |  | Highest education level, cleaned | 0 | 133 | 0 | 2.398496240601504 | 1.236685756759011 | 0 | 6 | 7 |
| completed_secondary_or_above | byte | %8.0g | yesno | Completed secondary education or above | 0 | 133 | 0 | 0.1879699248120301 | 0.3921652392120015 | 0 | 1 | 2 |
| education_score | double | %10.0g |  | Education score normalized 0-1 | 0 | 133 | 0 | 0.399749373433584 | 0.2061142927931685 | 0 | 1 | 7 |
| lc_experience_years | byte | %10.0g |  | Years in LC1 position | 0 | 133 | 0 | 16.92481203007519 | 11.05812745131612 | 1 | 42 | 31 |
| lc_experience_score | double | %10.0g |  | LC experience score capped at 10 years, normalized 0-1 | 0 | 133 | 0 | 0.8488721804511279 | 0.245756883239521 | 0.1 | 1 | 10 |
| record_literacy_score | double | %10.0g |  | Comfort reading/writing LCC case records, normalized 0-1 | 0 | 133 | 0 | 0.6353383458646616 | 0.21211256614219 | 0.25 | 1 | 4 |
| can_record_english | byte | %8.0g | yesno | Can complete LCC records in English | 0 | 133 | 0 | 0.2180451127819549 | 0.414479335023521 | 0 | 1 | 2 |
| can_record_runyankore | byte | %8.0g | yesno | Can complete LCC records in Runyankore/Runyakitara | 0 | 133 | 0 | 0.9699248120300752 | 0.1714399631667259 | 0 | 1 | 2 |
| cannot_complete_records | byte | %8.0g | yesno | Cannot comfortably complete written LCC records | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| prior_justice_training | byte | %8.0g | yesno | Prior training on justice, mediation, mandate, records, or referrals | 0 | 133 | 0 | 0.7443609022556391 | 0.4378690709655921 | 0 | 1 | 2 |
| prior_formal_coordination | byte | %8.0g | yesno | Prior coordination with police/courts/probation/child protection/justice actors | 0 | 133 | 0 | 0.9548872180451128 | 0.2083361813430304 | 0 | 1 | 2 |
| n_case_types_handled | byte | %9.0g |  | Number of dispute/case types handled since Jan 2025 | 0 | 133 | 0 | 3.270676691729324 | 1.31499406352429 | 1 | 8 | 8 |
| case_experience_score | double | %10.0g |  | Breadth of case experience, capped at 5 types, normalized 0-1 | 0 | 133 | 0 | 0.6360902255639097 | 0.2199649923471507 | 0.2 | 1 | 5 |
| handled_child_or_sgbv_case | byte | %8.0g | yesno | Handled child-related or SGBV case since Jan 2025 | 0 | 133 | 0 | 0.0827067669172932 | 0.2764798415018575 | 0 | 1 | 2 |
| weekly_lc_time_score | double | %10.0g |  | Weekly time spent on LC/LCC duties, normalized 0-1 | 0 | 133 | 0 | 0.2744360902255639 | 0.0966516200450108 | 0 | 0.75 | 4 |
| lcc_members_total | byte | %10.0g |  | Number of current LCC/LC committee members | 0 | 133 | 0 | 9.210526315789474 | 2.153406855317756 | 5 | 11 | 7 |
| lcc_women_members | byte | %10.0g |  | Number of women LCC/LC committee members | 1 | 132 | 0.7518796992481203 | 3.272727272727273 | 1.254554506197922 | 1 | 9 | 7 |
| lcc_women_share | double | %10.0g |  | Share of current LCC/LC committee members who are women | 1 | 132 | 0.7518796992481203 | 0.3675890397481307 | 0.1381986047717676 | 0.0909090909090909 | 1 | 24 |
| lcc_has_woman_member | byte | %8.0g | yesno | LCC/LC committee has at least one woman member | 1 | 132 | 0.7518796992481203 | 1 | 0 | 1 | 1 | 1 |
| lcc_has_vacancy | byte | %8.0g | yesno | LCC/LC committee has vacancies | 0 | 133 | 0 | 0.6842105263157895 | 0.4665869150354483 | 0 | 1 | 2 |
| lcc_vacancies_count | byte | %10.0g |  |  | 133 | 0 | 100 |  |  |  |  | 0 |
| lcc_sittings_12m | byte | %10.0g |  | Number of LCC sittings/hearings in the past 12 months | 0 | 133 | 0 | 5.142857142857143 | 6.919606374711814 | 0 | 47 | 18 |
| meeting_frequency_score | double | %10.0g |  | LCC meeting/sitting frequency score, 0-1 | 0 | 133 | 0 | 0.6609022556390978 | 0.2166671048245565 | 0 | 1 | 6 |
| quorum_score | double | %10.0g |  | Quorum achievement score, 0-1 | 0 | 133 | 0 | 0.8289473684210527 | 0.2775849942398062 | 0 | 1 | 4 |
| fixed_place_score | double | %10.0g |  | LCC has fixed/regular hearing place score, 0-1 | 0 | 133 | 0 | 0.8984962406015038 | 0.2443249706305899 | 0 | 1 | 3 |
| inst_record_exist_score | double | %10.0g |  | Institutional record existence score from M2, 0-1 | 0 | 133 | 0 | 0.8533834586466166 | 0.2521269738374536 | 0 | 1 | 3 |
| inst_record_uptodate_score | double | %10.0g |  | Institutional record up-to-date score from M2, 0-1 | 2 | 131 | 1.503759398496241 | 0.8702290076335878 | 0.2673789176685832 | 0 | 1 | 3 |
| materials_score | double | %10.0g |  | Availability of basic materials score, 0-1 | 3 | 130 | 2.255639097744361 | 0.6884615384615385 | 0.3066787869321971 | 0 | 1 | 3 |
| n_materials_missing | byte | %9.0g |  | Number of basic LCC materials reported missing or insufficient | 0 | 133 | 0 | 1.62406015037594 | 1.725923133578431 | 0 | 6 | 7 |
| record_seen_score_m2 | double | %10.0g |  | Enumerator saw LCC records score from M2, 0-1 | 19 | 114 | 14.28571428571428 | 0.8070175438596491 | 0.3225230452754299 | 0 | 1 | 3 |
| recent_entries_uptodate_score_m2 | double | %10.0g |  | Enumerator-verified recent entries up-to-date score, 0-1 | 27 | 106 | 20.30075187969925 | 0.9245283018867925 | 0.2159414915267634 | 0 | 1 | 3 |
| caseload_30d | byte | %10.0g |  | Cases received by LCC in past 30 days | 0 | 133 | 0 | 1.233082706766917 | 2.865381718833098 | 0 | 30 | 8 |
| caseload_3m | byte | %10.0g |  | Cases received by LCC in past 3 months | 0 | 133 | 0 | 2.684210526315789 | 5.645282853923039 | 0 | 60 | 12 |
| pending_cases | byte | %10.0g |  | Pending/unresolved LCC cases | 0 | 133 | 0 | 0.3233082706766917 | 0.7542693854084302 | 0 | 5 | 5 |
| directly_brought_cases_3m | byte | %10.0g |  | Cases brought directly by community/parties in past 3 months | 38 | 95 | 28.57142857142857 | 0.2315789473684211 | 0.5147325597460394 | 0 | 2 | 3 |
| referred_to_lcc_cases_3m | byte | %10.0g |  | Cases referred to LCC by another actor in past 3 months | 133 | 0 | 100 |  |  |  |  | 0 |
| referred_onward_cases_3m | byte | %10.0g |  | Cases referred onward by LCC in past 3 months | 133 | 0 | 100 |  |  |  |  | 0 |
| flag_caseload_30d_gt_3m | byte | %8.0g | yesno |  | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| flag_pending_gt_3m | byte | %8.0g | yesno |  | 0 | 133 | 0 | 0.0451127819548872 | 0.2083361813430304 | 0 | 1 | 2 |
| flag_direct_gt_3m | byte | %8.0g | yesno |  | 38 | 95 | 28.57142857142857 | 0 | 0 | 0 | 0 | 1 |
| flag_referred_to_lcc_gt_3m | byte | %8.0g | yesno |  | 133 | 0 | 100 |  |  |  |  | 0 |
| flag_referred_onward_gt_3m | byte | %8.0g | yesno |  | 133 | 0 | 100 |  |  |  |  | 0 |
| pending_share_3m | double | %10.0g |  | Pending cases as share of 3-month caseload | 41 | 92 | 30.82706766917293 | 0.1043478260869565 | 0.2370693778148964 | 0 | 1 | 10 |
| directly_brought_share_3m | double | %10.0g |  | Directly brought cases as share of 3-month caseload | 38 | 95 | 28.57142857142857 | 0.1228070175438596 | 0.2795328405280527 | 0 | 1 | 5 |
| referred_to_lcc_share_3m | byte | %10.0g |  | Cases referred to LCC as share of 3-month caseload | 133 | 0 | 100 |  |  |  |  | 0 |
| referred_onward_share_3m | byte | %10.0g |  | Cases referred onward as share of 3-month caseload | 133 | 0 | 100 |  |  |  |  | 0 |
| n_case_types_received_3m | byte | %9.0g |  | Number of case/dispute types received in past 3 months | 0 | 133 | 0 | 1.954887218045113 | 1.561199333331907 | 0 | 6 | 7 |
| any_child_or_sgbv_case_3m | byte | %8.0g | yesno | LCC received child-related or SGBV case in past 3 months | 0 | 133 | 0 | 0.0451127819548872 | 0.2083361813430304 | 0 | 1 | 2 |
| any_reintegration_case_3m | byte | %8.0g | yesno | LCC received reintegration-related case in past 3 months | 37 | 96 | 27.81954887218045 | 0 | 0 | 0 | 0 | 1 |
| any_serious_or_sensitive_case_3m | byte | %8.0g | yesno |  | 0 | 133 | 0 | 0.0451127819548872 | 0.2083361813430304 | 0 | 1 | 2 |
| petty_case_share_score | double | %10.0g |  | Perceived share of cases that are petty/minor and locally handleable, 0-1 | 37 | 96 | 27.81954887218045 | 0.6020833333333333 | 0.3314971355490013 | 0.2 | 1 | 5 |
| caseload_accuracy_score | double | %10.0g |  | Respondent confidence in reported caseload, 0-1 | 0 | 133 | 0 | 0.6785714285714286 | 0.1886239760184381 | 0 | 1 | 5 |
| m4_q01_local_scope_score | float | %9.0g |  | Knowledge score: cases LCC can handle locally, 0-1 | 0 | 133 | 0 | 0.9047618983383465 | 0.0606006464549928 | 0.6000000238418579 | 1 | 10 |
| m4_q02_referral_scope_score | float | %9.0g |  | Knowledge score: cases requiring referral, 0-1 | 0 | 133 | 0 | 0.8295739272091174 | 0.1490704885252699 | 0 | 1 | 11 |
| m4_q04_correct_refer | byte | %8.0g | yesno | Correct response: outside mandate cases should be referred | 0 | 133 | 0 | 0.4887218045112782 | 0.5017626710722586 | 0 | 1 | 2 |
| m4_q05_documentation_score | float | %9.0g |  | Knowledge score: what should be documented, 0-1 | 0 | 133 | 0 | 0.7725564026294794 | 0.1349678160822734 | 0 | 1 | 8 |
| m4_q06_procedure_score | float | %9.0g |  | Knowledge score: LCC procedural steps before resolution, 0-1 | 0 | 133 | 0 | 0.714912288843241 | 0.1205916854975065 | 0.25 | 1 | 9 |
| m4_q07_correct_adr_scope | byte | %8.0g | yesno | Correct response: ADR for eligible petty/minor disputes only | 0 | 133 | 0 | 0.2406015037593985 | 0.4290648029718084 | 0 | 1 | 2 |
| m4_q08_authority_score | float | %9.0g |  | Knowledge score: when formal authority involvement is needed, 0-1 | 0 | 133 | 0 | 0.835588982006661 | 0.0797930254938311 | 0.2666666805744171 | 1 | 6 |
| classification_confidence_score | double | %10.0g |  | Self-confidence distinguishing handle vs refer cases, 0-1 | 0 | 133 | 0 | 0.6127819548872181 | 0.2142334940548218 | 0 | 1 | 5 |
| v01_boundary_q1_correct | byte | %8.0g |  |  | 0 | 133 | 0 | 0.9699248120300752 | 0.1714399631667259 | 0 | 1 | 2 |
| v01_boundary_q2_correct | byte | %8.0g |  |  | 0 | 133 | 0 | 0.9473684210526315 | 0.2241411038827122 | 0 | 1 | 2 |
| v01_boundary_q3_correct | byte | %8.0g |  |  | 0 | 133 | 0 | 0.7293233082706767 | 0.445989189107868 | 0 | 1 | 2 |
| v02_family_q1_correct | byte | %8.0g |  |  | 0 | 133 | 0 | 0.9624060150375939 | 0.1909313313651758 | 0 | 1 | 2 |
| v02_family_q2_correct | byte | %8.0g |  |  | 0 | 133 | 0 | 0.9473684210526315 | 0.2241411038827122 | 0 | 1 | 2 |
| v02_family_q3_correct | byte | %8.0g |  |  | 0 | 133 | 0 | 0.7593984962406015 | 0.4290648029718084 | 0 | 1 | 2 |
| v05_child_q1_correct | byte | %8.0g |  |  | 0 | 133 | 0 | 0.3834586466165413 | 0.4880667569726408 | 0 | 1 | 2 |
| v05_child_q2_correct | byte | %8.0g |  |  | 0 | 133 | 0 | 0.4511278195488722 | 0.4994870916755633 | 0 | 1 | 2 |
| v05_child_q3_correct | byte | %8.0g |  |  | 0 | 133 | 0 | 0.1804511278195489 | 0.3860166911559539 | 0 | 1 | 2 |
| v06_sgbv_q1_correct | byte | %8.0g |  |  | 0 | 133 | 0 | 0.443609022556391 | 0.4986881857279591 | 0 | 1 | 2 |
| v06_sgbv_q2_correct | byte | %8.0g |  |  | 0 | 133 | 0 | 0.4360902255639098 | 0.4977735803075746 | 0 | 1 | 2 |
| v06_sgbv_q3_correct | byte | %8.0g |  |  | 0 | 133 | 0 | 0.443609022556391 | 0.4986881857279591 | 0 | 1 | 2 |
| idx_vignette_classification | float | %9.0g |  | Index: case-vignette classification/referral performance, 0-1 | 0 | 133 | 0 | 0.6378446147406012 | 0.2354890332237526 | 0.25 | 1 | 10 |
| idx_safeguard_classif_know | float | %9.0g |  | Index: serious/sensitive-case classification and referral knowledge, 0-1 | 0 | 133 | 0 | 0.4570802043234103 | 0.3447776325169384 | 0 | 0.9930555820465088 | 38 |
| m5_q01_score | double | %10.0g |  |  | 2 | 131 | 1.503759398496241 | 0.6851145038167938 | 0.2851918825369057 | 0 | 1 | 5 |
| m5_q02_score | double | %10.0g |  |  | 0 | 133 | 0 | 0.7556390977443609 | 0.2690931836559389 | 0 | 1 | 5 |
| m5_q03_score | double | %10.0g |  |  | 1 | 132 | 0.7518796992481203 | 0.7102272727272727 | 0.2976202455281401 | 0 | 1 | 5 |
| m5_q06_score | double | %10.0g |  |  | 1 | 132 | 0.7518796992481203 | 0.6628787878787878 | 0.3073291253726798 | 0 | 1 | 5 |
| m5_q07_score | double | %10.0g |  |  | 0 | 133 | 0 | 0.6390977443609023 | 0.3037230063990636 | 0 | 1 | 5 |
| m5_q14_score | double | %10.0g |  |  | 0 | 133 | 0 | 0.6560150375939849 | 0.3040158983323476 | 0 | 1 | 5 |
| m5_q16_score | double | %10.0g |  |  | 2 | 131 | 1.503759398496241 | 0.5438931297709924 | 0.2982012034208911 | 0 | 1 | 5 |
| adr_confidence_score | double | %10.0g |  |  | 0 | 133 | 0 | 0.6146616541353384 | 0.2029873442546262 | 0 | 1 | 5 |
| deescalation_confidence_score | double | %10.0g |  |  | 0 | 133 | 0 | 0.6353383458646616 | 0.2053066770090925 | 0 | 1 | 5 |
| noncomp_response_app | byte | %8.0g | yesno | Appropriate response to noncompliance with mediated agreement | 0 | 133 | 0 | 0.8872180451127819 | 0.317522018762762 | 0 | 1 | 2 |
| n_adr_barriers | byte | %9.0g |  | Number of reported barriers to local mediation/ADR | 0 | 133 | 0 | 1.954887218045113 | 1.0065291521628 | 0 | 3 | 4 |
| n_adr_methods | byte | %9.0g |  | Number of ADR/local resolution methods used by LCC | 0 | 133 | 0 | 2.639097744360902 | 0.9561471443171196 | 1 | 5 | 5 |
| adr_methods_score | double | %10.0g |  | ADR method breadth score, capped at 5 methods, normalized 0-1 | 0 | 133 | 0 | 0.5278195488721805 | 0.1912294288634239 | 0.2 | 1 | 5 |
| referral_frequency_score | double | %10.0g |  |  | 2 | 131 | 1.503759398496241 | 0.7061068702290076 | 0.2747042396107661 | 0 | 1 | 5 |
| referral_documentation_score | double | %10.0g |  |  | 0 | 133 | 0 | 0.5413533834586466 | 0.2772641830535899 | 0 | 1 | 5 |
| referral_feedback_score | double | %10.0g |  |  | 3 | 130 | 2.255639097744361 | 0.5 | 0.2835954100283488 | 0 | 1 | 5 |
| police_coordination_score | double | %10.0g |  |  | 0 | 133 | 0 | 0.7781954887218046 | 0.2814568016439031 | 0 | 1 | 5 |
| court_coordination_score | double | %10.0g |  |  | 3 | 130 | 2.255639097744361 | 0.7326923076923076 | 0.3207737459088582 | 0 | 1 | 5 |
| referral_path_conf_score | double | %10.0g |  |  | 0 | 133 | 0 | 0.5958646616541353 | 0.2147977477858228 | 0 | 1 | 5 |
| referral_explain_conf_score | double | %10.0g |  |  | 0 | 133 | 0 | 0.5902255639097744 | 0.222627104197476 | 0 | 1 | 5 |
| verified_referral_record_score | double | %10.0g |  | Enumerator-verified referred cases are recorded, 0-1 | 37 | 96 | 27.81954887218045 | 0.7291666666666666 | 0.3901191900639346 | 0 | 1 | 3 |
| verified_ref_dest_score | double | %10.0g |  | Enumerator-verified referral destination is recorded, 0-1 | 34 | 99 | 25.56390977443609 | 0.7424242424242424 | 0.3736447371640468 | 0 | 1 | 3 |
| n_referral_reasons | byte | %9.0g |  | Number of reasons for onward referral reported | 0 | 133 | 0 | 2.263157894736842 | 1.173538658270847 | 1 | 6 | 6 |
| n_referral_barriers | byte | %9.0g |  | Number of referral barriers reported | 0 | 133 | 0 | 1.969924812030075 | 0.9995442114621935 | 0 | 3 | 4 |
| no_major_referral_barriers | byte | %8.0g | yesno | Respondent reports no major referral barriers | 0 | 133 | 0 | 0.1503759398496241 | 0.3587909115412519 | 0 | 1 | 2 |
| case_register_score | double | %10.0g |  | Current case register/case book score, 0-1 | 0 | 133 | 0 | 0.8157894736842105 | 0.3106303720986978 | 0 | 1 | 3 |
| n_record_types | byte | %9.0g |  | Number of written record types kept by LCC | 0 | 133 | 0 | 1.969924812030075 | 1.086695363239284 | 0 | 4 | 5 |
| record_type_breadth_score | double | %10.0g |  | Breadth of written record types kept, 0-1 | 0 | 133 | 0 | 0.3283208020050125 | 0.1811158938732141 | 0 | 0.6666666666666666 | 5 |
| record_uptodate_score | double | %10.0g |  | Self-reported record up-to-date score, 0-1 | 11 | 122 | 8.270676691729323 | 0.7622950819672131 | 0.3353369759117381 | 0 | 1 | 3 |
| most_recent_entry_score | double | %10.0g |  | Recency of most recent case entry score, 0-1 | 11 | 122 | 8.270676691729323 | 0.6885245901639344 | 0.2516710174875508 | 0 | 1 | 5 |
| n_record_fields | byte | %9.0g |  | Number of core fields usually included in case records | 0 | 133 | 0 | 3.390977443609023 | 1.937800168209198 | 0 | 11 | 11 |
| record_fields_score | double | %10.0g |  | Completeness of fields usually included in case records, 0-1 | 0 | 133 | 0 | 0.2825814536340852 | 0.1614833473507665 | 0 | 0.9166666666666666 | 11 |
| outcome_recorded_score | double | %10.0g |  | Outcome/resolution/decision usually recorded, 0-1 | 10 | 123 | 7.518796992481203 | 0.6382113821138211 | 0.2848699229194611 | 0 | 1 | 5 |
| record_retrieval_score | double | %10.0g |  | Ease of retrieving a recent case record, 0-1 | 10 | 123 | 7.518796992481203 | 0.6788617886178862 | 0.3045426650559779 | 0 | 1 | 5 |
| secure_storage_score | double | %10.0g |  | Secure/confidential record storage score, 0-1 | 11 | 122 | 8.270676691729323 | 0.7131147540983607 | 0.3396524280004977 | 0 | 1 | 3 |
| records_access_open_to_community | byte | %8.0g | yesno | Any community member can access records upon request | 10 | 123 | 7.518796992481203 | 0.008130081300813 | 0.0901669634667432 | 0 | 1 | 2 |
| n_record_challenges | byte | %9.0g |  | Number of reported record-keeping challenges | 0 | 133 | 0 | 2.195488721804511 | 0.9248967724262886 | 0 | 3 | 4 |
| no_major_record_challenges | byte | %8.0g | yesno | Respondent reports no major record-keeping challenges | 0 | 133 | 0 | 0.0676691729323308 | 0.2521269738374536 | 0 | 1 | 2 |
| verified_case_register_score | double | %10.0g |  | Enumerator-verified case register score, 0-1 | 19 | 114 | 14.28571428571428 | 0.7763157894736842 | 0.3525639668513185 | 0 | 1 | 3 |
| verified_proceedings_score | double | %10.0g |  | Enumerator-verified proceedings book/notes score, 0-1 | 19 | 114 | 14.28571428571428 | 0.7543859649122807 | 0.3718264774848548 | 0 | 1 | 3 |
| verified_storage_score | double | %10.0g |  | Enumerator-verified storage security score, 0-1 | 37 | 96 | 27.81954887218045 | 0.6354166666666666 | 0.3515317359834084 | 0 | 1 | 3 |
| verified_record_usability_score | double | %10.0g |  | Enumerator-rated overall record usability score, 0-1 | 26 | 107 | 19.54887218045113 | 0.6004672897196262 | 0.2700886757860612 | 0 | 1 | 5 |
| collective_handling_score | double | %10.0g |  | Collective rather than chair-alone case handling score, 0-1 | 0 | 133 | 0 | 0.8796992481203008 | 0.2145324014859042 | 0.5 | 1 | 2 |
| active_member_part_score | double | %10.0g |  | Different members actively participate, 0-1 | 0 | 133 | 0 | 0.6428571428571429 | 0.2875011763574654 | 0 | 1 | 5 |
| collective_discussion_score | double | %10.0g |  | Committee discusses collectively before decision/referral, 0-1 | 0 | 133 | 0 | 0.6560150375939849 | 0.2710835157279586 | 0 | 1 | 5 |
| women_participation_score | double | %10.0g |  | Women members participate actively when present, 0-1 | 1 | 132 | 0.7518796992481203 | 0.7367424242424242 | 0.2802575048524825 | 0 | 1 | 5 |
| women_perspective_mechanism | byte | %8.0g | yesno | Mechanism exists to consider women's perspectives where no women serve | 1 | 132 | 0.7518796992481203 | 0.9772727272727273 | 0.1496004393852536 | 0 | 1 | 2 |
| record_validation_score | double | %10.0g |  | Decision/agreement/referral validated by more than one member, 0-1 | 0 | 133 | 0 | 0.6954887218045113 | 0.3051613238665082 | 0 | 1 | 5 |
| case_review_score | double | %10.0g |  | LCC case review meetings for pending/referral/follow-up cases, 0-1 | 1 | 132 | 0.7518796992481203 | 0.6687878787878788 | 0.3171317791520394 | 0 | 1 | 4 |
| decision_process_score | double | %10.0g |  | Decision process when committee members disagree, 0-1 | 1 | 132 | 0.7518796992481203 | 0.8946969696969697 | 0.2755464782394006 | 0 | 1 | 4 |
| similar_case_consistency_score | double | %10.0g |  | Consistency across similar cases, 0-1 | 0 | 133 | 0 | 0.6259398496240601 | 0.2232339362505545 | 0 | 1 | 5 |
| procedure_confidence_score | double | %10.0g |  | Confidence LCC follows same basic procedure across similar cases, 0-1 | 0 | 133 | 0 | 0.5864661654135338 | 0.2088140955444898 | 0 | 1 | 5 |
| n_committee_challenges | byte | %9.0g |  | Number of committee-functioning challenges reported | 0 | 133 | 0 | 1.706766917293233 | 0.9275411849650311 | 0 | 3 | 4 |
| no_major_committee_challenges | byte | %8.0g | yesno | Respondent reports no major committee-functioning challenges | 0 | 133 | 0 | 0.1203007518796992 | 0.3265428178560505 | 0 | 1 | 2 |
| verified_member_part_score | double | %10.0g |  | Enumerator-verified more than one member participates, 0-1 | 28 | 105 | 21.05263157894737 | 0.8428571428571429 | 0.304724700110022 | 0 | 1 | 3 |
| verified_multimember_val_score | double | %10.0g |  | Enumerator-verified decisions validated by more than one member, 0-1 | 30 | 103 | 22.55639097744361 | 0.8495145631067961 | 0.3195811555488138 | 0 | 1 | 3 |
| perceived_lcc_fairness_score | double | %10.0g |  | Perceived community view of LCC fairness, 0-1 | 0 | 133 | 0 | 0.6823308270676691 | 0.2502419653844301 | 0 | 1 | 5 |
| perc_willing_use_lcc_score | double | %10.0g |  | Perceived willingness of community to use LCC for eligible petty disputes, 0-1 | 0 | 133 | 0 | 0.6597744360902256 | 0.2350417956559472 | 0 | 1 | 5 |
| bypass_frequency_score | double | %10.0g |  | Perceived frequency of bypassing LCC for eligible petty disputes, 0-1 | 0 | 133 | 0 | 0.5582706766917294 | 0.3013341829521631 | 0 | 1 | 5 |
| low_bypass_score | double | %10.0g |  | Inverse bypass score: higher means less perceived bypass, 0-1 | 0 | 133 | 0 | 0.4417293233082707 | 0.3013341829521631 | 0 | 1 | 5 |
| perc_favor_influence_score | double | %10.0g |  | Perceived influence of connections/favoritism/gifts/pressure, 0-1 | 2 | 131 | 1.503759398496241 | 0.482824427480916 | 0.2724370775883158 | 0 | 1 | 5 |
| low_favoritism_influence_score | double | %10.0g |  | Inverse favoritism/corruption-risk score, 0-1 | 2 | 131 | 1.503759398496241 | 0.517175572519084 | 0.2724370775883158 | 0 | 1 | 5 |
| conf_trust_when_referring | double | %10.0g |  | Confidence maintaining trust while referring serious/ineligible cases, 0-1 | 0 | 133 | 0 | 0.6240601503759399 | 0.1985364541520019 | 0 | 1 | 5 |
| conf_fair_respect_score | double | %10.0g |  | Confidence LCC handles petty disputes fairly/respectfully, 0-1 | 0 | 133 | 0 | 0.6390977443609023 | 0.2050811319373183 | 0 | 1 | 5 |
| bypass_due_distrust | byte | %8.0g | yesno | Bypass reason: community does not trust LCC | 0 | 133 | 0 | 0.1203007518796992 | 0.3265428178560505 | 0 | 1 | 2 |
| bypass_due_bias | byte | %8.0g | yesno | Bypass reason: perceived LCC bias/favoritism | 0 | 133 | 0 | 0.0601503759398496 | 0.2386641642064697 | 0 | 1 | 2 |
| bypass_due_enforcement | byte | %8.0g | yesno | Bypass reason: LCC cannot enforce agreements/decisions | 0 | 133 | 0 | 0.0300751879699248 | 0.1714399631667259 | 0 | 1 | 2 |
| bypass_due_mandate_uncertainty | byte | %8.0g | yesno | Bypass reason: people do not know which cases LCC can handle | 0 | 133 | 0 | 0.0300751879699248 | 0.1714399631667259 | 0 | 1 | 2 |
| bypass_due_serious_case | byte | %8.0g | yesno | Bypass reason: case is serious and should go to police/court | 0 | 133 | 0 | 0.0075187969924812 | 0.086710996952412 | 0 | 1 | 2 |
| eligible_cases_rarely_bypass | byte | %8.0g | yesno | Respondent says people rarely bypass LCC for eligible petty cases | 0 | 133 | 0 | 0.1503759398496241 | 0.3587909115412519 | 0 | 1 | 2 |
| vulnerable_need_sh | byte | %8.0g | yesno | Respondent says vulnerable/sensitive cases require special handling | 0 | 133 | 0 | 0.849624060150376 | 0.3587909115412519 | 0 | 1 | 2 |
| n_m10_q08_nonmiss | byte | %9.0g |  | Number of non-missing M10_Q08 special-handling items | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| n_special_handling_practices | byte | %9.0g |  | Number of special-handling practices identified for vulnerable/sensitive cases | 133 | 0 | 100 |  |  |  |  | 0 |
| special_handling_practices_score | byte | %10.0g |  | Special-handling knowledge breadth score, 0-1 | 133 | 0 | 100 |  |  |  |  | 0 |
| sh_includes_confidentiality | byte | %8.0g | yesno | Special handling includes confidentiality | 133 | 0 | 100 |  |  |  |  | 0 |
| sh_includes_referral | byte | %8.0g | yesno | Special handling includes referral | 133 | 0 | 100 |  |  |  |  | 0 |
| sh_avoid_unsafe_mediation | byte | %8.0g | yesno | Special handling includes avoiding unsafe mediation | 133 | 0 | 100 |  |  |  |  | 0 |
| verif_sensitive_ref_score | byte | %10.0g |  | Enumerator-verified sensitive/serious cases marked as referred, 0-1 | 133 | 0 | 100 |  |  |  |  | 0 |
| verif_sensitive_conf_score | byte | %10.0g |  | Enumerator-verified sensitive case record confidentiality, 0-1 | 133 | 0 | 100 |  |  |  |  | 0 |
| reintegration_importance_score | double | %10.0g |  | Importance of community leaders supporting reintegration, 0-1 | 0 | 133 | 0 | 0.6221804511278195 | 0.2167610692216155 | 0 | 1 | 5 |
| reintegration_willingness_score | double | %10.0g |  | Willingness to support peaceful return of formerly incarcerated persons, 0-1 | 0 | 133 | 0 | 0.6221804511278195 | 0.2055492949276389 | 0 | 1 | 5 |
| fair_chance_reintegration_score | double | %10.0g |  | Agreement that formerly incarcerated persons deserve fair chance, 0-1 | 0 | 133 | 0 | 0.7763157894736842 | 0.1546720562224365 | 0 | 1 | 5 |
| exclusion_norm_score | double | %10.0g |  |  | 0 | 133 | 0 | 0.556390977443609 | 0.3102060369698214 | 0 | 1 | 5 |
| low_exclusion_norm_score | double | %10.0g |  | Reverse-coded norm against avoiding formerly incarcerated persons, 0-1 | 0 | 133 | 0 | 0.443609022556391 | 0.3102060369698214 | 0 | 1 | 5 |
| perceived_reoffending_risk_score | double | %10.0g |  |  | 1 | 132 | 0.7518796992481203 | 0.6401515151515151 | 0.2189879039096806 | 0 | 1 | 5 |
| low_reoffending_stigma_score | double | %10.0g |  | Reverse-coded belief that most formerly incarcerated persons reoffend, 0-1 | 1 | 132 | 0.7518796992481203 | 0.3598484848484849 | 0.2189879039096806 | 0 | 1 | 5 |
| comm_role_reint_score | double | %10.0g |  | Agreement community has role in avoiding future conflict/offending, 0-1 | 1 | 132 | 0.7518796992481203 | 0.6950757575757576 | 0.1886937670630096 | 0 | 1 | 5 |
| reint_mediation_comfort | double | %10.0g |  | Comfort mediating eligible disputes involving formerly incarcerated persons, 0-1 | 0 | 133 | 0 | 0.6973684210526315 | 0.2110862768347165 | 0 | 1 | 5 |
| connect_support_willing_score | double | %10.0g |  | Willingness to connect formerly incarcerated person to support/resources, 0-1 | 1 | 132 | 0.7518796992481203 | 0.7272727272727273 | 0.1940295519676836 | 0 | 1 | 5 |
| community_stigma_level_score | double | %10.0g |  | Perceived level of community stigma toward formerly incarcerated persons, 0-1 | 0 | 133 | 0 | 0.3928571428571428 | 0.3066277266826384 | 0 | 1 | 5 |
| n_reintegration_support_types | byte | %9.0g |  | Number of support types identified for successful reintegration | 0 | 133 | 0 | 2.165413533834586 | 0.8181691601765081 | 0 | 4 | 5 |
| reint_support_breadth_score | double | %10.0g |  | Breadth of reintegration support identified, 0-1 | 0 | 133 | 0 | 0.2706766917293233 | 0.1022711450220635 | 0 | 0.5 | 5 |
| no_reintegration_support_needed | byte | %8.0g | yesno | Respondent says formerly incarcerated persons should manage on their own | 0 | 133 | 0 | 0.0150375939849624 | 0.122162485315295 | 0 | 1 | 2 |
| n_reintegration_barriers | byte | %9.0g |  | Number of perceived barriers to accepting/supporting formerly incarcerated perso | 0 | 133 | 0 | 1.759398496240602 | 0.9386513208422677 | 0 | 3 | 4 |
| comm_accepts_ex_prisoner | byte | %8.0g | yesno | Respondent says community members are usually willing to accept them | 0 | 133 | 0 | 0.0902255639097744 | 0.2875878420888012 | 0 | 1 | 2 |
| recent_reintegration_issue | byte | %8.0g | yesno | LCC handled reintegration-related dispute/tension/concern in past 6 months | 0 | 133 | 0 | 0.6165413533834586 | 0.4880667569726408 | 0 | 1 | 2 |
| n_m11_q14_nonmiss | byte | %9.0g |  | Number of non-missing M11_Q14 reintegration issue-type items | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| n_reintegration_issue_types | byte | %9.0g |  | Number of recent reintegration-related issue types handled | 133 | 0 | 100 |  |  |  |  | 0 |
| recent_reint_stigma | byte | %8.0g | yesno | Recent reintegration issue involved stigma/exclusion/refusal to accept | 133 | 0 | 100 |  |  |  |  | 0 |
| recent_reint_serious_ref | byte | %8.0g | yesno | Recent reintegration issue involved serious allegation requiring referral | 133 | 0 | 100 |  |  |  |  | 0 |
| reint_response_supportive | byte | %8.0g | yesno | LCC response to recent reintegration issue was active/supportive or referral-ori | 133 | 0 | 100 |  |  |  |  | 0 |
| reint_tension_conf_score | double | %10.0g |  | Confidence LCC can reduce reintegration-related community tensions, 0-1 | 0 | 133 | 0 | 0.5676691729323309 | 0.2242998777950096 | 0 | 1 | 5 |
| reint_referral_conf_score | double | %10.0g |  | Confidence knowing where to refer formerly incarcerated persons for support, 0-1 | 0 | 133 | 0 | 0.6015037593984962 | 0.20879704601635 | 0 | 1 | 5 |
| reint_comm_justice_role | byte | %8.0g | yesno | Support for reintegration is part of community justice/local leadership role | 0 | 133 | 0 | 0.9022556390977443 | 0.298091445551766 | 0 | 1 | 2 |
| n_m11_q19_nonmiss | byte | %9.0g |  | Number of non-missing M11_Q19 reintegration leadership-role items | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| n_reintegration_leadership_roles | byte | %9.0g |  | Number of reintegration roles identified for LC/community leaders | 133 | 0 | 100 |  |  |  |  | 0 |
| reint_leadership_role_score | byte | %10.0g |  | Breadth of LC/community leader reintegration roles identified, 0-1 | 133 | 0 | 100 |  |  |  |  | 0 |
| high_operational_capacity | byte | %8.0g | yesno | Operational capacity index >= 0.75 | 0 | 133 | 0 | 0.4060150375939849 | 0.4929440619958883 | 0 | 1 | 2 |
| high_case_handling_quality | byte | %8.0g | yesno | Case-handling quality index >= 0.75 | 0 | 133 | 0 | 0.2556390977443609 | 0.4378690709655921 | 0 | 1 | 2 |
| high_legitimacy_norms | byte | %8.0g | yesno | Legitimacy and reintegration norms index >= 0.75 | 0 | 133 | 0 | 0.0526315789473684 | 0.2241411038827122 | 0 | 1 | 2 |
| p1_admin_last_cdfu | byte | %8.0g | yesno | Admin list: village belongs to last CDFU phase | 0 | 133 | 0 | 0.1578947368421053 | 0.3660208899312015 | 0 | 1 | 2 |
| p1_admin_inherited_fhri | byte | %8.0g | yesno | Admin list: village inherited from FHRI | 0 | 133 | 0 | 0.0526315789473684 | 0.2241411038827122 | 0 | 1 | 2 |
| p1_admin_previously_contacted | byte | %8.0g | yesno | Admin list: previously contacted/added village | 0 | 133 | 0 | 0.2105263157894737 | 0.4092237955355674 | 0 | 1 | 2 |
| p1_admin_new | byte | %8.0g | yesno | Admin list: new/randomly selected Phase 1 village | 0 | 133 | 0 | 0.7894736842105263 | 0.4092237955355674 | 0 | 1 | 2 |
| p1_admin_origin | byte | %23.0g | p1_admin_origin_lbl | Admin list Phase 1 origin group | 0 | 133 | 0 | 0.2631578947368421 | 0.5490313348968022 | 0 | 2 | 3 |
| p1_admin_origin_detail | str23 | %23s |  | Text label for admin Phase 1 origin group | 0 | 133 | 0 |  |  |  |  | 3 |
| p1_admin_match_note | strL | %9s |  | Audit note: admin village matched to SurveyCTO submission | 105 | 28 | 78.94736842105263 |  |  |  |  |  |
| __000000 | byte | %8.0g |  | tag(qa_village_key) | 0 | 133 | 0 | 0.9624060150375939 | 0.1909313313651758 | 0 | 1 | 2 |
| __000002 | byte | %8.0g |  | tag(submission_key) | 0 | 133 | 0 | 1 | 0 | 1 | 1 | 1 |
| __000003 | byte | %8.0g |  |  | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| __000004 | byte | %8.0g |  |  | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| __000005 | byte | %8.0g |  |  | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| __000006 | byte | %8.0g |  |  | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| __000007 | byte | %8.0g |  |  | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| __000008 | byte | %8.0g |  |  | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| __000009 | byte | %8.0g |  |  | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| __00000A | byte | %8.0g |  |  | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| __00000B | byte | %8.0g |  |  | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
| __00000C | byte | %8.0g |  |  | 0 | 133 | 0 | 0.075187969924812 | 0.2646913625903545 | 0 | 1 | 2 |
| __00000D | byte | %8.0g |  |  | 5 | 128 | 3.759398496240602 | 0 | 0 | 0 | 0 | 1 |
| __00000E | double | %10.0g |  |  | 8 | 125 | 6.015037593984962 | 2095009711705.304 | 310171032.7315162 | 2094722621328 | 2095779294524 | 125 |
| __00000F | byte | %8.0g |  |  | 12 | 121 | 9.022556390977442 | 0.0826446280991736 | 0.2764892059226464 | 0 | 1 | 2 |
| __00000G | byte | %10.0g |  |  | 0 | 133 | 0 | 0.8571428571428571 | 1.518286799387654 | 0 | 7 | 8 |
| __00000H | byte | %8.0g |  |  | 0 | 133 | 0 | 0 | 0 | 0 | 0 | 1 |
## Sheet: module_completeness
| module_number | module | n_fields | n_eligible | n_all_missing | pct_all_missing | mean_response_density |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | M1 | 0 | 133 | 133 | 100 |  |
| 2 | M2 | 0 | 133 | 133 | 100 |  |
| 3 | M3 | 0 | 133 | 133 | 100 |  |
| 4 | M4 | 96 | 133 | 0 | 0 | 0.9995300751879699 |
| 5 | M5 | 0 | 133 | 133 | 100 |  |
| 6 | M6 | 0 | 133 | 133 | 100 |  |
| 7 | M7 | 55 | 133 | 0 | 0 | 0.9326042378673958 |
| 8 | M8 | 26 | 133 | 0 | 0 | 0.9861191440138809 |
| 9 | M9 | 0 | 133 | 133 | 100 |  |
| 10 | M10 | 13 | 133 | 0 | 0 | 0.1515326778484673 |
| 11 | M11 | 0 | 133 | 133 | 100 |  |
## Sheet: enumerator_summary
| qa_enumerator | n_interviews | median_duration_min | p10_duration_min | p90_duration_min | total_issues | total_errors | total_warnings | n_records_with_error | n_records_with_warning | n_short | n_long | n_outside_fieldwork | pct_records_with_error | pct_short |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Akankwasa Ronals | 27 | 41.53333333333333 | 21.116666666666667 | 77.03333333333333 | 99 | 34 | 38 | 25 | 24 | 2 | 1 | 0 | 92.5925925925926 | 7.4074074074074066 |
| Nayebare Christine | 25 | 40.983333333333334 | 17.95 | 64.13333333333334 | 99 | 30 | 44 | 24 | 25 | 3 | 1 | 0 | 96 | 12 |
| Ashabe Gina | 18 | 44.59166666666667 | 29.366666666666667 | 74.1 | 67 | 20 | 29 | 16 | 18 | 0 | 0 | 0 | 88.88888888888889 | 0 |
| Natukunda Britah | 17 | 32.93333333333333 | 19.266666666666666 | 65.56666666666666 | 56 | 18 | 21 | 14 | 14 | 2 | 0 | 0 | 82.35294117647058 | 11.76470588235294 |
| Natuhwera Sylivia | 18 | 45.84166666666667 | 28.416666666666668 | 70.88333333333334 | 40 | 14 | 8 | 13 | 7 | 0 | 0 | 0 | 72.22222222222221 | 0 |
|  | 5 | 71.68333333333334 | 67.2 | 106.65 | 21 | 9 | 7 | 5 | 5 | 0 | 0 | 0 | 100 | 0 |
| Kagoro Meliza | 6 | 36.208333333333336 | 30.15 | 59.1 | 13 | 6 | 1 | 6 | 1 | 0 | 0 | 0 | 100 | 0 |
| Atukwase Shallon | 17 | 60.416666666666664 | 44.28333333333333 | 93.3 | 47 | 3 | 27 | 2 | 16 | 0 | 1 | 0 | 11.76470588235294 | 0 |
## Sheet: district_summary
| qa_district | n_records | total_issues | total_errors | total_warnings | n_records_with_error | n_records_with_warning | pct_records_with_error |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Bushenyi | 55 | 189 | 55 | 79 | 44 | 48 | 80 |
| Rubirizi | 42 | 152 | 47 | 63 | 33 | 38 | 78.57142857142857 |
| Sheema | 36 | 101 | 32 | 33 | 28 | 24 | 77.77777777777779 |
## Sheet: date_summary
| qa_interview_date | n_interviews | median_duration_min | total_issues | total_errors | n_records_with_error |
| --- | --- | --- | --- | --- | --- |
| 2026-05-18 00:00:00 | 15 | 70.88333333333334 | 57 | 15 | 11 |
| 2026-05-19 00:00:00 | 29 | 55.35 | 95 | 29 | 23 |
| 2026-05-20 00:00:00 | 32 | 42.108333333333334 | 106 | 31 | 22 |
| 2026-05-21 00:00:00 | 36 | 33.05 | 101 | 32 | 28 |
| 2026-05-29 00:00:00 | 11 | 41.6 | 44 | 15 | 11 |
| 2026-05-30 00:00:00 | 9 | 37.583333333333336 | 36 | 11 | 9 |
| 2026-06-05 00:00:00 | 1 | 41.53333333333333 | 3 | 1 | 1 |