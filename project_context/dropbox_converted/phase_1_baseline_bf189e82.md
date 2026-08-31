<!-- converted from phase_1_baseline.xlsx -->

## Sheet: survey
| type | name | label | hint | default | appearance | constraint | constraint message | relevance | disabled | required | required message | read only | calculation | repeat_count | media:image | media:audio | media:video | choice_filter | note | response_note | publishable | minimum_seconds |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| start | starttime |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| end | endtime |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| deviceid | deviceid |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| phonenumber | devicephonenum |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| username | username |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| calculate | device_info |  |  |  |  |  |  |  |  |  |  |  | device-info() |  |  |  |  |  |  |  |  |  |
| calculate | duration |  |  |  |  |  |  |  |  |  |  |  | duration() |  |  |  |  |  |  |  |  |  |
| caseid | caseid |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | intro | Introduction and consent |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one Enum | Enum | Enumerator Name |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | introduction | Good morning/Good afternoon Sir/Madam. My name is………………. I am a researcher working with consultants that are evaluating the a program on Local Council Courts that is being implemented by Community Development Foundation Uganda (CDFU). I would like to ask you afew questions about your role as the Local Council chairperson and the Local Council courts of (Name the village). Your name was randomly selected from all the villages from (Distric name). Meaning, every chairperson in this district had an equal chance of being selected to participate in this interview. Your participation is completely voluntary. All your responses will be treated with utmost confidentiality; meaning that your name or response will not be attributed to your identity. Also, there are no wrong or right answers, its all about your honest opinion. There is no direct benefit for participating in this study but rather the information you give us will be used to inform future programs aimed at strengthening LC roles. This interview will take approximately one hour. So, can I go ahead and interview you? Thank you. |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one yesno | consent | Is it ok to proceed with this interview? |  |  | quick |  |  |  |  | yes | Consent response is required. |  |  |  |  |  |  |  |  |  |  |  |
| note | consent_no_stop | The respondent did not consent. Please stop the interview and record the outcome in the field tracking sheet. |  |  |  |  |  | ${consent} = 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one Attend_CDFU_Training | Attend_CDFU_Training | Have you attended any training by Communication for Development Foundation Uganda (CDFU)? (For directly trained) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one Topics_Trained | Topics_Trained | What topics did that previous training cover? Select all that apply. |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| integer | Rating_CDFU_Training | On a scale of 1-5, 1 being the lowest and 5 the highest, how do you rate the topic (s) mentioned above towards increasing your knowledge in handling disputes in your village? |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | Background | Please observe the following and record your observations |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one yesno | records | Are any LCC records, case books, registers, or proceedings books physically present or available for consultation during this interview? |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| end group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| end group | end_intro |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | m0_group | Module 0. Interview metadata, respondent eligibility, and interview context |  |  |  |  |  | ${consent} = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | M0_Q00 | We will begin by recording basic information about this interview, the village/Local Council Court, and the respondent yourself. This information is needed to correctly link this interview to the study records. | Read only if needed. This section is mostly administrative. |  |  |  |  | ${consent} = 1 |  |  |  |  |  |  |  |  |  |  | Project measurement architecture; Inception Report data linkage strategy |  |  |  |
| select_one M0_Q04 | M0_Q04 | District | Preload from sample frame where possible. If manually entered, use official spelling. |  |  |  |  | ${consent} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Sampling frame / randomization file |  |  |  |
| select_one M0_Q05 | M0_Q05 | Sub-county / division | Preload from sample frame where possible. |  |  |  |  | ${consent} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Sampling frame / randomization file |  |  |  |
| select_one M0_Q06 | M0_Q06 | Parish / ward | Preload from sample frame where possible. |  |  |  |  | ${consent} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Sampling frame / randomization file |  |  |  |
| select_one M0_Q07 | M0_Q07 | Village / LCC catchment name | Preload from sample frame where possible. Confirm verbally with respondent. |  |  |  |  | ${consent} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Sampling frame / randomization file |  |  |  |
| select_one M0_Q02 | M0_Q12 | Respondent name or respondent code | Use respondent code instead of full name if confidentiality protocol requires de-identification. |  |  |  |  | ${consent} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Standard survey metadata; data protection principles |  |  |  |
| select_one m0_q13 | M0_Q13 | What is your current role in the Local Council / Local Council Court? | Select the respondent’s current official role. |  | quick |  |  | ${consent} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training model; LCC institutional structure |  |  |  |
| text | M0_Q14 | Please specify the respondent’s role. | Record the role as stated by the respondent. |  |  |  |  | ${consent} = 1 and ${M0_Q13} = 5 |  | yes | This question is required. |  |  |  |  |  |  |  | Standard survey metadata |  |  |  |
| select_one m0_q15 | M0_Q15 | Respondent category for this study | Select based on study records and confirm with respondent. |  | quick |  |  | ${consent} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Project two-stage evaluation design |  |  |  |
| select_one m0_q16 | M0_Q16 | Is this respondent the person listed in the sample tracking sheet for this village/LCC? | Compare with sample/preload information before continuing. |  | quick |  |  | ${consent} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Field tracking protocol |  |  |  |
| text | M0_Q17 | Why is the listed respondent not being interviewed? | Record reason clearly: absent, replaced, no longer in role, unavailable, refused, deceased, etc. |  |  |  |  | ${consent} = 1 and ${M0_Q16} = 0 |  | yes | This question is required. |  |  |  |  |  |  |  | Field tracking protocol |  |  |  |
| select_one m0_q18 | M0_Q18 | Is the current respondent still knowledgeable about LCC operations and case handling in this village? | Continue only if respondent is an appropriate substitute according to field protocol. |  | quick |  |  | ${consent} = 1 and ${M0_Q16} = 0 |  | yes | This question is required. |  |  |  |  |  |  |  | Field tracking protocol; data quality protocol |  |  |  |
| calculate | m0_eligible |  |  |  |  |  |  | ${consent} = 1 |  |  |  |  | if(${M0_Q16} = 1 or (${M0_Q16} = 0 and ${M0_Q18} = 1), 1, 0) |  |  |  |  |  |  |  |  |  |
| note | M0_Q19 | This respondent is not eligible for the full interview. Please stop and contact your supervisor. | Do not continue the substantive survey unless supervisor authorizes. |  |  |  |  | ${consent} = 1 and ${M0_Q18} = 0 |  |  |  |  |  |  |  |  |  |  | Field tracking protocol |  |  |  |
| select_one m0_q20 | M0_Q20 | Are any LCC records, case books, registers, or proceedings books physically present or available for consultation during this interview? | This is important for later record-keeping and audit modules. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; data quality protocol |  |  |  |
| select_one m0_q21 | M0_Q21 | Is any other LC/LCC member present during the interview? | Record presence because it may affect responses, especially on institutional functioning and sensitive questions. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Data quality protocol |  |  |  |
| select_multiple m0_q22 | M0_Q22 | Which other LC/LCC members are present? Select all that apply. | Select all roles present. |  |  |  |  | ${m0_eligible} = 1 and ${M0_Q21} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Data quality protocol |  |  |  |
| select_one m0_q23 | M0_Q23 | Is the interview being conducted in private enough for the respondent to answer freely? | If not private, avoid probing sensitive issues and document the setting. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Research ethics and data quality protocol |  |  |  |
| select_one m0_q24 | M0_Q24 | Interview language | Select main language used during interview. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Fieldwork metadata |  |  |  |
| text | M0_Q25 | Please specify the interview language. | Record the language used. |  |  |  |  | ${m0_eligible} = 1 and ${M0_Q24} = 98 |  | yes | This question is required. |  |  |  |  |  |  |  | Fieldwork metadata |  |  |  |
| calculate | M0_Q26 | Interview start time | SurveyCTO should capture this automatically. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  | ${starttime} |  |  |  |  |  | Standard SurveyCTO metadata |  |  |  |
| calculate | M0_Q27 | Interview end time | SurveyCTO should capture this automatically. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  | ${endtime} |  |  |  |  |  | Standard SurveyCTO metadata |  |  |  |
| calculate | M0_Q28 | Interview duration in minutes | Use to monitor average duration and identify suspiciously short/long interviews. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  | duration() |  |  |  |  |  | Standard survey quality control |  |  |  |
| text | M0_Q30 | Enumerator notes on interview context | Record any relevant context: interruptions, respondent consulted records, respondent uncertain, other people influenced answers, etc. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Fieldwork data quality protocol |  |  |  |
| end group | end_m0_group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | m1_group | Module 1. Respondent profile and LC role |  |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | M1_Q00 | We will now ask a few questions about your role in the Local Council / Local Council Court and your experience with local dispute handling. | Read aloud as transition. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Project measurement architecture; theory of change |  |  |  |
| select_one m1_q01 | M1_Q01 | What is your current main role in the Local Council / Local Council Court? | If respondent holds more than one role, select the role most directly related to LCC case handling. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training model; LCC institutional structure |  |  |  |
| text | M1_Q02 | Please specify your current role. | Record the role as stated by the respondent. |  |  |  |  | ${m0_eligible} = 1 and ${M1_Q01} = 5 |  | yes | This question is required. |  |  |  |  |  |  |  | Standard survey metadata |  |  |  |
| select_one m1_q03 | M1_Q03 | Are you currently involved in receiving, hearing, mediating, deciding, or referring cases brought to the Local Council Court? | This identifies whether the respondent is substantively involved in case handling, not only whether they hold an LC title. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; project theory of change |  |  |  |
| integer | M1_Q04 | For how many years have you served in your current position as the LC chairperson? | If less than one year, record 0. |  |  | . >= 0 and . <= 60 | Value must be between 0 and 60. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Standard respondent profile; heterogeneity analysis |  |  |  |
| integer | M1_Q05 | For how many total years have you served in any Local Council or Local Council Court role? | Include all years in any LC/LCC role, not only the current role. |  |  | (. >= 0 and . <= 70) and . >= ${M1_Q04} | Total years in LC service must be greater than or equal to years in current role. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Standard respondent profile; heterogeneity analysis |  |  |  |
| select_one m1_q06 | M1_Q06 | What is your gender? | Ask respectfully and record respondent’s answer. Do not infer if respondent answers directly. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Gender-disaggregated analysis; safeguards framework |  |  |  |
| select_one m1_q07 | M1_Q07 | What is your age group? | Use age group rather than exact age to reduce sensitivity. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Standard respondent profile |  |  |  |
| select_one m1_q08 | M1_Q08 | What is the highest level of education you completed? | Ask for completed level, not currently attended level. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Standard respondent profile; capacity heterogeneity |  |  |  |
| select_one m1_q09 | M1_Q09 | How comfortable are you with reading and completing written case records or registers? | This refers specifically to written LCC case records, not general reading only. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record-keeping quality; implementation capacity |  |  |  |
| select_multiple m1_q10 | M1_Q10 | In which languages can you comfortably complete or review LCC records? Select all that apply. | This captures practical record-keeping capacity. |  |  | (not(selected(., '95') and count-selected(.) > 1)) | Do not combine 'None' or 'Do not know' with other options. | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; data quality protocol |  |  |  |
| select_one m1_q11 | M1_Q11 | Before this programme, had you ever received any training on justice, mediation, ADR, legal procedure, case handling, or referral of cases? | “Before this programme” means before CDFU/Legatum-related training or mentoring. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Training exposure; Albezreh et al. (2022); Blattman et al. (2014); CDFU training model |  |  |  |
| select_multiple m1_q12 | M1_Q12 | What topics did that previous training cover? Select all that apply. | Do not include current CDFU/Legatum training. |  |  |  |  | ${m0_eligible} = 1 and ${M1_Q11} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Training exposure; ADR and mediation literature |  |  |  |
| select_one m1_q13 | M1_Q13 | Before this programme Between January 2025 to May 2026 have you ever coordinated worked directly with any Justice Law and Order actors such as police, courts, probation, child protection, or other formal justice actors about on a case? | This captures prior coordination experience, not personal acquaintance. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Coordination/referral mechanism; Rockowitz et al. (2024); Albezreh et al. (2022) |  |  |  |
| select_multiple m1_q14 | M1_Q14 | Which of the following types of disputes or cases have you personally handled or participated in handling as an LC/LCC member between January 2025 todate? Select all that apply. | “Handled” includes receiving, hearing, mediating, deciding, recording, or referring a case. |  |  | (not(selected(., '95') and count-selected(.) > 1)) | Do not combine 'None' or 'Do not know' with other options. | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; case classification/triage mechanism |  |  |  |
| select_one m1_q15 | M1_Q15 | In a normal week, about how much time do you spend on Local Council or Local Council Court duties? | Include case handling, community meetings, record keeping, referral, and related LC duties. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Implementation capacity; mentor feasibility |  |  |  |
| select_one m1_q16 | M1_Q16 | Do you personally have access to a working phone that can be used for follow-up related to LC/LCC activities? | This is not for public reporting; it helps field tracking and implementation follow-up. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Field tracking protocol; implementation monitoring |  |  |  |
| select_one m1_q17 | M1_Q17 | May the project team we contact you by phone for follow-up related to this study or LC/LCC activities? | Ask consent clearly. Do not record phone number here unless the data protocol allows it. |  | quick |  |  | ${m0_eligible} = 1 and (${M1_Q16} = 1 or ${M1_Q16} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | Ethics and follow-up tracking protocol |  |  |  |
| end group | end_m1_group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | m2_group | Module 2. Institutional set-up and court composition |  |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | M2_Q00 | We will now ask about how the Local Council Court is organized and how it normally functions when handling cases. | Read aloud as transition. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; project theory of change |  |  |  |
| integer | M2_Q01 | How many people are currently members of this Local Council Court or LC committee involved in case handling? | Include all current members who are officially part of the LC/LCC structure, even if not always active. |  |  | . >= 1 and . <= 30 | Value must be between 1 and 30. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; LCC institutional structure |  |  |  |
| integer | M2_Q02 | Of these members, how many are currently active in receiving, hearing, mediating, deciding, recording, or referring cases? | “Active” means they participate in LCC duties in practice, not only that they hold a title. |  |  | . >= 0 and . <= ${M2_Q01} | Value must be between 0 and the referenced value. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; institutional functioning |  |  |  |
| select_one m2_q03 | M2_Q03 | Are there any vacant positions in the Local Council Court or LC committee? | Vacancies include formally unfilled positions or positions where the person is no longer serving. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; institutional capacity |  |  |  |
| integer | M2_Q04 | How many positions are currently vacant? | Ask for the number of vacant positions related to the LCC/committee. |  |  | . >= 1 and . <= 20 | Value must be between 1 and 20. | ${m0_eligible} = 1 and ${M2_Q03} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; institutional capacity |  |  |  |
| integer | M2_Q05 | How many women are currently members of the Local Council Court involved in case handling? | If respondent is unsure, ask for best estimate but do not guess for them. |  |  | . >= 0 and . <= ${M2_Q01} | Value must be between 0 and the referenced value. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; gender and inclusion safeguards |  |  |  |
| integer | M2_Q06 | How many times have you sat as the local council to handle cases in your village from January 2025-to date? | This refers to actual practice, not what should happen by law. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; committee functioning |  |  |  |
| select_one m2_q07 | M2_Q07 | How often does the Local Council Court or committee usually meet or sit to discuss or handle cases? | If sittings depend on whether cases arise, ask what normally happens when there are cases. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; institutional functioning |  |  |  |
| select_one m2_q08 | M2_Q08 | When the Local Council Court handles a case, is the required quorum usually achieved? | If respondent does not know the word quorum, explain as “the minimum number of members required to sit or make decisions.” |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; procedural regularity |  |  |  |
| select_one m2_q09 | M2_Q09 | Does the Local Council Court have a regular place where cases are normally heard or mediated? | This may be an LC office, community space, or other regular venue. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; institutional set-up |  |  |  |
| select_one m2_q12 | M2_Q12 | Does this Local Council Court keep a formal case register or case book? | This will be verified later if records are available. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; data quality protocol |  |  |  |
| select_one m2_q13 | M2_Q13 | Are the LCC case records currently up to date? Which of the following statement is a true representation of case record keeping of your LC (Read all options) | “Up to date” means recent cases have been entered and are not waiting to be recorded. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record-keeping quality |  |  |  |
| select_one m2_q14 | M2_Q14 | Does the Local Council Court have access to the basic materials needed to hear cases and keep records? Which of the following statements do you agree with most regarding availability of basic materials to hear cases and keep records? (Read all options) | Materials may include case books, proceedings books, paper, pens, forms, stamps, or other items used locally. |  | quick |  |  | ${m0_eligible} = 1 and (${M2_Q12} = 1 or ${M2_Q12} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; implementation capacity |  |  |  |
| select_multiple m2_q15 | M2_Q15 | Which materials are missing or insufficient? Select all that apply. | Select all materials reported as missing or insufficient. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; implementation capacity |  |  |  |
| select_one m2_q16 | M2_Q16 | Enumerator verification: Did you see a case register, case book, or other written LCC record during the interview? | Enumerator should answer based on observation, not respondent report. |  | quick |  |  | ${m0_eligible} = 1 and ${M0_Q20} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record audit protocol |  |  |  |
| select_one m2_q17 | M2_Q17 | Enumerator verification: Based on the records seen, do the most recent entries appear to be up to date? | Do not read aloud. Complete after looking at records. |  | quick |  |  | ${m0_eligible} = 1 and (${M2_Q16} = 1 or ${M2_Q16} = 2 or ${M7_V01} = 1 or ${M7_V01} = 2 or ${M7_V02} = 1 or ${M7_V02} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; data quality protocol |  |  |  |
| text | M2_Q18 | Enumerator notes on LCC institutional set-up or records | Record any relevant observations: no committee present, records locked away, respondent uncertain, records inconsistent, materials missing, etc. |  |  |  |  | ${m0_eligible} = 1 and (${M2_Q16} = 1 or ${M2_Q16} = 2) |  |  |  |  |  |  |  |  |  |  | Fieldwork data quality protocol |  |  |  |
| end group | end_m2_group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | m3_group | Module 3. Recent caseload and case mix |  |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | M3_Q00 | We will now ask about the types and number of cases recently brought to this Local Council Court. Please answer based on the records if they are available. If records are not available, please give your best estimate. | Read aloud. Emphasize that estimates are acceptable if records are not available, but records should be used whenever possible. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Project measurement architecture; administrative-data validation logic |  |  |  |
| select_one m3_q01 | M3_Q01 | For the questions in this section, what will your answers mainly be based on? | This helps distinguish record-based from recall-based caseload measures. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Data quality protocol; CDFU maturity tool |  |  |  |
| integer | M3_Q02 | In the last 30 days, How many cases or disputes did you receive in your Local Council Court? | Include cases received, even if not yet resolved. If none, enter 0. |  |  | . >= 0 and . <= 500 | Value must be between 0 and 500. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Case-flow validation; project primary-outcome linkage |  |  |  |
| integer | M3_Q03 | In the last 3 months, how many cases or disputes were received by this Local Council Court? | Include all cases received in the last 3 months, whether resolved, pending, or referred. |  |  | (. >= 0 and . <= 1500) and . >= ${M3_Q02} | Value must be within allowed range and greater than or equal to cases in the last 30 days. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Case-flow validation; project primary-outcome linkage |  |  |  |
| select_multiple m3_q04 | M3_Q04 | What types of cases or disputes were received by this Local Council Court in the last 3 months? Select all that apply. | Select all types received. Do not ask for sensitive details. |  |  |  |  | ${m0_eligible} = 1 and ${M3_Q03} > 0 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; case classification and triage mechanism |  |  |  |
| select_one m3_q05 | M3_Q05 | Which type of case or dispute was most common reported to your court in the last 3 months? | Select the single most common type. If respondent is unsure, ask for best estimate. |  |  |  |  | ${m0_eligible} = 1 and ${M3_Q03} > 0 |  | yes | This question is required. |  |  |  |  |  |  |  | Forum-choice theory; CDFU case classification logic |  |  |  |
| select_one m3_q06 | M3_Q06 | Thinking about all cases received in the last 3 months, approximately what share percent were petty or minor disputes that could potentially be handled locally by the LCC? | Ask for approximate share, not exact count. |  |  |  |  | ${m0_eligible} = 1 and ${M3_Q03} > 0 |  | yes | This question is required. |  |  |  |  |  |  |  | Project theory of change; diversion mechanism |  |  |  |
| integer | M3_Q08 | How many cases are currently pending or unresolved before this Local Council Court? | Pending means received but not yet closed, resolved, or referred. |  |  | . >= 0 and . <= 500 | Value must be between 0 and 500. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | LC throughput and local resolution mechanism |  |  |  |
| integer | M3_Q09 | Of the cases received in the last 3 months, how many were brought directly by community members other than the individuals in conflict or disputing parties? | Cases brought directly by a party, family member, neighbor, or community member. |  |  | . >= 0 and . <= ${M3_Q03} | Value must be between 0 and the referenced value. | ${m0_eligible} = 1 and ${M3_Q03} > 0 |  |  |  |  |  |  |  |  |  |  | Forum-choice theory; Krakowski & Kursani (2024) inspired |  |  |  |
| integer | M3_Q10 | Of the cases received in the last 3 months, how many were referred to the LCC by another actor, such as police, court, another LC, community leader, or other institution? | This should include formal and informal referrals to the LCC. |  |  | . >= 0 and . <= ${M3_Q03} | Value must be between 0 and the referenced value. | ${m0_eligible} = 1 and ${M3_Q03} > 0 |  |  |  |  |  |  |  |  |  |  | Coordination/referral mechanism; Rockowitz et al. (2024); Albezreh et al. (2022) inspired |  |  |  |
| select_multiple m3_q11 | M3_Q11 | Which actor referred cases to this LCC in the last 3 months mentioned above? Select all that apply. | Select all actors that referred at least one case. |  |  |  |  | ${m0_eligible} = 1 and ${M3_Q10} > 0 |  | yes | This question is required. |  |  |  |  |  |  |  | Coordination/referral mechanism |  |  |  |
| integer | M3_Q12 | Of the cases received in the last 3 months, how many were referred onward by the LCC to police, court, probation, child protection, or another authority? | This is about referrals made by the LCC to another authority. |  |  | . >= 0 and . <= ${M3_Q03} | Value must be between 0 and the referenced value. | ${m0_eligible} = 1 and ${M3_Q03} > 0 |  |  |  |  |  |  |  |  |  |  | Referral appropriateness; project theory of change |  |  |  |
| select_multiple m3_q13 | M3_Q13 | Where did the LCC refer cases in the last 3 months? Select all that apply. | Select all referral destinations. |  |  |  |  | ${m0_eligible} = 1 and ${M3_Q12} > 0 |  | yes | This question is required. |  |  |  |  |  |  |  | Coordination/referral mechanism; safeguarding framework |  |  |  |
| select_one m3_q14 | M3_Q14 | Compared with the period before the last 3 months and now, has the number of cases brought to this LCC  increased, decreased or remained the same? | Ask about perceived change in inflow, not whether the LCC is better or worse. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Benchmarking and process evaluation; forum-choice theory |  |  |  |
| select_multiple m3_q15 | M3_Q15 | What do you think are the main reasons why the number of cases brought to this LCC has increased? Select up to three. | Do not read as blame; ask neutrally. |  |  | count-selected(.) <= 3 | Select up to three options. | ${m0_eligible} = 1 and (${M3_Q14} = 1 or ${M3_Q14} = 2) |  |  |  |  |  |  |  |  |  |  | Process evaluation; implementation learning |  |  |  |
| select_multiple m3_q16 | M3_Q16 | What do you think are the main reasons why the number of cases brought to this LCC has decreased? Select up to three. | Ask neutrally; do not imply decrease is good or bad. |  |  | count-selected(.) <= 3 | Select up to three options. | ${m0_eligible} = 1 and (${M3_Q14} = 4 or ${M3_Q14} = 5) |  |  |  |  |  |  |  |  |  |  | Process evaluation; implementation learning |  |  |  |
| select_one m3_q17 | M3_Q17 | Overall, how confident are you that the case numbers reported in this section are accurate? | This is a data-quality confidence item. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Data quality protocol; administrative validation strategy |  |  |  |
| text | M3_Q18 | Enumerator notes on recent caseload and case mix | Record any important context: estimates based only on memory, records incomplete, respondent unsure, unusual recent event, etc. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Fieldwork data quality protocol |  |  |  |
| end group | end_m3_group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | m4_group | Module 4. Legal mandate, jurisdiction, and classification knowledge |  |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | M4_Q00 | We will now ask about the types of cases your Local Council Courts can handle, when cases should be referred, and how you would respond to different case situations. Some questions are short examples. There are no trick questions; we want to understand how cases are classified in practice. | Read aloud. Emphasize that examples are hypothetical and do not refer to real people. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Project theory of change; CDFU training content; Blattman et al. (2014); Albezreh et al. (2022) |  |  |  |
| select_multiple m4_q01 | M4_Q01 | Which types of cases do you understand Local Council Courts are allowed to handle or help resolve? Select all that apply. | This measures perceived jurisdiction. Final scoring should be legally validated. |  |  | (not(selected(., '98') and count-selected(.) > 1)) | Do not combine 'None' or 'Do not know' with other options. | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training manual; LCC legal mandate; classification/triage mechanism |  |  |  |
| select_multiple m4_q02 | M4_Q02 | Which types of cases should be referred immediately to another authority rather than resolved by the Local Council Court? Select all that apply. | Do not ask for examples from real cases. |  |  | (not(selected(., '98') and count-selected(.) > 1)) | Do not combine 'None' or 'Do not know' with other options. | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training manual; safeguarding framework; Rockowitz et al. (2024) |  |  |  |
| select_one m4_q04 | M4_Q04 | When a case is outside the Local Council Court’s mandate, what should the LCC normally do? (Read all options) | Measures knowledge of referral obligation. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training manual; referral mechanism |  |  |  |
| select_multiple m4_q05 | M4_Q05 | What should normally be documented when the Local Council Court receives or handles a case? Select all that apply. | Measures knowledge of documentation requirements. |  |  | (not(selected(., '98') and count-selected(.) > 1)) | Do not combine 'None' or 'Do not know' with other options. | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record-keeping quality |  |  |  |
| select_multiple m4_q06 | M4_Q06 | Before resolving a case locally, which steps should the Local Council Court normally take? Select all that apply. | Measures procedural knowledge. |  |  | (not(selected(., '98') and count-selected(.) > 1)) | Do not combine 'None' or 'Do not know' with other options. | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training manual; procedural fairness literature; Tyler (1988, 2017) inspired |  |  |  |
| select_one m4_q07 | M4_Q07 | When is ADR (non-formal judiciary dispute resolution mechnisms) most appropriate for the Local Council Court to attempt?  | Measures understanding of ADR boundaries. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; Menkel-Meadow (2007); Braithwaite (2021) |  |  |  |
| select_multiple m4_q08 | M4_Q08 | In which situations should police, court, probation, child protection, or another formal authority normally be involved? Select all that apply. | Measures referral classification. |  |  | (not(selected(., '98') and count-selected(.) > 1)) | Do not combine 'None' or 'Do not know' with other options. | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; safeguarding framework; Rockowitz et al. (2024) |  |  |  |
| select_one m4_q09 | M4_Q09 | Which statement best describes the role of bail, bond, or community service in relation to the justice system? | Retain only if bail/bond/community service is included in training. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training guide; Legatum justice-chain framework |  |  |  |
| select_one m4_q10 | M4_Q10 | How confident are you that you can correctly distinguish between cases that the LC Court can handle and cases that must be referred? | Self-assessed competence; not a substitute for vignette scoring. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Project theory of change; training evaluation logic |  |  |  |
| note | M4_V00 | Now I will read short hypothetical case examples. For each example, please tell me what the Local Council Court should do first. These examples are not about real people in this village. | Read aloud. Do not coach respondent. Do not reveal whether answers are correct. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Survey vignette methodology; classification/triage mechanism |  |  |  |
| note | M4_V01_CASE | Example 1: Boundary dispute. Two neighbors disagree about the boundary between their gardens. There is no physical violence, no threat of violence, and both parties say they are willing to talk. One party comes to the Local Council Court asking for help. | Read exactly as written. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU case types; community dispute-resolution literature; Blattman et al. (2014) inspired |  |  |  |
| select_one m4_v01_q1 | M4_V01_Q1 | In this example, can the Local Council Court handle or help resolve the case locally? | Final correct classification to be validated with CDFU/legal expert. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; LCC jurisdiction |  |  |  |
| select_one m4_v01_q2 | M4_V01_Q2 | What should the Local Council Court do first in this example? | Do not read response options unless needed; classify answer. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; ADR mechanism |  |  |  |
| select_multiple m4_v01_q3 | M4_V01_Q3 | Which actor(s), if any, should be involved or notified at the first stage? Select all that apply. | Final scoring to be validated. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; referral mechanism |  |  |  |
| note | M4_V02_CASE | Example 2: Family disagreement. A husband and wife come to the Local Council Court because they are arguing about household responsibilities and money. There is no report of physical violence, sexual violence, or threats, and both say they want help resolving the disagreement. | Read exactly as written. Do not add examples. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU case types; mediation and procedural justice literature |  |  |  |
| select_one m4_v02_q1 | M4_V02_Q1 | In this example, can the Local Council Court handle or help resolve the case locally? | Final correct classification to be validated. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; LCC jurisdiction |  |  |  |
| select_one m4_v02_q2 | M4_V02_Q2 | What should the Local Council Court do first in this example? | Do not coach. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; ADR mechanism; Tyler (1988, 2017) inspired |  |  |  |
| select_multiple m4_v02_q3 | M4_V02_Q3 | Which actor(s), if any, should be involved or notified at the first stage? Select all that apply. | Final scoring to be validated. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; referral mechanism |  |  |  |
| note | M4_V05_CASE | Example 5: Child protection concern. A neighbor reports that a child in the village is often beaten severely at home and sometimes appears injured and afraid. The child has not come directly to the Local Council Court, but the neighbor asks the LCC to intervene. | Read exactly as written. Do not probe for real examples. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Safeguarding framework; Mennen (2010); Rockowitz et al. (2024) inspired |  |  |  |
| select_one m4_v05_q1 | M4_V05_Q1 | In this example, can the Local Council Court handle or help resolve the case locally without referral? | This should generally test recognition of child-protection referral need; final scoring to be validated. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Safeguarding framework; CDFU referral content |  |  |  |
| select_one m4_v05_q2 | M4_V05_Q2 | What should the Local Council Court do first in this example? | Do not coach. Sensitive case safeguard item. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Safeguarding framework |  |  |  |
| select_multiple m4_v05_q3 | M4_V05_Q3 | Which actor(s), if any, should be involved or notified at the first stage? Select all that apply. | Final scoring to be validated. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Safeguarding framework; referral pathway |  |  |  |
| note | M4_V06_CASE | Example 6: Sexual or severe violence. A woman reports that she was sexually assaulted raped by a man in the community. She is afraid and asks the Local Council Court what to do. | Read exactly as written. Do not probe. If respondent discloses a real case, follow safeguarding protocol. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Safeguarding framework; Rockowitz et al. (2024); Albezreh et al. (2022) |  |  |  |
| select_one m4_v06_q1 | M4_V06_Q1 | In this example, can the Local Council Court handle or resolve the case locally through mediation? | This is a safeguarding-critical classification item. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Safeguarding framework; CDFU referral content |  |  |  |
| select_one m4_v06_q2 | M4_V06_Q2 | What should the Local Council Court do first in this example? | Do not coach. Sensitive case safeguard item. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Safeguarding framework; Rockowitz et al. (2024) |  |  |  |
| select_multiple m4_v06_q3 | M4_V06_Q3 | Which actor(s), if any, should be involved or notified at the first stage? Select all that apply. | Final scoring to be validated. Do not ask for real case details. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Safeguarding framework; multisectoral referral literature; Albezreh et al. (2022); Rockowitz et al. (2024) |  |  |  |
| select_one m4_q11 | M4_Q11 | Overall, how difficult was it for you to decide what the Local Council Court should do in these examples? | This helps interpret vignette performance and perceived ambiguity. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Survey measurement quality; classification/triage mechanism |  |  |  |
| text | M4_Q12 | Enumerator notes on mandate, jurisdiction, and classification knowledge | Record if respondent seemed confused, asked for clarification, disclosed a real case, or if there were interruptions. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Fieldwork data quality protocol |  |  |  |
| end group | end_m4_group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | m5_group | Module 5. ADR and mediation practice |  |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | M5_Q00 | We will now ask about how the Local Council Court normally uses mediation, dialogue, reconciliation, or other Alternative Dispute Resolution methods when handling eligible petty or minor disputes. | Read aloud. Emphasize that this section refers to eligible petty or minor disputes, not serious cases that must be referred. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU training content; Menkel-Meadow (2007); Braithwaite (2021); Blattman et al. (2014) |  |  |  |
| select_one m5_q01 | M5_Q01 | When an eligible petty or minor dispute is brought to your LCC, how often does the LCC first try mediation, dialogue, reconciliation, or another ADR method before escalation? | This refers only to cases that are suitable for local handling. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; ADR mechanism; Blattman et al. (2014) |  |  |  |
| select_one m5_q02 | M5_Q02 | During mediation or dialogue, how often are both sides given an opportunity to explain their side of the dispute? | This is a core procedural fairness item. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Tyler (1988, 2017); Creutzfeldt & Bradford (2016); CDFU training content |  |  |  |
| select_one m5_q03 | M5_Q03 | During mediation or dialogue, how often are parties allowed to speak without interruption while explaining their side? | Ask about normal practice, not one exceptional case. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Procedural justice: voice and respectful treatment; Tyler (1988, 2017) |  |  |  |
| select_one m5_q04 | M5_Q04 | When mediating a dispute, how often do you or the LCC try to remain neutral and avoid favoring either side? | This is self-reported practice. Later analysis may combine with procedural fairness items. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Procedural justice: neutrality; Tyler (1988, 2017); Jackson (2018) |  |  |  |
| select_one m5_q05 | M5_Q05 | In most eligible petty disputes, what is the main goal of the LCC’s mediation or dialogue process? | If respondent mentions multiple goals, ask which is most common. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | ADR and restorative justice literature; Menkel-Meadow (2007); Braithwaite (2021) |  |  |  |
| select_one m5_q06 | M5_Q06 | When a mediation or dialogue process reaches an agreement, how often is the agreement written down or recorded? | Agreement may be written in register, proceedings book, or other written record. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record-keeping quality; ADR mechanism |  |  |  |
| select_one m5_q07 | M5_Q07 | After an agreement is reached, how often does the LCC follow up to see whether the parties are complying with the agreement? | Follow-up may be by phone, visit, later meeting, or party report. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | ADR quality; restorative justice practice; CDFU maturity tool inspired |  |  |  |
| select_one m5_q08 | M5_Q08 | If emotions are high or there is risk that parties may fight during a mediation, how often does the LCC separate the parties or take steps to calm the situation before continuing? | This captures safety-conscious mediation practice. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Conflict management content; CDFU training; safeguarding logic |  |  |  |
| select_one m5_q09 | M5_Q09 | How confident are you in mediating eligible petty or minor disputes brought to the LCC? | Self-efficacy item; not a substitute for observed practice. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Training evaluation logic; Albezreh et al. (2022); CDFU training content |  |  |  |
| select_one m5_q10 | M5_Q10 | How confident are you in calming or de-escalating conflict between parties before a dispute becomes more serious? | Refers to de-escalation, not legal decision-making. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Conflict management training; restorative-responsive justice theory; Braithwaite (2021) |  |  |  |
| select_multiple m5_q11 | M5_Q11 | What are the main barriers that make successful mediation or ADR difficult for the LCC? Select up to three. | Ask neutrally. Do not suggest that the LCC is at fault. |  |  | count-selected(.) <= 3 | Select up to three options. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Process evaluation; ADR implementation barriers; Swenson (2018); Rockowitz et al. (2024) inspired |  |  |  |
| select_multiple m5_q12 | M5_Q12 | When mediation fails, what are the most common reasons? Select up to three. | This asks about cases where mediation was attempted but did not resolve the dispute. |  |  | count-selected(.) <= 3 | Select up to three options. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | ADR quality; process evaluation; Menkel-Meadow (2007) inspired |  |  |  |
| select_multiple m5_q13 | M5_Q13 | Which methods does the LCC use when trying to resolve eligible petty disputes? Select all that apply. | Select all methods used in practice. |  |  | (not(selected(., '95') and count-selected(.) > 1)) | Do not combine 'None' or 'Do not know' with other options. | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; ADR/restorative justice literature |  |  |  |
| select_one m5_q14 | M5_Q14 | When the LCC reaches a mediated agreement in an eligible petty dispute, how often do the parties usually comply with the agreement? | Ask about typical practice, not one exceptional case. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | ADR outcome quality; restorative justice literature |  |  |  |
| select_one m5_q15 | M5_Q15 | If one party does not comply with a mediated agreement, what does the LCC usually do first? | Measures post-agreement handling. Final legal scoring to be validated. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; ADR follow-up; referral mechanism |  |  |  |
| select_one m5_q16 | M5_Q16 | In your view, how often does LCC mediation help prevent eligible petty disputes from escalating to police or court? | Measures perceived diversion mechanism; not primary outcome. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Project theory of change; diversion mechanism; Blattman et al. (2014) inspired |  |  |  |
| text | M5_Q17 | Enumerator notes on ADR and mediation practice | Record if respondent gave examples, seemed uncertain, contradicted earlier case-handling answers, or if another person influenced the response. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Fieldwork data quality protocol |  |  |  |
| end group | end_m5_group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | m6_group | Module 6. Referral practice and coordination with formal institutions |  |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | M6_Q00 | We will now ask about cases that the Local Council Court refers to police, court, probation, child protection, or other institutions, and about how the LCC coordinates with those actors. | Read aloud. Emphasize that referral is not a failure; it may be the appropriate response when a case is outside LCC mandate. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Project theory of change; CDFU training content; Albezreh et al. (2022); Rockowitz et al. (2024) |  |  |  |
| select_one m6_q01 | M6_Q01 | When a case is outside the LCC’s mandate or is too serious for local handling, how often does the LCC refer or direct the case to the appropriate authority? | This refers to cases that should not be resolved locally. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; referral appropriateness mechanism |  |  |  |
| integer | M6_Q02 | In the last 3 months, how many cases did the LCC refer onward to police, court, probation, child protection, or another authority? | If records are available, use records. If not, ask for best estimate. Should be consistent with M3_Q12 where applicable. |  |  | . >= 0 and . <= 500 | Value must be between 0 and 500. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Project measurement architecture; administrative validation |  |  |  |
| select_multiple m6_q03 | M6_Q03 | In the last 3 months, where did the LCC refer cases? Select all that apply. | Select all referral destinations used in the last 3 months. |  |  |  |  | ${m0_eligible} = 1 and ${M6_Q02} > 0 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; justice-chain coordination |  |  |  |
| select_multiple m6_q04 | M6_Q04 | What were the main reasons for referring cases onward in the last 3 months? Select all that apply. | Select all reasons mentioned. |  |  |  |  | ${m0_eligible} = 1 and ${M6_Q02} > 0 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; referral appropriateness |  |  |  |
| select_one m6_q05 | M6_Q05 | When the LCC refers a case to another authority, how often is the referral documented in the case register, proceedings book, referral note, or other written record? | Documentation may be in any formal or informal written LCC record. |  |  |  |  | ${m0_eligible} = 1 and ${M6_Q02} > 0 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record-keeping quality; referral documentation |  |  |  |
| select_one m6_q06 | M6_Q06 | When referring a case, how often does the LCC explain to the parties why the case needs to go to another authority? | This captures procedural explanation and legitimacy of referral. |  |  |  |  | ${m0_eligible} = 1 and ${M6_Q02} > 0 |  | yes | This question is required. |  |  |  |  |  |  |  | Procedural justice: explanation/voice; Tyler (1988, 2017); Jackson (2018) |  |  |  |
| select_one m6_q07 | M6_Q07 | After referring a case, how often does the LCC follow up to find out what happened to the case? | Follow-up may be with the referred authority or with the parties. |  |  |  |  | ${m0_eligible} = 1 and ${M6_Q02} > 0 |  | yes | This question is required. |  |  |  |  |  |  |  | Coordination mechanism; process evaluation; Albezreh et al. (2022) inspired |  |  |  |
| select_one m6_q08 | M6_Q08 | After referring a case, how often does the receiving authority provide feedback or information back to the LCC? | Receiving authority may be police, court, probation, child protection, or another institution. |  |  |  |  | ${m0_eligible} = 1 and ${M6_Q02} > 0 |  | yes | This question is required. |  |  |  |  |  |  |  | Coordination bottlenecks; Rockowitz et al. (2024); Albezreh et al. (2022) |  |  |  |
| select_one m6_q09 | M6_Q09 | Overall, how easy or difficult is it for this LCC to coordinate with police when a case requires police involvement? | Ask about normal experience, not a single case. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Coordination mechanism; justice-chain interface |  |  |  |
| select_one m6_q10 | M6_Q10 | Overall, how easy or difficult is it for this LCC to coordinate with courts when a case requires court involvement? | Ask about normal experience, not a single case. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Coordination mechanism; justice-chain interface |  |  |  |
| select_one m6_q11 | M6_Q11 | Overall, how easy or difficult is it for this LCC to coordinate with probation, child protection, or other social service actors when needed? | Use local terminology for probation/child protection if CDFU confirms preferred wording. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Safeguarding and referral coordination; Rockowitz et al. (2024) |  |  |  |
| select_multiple m6_q12 | M6_Q12 | What are the main barriers that make referral of cases difficult for the LCC? Select up to three. | Ask neutrally. Do not imply blame toward any institution. |  |  | count-selected(.) <= 3 | Select up to three options. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Coordination barriers; process evaluation; access to justice literature |  |  |  |
| select_multiple m6_q13 | M6_Q13 | What are the main barriers to receiving feedback from police, courts, probation, or other authorities after a case is referred? Select up to three. | Feedback may be formal or informal. |  |  | count-selected(.) <= 3 | Select up to three options. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Coordination bottlenecks; multisectoral referral literature |  |  |  |
| select_one m6_q14 | M6_Q14 | How confident are you that you know where to refer cases that are outside the LCC’s mandate? | Self-efficacy item. Compare with vignette classification in Module 4. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Training evaluation logic; CDFU referral content |  |  |  |
| select_one m6_q15 | M6_Q15 | How confident are you that you can explain to community members why some cases must be referred instead of handled locally? | Captures ability to communicate jurisdictional boundaries and maintain legitimacy. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Procedural fairness/explanation; Tyler (1988, 2017); CDFU training content |  |  |  |
| select_one m6_q16 | M6_Q16 | Enumerator verification: In the records seen today, is there any written evidence that referred cases are recorded as referrals? | Enumerator should answer based on records, not respondent report. |  | quick |  |  | ${m0_eligible} = 1 and ${M0_Q20} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record audit protocol |  |  |  |
| select_one m6_q17 | M6_Q17 | Enumerator verification: In the records seen today, is the destination of referral usually recorded? | Destination means police, court, probation, child protection, etc. |  | quick |  |  | ${m0_eligible} = 1 and ${M0_Q20} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record audit protocol |  |  |  |
| text | M6_Q18 | Enumerator notes on referral practice and coordination | Record relevant context: respondent mentions poor police/court coordination, no referral forms, sensitive cases, incomplete records, or contradiction with earlier answers. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Fieldwork data quality protocol |  |  |  |
| end group | end_m6_group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | m7_group | Module 7. Record-keeping and case management quality |  |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | M7_Q00 | We will now ask about how this Local Council Court keeps records of cases, hearings, outcomes, referrals, and agreements. If records are available, we may ask to look at them only to check whether information is recorded. We will not copy names or personal details from individual cases. | Read aloud. Emphasize confidentiality. Do not record party names or identifying details. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; project administrative-data strategy |  |  |  |
| select_one m7_q01 | M7_Q01 | Does this Local Council Court currently have a case register or case book for recording cases received? | This may repeat earlier information but is asked here as the start of detailed record-quality assessment. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record-keeping quality |  |  |  |
| select_one m7_q02 | M7_Q02 | Does this Local Council Court currently have a proceedings book or written record of hearings, mediation sessions, or committee decisions? | Proceedings book may be separate from case register. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; procedural documentation |  |  |  |
| select_multiple m7_q03 | M7_Q03 | Which types of written case records does the LCC currently keep? Select all that apply. | Select all record types currently used. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record audit protocol |  |  |  |
| select_one m7_q04 | M7_Q04 | Are the LCC case records currently up to date? | “Up to date” means recent cases have been entered and are not waiting to be recorded. |  | quick |  |  | ${m0_eligible} = 1 and (${M7_Q01} = 1 or ${M7_Q01} = 2 or ${M7_Q02} = 1 or ${M7_Q02} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; data quality protocol |  |  |  |
| select_one m7_q05 | M7_Q05 | When was the most recent case entry made in the LCC records? | Ask respondent to use the records if available. |  |  |  |  | ${m0_eligible} = 1 and (${M7_Q01} = 1 or ${M7_Q01} = 2 or ${M7_Q02} = 1 or ${M7_Q02} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record recency |  |  |  |
| select_multiple m7_q06 | M7_Q06 | When a case is recorded, what information is usually included? Select all that apply. | Ask about usual recording practice. |  |  |  |  | ${m0_eligible} = 1 and (${M7_Q01} = 1 or ${M7_Q01} = 2 or ${M7_Q02} = 1 or ${M7_Q02} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; documentation requirements |  |  |  |
| select_one m7_q07 | M7_Q07 | How often is the type or nature of the case recorded? | Case type includes land, family, debt, assault, referral, etc. |  |  |  |  | ${m0_eligible} = 1 and (${M7_Q01} = 1 or ${M7_Q01} = 2 or ${M7_Q02} = 1 or ${M7_Q02} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; case classification mechanism |  |  |  |
| select_one m7_q08 | M7_Q08 | How often is the outcome, resolution, decision, or agreement recorded? | Outcome may include resolved, pending, referred, withdrawn, or agreement reached. |  |  |  |  | ${m0_eligible} = 1 and (${M7_Q01} = 1 or ${M7_Q01} = 2 or ${M7_Q02} = 1 or ${M7_Q02} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; local resolution outcome |  |  |  |
| select_one m7_q09 | M7_Q09 | How often is referral status recorded when a case is referred to police, court, probation, child protection, or another authority? | Referral status may include destination, date, or reason for referral. |  |  |  |  | ${m0_eligible} = 1 and (${M7_Q01} = 1 or ${M7_Q01} = 2 or ${M7_Q02} = 1 or ${M7_Q02} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; referral documentation |  |  |  |
| select_one m7_q10 | M7_Q10 | How often is the closure date, resolution date, or referral date recorded? | This captures whether the case timeline can be reconstructed. |  |  |  |  | ${m0_eligible} = 1 and (${M7_Q01} = 1 or ${M7_Q01} = 2 or ${M7_Q02} = 1 or ${M7_Q02} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; time-to-resolution measurement |  |  |  |
| select_one m7_q11 | M7_Q11 | When the LCC reaches an agreement between parties, how often is the agreement written down or attached to the case record? | Agreement may be inside the register, proceedings book, or a separate attachment. |  |  |  |  | ${m0_eligible} = 1 and (${M7_Q01} = 1 or ${M7_Q01} = 2 or ${M7_Q02} = 1 or ${M7_Q02} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; ADR documentation |  |  |  |
| select_one m7_q12 | M7_Q12 | If someone asked to find a case handled in the last 3 months, how easy would it be to retrieve the record? | Ask about records generally, not confidential access by outsiders. |  |  |  |  | ${m0_eligible} = 1 and (${M7_Q01} = 1 or ${M7_Q01} = 2 or ${M7_Q02} = 1 or ${M7_Q02} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; data accessibility |  |  |  |
| select_one m7_q13 | M7_Q13 | Are case records kept in a secure place where they are protected from loss, damage, or unauthorized access? | Secure storage may include locked cabinet, locked room, or another protected location. |  | quick |  |  | ${m0_eligible} = 1 and (${M7_Q01} = 1 or ${M7_Q01} = 2 or ${M7_Q02} = 1 or ${M7_Q02} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; confidentiality/data protection |  |  |  |
| select_multiple m7_q14 | M7_Q14 | Who normally has access to the LCC case records? Select all that apply. | This item captures confidentiality and access control. |  |  |  |  | ${m0_eligible} = 1 and (${M7_Q01} = 1 or ${M7_Q01} = 2 or ${M7_Q02} = 1 or ${M7_Q02} = 2) |  | yes | This question is required. |  |  |  |  |  |  |  | Data protection protocol; CDFU maturity tool |  |  |  |
| select_multiple m7_q15 | M7_Q15 | What are the main challenges this LCC faces in keeping complete and accurate records? Select up to three. | Ask neutrally. Do not imply blame. |  |  | count-selected(.) <= 3 | Select up to three options. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; implementation barriers |  |  |  |
| note | M7_V00 | Enumerator: You will now complete a brief verification of the LCC records that are physically available. Do not record names, addresses, phone numbers, or details that could identify parties. Only check whether fields are present and complete. | Do not read aloud unless needed. Follow confidentiality protocol. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; record audit protocol; data protection protocol |  |  |  |
| select_one m7_v01 | M7_V01 | Enumerator verification: Did you see a case register or case book? | Complete based on observation, not respondent report. |  | quick |  |  | ${m0_eligible} = 1 and ${M0_Q20} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record audit protocol |  |  |  |
| select_one m7_v02 | M7_V02 | Enumerator verification: Did you see a proceedings book or hearing/mediation notes? | Complete based on observation. |  | quick |  |  | ${m0_eligible} = 1 and ${M0_Q20} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record audit protocol |  |  |  |
| integer | M7_V03 | Enumerator verification: How many of the most recent case entries did you review? | Review up to the 3 most recent entries available. If fewer than 3 exist, enter the number reviewed. Do not copy names or facts. |  |  | . >= 0 and . <= 3 | Value must be between 0 and 3. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Record audit protocol |  |  |  |
| integer | M7_V04 | Out of the case entries reviewed, how many recorded the date the case was received or opened? | Count entries with date received/opened clearly recorded. |  |  | . >= 0 and . <= ${M7_V03} | Value must be between 0 and the referenced value. | ${m0_eligible} = 1 and ${M0_Q20} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; record completeness |  |  |  |
| integer | M7_V05 | Out of the case entries reviewed, how many recorded the parties’ names or identifiers? | Do not copy names. Only count whether party identifiers are present. |  |  | . >= 0 and . <= ${M7_V03} | Value must be between 0 and the referenced value. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; record completeness; confidentiality protocol |  |  |  |
| integer | M7_V06 | Out of the case entries reviewed, how many recorded the type or nature of the case? | Case type may be written as land, family, assault, debt, referral, etc. |  |  | . >= 0 and . <= ${M7_V03} | Value must be between 0 and the referenced value. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Case classification mechanism; CDFU maturity tool |  |  |  |
| integer | M7_V07 | Out of the case entries reviewed, how many recorded the action taken by the LCC, such as hearing, mediation, advice, decision, or referral? | Count only if action taken is visible in the record. |  |  | . >= 0 and . <= ${M7_V03} | Value must be between 0 and the referenced value. | ${m0_eligible} = 1 and (${M7_V01} = 1 or ${M7_V01} = 2 or ${M7_V02} = 1 or ${M7_V02} = 2) |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; case-management quality |  |  |  |
| integer | M7_V08 | Out of the case entries reviewed, how many recorded an outcome, resolution status, decision, agreement, or referral? | Outcome may be resolved, pending, referred, withdrawn, no agreement, etc. |  |  | . >= 0 and . <= ${M7_V03} | Value must be between 0 and the referenced value. | ${m0_eligible} = 1 and ${M7_V03} > 0 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; local resolution measurement |  |  |  |
| integer | M7_V09 | Out of the case entries reviewed, how many recorded a closure date, resolution date, or referral date? | This is needed to reconstruct time-to-resolution. |  |  | . >= 0 and . <= ${M7_V03} | Value must be between 0 and the referenced value. | ${m0_eligible} = 1 and ${M7_V03} > 0 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; time-to-resolution measurement |  |  |  |
| integer | M7_V10 | Out of the case entries reviewed, how many had a written agreement, signed decision, or attached outcome note where relevant? | Count only if an agreement/decision/outcome note is present or clearly referenced. |  |  | . >= 0 and . <= ${M7_V03} | Value must be between 0 and the referenced value. | ${m0_eligible} = 1 and ${M7_V03} > 0 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; ADR documentation |  |  |  |
| select_one m7_v11 | M7_V11 | Enumerator verification: Are the case register and proceedings records broadly consistent with each other for the entries reviewed? | Compare only the reviewed entries. Do not investigate case details. |  | quick |  |  | ${m0_eligible} = 1 and ${M7_V03} > 0 |  | yes | This question is required. |  |  |  |  |  |  |  | Record audit protocol; administrative data quality |  |  |  |
| select_one m7_v12 | M7_V12 | Enumerator verification: Where were the records stored at the time of the interview? | Do not request access to private storage beyond what respondent voluntarily shows. |  |  |  |  | ${m0_eligible} = 1 and ((${M7_V01} = 1 or ${M7_V01} = 2) and (${M7_V02} = 1 or ${M7_V02} = 2)) |  | yes | This question is required. |  |  |  |  |  |  |  | Data protection protocol; CDFU maturity tool |  |  |  |
| select_one m7_v13 | M7_V13 | Enumerator verification: Overall, how complete and usable did the available LCC records appear for monitoring case flow? | This is an enumerator judgment after reviewing records. |  |  |  |  | ${m0_eligible} = 1 and ${M0_Q20} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Administrative-data quality protocol; project measurement strategy |  |  |  |
| select_one m7_v14 | M7_V14 | Enumerator verification: Why could records not be verified during this interview? | Complete based on respondent explanation and observation. |  |  |  |  | ${m0_eligible} = 1 and ${M0_Q20} != 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Fieldwork data quality protocol |  |  |  |
| text | M7_Q16 | Enumerator notes on record-keeping and case management quality | Record any relevant observations: missing books, incomplete records, respondent uncertainty, poor storage, contradiction between self-report and records, or privacy concerns. Do not record names or case details. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Fieldwork data quality protocol |  |  |  |
| end group | end_m7_group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | m8_group | Module 8. Committee sitting and decision-making process |  |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | M8_Q00 | We will now ask about how the Local Council Court sits, discusses cases, and makes decisions as a committee. Please answer based on how cases are usually handled in practice. | Read aloud as transition. Emphasize actual practice, not only formal rules. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; project theory of change; procedural regularity |  |  |  |
| select_one m8_q01 | M8_Q01 | When this Local Council Court handles cases, how are cases usually handled in practice? | Ask about the usual practice across cases, not one exceptional case. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; institutional functioning |  |  |  |
| select_one m8_q02 | M8_Q02 | When cases are heard or mediated, how often does the LCC have the required quorum or minimum number of members present? | If needed, explain quorum as “the minimum number of members required to sit or make decisions.” |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; committee functioning |  |  |  |
| select_one m8_q03 | M8_Q03 | During case discussions, how often do different committee members actively participate rather than leaving the discussion to one person? | “Actively participate” includes asking questions, giving views, helping mediate, or contributing to a decision. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; collective decision-making |  |  |  |
| select_one m8_q04 | M8_Q04 | Before reaching a decision, agreement, or referral, how often does the committee discuss the case collectively? | This includes discussion before mediation outcome, decision, or referral. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; procedural regularity |  |  |  |
| select_one m8_q05 | M8_Q05 | How often does one person dominate the hearing, mediation, or decision-making process? | This is not asking for names. Ask neutrally and do not imply wrongdoing. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; institutional quality; elite capture / domination risk |  |  |  |
| select_one m8_q06 | M8_Q06 | When women are members of the LCC or committee, how often do they actively participate in case discussions or decisions? | Ask about participation in practice, not formal membership only. |  |  |  |  | ${m0_eligible} = 1 and ${M2_Q05} > 0 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; gender and inclusion safeguards |  |  |  |
| select_one m8_q07 | M8_Q07 | Is there any mechanism for women’s perspectives or concerns to be considered when the LCC handles cases? | Ask neutrally. This does not replace women’s formal participation but helps identify local practice. |  | quick |  |  | ${m0_eligible} = 1 and ${M2_Q05} = 0 |  | yes | This question is required. |  |  |  |  |  |  |  | Gender and inclusion safeguards; procedural fairness |  |  |  |
| select_one m8_q08 | M8_Q08 | When a case is resolved, decided, or referred, how often is the record signed, stamped, or otherwise validated by more than one LCC member? | Validation may include signatures, initials, stamp, or written confirmation by more than one member. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record validation and case-management quality |  |  |  |
| select_one m8_q09 | M8_Q09 | Does the LCC hold meetings to review pending cases, unresolved cases, referrals, or follow-up actions? | This refers to case review meetings, not only hearings with parties. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; case-management quality |  |  |  |
| select_one m8_q10 | M8_Q10 | How often are these case review meetings documented in writing? | Documentation may be in minutes, proceedings book, or case register notes. |  |  |  |  | ${m0_eligible} = 1 and (${M8_Q09} = 1 or ${M8_Q09} = 2 or ${M8_Q09} = 3) |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record-keeping quality |  |  |  |
| select_one m8_q11 | M8_Q11 | When committee members disagree about how to handle a case, what usually happens? | Ask about usual practice. Do not ask for examples involving real parties. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Procedural regularity; internal deliberation; Tyler (1988, 2017) inspired |  |  |  |
| select_one m8_q12 | M8_Q12 | How often do committee members disagree about whether a case should be handled locally or referred to another authority? | This captures uncertainty in triage and referral decisions. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Case classification/triage mechanism; CDFU training content |  |  |  |
| select_one m8_q13 | M8_Q13 | How consistent are LCC decisions across similar cases? | Similar cases means cases of a similar type and seriousness. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Procedural fairness: consistency/neutrality; Tyler (1988); Jackson (2018) |  |  |  |
| select_one m8_q14 | M8_Q14 | How confident are you that this LCC follows the same basic procedure when handling similar cases? | Self-assessed procedural consistency. Compare with record and vignette measures. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; procedural regularity |  |  |  |
| select_multiple m8_q15 | M8_Q15 | What are the main challenges to the LCC functioning as a committee when handling cases? Select up to three. | Ask neutrally. Do not imply fault. |  |  | count-selected(.) <= 3 | Select up to three options. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU maturity tool; process evaluation |  |  |  |
| select_one m8_v01 | M8_V01 | Enumerator verification: In the records seen today, is there evidence that more than one LCC member participates in hearings, mediation, decisions, or referrals? | Look for signatures, names, initials, members present, or similar evidence. Do not copy names. |  | quick |  |  | ${m0_eligible} = 1 and ${M0_Q20} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record audit protocol |  |  |  |
| select_one m8_v02 | M8_V02 | Enumerator verification: In the records seen today, is there evidence that decisions, agreements, or referrals are signed or validated by more than one member? | Do not record names or signatures; only record whether evidence exists. |  | quick |  |  | ${m0_eligible} = 1 and ${M0_Q20} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; record validation |  |  |  |
| text | M8_Q16 | Enumerator notes on committee sitting and decision-making process | Record relevant observations: respondent indicates decisions are mainly individual, committee absent, quorum unclear, women members absent, records contradict self-report, or any interruptions. Do not record case details. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Fieldwork data quality protocol |  |  |  |
| end group | end_m8_group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | m9_group | Module 9. Procedural fairness orientation and perceived local legitimacy |  |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | M9_Q00 | We will now ask about fairness, trust, and how community members view the Local Council Court. Please answer based on your own view and your experience with cases brought to the LCC. | Read aloud as transition. Emphasize that the questions are about general practice and perceptions, not any specific case. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Procedural justice and legitimacy literature; Tyler (1988, 2017); Jackson (2018); Creutzfeldt & Bradford (2016) |  |  |  |
| select_one m9_q01 | M9_Q01 | When the LCC handles a dispute, how important is it that each party has a chance to explain their side? | Measures fairness norm: voice. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Tyler (1988, 2017); procedural justice: voice |  |  |  |
| select_one m9_q02 | M9_Q02 | When the LCC handles a dispute, how important is it that the LCC treats both parties impartially. Which of the following statement do you agree with most | Measures fairness norm: neutrality/impartiality. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Tyler (1988, 2017); Jackson (2018) |  |  |  |
| select_one m9_q03 | M9_Q03 | When the LCC handles a dispute, how important is it that all parties are treated respectfully, even when they disagree? I will read a series of statements that some citizens make about their LC chairpersons. For each statement, please indicate whether it is true or not true in relation to your village LC court | Measures fairness norm: respect/dignity. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Tyler (1988, 2017); procedural justice: respect |  |  |  |
| select_one m9_q04 | M9_Q04 | When the LCC reaches a decision, agreement, or referral, how important is it to explain the reason to the parties? I On the scale of 1-5 with 1 being the lowest and 5, the most, please rank these statements according to how citizens think about the LC courts in this village. | Measures fairness norm: explanation/transparency. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Tyler (1988); procedural justice; Creutzfeldt & Bradford (2016) |  |  |  |
| select_one m9_q05 | M9_Q05 | When the LCC handles similar cases, how important is it that similar cases are treated in a consistent way? | Measures fairness norm: consistency. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Tyler (1988); Jackson (2018); procedural justice |  |  |  |
| select_one m9_q06 | M9_Q06 | When the LCC handles a dispute, how important is it that LCC members act honestly and with good motives? | Measures fairness norm: trustworthy motives/honesty. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Tyler (1988, 2017); Jackson (2018) |  |  |  |
| select_one m9_q12 | M9_Q12 | In your view, how fair do most community members think this LCC is when handling petty or minor disputes? | This is respondent’s perception of community view, not the respondent’s own evaluation. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Procedural justice and legitimacy; Tyler (2017); Jackson (2018); Cooper-Knock & Macdonald (2020) |  |  |  |
| select_one m9_q14 | M9_Q14 | In your view, how willing are community members to bring eligible petty or minor disputes to this LCC rather than going directly to police or court? | This captures perceived forum choice and local legitimacy. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Forum choice and informal justice literature; Krakowski & Kursani (2024); Cooper-Knock & Macdonald (2020) |  |  |  |
| select_one m9_q15 | M9_Q15 | In your view, how often do community members bypass the LCC and take eligible petty or minor disputes directly to police or court instead of Local Council Courts? | Bypass means going directly to police/court without first approaching the LCC. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Forum choice; lower court engagement literature; Macdonald et al. (2022); Krakowski & Kursani (2024) |  |  |  |
| select_multiple m9_q16 | M9_Q16 | What are the main reasons why some people may bypass the LCC and go take their cases directly to police or court instead of the local courts? Select up to three. | Ask neutrally. Do not imply that bypassing is always wrong. |  |  | count-selected(.) <= 3 | Select up to three options. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Forum-choice literature; Cooper-Knock & Macdonald (2020); Macdonald et al. (2022); Krakowski & Kursani (2024) |  |  |  |
| select_one m9_q17 | M9_Q17 | In your view, how serious is the risk that personal connections, favoritism, gifts, money, or pressure can influence local dispute handling in this community? | Ask neutrally and do not ask for names or examples. This is a perceived corruption/favoritism risk item. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Procedural justice: neutrality/honesty; Jackson (2018); Macdonald et al. (2022) |  |  |  |
| select_one m9_q18 | M9_Q18 | How confident are you that this LCC can maintain community trust while referring serious or ineligible cases to the appropriate authority and still be considered credible? | This links legitimacy with referral decisions. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Referral explanation and legitimacy; Tyler (1988); CDFU training content |  |  |  |
| select_one m9_q19 | M9_Q19 | Overall, how confident are you that this LCC handles eligible petty or minor disputes in a fair and respectful way? | Self-assessed fairness capacity. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Procedural justice and training evaluation logic |  |  |  |
| text | M9_Q20 | Enumerator notes on procedural fairness and perceived local legitimacy | Record relevant context: respondent seemed uncomfortable, another person influenced the answer, respondent mentioned trust/corruption concerns, or answers contradicted earlier modules. Do not record names or case details. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Fieldwork data quality protocol |  |  |  |
| end group | end_m9_group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | m10_group | Module 10. Gender, child protection, and serious-case safeguards |  |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | M10_Q00 | We will now ask about cases involving women, children, vulnerable persons, serious violence, and other sensitive situations. These questions are about general procedures and do not ask about any specific real person or case. | Read aloud. Do not ask for examples or details of real sensitive cases. If respondent discloses an active serious case, follow the approved safeguarding protocol. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Safeguarding framework; CDFU training content; Rockowitz et al. (2024); Albezreh et al. (2022); Mennen (2010) |  |  |  |
| select_multiple m10_q01 | M10_Q01 | Which types of cases should not remain only at the LCC for local resolution and should normally be referred to an appropriate authority or service? Select all that apply. | This is a core safeguard knowledge item. Final scoring should be validated with CDFU/legal expert. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; safeguarding framework; Rockowitz et al. (2024) |  |  |  |
| select_one m10_q02 | M10_Q02 | If a person reports sexual violence to the LCC, what should the LCC normally do first? | Do not probe for real cases. This is a safeguarding-critical item. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; Rockowitz et al. (2024); Albezreh et al. (2022) |  |  |  |
| select_one m10_q03 | M10_Q03 | If the LCC learns that a child may be abused, neglected, or at immediate risk of harm, what should the LCC normally do first? | This is a child-protection safeguard item. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; safeguarding framework; Mennen (2010); Rockowitz et al. (2024) |  |  |  |
| select_one m10_q04 | M10_Q04 | If a case involves serious assault, severe injury, a weapon, or an ongoing threat, what should the LCC normally do first? | This tests recognition of serious-violence referral needs. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; safeguarding framework |  |  |  |
| select_one m10_q05 | M10_Q05 | When the LCC receives a sensitive case, how often does it take steps to protect confidentiality and avoid unnecessary disclosure of personal details? | Sensitive cases include SGBV, child protection, family violence, serious assault, and other vulnerable-person cases. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Safeguarding framework; survivor-centered response; Albezreh et al. (2022); Rockowitz et al. (2024) |  |  |  |
| select_one m10_q06 | M10_Q06 | When women are parties to a case, how often does the LCC take steps to ensure they can speak safely and be heard during the process? | This does not ask about a specific real case. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Gender-sensitive justice; procedural fairness; Tyler (1988, 2017); Rockowitz et al. (2024) |  |  |  |
| select_one m10_q07 | M10_Q07 | In your view, do cases involving children, survivors of violence, persons with disabilities, or other vulnerable persons require special handling by the LCC? | If needed, explain “special handling” as additional care, confidentiality, safety, referral, or support. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Safeguarding and inclusion framework; Rockowitz et al. (2024); Mennen (2010) |  |  |  |
| select_multiple m10_q08 | M10_Q08 | What special handling may be needed for these cases? Select all that apply. | Do not ask for examples. |  |  |  |  | ${m0_eligible} = 1 and ${M10_Q07} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Safeguarding framework; survivor-centered and child-sensitive response |  |  |  |
| select_multiple m10_q09 | M10_Q09 | If a sensitive case needs referral, where would the LCC normally refer or direct the person? Select all that apply. | This measures referral pathway knowledge. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; multisectoral referral literature; Albezreh et al. (2022); Rockowitz et al. (2024) |  |  |  |
| select_one m10_q10 | M10_Q10 | How confident are you that you know where to refer sexual violence, child protection, or serious violence cases? | Self-efficacy item; compare with knowledge and vignette items. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Training evaluation logic; CDFU referral content; Albezreh et al. (2022) |  |  |  |
| select_one m10_q11 | M10_Q11 | How confident are you that you can explain to community members why sensitive or serious cases must be referred instead of handled only by the LCC? | This captures ability to preserve legitimacy while applying safeguards. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Procedural justice: explanation; Tyler (1988, 2017); CDFU training content |  |  |  |
| select_multiple m10_q12 | M10_Q12 | What are the main barriers that make appropriate referral of sensitive or serious cases difficult? Select up to three. | Ask neutrally. Do not ask about real cases. |  |  | count-selected(.) <= 3 | Select up to three options. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Safeguarding barriers; legal pluralism; Mennen (2010); Rockowitz et al. (2024) |  |  |  |
| select_one m10_q13 | M10_Q13 | How often does community pressure make it difficult for the LCC to refer sensitive or serious cases instead of handling them locally? | This captures inappropriate informalization pressure. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Boundary conditions and informal justice risks; Mennen (2010); Pavlich (1996) inspired |  |  |  |
| select_one m10_q14 | M10_Q14 | If the LCC refers a sensitive case, how often does it avoid recording unnecessary personal details that could expose or harm the survivor, child, or vulnerable person? | This does not mean “do not document.” It means document only what is necessary and protect confidentiality. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Data protection and safeguarding protocol; survivor-centered response |  |  |  |
| select_one m10_v01 | M10_V01 | Enumerator verification: In the records seen today, is there evidence that sensitive or serious cases are marked as referred or directed to another authority when applicable? | Do not copy case details. Only assess whether serious/sensitive cases, if visible, show referral or direction. |  | quick |  |  | ${m0_eligible} = 1 and ${M0_Q20} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU maturity tool; safeguarding record audit |  |  |  |
| select_one m10_v02 | M10_V02 | Enumerator verification: Based on the records seen today, do sensitive case records appear to be stored or written in a way that protects confidentiality? | Do not look for more details than necessary. If no sensitive records are visible, choose option 4. |  | quick |  |  | ${m0_eligible} = 1 and ${M0_Q20} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Data protection and safeguarding protocol |  |  |  |
| text | M10_Q15 | Enumerator notes on gender, child protection, and serious-case safeguards | Record relevant observations only at a general level. Do not record names, identifying details, allegations, or sensitive case facts. If any disclosure requires action, follow safeguarding protocol and document only through the approved safeguarding channel. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Fieldwork data quality and safeguarding protocol |  |  |  |
| end group | end_m10_group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | m11_group | Module 11. Perceptions toward incarcerated and formerly incarcerated persons; reintegration norms |  |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | M11_Q00 | We will now ask about people who have been released from prison or detention and return to their communities. These questions are about general views and community support, not about any specific person. | Read aloud. Do not ask for names or details of specific formerly incarcerated persons. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU training content; Legatum reintegration results framework; restorative justice literature |  |  |  |
| select_one m11_q01 | M11_Q01 | In your view, can people who have been released from prison or detention successfully reintegrate into community life? | Ask neutrally. Do not imply a preferred answer. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; reintegration norms; Menkel-Meadow (2007); Braithwaite (2021) inspired |  |  |  |
| select_one m11_q02 | M11_Q02 | How important is it for community leaders, including LC leaders, to support the reintegration of people released from prison or detention? | Measures perceived LC/community responsibility. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; Legatum reintegration results framework |  |  |  |
| select_one m11_q03 | M11_Q03 | How willing would you be, in your LC/LCC role, to support the peaceful return of a formerly incarcerated person to the community? | This is about appropriate support within the LC/LCC role, not personal financial support. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; reintegration norms |  |  |  |
| select_one m11_q04 | M11_Q04 | Please tell me how much you agree or disagree with this statement: “People released from prison or detention should be given a fair chance to participate in community life again.” | Attitude item. Keep wording neutral and read exactly. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Reintegration norms; restorative justice literature |  |  |  |
| select_one m11_q05 | M11_Q05 | Please tell me how much you agree or disagree with this statement: “People released from prison or detention should generally be avoided by community members.” | This is a stigma/exclusion item. Reverse-code in analysis. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; stigma/reintegration norms |  |  |  |
| select_one m11_q06 | M11_Q06 | Please tell me how much you agree or disagree with this statement: “Most people released from prison or detention are likely to commit another offence.” | This measures perceived reoffending risk/stigma. Reverse-code depending on index direction. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Legatum reincarceration prevention framework; reintegration/stigma literature |  |  |  |
| select_one m11_q07 | M11_Q07 | Please tell me how much you agree or disagree with this statement: “Communities have a role in helping formerly incarcerated persons avoid future conflict or offending.” | Measures belief in community role in prevention and reintegration. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; Legatum reintegration results framework |  |  |  |
| select_one m11_q08 | M11_Q08 | If a dispute involves a formerly incarcerated person and another community member, how comfortable would you be helping to mediate or guide the case if it is within the LCC’s mandate? | Emphasize “if it is within the LCC’s mandate.” Serious cases still require referral. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; ADR/reintegration interface; restorative justice literature |  |  |  |
| select_one m11_q09 | M11_Q09 | How willing would you be to help connect a formerly incarcerated person to appropriate community support, services, or local leaders if they needed help reintegrating? | This does not require respondent to provide money or personal resources. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; Legatum reintegration results framework |  |  |  |
| select_multiple m11_q10 | M11_Q10 | What types of support can help a person released from prison or detention reintegrate successfully? Select all that apply. | Do not suggest that the LC itself must provide all support. |  |  | (not(selected(., '9') and count-selected(.) > 1)) | Do not combine 'None' or 'Do not know' with other options. | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Legatum reintegration conditions; CDFU training content |  |  |  |
| select_one m11_q11 | M11_Q11 | In your view, how common is stigma or negative treatment toward people who return to the community after prison or detention? | Ask about general perception, not a specific person. |  |  |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Reintegration norms; stigma measurement; Legatum results framework |  |  |  |
| select_multiple m11_q12 | M11_Q12 | What are the main reasons community members may be reluctant to accept or support a formerly incarcerated person? Select up to three. | Ask neutrally. Do not ask for names or examples. |  |  | count-selected(.) <= 3 | Select up to three options. | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Reintegration barriers; Legatum reintegration framework |  |  |  |
| select_one m11_q13 | M11_Q13 | In the last 6 months, has this LC/LCC handled any dispute, tension, or community concern involving a formerly incarcerated person returning to the community? | Do not ask for names or case details. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; reintegration-related case handling |  |  |  |
| select_multiple m11_q14 | M11_Q14 | What type of issue did the LC/LCC handle? Select all that apply. | Do not record names, locations, or identifying case details. |  |  |  |  | ${m0_eligible} = 1 and ${M11_Q13} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | Reintegration-related case typology; CDFU training content |  |  |  |
| select_one m11_q15 | M11_Q15 | How did the LC/LCC mainly respond to the issue involving a formerly incarcerated person? | Ask for the main response only. Do not collect case details. |  |  |  |  | ${m0_eligible} = 1 and ${M11_Q13} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; ADR/reintegration mechanism |  |  |  |
| select_one m11_q16 | M11_Q16 | How confident are you that the LC/LCC can help reduce community tensions involving formerly incarcerated persons, when the matter is within its role and mandate? | Emphasize “within its role and mandate.” |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; reintegration/community conflict mechanism |  |  |  |
| select_one m11_q17 | M11_Q17 | How confident are you that you know where to refer a formerly incarcerated person who needs support beyond what the LC/LCC can provide? | Support may include psychosocial, livelihood, legal, or social service support. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; referral/support pathway knowledge |  |  |  |
| select_one m11_q18 | M11_Q18 | In your view, should support for formerly incarcerated persons be part of the broader role of community justice and local leadership? | This captures normative alignment with the intervention content. |  | quick |  |  | ${m0_eligible} = 1 |  | yes | This question is required. |  |  |  |  |  |  |  | CDFU training content; Legatum reintegration results framework |  |  |  |
| select_multiple m11_q19 | M11_Q19 | What role should LC or community leaders play in supporting reintegration? Select up to three. | Ask for broad roles, not commitments to provide services personally. |  |  | count-selected(.) <= 3 | Select up to three options. | ${m0_eligible} = 1 and ${M11_Q18} = 1 |  |  |  |  |  |  |  |  |  |  | CDFU training content; reintegration/community leadership role |  |  |  |
| text | M11_Q20 | Enumerator notes on perceptions toward incarcerated and formerly incarcerated persons | Record relevant general observations only. Do not record names, identifying details, or allegations involving specific persons. If a current serious case is disclosed, follow safeguarding protocol. |  |  |  |  | ${m0_eligible} = 1 |  |  |  |  |  |  |  |  |  |  | Fieldwork data quality and safeguarding protocol |  |  |  |
| end group | end_m11_group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: choices
| list_name | value | label | image | filter |
| --- | --- | --- | --- | --- |
| yesno | 1 | Yes |  |  |
| yesno | 0 | No |  |  |
| Enum | 1 | Kanyesigye Linnet |  |  |
| Enum | 2 | Julius Baguma |  |  |
| Enum | 3 | Hope Kwarikunda |  |  |
| Enum | 4 | Asiimwe Isaac |  |  |
| Enum | 5 | Sharon  Shammah Talent |  |  |
| Enum | 6 | Ashabe Gina |  |  |
| Enum | 7 | Osbert |  |  |
| Enum | 8 | Atukwase Sharon |  |  |
| Enum | 9 | Najib Kizito |  |  |
| Enum | 10 | Natuhwera Sylivia |  |  |
| Enum | 11 | Kagoro Meliza |  |  |
| Enum | 12 | Ashaba Andrew |  |  |
| m0_q13 | 1 | LC I Chairperson |  |  |
| m0_q13 | 2 | Vice Chairperson |  |  |
| m0_q13 | 3 | Secretary |  |  |
| m0_q13 | 4 | Committee member / court member |  |  |
| m0_q13 | 5 | Other LC/LCC role |  |  |
| m0_q15 | 1 | Directly trained LC representative |  |  |
| m0_q15 | 2 | Mentor-ready / selected mentor |  |  |
| m0_q15 | 3 | Neighboring-village LC respondent |  |  |
| m0_q15 | 4 | Other LC respondent |  |  |
| m0_q16 | 1 | Yes |  |  |
| m0_q16 | 0 | No |  |  |
| m0_q18 | 1 | Yes |  |  |
| m0_q18 | 0 | No |  |  |
| m0_q20 | 1 | Yes, records are present and can be consulted |  |  |
| m0_q20 | 2 | Yes, records exist but are not present during the interview |  |  |
| m0_q20 | 3 | No records exist |  |  |
| m0_q20 | 98 | Respondent does not know |  |  |
| m0_q21 | 1 | Yes |  |  |
| m0_q21 | 0 | No |  |  |
| m0_q22 | 1 | LC I Chairperson |  |  |
| m0_q22 | 2 | Vice Chairperson |  |  |
| m0_q22 | 3 | Secretary |  |  |
| m0_q22 | 4 | Committee member / court member |  |  |
| m0_q22 | 5 | Other community authority |  |  |
| m0_q22 | 98 | Other |  |  |
| m0_q23 | 1 | Yes, fully private |  |  |
| m0_q23 | 2 | Partly private |  |  |
| m0_q23 | 3 | Not private |  |  |
| m0_q24 | 1 | English |  |  |
| m0_q24 | 2 | Runyankore / Runyakitara |  |  |
| m0_q24 | 98 | Other |  |  |
| m1_q01 | 1 | LC I Chairperson |  |  |
| m1_q01 | 2 | Vice Chairperson |  |  |
| m1_q01 | 3 | Secretary |  |  |
| m1_q01 | 4 | Committee member / court member |  |  |
| m1_q01 | 5 | Other LC/LCC role |  |  |
| m1_q03 | 1 | Yes |  |  |
| m1_q03 | 0 | No |  |  |
| m1_q06 | 1 | Male |  |  |
| m1_q06 | 2 | Female |  |  |
| m1_q06 | 98 | Other / prefer to self-describe |  |  |
| m1_q06 | 99 | Prefer not to say |  |  |
| m1_q07 | 1 | 18–24 years |  |  |
| m1_q07 | 2 | 25–34 years |  |  |
| m1_q07 | 3 | 35–44 years |  |  |
| m1_q07 | 4 | 45–54 years |  |  |
| m1_q07 | 5 | 55–64 years |  |  |
| m1_q07 | 6 | 65 years or older |  |  |
| m1_q07 | 99 | Prefer not to say |  |  |
| m1_q08 | 0 | No formal education |  |  |
| m1_q08 | 1 | Some primary |  |  |
| m1_q08 | 2 | Completed primary |  |  |
| m1_q08 | 3 | Some secondary |  |  |
| m1_q08 | 4 | Completed secondary |  |  |
| m1_q08 | 5 | Vocational / technical training, other than University |  |  |
| m1_q08 | 6 | Tertiary / university |  |  |
| m1_q08 | 98 | Other |  |  |
| m1_q09 | 0 | Not comfortable at all |  |  |
| m1_q09 | 1 | Slightly comfortable |  |  |
| m1_q09 | 2 | Moderately comfortable |  |  |
| m1_q09 | 3 | Very comfortable |  |  |
| m1_q09 | 4 | Completely comfortable |  |  |
| m1_q10 | 1 | English |  |  |
| m1_q10 | 2 | Runyankore / Runyakitara |  |  |
| m1_q10 | 3 | Luganda |  |  |
| m1_q10 | 4 | Kiswahili |  |  |
| m1_q10 | 95 | None / cannot comfortably complete written records |  |  |
| m1_q10 | 98 | Other |  |  |
| m1_q11 | 1 | Yes |  |  |
| m1_q11 | 0 | No |  |  |
| m1_q11 | 98 | Do not know / cannot remember |  |  |
| m1_q12 | 1 | Mediation / ADR |  |  |
| m1_q12 | 2 | Local Council Court procedures |  |  |
| m1_q12 | 3 | Case recording / record keeping |  |  |
| m1_q12 | 4 | Referral to police or courts |  |  |
| m1_q12 | 5 | Child protection |  |  |
| m1_q12 | 6 | Gender-based violence / SGBV |  |  |
| m1_q12 | 7 | Reintegration of formerly incarcerated persons |  |  |
| m1_q12 | 98 | Other |  |  |
| m1_q13 | 1 | Yes |  |  |
| m1_q13 | 0 | No |  |  |
| m1_q14 | 1 | Land or boundary disputes |  |  |
| m1_q14 | 2 | Family or marital disputes |  |  |
| m1_q14 | 3 | Debt or money-related disputes |  |  |
| m1_q14 | 4 | Neighbor disputes / verbal conflicts |  |  |
| m1_q14 | 5 | Minor assault or physical fight |  |  |
| m1_q14 | 6 | Property damage or theft-related matter |  |  |
| m1_q14 | 7 | Child-related case |  |  |
| m1_q14 | 8 | Sexual violence or gender-based violence case |  |  |
| m1_q14 | 95 | None of these |  |  |
| m1_q14 | 98 | Other |  |  |
| m1_q15 | 0 | Less than 1 hour |  |  |
| m1_q15 | 1 | 1–3 hours |  |  |
| m1_q15 | 2 | 4–7 hours |  |  |
| m1_q15 | 3 | 8–14 hours |  |  |
| m1_q15 | 4 | 15 hours or more |  |  |
| m1_q16 | 1 | Yes, personal phone |  |  |
| m1_q16 | 2 | Yes, shared phone |  |  |
| m1_q16 | 0 | No working phone access |  |  |
| m1_q17 | 1 | Yes |  |  |
| m1_q17 | 0 | No |  |  |
| m2_q03 | 1 | Yes |  |  |
| m2_q03 | 0 | No |  |  |
| m2_q03 | 98 | Do not know |  |  |
| m2_q07 | 1 | At least once per week |  |  |
| m2_q07 | 2 | Two to three times per month |  |  |
| m2_q07 | 3 | About once per month |  |  |
| m2_q07 | 4 | Less than once per month |  |  |
| m2_q07 | 5 | Only when a case arises |  |  |
| m2_q07 | 6 | It does not currently meet or sit |  |  |
| m2_q08 | 1 | Yes, always or almost always |  |  |
| m2_q08 | 2 | Yes, sometimes |  |  |
| m2_q08 | 3 | Rarely |   |  |
| m2_q08 | 4 | Never |  |  |
| m2_q08 | 98 | Do not know |  |  |
| m2_q09 | 1 | Yes, a regular fixed place |  |  |
| m2_q09 | 2 | Sometimes, but not always the same place |  |  |
| m2_q09 | 3 | No regular place |  |  |
| m2_q12 | 1 | Yes, formal register/case book exists |  |  |
| m2_q12 | 2 | Records are kept, but not in a formal register/case book |  |  |
| m2_q12 | 3 | No case records are kept |  |  |
| m2_q12 | 98 | Do not know |  |  |
| m2_q13 | 1 | Yes, Our case records are fully up to date |  |  |
| m2_q13 | 2 | Our case records are partly up to date |  |  |
| m2_q13 | 3 | Our case records are not up to date |  |  |
| m2_q13 | 98 | Do not know (Don't read) |  |  |
| m2_q14 | 1 | Yes, We have enough materials are available for case handleing and record keeping |  |  |
| m2_q14 | 2 | Some materials are available, but not enough |  |  |
| m2_q14 | 3 | No basic materials are available |  |  |
| m2_q14 | 98 | Do not know |  |  |
| m2_q15 | 1 | Case register / case book |  |  |
| m2_q15 | 2 | Proceedings book |  |  |
| m2_q15 | 3 | Paper or forms |  |  |
| m2_q15 | 4 | Pens or basic stationery |  |  |
| m2_q15 | 5 | Secure storage for records |  |  |
| m2_q15 | 6 | Space or furniture for hearings |  |  |
| m2_q15 | 98 | Other |  |  |
| m2_q16 | 1 | Yes, formal register/case book seen |  |  |
| m2_q16 | 2 | Yes, informal written records seen |  |  |
| m2_q16 | 0 | No records seen |  |  |
| m2_q17 | 1 | Yes, entries appear up to date |  |  |
| m2_q17 | 2 | Partly up to date |  |  |
| m2_q17 | 3 | Not up to date |  |  |
| m2_q17 | 98 | Cannot determine |  |  |
| m3_q01 | 1 | Written LCC records or register |  |  |
| m3_q01 | 2 | Respondent recall / memory |  |  |
| m3_q01 | 3 | Both records and recall |  |  |
| m3_q04 | 1 | Land or boundary disputes |  |  |
| m3_q04 | 2 | Family or marital disputes |  |  |
| m3_q04 | 3 | Debt, loan, or money-related disputes |  |  |
| m3_q04 | 4 | Neighbor disputes, insults, threats, or verbal conflicts |  |  |
| m3_q04 | 5 | Minor assault or physical fight |  |  |
| m3_q04 | 6 | Property damage or theft-related matter |  |  |
| m3_q04 | 7 | Child-related case |  |  |
| m3_q04 | 8 | Sexual violence or gender-based violence case |  |  |
| m3_q04 | 9 | Alcohol, disorderly conduct, or public disturbance |  |  |
| m3_q04 | 10 | Reintegration or conflict involving a formerly incarcerated person |  |  |
| m3_q04 | 98 | Other |  |  |
| m3_q05 | 1 | Land or boundary disputes |  |  |
| m3_q05 | 2 | Family or marital disputes |  |  |
| m3_q05 | 3 | Debt, loan, or money-related disputes |  |  |
| m3_q05 | 4 | Neighbor disputes, insults, threats, or verbal conflicts |  |  |
| m3_q05 | 5 | Minor assault or physical fight |  |  |
| m3_q05 | 6 | Property damage or theft-related matter |  |  |
| m3_q05 | 7 | Child-related case |  |  |
| m3_q05 | 8 | Sexual violence or gender-based violence case |  |  |
| m3_q05 | 9 | Alcohol, disorderly conduct, or public disturbance |  |  |
| m3_q05 | 10 | Reintegration or conflict involving a formerly incarcerated person |  |  |
| m3_q05 | 98 | Other |  |  |
| m3_q06 | 0 | None |  |  |
| m3_q06 | 1 | Less than one-quarter |  |  |
| m3_q06 | 2 | About one-quarter |  |  |
| m3_q06 | 3 | About half |  |  |
| m3_q06 | 4 | About three-quarters |  |  |
| m3_q06 | 5 | Almost all or all cases |  |  |
| m3_q06 | 98 | Do not know |  |  |
| m3_q11 | 1 | Police |  |  |
| m3_q11 | 2 | Court |  |  |
| m3_q11 | 3 | Another LC/LCC |  |  |
| m3_q11 | 4 | Parish or sub-county official |  |  |
| m3_q11 | 5 | Community leader / elder / religious leader |  |  |
| m3_q11 | 6 | Probation / child protection actor |  |  |
| m3_q11 | 98 | Other |  |  |
| m3_q13 | 1 | Police |  |  |
| m3_q13 | 2 | Court |  |  |
| m3_q13 | 3 | Probation / child protection actor |  |  |
| m3_q13 | 4 | Health facility or medical/legal service |  |  |
| m3_q13 | 5 | Parish / sub-county official |  |  |
| m3_q13 | 6 | Another LC/LCC |  |  |
| m3_q13 | 98 | Other |  |  |
| m3_q14 | 1 | Increased a lot |  |  |
| m3_q14 | 2 | Increased a little |  |  |
| m3_q14 | 3 | Stayed about the same |  |  |
| m3_q14 | 4 | Decreased a little |  |  |
| m3_q14 | 5 | Decreased a lot |  |  |
| m3_q14 | 98 | Do not know |  |  |
| m3_q15 | 1 | More disputes in the community |  |  |
| m3_q15 | 2 | More people know about the LCC |  |  |
| m3_q15 | 3 | More people trust the LCC |  |  |
| m3_q15 | 4 | Police/courts/other actors refer more cases to the LCC |  |  |
| m3_q15 | 5 | Records are now kept more completely |  |  |
| m3_q15 | 6 | Recent local conflict or specific event increased disputes |  |  |
| m3_q15 | 7 | Training or sensitization changed reporting behavior |  |  |
| m3_q15 | 98 | Other |  |  |
| m3_q16 | 1 | Fewer disputes in the community |  |  |
| m3_q16 | 2 | More cases go directly to police or courts |  |  |
| m3_q16 | 3 | People do not know when to use the LCC |  |  |
| m3_q16 | 4 | People do not trust the LCC |  |  |
| m3_q16 | 5 | Some cases are resolved informally before reaching the LCC |  |  |
| m3_q16 | 6 | Records are less complete than before |  |  |
| m3_q16 | 7 | LCC is less available or less active than before |  |  |
| m3_q16 | 98 | Other |  |  |
| m3_q17 | 1 | Not confident |  |  |
| m3_q17 | 2 | Slightly confident |  |  |
| m3_q17 | 3 | Moderately confident |  |  |
| m3_q17 | 4 | Very confident |  |  |
| m3_q17 | 5 | Completely confident |  |  |
| m4_q01 | 1 | Minor land or boundary disputes |  |  |
| m4_q01 | 2 | Family or marital disagreements that do not involve serious violence |  |  |
| m4_q01 | 3 | Debt or small money-related disputes |  |  |
| m4_q01 | 4 | Neighbor disputes, insults, or verbal conflicts |  |  |
| m4_q01 | 5 | Minor property damage |  |  |
| m4_q01 | 6 | Minor assault or physical fight, where legally permitted |  |  |
| m4_q01 | 7 | Sexual violence cases |  |  |
| m4_q01 | 8 | Serious assault causing severe injury |  |  |
| m4_q01 | 9 | Child abuse or serious child protection cases |  |  |
| m4_q01 | 10 | Murder or capital offences |  |  |
| m4_q01 | 98 | Do not know |  |  |
| m4_q02 | 1 | Sexual violence or rape |  |  |
| m4_q02 | 2 | Defilement or sexual abuse of a child |  |  |
| m4_q02 | 3 | Serious physical violence or severe injury |  |  |
| m4_q02 | 4 | Murder or suspected murder |  |  |
| m4_q02 | 5 | Serious theft, robbery, or burglary |  |  |
| m4_q02 | 6 | Cases involving immediate risk to a child |  |  |
| m4_q02 | 7 | Minor boundary dispute between neighbors |  |  |
| m4_q02 | 8 | Small debt dispute between two adults |  |  |
| m4_q02 | 98 | Do not know |  |  |
| m4_q04 | 1 | Try to resolve it locally to avoid delays |  |  |
| m4_q04 | 2 | Refer or direct it to the appropriate authority |  |  |
| m4_q04 | 3 | Ignore the case because it is not the LCC’s responsibility |  |  |
| m4_q04 | 4 | Ask the parties to settle privately without recording anything |  |  |
| m4_q04 | 98 | Do not know |  |  |
| m4_q05 | 1 | Date the case was received |  |  |
| m4_q05 | 2 | Names or identifiers of the parties |  |  |
| m4_q05 | 3 | Type or nature of the case |  |  |
| m4_q05 | 4 | Steps taken by the LCC |  |  |
| m4_q05 | 5 | Outcome, agreement, decision, or referral |  |  |
| m4_q05 | 6 | Date the case was closed or referred |  |  |
| m4_q05 | 7 | Nothing needs to be documented if the case is resolved peacefully |  |  |
| m4_q05 | 98 | Do not know |  |  |
| m4_q06 | 1 | Record that the case was received |  |  |
| m4_q06 | 2 | Check whether the case is within LCC mandate |  |  |
| m4_q06 | 3 | Inform or summon the relevant parties |  |  |
| m4_q06 | 4 | Give both sides an opportunity to be heard |  |  |
| m4_q06 | 5 | Sit as a committee where required |  |  |
| m4_q06 | 6 | Decide the case before hearing one side if the matter seems obvious |  |  |
| m4_q06 | 7 | Record the outcome or referral |  |  |
| m4_q06 | 98 | Do not know |  |  |
| m4_q07 | 1 | For any case, including serious violence, if the parties agree |  |  |
| m4_q07 | 2 | For eligible petty or minor disputes where local resolution is allowed and safe |  |  |
| m4_q07 | 3 | Only after police or court have already decided the case |  |  |
| m4_q07 | 4 | Never; mediation should not be used by LCCs |  |  |
| m4_q07 | 98 | Do not know |  |  |
| m4_q08 | 1 | A case involves sexual violence |  |  |
| m4_q08 | 2 | A case involves a child at risk of harm |  |  |
| m4_q08 | 3 | A case involves serious injury or threat to life |  |  |
| m4_q08 | 4 | The LCC lacks jurisdiction over the case |  |  |
| m4_q08 | 5 | Parties refuse to comply with a lawful local agreement or decision |  |  |
| m4_q08 | 6 | A minor boundary dispute is suitable for local mediation |  |  |
| m4_q08 | 7 | A small debt dispute can be safely mediated locally |  |  |
| m4_q08 | 98 | Do not know |  |  |
| m4_q09 | 1 | They are ways to manage cases while respecting legal procedures and reducing unnecessary detention where legally appropriate |  |  |
| m4_q09 | 2 | They mean that the person is automatically innocent and the case is closed |  |  |
| m4_q09 | 3 | They are punishments that LCCs can impose in all cases |  |  |
| m4_q09 | 4 | They are not related to the justice process |  |  |
| m4_q09 | 98 | Do not know |  |  |
| m4_q10 | 0 | Not confident at all |  |  |
| m4_q10 | 1 | Slightly confident |  |  |
| m4_q10 | 2 | Moderately confident |  |  |
| m4_q10 | 3 | Very confident |  |  |
| m4_q10 | 4 | Completely confident |  |  |
| m4_v01_q1 | 1 | Yes, the LCC can handle or help resolve it locally |  |  |
| m4_v01_q1 | 2 | The LCC can take initial steps but should also involve another authority |  |  |
| m4_v01_q1 | 3 | No, the LCC should refer immediately and not attempt local handling |  |  |
| m4_v01_q1 | 98 | Do not know |  |  |
| m4_v01_q2 | 1 | Record the case, summon or invite both parties, and attempt local mediation/ADR |  |  |
| m4_v01_q2 | 2 | Decide immediately in favor of the person who came first |  |  |
| m4_v01_q2 | 3 | Refer immediately to police |  |  |
| m4_v01_q2 | 4 | Refer immediately to court |  |  |
| m4_v01_q2 | 5 | Refer to probation/child protection |  |  |
| m4_v01_q2 | 98 | Do not know |  |  |
| m4_v01_q3 | 1 | LCC only at first stage |  |  |
| m4_v01_q3 | 2 | Police |  |  |
| m4_v01_q3 | 3 | Court |  |  |
| m4_v01_q3 | 4 | Probation / child protection actor |  |  |
| m4_v01_q3 | 5 | Health facility / medical provider |  |  |
| m4_v01_q3 | 6 | Parish or sub-county official |  |  |
| m4_v01_q3 | 98 | Other |  |  |
| m4_v02_q1 | 1 | Yes, the LCC can handle or help resolve it locally |  |  |
| m4_v02_q1 | 2 | The LCC can take initial steps but should also involve another authority |  |  |
| m4_v02_q1 | 3 | No, the LCC should refer immediately and not attempt local handling |  |  |
| m4_v02_q1 | 98 | Do not know |  |  |
| m4_v02_q2 | 1 | Record the case, hear both sides, and attempt mediation/ADR if safe and appropriate |  |  |
| m4_v02_q2 | 2 | Decide immediately based on which spouse is more convincing |  |  |
| m4_v02_q2 | 3 | Refer immediately to police |  |  |
| m4_v02_q2 | 4 | Refer immediately to court |  |  |
| m4_v02_q2 | 5 | Refer to probation/child protection |  |  |
| m4_v02_q2 | 98 | Do not know |  |  |
| m4_v02_q3 | 1 | LCC only at first stage |  |  |
| m4_v02_q3 | 2 | Police |  |  |
| m4_v02_q3 | 3 | Court |  |  |
| m4_v02_q3 | 4 | Probation / child protection actor |  |  |
| m4_v02_q3 | 5 | Health facility / medical provider |  |  |
| m4_v02_q3 | 6 | Parish or sub-county official |  |  |
| m4_v02_q3 | 98 | Other |  |  |
| m4_v03_q1 | 1 | Yes, the LCC can handle or help resolve it locally |  |  |
| m4_v03_q1 | 2 | The LCC can take initial steps but should also involve another authority |  |  |
| m4_v03_q1 | 3 | No, the LCC should refer immediately and not attempt local handling |  |  |
| m4_v03_q1 | 98 | Do not know |  |  |
| m4_v03_q2 | 1 | Record the case, hear both parties, and attempt mediation or agreement if within mandate |  |  |
| m4_v03_q2 | 2 | Order repayment immediately without hearing the borrower |  |  |
| m4_v03_q2 | 3 | Refer immediately to police |  |  |
| m4_v03_q2 | 4 | Refer immediately to court |  |  |
| m4_v03_q2 | 5 | Refer to probation/child protection |  |  |
| m4_v03_q2 | 98 | Do not know |  |  |
| m4_v03_q3 | 1 | LCC only at first stage |  |  |
| m4_v03_q3 | 2 | Police |  |  |
| m4_v03_q3 | 3 | Court |  |  |
| m4_v03_q3 | 4 | Probation / child protection actor |  |  |
| m4_v03_q3 | 5 | Health facility / medical provider |  |  |
| m4_v03_q3 | 6 | Parish or sub-county official |  |  |
| m4_v03_q3 | 98 | Other |  |  |
| m4_v04_q1 | 1 | Yes, the LCC can handle or help resolve it locally |  |  |
| m4_v04_q1 | 2 | The LCC can take initial steps but should also involve another authority |  |  |
| m4_v04_q1 | 3 | No, the LCC should refer immediately and not attempt local handling |  |  |
| m4_v04_q1 | 98 | Do not know |  |  |
| m4_v04_q2 | 1 | Record the case, assess safety and seriousness, and proceed locally only if within mandate and safe |  |  |
| m4_v04_q2 | 2 | Mediate immediately without recording the case |  |  |
| m4_v04_q2 | 3 | Refer immediately to police |  |  |
| m4_v04_q2 | 4 | Refer immediately to court |  |  |
| m4_v04_q2 | 5 | Refer to probation/child protection |  |  |
| m4_v04_q2 | 98 | Do not know |  |  |
| m4_v04_q3 | 1 | LCC only at first stage |  |  |
| m4_v04_q3 | 2 | Police |  |  |
| m4_v04_q3 | 3 | Court |  |  |
| m4_v04_q3 | 4 | Probation / child protection actor |  |  |
| m4_v04_q3 | 5 | Health facility / medical provider |  |  |
| m4_v04_q3 | 6 | Parish or sub-county official |  |  |
| m4_v04_q3 | 98 | Other |  |  |
| m4_v05_q1 | 1 | Yes, the LCC can resolve it locally without referral |  |  |
| m4_v05_q1 | 2 | The LCC can take protective initial steps but should involve the appropriate authority |  |  |
| m4_v05_q1 | 3 | No, the LCC should refer immediately and not attempt local resolution |  |  |
| m4_v05_q1 | 98 | Do not know |  |  |
| m4_v05_q2 | 1 | Try to reconcile the family privately without recording or referring |  |  |
| m4_v05_q2 | 2 | Record the concern, ensure immediate safety, and refer or notify the appropriate child protection/probation authority |  |  |
| m4_v05_q2 | 3 | Wait until the child personally brings the case |  |  |
| m4_v05_q2 | 4 | Treat it only as a family disagreement for local mediation |  |  |
| m4_v05_q2 | 98 | Do not know |  |  |
| m4_v05_q3 | 1 | LCC only at first stage |  |  |
| m4_v05_q3 | 2 | Police |  |  |
| m4_v05_q3 | 3 | Court |  |  |
| m4_v05_q3 | 4 | Probation / child protection actor |  |  |
| m4_v05_q3 | 5 | Health facility / medical provider |  |  |
| m4_v05_q3 | 6 | Parish or sub-county official |  |  |
| m4_v05_q3 | 98 | Other |  |  |
| m4_v06_q1 | 1 | Yes, the LCC can resolve it locally through mediation |  |  |
| m4_v06_q1 | 2 | The LCC can only provide initial support and should refer immediately to appropriate authorities/services |  |  |
| m4_v06_q1 | 3 | No, the LCC should do nothing because it is outside its mandate |  |  |
| m4_v06_q1 | 98 | Do not know |  |  |
| m4_v06_q2 | 1 | Mediate between the woman and the alleged perpetrator |  |  |
| m4_v06_q2 | 2 | Keep the matter private and ask the families to settle it |  |  |
| m4_v06_q2 | 3 | Support the survivor’s safety and refer or notify the appropriate police/medical/legal services immediately |  |  |
| m4_v06_q2 | 4 | Wait until the alleged perpetrator also comes to the LCC |  |  |
| m4_v06_q2 | 98 | Do not know |  |  |
| m4_v06_q3 | 1 | LCC only at first stage |  |  |
| m4_v06_q3 | 2 | Police |  |  |
| m4_v06_q3 | 3 | Court |  |  |
| m4_v06_q3 | 4 | Probation / child protection actor |  |  |
| m4_v06_q3 | 5 | Health facility / medical provider |  |  |
| m4_v06_q3 | 6 | Parish or sub-county official |  |  |
| m4_v06_q3 | 98 | Other |  |  |
| m4_q11 | 1 | Very difficult |  |  |
| m4_q11 | 2 | Somewhat difficult |  |  |
| m4_q11 | 3 | Neither difficult nor easy |  |  |
| m4_q11 | 4 | Somewhat easy |  |  |
| m4_q11 | 5 | Very easy |  |  |
| m5_q01 | 0 | Never |  |  |
| m5_q01 | 1 | Rarely |  |  |
| m5_q01 | 2 | Sometimes |  |  |
| m5_q01 | 3 | Often |  |  |
| m5_q01 | 4 | Always or almost always |  |  |
| m5_q01 | 98 | Do not know |  |  |
| m5_q02 | 0 | Never |  |  |
| m5_q02 | 1 | Rarely |  |  |
| m5_q02 | 2 | Sometimes |  |  |
| m5_q02 | 3 | Often |  |  |
| m5_q02 | 4 | Always or almost always |  |  |
| m5_q02 | 98 | Do not know |  |  |
| m5_q03 | 0 | Never |  |  |
| m5_q03 | 1 | Rarely |  |  |
| m5_q03 | 2 | Sometimes |  |  |
| m5_q03 | 3 | Often |  |  |
| m5_q03 | 4 | Always or almost always |  |  |
| m5_q03 | 98 | Do not know |  |  |
| m5_q04 | 0 | Never |  |  |
| m5_q04 | 1 | Rarely |  |  |
| m5_q04 | 2 | Sometimes |  |  |
| m5_q04 | 3 | Often |  |  |
| m5_q04 | 4 | Always or almost always |  |  |
| m5_q04 | 98 | Do not know |  |  |
| m5_q05 | 1 | To help the parties reach a negotiated agreement or reconciliation |  |  |
| m5_q05 | 2 | To decide which party is right and impose a decision |  |  |
| m5_q05 | 3 | To warn the parties and send them away |  |  |
| m5_q05 | 4 | To refer the case elsewhere without attempting local discussion |  |  |
| m5_q05 | 5 | It depends on the case |  |  |
| m5_q05 | 98 | Do not know |  |  |
| m5_q06 | 0 | Never |  |  |
| m5_q06 | 1 | Rarely |  |  |
| m5_q06 | 2 | Sometimes |  |  |
| m5_q06 | 3 | Often |  |  |
| m5_q06 | 4 | Always or almost always |  |  |
| m5_q06 | 97 | No agreements have been reached recently |  |  |
| m5_q06 | 98 | Do not know |  |  |
| m5_q07 | 0 | Never |  |  |
| m5_q07 | 1 | Rarely |  |  |
| m5_q07 | 2 | Sometimes |  |  |
| m5_q07 | 3 | Often |  |  |
| m5_q07 | 4 | Always or almost always |  |  |
| m5_q07 | 97 | No agreements have been reached recently |  |  |
| m5_q07 | 98 | Do not know |  |  |
| m5_q08 | 0 | Never |  |  |
| m5_q08 | 1 | Rarely |  |  |
| m5_q08 | 2 | Sometimes |  |  |
| m5_q08 | 3 | Often |  |  |
| m5_q08 | 4 | Always or almost always |  |  |
| m5_q08 | 97 | This situation has not occurred |  |  |
| m5_q08 | 98 | Do not know |  |  |
| m5_q09 | 0 | Not confident at all |  |  |
| m5_q09 | 1 | Slightly confident |  |  |
| m5_q09 | 2 | Moderately confident |  |  |
| m5_q09 | 3 | Very confident |  |  |
| m5_q09 | 4 | Completely confident |  |  |
| m5_q10 | 0 | Not confident at all |  |  |
| m5_q10 | 1 | Slightly confident |  |  |
| m5_q10 | 2 | Moderately confident |  |  |
| m5_q10 | 3 | Very confident |  |  |
| m5_q10 | 4 | Completely confident |  |  |
| m5_q11 | 1 | Parties refuse to attend or participate |  |  |
| m5_q11 | 2 | Parties do not trust the LCC |  |  |
| m5_q11 | 3 | Parties are too angry or conflict is too intense |  |  |
| m5_q11 | 4 | One party is much more powerful or influential |  |  |
| m5_q11 | 5 | The case is outside the LCC mandate |  |  |
| m5_q11 | 6 | Lack of knowledge or training among LCC members |  |  |
| m5_q11 | 7 | Lack of records, forms, or materials |  |  |
| m5_q11 | 8 | Lack of cooperation from police, courts, or other authorities |  |  |
| m5_q11 | 9 | Fear of retaliation or community pressure |  |  |
| m5_q11 | 10 | No major barriers |  |  |
| m5_q11 | 98 | Other |  |  |
| m5_q12 | 1 | One or both parties refuse the proposed agreement |  |  |
| m5_q12 | 2 | One party does not accept the LCC’s role |  |  |
| m5_q12 | 3 | The case is more serious than first understood |  |  |
| m5_q12 | 4 | The case requires police, court, probation, or another authority |  |  |
| m5_q12 | 5 | Parties initially agree but later fail to comply |  |  |
| m5_q12 | 6 | Family, clan, or community pressure affects the case |  |  |
| m5_q12 | 7 | Lack of evidence or unclear facts |  |  |
| m5_q12 | 8 | The LCC lacks enough members or quorum to proceed properly |  |  |
| m5_q12 | 9 | Mediation rarely fails |  |  |
| m5_q12 | 98 | Other |  |  |
| m5_q13 | 1 | Mediation between the parties |  |  |
| m5_q13 | 2 | Community dialogue |  |  |
| m5_q13 | 3 | Reconciliation meeting |  |  |
| m5_q13 | 4 | Negotiated written agreement |  |  |
| m5_q13 | 5 | Advice or warning to parties |  |  |
| m5_q13 | 6 | Referral to another authority |  |  |
| m5_q13 | 7 | Committee hearing and decision |  |  |
| m5_q13 | 8 | Restitution or compensation agreement, where appropriate |  |  |
| m5_q13 | 95 | None of these methods are used |  |  |
| m5_q13 | 98 | Other |  |  |
| m5_q14 | 0 | Never |  |  |
| m5_q14 | 1 | Rarely |  |  |
| m5_q14 | 2 | Sometimes |  |  |
| m5_q14 | 3 | Often |  |  |
| m5_q14 | 4 | Always or almost always |  |  |
| m5_q14 | 97 | No mediated agreements have been reached recently |  |  |
| m5_q14 | 98 | Do not know |  |  |
| m5_q15 | 1 | Follow up with the parties and try to resolve the non-compliance |  |  |
| m5_q15 | 2 | Record the non-compliance and consider referral if appropriate |  |  |
| m5_q15 | 3 | Ignore the matter because the LCC already mediated |  |  |
| m5_q15 | 4 | Punish the non-complying party directly without further process |  |  |
| m5_q15 | 5 | Immediately refer every case of non-compliance to police |  |  |
| m5_q15 | 97 | This has not happened recently |  |  |
| m5_q15 | 98 | Do not know |  |  |
| m5_q16 | 0 | Never |  |  |
| m5_q16 | 1 | Rarely |  |  |
| m5_q16 | 2 | Sometimes |  |  |
| m5_q16 | 3 | Often |  |  |
| m5_q16 | 4 | Always or almost always |  |  |
| m5_q16 | 98 | Do not know |  |  |
| m6_q01 | 0 | Never |  |  |
| m6_q01 | 1 | Rarely |  |  |
| m6_q01 | 2 | Sometimes |  |  |
| m6_q01 | 3 | Often |  |  |
| m6_q01 | 4 | Always or almost always |  |  |
| m6_q01 | 97 | No such cases have been received recently |  |  |
| m6_q01 | 98 | Do not know |  |  |
| m6_q03 | 1 | Police |  |  |
| m6_q03 | 2 | Court |  |  |
| m6_q03 | 3 | Probation / child protection actor |  |  |
| m6_q03 | 4 | Health facility / medical provider |  |  |
| m6_q03 | 5 | Community development office / community-based service actor |  |  |
| m6_q03 | 6 | Parish or sub-county official |  |  |
| m6_q03 | 7 | Another LC/LCC |  |  |
| m6_q03 | 8 | Religious, clan, or community leader |  |  |
| m6_q03 | 98 | Other |  |  |
| m6_q04 | 1 | Case was outside LCC legal mandate |  |  |
| m6_q04 | 2 | Case involved serious violence or threat to life |  |  |
| m6_q04 | 3 | Case involved sexual violence or SGBV |  |  |
| m6_q04 | 4 | Case involved child protection concerns |  |  |
| m6_q04 | 5 | Parties refused local mediation or agreement |  |  |
| m6_q04 | 6 | Parties did not comply with a local agreement |  |  |
| m6_q04 | 7 | Evidence or facts were too complex for local handling |  |  |
| m6_q04 | 8 | LCC lacked quorum or capacity to handle the case |  |  |
| m6_q04 | 98 | Other |  |  |
| m6_q05 | 0 | Never |  |  |
| m6_q05 | 1 | Rarely |  |  |
| m6_q05 | 2 | Sometimes |  |  |
| m6_q05 | 3 | Often |  |  |
| m6_q05 | 4 | Always or almost always |  |  |
| m6_q05 | 98 | Do not know |  |  |
| m6_q06 | 0 | Never |  |  |
| m6_q06 | 1 | Rarely |  |  |
| m6_q06 | 2 | Sometimes |  |  |
| m6_q06 | 3 | Often |  |  |
| m6_q06 | 4 | Always or almost always |  |  |
| m6_q06 | 98 | Do not know |  |  |
| m6_q07 | 0 | Never |  |  |
| m6_q07 | 1 | Rarely |  |  |
| m6_q07 | 2 | Sometimes |  |  |
| m6_q07 | 3 | Often |  |  |
| m6_q07 | 4 | Always or almost always |  |  |
| m6_q07 | 98 | Do not know |  |  |
| m6_q08 | 0 | Never |  |  |
| m6_q08 | 1 | Rarely |  |  |
| m6_q08 | 2 | Sometimes |  |  |
| m6_q08 | 3 | Often |  |  |
| m6_q08 | 4 | Always or almost always |  |  |
| m6_q08 | 98 | Do not know |  |  |
| m6_q09 | 1 | Very difficult |  |  |
| m6_q09 | 2 | Somewhat difficult |  |  |
| m6_q09 | 3 | Neither easy nor difficult |  |  |
| m6_q09 | 4 | Somewhat easy |  |  |
| m6_q09 | 5 | Very easy |  |  |
| m6_q09 | 97 | LCC has not needed to coordinate with police recently |  |  |
| m6_q09 | 98 | Do not know |  |  |
| m6_q10 | 1 | Very difficult |  |  |
| m6_q10 | 2 | Somewhat difficult |  |  |
| m6_q10 | 3 | Neither easy nor difficult |  |  |
| m6_q10 | 4 | Somewhat easy |  |  |
| m6_q10 | 5 | Very easy |  |  |
| m6_q10 | 97 | LCC has not needed to coordinate with courts recently |  |  |
| m6_q10 | 98 | Do not know |  |  |
| m6_q11 | 1 | Very difficult |  |  |
| m6_q11 | 2 | Somewhat difficult |  |  |
| m6_q11 | 3 | Neither easy nor difficult |  |  |
| m6_q11 | 4 | Somewhat easy |  |  |
| m6_q11 | 5 | Very easy |  |  |
| m6_q11 | 97 | LCC has not needed to coordinate with these actors recently |  |  |
| m6_q11 | 98 | Do not know |  |  |
| m6_q12 | 1 | Police, court, or other authority is too far away |  |  |
| m6_q12 | 2 | Transport cost or lack of transport |  |  |
| m6_q12 | 3 | Parties do not want the case referred |  |  |
| m6_q12 | 4 | Parties fear costs, delay, or consequences in the formal system |  |  |
| m6_q12 | 5 | Receiving authority is slow or unresponsive |  |  |
| m6_q12 | 6 | Unclear which authority should receive the case |  |  |
| m6_q12 | 7 | LCC members lack knowledge of referral procedures |  |  |
| m6_q12 | 8 | Lack of written forms or documentation tools |  |  |
| m6_q12 | 9 | Community pressure to keep the case local |  |  |
| m6_q12 | 10 | Fear of retaliation or worsening conflict |  |  |
| m6_q12 | 11 | No major barriers |  |  |
| m6_q12 | 98 | Other |  |  |
| m6_q13 | 1 | No clear feedback channel |  |  |
| m6_q13 | 2 | Receiving authority does not usually report back |  |  |
| m6_q13 | 3 | LCC does not know whom to contact |  |  |
| m6_q13 | 4 | LCC lacks phone/transport/resources for follow-up |  |  |
| m6_q13 | 5 | Parties do not return to update the LCC |  |  |
| m6_q13 | 6 | Case records are incomplete or not linked across institutions |  |  |
| m6_q13 | 7 | Confidentiality or sensitivity of the case limits feedback |  |  |
| m6_q13 | 8 | Feedback is not expected in current practice |  |  |
| m6_q13 | 9 | No major barriers |  |  |
| m6_q13 | 98 | Other |  |  |
| m6_q14 | 0 | Not confident at all |  |  |
| m6_q14 | 1 | Slightly confident |  |  |
| m6_q14 | 2 | Moderately confident |  |  |
| m6_q14 | 3 | Very confident |  |  |
| m6_q14 | 4 | Completely confident |  |  |
| m6_q15 | 0 | Not confident at all |  |  |
| m6_q15 | 1 | Slightly confident |  |  |
| m6_q15 | 2 | Moderately confident |  |  |
| m6_q15 | 3 | Very confident |  |  |
| m6_q15 | 4 | Completely confident |  |  |
| m6_q16 | 1 | Yes, referrals are clearly recorded |  |  |
| m6_q16 | 2 | Some referrals appear to be recorded, but not clearly or consistently |  |  |
| m6_q16 | 3 | Records were seen, but no referral information was visible |  |  |
| m6_q16 | 4 | Records were seen, but there were no referred cases in the visible records |  |  |
| m6_q16 | 98 | Cannot determine |  |  |
| m6_q17 | 1 | Yes, referral destination is usually recorded |  |  |
| m6_q17 | 2 | Sometimes recorded |  |  |
| m6_q17 | 3 | Not recorded |  |  |
| m6_q17 | 4 | No referred cases visible in records |  |  |
| m6_q17 | 98 | Cannot determine |  |  |
| m7_q01 | 1 | Yes, formal case register/case book |  |  |
| m7_q01 | 2 | Yes, informal notebook or written list |  |  |
| m7_q01 | 3 | No written case register or case book |  |  |
| m7_q02 | 1 | Yes, formal proceedings book |  |  |
| m7_q02 | 2 | Yes, informal written proceedings notes |  |  |
| m7_q02 | 3 | No written proceedings record |  |  |
| m7_q02 | 98 | Do not know |  |  |
| m7_q03 | 1 | Case register / case book |  |  |
| m7_q03 | 2 | Proceedings book / hearing notes |  |  |
| m7_q03 | 3 | Written agreements or settlement forms |  |  |
| m7_q03 | 4 | Referral notes or referral records |  |  |
| m7_q03 | 5 | Summons or invitation notes |  |  |
| m7_q03 | 6 | Follow-up notes after resolution or referral |  |  |
| m7_q03 | 95 | No written records are kept |  |  |
| m7_q03 | 98 | Other written record |  |  |
| m7_q04 | 1 | Yes, fully up to date |  |  |
| m7_q04 | 2 | Partly up to date |  |  |
| m7_q04 | 3 | Not up to date |  |  |
| m7_q04 | 98 | Do not know |  |  |
| m7_q05 | 1 | Within the last 7 days |  |  |
| m7_q05 | 2 | Within the last 30 days |  |  |
| m7_q05 | 3 | Within the last 3 months |  |  |
| m7_q05 | 4 | More than 3 months ago |  |  |
| m7_q05 | 5 | No case has ever been entered |  |  |
| m7_q05 | 98 | Do not know / cannot verify |  |  |
| m7_q06 | 1 | Date case was received or opened |  |  |
| m7_q06 | 2 | Names or identifiers of the parties |  |  |
| m7_q06 | 3 | Village or location of the parties |  |  |
| m7_q06 | 4 | Type or nature of the case |  |  |
| m7_q06 | 5 | Brief description of the complaint or dispute |  |  |
| m7_q06 | 6 | Date of hearing or mediation |  |  |
| m7_q06 | 7 | Members present / committee members involved |  |  |
| m7_q06 | 8 | Steps taken by the LCC |  |  |
| m7_q06 | 9 | Outcome, resolution, decision, or agreement |  |  |
| m7_q06 | 10 | Referral status or destination |  |  |
| m7_q06 | 11 | Closure date or referral date |  |  |
| m7_q06 | 12 | Signatures, thumbprints, or confirmation by parties |  |  |
| m7_q06 | 98 | Other |  |  |
| m7_q07 | 0 | Never |  |  |
| m7_q07 | 1 | Rarely |  |  |
| m7_q07 | 2 | Sometimes |  |  |
| m7_q07 | 3 | Often |  |  |
| m7_q07 | 4 | Always or almost always |  |  |
| m7_q07 | 98 | Do not know |  |  |
| m7_q08 | 0 | Never |  |  |
| m7_q08 | 1 | Rarely |  |  |
| m7_q08 | 2 | Sometimes |  |  |
| m7_q08 | 3 | Often |  |  |
| m7_q08 | 4 | Always or almost always |  |  |
| m7_q08 | 98 | Do not know |  |  |
| m7_q09 | 0 | Never |  |  |
| m7_q09 | 1 | Rarely |  |  |
| m7_q09 | 2 | Sometimes |  |  |
| m7_q09 | 3 | Often |  |  |
| m7_q09 | 4 | Always or almost always |  |  |
| m7_q09 | 97 | No cases have been referred recently |  |  |
| m7_q09 | 98 | Do not know |  |  |
| m7_q10 | 0 | Never |  |  |
| m7_q10 | 1 | Rarely |  |  |
| m7_q10 | 2 | Sometimes |  |  |
| m7_q10 | 3 | Often |  |  |
| m7_q10 | 4 | Always or almost always |  |  |
| m7_q10 | 98 | Do not know |  |  |
| m7_q11 | 0 | Never |  |  |
| m7_q11 | 1 | Rarely |  |  |
| m7_q11 | 2 | Sometimes |  |  |
| m7_q11 | 3 | Often |  |  |
| m7_q11 | 4 | Always or almost always |  |  |
| m7_q11 | 97 | No agreements have been reached recently |  |  |
| m7_q11 | 98 | Do not know |  |  |
| m7_q12 | 1 | Very difficult |  |  |
| m7_q12 | 2 | Somewhat difficult |  |  |
| m7_q12 | 3 | Neither easy nor difficult |  |  |
| m7_q12 | 4 | Somewhat easy |  |  |
| m7_q12 | 5 | Very easy |  |  |
| m7_q12 | 98 | Do not know |  |  |
| m7_q13 | 1 | Yes, secure storage |  |  |
| m7_q13 | 2 | Partly secure |  |  |
| m7_q13 | 3 | Not secure |  |  |
| m7_q13 | 98 | Do not know |  |  |
| m7_q14 | 1 | LC I Chairperson |  |  |
| m7_q14 | 2 | Secretary |  |  |
| m7_q14 | 3 | Other LCC committee members |  |  |
| m7_q14 | 4 | Parish or sub-county officials |  |  |
| m7_q14 | 5 | Police or court officials |  |  |
| m7_q14 | 6 | Any community member upon request |  |  |
| m7_q14 | 7 | Parties to the case only |  |  |
| m7_q14 | 98 | Other |  |  |
| m7_q15 | 1 | Lack of register, books, forms, or paper |  |  |
| m7_q15 | 2 | Lack of pens or basic stationery |  |  |
| m7_q15 | 3 | Lack of training on how to record cases |  |  |
| m7_q15 | 4 | Limited time to complete records |  |  |
| m7_q15 | 5 | Difficulty writing in required language |  |  |
| m7_q15 | 6 | Records are kept by one person who is often unavailable |  |  |
| m7_q15 | 7 | Records are lost, damaged, or not stored safely |  |  |
| m7_q15 | 8 | Sensitive cases are difficult to record confidentially |  |  |
| m7_q15 | 9 | No major challenges |  |  |
| m7_q15 | 98 | Other |  |  |
| m7_v01 | 1 | Yes, formal case register/case book seen |  |  |
| m7_v01 | 2 | Yes, informal case notebook/list seen |  |  |
| m7_v01 | 0 | No case register/case book seen |  |  |
| m7_v02 | 1 | Yes, formal proceedings book seen |  |  |
| m7_v02 | 2 | Yes, informal hearing/mediation notes seen |  |  |
| m7_v02 | 0 | No proceedings book or hearing notes seen |  |  |
| m7_v11 | 1 | Yes, broadly consistent |  |  |
| m7_v11 | 2 | Partly consistent |  |  |
| m7_v11 | 3 | Not consistent |  |  |
| m7_v11 | 98 | Cannot determine |  |  |
| m7_v12 | 1 | Locked cabinet, box, or room |  |  |
| m7_v12 | 2 | Unlocked but protected location |  |  |
| m7_v12 | 3 | Open/public location |  |  |
| m7_v12 | 4 | With one LC/LCC member personally |  |  |
| m7_v12 | 5 | Records were present but storage location unclear |  |  |
| m7_v12 | 98 | Other |  |  |
| m7_v13 | 1 | Very poor: not usable |  |  |
| m7_v13 | 2 | Poor: limited usability |  |  |
| m7_v13 | 3 | Moderate: usable with important limitations |  |  |
| m7_v13 | 4 | Good: mostly usable |  |  |
| m7_v13 | 5 | Very good: complete and easy to use |  |  |
| m7_v13 | 98 | Cannot determine |  |  |
| m7_v14 | 1 | Records exist but were not physically present |  |  |
| m7_v14 | 2 | Records are kept by another person who was absent |  |  |
| m7_v14 | 3 | Records are locked or inaccessible |  |  |
| m7_v14 | 4 | Respondent reports that no records exist |  |  |
| m7_v14 | 5 | Respondent refused record verification |  |  |
| m7_v14 | 98 | Other reason |  |  |
| m8_q01 | 1 | By the full committee or most members together |  |  |
| m8_q01 | 2 | By a smaller group of committee members |  |  |
| m8_q01 | 3 | Mostly by the chairperson alone |  |  |
| m8_q02 | 0 | Never |  |  |
| m8_q02 | 1 | Rarely |  |  |
| m8_q02 | 2 | Sometimes |  |  |
| m8_q02 | 3 | Often |  |  |
| m8_q02 | 4 | Always or almost always |  |  |
| m8_q02 | 98 | Do not know |  |  |
| m8_q03 | 0 | Never |  |  |
| m8_q03 | 1 | Rarely |  |  |
| m8_q03 | 2 | Sometimes |  |  |
| m8_q03 | 3 | Often |  |  |
| m8_q03 | 4 | Always or almost always |  |  |
| m8_q03 | 98 | Do not know |  |  |
| m8_q04 | 0 | Never |  |  |
| m8_q04 | 1 | Rarely |  |  |
| m8_q04 | 2 | Sometimes |  |  |
| m8_q04 | 3 | Often |  |  |
| m8_q04 | 4 | Always or almost always |  |  |
| m8_q04 | 98 | Do not know |  |  |
| m8_q05 | 0 | Never |  |  |
| m8_q05 | 1 | Rarely |  |  |
| m8_q05 | 2 | Sometimes |  |  |
| m8_q05 | 3 | Often |  |  |
| m8_q05 | 4 | Always or almost always |  |  |
| m8_q05 | 98 | Do not know |  |  |
| m8_q06 | 0 | Never |  |  |
| m8_q06 | 1 | Rarely |  |  |
| m8_q06 | 2 | Sometimes |  |  |
| m8_q06 | 3 | Often |  |  |
| m8_q06 | 4 | Always or almost always |  |  |
| m8_q06 | 97 | No women currently serve on the LCC/committee |  |  |
| m8_q06 | 98 | Do not know |  |  |
| m8_q07 | 1 | Yes, through women LC representatives or other local women leaders |  |  |
| m8_q07 | 2 | Yes, through consultation with affected women or parties |  |  |
| m8_q07 | 3 | Yes, through another mechanism |  |  |
| m8_q07 | 4 | No mechanism |  |  |
| m8_q07 | 98 | Do not know |  |  |
| m8_q08 | 0 | Never |  |  |
| m8_q08 | 1 | Rarely |  |  |
| m8_q08 | 2 | Sometimes |  |  |
| m8_q08 | 3 | Often |  |  |
| m8_q08 | 4 | Always or almost always |  |  |
| m8_q08 | 97 | Records are not signed or validated at all |  |  |
| m8_q08 | 98 | Do not know |  |  |
| m8_q09 | 1 | Yes, regularly |  |  |
| m8_q09 | 2 | Yes, sometimes |  |  |
| m8_q09 | 3 | Rarely |  |  |
| m8_q09 | 4 | Never |  |  |
| m8_q09 | 98 | Do not know |  |  |
| m8_q10 | 0 | Never |  |  |
| m8_q10 | 1 | Rarely |  |  |
| m8_q10 | 2 | Sometimes |  |  |
| m8_q10 | 3 | Often |  |  |
| m8_q10 | 4 | Always or almost always |  |  |
| m8_q10 | 98 | Do not know |  |  |
| m8_q11 | 1 | Members discuss until they reach agreement |  |  |
| m8_q11 | 2 | The chairperson or one senior member decides |  |  |
| m8_q11 | 3 | The case is postponed for further discussion |  |  |
| m8_q11 | 4 | The case is referred to another authority |  |  |
| m8_q11 | 5 | Disagreements rarely or never happen |  |  |
| m8_q11 | 98 | Do not know |  |  |
| m8_q12 | 0 | Never |  |  |
| m8_q12 | 1 | Rarely |  |  |
| m8_q12 | 2 | Sometimes |  |  |
| m8_q12 | 3 | Often |  |  |
| m8_q12 | 4 | Always or almost always |  |  |
| m8_q12 | 98 | Do not know |  |  |
| m8_q13 | 1 | Not consistent at all |  |  |
| m8_q13 | 2 | Slightly consistent |  |  |
| m8_q13 | 3 | Moderately consistent |  |  |
| m8_q13 | 4 | Very consistent |  |  |
| m8_q13 | 5 | Completely consistent |  |  |
| m8_q13 | 98 | Do not know |  |  |
| m8_q14 | 0 | Not confident at all |  |  |
| m8_q14 | 1 | Slightly confident |  |  |
| m8_q14 | 2 | Moderately confident |  |  |
| m8_q14 | 3 | Very confident |  |  |
| m8_q14 | 4 | Completely confident |  |  |
| m8_q15 | 1 | Some members are often absent |  |  |
| m8_q15 | 2 | Members lack time for LCC duties |  |  |
| m8_q15 | 3 | Members lack training or knowledge |  |  |
| m8_q15 | 4 | One member dominates the process |  |  |
| m8_q15 | 5 | Women members or less senior members do not participate actively |  |  |
| m8_q15 | 6 | Quorum is difficult to achieve |  |  |
| m8_q15 | 7 | Disagreements between members delay decisions |  |  |
| m8_q15 | 8 | Lack of meeting place, materials, or records |  |  |
| m8_q15 | 9 | Community members prefer one leader rather than full committee |  |  |
| m8_q15 | 10 | No major challenges |  |  |
| m8_q15 | 98 | Other |  |  |
| m8_v01 | 1 | Yes, clearly shown in records |  |  |
| m8_v01 | 2 | Some evidence, but not consistent |  |  |
| m8_v01 | 3 | No evidence visible |  |  |
| m8_v01 | 4 | Records seen, but no relevant cases/entries available |  |  |
| m8_v01 | 98 | Cannot determine |  |  |
| m8_v02 | 1 | Yes, clearly shown in records |  |  |
| m8_v02 | 2 | Some evidence, but not consistent |  |  |
| m8_v02 | 3 | No evidence visible |  |  |
| m8_v02 | 4 | Records seen, but no decisions/agreements/referrals available |  |  |
| m8_v02 | 98 | Cannot determine |  |  |
| m9_q01 | 0 | Not important at all |  |  |
| m9_q01 | 1 | Slightly important |  |  |
| m9_q01 | 2 | Moderately important |  |  |
| m9_q02 | 0 | Not important at all |  |  |
| m9_q02 | 1 | Slightly important |  |  |
| m9_q02 | 2 | Moderately important |  |  |
| m9_q02 | 3 | Very important |  |  |
| m9_q02 | 4 | Essential |  |  |
| m9_q03 | 0 | Not important at all |  |  |
| m9_q03 | 1 | Slightly important |  |  |
| m9_q03 | 2 | Moderately important |  |  |
| m9_q03 | 3 | Very important |  |  |
| m9_q03 | 4 | Essential |  |  |
| m9_q04 | 0 | Not important at all  |  |  |
| m9_q04 | 1 | Slightly important |  |  |
| m9_q04 | 2 | Moderately important  |  |  |
| m9_q04 | 3 | Very important |  |  |
| m9_q04 | 4 | Essential |  |  |
| m9_q05 | 0 | Not important at all |  |  |
| m9_q05 | 1 | Slightly important |  |  |
| m9_q05 | 2 | Moderately important |  |  |
| m9_q05 | 3 | Very important |  |  |
| m9_q05 | 4 | Essential |  |  |
| m9_q06 | 0 | Not important at all |  |  |
| m9_q06 | 1 | Slightly important |  |  |
| m9_q06 | 2 | Moderately important |  |  |
| m9_q06 | 3 | Very important |  |  |
| m9_q06 | 4 | Essential |  |  |
| m9_q07 | 0 | Never |  |  |
| m9_q07 | 1 | Rarely |  |  |
| m9_q07 | 2 | Sometimes |  |  |
| m9_q07 | 3 | Often |  |  |
| m9_q07 | 4 | Always or almost always |  |  |
| m9_q07 | 98 | Do not know |  |  |
| m9_q08 | 0 | Never |  |  |
| m9_q08 | 1 | Rarely |  |  |
| m9_q08 | 2 | Sometimes |  |  |
| m9_q08 | 3 | Often |  |  |
| m9_q08 | 4 | Always or almost always |  |  |
| m9_q08 | 98 | Do not know |  |  |
| m9_q09 | 0 | Never |  |  |
| m9_q09 | 1 | Rarely |  |  |
| m9_q09 | 2 | Sometimes |  |  |
| m9_q09 | 3 | Often |  |  |
| m9_q09 | 4 | Always or almost always |  |  |
| m9_q09 | 98 | Do not know |  |  |
| m9_q10 | 1 | Never |  |  |
| m9_q10 | 2 | Rarely  |  |  |
| m9_q10 | 2 | Sometimes |  |  |
| m9_q10 | 3 | Often |  |  |
| m9_q10 | 4 | Always or almost always |  |  |
| m9_q10 | 98 | Do not know |  |  |
| m9_q11 | 0 | In practice, this LCC handles all similar cases in a consistent way |  |  |
| m9_q11 | 1 | In practice, all this LCC handles similar cases in different ways depending on circumustances |  |  |
| m9_q11 | 2 | Sometimes |  |  |
| m9_q11 | 3 | Often |  |  |
| m9_q11 | 4 | Always or almost always |  |  |
| m9_q11 | 98 | Do not know |  |  |
| m9_q12 | 1 | Not fair at all |  |  |
| m9_q12 | 2 | Slightly fair |  |  |
| m9_q12 | 3 | Moderately fair |  |  |
| m9_q12 | 4 | Very fair |  |  |
| m9_q12 | 5 | Completely fair |  |  |
| m9_q12 | 98 | Do not know |  |  |
| m9_q13 | 1 | No trust at all |  |  |
| m9_q13 | 2 | A little trust |  |  |
| m9_q13 | 3 | Moderate trust |  |  |
| m9_q13 | 4 | A lot of trust |  |  |
| m9_q13 | 5 | Complete trust |  |  |
| m9_q13 | 98 | Do not know  |  |  |
| m9_q14 | 1 | Not willing at all |  |  |
| m9_q14 | 2 | Slightly willing |  |  |
| m9_q14 | 3 | Moderately willing |  |  |
| m9_q14 | 4 | Very willing |  |  |
| m9_q14 | 5 | Completely willing |  |  |
| m9_q14 | 98 | Do not know |  |  |
| m9_q15 | 0 | Never |  |  |
| m9_q15 | 1 | Rarely |  |  |
| m9_q15 | 2 | Sometimes |  |  |
| m9_q15 | 3 | Often |  |  |
| m9_q15 | 4 | Always or almost always |  |  |
| m9_q15 | 98 | Do not know |  |  |
| m9_q16 | 1 | They believe police or courts are more powerful or authoritative |  |  |
| m9_q16 | 2 | They believe police or courts will act faster |  |  |
| m9_q16 | 3 | They do not trust the LCC |  |  |
| m9_q16 | 4 | They think the LCC is biased or favors certain people |  |  |
| m9_q16 | 5 | They think the LCC cannot enforce agreements or decisions |  |  |
| m9_q16 | 6 | They do not know which cases the LCC can handle |  |  |
| m9_q16 | 7 | The case is serious and should go to police or court |  |  |
| m9_q16 | 8 | They fear community pressure, stigma, or retaliation |  |  |
| m9_q16 | 9 | They expect costs, delays, or unfair treatment at the LCC |  |  |
| m9_q16 | 10 | They have personal connections with police, court, or other authorities |  |  |
| m9_q16 | 11 | People rarely bypass the LCC for eligible petty cases |  |  |
| m9_q16 | 98 | Other |  |  |
| m9_q17 | 1 | No inffluence atall |  |  |
| m9_q17 | 2 | Small extent |  |  |
| m9_q17 | 3 | Moderate extent |  |  |
| m9_q17 | 4 | High extent |  |  |
| m9_q17 | 5 | Very highextent |  |  |
| m9_q17 | 98 | Do not know |  |  |
| m9_q18 | 0 | Not confident at all |  |  |
| m9_q18 | 1 | Slightly confident |  |  |
| m9_q18 | 2 | Moderately confident |  |  |
| m9_q18 | 3 | Very confident |  |  |
| m9_q18 | 4 | Completely confident |  |  |
| m9_q19 | 0 | Not confident at all |  |  |
| m9_q19 | 1 | Slightly confident |  |  |
| m9_q19 | 2 | Moderately confident |  |  |
| m9_q19 | 3 | Very confident |  |  |
| m9_q19 | 4 | Completely confident |  |  |
| m10_q01 | 1 | Sexual violence or rape |  |  |
| m10_q01 | 2 | Defilement or sexual abuse of a child |  |  |
| m10_q01 | 3 | Child abuse, neglect, or a child at risk of harm |  |  |
| m10_q02 | 1 | Mediate between the survivor and the alleged perpetrator |  |  |
| m10_q02 | 2 | Support the person’s safety and refer or notify the appropriate police, medical, or legal services immediately |  |  |
| m10_q02 | 3 | Ask families to settle the matter privately |  |  |
| m10_q02 | 4 | Do nothing because it is outside the LCC’s mandate |  |  |
| m10_q02 | 98 | Do not know |  |  |
| m10_q03 | 1 | Treat it as a family matter for local mediation only |  |  |
| m10_q03 | 2 | Ensure immediate safety where possible and refer or notify the appropriate child protection/probation authority |  |  |
| m10_q03 | 3 | Wait until the child personally brings the case |  |  |
| m10_q03 | 4 | Ask the parents or guardians to resolve it privately without recording or referral |  |  |
| m10_q03 | 98 | Do not know |  |  |
| m10_q04 | 1 | Mediate locally if both parties agree |  |  |
| m10_q04 | 2 | Refer or notify police or the appropriate authority immediately and avoid informal resolution as the only response |  |  |
| m10_q04 | 3 | Ask elders or family members to settle it privately |  |  |
| m10_q04 | 4 | Delay action until the next scheduled LCC sitting |  |  |
| m10_q04 | 98 | Do not know |  |  |
| m10_q05 | 0 | Never |  |  |
| m10_q05 | 1 | Rarely |  |  |
| m10_q05 | 2 | Sometimes |  |  |
| m10_q05 | 3 | Often |  |  |
| m10_q05 | 4 | Always or almost always |  |  |
| m10_q05 | 97 | No sensitive cases have been received recently |  |  |
| m10_q05 | 98 | Do not know |  |  |
| m10_q06 | 0 | Never |  |  |
| m10_q06 | 1 | Rarely |  |  |
| m10_q06 | 2 | Sometimes |  |  |
| m10_q06 | 3 | Often |  |  |
| m10_q06 | 4 | Always or almost always |  |  |
| m10_q06 | 97 | No such cases have been received recently |  |  |
| m10_q06 | 98 | Do not know |  |  |
| m10_q07 | 1 | Yes |  |  |
| m10_q07 | 0 | No |  |  |
| m10_q07 | 98 | Do not know |  |  |
| m10_q08 | 1 | Protecting confidentiality |  |  |
| m10_q08 | 2 | Ensuring immediate safety |  |  |
| m10_q08 | 3 | Referring to police, probation, child protection, health, or other services |  |  |
| m10_q08 | 4 | Avoiding mediation where it may be unsafe or inappropriate |  |  |
| m10_q08 | 5 | Allowing the person to speak in a safe setting |  |  |
| m10_q08 | 6 | Involving an appropriate support person or responsible authority |  |  |
| m10_q08 | 7 | Keeping records securely and limiting who can access them |  |  |
| m10_q08 | 98 | Other |  |  |
| m10_q09 | 1 | Police |  |  |
| m10_q09 | 2 | Court |  |  |
| m10_q09 | 3 | Probation / child protection officer |  |  |
| m10_q09 | 4 | Health facility / medical provider |  |  |
| m10_q09 | 5 | Community development office or social service actor |  |  |
| m10_q09 | 6 | Parish or sub-county authority |  |  |
| m10_q09 | 7 | Religious, clan, or community leader only |  |  |
| m10_q09 | 8 | I would not know where to refer |  |  |
| m10_q09 | 98 | Other |  |  |
| m10_q10 | 0 | Not confident at all |  |  |
| m10_q10 | 1 | Slightly confident |  |  |
| m10_q10 | 2 | Moderately confident |  |  |
| m10_q10 | 3 | Very confident |  |  |
| m10_q10 | 4 | Completely confident |  |  |
| m10_q11 | 0 | Not confident at all |  |  |
| m10_q11 | 1 | Slightly confident |  |  |
| m10_q11 | 2 | Moderately confident |  |  |
| m10_q11 | 3 | Very confident |  |  |
| m10_q11 | 4 | Completely confident |  |  |
| m10_q12 | 1 | People prefer to keep the case within the family or community |  |  |
| m10_q12 | 2 | Fear of stigma or shame |  |  |
| m10_q12 | 3 | Fear of retaliation or worsening conflict |  |  |
| m10_q12 | 4 | Police, health, probation, or other services are far away |  |  |
| m10_q12 | 5 | Transport or service costs |  |  |
| m10_q12 | 6 | Parties do not trust formal authorities or services |  |  |
| m10_q12 | 7 | LCC members are unsure where to refer |  |  |
| m10_q12 | 8 | Formal authorities do not respond quickly |  |  |
| m10_q12 | 9 | Community pressure to mediate locally |  |  |
| m10_q12 | 10 | Lack of confidentiality or private space |  |  |
| m10_q12 | 11 | No major barriers |  |  |
| m10_q12 | 98 | Other |  |  |
| m10_q13 | 0 | Never |  |  |
| m10_q13 | 1 | Rarely |  |  |
| m10_q13 | 2 | Sometimes |  |  |
| m10_q13 | 3 | Often |  |  |
| m10_q13 | 4 | Always or almost always |  |  |
| m10_q13 | 97 | No sensitive or serious cases have been received recently |  |  |
| m10_q13 | 98 | Do not know |  |  |
| m10_q14 | 0 | Never |  |  |
| m10_q14 | 1 | Rarely |  |  |
| m10_q14 | 2 | Sometimes |  |  |
| m10_q14 | 3 | Often |  |  |
| m10_q14 | 4 | Always or almost always |  |  |
| m10_q14 | 97 | No sensitive cases have been referred recently |  |  |
| m10_q14 | 98 | Do not know |  |  |
| m10_v01 | 1 | Yes, clearly shown in records |  |  |
| m10_v01 | 2 | Some evidence, but not clear or consistent |  |  |
| m10_v01 | 3 | No evidence visible |  |  |
| m10_v01 | 4 | No sensitive or serious cases visible in records reviewed |  |  |
| m10_v01 | 98 | Cannot determine |  |  |
| m10_v02 | 1 | Yes, confidentiality appears protected |  |  |
| m10_v02 | 2 | Partly protected |  |  |
| m10_v02 | 3 | Not protected |  |  |
| m10_v02 | 4 | No sensitive case records visible |  |  |
| m10_v02 | 98 | Cannot determine |  |  |
| m11_q01 | 1 | No, almost never |  |  |
| m11_q01 | 2 | Yes, but only rarely |  |  |
| m11_q01 | 3 | Yes, sometimes |  |  |
| m11_q02 | 0 | Not important at all |  |  |
| m11_q02 | 1 | Slightly important |  |  |
| m11_q02 | 2 | Moderately important |  |  |
| m11_q02 | 3 | Very important |  |  |
| m11_q02 | 4 | Essential |  |  |
| m11_q03 | 0 | Not willing at all |  |  |
| m11_q03 | 1 | Slightly willing |  |  |
| m11_q03 | 2 | Moderately willing |  |  |
| m11_q03 | 3 | Very willing |  |  |
| m11_q03 | 4 | Completely willing |  |  |
| m11_q04 | 1 | Strongly disagree |  |  |
| m11_q04 | 2 | Disagree |  |  |
| m11_q04 | 3 | Neither agree nor disagree |  |  |
| m11_q04 | 4 | Agree |  |  |
| m11_q04 | 5 | Strongly agree |  |  |
| m11_q04 | 98 | Do not know |  |  |
| m11_q05 | 1 | Strongly disagree |  |  |
| m11_q05 | 2 | Disagree |  |  |
| m11_q05 | 3 | Neither agree nor disagree |  |  |
| m11_q05 | 4 | Agree |  |  |
| m11_q05 | 5 | Strongly agree |  |  |
| m11_q05 | 98 | Do not know |  |  |
| m11_q06 | 1 | Strongly disagree |  |  |
| m11_q06 | 2 | Disagree |  |  |
| m11_q06 | 3 | Neither agree nor disagree |  |  |
| m11_q06 | 4 | Agree |  |  |
| m11_q06 | 5 | Strongly agree |  |  |
| m11_q06 | 98 | Do not know |  |  |
| m11_q07 | 1 | Strongly disagree |  |  |
| m11_q07 | 2 | Disagree |  |  |
| m11_q07 | 3 | Neither agree nor disagree |  |  |
| m11_q07 | 4 | Agree |  |  |
| m11_q07 | 5 | Strongly agree |  |  |
| m11_q07 | 98 | Do not know |  |  |
| m11_q08 | 0 | Not comfortable at all |  |  |
| m11_q08 | 1 | Slightly comfortable |  |  |
| m11_q08 | 2 | Moderately comfortable |  |  |
| m11_q08 | 3 | Very comfortable |  |  |
| m11_q08 | 4 | Completely comfortable |  |  |
| m11_q08 | 98 | Do not know |  |  |
| m11_q09 | 0 | Not willing at all |  |  |
| m11_q09 | 1 | Slightly willing |  |  |
| m11_q09 | 2 | Moderately willing |  |  |
| m11_q09 | 3 | Very willing |  |  |
| m11_q09 | 4 | Completely willing |  |  |
| m11_q09 | 98 | Do not know where to connect them |  |  |
| m11_q10 | 1 | Acceptance by family and community |  |  |
| m11_q10 | 2 | Livelihood or income-generating opportunities |  |  |
| m11_q10 | 3 | Psychosocial, counseling, or emotional support |  |  |
| m11_q10 | 4 | Conflict mediation with family or community members |  |  |
| m11_q10 | 5 | Support from LC or community leaders |  |  |
| m11_q10 | 6 | Support from religious, clan, or cultural leaders |  |  |
| m11_q10 | 7 | Legal or administrative support |  |  |
| m11_q10 | 8 | Skills training or education |  |  |
| m11_q10 | 9 | None; they should manage on their own |  |  |
| m11_q10 | 98 | Other |  |  |
| m11_q11 | 1 | Not common at all |  |  |
| m11_q11 | 2 | Slightly common |  |  |
| m11_q11 | 3 | Moderately common |  |  |
| m11_q11 | 4 | Very common |  |  |
| m11_q11 | 5 | Extremely common |  |  |
| m11_q11 | 98 | Do not know |  |  |
| m11_q12 | 1 | Fear that the person may reoffend |  |  |
| m11_q12 | 2 | Fear of violence or conflict |  |  |
| m11_q12 | 3 | Shame or stigma attached to imprisonment |  |  |
| m11_q12 | 4 | Lack of trust in the person |  |  |
| m11_q12 | 5 | Victims or families feel harmed and not reconciled |  |  |
| m11_q12 | 6 | Lack of livelihood or work opportunities |  |  |
| m11_q12 | 7 | Lack of community guidance or support structures |  |  |
| m11_q12 | 8 | People do not know how to support reintegration |  |  |
| m11_q12 | 9 | Community members are usually willing to accept them |  |  |
| m11_q12 | 98 | Other |  |  |
| m11_q13 | 1 | Yes |  |  |
| m11_q13 | 0 | No |  |  |
| m11_q13 | 98 | Do not know / cannot remember |  |  |
| m11_q14 | 1 | Family or household tension after return |  |  |
| m11_q14 | 2 | Neighbor or community conflict |  |  |
| m11_q14 | 3 | Dispute related to property, land, or debt |  |  |
| m11_q14 | 4 | Stigma, exclusion, or refusal to accept the person |  |  |
| m11_q14 | 5 | Concern that the person might reoffend |  |  |
| m11_q14 | 6 | Livelihood, employment, or income-related concern |  |  |
| m11_q14 | 7 | Need for referral or support services |  |  |
| m11_q14 | 8 | Serious allegation requiring referral to police/court |  |  |
| m11_q14 | 98 | Other |  |  |
| m11_q15 | 1 | Mediated or facilitated dialogue locally |  |  |
| m11_q15 | 2 | Referred the matter to police or court |  |  |
| m11_q15 | 3 | Referred or connected the person to social, livelihood, psychosocial, or community support |  |  |
| m11_q15 | 4 | Consulted family, elders, religious, clan, or community leaders |  |  |
| m11_q15 | 5 | Took no action |  |  |
| m11_q15 | 6 | Response is still ongoing |  |  |
| m11_q15 | 98 | Other |  |  |
| m11_q16 | 0 | Not confident at all |  |  |
| m11_q16 | 1 | Slightly confident |  |  |
| m11_q16 | 2 | Moderately confident |  |  |
| m11_q16 | 3 | Very confident |  |  |
| m11_q16 | 4 | Completely confident |  |  |
| m11_q17 | 0 | Not confident at all |  |  |
| m11_q17 | 1 | Slightly confident |  |  |
| m11_q17 | 2 | Moderately confident |  |  |
| m11_q17 | 3 | Very confident |  |  |
| m11_q17 | 4 | Completely confident |  |  |
| m11_q18 | 1 | Yes |  |  |
| m11_q18 | 0 | No |  |  |
| m11_q18 | 98 | Do not know |  |  |
| m11_q19 | 1 | Help reduce stigma and encourage peaceful acceptance |  |  |
| m11_q19 | 2 | Mediate tensions between the person, family, and community |  |  |
| m11_q19 | 3 | Refer the person to appropriate services or support |  |  |
| m11_q19 | 4 | Help prevent conflict or reoffending through guidance |  |  |
| m11_q19 | 5 | Coordinate with police, probation, religious leaders, or other actors when needed |  |  |
| m11_q19 | 6 | Support fair handling if a dispute involving the person arises |  |  |
| m11_q19 | 7 | Keep the community informed while protecting confidentiality |  |  |
| m11_q19 | 98 | Other |  |  |
| Topics_Trained | 1 | Mediation / ADR |  |  |
| Topics_Trained | 2 | Local Council Court procedures |  |  |
| Topics_Trained | 3 | Case recording / record keeping |  |  |
| Topics_Trained | 4 | Referral to police or courts |  |  |
| Topics_Trained | 5 | Child protection |  |  |
| Topics_Trained | 6 | Gender-based violence / SGBV |  |  |
| Topics_Trained | 7 | Reintegration of formerly incarcerated persons |  |  |
| Topics_Trained | 98 | Other |  |  |
| MO_Q01 | 1 | Runyankore |  |  |
| MO_Q01 | 2 | English |  |  |
| MO_Q02 | 1 | Ivan |  |  |
| MO_Q02 | 2 | Jorge |  |  |
| Attend_CDFU_Training | 0 | No |  |  |
| Attend_CDFU_Training | 1 | Yes |  |  |
| M0_Q04 | 1 | Bushenyi |  |  |
| M0_Q04 | 2 | Rubirizi |  |  |
| M0_Q04 | 3 | Sheema |  |  |
| M0_Q05 | 1 | Kyamuhunga Town |  |  |
| M0_Q05 | 2 | Kyeizooba |  |  |
| M0_Q05 | 3 | Kakanju |  |  |
| M0_Q05 | 4 | Ruhumuro |  |  |
| M0_Q05 | 5 | Bumbaire |  |  |
| M0_Q05 | 6 | Nkanga |  |  |
| M0_Q05 | 7 | Nyabubare |  |  |
| M0_Q05 | 8 | Kizinda Town Council |  |  |
| M0_Q05 | 9 | Bitooma |  |  |
| M0_Q05 | 10 | Nyakabirizi |  |  |
| M0_Q05 | 11 | Bushenyi central |  |  |
| M0_Q05 | 12 | Ibaare |  |  |
| M0_Q05 | 13 | Rwentuha |  |  |
| M0_Q05 | 14 | Kyamuhunga sub |  |  |
| M0_Q05 | 15 | Kyabugimbi Sub county |  |  |
| M0_Q05 | 16 | Kyabugimbi Town Council |  |  |
| M0_Q05 | 17 | Kyamuhunga Town |  |  |
| M0_Q05 | 18 | Kyeizooba |  |  |
| M0_Q05 | 19 | Kakanju |  |  |
| M0_Q05 | 20 | Bumbaire |  |  |
| M0_Q05 | 21 | Ishaka Division |  |  |
| M0_Q05 | 22 | Ruhumuro |  |  |
| M0_Q05 | 23 | Rwentuha |  |  |
| M0_Q05 | 24 | Bumbaire |  |  |
| M0_Q05 | 25 | Nyabubare |  |  |
| M0_Q05 | 26 | Bushenyi central |  |  |
| M0_Q05 | 27 | Kizinda Town Council |  |  |
| M0_Q05 | 28 | Kyamuhunga Town |  |  |
| M0_Q05 | 29 | Kakanju |  |  |
| M0_Q05 | 30 | Nyakabirizi |  |  |
| M0_Q05 | 31 | Bitooma |  |  |
| M0_Q05 | 32 | Ibaare |  |  |
| M0_Q05 | 33 | Ishaka Division |  |  |
| M0_Q05 | 34 | Ruhumuro |  |  |
| M0_Q05 | 35 | Bumbaire |  |  |
| M0_Q05 | 36 | Bushenyi central |  |  |
| M0_Q05 | 37 | Kizinda Town Council |  |  |
| M0_Q05 | 38 | Kyamuhunga Town |  |  |
| M0_Q05 | 39 | Kakanju |  |  |
| M0_Q05 | 40 | Nyakabirizi |  |  |
| M0_Q05 | 41 | Ibaare |  |  |
| M0_Q05 | 42 | Kicwamba |  |  |
| M0_Q05 | 43 | Kirugu |  |  |
| M0_Q05 | 44 | Katerera Town council |  |  |
| M0_Q05 | 45 | Ryeru |  |  |
| M0_Q05 | 46 | Magambo |  |  |
| M0_Q05 | 47 | Rutoto |  |  |
| M0_Q05 | 48 | Kyabakara |  |  |
| M0_Q05 | 49 | Katunguru |  |  |
| M0_Q05 | 50 | Kicwamba |  |  |
| M0_Q05 | 51 | Kirugu |  |  |
| M0_Q05 | 52 | Katerera Town council |  |  |
| M0_Q05 | 53 | Ryeru |  |  |
| M0_Q05 | 54 | Magambo |  |  |
| M0_Q05 | 55 | Katunguru |  |  |
| M0_Q05 | 56 | Kicwamba |  |  |
| M0_Q05 | 57 | Rutoto |  |  |
| M0_Q05 | 58 | Kicwamba |  |  |
| M0_Q05 | 59 | Katanda |  |  |
| M0_Q05 | 60 | Katerera Town council |  |  |
| M0_Q05 | 61 | Kirugu |  |  |
| M0_Q05 | 62 | Katerera Sub county |  |  |
| M0_Q05 | 63 | Kyabakara |  |  |
| M0_Q05 | 64 | Ryeru |  |  |
| M0_Q05 | 65 | Katunguru |  |  |
| M0_Q05 | 66 | Rutoto |  |  |
| M0_Q05 | 67 | Kicwamba |  |  |
| M0_Q05 | 68 | Katanda |  |  |
| M0_Q05 | 69 | Katerera Town council |  |  |
| M0_Q05 | 70 | Kirugu |  |  |
| M0_Q05 | 71 | Katerera Sub county |  |  |
| M0_Q05 | 72 | Bugongi |  |  |
| M0_Q05 | 73 | Masheruka sub county |  |  |
| M0_Q05 | 74 | Kyangyenyi |  |  |
| M0_Q05 | 75 | kagango |  |  |
| M0_Q05 | 76 | Kasana Sub county |  |  |
| M0_Q05 | 77 | Kabwohe Division |  |  |
| M0_Q05 | 78 | Bugongi |  |  |
| M0_Q05 | 79 | Masheruka TC |  |  |
| M0_Q05 | 80 | Kigarama Sub county |  |  |
| M0_Q05 | 81 | Kitagata Town counsil |  |  |
| M0_Q05 | 82 | Bugongi |  |  |
| M0_Q05 | 83 | Masheruka sub county |  |  |
| M0_Q05 | 84 | Kyangyenyi |  |  |
| M0_Q05 | 85 | kagango |  |  |
| M0_Q05 | 86 | kagango |  |  |
| M0_Q05 | 87 | Kyangyenyi |  |  |
| M0_Q05 | 88 | Kigarama Sub county |  |  |
| M0_Q05 | 89 | Bugongi |  |  |
| M0_Q05 | 90 | Kasana Sub county |  |  |
| M0_Q05 | 91 | Kabwohe Division |  |  |
| M0_Q05 | 92 | Kabwohe Division |  |  |
| M0_Q05 | 93 | Masheruka TC |  |  |
| M0_Q05 | 94 | kagango |  |  |
| M0_Q05 | 95 | Kyangyenyi |  |  |
| M0_Q05 | 96 | Kigarama Sub county |  |  |
| M0_Q05 | 97 | Bugongi |  |  |
| M0_Q05 | 98 | Kasana Sub county |  |  |
| M0_Q05 | 99 | Kabwohe Division |  |  |
| M0_Q05 | 100 | Kabwohe Division |  |  |
| M0_Q05 | 101 | Kakanju |  |  |
| M0_Q05 | 102 | Kizinda Town Council |  |  |
| M0_Q05 | 105 | Kyamuhunga  |  |  |
| M0_Q05 | 106 | Kirugu |  |  |
| M0_Q05 | 107 | Kirugu |  |  |
| M0_Q05 | 108 | Ryeru |  |  |
| M0_Q05 | 109 | Kicwamba  |  |  |
| M0_Q05 | 110 | Rubirizi town  |  |  |
| M0_Q05 | 111 | Kirugu |  |  |
| M0_Q05 | 112 | Masheruka sub county |  |  |
| M0_Q05 | 117 | Kabwohe Division |  |  |
| M0_Q05 | 121 | Katerera Town council |  |  |
| M0_Q05 | 125 | Kyamuhunga sub county |  |  |
| M0_Q06 | 1 | Butare |  |  |
| M0_Q06 | 2 | Kararo |  |  |
| M0_Q06 | 3 | Katunga |  |  |
| M0_Q06 | 4 | Kyeibingo |  |  |
| M0_Q06 | 5 | Bumbaire |  |  |
| M0_Q06 | 6 | Birimbi |  |  |
| M0_Q06 | 7 | Nyabubare |  |  |
| M0_Q06 | 8 | Kigoma |  |  |
| M0_Q06 | 9 | Kimuri |  |  |
| M0_Q06 | 10 | Ward I |  |  |
| M0_Q06 | 11 | Kyeitembe |  |  |
| M0_Q06 | 12 | Kyamugabo |  |  |
| M0_Q06 | 13 | Rutooma |  |  |
| M0_Q06 | 14 | Kakoni |  |  |
| M0_Q06 | 15 | Kitwe |  |  |
| M0_Q06 | 16 | Kitwe |  |  |
| M0_Q06 | 17 | Butare |  |  |
| M0_Q06 | 18 | Nyamiyaga |  |  |
| M0_Q06 | 19 | Katunga |  |  |
| M0_Q06 | 20 | Bumbaire |  |  |
| M0_Q06 | 21 | Ishaka |  |  |
| M0_Q06 | 22 | Burungira |  |  |
| M0_Q06 | 23 | Rutooma |  |  |
| M0_Q06 | 24 | Bumbaire |  |  |
| M0_Q06 | 25 | Nyabubare |  |  |
| M0_Q06 | 26 | Central ward |  |  |
| M0_Q06 | 27 | Kizinda |  |  |
| M0_Q06 | 28 | Butare |  |  |
| M0_Q06 | 29 | Katunga |  |  |
| M0_Q06 | 30 | Kibaare |  |  |
| M0_Q06 | 31 | Nyanga |  |  |
| M0_Q06 | 32 | Kyamugabo |  |  |
| M0_Q06 | 33 | Ishaka |  |  |
| M0_Q06 | 34 | Bugaana |  |  |
| M0_Q06 | 35 | Kibaare |  |  |
| M0_Q06 | 36 | Ward II |  |  |
| M0_Q06 | 37 | Nyabubare |  |  |
| M0_Q06 | 38 | Bubare |  |  |
| M0_Q06 | 39 | Kakanju |  |  |
| M0_Q06 | 40 | Kibaare |  |  |
| M0_Q06 | 41 | Kyamugabo |  |  |
| M0_Q06 | 42 | Rumri |  |  |
| M0_Q06 | 43 | Kikumbo |  |  |
| M0_Q06 | 44 | Katerera ward |  |  |
| M0_Q06 | 45 | Bugaya |  |  |
| M0_Q06 | 46 | Bugaya |  |  |
| M0_Q06 | 47 | Rutoto |  |  |
| M0_Q06 | 48 | Rugarama |  |  |
| M0_Q06 | 49 | Kashaka |  |  |
| M0_Q06 | 50 | Katara |  |  |
| M0_Q06 | 51 | Kikumbo |  |  |
| M0_Q06 | 52 | Katerera ward |  |  |
| M0_Q06 | 53 | Bugaya |  |  |
| M0_Q06 | 54 | Butoha |  |  |
| M0_Q06 | 55 | Katunguru |  |  |
| M0_Q06 | 56 | Kicwamba |  |  |
| M0_Q06 | 57 | Rutoto |  |  |
| M0_Q06 | 58 | Kicwamba |  |  |
| M0_Q06 | 59 | kyankaranga |  |  |
| M0_Q06 | 60 | Nyakagyezi ward |  |  |
| M0_Q06 | 61 | Kirugu |  |  |
| M0_Q06 | 62 | katerera |  |  |
| M0_Q06 | 63 | Rugarama |  |  |
| M0_Q06 | 64 | Butoha |  |  |
| M0_Q06 | 65 | Kisenyi |  |  |
| M0_Q06 | 66 | Rutoto |  |  |
| M0_Q06 | 67 | Kyambura |  |  |
| M0_Q06 | 68 | Rwamatumba |  |  |
| M0_Q06 | 69 | Katerera ward |  |  |
| M0_Q06 | 70 | Kyenzaza |  |  |
| M0_Q06 | 71 | katerera |  |  |
| M0_Q06 | 72 | Kyamurari |  |  |
| M0_Q06 | 73 | Rugazi |  |  |
| M0_Q06 | 74 | Kashanjure |  |  |
| M0_Q06 | 75 | Kagango |  |  |
| M0_Q06 | 76 | Kasaana Central |  |  |
| M0_Q06 | 77 | Nyanga |  |  |
| M0_Q06 | 78 | Kyamurari |  |  |
| M0_Q06 | 79 | Kanyegayegye |  |  |
| M0_Q06 | 80 | Kigarama |  |  |
| M0_Q06 | 81 | Kyarushakara |  |  |
| M0_Q06 | 82 | Isingiro |  |  |
| M0_Q06 | 83 | Nyabwina |  |  |
| M0_Q06 | 84 | Kagongi |  |  |
| M0_Q06 | 85 | Kagango |  |  |
| M0_Q06 | 86 | Kagango |  |  |
| M0_Q06 | 87 | Masyooro |  |  |
| M0_Q06 | 88 | Kigarama |  |  |
| M0_Q06 | 89 | Kyamurari |  |  |
| M0_Q06 | 90 | Kasaana North |  |  |
| M0_Q06 | 91 | Nyanga |  |  |
| M0_Q06 | 92 | kabwohe |  |  |
| M0_Q06 | 93 | Kanyegayegye |  |  |
| M0_Q06 | 94 | Kagango |  |  |
| M0_Q06 | 95 | Kagongi |  |  |
| M0_Q06 | 96 | Byayegamba |  |  |
| M0_Q06 | 97 | Isingiro |  |  |
| M0_Q06 | 98 | Karugorora |  |  |
| M0_Q06 | 99 | Kabwohe |  |  |
| M0_Q06 | 100 | Nyanga |  |  |
| M0_Q06 | 101 | Katunga |  |  |
| M0_Q06 | 102 | Nyabubare |  |  |
| M0_Q06 | 103 | Nyabubare |  |  |
| M0_Q06 | 104 | Kizinda ward |  |  |
| M0_Q06 | 105 | Butaare |  |  |
| M0_Q06 | 106 | Kikumbo |  |  |
| M0_Q06 | 107 | Kirugu |  |  |
| M0_Q06 | 108 | Ndekye |  |  |
| M0_Q06 | 109 | Kicwamba  |  |  |
| M0_Q06 | 110 | Nyakasharu |  |  |
| M0_Q06 | 111 | Kirugu |  |  |
| M0_Q06 | 112 | Nyakambu |  |  |
| M0_Q06 | 113 | Nyakambu |  |  |
| M0_Q06 | 114 | Mabare |  |  |
| M0_Q06 | 115 | Mabare |  |  |
| M0_Q06 | 116 | Buringo |  |  |
| M0_Q06 | 117 | Kabwohe |  |  |
| M0_Q06 | 118 | Rutoma  |  |  |
| M0_Q06 | 119 | Nyanga ward |  |  |
| M0_Q06 | 120 | Kabwohe |  |  |
| M0_Q06 | 121 | Katerera |  |  |
| M0_Q06 | 122 | Katerera |  |  |
| M0_Q06 | 123 | Katerera |  |  |
| M0_Q06 | 124 | Katerera |  |  |
| M0_Q06 | 125 | Nsumi |  |  |
| M0_Q06 | 126 | Mashonga  |  |  |
| M0_Q06 | 127 | Kibazi |  |  |
| M0_Q06 | 128 | Mashonga |  |  |
| M0_Q07 | 1 | Nyakahanga |  |  |
| M0_Q07 | 2 | Kitagata |  |  |
| M0_Q07 | 3 | Nombe B |  |  |
| M0_Q07 | 4 | Kansenjesa |  |  |
| M0_Q07 | 5 | Kisubu |  |  |
| M0_Q07 | 6 | Kirimbi |  |  |
| M0_Q07 | 7 | Nyabitote I |  |  |
| M0_Q07 | 8 | Ryabuganyi |  |  |
| M0_Q07 | 9 | Kimuri |  |  |
| M0_Q07 | 10 | Katungu |  |  |
| M0_Q07 | 11 | Bwatogo |  |  |
| M0_Q07 | 12 | Kibingo |  |  |
| M0_Q07 | 13 | Rutooma ward |  |  |
| M0_Q07 | 14 | Manengo |  |  |
| M0_Q07 | 15 | Kajunju |  |  |
| M0_Q07 | 16 | Buhimba A |  |  |
| M0_Q07 | 17 | Nyampungye |  |  |
| M0_Q07 | 18 | Nyamiyaga |  |  |
| M0_Q07 | 19 | Kakuto B |  |  |
| M0_Q07 | 20 | Kitakuuka |  |  |
| M0_Q07 | 21 | K.I.U |  |  |
| M0_Q07 | 22 | Orubingo A |  |  |
| M0_Q07 | 23 | Rwentuha Town |  |  |
| M0_Q07 | 24 | Bumbaire II |  |  |
| M0_Q07 | 25 | Nkuna I |  |  |
| M0_Q07 | 26 | Nyamiko |  |  |
| M0_Q07 | 27 | Kangaate |  |  |
| M0_Q07 | 28 | Nyamalembe |  |  |
| M0_Q07 | 29 | Bwegyeme A |  |  |
| M0_Q07 | 30 | Kibaare II |  |  |
| M0_Q07 | 31 | Kyamamari |  |  |
| M0_Q07 | 32 | Kyamugabo |  |  |
| M0_Q07 | 33 | Bassaja |  |  |
| M0_Q07 | 34 | Nyamyerande I |  |  |
| M0_Q07 | 35 | Nyabubare B |  |  |
| M0_Q07 | 36 | Ruhandagazi |  |  |
| M0_Q07 | 37 | Rushoroza |  |  |
| M0_Q07 | 38 | Butare ward |  |  |
| M0_Q07 | 39 | Nyabubare A |  |  |
| M0_Q07 | 40 | Kibaare I |  |  |
| M0_Q07 | 41 | Tandara |  |  |
| M0_Q07 | 42 | Rumuri II |  |  |
| M0_Q07 | 43 | Omukabare |  |  |
| M0_Q07 | 44 | Katerera I |  |  |
| M0_Q07 | 45 | Mubanda |  |  |
| M0_Q07 | 46 | Busonga II |  |  |
| M0_Q07 | 47 | Bururuma |  |  |
| M0_Q07 | 48 | Nyabubare |  |  |
| M0_Q07 | 49 | Kimanvu I |  |  |
| M0_Q07 | 50 | Katara I |  |  |
| M0_Q07 | 51 | Ntunga A |  |  |
| M0_Q07 | 52 | Katerera II |  |  |
| M0_Q07 | 53 | Karagara |  |  |
| M0_Q07 | 54 | Nyangorogo II |  |  |
| M0_Q07 | 55 | Kyangabukama |  |  |
| M0_Q07 | 56 | Kyambuzi B |  |  |
| M0_Q07 | 57 | Omukyeya |  |  |
| M0_Q07 | 58 | Mutambi IIB |  |  |
| M0_Q07 | 59 | Mikonabire |  |  |
| M0_Q07 | 60 | Nyakagyezi I |  |  |
| M0_Q07 | 61 | Kafuro IB |  |  |
| M0_Q07 | 62 | Kakindo |  |  |
| M0_Q07 | 63 | Kagarama |  |  |
| M0_Q07 | 64 | Nyakiyaza |  |  |
| M0_Q07 | 65 | Nyamweru |  |  |
| M0_Q07 | 66 | Rwemitanga |  |  |
| M0_Q07 | 67 | Kyambura C |  |  |
| M0_Q07 | 68 | Kisharu I |  |  |
| M0_Q07 | 69 | Kabaseeka |  |  |
| M0_Q07 | 70 | Kirugu IB |  |  |
| M0_Q07 | 71 | Katabengo |  |  |
| M0_Q07 | 72 | Rwenkurigo |  |  |
| M0_Q07 | 73 | Kabaare |  |  |
| M0_Q07 | 74 | Kashanjure |  |  |
| M0_Q07 | 75 | Kanyina |  |  |
| M0_Q07 | 76 | Kihanga II |  |  |
| M0_Q07 | 77 | Kyamatongo |  |  |
| M0_Q07 | 78 | Kamushasha |  |  |
| M0_Q07 | 79 | Bugarama |  |  |
| M0_Q07 | 80 | Kigarama |  |  |
| M0_Q07 | 81 | Bwoma |  |  |
| M0_Q07 | 82 | Isingiro |  |  |
| M0_Q07 | 83 | Nyabwina |  |  |
| M0_Q07 | 84 | Ryamatshya II |  |  |
| M0_Q07 | 85 | Kiziba |  |  |
| M0_Q07 | 86 | Itendero Town |  |  |
| M0_Q07 | 87 | Masyooro |  |  |
| M0_Q07 | 88 | Katanoga |  |  |
| M0_Q07 | 89 | Runyinya II |  |  |
| M0_Q07 | 90 | Mishenyi |  |  |
| M0_Q07 | 91 | Rushorooza west |  |  |
| M0_Q07 | 92 | Ishekye |  |  |
| M0_Q07 | 93 | Ihanda |  |  |
| M0_Q07 | 94 | Kihunda |  |  |
| M0_Q07 | 95 | Ryamatshya |  |  |
| M0_Q07 | 96 | Nyakasharara |  |  |
| M0_Q07 | 97 | Kyabuyongo |  |  |
| M0_Q07 | 98 | Karugorora |  |  |
| M0_Q07 | 99 | Kabwohe hill |  |  |
| M0_Q07 | 100 | Mailo IV |  |  |
| M0_Q07 | 101 | Kakuto A |  |  |
| M0_Q07 | 102 | Nyakinengo |  |  |
| M0_Q07 | 103 | Masya |  |  |
| M0_Q07 | 104 | Kitooma  |  |  |
| M0_Q07 | 105 | Nyambugye  |  |  |
| M0_Q07 | 106 | Omukabare  B |  |  |
| M0_Q07 | 107 | Kirugu 2 B |  |  |
| M0_Q07 | 108 | Ryeru |  |  |
| M0_Q07 | 109 | Kyesama  |  |  |
| M0_Q07 | 110 | Kyakabunda  |  |  |
| M0_Q07 | 111 | Mirarikye |  |  |
| M0_Q07 | 112 | Nyakambu |  |  |
| M0_Q07 | 113 | Migera |  |  |
| M0_Q07 | 114 | Rwichumu  |  |  |
| M0_Q07 | 115 | Nyakanoni |  |  |
| M0_Q07 | 116 | Mukono 1 |  |  |
| M0_Q07 | 117 | Market cell |  |  |
| M0_Q07 | 118 | Kabwohe A |  |  |
| M0_Q07 | 119 | Mabaga Cell |  |  |
| M0_Q07 | 120 | Kabwohe central |  |  |
| M0_Q07 | 121 | Kikonjo |  |  |
| M0_Q07 | 122 | KIZIRA CELL |  |  |
| M0_Q07 | 123 | KACU CELL |  |  |
| M0_Q07 | 124 | RWENTOSHO I |  |  |
| M0_Q07 | 125 | NYAMPUGYE |  |  |
| M0_Q07 | 126 | KYAMABARE  |  |  |
| M0_Q07 | 127 | NYAKAZINGA |  |  |
| M0_Q07 | 128 | Nyamabare |  |  |
| M0_Q02 | 1 | Ivan |  |  |
| M0_Q02 | 2 | Jorge |  |  |
## Sheet: settings
| form_title | form_id | version | public_key | submission_url | default_language |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Phase 1 Baseline | phase_1_baseline | 2605152131 |  |  | english |  |  |
## Sheet: help-survey
| The survey worksheet |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| This worksheet specifies all of the groups, questions, and other fields in your survey form, each in its own row. Aside from overall settings and lists of multiple-choice options, everything about your survey form is specified in this worksheet. |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Learn more about form definitions and field types |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| type | name | label | label:languagename | hint | hint:languagename | default | appearance | constraint | constraint message | constraint message:languagename | relevance | disabled | required | required message | required message:languagename | read only | calculation | repeat_count | media:image | media:audio | media:video | media:image:languagename | media:audio:languagename | media:video:languagename | choice_filter | note | response_note | publishable | minimum_seconds |
| This column specifies the type of the field or group. It has to follow a pre-specified format, and Excel's conditional formatting has been used to auto-highlight rows that appear to have a valid type column -- so, if you are using Excel and your row is not automatically highlighted, re-check that you have entered the type properly. 

See below for an exhaustive list of brief examples. | This column specifies the name of the field or group. Field names must be unique, and they cannot include any spaces or punctuation. 

Example: age | For those field types that present a user interface, this column is where you put the primary text for the question or field. You can include line-breaks in your label text by pressing Alt+Enter on Windows or Control+Option+Enter on a Mac. | Any label:languagename column (e.g., label:tamil) may be added in order to provide labels in an alternative language.

View the help topic below for more details. | Text in this column, if any, will appear italicized beneath the field's label. You can include line-breaks in your hint text by pressing Alt+Enter on Windows or Control+Option+Enter on a Mac. | Any hint:languagename column (e.g., hint:tamil) may be added in order to provide hints in an alternative language.

View the help topic below for more details. | If you want to default the user's entry or selection for a given field, you can specify a number or some text in this column. 

Alternatively, you can specify an expression for dynamically calculating the field's default entry or selection, in the "calculation" column. View the help topic below for more details.

View the help topic below for more details. | For field types that allow multiple appearances, you can specify the appearance style in this column (e.g., quick or minimal for select_one fields). 

See the individual examples below. | Enter an expression into this column to validate entered or selected values. The user will only be allowed to proceed to the next question when the expression evaluates to true. Use the constraint builder to build new constraint expressions. (Also see the expression quick-reference following the examples below.) 

Example: . < 130

View the help topic below for more details. | If the user tries to move forward but the constraint expression is false, a generic "That entry is invalid" message will appear; to override this message on a field-by-field basis, enter another message into this column.

View the help topic below for more details. | Any constraint message:languagename column (e.g., constraint message:tamil) may be added in order to provide constraint messages in an alternative language. | Enter an expression into this column to control when a field or group displays to the user (i.e., to control when it is "relevant"). The field or group will only show up to users when the expression in this column evaluates to true; otherwise, it will remain hidden. Use the relevance builder to build new relevance expressions. (Also see the expression quick-reference following the examples below.) 

Example: ${age} < 18

View the help topic below for more details. | Enter yes into this column to temporarily disable a field. (Rarely used.)

View the help topic below for more details. | Enter yes into this column to require that users enter or select a value before continuing.

View the help topic below for more details. | If the user tries to move forward without entering or selecting a value for a required field, a generic "Sorry, this response is required" message will appear; to override this message on a field-by-field basis, enter another message into this column.

View the help topic below for more details. | Any required message:languagename column (e.g., required message:tamil) may be added in order to provide required messages in an alternative language. | Enter yes into this column to make it read-only (a user can see the field, but cannot enter or select a value). (Rarely used, because note fields, which are by nature read-only, are automatically read-only regardless of what is specified here.) | This column specifies the expression to use for a calculate field, or the expression to use for calculating the default entry or selection for a visible form field. Use the calculation builder to build new calculation expressions. (Also see the expression quick-reference following the examples below.)

View the help topic below for more details. | For a begin repeat row, this column can specify the number of times to repeat the group of questions. (Can be a fixed count like 3 or a reference to an earlier field like ${numhh_members}.)

View the help topic below for more details. | To include an image to display for a field (in addition to or in lieu of its label), its filename should be specified here (and the file should be uploaded with this form defintion). Which media file formats are supported will depend on your Android device, but all devices support common image formats like .jpg or .png. 

Example: paddy.png

View the help topic below for more details. | To include a sound clip that can be played at a field, its filename should be specified here (and the file should be uploaded with this form defintion). Which media file formats are supported will depend on your Android device. 

Example: explanation.3gpp

View the help topic below for more details. | To include a video clip that can be played at a field, its filename should be specified here (and the file should be uploaded with this form defintion). Which media file formats are supported will depend on your Android device. 

Example: demonstration.mp4

View the help topic below for more details. | Any media:image:languagename column (e.g., media:image:tamil) may be added in order to provide images for an alternative language.

View the help topic below for more details. | Any media:audio:languagename column (e.g., media:audio:tamil) may be added in order to provide audio clips for an alternative language.

View the help topic below for more details. | Any media:video:languagename column (e.g., media:video:tamil) may be added in order to provide video clips for an alternative language.

View the help topic below for more details. | When filtering lists of multiple-choice options, this column specifies, for each field, which prior field should be used when filtering the list of options. 

Example: filter=${survey_region}

View the help topic below for more details. | This column can specify an optional note to appear with the field in printable versions of the survey form, in order to explain when groups or fields will appear (i.e., when they are relevant), what restrictions there are on user entries (i.e., what constraints apply), etc. | This column can specify optional text or symbols to appear in the response area to the right of questions in printable versions of the survey form. For a text field, for example, you might put something like |___|___| if you are looking for two letters or numbers; or, for a checkbox, you might put a hollow square like □ (this is a special HTML character: enter "&#9633;", without quotes, into this column); finally, for a radio button, you might simply enter a capital O. | Enter yes into this column to indicate that a field in an encrypted form should be left unencrypted so that it can be published to one or more datasets. Use only for non-sensitive fields that can be left unencrypted without compromising data security. (This field is ignored for unencrypted forms.)

View the help topic below for more details. | Enter a number of seconds that represents the minimum time enumerators should spend the first time they view the field. This represents a "speed limit" that can be enforced by SurveyCTO Collect for Android (with the Enforce minimum times for fields option within Collect's Admin Settings); alternatively, you can track violations with the following field types: "speed violations count", "speed violations list", and "speed violations audit" (see examples for these field types below).

View the help topic below for more details.  |
|  |  |  | Help topic: Form languages |  | Help topic: Form languages | Help topic: Pre-loading data into a form |  | Help topic: Using constraints to validate responses | Help topic: Using constraints to validate responses |  | Help topic: Implementing skip patterns with "relevance" | Help topic: Other field properties | Help topic: Other field properties | Help topic: Other field properties |  | Help topic: Other field properties | Help topic: Field type: calculate | Help topic: Grouping and repeating questions | Help topic: Images: Adding pictures and other graphics | Help topic: Other field properties | Help topic: Other field properties | Help topic: Form languages | Help topic: Form languages | Help topic: Form languages | Help topic: Dynamically filtering lists of multiple-choice options | Help topic: Downloading printable copies of your forms | Help topic: Downloading printable copies of your forms | Help topic: Encrypting form data (end-to-end encryption) | Help topic: Collecting high-quality data |
| Examples (scroll right for appearance styles) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| enumerator | fieldname | Enumerator selection field (require a special code in order to reveal the full enumerator list): |  |  |  |  | other-user-code(xyz) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| enumerator | fieldname | Enumerator selection field (require a special code in order to enter a new enumerator): |  |  |  |  | add-new-code(xyz) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| enumerator | fieldname | Enumerator selection field: |  |  |  |  | default-to-entry |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| enumerator | fieldname | Enumerator selection field: |  |  |  |  | default-to-scan |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| text | fieldname | Standard text field: |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| text | fieldname | Text field which uses the numeric keypad: |  |  |  |  | numbers |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| integer | fieldname | Standard integer field: |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| decimal | fieldname | Standard decimal field: |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Standard multiple-choice field (allows one selection, shown as series of radio buttons): |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, shown horizontally along likert-type scale): |  |  |  |  | likert |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, shown horizontally along likert-type scale, labels only at ends of the scale): |  |  |  |  | likert-min |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, shown horizontally along likert-type scale, labels only at ends and middle of scale): |  |  |  |  | likert-mid |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, auto-advances to next question as soon as an option is selected): |  |  |  |  | quick |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, shown as a drop-down selector): |  |  |  |  | minimal |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, shown as a compact table of options): |  |  |  |  | compact |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, shown as a compact table of options with exactly three columns): |  |  |  |  | compact-3 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, shown as a compact table of options, auto-advances to next question as soon as an option is selected): |  |  |  |  | quickcompact |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, shown as a compact table of options with exactly three columns, auto-advances to next question as soon as an option is selected): |  |  |  |  | quickcompact-3 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, loads options from pre-loaded .csv file, includes options based on a "contains" comparison): |  |  |  |  | search('hhplotdata', 'contains', 'respondentname', ${nametofind}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, loads options from pre-loaded .csv file, includes options based on a "starts with" comparison): |  |  |  |  | search('hhplotdata', 'startswith', 'respondentname', ${nameprefix}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, loads options from pre-loaded .csv file, includes options based on an "ends with" comparison): |  |  |  |  | search('hhplotdata', 'endswith', 'respondentname', ${namesuffix}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, loads options from pre-loaded .csv file, includes options based on an "exact match" comparison): |  |  |  |  | search('hhplotdata', 'matches', 'respondentname', ${nametofind}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_one listname | fieldname | Multiple-choice field (allows one selection, loads options from pre-loaded .csv file, includes options based on both a "contains" comparison and an "exact match" filter): |  |  |  |  | search('hhplotdata', 'contains', 'respondentname', ${nametofind}, 'villageid', ${villageid}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_multiple listname | fieldname | Standard multiple-choice field (allows multiple selections, shown as series of radio buttons): |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_multiple listname | fieldname | Multiple-choice field (allows multiple selections, shown as a pop-up selector): |  |  |  |  | minimal |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_multiple listname | fieldname | Multiple-choice field (allows multiple selections, shown as a compact table of options): |  |  |  |  | compact |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_multiple listname | fieldname | Multiple-choice field (allows multiple selections, shown as a compact table of options with exactly three columns): |  |  |  |  | compact-3 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_multiple listname | fieldname | Multiple-choice field (allows multiple selections, loads options from pre-loaded .csv file, includes options based on a "contains" comparison): |  |  |  |  | search('hhplotdata', 'contains', 'respondentname', ${nametofind}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_multiple listname | fieldname | Multiple-choice field (allows multiple selections, loads options from pre-loaded .csv file, includes options based on a "starts with" comparison): |  |  |  |  | search('hhplotdata', 'startswith', 'respondentname', ${nameprefix}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_multiple listname | fieldname | Multiple-choice field (allows multiple selections, loads options from pre-loaded .csv file, includes options based on an "ends with" comparison): |  |  |  |  | search('hhplotdata', 'endswith', 'respondentname', ${namesuffix}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_multiple listname | fieldname | Multiple-choice field (allows multiple selections, loads options from pre-loaded .csv file, includes options based on an "exact match" comparison): |  |  |  |  | search('hhplotdata', 'matches', 'respondentname', ${nametofind}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| select_multiple listname | fieldname | Multiple-choice field (allows multiple selections, loads options from pre-loaded .csv file, includes options based on both a "contains" comparison and an "exact match" filter): |  |  |  |  | search('hhplotdata', 'contains', 'respondentname', ${nametofind}, 'villageid', ${villageid}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| geopoint | fieldname | Standard GPS location-capture field: |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| geoshape | fieldname | Boundary-capture field (GPS polygon): |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| geotrace | fieldname | Boundary- or path-capture field (GPS polyline or polygon): |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| barcode | fieldname | Standard scan-barcode field: |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| date | fieldname | Standard date field: |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| date | fieldname | Date field (but for smaller screens): |  |  |  |  | no-calendar |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| datetime | fieldname | Standard date+time field: |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| datetime | fieldname | Date+time field (but for smaller screens): |  |  |  |  | no-calendar |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| time | fieldname | Standard time field: |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| image | fieldname | Standard image-capture field: |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| image | fieldname | Image-capture field which allows user to annotate image: |  |  |  |  | annotate |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| image | fieldname | Image-capture field which allows user to draw image: |  |  |  |  | draw |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| image | fieldname | Image-capture field which collects a signature as the image: |  |  |  |  | signature |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| audio | fieldname | Standard audio-capture field: |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| video | fieldname | Standard video-capture field: |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| file | fieldname | Attach text, image, video, audio, PDF, ZIP, or MS Office file (Excel or Word): |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| note | fieldname | Standard note field (read-only). |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| start | fieldname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| end | fieldname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| deviceid | fieldname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| subscriberid | fieldname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| simserial | fieldname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| caseid | fieldname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| phonenumber | fieldname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| comments | fieldname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| calculate | fieldname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | (${age1}+${age2}+${age3}) div 3 |  |  |  |  |  |  |  |  |  |  |  |  |
| calculate_here | fieldname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | once(format-date-time(now(), '%Y-%b-%e %H:%M:%S')) |  |  |  |  |  |  |  |  |  |  |  |  |
| text audit | fieldname |  |  |  |  |  | p = 50 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| text audit | fieldname |  |  |  |  |  | p = 50; eventlog; choices |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| audio audit | fieldname |  |  |  |  |  | p = 50; s = 0; d = 60 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| audio audit | fieldname |  |  |  |  |  | p = 50; s = 0-600; d = 60 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| audio audit | fieldname |  |  |  |  |  | p = 50; s = firstfield; d = lastfield |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin group | groupname | Standard group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| … |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| end group | groupname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin repeat | repeatname | Standard repeated group |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| … |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| end repeat | repeatname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| begin repeat | repeatname | Group repeated exactly three times |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 3 |  |  |  |  |  |  |  |  |  |  |  |
| … |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| end repeat | repeatname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| speed violations count | fieldname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| speed violations list | fieldname |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| speed violations audit | fieldname |  |  |  |  |  | v = 5; d = 120 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| sensor_stream movement | fieldname |  |  |  |  |  | period = 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| sensor_statistic pct_movement_between | fieldname |  |  |  |  |  | min = 0.25; max = 2 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Quick reference for relevance, constraint, and selected calculation expressions |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Learn about all available expressions in "Using expressions in your forms: a reference for all operators and functions" |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Operation | Operator | Example | Example answer |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Addition | + | 1 + 1 | 2 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Subtraction | - | 3 - 2 | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Multiplication | * | 3 * 2 | 6 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Division | div | 10 div 2 | 5 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Modulus | mod | 9 mod 2 | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Equal | = | ${fieldname} = 3 | true or false |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Not equal | != | ${fieldname} != 3 | true or false |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Greater-than | > | ${fieldname} > 3 | true or false |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| >-or-equal | >= | ${fieldname} >= 3 | true or false |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Less-than | < | ${fieldname} < 3 | true or false |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| <-or-equal | <= | ${fieldname} <= 3 | true or false |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Or | or | ${fieldname} = 3 or ${fieldname} = 4 | true or false |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| And | and | ${fieldname} > 3 and ${fieldname} < 5 | true or false |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Not | not() | not(${fieldname} > 3 and ${fieldname} < 5) | false or true |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Function | Example |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | relevant(field) | relevant(${followup_question}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | empty(field) | empty(${consent}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | once(expression) | once(random()) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | once(random()) | once(random()) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | pulldata(csvname, colname, lookupcolname, lookupval) | pulldata('hhplotdata', 'plot1size', 'hhid_key', ${hhid}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | string-length(field) | string-length(.) > 3 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | count-selected(field) | count-selected(.) >= 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | selected(field, value) | selected(${fieldname}, 'Male') |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | selected-at(field, number) | selected-at(${fieldname}, 0) = 'Shona' |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | choice-label(field, value) | choice-label(${selectonefield}, ${selectonefield}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | concat(fieldorstring, fieldorstring, ...) | concat(${firstname}, ' ', ${lastname}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | index() | index() |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | count(repeatgroup) | count(${repeatgroupname}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | sum(repeatedfield) | sum(${loan_size}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | join(string, repeatedfield) | join(' ,', ${hh_member_name}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | min(repeatedfield) | min(${hh_member_age}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | max(repeatedfield) | max(${hh_member_age}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | indexed-repeat(repeatedfield, repeatgroup, index) | indexed-repeat(${name}, ${names}, 1) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | substr(fieldorstring, startindex, endindex) | substr(${phone}, 0, 3) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | coalesce(field1, field2) | coalesce(${id}, ${id2}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | round(field, digits) | round(${interest_rate}, 2) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | regex(field, expression) | regex(., '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}') |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | if(expression, valueiftrue, valueiffalse) | if(selected(${country}, 'South Africa') or selected(${country}, 'Zimbabwe'), 'SADC', 'Non-SADC') |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | today() | format-date-time(today(), '%Y-%b-%e') |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | now() | once(format-date-time(now(), '%Y-%b-%e %H:%M:%S')) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | username() | username() |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | duration() | duration() |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | rank-index(index, repeatedfield) | rank-index(1, ${random_draw}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | rank-value(fieldorvalue, fieldorlist) | rank-value(${random_draw}, ${list_of_draws}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | de-duplicate(string, field) | de-duplicate(' ', join(' ', ${repeatedfield})) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | distance-between(geopointfield1, geopointfield2) | distance-between(${start_gps}, ${end_gps}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | area(repeatedgeopointfield) | area(${gps_reading}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | phone-call-log() | phone-call-log() |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | plug-in-metadata(field) | plug-in-metadata(${counter}) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: help-choices
| The choices worksheet |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- |
| This worksheet is for the configuration of multiple-choice response options. These are stored in choice lists which are used with select_one and select_multiple type fields. |  |  |  |  |  |  |  |
| Read about the select_one field type for more information |  |  |  |  |  |  |  |
| Read about the select_multiple field type for more information |  |  |  |  |  |  |  |
| Read about dynamically loading choice lists from external pre-loaded data |  |  |  |  |  |  |  |
| list_name | value | label | label:languagename | image | image:languagename | filter |  |
| This column specifies the name of a multiple-choice question type (without any spaces or punctuation). A given list of options will involve multiple rows, each with the same list_name. Example: yesno | This column specifies the internal value stored for a given choice. (It should really be called "value" rather than "name".) Example: 1

If dynamically loading from a pre-loaded .csv file, this should instead be the .csv column name from which to load option values. | This column specifies the label to use for a given choice, in the form's default language. Example: Yes

If dynamically loading from a pre-loaded .csv file, this should instead be the .csv column name -- or comma-separated list of column names -- from which to load option labels for the default language. | Any label:languagename column (e.g., label:tamil) may be added in order to provide labels in an alternative language.

View the help topic below for more details. | To include an image to display for an option, its filename should be specified here (and the file should be uploaded with this form defintion). Which media file formats are supported will depend on your Android device, but all devices support common image formats like .jpg or .png. Example: paddy.png

If dynamically loading from a pre-loaded .csv file, this should instead be the .csv column name from which to load image filenames.

View the help topic below for more details. | Any label:languagename column (e.g., label:tamil) may be added in order to provide images in an alternative language. | To filter the list of options displayed, a filter value can be specified here, along with a filter expression in the choice_filter column of the survey worksheet. For example, you might have filter values like LAC and a choice_filter like filter=${survey_region}. For more details, see the following help topic: How can I filter the list of multiple-choice options presented to users? |  |
|  |  |  | Help topic: Form languages | Help topic: Images: Adding pictures and other graphics |  | Help topic: Dynamically filtering lists of multiple-choice options |  |
## Sheet: help-settings
| The settings worksheet |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- |
| This worksheet contains overall settings for your form, all specified in the second row of the worksheet. When you download a form template from your SurveyCTO server, these settings will be pre-filled for you. |  |  |  |  |  |  |  |
| form_title | form_id | version | public_key | submission_url | default_language |  |  |
| This is the title of your form. Enumerators will use the title to tell different forms apart. You will be able to revise the title of the form through subsequent form updates.

If you begin this title with TEST - (as in "TEST - Household listing survey"), it will not appear by default to users. View the help topic below for more details. | This is the unique ID that will identify the form. The form ID must not contain spaces and must remain fixed for the life of the form. The form ID must also begin with a letter, and it can only include letters, numbers, underscores, and hyphens (no other punctuation or special characters).

Example: hhlisting_round1 | This is the version number of the form, which you must increase each time you modify an existing form. If you started with a form template or with one of the sample forms, then this is automatic: the version is set to a formula that automatically increments every minute. (Otherwise, you need to increment the version number yourself, taking care to keep the number of digits fixed; the version has to be a single whole number, and its number of digits has to stay the same from one version to the next. The convention is to always use a ten-digit number that represents the current date and time, e.g., 1401130917 for 9:17AM on January 13, 2014. Alternatively, you can use 10-digit numbers like 0000000001 and 0000000024 or 3-digit numbers like 001 and 024.)

View the help topic below for more details. | This is the public key with which to encrypt all form submissions.

View the help topic below for more details. | This is the submission URL to use when submitting encrypted forms.

View the help topic below for more details. | This is the name of the language associated with labels, images, and other content when no other language is specified. For example, the label:french column is clearly in French, but the label column, which will display by default, is in an unknown language. Put the name of that default language here. 

View the help topic below for more details. |  |  |
| Help topic: Hiding forms during testing |  | Help topic: Updating an existing form | Help topic: Encrypting form data (end-to-end encryption) | Help topic: Encrypting form data (end-to-end encryption) | Help topic: Form languages |  |  |