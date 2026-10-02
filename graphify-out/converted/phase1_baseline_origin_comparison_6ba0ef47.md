<!-- converted from phase1_baseline_origin_comparison.xlsx -->

## Sheet: README
| Advancing Justice Uganda - Phase 1 baseline origin comparison |  |
| --- | --- |
| Purpose | Descriptive comparison of observed selected-list LCs and previously contacted LCs; other amended LCs excluded. |
| Grouping variable | p1_admin_previously_contacted |
| Definition | 1 if admin list marks village as Last_CDFU_phase == 1 or Inherited_FHRI == 1; 0 otherwise. |
| Interpretation | Descriptive baseline association, not a causal effect of previous contact. |
| Recommended use | Use as implementation diagnostics in the Phase 1 Final Baseline Report. |
## Sheet: sample_by_origin
| p1_admin_previously_contacted | origin_group | n | share | total |
| --- | --- | --- | --- | --- |
| Selected-list (observed) | Selected-list (observed) | 93 | 0.8086956739425659 | 115 |
| Previously contacted | Previously contacted | 22 | 0.19130434095859528 | 115 |
## Sheet: sample_by_district_origin
| canonical_district | p1_admin_previously_contacted | origin_group | n | district_total | district_share |
| --- | --- | --- | --- | --- | --- |
| Bushenyi | Selected-list (observed) | Selected-list (observed) | 41 | 48 | 0.8541666865348816 |
| Bushenyi | Previously contacted | Previously contacted | 7 | 48 | 0.1458333283662796 |
| Rubirizi | Selected-list (observed) | Selected-list (observed) | 28 | 34 | 0.8235294222831726 |
| Rubirizi | Previously contacted | Previously contacted | 6 | 34 | 0.1764705926179886 |
| Sheema | Selected-list (observed) | Selected-list (observed) | 24 | 33 | 0.7272727489471436 |
| Sheema | Previously contacted | Previously contacted | 9 | 33 | 0.27272728085517883 |
## Sheet: final_diff_table
| domain | variable | label | n_selected | mean_selected | n_prev | mean_prev | diff_prev_minus_selected | p_value | abs_diff |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Core composites | idx_lcc_operational_capacity | Operational capacity | 93 | 0.6782861906354145 | 22 | 0.8084242479367689 | 0.1301380573013544 | 1.9104368202e-05 | 0.1301380573013544 |
| Core composites | idx_p1_base_mentor_ready_proxy | Baseline mentor-readiness proxy | 93 | 0.6427177325371773 | 22 | 0.7175788391720165 | 0.0748611066348391 | 0.0005434265669958 | 0.0748611066348391 |
| Core composites | idx_lcc_case_handling_quality | Case-handling quality | 93 | 0.6691372814357922 | 22 | 0.7412330494685606 | 0.0720957680327684 | 0.0157690771133387 | 0.0720957680327684 |
| Core composites | idx_lcc_legitimacy_and_norms | Legitimacy and reintegration | 93 | 0.6117475141761124 | 22 | 0.6348355656320398 | 0.0230880514559274 | 0.3929928382234932 | 0.0230880514559274 |
| Domain indices | idx_institutional_functioning | Institutional functioning | 93 | 0.762384795693941 | 22 | 0.8915719742124731 | 0.1291871785185321 | 0.000240867501065 | 0.1291871785185321 |
| Domain indices | idx_adr_mediation_practice | ADR/mediation practice | 93 | 0.6548655905550526 | 22 | 0.7586776925758882 | 0.1038121020208357 | 0.0220147262289193 | 0.1038121020208357 |
| Domain indices | idx_respondent_capacity | Respondent capacity | 93 | 0.611699949509354 | 22 | 0.6858225071972067 | 0.0741225576878527 | 0.0299591873319348 | 0.0741225576878527 |
| Domain indices | idx_committee_functioning | Committee functioning | 93 | 0.7479093616367668 | 22 | 0.8192121169783853 | 0.0713027553416185 | 0.0195396725177469 | 0.0713027553416185 |
| Domain indices | idx_legal_classif_knowledge | Legal/classification knowledge | 93 | 0.7068772424933731 | 22 | 0.7486426803198728 | 0.0417654378264997 | 0.1971978296089668 | 0.0417654378264997 |
| JLOS/referral collaboration | referral_documentation_score | Referral practice score: documentation | 90 | 0.4611111111111111 | 22 | 0.6704545454545454 | 0.2093434343434343 | 0.0018960041074505 | 0.2093434343434343 |
| JLOS/referral collaboration | referral_feedback_score | Referral practice score: receiving feedback | 90 | 0.4222222222222222 | 21 | 0.6071428571428571 | 0.1849206349206349 | 0.0082921406870097 | 0.1849206349206349 |
| JLOS/referral collaboration | m6_q04_1 | Referral reason: outside LCC mandate | 93 | 0.8387096774193549 | 22 | 0.9545454545454546 | 0.1158357771260997 | 0.1607752812799218 | 0.1158357771260997 |
| JLOS/referral collaboration | m6_q12_2 | Referral barrier: transport cost/lack of transport | 93 | 0.4301075268817204 | 22 | 0.5454545454545454 | 0.115347018572825 | 0.3326032191300492 | 0.115347018572825 |
| JLOS/referral collaboration | m6_q04_2 | Referral reason: serious violence/threat to life | 93 | 0.6881720430107527 | 22 | 0.7727272727272727 | 0.08455522971652 | 0.4389021554774559 | 0.08455522971652 |
| JLOS/referral collaboration | idx_referral_practice | Referral practice | 93 | 0.615209507205153 | 22 | 0.6982999606565996 | 0.0830904534514466 | 0.0237050435060385 | 0.0830904534514466 |
| JLOS/referral collaboration | verified_ref_dest_score | Enumerator-verified referral destination is recorded, 0-1 | 56 | 0.6875 | 17 | 0.7647058823529411 | 0.0772058823529411 | 0.4969888236901042 | 0.0772058823529411 |
| JLOS/referral collaboration | m6_q04_3 | Referral reason: sexual violence or SGBV | 93 | 0.4838709677419355 | 22 | 0.4090909090909091 | -0.0747800586510264 | 0.5315429090118823 | 0.0747800586510264 |
| JLOS/referral collaboration | referral_explain_conf_score | Confidence explaining referrals to community members | 93 | 0.5860215053763441 | 22 | 0.6590909090909091 | 0.0730694037145649 | 0.1653408835052607 | 0.0730694037145649 |
| JLOS/referral collaboration | prior_formal_coordination | Prior coordination with police/courts/probation/child protection/justice actors | 93 | 0.8817204301075269 | 22 | 0.9545454545454546 | 0.0728250244379277 | 0.3192493927681256 | 0.0728250244379277 |
| JLOS/referral collaboration | verified_referral_record_score | Enumerator-verified referred cases are recorded, 0-1 | 55 | 0.7181818181818181 | 16 | 0.65625 | -0.0619318181818181 | 0.5988066848418752 | 0.0619318181818181 |
| JLOS/referral collaboration | m6_q04_4 | Referral reason: child protection concern | 93 | 0.2150537634408602 | 22 | 0.2727272727272727 | 0.0576735092864125 | 0.564863107953807 | 0.0576735092864125 |
| JLOS/referral collaboration | referral_path_conf_score | Confidence knowing where to refer cases | 93 | 0.5940860215053764 | 22 | 0.6477272727272727 | 0.0536412512218963 | 0.2878003127995121 | 0.0536412512218963 |
| JLOS/referral collaboration | court_coordination_score | Perceived ease of coordinating with court/formal justice actors | 89 | 0.702247191011236 | 22 | 0.75 | 0.047752808988764 | 0.5192055028872642 | 0.047752808988764 |
| JLOS/referral collaboration | police_coordination_score | Perceived ease of coordinating with police | 91 | 0.7472527472527473 | 22 | 0.7840909090909091 | 0.0368381618381618 | 0.5917254605150458 | 0.0368381618381618 |
| JLOS/referral collaboration | m6_q12_1 | Referral barrier: authority too far away | 93 | 0.5161290322580645 | 22 | 0.5454545454545454 | 0.0293255131964809 | 0.8064949829553979 | 0.0293255131964809 |
| JLOS/referral collaboration | referral_frequency_score | Referral practice score: frequency/regularity | 88 | 0.7471590909090909 | 22 | 0.7272727272727273 | -0.0198863636363636 | 0.7752526513755804 | 0.0198863636363636 |
| Legitimacy and reintegration | comm_accepts_ex_prisoner | Respondent says community members are usually willing to accept them | 93 | 0.3010752688172043 | 22 | 0.1363636363636364 | -0.1647116324535679 | 0.1194846663140055 | 0.1647116324535679 |
| Legitimacy and reintegration | low_bypass_score | Inverse bypass score: higher means less perceived bypass, 0-1 | 89 | 0.5252808988764045 | 22 | 0.375 | -0.1502808988764045 | 0.0380629273137232 | 0.1502808988764045 |
| Legitimacy and reintegration | conf_fair_respect_score | Confidence LCC handles petty disputes fairly/respectfully, 0-1 | 93 | 0.5967741935483871 | 22 | 0.7272727272727273 | 0.1304985337243402 | 0.0109656170380977 | 0.1304985337243402 |
| Legitimacy and reintegration | reint_tension_conf_score | Confidence LCC can reduce reintegration-related community tensions, 0-1 | 93 | 0.5967741935483871 | 22 | 0.6931818181818182 | 0.0964076246334311 | 0.0647344620720814 | 0.0964076246334311 |
| Legitimacy and reintegration | bypass_due_bias | Bypass reason: perceived LCC bias/favoritism | 93 | 0.0860215053763441 | 22 | 0 | -0.0860215053763441 | 0.1565138644440016 | 0.0860215053763441 |
| Legitimacy and reintegration | reintegration_importance_score | Importance of community leaders supporting reintegration, 0-1 | 93 | 0.6102150537634409 | 22 | 0.6931818181818182 | 0.0829667644183774 | 0.1129997923085451 | 0.0829667644183774 |
| Legitimacy and reintegration | conf_trust_when_referring | Confidence maintaining trust while referring serious/ineligible cases, 0-1 | 93 | 0.5994623655913979 | 22 | 0.6818181818181818 | 0.0823558162267839 | 0.0815637115586467 | 0.0823558162267839 |
| Legitimacy and reintegration | perceived_lcc_fairness_score | Perceived community view of LCC fairness, 0-1 | 89 | 0.6713483146067416 | 22 | 0.75 | 0.0786516853932584 | 0.1730757374034435 | 0.0786516853932584 |
| Legitimacy and reintegration | reint_referral_conf_score | Confidence knowing where to refer formerly incarcerated persons for support, 0-1 | 93 | 0.5913978494623656 | 22 | 0.6590909090909091 | 0.0676930596285434 | 0.1998984801559283 | 0.0676930596285434 |
| Legitimacy and reintegration | fair_chance_reintegration_score | Agreement that formerly incarcerated persons deserve fair chance, 0-1 | 93 | 0.7553763440860215 | 22 | 0.8181818181818182 | 0.0628054740957967 | 0.1006874707948905 | 0.0628054740957967 |
| Legitimacy and reintegration | recent_reintegration_issue | LCC handled reintegration-related dispute/tension/concern in past 6 months | 93 | 0.4516129032258064 | 22 | 0.5 | 0.0483870967741936 | 0.6853880621562514 | 0.0483870967741936 |
| Legitimacy and reintegration | bypass_due_enforcement | Bypass reason: LCC cannot enforce agreements/decisions | 93 | 0.043010752688172 | 22 | 0 | -0.043010752688172 | 0.3263952254287072 | 0.043010752688172 |
| Legitimacy and reintegration | perc_willing_use_lcc_score | Perceived willingness of community to use LCC for eligible petty disputes, 0-1 | 89 | 0.6713483146067416 | 22 | 0.7045454545454546 | 0.033197139938713 | 0.5585600308312344 | 0.033197139938713 |
| Legitimacy and reintegration | idx_reintegration_norms | Reintegration norms | 93 | 0.6195523783724796 | 22 | 0.652246893806891 | 0.0326945154344115 | 0.2240407417593582 | 0.0326945154344115 |
| Legitimacy and reintegration | bypass_due_distrust | Bypass reason: community does not trust LCC | 93 | 0.1075268817204301 | 22 | 0.0909090909090909 | -0.0166177908113392 | 0.820578491980084 | 0.0166177908113392 |
| Legitimacy and reintegration | idx_perceived_legitimacy | Perceived legitimacy | 93 | 0.6039426528638409 | 22 | 0.6174242401664908 | 0.0134815873026499 | 0.696933200302649 | 0.0134815873026499 |
| Legitimacy and reintegration | low_reoffending_stigma_score | Reverse-coded belief that most formerly incarcerated persons reoffend, 0-1 | 93 | 0.4086021505376344 | 21 | 0.4166666666666667 | 0.0080645161290323 | 0.8901728565194712 | 0.0080645161290323 |
| Mentor-readiness flags | high_operational_capacity | Operational capacity index >= 0.75 | 93 | 0.2903225806451613 | 22 | 0.7727272727272727 | 0.4824046920821114 | 1.60855546253e-05 | 0.4824046920821114 |
| Mentor-readiness flags | high_case_handling_quality | Case-handling quality index >= 0.75 | 93 | 0.2580645161290323 | 22 | 0.5909090909090909 | 0.3328445747800586 | 0.0024169278216036 | 0.3328445747800586 |
| Mentor-readiness flags | high_mentor_readiness_proxy | Baseline mentor-readiness proxy index >= 0.75 | 93 | 0.0967741935483871 | 22 | 0.3636363636363636 | 0.2668621700879765 | 0.001332676712635 | 0.2668621700879765 |
| Mentor-readiness flags | high_legitimacy_norms | Legitimacy and reintegration norms index >= 0.75 | 93 | 0.0860215053763441 | 22 | 0.0909090909090909 | 0.0048875855327468 | 0.9423104520786998 | 0.0048875855327468 |
| Other/context | lcc_sittings_12m | Number of LCC sittings/hearings in the past 12 months | 93 | 4 | 22 | 8.272727272727273 | 4.272727272727273 | 0.0090474062123943 | 4.272727272727273 |
| Other/context | caseload_3m | Cases received by LCC in past 3 months | 91 | 2.010989010989011 | 22 | 2.727272727272727 | 0.7162837162837161 | 0.2515084504024167 | 0.7162837162837161 |
| Other/context | prior_cdfu_fhri_training | Respondent reports prior CDFU/FHRI training before/at baseline | 89 | 0.1797752808988764 | 22 | 0.7272727272727273 | 0.5474974463738509 | 8.59553474479e-08 | 0.5474974463738509 |
| Other/context | lc_experience_years | Years in LC1 position | 93 | 16.47311827956989 | 22 | 16.77272727272727 | 0.2996089931573813 | 0.9161223391206824 | 0.2996089931573813 |
| Other/context | prior_justice_training | Prior training on justice, mediation, mandate, records, or referrals | 93 | 0.6881720430107527 | 22 | 0.9545454545454546 | 0.2663734115347018 | 0.0102296368574016 | 0.2663734115347018 |
| Other/context | pending_cases | Pending/unresolved LCC cases | 93 | 0.2365591397849462 | 22 | 0.4545454545454545 | 0.2179863147605083 | 0.1354515014588593 | 0.2179863147605083 |
| Other/context | lcc_has_vacancy | LCC/LC committee has vacancies | 93 | 0.4946236559139785 | 22 | 0.6818181818181818 | 0.1871945259042033 | 0.1156177895831148 | 0.1871945259042033 |
| Other/context | completed_secondary_or_above | Completed secondary education or above | 93 | 0.1505376344086022 | 22 | 0.3181818181818182 | 0.167644183773216 | 0.0681994072868709 | 0.167644183773216 |
| Other/context | can_record_english | Can complete LCC records in English | 93 | 0.2795698924731183 | 22 | 0.1363636363636364 | -0.1432062561094819 | 0.167091014464043 | 0.1432062561094819 |
| Other/context | lcc_women_share | Share of current LCC/LC committee members who are women | 92 | 0.3646786184829663 | 22 | 0.4325150859241768 | 0.0678364674412105 | 0.0252551364217717 | 0.0678364674412105 |
| Other/context | any_serious_or_sensitive_case_3m | Reported child-related or SGBV case in past 3 months | 91 | 0.043956043956044 | 22 | 0.0909090909090909 | 0.0469530469530469 | 0.382612075263589 | 0.0469530469530469 |
| Other/context | any_child_or_sgbv_case_3m | LCC received child-related or SGBV case in past 3 months | 91 | 0.043956043956044 | 22 | 0.0909090909090909 | 0.0469530469530469 | 0.382612075263589 | 0.0469530469530469 |
| Other/context | can_record_runyankore | Can complete LCC records in Runyankore/Runyakitara | 93 | 0.978494623655914 | 22 | 1 | 0.021505376344086 | 0.492059771927674 | 0.021505376344086 |
| Records and safeguards | n_record_challenges | Number of reported record-keeping challenges | 93 | 2.301075268817204 | 22 | 1.590909090909091 | -0.710166177908113 | 0.0019609477212618 | 0.710166177908113 |
| Records and safeguards | m7_q15_3 | Record challenge: need training on case records | 93 | 0.5591397849462365 | 22 | 0.0909090909090909 | -0.4682306940371456 | 4.94375614732e-05 | 0.4682306940371456 |
| Records and safeguards | m7_q15_1 | Record challenge: no registers/books/forms/paper | 93 | 0.7634408602150538 | 22 | 0.4545454545454545 | -0.3088954056695993 | 0.0040265127730818 | 0.3088954056695993 |
| Records and safeguards | case_register_score | Current case register/case book score, 0-1 | 93 | 0.6881720430107527 | 22 | 0.9318181818181818 | 0.243646138807429 | 0.0037286887679766 | 0.243646138807429 |
| Records and safeguards | verified_record_usability_score | Enumerator-rated overall record usability score, 0-1 | 69 | 0.5543478260869565 | 19 | 0.7763157894736842 | 0.2219679633867276 | 0.0013141839603254 | 0.2219679633867276 |
| Records and safeguards | v06_sgbv_q3_correct | SGBV vignette: appropriate actor involvement/notification | 93 | 0.5161290322580645 | 22 | 0.7272727272727273 | 0.2111436950146628 | 0.074149097587517 | 0.2111436950146628 |
| Records and safeguards | idx_record_quality | Record quality | 93 | 0.5245644136542275 | 22 | 0.7144886363636364 | 0.1899242227094089 | 0.0007053686828179 | 0.1899242227094089 |
| Records and safeguards | v05_child_q2_correct | Child-related vignette: correct action/referral | 93 | 0.5376344086021505 | 22 | 0.7272727272727273 | 0.1896383186705768 | 0.1075943763256744 | 0.1896383186705768 |
| Records and safeguards | v05_child_q1_correct | Child-related vignette: correct classification | 93 | 0.5053763440860215 | 22 | 0.6363636363636364 | 0.1309872922776149 | 0.2722493516003762 | 0.1309872922776149 |
| Records and safeguards | v06_sgbv_q2_correct | SGBV vignette: correct action/referral | 93 | 0.5268817204301075 | 22 | 0.6363636363636364 | 0.1094819159335289 | 0.3578718997000038 | 0.1094819159335289 |
| Records and safeguards | idx_safeguard_classif_know | Index: serious/sensitive-case classification and referral knowledge, 0-1 | 93 | 0.5497311880832078 | 22 | 0.6549873846498403 | 0.1052561965666325 | 0.2150370087717239 | 0.1052561965666325 |
| Records and safeguards | v06_sgbv_q1_correct | SGBV vignette: correct classification | 93 | 0.5376344086021505 | 22 | 0.6363636363636364 | 0.0987292277614858 | 0.4063341426784139 | 0.0987292277614858 |
| Records and safeguards | idx_safeguards | Safeguards/referral knowledge | 93 | 0.699596782685608 | 22 | 0.7593118819323453 | 0.0597150992467373 | 0.2575737345663511 | 0.0597150992467373 |
| Records and safeguards | record_fields_score | Completeness of fields usually included in case records, 0-1 | 93 | 0.3198924731182796 | 22 | 0.356060606060606 | 0.0361681329423264 | 0.5080429950856225 | 0.0361681329423264 |
| Records and safeguards | vulnerable_need_sh | Respondent says vulnerable/sensitive cases require special handling | 93 | 0.8494623655913979 | 22 | 0.8636363636363636 | 0.0141739980449658 | 0.8676733515762063 | 0.0141739980449658 |
| Records and safeguards | v05_child_q3_correct | Child-related vignette: appropriate actor involvement/notification | 93 | 0.3118279569892473 | 22 | 0.3181818181818182 | 0.0063538611925709 | 0.9544161600413509 | 0.0063538611925709 |
| Records and safeguards | m7_q15_2 | Record challenge: no pens/basic stationery | 93 | 0.7741935483870968 | 22 | 0.7727272727272727 | -0.001466275659824 | 0.9883321736490267 | 0.001466275659824 |
## Sheet: ranked_abs_differences
| domain | variable | label | n_selected | mean_selected | n_prev | mean_prev | diff_prev_minus_selected | p_value | abs_diff |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Other/context | lcc_sittings_12m | Number of LCC sittings/hearings in the past 12 months | 93 | 4 | 22 | 8.272727272727273 | 4.272727272727273 | 0.0090474062123943 | 4.272727272727273 |
| Other/context | caseload_3m | Cases received by LCC in past 3 months | 91 | 2.010989010989011 | 22 | 2.727272727272727 | 0.7162837162837161 | 0.2515084504024167 | 0.7162837162837161 |
| Records and safeguards | n_record_challenges | Number of reported record-keeping challenges | 93 | 2.301075268817204 | 22 | 1.590909090909091 | -0.710166177908113 | 0.0019609477212618 | 0.710166177908113 |
| Other/context | prior_cdfu_fhri_training | Respondent reports prior CDFU/FHRI training before/at baseline | 89 | 0.1797752808988764 | 22 | 0.7272727272727273 | 0.5474974463738509 | 8.59553474479e-08 | 0.5474974463738509 |
| Mentor-readiness flags | high_operational_capacity | Operational capacity index >= 0.75 | 93 | 0.2903225806451613 | 22 | 0.7727272727272727 | 0.4824046920821114 | 1.60855546253e-05 | 0.4824046920821114 |
| Records and safeguards | m7_q15_3 | Record challenge: need training on case records | 93 | 0.5591397849462365 | 22 | 0.0909090909090909 | -0.4682306940371456 | 4.94375614732e-05 | 0.4682306940371456 |
| Mentor-readiness flags | high_case_handling_quality | Case-handling quality index >= 0.75 | 93 | 0.2580645161290323 | 22 | 0.5909090909090909 | 0.3328445747800586 | 0.0024169278216036 | 0.3328445747800586 |
| Records and safeguards | m7_q15_1 | Record challenge: no registers/books/forms/paper | 93 | 0.7634408602150538 | 22 | 0.4545454545454545 | -0.3088954056695993 | 0.0040265127730818 | 0.3088954056695993 |
| Other/context | lc_experience_years | Years in LC1 position | 93 | 16.47311827956989 | 22 | 16.77272727272727 | 0.2996089931573813 | 0.9161223391206824 | 0.2996089931573813 |
| Mentor-readiness flags | high_mentor_readiness_proxy | Baseline mentor-readiness proxy index >= 0.75 | 93 | 0.0967741935483871 | 22 | 0.3636363636363636 | 0.2668621700879765 | 0.001332676712635 | 0.2668621700879765 |
| Other/context | prior_justice_training | Prior training on justice, mediation, mandate, records, or referrals | 93 | 0.6881720430107527 | 22 | 0.9545454545454546 | 0.2663734115347018 | 0.0102296368574016 | 0.2663734115347018 |
| Records and safeguards | case_register_score | Current case register/case book score, 0-1 | 93 | 0.6881720430107527 | 22 | 0.9318181818181818 | 0.243646138807429 | 0.0037286887679766 | 0.243646138807429 |
| Records and safeguards | verified_record_usability_score | Enumerator-rated overall record usability score, 0-1 | 69 | 0.5543478260869565 | 19 | 0.7763157894736842 | 0.2219679633867276 | 0.0013141839603254 | 0.2219679633867276 |
| Other/context | pending_cases | Pending/unresolved LCC cases | 93 | 0.2365591397849462 | 22 | 0.4545454545454545 | 0.2179863147605083 | 0.1354515014588593 | 0.2179863147605083 |
| Records and safeguards | v06_sgbv_q3_correct | SGBV vignette: appropriate actor involvement/notification | 93 | 0.5161290322580645 | 22 | 0.7272727272727273 | 0.2111436950146628 | 0.074149097587517 | 0.2111436950146628 |
| JLOS/referral collaboration | referral_documentation_score | Referral practice score: documentation | 90 | 0.4611111111111111 | 22 | 0.6704545454545454 | 0.2093434343434343 | 0.0018960041074505 | 0.2093434343434343 |
| Records and safeguards | idx_record_quality | Record quality | 93 | 0.5245644136542275 | 22 | 0.7144886363636364 | 0.1899242227094089 | 0.0007053686828179 | 0.1899242227094089 |
| Records and safeguards | v05_child_q2_correct | Child-related vignette: correct action/referral | 93 | 0.5376344086021505 | 22 | 0.7272727272727273 | 0.1896383186705768 | 0.1075943763256744 | 0.1896383186705768 |
| Other/context | lcc_has_vacancy | LCC/LC committee has vacancies | 93 | 0.4946236559139785 | 22 | 0.6818181818181818 | 0.1871945259042033 | 0.1156177895831148 | 0.1871945259042033 |
| JLOS/referral collaboration | referral_feedback_score | Referral practice score: receiving feedback | 90 | 0.4222222222222222 | 21 | 0.6071428571428571 | 0.1849206349206349 | 0.0082921406870097 | 0.1849206349206349 |
| Other/context | completed_secondary_or_above | Completed secondary education or above | 93 | 0.1505376344086022 | 22 | 0.3181818181818182 | 0.167644183773216 | 0.0681994072868709 | 0.167644183773216 |
| Legitimacy and reintegration | comm_accepts_ex_prisoner | Respondent says community members are usually willing to accept them | 93 | 0.3010752688172043 | 22 | 0.1363636363636364 | -0.1647116324535679 | 0.1194846663140055 | 0.1647116324535679 |
| Legitimacy and reintegration | low_bypass_score | Inverse bypass score: higher means less perceived bypass, 0-1 | 89 | 0.5252808988764045 | 22 | 0.375 | -0.1502808988764045 | 0.0380629273137232 | 0.1502808988764045 |
| Other/context | can_record_english | Can complete LCC records in English | 93 | 0.2795698924731183 | 22 | 0.1363636363636364 | -0.1432062561094819 | 0.167091014464043 | 0.1432062561094819 |
| Records and safeguards | v05_child_q1_correct | Child-related vignette: correct classification | 93 | 0.5053763440860215 | 22 | 0.6363636363636364 | 0.1309872922776149 | 0.2722493516003762 | 0.1309872922776149 |
| Legitimacy and reintegration | conf_fair_respect_score | Confidence LCC handles petty disputes fairly/respectfully, 0-1 | 93 | 0.5967741935483871 | 22 | 0.7272727272727273 | 0.1304985337243402 | 0.0109656170380977 | 0.1304985337243402 |
| Core composites | idx_lcc_operational_capacity | Operational capacity | 93 | 0.6782861906354145 | 22 | 0.8084242479367689 | 0.1301380573013544 | 1.9104368202e-05 | 0.1301380573013544 |
| Domain indices | idx_institutional_functioning | Institutional functioning | 93 | 0.762384795693941 | 22 | 0.8915719742124731 | 0.1291871785185321 | 0.000240867501065 | 0.1291871785185321 |
| JLOS/referral collaboration | m6_q04_1 | Referral reason: outside LCC mandate | 93 | 0.8387096774193549 | 22 | 0.9545454545454546 | 0.1158357771260997 | 0.1607752812799218 | 0.1158357771260997 |
| JLOS/referral collaboration | m6_q12_2 | Referral barrier: transport cost/lack of transport | 93 | 0.4301075268817204 | 22 | 0.5454545454545454 | 0.115347018572825 | 0.3326032191300492 | 0.115347018572825 |
| Records and safeguards | v06_sgbv_q2_correct | SGBV vignette: correct action/referral | 93 | 0.5268817204301075 | 22 | 0.6363636363636364 | 0.1094819159335289 | 0.3578718997000038 | 0.1094819159335289 |
| Records and safeguards | idx_safeguard_classif_know | Index: serious/sensitive-case classification and referral knowledge, 0-1 | 93 | 0.5497311880832078 | 22 | 0.6549873846498403 | 0.1052561965666325 | 0.2150370087717239 | 0.1052561965666325 |
| Domain indices | idx_adr_mediation_practice | ADR/mediation practice | 93 | 0.6548655905550526 | 22 | 0.7586776925758882 | 0.1038121020208357 | 0.0220147262289193 | 0.1038121020208357 |
| Records and safeguards | v06_sgbv_q1_correct | SGBV vignette: correct classification | 93 | 0.5376344086021505 | 22 | 0.6363636363636364 | 0.0987292277614858 | 0.4063341426784139 | 0.0987292277614858 |
| Legitimacy and reintegration | reint_tension_conf_score | Confidence LCC can reduce reintegration-related community tensions, 0-1 | 93 | 0.5967741935483871 | 22 | 0.6931818181818182 | 0.0964076246334311 | 0.0647344620720814 | 0.0964076246334311 |
| Legitimacy and reintegration | bypass_due_bias | Bypass reason: perceived LCC bias/favoritism | 93 | 0.0860215053763441 | 22 | 0 | -0.0860215053763441 | 0.1565138644440016 | 0.0860215053763441 |
| JLOS/referral collaboration | m6_q04_2 | Referral reason: serious violence/threat to life | 93 | 0.6881720430107527 | 22 | 0.7727272727272727 | 0.08455522971652 | 0.4389021554774559 | 0.08455522971652 |
| JLOS/referral collaboration | idx_referral_practice | Referral practice | 93 | 0.615209507205153 | 22 | 0.6982999606565996 | 0.0830904534514466 | 0.0237050435060385 | 0.0830904534514466 |
| Legitimacy and reintegration | reintegration_importance_score | Importance of community leaders supporting reintegration, 0-1 | 93 | 0.6102150537634409 | 22 | 0.6931818181818182 | 0.0829667644183774 | 0.1129997923085451 | 0.0829667644183774 |
| Legitimacy and reintegration | conf_trust_when_referring | Confidence maintaining trust while referring serious/ineligible cases, 0-1 | 93 | 0.5994623655913979 | 22 | 0.6818181818181818 | 0.0823558162267839 | 0.0815637115586467 | 0.0823558162267839 |
| Legitimacy and reintegration | perceived_lcc_fairness_score | Perceived community view of LCC fairness, 0-1 | 89 | 0.6713483146067416 | 22 | 0.75 | 0.0786516853932584 | 0.1730757374034435 | 0.0786516853932584 |
| JLOS/referral collaboration | verified_ref_dest_score | Enumerator-verified referral destination is recorded, 0-1 | 56 | 0.6875 | 17 | 0.7647058823529411 | 0.0772058823529411 | 0.4969888236901042 | 0.0772058823529411 |
| Core composites | idx_p1_base_mentor_ready_proxy | Baseline mentor-readiness proxy | 93 | 0.6427177325371773 | 22 | 0.7175788391720165 | 0.0748611066348391 | 0.0005434265669958 | 0.0748611066348391 |
| JLOS/referral collaboration | m6_q04_3 | Referral reason: sexual violence or SGBV | 93 | 0.4838709677419355 | 22 | 0.4090909090909091 | -0.0747800586510264 | 0.5315429090118823 | 0.0747800586510264 |
| Domain indices | idx_respondent_capacity | Respondent capacity | 93 | 0.611699949509354 | 22 | 0.6858225071972067 | 0.0741225576878527 | 0.0299591873319348 | 0.0741225576878527 |
| JLOS/referral collaboration | referral_explain_conf_score | Confidence explaining referrals to community members | 93 | 0.5860215053763441 | 22 | 0.6590909090909091 | 0.0730694037145649 | 0.1653408835052607 | 0.0730694037145649 |
| JLOS/referral collaboration | prior_formal_coordination | Prior coordination with police/courts/probation/child protection/justice actors | 93 | 0.8817204301075269 | 22 | 0.9545454545454546 | 0.0728250244379277 | 0.3192493927681256 | 0.0728250244379277 |
| Core composites | idx_lcc_case_handling_quality | Case-handling quality | 93 | 0.6691372814357922 | 22 | 0.7412330494685606 | 0.0720957680327684 | 0.0157690771133387 | 0.0720957680327684 |
| Domain indices | idx_committee_functioning | Committee functioning | 93 | 0.7479093616367668 | 22 | 0.8192121169783853 | 0.0713027553416185 | 0.0195396725177469 | 0.0713027553416185 |
| Other/context | lcc_women_share | Share of current LCC/LC committee members who are women | 92 | 0.3646786184829663 | 22 | 0.4325150859241768 | 0.0678364674412105 | 0.0252551364217717 | 0.0678364674412105 |
| Legitimacy and reintegration | reint_referral_conf_score | Confidence knowing where to refer formerly incarcerated persons for support, 0-1 | 93 | 0.5913978494623656 | 22 | 0.6590909090909091 | 0.0676930596285434 | 0.1998984801559283 | 0.0676930596285434 |
| Legitimacy and reintegration | fair_chance_reintegration_score | Agreement that formerly incarcerated persons deserve fair chance, 0-1 | 93 | 0.7553763440860215 | 22 | 0.8181818181818182 | 0.0628054740957967 | 0.1006874707948905 | 0.0628054740957967 |
| JLOS/referral collaboration | verified_referral_record_score | Enumerator-verified referred cases are recorded, 0-1 | 55 | 0.7181818181818181 | 16 | 0.65625 | -0.0619318181818181 | 0.5988066848418752 | 0.0619318181818181 |
| Records and safeguards | idx_safeguards | Safeguards/referral knowledge | 93 | 0.699596782685608 | 22 | 0.7593118819323453 | 0.0597150992467373 | 0.2575737345663511 | 0.0597150992467373 |
| JLOS/referral collaboration | m6_q04_4 | Referral reason: child protection concern | 93 | 0.2150537634408602 | 22 | 0.2727272727272727 | 0.0576735092864125 | 0.564863107953807 | 0.0576735092864125 |
| JLOS/referral collaboration | referral_path_conf_score | Confidence knowing where to refer cases | 93 | 0.5940860215053764 | 22 | 0.6477272727272727 | 0.0536412512218963 | 0.2878003127995121 | 0.0536412512218963 |
| Legitimacy and reintegration | recent_reintegration_issue | LCC handled reintegration-related dispute/tension/concern in past 6 months | 93 | 0.4516129032258064 | 22 | 0.5 | 0.0483870967741936 | 0.6853880621562514 | 0.0483870967741936 |
| JLOS/referral collaboration | court_coordination_score | Perceived ease of coordinating with court/formal justice actors | 89 | 0.702247191011236 | 22 | 0.75 | 0.047752808988764 | 0.5192055028872642 | 0.047752808988764 |
| Other/context | any_child_or_sgbv_case_3m | LCC received child-related or SGBV case in past 3 months | 91 | 0.043956043956044 | 22 | 0.0909090909090909 | 0.0469530469530469 | 0.382612075263589 | 0.0469530469530469 |
| Other/context | any_serious_or_sensitive_case_3m | Reported child-related or SGBV case in past 3 months | 91 | 0.043956043956044 | 22 | 0.0909090909090909 | 0.0469530469530469 | 0.382612075263589 | 0.0469530469530469 |
| Legitimacy and reintegration | bypass_due_enforcement | Bypass reason: LCC cannot enforce agreements/decisions | 93 | 0.043010752688172 | 22 | 0 | -0.043010752688172 | 0.3263952254287072 | 0.043010752688172 |
| Domain indices | idx_legal_classif_knowledge | Legal/classification knowledge | 93 | 0.7068772424933731 | 22 | 0.7486426803198728 | 0.0417654378264997 | 0.1971978296089668 | 0.0417654378264997 |
| JLOS/referral collaboration | police_coordination_score | Perceived ease of coordinating with police | 91 | 0.7472527472527473 | 22 | 0.7840909090909091 | 0.0368381618381618 | 0.5917254605150458 | 0.0368381618381618 |
| Records and safeguards | record_fields_score | Completeness of fields usually included in case records, 0-1 | 93 | 0.3198924731182796 | 22 | 0.356060606060606 | 0.0361681329423264 | 0.5080429950856225 | 0.0361681329423264 |
| Legitimacy and reintegration | perc_willing_use_lcc_score | Perceived willingness of community to use LCC for eligible petty disputes, 0-1 | 89 | 0.6713483146067416 | 22 | 0.7045454545454546 | 0.033197139938713 | 0.5585600308312344 | 0.033197139938713 |
| Legitimacy and reintegration | idx_reintegration_norms | Reintegration norms | 93 | 0.6195523783724796 | 22 | 0.652246893806891 | 0.0326945154344115 | 0.2240407417593582 | 0.0326945154344115 |
| JLOS/referral collaboration | m6_q12_1 | Referral barrier: authority too far away | 93 | 0.5161290322580645 | 22 | 0.5454545454545454 | 0.0293255131964809 | 0.8064949829553979 | 0.0293255131964809 |
| Core composites | idx_lcc_legitimacy_and_norms | Legitimacy and reintegration | 93 | 0.6117475141761124 | 22 | 0.6348355656320398 | 0.0230880514559274 | 0.3929928382234932 | 0.0230880514559274 |
| Other/context | can_record_runyankore | Can complete LCC records in Runyankore/Runyakitara | 93 | 0.978494623655914 | 22 | 1 | 0.021505376344086 | 0.492059771927674 | 0.021505376344086 |
| JLOS/referral collaboration | referral_frequency_score | Referral practice score: frequency/regularity | 88 | 0.7471590909090909 | 22 | 0.7272727272727273 | -0.0198863636363636 | 0.7752526513755804 | 0.0198863636363636 |
| Legitimacy and reintegration | bypass_due_distrust | Bypass reason: community does not trust LCC | 93 | 0.1075268817204301 | 22 | 0.0909090909090909 | -0.0166177908113392 | 0.820578491980084 | 0.0166177908113392 |
| Records and safeguards | vulnerable_need_sh | Respondent says vulnerable/sensitive cases require special handling | 93 | 0.8494623655913979 | 22 | 0.8636363636363636 | 0.0141739980449658 | 0.8676733515762063 | 0.0141739980449658 |
| Legitimacy and reintegration | idx_perceived_legitimacy | Perceived legitimacy | 93 | 0.6039426528638409 | 22 | 0.6174242401664908 | 0.0134815873026499 | 0.696933200302649 | 0.0134815873026499 |
| Legitimacy and reintegration | low_reoffending_stigma_score | Reverse-coded belief that most formerly incarcerated persons reoffend, 0-1 | 93 | 0.4086021505376344 | 21 | 0.4166666666666667 | 0.0080645161290323 | 0.8901728565194712 | 0.0080645161290323 |
| Records and safeguards | v05_child_q3_correct | Child-related vignette: appropriate actor involvement/notification | 93 | 0.3118279569892473 | 22 | 0.3181818181818182 | 0.0063538611925709 | 0.9544161600413509 | 0.0063538611925709 |
| Mentor-readiness flags | high_legitimacy_norms | Legitimacy and reintegration norms index >= 0.75 | 93 | 0.0860215053763441 | 22 | 0.0909090909090909 | 0.0048875855327468 | 0.9423104520786998 | 0.0048875855327468 |
| Records and safeguards | m7_q15_2 | Record challenge: no pens/basic stationery | 93 | 0.7741935483870968 | 22 | 0.7727272727272727 | -0.001466275659824 | 0.9883321736490267 | 0.001466275659824 |
## Sheet: report_core_comparisons
| domain | variable | label | n_selected | mean_selected | n_prev | mean_prev | diff_prev_minus_selected | p_value | abs_diff |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Records and safeguards | n_record_challenges | Number of reported record-keeping challenges | 93 | 2.301075268817204 | 22 | 1.590909090909091 | -0.710166177908113 | 0.0019609477212618 | 0.710166177908113 |
| Mentor-readiness flags | high_operational_capacity | Operational capacity index >= 0.75 | 93 | 0.2903225806451613 | 22 | 0.7727272727272727 | 0.4824046920821114 | 1.60855546253e-05 | 0.4824046920821114 |
| Records and safeguards | m7_q15_3 | Record challenge: need training on case records | 93 | 0.5591397849462365 | 22 | 0.0909090909090909 | -0.4682306940371456 | 4.94375614732e-05 | 0.4682306940371456 |
| Mentor-readiness flags | high_case_handling_quality | Case-handling quality index >= 0.75 | 93 | 0.2580645161290323 | 22 | 0.5909090909090909 | 0.3328445747800586 | 0.0024169278216036 | 0.3328445747800586 |
| Records and safeguards | m7_q15_1 | Record challenge: no registers/books/forms/paper | 93 | 0.7634408602150538 | 22 | 0.4545454545454545 | -0.3088954056695993 | 0.0040265127730818 | 0.3088954056695993 |
| Mentor-readiness flags | high_mentor_readiness_proxy | Baseline mentor-readiness proxy index >= 0.75 | 93 | 0.0967741935483871 | 22 | 0.3636363636363636 | 0.2668621700879765 | 0.001332676712635 | 0.2668621700879765 |
| Records and safeguards | case_register_score | Current case register/case book score, 0-1 | 93 | 0.6881720430107527 | 22 | 0.9318181818181818 | 0.243646138807429 | 0.0037286887679766 | 0.243646138807429 |
| Records and safeguards | verified_record_usability_score | Enumerator-rated overall record usability score, 0-1 | 69 | 0.5543478260869565 | 19 | 0.7763157894736842 | 0.2219679633867276 | 0.0013141839603254 | 0.2219679633867276 |
| Records and safeguards | v06_sgbv_q3_correct | SGBV vignette: appropriate actor involvement/notification | 93 | 0.5161290322580645 | 22 | 0.7272727272727273 | 0.2111436950146628 | 0.074149097587517 | 0.2111436950146628 |
| JLOS/referral collaboration | referral_documentation_score | Referral practice score: documentation | 90 | 0.4611111111111111 | 22 | 0.6704545454545454 | 0.2093434343434343 | 0.0018960041074505 | 0.2093434343434343 |
| Records and safeguards | idx_record_quality | Record quality | 93 | 0.5245644136542275 | 22 | 0.7144886363636364 | 0.1899242227094089 | 0.0007053686828179 | 0.1899242227094089 |
| Records and safeguards | v05_child_q2_correct | Child-related vignette: correct action/referral | 93 | 0.5376344086021505 | 22 | 0.7272727272727273 | 0.1896383186705768 | 0.1075943763256744 | 0.1896383186705768 |
| JLOS/referral collaboration | referral_feedback_score | Referral practice score: receiving feedback | 90 | 0.4222222222222222 | 21 | 0.6071428571428571 | 0.1849206349206349 | 0.0082921406870097 | 0.1849206349206349 |
| Legitimacy and reintegration | comm_accepts_ex_prisoner | Respondent says community members are usually willing to accept them | 93 | 0.3010752688172043 | 22 | 0.1363636363636364 | -0.1647116324535679 | 0.1194846663140055 | 0.1647116324535679 |
| Legitimacy and reintegration | low_bypass_score | Inverse bypass score: higher means less perceived bypass, 0-1 | 89 | 0.5252808988764045 | 22 | 0.375 | -0.1502808988764045 | 0.0380629273137232 | 0.1502808988764045 |
| Records and safeguards | v05_child_q1_correct | Child-related vignette: correct classification | 93 | 0.5053763440860215 | 22 | 0.6363636363636364 | 0.1309872922776149 | 0.2722493516003762 | 0.1309872922776149 |
| Legitimacy and reintegration | conf_fair_respect_score | Confidence LCC handles petty disputes fairly/respectfully, 0-1 | 93 | 0.5967741935483871 | 22 | 0.7272727272727273 | 0.1304985337243402 | 0.0109656170380977 | 0.1304985337243402 |
| Core composites | idx_lcc_operational_capacity | Operational capacity | 93 | 0.6782861906354145 | 22 | 0.8084242479367689 | 0.1301380573013544 | 1.9104368202e-05 | 0.1301380573013544 |
| Domain indices | idx_institutional_functioning | Institutional functioning | 93 | 0.762384795693941 | 22 | 0.8915719742124731 | 0.1291871785185321 | 0.000240867501065 | 0.1291871785185321 |
| JLOS/referral collaboration | m6_q04_1 | Referral reason: outside LCC mandate | 93 | 0.8387096774193549 | 22 | 0.9545454545454546 | 0.1158357771260997 | 0.1607752812799218 | 0.1158357771260997 |
| JLOS/referral collaboration | m6_q12_2 | Referral barrier: transport cost/lack of transport | 93 | 0.4301075268817204 | 22 | 0.5454545454545454 | 0.115347018572825 | 0.3326032191300492 | 0.115347018572825 |
| Records and safeguards | v06_sgbv_q2_correct | SGBV vignette: correct action/referral | 93 | 0.5268817204301075 | 22 | 0.6363636363636364 | 0.1094819159335289 | 0.3578718997000038 | 0.1094819159335289 |
| Records and safeguards | idx_safeguard_classif_know | Index: serious/sensitive-case classification and referral knowledge, 0-1 | 93 | 0.5497311880832078 | 22 | 0.6549873846498403 | 0.1052561965666325 | 0.2150370087717239 | 0.1052561965666325 |
| Domain indices | idx_adr_mediation_practice | ADR/mediation practice | 93 | 0.6548655905550526 | 22 | 0.7586776925758882 | 0.1038121020208357 | 0.0220147262289193 | 0.1038121020208357 |
| Records and safeguards | v06_sgbv_q1_correct | SGBV vignette: correct classification | 93 | 0.5376344086021505 | 22 | 0.6363636363636364 | 0.0987292277614858 | 0.4063341426784139 | 0.0987292277614858 |
| Legitimacy and reintegration | reint_tension_conf_score | Confidence LCC can reduce reintegration-related community tensions, 0-1 | 93 | 0.5967741935483871 | 22 | 0.6931818181818182 | 0.0964076246334311 | 0.0647344620720814 | 0.0964076246334311 |
| Legitimacy and reintegration | bypass_due_bias | Bypass reason: perceived LCC bias/favoritism | 93 | 0.0860215053763441 | 22 | 0 | -0.0860215053763441 | 0.1565138644440016 | 0.0860215053763441 |
| JLOS/referral collaboration | m6_q04_2 | Referral reason: serious violence/threat to life | 93 | 0.6881720430107527 | 22 | 0.7727272727272727 | 0.08455522971652 | 0.4389021554774559 | 0.08455522971652 |
| JLOS/referral collaboration | idx_referral_practice | Referral practice | 93 | 0.615209507205153 | 22 | 0.6982999606565996 | 0.0830904534514466 | 0.0237050435060385 | 0.0830904534514466 |
| Legitimacy and reintegration | reintegration_importance_score | Importance of community leaders supporting reintegration, 0-1 | 93 | 0.6102150537634409 | 22 | 0.6931818181818182 | 0.0829667644183774 | 0.1129997923085451 | 0.0829667644183774 |
| Legitimacy and reintegration | conf_trust_when_referring | Confidence maintaining trust while referring serious/ineligible cases, 0-1 | 93 | 0.5994623655913979 | 22 | 0.6818181818181818 | 0.0823558162267839 | 0.0815637115586467 | 0.0823558162267839 |
| Legitimacy and reintegration | perceived_lcc_fairness_score | Perceived community view of LCC fairness, 0-1 | 89 | 0.6713483146067416 | 22 | 0.75 | 0.0786516853932584 | 0.1730757374034435 | 0.0786516853932584 |
| JLOS/referral collaboration | verified_ref_dest_score | Enumerator-verified referral destination is recorded, 0-1 | 56 | 0.6875 | 17 | 0.7647058823529411 | 0.0772058823529411 | 0.4969888236901042 | 0.0772058823529411 |
| Core composites | idx_p1_base_mentor_ready_proxy | Baseline mentor-readiness proxy | 93 | 0.6427177325371773 | 22 | 0.7175788391720165 | 0.0748611066348391 | 0.0005434265669958 | 0.0748611066348391 |
| JLOS/referral collaboration | m6_q04_3 | Referral reason: sexual violence or SGBV | 93 | 0.4838709677419355 | 22 | 0.4090909090909091 | -0.0747800586510264 | 0.5315429090118823 | 0.0747800586510264 |
| Domain indices | idx_respondent_capacity | Respondent capacity | 93 | 0.611699949509354 | 22 | 0.6858225071972067 | 0.0741225576878527 | 0.0299591873319348 | 0.0741225576878527 |
| JLOS/referral collaboration | referral_explain_conf_score | Confidence explaining referrals to community members | 93 | 0.5860215053763441 | 22 | 0.6590909090909091 | 0.0730694037145649 | 0.1653408835052607 | 0.0730694037145649 |
| JLOS/referral collaboration | prior_formal_coordination | Prior coordination with police/courts/probation/child protection/justice actors | 93 | 0.8817204301075269 | 22 | 0.9545454545454546 | 0.0728250244379277 | 0.3192493927681256 | 0.0728250244379277 |
| Core composites | idx_lcc_case_handling_quality | Case-handling quality | 93 | 0.6691372814357922 | 22 | 0.7412330494685606 | 0.0720957680327684 | 0.0157690771133387 | 0.0720957680327684 |
| Domain indices | idx_committee_functioning | Committee functioning | 93 | 0.7479093616367668 | 22 | 0.8192121169783853 | 0.0713027553416185 | 0.0195396725177469 | 0.0713027553416185 |
| Legitimacy and reintegration | reint_referral_conf_score | Confidence knowing where to refer formerly incarcerated persons for support, 0-1 | 93 | 0.5913978494623656 | 22 | 0.6590909090909091 | 0.0676930596285434 | 0.1998984801559283 | 0.0676930596285434 |
| Legitimacy and reintegration | fair_chance_reintegration_score | Agreement that formerly incarcerated persons deserve fair chance, 0-1 | 93 | 0.7553763440860215 | 22 | 0.8181818181818182 | 0.0628054740957967 | 0.1006874707948905 | 0.0628054740957967 |
| JLOS/referral collaboration | verified_referral_record_score | Enumerator-verified referred cases are recorded, 0-1 | 55 | 0.7181818181818181 | 16 | 0.65625 | -0.0619318181818181 | 0.5988066848418752 | 0.0619318181818181 |
| Records and safeguards | idx_safeguards | Safeguards/referral knowledge | 93 | 0.699596782685608 | 22 | 0.7593118819323453 | 0.0597150992467373 | 0.2575737345663511 | 0.0597150992467373 |
| JLOS/referral collaboration | m6_q04_4 | Referral reason: child protection concern | 93 | 0.2150537634408602 | 22 | 0.2727272727272727 | 0.0576735092864125 | 0.564863107953807 | 0.0576735092864125 |
| JLOS/referral collaboration | referral_path_conf_score | Confidence knowing where to refer cases | 93 | 0.5940860215053764 | 22 | 0.6477272727272727 | 0.0536412512218963 | 0.2878003127995121 | 0.0536412512218963 |
| Legitimacy and reintegration | recent_reintegration_issue | LCC handled reintegration-related dispute/tension/concern in past 6 months | 93 | 0.4516129032258064 | 22 | 0.5 | 0.0483870967741936 | 0.6853880621562514 | 0.0483870967741936 |
| JLOS/referral collaboration | court_coordination_score | Perceived ease of coordinating with court/formal justice actors | 89 | 0.702247191011236 | 22 | 0.75 | 0.047752808988764 | 0.5192055028872642 | 0.047752808988764 |
| Legitimacy and reintegration | bypass_due_enforcement | Bypass reason: LCC cannot enforce agreements/decisions | 93 | 0.043010752688172 | 22 | 0 | -0.043010752688172 | 0.3263952254287072 | 0.043010752688172 |
| Domain indices | idx_legal_classif_knowledge | Legal/classification knowledge | 93 | 0.7068772424933731 | 22 | 0.7486426803198728 | 0.0417654378264997 | 0.1971978296089668 | 0.0417654378264997 |
| JLOS/referral collaboration | police_coordination_score | Perceived ease of coordinating with police | 91 | 0.7472527472527473 | 22 | 0.7840909090909091 | 0.0368381618381618 | 0.5917254605150458 | 0.0368381618381618 |
| Records and safeguards | record_fields_score | Completeness of fields usually included in case records, 0-1 | 93 | 0.3198924731182796 | 22 | 0.356060606060606 | 0.0361681329423264 | 0.5080429950856225 | 0.0361681329423264 |
| Legitimacy and reintegration | perc_willing_use_lcc_score | Perceived willingness of community to use LCC for eligible petty disputes, 0-1 | 89 | 0.6713483146067416 | 22 | 0.7045454545454546 | 0.033197139938713 | 0.5585600308312344 | 0.033197139938713 |
| Legitimacy and reintegration | idx_reintegration_norms | Reintegration norms | 93 | 0.6195523783724796 | 22 | 0.652246893806891 | 0.0326945154344115 | 0.2240407417593582 | 0.0326945154344115 |
| JLOS/referral collaboration | m6_q12_1 | Referral barrier: authority too far away | 93 | 0.5161290322580645 | 22 | 0.5454545454545454 | 0.0293255131964809 | 0.8064949829553979 | 0.0293255131964809 |
| Core composites | idx_lcc_legitimacy_and_norms | Legitimacy and reintegration | 93 | 0.6117475141761124 | 22 | 0.6348355656320398 | 0.0230880514559274 | 0.3929928382234932 | 0.0230880514559274 |
| JLOS/referral collaboration | referral_frequency_score | Referral practice score: frequency/regularity | 88 | 0.7471590909090909 | 22 | 0.7272727272727273 | -0.0198863636363636 | 0.7752526513755804 | 0.0198863636363636 |
| Legitimacy and reintegration | bypass_due_distrust | Bypass reason: community does not trust LCC | 93 | 0.1075268817204301 | 22 | 0.0909090909090909 | -0.0166177908113392 | 0.820578491980084 | 0.0166177908113392 |
| Records and safeguards | vulnerable_need_sh | Respondent says vulnerable/sensitive cases require special handling | 93 | 0.8494623655913979 | 22 | 0.8636363636363636 | 0.0141739980449658 | 0.8676733515762063 | 0.0141739980449658 |
| Legitimacy and reintegration | idx_perceived_legitimacy | Perceived legitimacy | 93 | 0.6039426528638409 | 22 | 0.6174242401664908 | 0.0134815873026499 | 0.696933200302649 | 0.0134815873026499 |
| Legitimacy and reintegration | low_reoffending_stigma_score | Reverse-coded belief that most formerly incarcerated persons reoffend, 0-1 | 93 | 0.4086021505376344 | 21 | 0.4166666666666667 | 0.0080645161290323 | 0.8901728565194712 | 0.0080645161290323 |
| Records and safeguards | v05_child_q3_correct | Child-related vignette: appropriate actor involvement/notification | 93 | 0.3118279569892473 | 22 | 0.3181818181818182 | 0.0063538611925709 | 0.9544161600413509 | 0.0063538611925709 |
| Mentor-readiness flags | high_legitimacy_norms | Legitimacy and reintegration norms index >= 0.75 | 93 | 0.0860215053763441 | 22 | 0.0909090909090909 | 0.0048875855327468 | 0.9423104520786998 | 0.0048875855327468 |
| Records and safeguards | m7_q15_2 | Record challenge: no pens/basic stationery | 93 | 0.7741935483870968 | 22 | 0.7727272727272727 | -0.001466275659824 | 0.9883321736490267 | 0.001466275659824 |
## Sheet: fig32_core_composites
| p1_admin_previously_contacted | origin_group | n | idx_lcc_operational_capacity | idx_lcc_case_handling_quality | idx_lcc_legitimacy_and_norms | idx_p1_base_mentor_ready_proxy |
| --- | --- | --- | --- | --- | --- | --- |
| Selected-list (observed) | Selected-list (observed) | 93 | 0.6782861948013306 | 0.6691372990608215 | 0.6117475032806396 | 0.642717719078064 |
| Previously contacted | Previously contacted | 22 | 0.8084242343902588 | 0.7412330508232117 | 0.6348355412483215 | 0.7175788283348083 |
## Sheet: fig33_jlos_collaboration
| p1_admin_previously_contacted | origin_group | n | prior_formal_coordination | police_coordination_score | court_coordination_score | referral_path_conf_score | referral_explain_conf_score | referral_feedback_score | verified_referral_record_score |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Selected-list (observed) | Selected-list (observed) | 93 | 0.8817204236984253 | 0.7472527472527473 | 0.702247191011236 | 0.5940860215053764 | 0.5860215053763441 | 0.4222222222222222 | 0.7181818181818181 |
| Previously contacted | Previously contacted | 22 | 0.9545454382896423 | 0.7840909090909091 | 0.75 | 0.6477272727272727 | 0.6590909090909091 | 0.6071428571428571 | 0.65625 |
## Sheet: fig34_priority_gaps
| p1_admin_previously_contacted | origin_group | n | gap_perceived_legitimacy | gap_record_quality | gap_reintegration_norms | gap_referral_practice | gap_safeguards | gap_case_handling |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Selected-list (observed) | Selected-list (observed) | 93 | 0.3960573471361591 | 0.4754355863457726 | 0.3804476216275205 | 0.38479049279484695 | 0.300403217314392 | 0.33086271856420785 |
| Previously contacted | Previously contacted | 22 | 0.3825757598335093 | 0.28551136363636365 | 0.347753106193109 | 0.30170003934340045 | 0.2406881180676547 | 0.25876695053143933 |
## Sheet: fig35_high_readiness_flags
| p1_admin_previously_contacted | origin_group | n | high_operational_capacity | high_case_handling_quality | high_legitimacy_norms | high_mentor_readiness_proxy |
| --- | --- | --- | --- | --- | --- | --- |
| Selected-list (observed) | Selected-list (observed) | 93 | 0.29032257199287415 | 0.25806450843811035 | 0.08602150529623032 | 0.09677419066429138 |
| Previously contacted | Previously contacted | 22 | 0.7727272510528564 | 0.5909090638160706 | 0.09090909361839294 | 0.3636363744735718 |
## Sheet: district_adjusted_diagnostics
| outcome | label | n | mean_selected | mean_prev | raw_diff_prev_minus_selected | coef_prev_contacted | se | ci_low | ci_high | p_value | model_note | df_residual |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| idx_lcc_operational_capacity | Operational capacity | 115 | 0.6782861906354145 | 0.8084242479367689 | 0.13013805449008942 | 0.1307590160288556 | 0.0233359914001027 | 0.08451718837022781 | 0.17700083553791046 | 1.54891284812e-07 | Cross-sectional baseline associations; not causal estimates. | 111 |
| idx_lcc_case_handling_quality | Case-handling quality | 115 | 0.6691372814357922 | 0.7412330494685606 | 0.07209576666355133 | 0.0723909127725405 | 0.0324354503367436 | 0.008117903023958206 | 0.13666392862796783 | 0.0276335367971771 | Cross-sectional baseline associations; not causal estimates. | 111 |
| idx_lcc_legitimacy_and_norms | Legitimacy and reintegration | 115 | 0.6117475141761124 | 0.6348355656320398 | 0.02308805100619793 | 0.023925287751463 | 0.024653485998333 | -0.02492723986506462 | 0.07277781516313553 | 0.3339258666841523 | Cross-sectional baseline associations; not causal estimates. | 111 |
| idx_p1_base_mentor_ready_proxy | Baseline mentor-readiness proxy | 115 | 0.6427177325371773 | 0.7175788391720165 | 0.07486110925674438 | 0.0753517923485101 | 0.0196703019828515 | 0.03637377545237541 | 0.11432980746030807 | 0.0002120617825066 | Cross-sectional baseline associations; not causal estimates. | 111 |
| idx_record_quality | Record quality | 115 | 0.5245644136542275 | 0.7144886363636364 | 0.1899242252111435 | 0.1913353996206353 | 0.0481787522838297 | 0.09586598724126816 | 0.28680482506752014 | 0.0001272769286991 | Cross-sectional baseline associations; not causal estimates. | 111 |
| idx_referral_practice | Referral practice | 115 | 0.615209507205153 | 0.6982999606565996 | 0.08309045433998108 | 0.0850532234853178 | 0.0372079688556646 | 0.01132314931601286 | 0.15878330171108246 | 0.0241592955839613 | Cross-sectional baseline associations; not causal estimates. | 111 |
| idx_safeguards | Safeguards/referral knowledge | 115 | 0.699596782685608 | 0.7593118819323453 | 0.05971509963274002 | 0.050797553231642 | 0.0507967899631682 | -0.049859676510095596 | 0.15145477652549744 | 0.3194782682452041 | Cross-sectional baseline associations; not causal estimates. | 111 |