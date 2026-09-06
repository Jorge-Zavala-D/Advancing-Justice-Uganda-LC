<!-- converted from phase1_baseline_origin_comparison.xlsx -->

## Sheet: README
| Advancing Justice Uganda - Phase 1 baseline origin comparison |  |
| --- | --- |
| Purpose | Descriptive comparison of baseline indicators between new/randomly selected villages and previously contacted villages. |
| Grouping variable | p1_admin_previously_contacted |
| Definition | 1 if admin list marks village as Last_CDFU_phase == 1 or Inherited_FHRI == 1; 0 otherwise. |
| Interpretation | Descriptive baseline association, not a causal effect of previous contact. |
| Recommended use | Use as implementation diagnostics in the Phase 1 Final Baseline Report. |
## Sheet: sample_by_origin
| p1_admin_previously_contacted | origin_group | n | share | total |
| --- | --- | --- | --- | --- |
| New / randomly selected | New / randomly selected | 107 | 0.8294573426246643 | 129 |
| Previously contacted | Previously contacted | 22 | 0.1705426424741745 | 129 |
## Sheet: sample_by_district_origin
| canonical_district | p1_admin_previously_contacted | origin_group | n | district_total | district_share |
| --- | --- | --- | --- | --- | --- |
| Bushenyi | New / randomly selected | New / randomly selected | 48 | 55 | 0.8727272748947144 |
| Bushenyi | Previously contacted | Previously contacted | 7 | 55 | 0.12727272510528564 |
| Rubirizi | New / randomly selected | New / randomly selected | 34 | 40 | 0.8500000238418579 |
| Rubirizi | Previously contacted | Previously contacted | 6 | 40 | 0.15000000596046448 |
| Sheema | New / randomly selected | New / randomly selected | 25 | 34 | 0.7352941036224365 |
| Sheema | Previously contacted | Previously contacted | 9 | 34 | 0.2647058963775635 |
## Sheet: final_diff_table
| domain | variable | label | n_new | mean_new | n_prev | mean_prev | diff_prev_minus_new | p_value | abs_diff |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Core composites | idx_lcc_operational_capacity | Operational capacity | 107 | 0.6707506739647588 | 22 | 0.8084242479367689 | 0.1376735739720101 | 6.5432615203e-06 | 0.1376735739720101 |
| Core composites | idx_p1_base_mentor_ready_proxy | Baseline mentor-readiness proxy | 107 | 0.6423631625197758 | 22 | 0.7175788391720165 | 0.0752156766522407 | 0.0004310937243595 | 0.0752156766522407 |
| Core composites | idx_lcc_case_handling_quality | Case-handling quality | 107 | 0.6739818985774139 | 22 | 0.7412330494685606 | 0.0672511508911467 | 0.0193804280094534 | 0.0672511508911467 |
| Core composites | idx_lcc_legitimacy_and_norms | Legitimacy and reintegration | 107 | 0.6207147421680879 | 22 | 0.6348355656320398 | 0.0141208234639519 | 0.5949698044801064 | 0.0141208234639519 |
| Domain indices | idx_institutional_functioning | Institutional functioning | 107 | 0.7447374307106589 | 22 | 0.8915719742124731 | 0.1468345435018142 | 3.84664613136e-05 | 0.1468345435018142 |
| Domain indices | idx_adr_mediation_practice | ADR/mediation practice | 107 | 0.6543564132858659 | 22 | 0.7586776925758882 | 0.1043212792900223 | 0.0182521017216507 | 0.1043212792900223 |
| Domain indices | idx_respondent_capacity | Respondent capacity | 107 | 0.6040053416356862 | 22 | 0.6858225071972067 | 0.0818171655615205 | 0.0178731394141011 | 0.0818171655615205 |
| Domain indices | idx_committee_functioning | Committee functioning | 107 | 0.7510707528791695 | 22 | 0.8192121169783853 | 0.0681413640992158 | 0.0227700668466222 | 0.0681413640992158 |
| Domain indices | idx_legal_classif_knowledge | Legal/classification knowledge | 107 | 0.7181269481917408 | 22 | 0.7486426803198728 | 0.030515732128132 | 0.3243985676897799 | 0.030515732128132 |
| JLOS/referral collaboration | referral_documentation_score | Referral practice score: documentation | 103 | 0.4490291262135923 | 22 | 0.6704545454545454 | 0.2214254192409531 | 0.0006142120917886 | 0.2214254192409531 |
| JLOS/referral collaboration | referral_feedback_score | Referral practice score: receiving feedback | 101 | 0.4183168316831683 | 21 | 0.6071428571428571 | 0.1888260254596888 | 0.0049773312367137 | 0.1888260254596888 |
| JLOS/referral collaboration | m6_q12_2 | Referral barrier: transport cost/lack of transport | 107 | 0.4018691588785047 | 22 | 0.5454545454545454 | 0.1435853865760407 | 0.2179972821693801 | 0.1435853865760407 |
| JLOS/referral collaboration | m6_q04_1 | Referral reason: outside LCC mandate | 107 | 0.8598130841121495 | 22 | 0.9545454545454546 | 0.0947323704333051 | 0.2227149252465224 | 0.0947323704333051 |
| JLOS/referral collaboration | verified_ref_dest_score | Enumerator-verified referral destination is recorded, 0-1 | 58 | 0.6724137931034483 | 17 | 0.7647058823529411 | 0.0922920892494928 | 0.4274183171427175 | 0.0922920892494928 |
| JLOS/referral collaboration | m6_q12_1 | Referral barrier: authority too far away | 107 | 0.4579439252336449 | 22 | 0.5454545454545454 | 0.0875106202209005 | 0.4579209725381599 | 0.0875106202209005 |
| JLOS/referral collaboration | m6_q04_3 | Referral reason: sexual violence or SGBV | 107 | 0.4953271028037383 | 22 | 0.4090909090909091 | -0.0862361937128292 | 0.4648328112120125 | 0.0862361937128292 |
| JLOS/referral collaboration | prior_formal_coordination | Prior coordination with police/courts/probation/child protection/justice actors | 107 | 0.8691588785046729 | 22 | 0.9545454545454546 | 0.0853865760407817 | 0.2586315745988855 | 0.0853865760407817 |
| JLOS/referral collaboration | idx_referral_practice | Referral practice | 107 | 0.6150135368665802 | 22 | 0.6982999606565996 | 0.0832864237900194 | 0.0204001894542453 | 0.0832864237900194 |
| JLOS/referral collaboration | idx_referral_practice | Referral practice | 107 | 0.6150135368665802 | 22 | 0.6982999606565996 | 0.0832864237900194 | 0.0204001894542453 | 0.0832864237900194 |
| JLOS/referral collaboration | m6_q04_2 | Referral reason: serious violence/threat to life | 107 | 0.6915887850467289 | 22 | 0.7727272727272727 | 0.0811384876805438 | 0.4509731936578201 | 0.0811384876805438 |
| JLOS/referral collaboration | m6_q04_4 | Referral reason: child protection concern | 107 | 0.205607476635514 | 22 | 0.2727272727272727 | 0.0671197960917587 | 0.4905736910328591 | 0.0671197960917587 |
| JLOS/referral collaboration | referral_explain_conf_score | Confidence explaining referrals to community members | 107 | 0.5934579439252337 | 22 | 0.6590909090909091 | 0.0656329651656754 | 0.199748618179883 | 0.0656329651656754 |
| JLOS/referral collaboration | referral_path_conf_score | Confidence knowing where to refer cases | 107 | 0.6004672897196262 | 22 | 0.6477272727272727 | 0.0472599830076466 | 0.3366567392875528 | 0.0472599830076466 |
| JLOS/referral collaboration | referral_frequency_score | Referral practice score: frequency/regularity | 99 | 0.7727272727272727 | 22 | 0.7272727272727273 | -0.0454545454545454 | 0.4904746619914659 | 0.0454545454545454 |
| JLOS/referral collaboration | verified_referral_record_score | Enumerator-verified referred cases are recorded, 0-1 | 58 | 0.6982758620689655 | 16 | 0.65625 | -0.0420258620689655 | 0.7201656631035783 | 0.0420258620689655 |
| JLOS/referral collaboration | court_coordination_score | Coordination score with court/formal justice actors | 101 | 0.7153465346534653 | 22 | 0.75 | 0.0346534653465347 | 0.6280833382665583 | 0.0346534653465347 |
| JLOS/referral collaboration | police_coordination_score | Coordination score with police | 104 | 0.75 | 22 | 0.7840909090909091 | 0.0340909090909091 | 0.6036936831380635 | 0.0340909090909091 |
| Legitimacy and reintegration | comm_accepts_ex_prisoner | Respondent says community members are usually willing to accept them | 107 | 0.3644859813084112 | 22 | 0.1363636363636364 | -0.2281223449447748 | 0.0378052889334808 | 0.2281223449447748 |
| Legitimacy and reintegration | low_bypass_score | Inverse bypass score: higher means less perceived bypass, 0-1 | 100 | 0.53 | 22 | 0.375 | -0.155 | 0.0261597044412356 | 0.155 |
| Legitimacy and reintegration | conf_fair_respect_score | Confidence LCC handles petty disputes fairly/respectfully, 0-1 | 107 | 0.6098130841121495 | 22 | 0.7272727272727273 | 0.1174596431605778 | 0.0174434456509321 | 0.1174596431605778 |
| Legitimacy and reintegration | bypass_due_bias | Bypass reason: perceived LCC bias/favoritism | 107 | 0.102803738317757 | 22 | 0 | -0.102803738317757 | 0.1176618280210644 | 0.102803738317757 |
| Legitimacy and reintegration | recent_reintegration_issue | LCC handled reintegration-related dispute/tension/concern in past 6 months | 107 | 0.411214953271028 | 22 | 0.5 | 0.088785046728972 | 0.4470709895067105 | 0.088785046728972 |
| Legitimacy and reintegration | reint_tension_conf_score | Confidence LCC can reduce reintegration-related community tensions, 0-1 | 107 | 0.6074766355140186 | 22 | 0.6931818181818182 | 0.0857051826677996 | 0.0981057570415603 | 0.0857051826677996 |
| Legitimacy and reintegration | perceived_lcc_fairness_score | Perceived community view of LCC fairness, 0-1 | 100 | 0.6675 | 22 | 0.75 | 0.0825 | 0.1533039547497636 | 0.0825 |
| Legitimacy and reintegration | conf_trust_when_referring | Confidence maintaining trust while referring serious/ineligible cases, 0-1 | 107 | 0.6121495327102804 | 22 | 0.6818181818181818 | 0.0696686491079014 | 0.1283746674497179 | 0.0696686491079014 |
| Legitimacy and reintegration | reint_referral_conf_score | Confidence knowing where to refer formerly incarcerated persons for support, 0-1 | 107 | 0.5957943925233645 | 22 | 0.6590909090909091 | 0.0632965165675445 | 0.2167003021735994 | 0.0632965165675445 |
| Legitimacy and reintegration | fair_chance_reintegration_score | Agreement that formerly incarcerated persons deserve fair chance, 0-1 | 107 | 0.7593457943925234 | 22 | 0.8181818181818182 | 0.0588360237892949 | 0.1052309257407606 | 0.0588360237892949 |
| Legitimacy and reintegration | reintegration_importance_score | Importance of community leaders supporting reintegration, 0-1 | 107 | 0.6355140186915887 | 22 | 0.6931818181818182 | 0.0576677994902295 | 0.2602436042961268 | 0.0576677994902295 |
| Legitimacy and reintegration | bypass_due_enforcement | Bypass reason: LCC cannot enforce agreements/decisions | 107 | 0.0560747663551402 | 22 | 0 | -0.0560747663551402 | 0.2587993680161048 | 0.0560747663551402 |
| Legitimacy and reintegration | idx_reintegration_norms | Reintegration norms | 107 | 0.6275665548360236 | 22 | 0.652246893806891 | 0.0246803389708674 | 0.3463975606928494 | 0.0246803389708674 |
| Legitimacy and reintegration | idx_reintegration_norms | Reintegration norms | 107 | 0.6275665548360236 | 22 | 0.652246893806891 | 0.0246803389708674 | 0.3463975606928494 | 0.0246803389708674 |
| Legitimacy and reintegration | perc_willing_use_lcc_score | Perceived willingness of community to use LCC for eligible petty disputes, 0-1 | 100 | 0.68 | 22 | 0.7045454545454546 | 0.0245454545454545 | 0.654183621133944 | 0.0245454545454545 |
| Legitimacy and reintegration | bypass_due_distrust | Bypass reason: community does not trust LCC | 107 | 0.1121495327102804 | 22 | 0.0909090909090909 | -0.0212404418011895 | 0.7726452068030253 | 0.0212404418011895 |
| Legitimacy and reintegration | low_reoffending_stigma_score | Reverse-coded belief that most formerly incarcerated persons reoffend, 0-1 | 107 | 0.4322429906542056 | 21 | 0.4166666666666667 | -0.0155763239875389 | 0.7893596438034312 | 0.0155763239875389 |
| Legitimacy and reintegration | idx_perceived_legitimacy | Perceived legitimacy | 107 | 0.6138629289430992 | 22 | 0.6174242401664908 | 0.0035613112233915 | 0.9175674507623452 | 0.0035613112233915 |
| Legitimacy and reintegration | idx_perceived_legitimacy | Perceived legitimacy | 107 | 0.6138629289430992 | 22 | 0.6174242401664908 | 0.0035613112233915 | 0.9175674507623452 | 0.0035613112233915 |
| Mentor-readiness flags | high_operational_capacity | Operational capacity index >= 0.75 | 107 | 0.2803738317757009 | 22 | 0.7727272727272727 | 0.4923534409515718 | 6.71751743001e-06 | 0.4923534409515718 |
| Mentor-readiness flags | high_case_handling_quality | Case-handling quality index >= 0.75 | 107 | 0.2710280373831775 | 22 | 0.5909090909090909 | 0.3198810535259135 | 0.0033127957577135 | 0.3198810535259135 |
| Mentor-readiness flags | high_mentor_readiness_proxy | Baseline mentor-readiness proxy index >= 0.75 | 107 | 0.0934579439252336 | 22 | 0.3636363636363636 | 0.27017841971113 | 0.0007438792460276 | 0.27017841971113 |
| Mentor-readiness flags | high_legitimacy_norms | Legitimacy and reintegration norms index >= 0.75 | 107 | 0.102803738317757 | 22 | 0.0909090909090909 | -0.0118946474086661 | 0.8672463601239218 | 0.0118946474086661 |
| Other/context | lcc_sittings_12m | Number of LCC sittings/hearings in the past 12 months | 107 | 3.728971962616822 | 22 | 8.272727272727273 | 4.543755310110452 | 0.0032087995765437 | 4.543755310110452 |
| Other/context | caseload_3m | Cases received by LCC in past 3 months | 105 | 1.828571428571429 | 22 | 2.727272727272727 | 0.8987012987012981 | 0.1272938078114775 | 0.8987012987012981 |
| Other/context | lc_experience_years | Years in LC1 position | 107 | 15.93457943925234 | 22 | 16.77272727272727 | 0.8381478334749293 | 0.7673791036489482 | 0.8381478334749293 |
| Other/context | prior_cdfu_fhri_training | Respondent reports prior CDFU/FHRI training before/at baseline | 102 | 0.1470588235294118 | 22 | 0.7272727272727273 | 0.5802139037433155 | 1.22917324844e-09 | 0.5802139037433155 |
| Other/context | prior_justice_training | Prior training on justice, mediation, mandate, records, or referrals | 107 | 0.6448598130841121 | 22 | 0.9545454545454546 | 0.3096856414613425 | 0.003731423567859 | 0.3096856414613425 |
| Other/context | pending_cases | Pending/unresolved LCC cases | 107 | 0.2149532710280374 | 22 | 0.4545454545454545 | 0.2395921835174171 | 0.082780082951527 | 0.2395921835174171 |
| Other/context | lcc_has_vacancy | LCC/LC committee has vacancies | 107 | 0.4485981308411215 | 22 | 0.6818181818181818 | 0.2332200509770603 | 0.046686892001546 | 0.2332200509770603 |
| Other/context | can_record_english | Can complete LCC records in English | 107 | 0.2990654205607476 | 22 | 0.1363636363636364 | -0.1627017841971112 | 0.1198706961851034 | 0.1627017841971112 |
| Other/context | completed_secondary_or_above | Completed secondary education or above | 107 | 0.1682242990654206 | 22 | 0.3181818181818182 | 0.1499575191163976 | 0.1067216196832127 | 0.1499575191163976 |
| Other/context | lcc_women_share | Share of current LCC/LC committee members who are women | 106 | 0.3673643442511367 | 22 | 0.4325150859241768 | 0.0651507416730401 | 0.0274857599509628 | 0.0651507416730401 |
| Other/context | any_serious_or_sensitive_case_3m | Any child, SGBV, or other serious/sensitive case in past 3 months | 107 | 0.0373831775700935 | 22 | 0.0909090909090909 | 0.0535259133389974 | 0.2811844144575819 | 0.0535259133389974 |
| Other/context | any_child_or_sgbv_case_3m | LCC received child-related or SGBV case in past 3 months | 107 | 0.0373831775700935 | 22 | 0.0909090909090909 | 0.0535259133389974 | 0.2811844144575819 | 0.0535259133389974 |
| Other/context | can_record_runyankore | Can complete LCC records in Runyankore/Runyakitara | 107 | 0.9813084112149533 | 22 | 1 | 0.0186915887850467 | 0.5218354420887018 | 0.0186915887850467 |
| Records and safeguards | n_record_challenges | Number of reported record-keeping challenges | 107 | 2.233644859813084 | 22 | 1.590909090909091 | -0.6427357689039928 | 0.0076847163505752 | 0.6427357689039928 |
| Records and safeguards | m7_q15_3 | Record challenge: need training on case records | 107 | 0.5514018691588785 | 22 | 0.0909090909090909 | -0.4604927782497876 | 5.6373222532e-05 | 0.4604927782497876 |
| Records and safeguards | case_register_score | Current case register/case book score, 0-1 | 107 | 0.6588785046728972 | 22 | 0.9318181818181818 | 0.2729396771452846 | 0.0009052052339881 | 0.2729396771452846 |
| Records and safeguards | m7_q15_1 | Record challenge: no registers/books/forms/paper | 107 | 0.719626168224299 | 22 | 0.4545454545454545 | -0.2650807136788446 | 0.0154867040954089 | 0.2650807136788446 |
| Records and safeguards | verified_record_usability_score | Enumerator-rated overall record usability score, 0-1 | 74 | 0.5675675675675675 | 19 | 0.7763157894736842 | 0.2087482219061166 | 0.0019650122911141 | 0.2087482219061166 |
| Records and safeguards | idx_record_quality | Record quality | 107 | 0.516443836319948 | 22 | 0.7144886363636364 | 0.1980448000436884 | 0.000358638623862 | 0.1980448000436884 |
| Records and safeguards | idx_record_quality | Record quality | 107 | 0.516443836319948 | 22 | 0.7144886363636364 | 0.1980448000436884 | 0.000358638623862 | 0.1980448000436884 |
| Records and safeguards | v06_sgbv_q3_correct | SGBV vignette: correct documentation/procedure | 107 | 0.5794392523364486 | 22 | 0.7272727272727273 | 0.1478334749362787 | 0.1994127707195842 | 0.1478334749362787 |
| Records and safeguards | v05_child_q2_correct | Child-related vignette: correct action/referral | 107 | 0.5887850467289719 | 22 | 0.7272727272727273 | 0.1384876805437554 | 0.2278568918056664 | 0.1384876805437554 |
| Records and safeguards | v05_child_q1_correct | Child-related vignette: correct classification | 107 | 0.5420560747663551 | 22 | 0.6363636363636364 | 0.0943075615972813 | 0.4211912442167095 | 0.0943075615972813 |
| Records and safeguards | idx_safeguard_classif_know | Index: serious/sensitive-case classification and referral knowledge, 0-1 | 107 | 0.5944314711144038 | 22 | 0.6549873846498403 | 0.0605559135354365 | 0.4664538268851146 | 0.0605559135354365 |
| Records and safeguards | idx_safeguards | Safeguards/referral knowledge | 107 | 0.7084306942246784 | 22 | 0.7593118819323453 | 0.0508811877076669 | 0.3341833406769956 | 0.0508811877076669 |
| Records and safeguards | idx_safeguards | Safeguards/referral knowledge | 107 | 0.7084306942246784 | 22 | 0.7593118819323453 | 0.0508811877076669 | 0.3341833406769956 | 0.0508811877076669 |
| Records and safeguards | v06_sgbv_q2_correct | SGBV vignette: correct action/referral | 107 | 0.5887850467289719 | 22 | 0.6363636363636364 | 0.0475785896346644 | 0.6814764770722015 | 0.0475785896346644 |
| Records and safeguards | vulnerable_need_sh | Respondent says vulnerable/sensitive cases require special handling | 107 | 0.822429906542056 | 22 | 0.8636363636363636 | 0.0412064570943076 | 0.6428934933886352 | 0.0412064570943076 |
| Records and safeguards | v06_sgbv_q1_correct | SGBV vignette: correct classification | 107 | 0.5981308411214953 | 22 | 0.6363636363636364 | 0.0382327952421411 | 0.7407481679595626 | 0.0382327952421411 |
| Records and safeguards | v05_child_q3_correct | Child-related vignette: correct documentation/procedure | 107 | 0.3457943925233645 | 22 | 0.3181818181818182 | -0.0276125743415463 | 0.8053582320488079 | 0.0276125743415463 |
| Records and safeguards | m7_q15_2 | Record challenge: no pens/basic stationery | 107 | 0.7570093457943925 | 22 | 0.7727272727272727 | 0.0157179269328802 | 0.8763305940213562 | 0.0157179269328802 |
| Records and safeguards | record_fields_score | Completeness of fields usually included in case records, 0-1 | 107 | 0.35202492211838 | 22 | 0.356060606060606 | 0.004035683942226 | 0.9454162618283082 | 0.004035683942226 |
## Sheet: ranked_abs_differences
| domain | variable | label | n_new | mean_new | n_prev | mean_prev | diff_prev_minus_new | p_value | abs_diff |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Other/context | lcc_sittings_12m | Number of LCC sittings/hearings in the past 12 months | 107 | 3.728971962616822 | 22 | 8.272727272727273 | 4.543755310110452 | 0.0032087995765437 | 4.543755310110452 |
| Other/context | caseload_3m | Cases received by LCC in past 3 months | 105 | 1.828571428571429 | 22 | 2.727272727272727 | 0.8987012987012981 | 0.1272938078114775 | 0.8987012987012981 |
| Other/context | lc_experience_years | Years in LC1 position | 107 | 15.93457943925234 | 22 | 16.77272727272727 | 0.8381478334749293 | 0.7673791036489482 | 0.8381478334749293 |
| Records and safeguards | n_record_challenges | Number of reported record-keeping challenges | 107 | 2.233644859813084 | 22 | 1.590909090909091 | -0.6427357689039928 | 0.0076847163505752 | 0.6427357689039928 |
| Other/context | prior_cdfu_fhri_training | Respondent reports prior CDFU/FHRI training before/at baseline | 102 | 0.1470588235294118 | 22 | 0.7272727272727273 | 0.5802139037433155 | 1.22917324844e-09 | 0.5802139037433155 |
| Mentor-readiness flags | high_operational_capacity | Operational capacity index >= 0.75 | 107 | 0.2803738317757009 | 22 | 0.7727272727272727 | 0.4923534409515718 | 6.71751743001e-06 | 0.4923534409515718 |
| Records and safeguards | m7_q15_3 | Record challenge: need training on case records | 107 | 0.5514018691588785 | 22 | 0.0909090909090909 | -0.4604927782497876 | 5.6373222532e-05 | 0.4604927782497876 |
| Mentor-readiness flags | high_case_handling_quality | Case-handling quality index >= 0.75 | 107 | 0.2710280373831775 | 22 | 0.5909090909090909 | 0.3198810535259135 | 0.0033127957577135 | 0.3198810535259135 |
| Other/context | prior_justice_training | Prior training on justice, mediation, mandate, records, or referrals | 107 | 0.6448598130841121 | 22 | 0.9545454545454546 | 0.3096856414613425 | 0.003731423567859 | 0.3096856414613425 |
| Records and safeguards | case_register_score | Current case register/case book score, 0-1 | 107 | 0.6588785046728972 | 22 | 0.9318181818181818 | 0.2729396771452846 | 0.0009052052339881 | 0.2729396771452846 |
| Mentor-readiness flags | high_mentor_readiness_proxy | Baseline mentor-readiness proxy index >= 0.75 | 107 | 0.0934579439252336 | 22 | 0.3636363636363636 | 0.27017841971113 | 0.0007438792460276 | 0.27017841971113 |
| Records and safeguards | m7_q15_1 | Record challenge: no registers/books/forms/paper | 107 | 0.719626168224299 | 22 | 0.4545454545454545 | -0.2650807136788446 | 0.0154867040954089 | 0.2650807136788446 |
| Other/context | pending_cases | Pending/unresolved LCC cases | 107 | 0.2149532710280374 | 22 | 0.4545454545454545 | 0.2395921835174171 | 0.082780082951527 | 0.2395921835174171 |
| Other/context | lcc_has_vacancy | LCC/LC committee has vacancies | 107 | 0.4485981308411215 | 22 | 0.6818181818181818 | 0.2332200509770603 | 0.046686892001546 | 0.2332200509770603 |
| Legitimacy and reintegration | comm_accepts_ex_prisoner | Respondent says community members are usually willing to accept them | 107 | 0.3644859813084112 | 22 | 0.1363636363636364 | -0.2281223449447748 | 0.0378052889334808 | 0.2281223449447748 |
| JLOS/referral collaboration | referral_documentation_score | Referral practice score: documentation | 103 | 0.4490291262135923 | 22 | 0.6704545454545454 | 0.2214254192409531 | 0.0006142120917886 | 0.2214254192409531 |
| Records and safeguards | verified_record_usability_score | Enumerator-rated overall record usability score, 0-1 | 74 | 0.5675675675675675 | 19 | 0.7763157894736842 | 0.2087482219061166 | 0.0019650122911141 | 0.2087482219061166 |
| Records and safeguards | idx_record_quality | Record quality | 107 | 0.516443836319948 | 22 | 0.7144886363636364 | 0.1980448000436884 | 0.000358638623862 | 0.1980448000436884 |
| Records and safeguards | idx_record_quality | Record quality | 107 | 0.516443836319948 | 22 | 0.7144886363636364 | 0.1980448000436884 | 0.000358638623862 | 0.1980448000436884 |
| JLOS/referral collaboration | referral_feedback_score | Referral practice score: receiving feedback | 101 | 0.4183168316831683 | 21 | 0.6071428571428571 | 0.1888260254596888 | 0.0049773312367137 | 0.1888260254596888 |
| Other/context | can_record_english | Can complete LCC records in English | 107 | 0.2990654205607476 | 22 | 0.1363636363636364 | -0.1627017841971112 | 0.1198706961851034 | 0.1627017841971112 |
| Legitimacy and reintegration | low_bypass_score | Inverse bypass score: higher means less perceived bypass, 0-1 | 100 | 0.53 | 22 | 0.375 | -0.155 | 0.0261597044412356 | 0.155 |
| Other/context | completed_secondary_or_above | Completed secondary education or above | 107 | 0.1682242990654206 | 22 | 0.3181818181818182 | 0.1499575191163976 | 0.1067216196832127 | 0.1499575191163976 |
| Records and safeguards | v06_sgbv_q3_correct | SGBV vignette: correct documentation/procedure | 107 | 0.5794392523364486 | 22 | 0.7272727272727273 | 0.1478334749362787 | 0.1994127707195842 | 0.1478334749362787 |
| Domain indices | idx_institutional_functioning | Institutional functioning | 107 | 0.7447374307106589 | 22 | 0.8915719742124731 | 0.1468345435018142 | 3.84664613136e-05 | 0.1468345435018142 |
| JLOS/referral collaboration | m6_q12_2 | Referral barrier: transport cost/lack of transport | 107 | 0.4018691588785047 | 22 | 0.5454545454545454 | 0.1435853865760407 | 0.2179972821693801 | 0.1435853865760407 |
| Records and safeguards | v05_child_q2_correct | Child-related vignette: correct action/referral | 107 | 0.5887850467289719 | 22 | 0.7272727272727273 | 0.1384876805437554 | 0.2278568918056664 | 0.1384876805437554 |
| Core composites | idx_lcc_operational_capacity | Operational capacity | 107 | 0.6707506739647588 | 22 | 0.8084242479367689 | 0.1376735739720101 | 6.5432615203e-06 | 0.1376735739720101 |
| Legitimacy and reintegration | conf_fair_respect_score | Confidence LCC handles petty disputes fairly/respectfully, 0-1 | 107 | 0.6098130841121495 | 22 | 0.7272727272727273 | 0.1174596431605778 | 0.0174434456509321 | 0.1174596431605778 |
| Domain indices | idx_adr_mediation_practice | ADR/mediation practice | 107 | 0.6543564132858659 | 22 | 0.7586776925758882 | 0.1043212792900223 | 0.0182521017216507 | 0.1043212792900223 |
| Legitimacy and reintegration | bypass_due_bias | Bypass reason: perceived LCC bias/favoritism | 107 | 0.102803738317757 | 22 | 0 | -0.102803738317757 | 0.1176618280210644 | 0.102803738317757 |
| JLOS/referral collaboration | m6_q04_1 | Referral reason: outside LCC mandate | 107 | 0.8598130841121495 | 22 | 0.9545454545454546 | 0.0947323704333051 | 0.2227149252465224 | 0.0947323704333051 |
| Records and safeguards | v05_child_q1_correct | Child-related vignette: correct classification | 107 | 0.5420560747663551 | 22 | 0.6363636363636364 | 0.0943075615972813 | 0.4211912442167095 | 0.0943075615972813 |
| JLOS/referral collaboration | verified_ref_dest_score | Enumerator-verified referral destination is recorded, 0-1 | 58 | 0.6724137931034483 | 17 | 0.7647058823529411 | 0.0922920892494928 | 0.4274183171427175 | 0.0922920892494928 |
| Legitimacy and reintegration | recent_reintegration_issue | LCC handled reintegration-related dispute/tension/concern in past 6 months | 107 | 0.411214953271028 | 22 | 0.5 | 0.088785046728972 | 0.4470709895067105 | 0.088785046728972 |
| JLOS/referral collaboration | m6_q12_1 | Referral barrier: authority too far away | 107 | 0.4579439252336449 | 22 | 0.5454545454545454 | 0.0875106202209005 | 0.4579209725381599 | 0.0875106202209005 |
| JLOS/referral collaboration | m6_q04_3 | Referral reason: sexual violence or SGBV | 107 | 0.4953271028037383 | 22 | 0.4090909090909091 | -0.0862361937128292 | 0.4648328112120125 | 0.0862361937128292 |
| Legitimacy and reintegration | reint_tension_conf_score | Confidence LCC can reduce reintegration-related community tensions, 0-1 | 107 | 0.6074766355140186 | 22 | 0.6931818181818182 | 0.0857051826677996 | 0.0981057570415603 | 0.0857051826677996 |
| JLOS/referral collaboration | prior_formal_coordination | Prior coordination with police/courts/probation/child protection/justice actors | 107 | 0.8691588785046729 | 22 | 0.9545454545454546 | 0.0853865760407817 | 0.2586315745988855 | 0.0853865760407817 |
| JLOS/referral collaboration | idx_referral_practice | Referral practice | 107 | 0.6150135368665802 | 22 | 0.6982999606565996 | 0.0832864237900194 | 0.0204001894542453 | 0.0832864237900194 |
| JLOS/referral collaboration | idx_referral_practice | Referral practice | 107 | 0.6150135368665802 | 22 | 0.6982999606565996 | 0.0832864237900194 | 0.0204001894542453 | 0.0832864237900194 |
| Legitimacy and reintegration | perceived_lcc_fairness_score | Perceived community view of LCC fairness, 0-1 | 100 | 0.6675 | 22 | 0.75 | 0.0825 | 0.1533039547497636 | 0.0825 |
| Domain indices | idx_respondent_capacity | Respondent capacity | 107 | 0.6040053416356862 | 22 | 0.6858225071972067 | 0.0818171655615205 | 0.0178731394141011 | 0.0818171655615205 |
| JLOS/referral collaboration | m6_q04_2 | Referral reason: serious violence/threat to life | 107 | 0.6915887850467289 | 22 | 0.7727272727272727 | 0.0811384876805438 | 0.4509731936578201 | 0.0811384876805438 |
| Core composites | idx_p1_base_mentor_ready_proxy | Baseline mentor-readiness proxy | 107 | 0.6423631625197758 | 22 | 0.7175788391720165 | 0.0752156766522407 | 0.0004310937243595 | 0.0752156766522407 |
| Legitimacy and reintegration | conf_trust_when_referring | Confidence maintaining trust while referring serious/ineligible cases, 0-1 | 107 | 0.6121495327102804 | 22 | 0.6818181818181818 | 0.0696686491079014 | 0.1283746674497179 | 0.0696686491079014 |
| Domain indices | idx_committee_functioning | Committee functioning | 107 | 0.7510707528791695 | 22 | 0.8192121169783853 | 0.0681413640992158 | 0.0227700668466222 | 0.0681413640992158 |
| Core composites | idx_lcc_case_handling_quality | Case-handling quality | 107 | 0.6739818985774139 | 22 | 0.7412330494685606 | 0.0672511508911467 | 0.0193804280094534 | 0.0672511508911467 |
| JLOS/referral collaboration | m6_q04_4 | Referral reason: child protection concern | 107 | 0.205607476635514 | 22 | 0.2727272727272727 | 0.0671197960917587 | 0.4905736910328591 | 0.0671197960917587 |
| JLOS/referral collaboration | referral_explain_conf_score | Confidence explaining referrals to community members | 107 | 0.5934579439252337 | 22 | 0.6590909090909091 | 0.0656329651656754 | 0.199748618179883 | 0.0656329651656754 |
| Other/context | lcc_women_share | Share of current LCC/LC committee members who are women | 106 | 0.3673643442511367 | 22 | 0.4325150859241768 | 0.0651507416730401 | 0.0274857599509628 | 0.0651507416730401 |
| Legitimacy and reintegration | reint_referral_conf_score | Confidence knowing where to refer formerly incarcerated persons for support, 0-1 | 107 | 0.5957943925233645 | 22 | 0.6590909090909091 | 0.0632965165675445 | 0.2167003021735994 | 0.0632965165675445 |
| Records and safeguards | idx_safeguard_classif_know | Index: serious/sensitive-case classification and referral knowledge, 0-1 | 107 | 0.5944314711144038 | 22 | 0.6549873846498403 | 0.0605559135354365 | 0.4664538268851146 | 0.0605559135354365 |
| Legitimacy and reintegration | fair_chance_reintegration_score | Agreement that formerly incarcerated persons deserve fair chance, 0-1 | 107 | 0.7593457943925234 | 22 | 0.8181818181818182 | 0.0588360237892949 | 0.1052309257407606 | 0.0588360237892949 |
| Legitimacy and reintegration | reintegration_importance_score | Importance of community leaders supporting reintegration, 0-1 | 107 | 0.6355140186915887 | 22 | 0.6931818181818182 | 0.0576677994902295 | 0.2602436042961268 | 0.0576677994902295 |
| Legitimacy and reintegration | bypass_due_enforcement | Bypass reason: LCC cannot enforce agreements/decisions | 107 | 0.0560747663551402 | 22 | 0 | -0.0560747663551402 | 0.2587993680161048 | 0.0560747663551402 |
| Other/context | any_child_or_sgbv_case_3m | LCC received child-related or SGBV case in past 3 months | 107 | 0.0373831775700935 | 22 | 0.0909090909090909 | 0.0535259133389974 | 0.2811844144575819 | 0.0535259133389974 |
| Other/context | any_serious_or_sensitive_case_3m | Any child, SGBV, or other serious/sensitive case in past 3 months | 107 | 0.0373831775700935 | 22 | 0.0909090909090909 | 0.0535259133389974 | 0.2811844144575819 | 0.0535259133389974 |
| Records and safeguards | idx_safeguards | Safeguards/referral knowledge | 107 | 0.7084306942246784 | 22 | 0.7593118819323453 | 0.0508811877076669 | 0.3341833406769956 | 0.0508811877076669 |
| Records and safeguards | idx_safeguards | Safeguards/referral knowledge | 107 | 0.7084306942246784 | 22 | 0.7593118819323453 | 0.0508811877076669 | 0.3341833406769956 | 0.0508811877076669 |
| Records and safeguards | v06_sgbv_q2_correct | SGBV vignette: correct action/referral | 107 | 0.5887850467289719 | 22 | 0.6363636363636364 | 0.0475785896346644 | 0.6814764770722015 | 0.0475785896346644 |
| JLOS/referral collaboration | referral_path_conf_score | Confidence knowing where to refer cases | 107 | 0.6004672897196262 | 22 | 0.6477272727272727 | 0.0472599830076466 | 0.3366567392875528 | 0.0472599830076466 |
| JLOS/referral collaboration | referral_frequency_score | Referral practice score: frequency/regularity | 99 | 0.7727272727272727 | 22 | 0.7272727272727273 | -0.0454545454545454 | 0.4904746619914659 | 0.0454545454545454 |
| JLOS/referral collaboration | verified_referral_record_score | Enumerator-verified referred cases are recorded, 0-1 | 58 | 0.6982758620689655 | 16 | 0.65625 | -0.0420258620689655 | 0.7201656631035783 | 0.0420258620689655 |
| Records and safeguards | vulnerable_need_sh | Respondent says vulnerable/sensitive cases require special handling | 107 | 0.822429906542056 | 22 | 0.8636363636363636 | 0.0412064570943076 | 0.6428934933886352 | 0.0412064570943076 |
| Records and safeguards | v06_sgbv_q1_correct | SGBV vignette: correct classification | 107 | 0.5981308411214953 | 22 | 0.6363636363636364 | 0.0382327952421411 | 0.7407481679595626 | 0.0382327952421411 |
| JLOS/referral collaboration | court_coordination_score | Coordination score with court/formal justice actors | 101 | 0.7153465346534653 | 22 | 0.75 | 0.0346534653465347 | 0.6280833382665583 | 0.0346534653465347 |
| JLOS/referral collaboration | police_coordination_score | Coordination score with police | 104 | 0.75 | 22 | 0.7840909090909091 | 0.0340909090909091 | 0.6036936831380635 | 0.0340909090909091 |
| Domain indices | idx_legal_classif_knowledge | Legal/classification knowledge | 107 | 0.7181269481917408 | 22 | 0.7486426803198728 | 0.030515732128132 | 0.3243985676897799 | 0.030515732128132 |
| Records and safeguards | v05_child_q3_correct | Child-related vignette: correct documentation/procedure | 107 | 0.3457943925233645 | 22 | 0.3181818181818182 | -0.0276125743415463 | 0.8053582320488079 | 0.0276125743415463 |
| Legitimacy and reintegration | idx_reintegration_norms | Reintegration norms | 107 | 0.6275665548360236 | 22 | 0.652246893806891 | 0.0246803389708674 | 0.3463975606928494 | 0.0246803389708674 |
| Legitimacy and reintegration | idx_reintegration_norms | Reintegration norms | 107 | 0.6275665548360236 | 22 | 0.652246893806891 | 0.0246803389708674 | 0.3463975606928494 | 0.0246803389708674 |
| Legitimacy and reintegration | perc_willing_use_lcc_score | Perceived willingness of community to use LCC for eligible petty disputes, 0-1 | 100 | 0.68 | 22 | 0.7045454545454546 | 0.0245454545454545 | 0.654183621133944 | 0.0245454545454545 |
| Legitimacy and reintegration | bypass_due_distrust | Bypass reason: community does not trust LCC | 107 | 0.1121495327102804 | 22 | 0.0909090909090909 | -0.0212404418011895 | 0.7726452068030253 | 0.0212404418011895 |
| Other/context | can_record_runyankore | Can complete LCC records in Runyankore/Runyakitara | 107 | 0.9813084112149533 | 22 | 1 | 0.0186915887850467 | 0.5218354420887018 | 0.0186915887850467 |
| Records and safeguards | m7_q15_2 | Record challenge: no pens/basic stationery | 107 | 0.7570093457943925 | 22 | 0.7727272727272727 | 0.0157179269328802 | 0.8763305940213562 | 0.0157179269328802 |
| Legitimacy and reintegration | low_reoffending_stigma_score | Reverse-coded belief that most formerly incarcerated persons reoffend, 0-1 | 107 | 0.4322429906542056 | 21 | 0.4166666666666667 | -0.0155763239875389 | 0.7893596438034312 | 0.0155763239875389 |
| Core composites | idx_lcc_legitimacy_and_norms | Legitimacy and reintegration | 107 | 0.6207147421680879 | 22 | 0.6348355656320398 | 0.0141208234639519 | 0.5949698044801064 | 0.0141208234639519 |
| Mentor-readiness flags | high_legitimacy_norms | Legitimacy and reintegration norms index >= 0.75 | 107 | 0.102803738317757 | 22 | 0.0909090909090909 | -0.0118946474086661 | 0.8672463601239218 | 0.0118946474086661 |
| Records and safeguards | record_fields_score | Completeness of fields usually included in case records, 0-1 | 107 | 0.35202492211838 | 22 | 0.356060606060606 | 0.004035683942226 | 0.9454162618283082 | 0.004035683942226 |
| Legitimacy and reintegration | idx_perceived_legitimacy | Perceived legitimacy | 107 | 0.6138629289430992 | 22 | 0.6174242401664908 | 0.0035613112233915 | 0.9175674507623452 | 0.0035613112233915 |
| Legitimacy and reintegration | idx_perceived_legitimacy | Perceived legitimacy | 107 | 0.6138629289430992 | 22 | 0.6174242401664908 | 0.0035613112233915 | 0.9175674507623452 | 0.0035613112233915 |
## Sheet: report_core_comparisons
| domain | variable | label | n_new | mean_new | n_prev | mean_prev | diff_prev_minus_new | p_value | abs_diff |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Records and safeguards | n_record_challenges | Number of reported record-keeping challenges | 107 | 2.233644859813084 | 22 | 1.590909090909091 | -0.6427357689039928 | 0.0076847163505752 | 0.6427357689039928 |
| Mentor-readiness flags | high_operational_capacity | Operational capacity index >= 0.75 | 107 | 0.2803738317757009 | 22 | 0.7727272727272727 | 0.4923534409515718 | 6.71751743001e-06 | 0.4923534409515718 |
| Records and safeguards | m7_q15_3 | Record challenge: need training on case records | 107 | 0.5514018691588785 | 22 | 0.0909090909090909 | -0.4604927782497876 | 5.6373222532e-05 | 0.4604927782497876 |
| Mentor-readiness flags | high_case_handling_quality | Case-handling quality index >= 0.75 | 107 | 0.2710280373831775 | 22 | 0.5909090909090909 | 0.3198810535259135 | 0.0033127957577135 | 0.3198810535259135 |
| Records and safeguards | case_register_score | Current case register/case book score, 0-1 | 107 | 0.6588785046728972 | 22 | 0.9318181818181818 | 0.2729396771452846 | 0.0009052052339881 | 0.2729396771452846 |
| Mentor-readiness flags | high_mentor_readiness_proxy | Baseline mentor-readiness proxy index >= 0.75 | 107 | 0.0934579439252336 | 22 | 0.3636363636363636 | 0.27017841971113 | 0.0007438792460276 | 0.27017841971113 |
| Records and safeguards | m7_q15_1 | Record challenge: no registers/books/forms/paper | 107 | 0.719626168224299 | 22 | 0.4545454545454545 | -0.2650807136788446 | 0.0154867040954089 | 0.2650807136788446 |
| Legitimacy and reintegration | comm_accepts_ex_prisoner | Respondent says community members are usually willing to accept them | 107 | 0.3644859813084112 | 22 | 0.1363636363636364 | -0.2281223449447748 | 0.0378052889334808 | 0.2281223449447748 |
| JLOS/referral collaboration | referral_documentation_score | Referral practice score: documentation | 103 | 0.4490291262135923 | 22 | 0.6704545454545454 | 0.2214254192409531 | 0.0006142120917886 | 0.2214254192409531 |
| Records and safeguards | verified_record_usability_score | Enumerator-rated overall record usability score, 0-1 | 74 | 0.5675675675675675 | 19 | 0.7763157894736842 | 0.2087482219061166 | 0.0019650122911141 | 0.2087482219061166 |
| Records and safeguards | idx_record_quality | Record quality | 107 | 0.516443836319948 | 22 | 0.7144886363636364 | 0.1980448000436884 | 0.000358638623862 | 0.1980448000436884 |
| Records and safeguards | idx_record_quality | Record quality | 107 | 0.516443836319948 | 22 | 0.7144886363636364 | 0.1980448000436884 | 0.000358638623862 | 0.1980448000436884 |
| JLOS/referral collaboration | referral_feedback_score | Referral practice score: receiving feedback | 101 | 0.4183168316831683 | 21 | 0.6071428571428571 | 0.1888260254596888 | 0.0049773312367137 | 0.1888260254596888 |
| Legitimacy and reintegration | low_bypass_score | Inverse bypass score: higher means less perceived bypass, 0-1 | 100 | 0.53 | 22 | 0.375 | -0.155 | 0.0261597044412356 | 0.155 |
| Records and safeguards | v06_sgbv_q3_correct | SGBV vignette: correct documentation/procedure | 107 | 0.5794392523364486 | 22 | 0.7272727272727273 | 0.1478334749362787 | 0.1994127707195842 | 0.1478334749362787 |
| Domain indices | idx_institutional_functioning | Institutional functioning | 107 | 0.7447374307106589 | 22 | 0.8915719742124731 | 0.1468345435018142 | 3.84664613136e-05 | 0.1468345435018142 |
| JLOS/referral collaboration | m6_q12_2 | Referral barrier: transport cost/lack of transport | 107 | 0.4018691588785047 | 22 | 0.5454545454545454 | 0.1435853865760407 | 0.2179972821693801 | 0.1435853865760407 |
| Records and safeguards | v05_child_q2_correct | Child-related vignette: correct action/referral | 107 | 0.5887850467289719 | 22 | 0.7272727272727273 | 0.1384876805437554 | 0.2278568918056664 | 0.1384876805437554 |
| Core composites | idx_lcc_operational_capacity | Operational capacity | 107 | 0.6707506739647588 | 22 | 0.8084242479367689 | 0.1376735739720101 | 6.5432615203e-06 | 0.1376735739720101 |
| Legitimacy and reintegration | conf_fair_respect_score | Confidence LCC handles petty disputes fairly/respectfully, 0-1 | 107 | 0.6098130841121495 | 22 | 0.7272727272727273 | 0.1174596431605778 | 0.0174434456509321 | 0.1174596431605778 |
| Domain indices | idx_adr_mediation_practice | ADR/mediation practice | 107 | 0.6543564132858659 | 22 | 0.7586776925758882 | 0.1043212792900223 | 0.0182521017216507 | 0.1043212792900223 |
| Legitimacy and reintegration | bypass_due_bias | Bypass reason: perceived LCC bias/favoritism | 107 | 0.102803738317757 | 22 | 0 | -0.102803738317757 | 0.1176618280210644 | 0.102803738317757 |
| JLOS/referral collaboration | m6_q04_1 | Referral reason: outside LCC mandate | 107 | 0.8598130841121495 | 22 | 0.9545454545454546 | 0.0947323704333051 | 0.2227149252465224 | 0.0947323704333051 |
| Records and safeguards | v05_child_q1_correct | Child-related vignette: correct classification | 107 | 0.5420560747663551 | 22 | 0.6363636363636364 | 0.0943075615972813 | 0.4211912442167095 | 0.0943075615972813 |
| JLOS/referral collaboration | verified_ref_dest_score | Enumerator-verified referral destination is recorded, 0-1 | 58 | 0.6724137931034483 | 17 | 0.7647058823529411 | 0.0922920892494928 | 0.4274183171427175 | 0.0922920892494928 |
| Legitimacy and reintegration | recent_reintegration_issue | LCC handled reintegration-related dispute/tension/concern in past 6 months | 107 | 0.411214953271028 | 22 | 0.5 | 0.088785046728972 | 0.4470709895067105 | 0.088785046728972 |
| JLOS/referral collaboration | m6_q12_1 | Referral barrier: authority too far away | 107 | 0.4579439252336449 | 22 | 0.5454545454545454 | 0.0875106202209005 | 0.4579209725381599 | 0.0875106202209005 |
| JLOS/referral collaboration | m6_q04_3 | Referral reason: sexual violence or SGBV | 107 | 0.4953271028037383 | 22 | 0.4090909090909091 | -0.0862361937128292 | 0.4648328112120125 | 0.0862361937128292 |
| Legitimacy and reintegration | reint_tension_conf_score | Confidence LCC can reduce reintegration-related community tensions, 0-1 | 107 | 0.6074766355140186 | 22 | 0.6931818181818182 | 0.0857051826677996 | 0.0981057570415603 | 0.0857051826677996 |
| JLOS/referral collaboration | prior_formal_coordination | Prior coordination with police/courts/probation/child protection/justice actors | 107 | 0.8691588785046729 | 22 | 0.9545454545454546 | 0.0853865760407817 | 0.2586315745988855 | 0.0853865760407817 |
| JLOS/referral collaboration | idx_referral_practice | Referral practice | 107 | 0.6150135368665802 | 22 | 0.6982999606565996 | 0.0832864237900194 | 0.0204001894542453 | 0.0832864237900194 |
| JLOS/referral collaboration | idx_referral_practice | Referral practice | 107 | 0.6150135368665802 | 22 | 0.6982999606565996 | 0.0832864237900194 | 0.0204001894542453 | 0.0832864237900194 |
| Legitimacy and reintegration | perceived_lcc_fairness_score | Perceived community view of LCC fairness, 0-1 | 100 | 0.6675 | 22 | 0.75 | 0.0825 | 0.1533039547497636 | 0.0825 |
| Domain indices | idx_respondent_capacity | Respondent capacity | 107 | 0.6040053416356862 | 22 | 0.6858225071972067 | 0.0818171655615205 | 0.0178731394141011 | 0.0818171655615205 |
| JLOS/referral collaboration | m6_q04_2 | Referral reason: serious violence/threat to life | 107 | 0.6915887850467289 | 22 | 0.7727272727272727 | 0.0811384876805438 | 0.4509731936578201 | 0.0811384876805438 |
| Core composites | idx_p1_base_mentor_ready_proxy | Baseline mentor-readiness proxy | 107 | 0.6423631625197758 | 22 | 0.7175788391720165 | 0.0752156766522407 | 0.0004310937243595 | 0.0752156766522407 |
| Legitimacy and reintegration | conf_trust_when_referring | Confidence maintaining trust while referring serious/ineligible cases, 0-1 | 107 | 0.6121495327102804 | 22 | 0.6818181818181818 | 0.0696686491079014 | 0.1283746674497179 | 0.0696686491079014 |
| Domain indices | idx_committee_functioning | Committee functioning | 107 | 0.7510707528791695 | 22 | 0.8192121169783853 | 0.0681413640992158 | 0.0227700668466222 | 0.0681413640992158 |
| Core composites | idx_lcc_case_handling_quality | Case-handling quality | 107 | 0.6739818985774139 | 22 | 0.7412330494685606 | 0.0672511508911467 | 0.0193804280094534 | 0.0672511508911467 |
| JLOS/referral collaboration | m6_q04_4 | Referral reason: child protection concern | 107 | 0.205607476635514 | 22 | 0.2727272727272727 | 0.0671197960917587 | 0.4905736910328591 | 0.0671197960917587 |
| JLOS/referral collaboration | referral_explain_conf_score | Confidence explaining referrals to community members | 107 | 0.5934579439252337 | 22 | 0.6590909090909091 | 0.0656329651656754 | 0.199748618179883 | 0.0656329651656754 |
| Legitimacy and reintegration | reint_referral_conf_score | Confidence knowing where to refer formerly incarcerated persons for support, 0-1 | 107 | 0.5957943925233645 | 22 | 0.6590909090909091 | 0.0632965165675445 | 0.2167003021735994 | 0.0632965165675445 |
| Records and safeguards | idx_safeguard_classif_know | Index: serious/sensitive-case classification and referral knowledge, 0-1 | 107 | 0.5944314711144038 | 22 | 0.6549873846498403 | 0.0605559135354365 | 0.4664538268851146 | 0.0605559135354365 |
| Legitimacy and reintegration | fair_chance_reintegration_score | Agreement that formerly incarcerated persons deserve fair chance, 0-1 | 107 | 0.7593457943925234 | 22 | 0.8181818181818182 | 0.0588360237892949 | 0.1052309257407606 | 0.0588360237892949 |
| Legitimacy and reintegration | reintegration_importance_score | Importance of community leaders supporting reintegration, 0-1 | 107 | 0.6355140186915887 | 22 | 0.6931818181818182 | 0.0576677994902295 | 0.2602436042961268 | 0.0576677994902295 |
| Legitimacy and reintegration | bypass_due_enforcement | Bypass reason: LCC cannot enforce agreements/decisions | 107 | 0.0560747663551402 | 22 | 0 | -0.0560747663551402 | 0.2587993680161048 | 0.0560747663551402 |
| Records and safeguards | idx_safeguards | Safeguards/referral knowledge | 107 | 0.7084306942246784 | 22 | 0.7593118819323453 | 0.0508811877076669 | 0.3341833406769956 | 0.0508811877076669 |
| Records and safeguards | idx_safeguards | Safeguards/referral knowledge | 107 | 0.7084306942246784 | 22 | 0.7593118819323453 | 0.0508811877076669 | 0.3341833406769956 | 0.0508811877076669 |
| Records and safeguards | v06_sgbv_q2_correct | SGBV vignette: correct action/referral | 107 | 0.5887850467289719 | 22 | 0.6363636363636364 | 0.0475785896346644 | 0.6814764770722015 | 0.0475785896346644 |
| JLOS/referral collaboration | referral_path_conf_score | Confidence knowing where to refer cases | 107 | 0.6004672897196262 | 22 | 0.6477272727272727 | 0.0472599830076466 | 0.3366567392875528 | 0.0472599830076466 |
| JLOS/referral collaboration | referral_frequency_score | Referral practice score: frequency/regularity | 99 | 0.7727272727272727 | 22 | 0.7272727272727273 | -0.0454545454545454 | 0.4904746619914659 | 0.0454545454545454 |
| JLOS/referral collaboration | verified_referral_record_score | Enumerator-verified referred cases are recorded, 0-1 | 58 | 0.6982758620689655 | 16 | 0.65625 | -0.0420258620689655 | 0.7201656631035783 | 0.0420258620689655 |
| Records and safeguards | vulnerable_need_sh | Respondent says vulnerable/sensitive cases require special handling | 107 | 0.822429906542056 | 22 | 0.8636363636363636 | 0.0412064570943076 | 0.6428934933886352 | 0.0412064570943076 |
| Records and safeguards | v06_sgbv_q1_correct | SGBV vignette: correct classification | 107 | 0.5981308411214953 | 22 | 0.6363636363636364 | 0.0382327952421411 | 0.7407481679595626 | 0.0382327952421411 |
| JLOS/referral collaboration | court_coordination_score | Coordination score with court/formal justice actors | 101 | 0.7153465346534653 | 22 | 0.75 | 0.0346534653465347 | 0.6280833382665583 | 0.0346534653465347 |
| JLOS/referral collaboration | police_coordination_score | Coordination score with police | 104 | 0.75 | 22 | 0.7840909090909091 | 0.0340909090909091 | 0.6036936831380635 | 0.0340909090909091 |
| Domain indices | idx_legal_classif_knowledge | Legal/classification knowledge | 107 | 0.7181269481917408 | 22 | 0.7486426803198728 | 0.030515732128132 | 0.3243985676897799 | 0.030515732128132 |
| Records and safeguards | v05_child_q3_correct | Child-related vignette: correct documentation/procedure | 107 | 0.3457943925233645 | 22 | 0.3181818181818182 | -0.0276125743415463 | 0.8053582320488079 | 0.0276125743415463 |
| Legitimacy and reintegration | idx_reintegration_norms | Reintegration norms | 107 | 0.6275665548360236 | 22 | 0.652246893806891 | 0.0246803389708674 | 0.3463975606928494 | 0.0246803389708674 |
| Legitimacy and reintegration | idx_reintegration_norms | Reintegration norms | 107 | 0.6275665548360236 | 22 | 0.652246893806891 | 0.0246803389708674 | 0.3463975606928494 | 0.0246803389708674 |
| Legitimacy and reintegration | perc_willing_use_lcc_score | Perceived willingness of community to use LCC for eligible petty disputes, 0-1 | 100 | 0.68 | 22 | 0.7045454545454546 | 0.0245454545454545 | 0.654183621133944 | 0.0245454545454545 |
| Legitimacy and reintegration | bypass_due_distrust | Bypass reason: community does not trust LCC | 107 | 0.1121495327102804 | 22 | 0.0909090909090909 | -0.0212404418011895 | 0.7726452068030253 | 0.0212404418011895 |
| Records and safeguards | m7_q15_2 | Record challenge: no pens/basic stationery | 107 | 0.7570093457943925 | 22 | 0.7727272727272727 | 0.0157179269328802 | 0.8763305940213562 | 0.0157179269328802 |
| Legitimacy and reintegration | low_reoffending_stigma_score | Reverse-coded belief that most formerly incarcerated persons reoffend, 0-1 | 107 | 0.4322429906542056 | 21 | 0.4166666666666667 | -0.0155763239875389 | 0.7893596438034312 | 0.0155763239875389 |
| Core composites | idx_lcc_legitimacy_and_norms | Legitimacy and reintegration | 107 | 0.6207147421680879 | 22 | 0.6348355656320398 | 0.0141208234639519 | 0.5949698044801064 | 0.0141208234639519 |
| Mentor-readiness flags | high_legitimacy_norms | Legitimacy and reintegration norms index >= 0.75 | 107 | 0.102803738317757 | 22 | 0.0909090909090909 | -0.0118946474086661 | 0.8672463601239218 | 0.0118946474086661 |
| Records and safeguards | record_fields_score | Completeness of fields usually included in case records, 0-1 | 107 | 0.35202492211838 | 22 | 0.356060606060606 | 0.004035683942226 | 0.9454162618283082 | 0.004035683942226 |
| Legitimacy and reintegration | idx_perceived_legitimacy | Perceived legitimacy | 107 | 0.6138629289430992 | 22 | 0.6174242401664908 | 0.0035613112233915 | 0.9175674507623452 | 0.0035613112233915 |
| Legitimacy and reintegration | idx_perceived_legitimacy | Perceived legitimacy | 107 | 0.6138629289430992 | 22 | 0.6174242401664908 | 0.0035613112233915 | 0.9175674507623452 | 0.0035613112233915 |
## Sheet: fig32_core_composites
| p1_admin_previously_contacted | origin_group | n | idx_lcc_operational_capacity | idx_lcc_case_handling_quality | idx_lcc_legitimacy_and_norms | idx_p1_base_mentor_ready_proxy |
| --- | --- | --- | --- | --- | --- | --- |
| New / randomly selected | New / randomly selected | 107 | 0.6707506775856018 | 0.6739819049835205 | 0.6207147240638733 | 0.6423631906509399 |
| Previously contacted | Previously contacted | 22 | 0.8084242343902588 | 0.7412330508232117 | 0.6348355412483215 | 0.7175788283348083 |
## Sheet: fig33_jlos_collaboration
| p1_admin_previously_contacted | origin_group | n | prior_formal_coordination | police_coordination_score | court_coordination_score | referral_path_conf_score | referral_explain_conf_score | referral_feedback_score | verified_referral_record_score |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| New / randomly selected | New / randomly selected | 107 | 0.8691588640213013 | 0.75 | 0.7153465346534653 | 0.6004672897196262 | 0.5934579439252337 | 0.4183168316831683 | 0.6982758620689655 |
| Previously contacted | Previously contacted | 22 | 0.9545454382896423 | 0.7840909090909091 | 0.75 | 0.6477272727272727 | 0.6590909090909091 | 0.6071428571428571 | 0.65625 |
## Sheet: fig34_priority_gaps
| p1_admin_previously_contacted | origin_group | n | gap_perceived_legitimacy | gap_record_quality | gap_reintegration_norms | gap_referral_practice | gap_safeguards | gap_case_handling |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| New / randomly selected | New / randomly selected | 107 | 0.38613707105690076 | 0.4835561636800521 | 0.37243344516397636 | 0.3849864631334198 | 0.29156930577532153 | 0.3260181014225862 |
| Previously contacted | Previously contacted | 22 | 0.3825757598335093 | 0.28551136363636365 | 0.347753106193109 | 0.30170003934340045 | 0.2406881180676547 | 0.25876695053143933 |
## Sheet: fig35_high_readiness_flags
| p1_admin_previously_contacted | origin_group | n | high_operational_capacity | high_case_handling_quality | high_legitimacy_norms | high_mentor_readiness_proxy |
| --- | --- | --- | --- | --- | --- | --- |
| New / randomly selected | New / randomly selected | 107 | 0.28037384152412415 | 0.2710280418395996 | 0.10280373692512512 | 0.09345794469118118 |
| Previously contacted | Previously contacted | 22 | 0.7727272510528564 | 0.5909090638160706 | 0.09090909361839294 | 0.3636363744735718 |
## Sheet: district_adjusted_diagnostics
| outcome | label | n | mean_new | mean_prev | raw_diff_prev_minus_new | coef_prev_contacted | se | ci_low | ci_high | p_value | model_note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| idx_lcc_operational_capacity | Operational capacity | 129 | 0.6707506739647588 | 0.8084242479367689 | 0.13767357170581818 | 0.1375324931657261 | 0.0227129683476031 | 0.09258071333169937 | 0.18248426914215088 | 1.52067985414e-08 | Cross-sectional baseline associations; not causal estimates. |
| idx_lcc_case_handling_quality | Case-handling quality | 129 | 0.6739818985774139 | 0.7412330494685606 | 0.06725115329027176 | 0.0690693410919393 | 0.0316788316743578 | 0.006373001728206873 | 0.131765678524971 | 0.0311082913217 | Cross-sectional baseline associations; not causal estimates. |
| idx_lcc_legitimacy_and_norms | Legitimacy and reintegration | 129 | 0.6207147421680879 | 0.6348355656320398 | 0.014120823703706264 | 0.0154940471802294 | 0.0243511321798433 | -0.032699864357709885 | 0.06368795782327652 | 0.5257597401323003 | Cross-sectional baseline associations; not causal estimates. |
| idx_p1_base_mentor_ready_proxy | Baseline mentor-readiness proxy | 129 | 0.6423631625197758 | 0.7175788391720165 | 0.07521567493677139 | 0.0761140789072277 | 0.0191986865277901 | 0.03811749443411827 | 0.11411066353321075 | 0.0001229645500303 | Cross-sectional baseline associations; not causal estimates. |
| idx_record_quality | Record quality | 129 | 0.516443836319948 | 0.7144886363636364 | 0.1980448067188263 | 0.1978893817351801 | 0.047537306181071 | 0.10380715131759644 | 0.2919716238975525 | 5.80740415152e-05 | Cross-sectional baseline associations; not causal estimates. |
| idx_referral_practice | Referral practice | 129 | 0.6150135368665802 | 0.6982999606565996 | 0.08328642696142197 | 0.0870869214612323 | 0.0363690221457118 | 0.015108113177120686 | 0.15906572341918945 | 0.0181264443482158 | Cross-sectional baseline associations; not causal estimates. |
| idx_safeguards | Safeguards/referral knowledge | 129 | 0.7084306942246784 | 0.7593118819323453 | 0.05088118836283684 | 0.046035436231474 | 0.0499291337564582 | -0.05278051644563675 | 0.14485138654708862 | 0.3582966544890631 | Cross-sectional baseline associations; not causal estimates. |