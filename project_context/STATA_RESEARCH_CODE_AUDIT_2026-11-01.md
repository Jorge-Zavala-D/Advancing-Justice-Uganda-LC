# Advancing Justice Uganda: Stata workflow and reproducibility audit

Date: 2026-11-01. Baseline repository commit: `472029f8d94662049351bf99d270f7a1ecacca08` (`main`). The initial working tree was clean. This is a research-code audit, not approval to release data, a new analysis, or permission to publish. No analytical source, raw data, score, sample, randomization, report, or existing analytical output was changed. Only project instructions and this audit record were written. External reference inputs were retrieved privately into the Dropbox audit folder.

## 1. Verdict and scope

The project has substantial useful safeguards and its current reported index calculations and existing association models reproduce in the bounded checks below. It is **not yet a self-contained, independently runnable replication package**. The main problems concern the execution entry point, unresolved measurement conventions, crosswalk identities, output denominators, privacy boundaries, and release/provenance handling. These are separate from stylistic preferences.

The assumed user is a competent social scientist running one local project, not a multi-user production service. No software test framework, new analysis architecture, new Stata file, or new dependency was added. Recommendations below are scoped research changes, not authorization to implement them.

### What was actually reviewed

The review inventoried all 14 tracked first-party analytical/support source files below. It traced preparation, index construction, current selected-list analysis, origin comparisons, regression exports, administrative and geographic builds, historical QA/presentation code, and the corpus helper. All reported defects were rechecked in short direct source excerpts. Several initial long source responses were lossy; apparent missing syntax was retracted after exact-byte checks. **This is not a certified lossless, independently reviewed reading of every line of every file.** Some analysis/archive sections had broad or compressed views, followed by targeted checks rather than a complete literal reread. No third-party ado library was exhaustively audited.

The full master was **not run**. It has no enabled project steps, references archived files at obsolete locations, and preparation starts with a nonexistent import path and includes the historical sampling draw. Running it unchanged would not constitute a safe clean-session replication. No randomization was executed. No external replication package was executed.

## 2. Fresh verification record

All Stata execution used `stata_run_selection` MCP. Diagnostics used `preserve`/`restore`, temporary variables and temporary result datasets; they did not save over project data or workbooks. This is bounded verification from the current coded inputs, not raw-to-report reproduction.

| Check | Verified result |
|---|---|
| Current coded cohort | 130 observations; canonical LC identifier unique |
| Original selection-frame interviews | 93 observations have `selected_fvl100_observed == 1`; distinguish these interviews from the 100-row roster |
| Previous-contact comparison | 93 selected-list interviews plus 22 legacy records; N=115 |
| Ten core and four higher-level indices | Recomputed the current source-defined row means from existing components; all 14 matched exactly after alignment to the source's float storage, with valid observed scores in [0,1] |
| Seven district-adjusted origin models | Re-estimated the exact current specifications; N and coefficients matched saved outputs, coefficient absolute tolerance 1e-12 |
| Seven multivariable diagnostic models | Re-estimated the exact current specifications; all 42 exported predictor rows matched N/coefficient/robust SE/R-squared |
| Export precision | Absolute tolerance 1e-7 for float-stored SEs, confidence limits and R-squared; this is a storage tolerance, not a substantive equivalence threshold |
| M5_Q15=97 | 23/130 and 15/93 selected-list interviews; all are currently scored zero in `noncomp_response_app` |
| M8_Q08=97 | Zero in the current 130; the problematic handling described below is conditional, not a realized cohort effect |
| M1_Q11=98 | Two in 130; the existing selected-list workbook records one among 93 |
| Other uncertainty codes in full cohort | M8_Q07:5; M10_Q07:9; M11_Q13:3; M11_Q18:3 |
| All-missing component batteries | M1 case types, M5 methods, M7 record types and M11 supports: zero all-missing rows; M7 record fields:17, including14 selected-list interviews |
| M7 structural skip | All17 blank M7_Q06 field batteries have M7_Q01=3, no written case register/book |
| Conditional observation denominator | `record_seen_score_m2` N=77 within the93 selected-list interviews |
| Crosswalk alias | Saved crosswalk contains Kibaare A observed/final=1, Kibaare I observed/final=0, and Kibaare II observed/final=1 |
| Native candidate geography | 130 coverage records; 51 unresolved have all seven neighborhood counts missing; 8,403 unique candidate pairs, all unreleased/not approved |

The existing Section10 workbook was also read back: 72 metric rows have N plus missing N equal to93; totals agree with mean times N within1e-5. The67 variables also present in the all-item numeric summary have matching N/means within1e-8. These are **agreement checks between exports**, not independent validation of every indicator definition against raw data or the formal Scope of Work.

An early diagnostic used an absent score variable and stopped; the preserved data were restored. An initial model comparison also stopped because the audit's temporary posted values defaulted to float. Storage types were inspected and the comparison was rerun with explicit double fields and the declared export tolerances; all comparisons above then passed. Neither event was a project-code defect or a scientific change.

Current data/output fingerprints (SHA-256):

- `phase1_baseline_analysis.dta`: `dde25a5c99391e3fd29a755ed237e561c3d265af5af30e0709e478926d11a731`
- `phase1_baseline_selected100_frame.dta`: `c1b04869a3ea8de6c072b671e35f3b7c06ceab57e5e26ca6a81b4b10df72ab00`
- `phase1_baseline_regression_results.xlsx`: `d5ce93f4990ad1b2e454c7442fb016b46a9da97a43e0278699e3bd52122ecd82`

These identify the audited artifacts. They do not, by themselves, prove that a fresh entry-point run recreates them.

## 3. Ranked findings

### Must resolve before claiming independent replication or public release

### F01. The documented master is not a complete runnable entry point

**Evidence:** `0 Master Code_AdvJusticeUganda.do:35–46,58–77`; `1 Data Preparation_AdvJusticeUganda.do:29`; root README. Every project call is guarded by `if (0)`. Four calls point to root-level files now under `archive/`. Phase2 entry points are absent. The README links the old QA path and expected128 convention. The first preparation import uses `${input_dir}/Secondary data/...`; that path does not exist locally, while the source exists under `${input_dir}/1 Raw/Secondary data/...`. Only the named author account has populated paths.

**Consequence:** A clean master can finish without producing research results, or fail at the first enabled preparation step. Existing successful outputs are not evidence that this entry point reproduces them.

**Smallest correction:** Document one simple, portable root configuration and explicit supported execution order. Correct actual paths and distinguish historical sampling, current baseline preparation/analysis, and Phase2 geography. Do not simply enable the whole preparation file, since it includes the historical draw. Keep archived work preserved but outside the release sequence.

**Status:** Confirmed source/path defect. No clean master execution was attempted.

### F02. M5 non-occurrence is scored as inappropriate behavior

**Evidence:** preparation `:2118`; English `phase_1_baseline_version 2.xlsx`, survey122 and choices505; fielded Runyankore `phase_1_baseline_version_Runyankore_Edited.xlsx`, survey124 and choices501. Both define M5_Q15=97 as “This has not happened recently.” Code includes97 in the scored universe and maps it to0.

**Consequence:** The ADR index treats lack of a recent noncompliance incident as an inappropriate response. This affects23 current records,15 in the primary93. It is not merely the already-approved M5_Q14/M5_Q16 label correction.

**Smallest correction:** First settle and document whether this index targets demonstrated responses conditional on an incident or a broader capacity convention. A missing/nonapplicable treatment is a plausible correction, but it changes scores and must be explicitly approved. Quantify and reproduce all affected indices/outputs before any promotion.

**Status:** Questionnaire meaning and occurrence confirmed. No rescoring implemented.

### F03. Several unknown responses are treated as negative factual/practice answers

**Evidence:** preparation `:1849,1877,2260,2372,2456,2484`. Both XLSForms distinguish98 “do not know/cannot remember” from0/no. For example, prior training has two unknown responses in130, one in the selected93; safeguards special handling has nine unknowns in130 and five in the selected workbook.

**Consequence:** Unknown training status becomes “no prior training” in the capacity index and model controls; uncertainty in other domains becomes a negative practice/norm response. This can change both index denominators and models. Coding DK as incorrect on an objective knowledge test is a different decision and is not automatically a defect.

**Smallest correction:** Make the construct-specific rule explicit, preserve raw98, and separately approve any change to missing versus zero. Do not globally recode all DK responses or silently change historical results.

**Status:** Current occurrences confirmed; numerical effect of alternative scoring was not estimated.

### F04. A canonical spelling correction creates a misleading historical crosswalk slot

**Evidence:** preparation `:1588–1591` changes matched Kibaare I to canonical Kibaare A. At `:1760–1794`, the FVL half rebuilds its key from historical names, appends the observed half, and deduplicates by the resulting different key. Stata verified both the unobserved I and observed A rows.

**Consequence:** The crosswalk can describe one historical selection identity as an unobserved slot plus an additional observed canonical LC. This is not proof that the separate100-row frame or the130-row analytical cohort is wrong; the defect is the crosswalk representation and its downstream interpretation.

**Smallest correction:** Retain the historical frame UID as a separate key and explicitly bridge it to the approved canonical UID. Do not undo approved aliases or deduplicate on name resemblance.

**Status:** Observed artifact inconsistency confirmed.

### F05. Publication/privacy boundaries are not established by dropping six fields

**Evidence:** preparation `:2673–2688` drops/asserts a fixed list of six direct identifiers, while retaining exact LC geography, submission keys and free-text fields. Archived presentation code `archive/5 QA Presentation Assets...:171–182` retains `qa_enumerator` while adding an anonymous-looking enumerator ID. The tracked local `assets/enumerator_summary.csv` header confirms both fields remain.

**Consequence:** These outputs are linkable/pseudonymized; “de-identified” or “anonymous” is not a disclosure assessment. No finding is made that any particular retained free-text cell contains PII or that material was externally disclosed.

**Smallest correction:** Define a restricted analytical boundary and a separate publication extract/field review. For any authorized reuse of the archive export, remove the original enumerator identifier from the public-facing asset. Review repository/history exposure before publication; do not delete or rewrite history without approval.

**Status:** Schema/export risk confirmed, not a confirmed breach. A header/content screen of one converted raw-data Markdown found neither the named direct-identifier fields nor the tested phone pattern; that is not a general privacy clearance.

### F06. Accepted inputs and outputs may be overwritten before drift is detected

**Evidence:** administrative Python `:122–124` writes a downloaded PDF before verifying its hash; administrative Stata `:17–38` replaces exported source snapshots before the companion checks pins. Geographic M6 Python `:2072–2073,2202–2207` deletes/replaces output before comparing the prior receipt. M7 `:2474–2478,2798–2820,2831–2835` checks prior inputs, writes new products/new manifest, then verifies against the new receipt rather than first validating the old accepted products. Preparation writes READY only after replacing outputs `:2667–2918`. Analysis `:3565–3590` publishes workbooks and figures sequentially.

**Consequence:** A failed rerun can leave stale READY text or mixed-vintage artifacts; altered accepted artifacts can be overwritten before custody checks run. This is a conditional workflow defect, not evidence that current results are mixed or corrupted.

**Smallest correction:** Verify the accepted receipt before writes, hash downloaded payloads before promoting them, use fresh per-run staging, and write a completed-run status/manifest only after all required outputs validate. Keep this to direct checks and a clear promotion block, not a general transaction framework.

**Status:** Source-level failure paths confirmed; no destructive test performed.

### Should resolve in the next bounded maintenance pass

### F07. Table denominators are not always item denominators

**Evidence:** analysis `:1003–1006,1037–1040,1066–1070` and similar later comparison blocks collapse many means while attaching a single count of an index. The selected index N is93 but `record_seen_score_m2` has N77. Case-type options use the positive-caseload answered universe N65, whereas zero-inclusive `any_child_or_sgbv_case_3m` has N91; `any_reintegration_case_3m` remains N65.

**Consequence:** A generic n can imply that a conditional/verified mean covers every LC. Related exposure measures can appear comparable despite different universes.

**Smallest correction:** Export measure-specific Ns or explicitly label the count as group/index N, and state each conditional universe in captions/notes. Do not fill nonanswers with zero merely to align denominators.

**Status:** Current data/output denominator differences confirmed.

### F08. Measurement conventions and labels need an explicit distinction

**Evidence:** preparation `:2198–2200` assigns0 to the all-missing record-field battery; both forms route M7_Q06 only to M7_Q01=1/2. All17 blank batteries actually have Q01=3. This can be an explicit capacity penalty for no register, but it is not twelve observed “no” responses. M7_Q03 also allows other written records. Separately, preparation `:2265` describes women's perspectives “where no women serve,” while both forms route M8_Q07 when M2_Q05>0. Analysis `:253` already uses a neutral, more accurate output label.

M8_Q08=97 means records are never signed/validated (English choices795, Runyankore791), but preparation `:2261` leaves it missing. There are **zero current cases**, so this last issue has no demonstrated current index effect.

**Smallest correction:** Document the conditional-quality versus no-register-capacity estimand; harmonize the coded-data and output labels; settle future97 handling through an approved scoring decision. Do not change scores as cosmetic cleanup.

**Status:** Routing, source labels and current frequencies confirmed. Raw zero/missing policy requires PI decision.

### F09. The environment is not frozen by `version 19`

**Evidence:** master `:54–67` sets a PLUS path and attempts unversioned SSC installs while continuing on failure. Current MCP inspection found Stata19, packages resolving across project/user/system locations, and no installed command under `randomize`, `randtreat`, or `sumstats`; other named commands and plotplain were found. The geographic worker `:306–315` can invoke uv dependency/Python resolution without an offline constraint.

**Consequence:** A different machine can obtain different ado versions or attempt network access in a nominal offline build. Some installed package names may not be required by the active workflow.

**Smallest correction:** Separate one-time setup from routine execution, document only actual dependencies and exact versions/source hashes, fail clearly if consequential dependencies are absent, and use a pre-provisioned pinned GIS worker for offline reproduction. Do not install a new package just to resemble an institutional template.

**Status:** Current dependency lookup and source behavior checked, not a fresh-machine execution.

### F10. Historical sampling lacks a unique stable order before its first draw

**Evidence:** preparation `:251–254` sets seed26042026 then draws a village uniform after quota merges, without an explicit unique-village sort immediately before it. No unique village-key assertion appears before this draw. District largest-remainder ties are, positively, broken by district ID at `:167–168`; the second draw has an explicit order at `:260–261`.

**Consequence:** The same seed need not attach the same draw to each village if upstream row/merge ordering changes. This is not evidence that the realized historical selection was invalid.

**Smallest correction:** Preserve the realized assignment and its original inputs/results as frozen research history. For any separately authorized future draw, establish a unique key and deterministic order first. Do not rerun or retroactively alter the Phase1 assignment.

**Status:** Static risk only; no stochastic operation executed.

### F11. Some data-preservation descriptions are stronger than the code

**Evidence:** preparation normalizes/destrings all imported strings `:1252–1265` before saving the “raw/lossless” archive at `:1429`. It later overwrites split training items `:1808–1811` and negative raw caseload responses `:1952–1956`.

**Consequence:** The original input files remain raw authorities, but this derived archive and these retained fields are not necessarily lossless copies of source values. This matters when auditing corrections and missingness.

**Smallest correction:** Use accurate imported/normalized archive terminology and clone original variables before consequential transformations. An approved change should compare source values/missingness and all downstream outputs, not silently rewrite earlier archives.

**Status:** Transformations confirmed; no claim that source delivery files were overwritten.

### F12. Geographic provenance/permissions metadata have not incorporated UBOS's clarification

**Evidence:** geographic Python `:2813` and Stata map note `:236` still say the reference date is pending. Dennis's19 October email confirms **30 April2024**, LC1 level, and restricted LC1 redistribution; parish and higher administrative levels are described as unrestricted. Detailed LC1 permission conditions remain unspecified.

**Consequence:** Output metadata are stale, and absence of a date must not be confused with absence of LC1 geometry. Conversely, confirmed source vintage is not proof of current2026 boundary equivalence or neighbor eligibility.

**Smallest correction:** Update metadata/map notes consistently in an authorized provenance-only pass. Keep restricted LC1 sources out of a public deposit pending written permission clarification; document access procedures. This email does not solve the51 outstanding identities or adjoining-district coverage.

**Status:** Confirmed stale documentation; no new outreach or metadata mutation in this audit.

### F13. Missing-count guards test “any missing” rather than “all missing”

**Evidence:** geographic Stata `:158` uses `missing(candidate_count,queen_exact_n,rook_exact_n)`, which is true if any argument is missing, not necessarily all. A similar pattern occurs at `:488`. Official Stata programming-function documentation confirms this behavior.

**Consequence:** A corrupt unresolved row with one missing count and another filled zero can pass; four distance-band counts are omitted from the first guard. Current native data pass the stronger check: all seven are missing for all51 unresolved anchors.

**Smallest correction:** Assert each relevant count is missing for unresolved geography using one clear foreach list; retain current missing rather than zero semantics.

**Status:** Guard defect confirmed; no current bad counts observed.

### F14. Figure/data traceability and publication inventory need tightening

**Evidence:** analysis `:1147–1174` exports item-level `vignette_performance` then overwrites fig13 with four scenario-level averages without a matching scenario sheet. Fixed temp figure directory and wildcard copy at `:56–64,3572–3579` can republish stale files. The purported all-item scope `:1501–1518` omits five Section10 variables: caseload_30d, caseload_3m, conf_trust_when_referring, reint_comm_justice_role, recent_reintegration_issue. Fig30/31 `:1473–1492` lack the part–whole caution correctly present on Fig29. Unmeasured remand indicator units differ at `:2965–2967` versus `:3518–3520`.

**Consequence:** A reader may not be able to match one chart to its underlying workbook rows or may reuse an incomplete/uncaveated asset. This does not establish wrong vignette averages or stale current figures.

**Smallest correction:** Export the final four scenario statistics with Ns, publish an explicit file inventory from a fresh staging directory, accurately define all-item scope, add the part–whole note, and reconcile the formal unit against the SOW. Do not add a new graph family or change statistical content.

**Status:** Source/output mapping issues confirmed; no report rewrite performed.

### F15. Archived QA/presentation code must not be treated as the current release workflow

**Evidence:** archived QA `:455–463` uses `count if tag`, so missing tags are counted as true; `:161–174` can count numerator outside eligibility and label zero-tested checks PASS; `:336–344` can turn blank geography into separator-only keys; `:677–683` misses some nested interview overlaps; `:969–976` treats a pending stock greater than recent inflow as an error; several optional-field checks can be omitted. Archived presentation `:294–313` hard-codes BLOCKED/128 and uses source-record minus target arithmetic. Archived regression files use broader historical “new” definitions, survey geography and village clustering rather than the active selected-list comparison.

**Consequence:** Re-enabling obsolete scripts can generate misleading gates, denominators, sample comparisons or privacy claims. These are archived conditional defects, not demonstrated errors in the active current regression results.

**Smallest correction:** Keep this history clearly outside the release entry point. If a specific archived feature is reused, fix its exact research logic and validate a small counterexample; do not resurrect old128/treatment-timing gates.

**Status:** Exact source checks; archive outputs not regenerated.

### F16. Corpus snapshot output can contaminate its own source inventory

**Evidence:** `build_dropbox_corpus_snapshot.py:229–236,255–266` permits an output directory inside the scanned source root, then writes fixed output filenames after the inventory while claiming no source mutation.

**Consequence:** Such an invocation changes the scanned corpus; a rerun can inventory its own generated files. Path/schema metadata may also be sensitive even without copying raw rows.

**Smallest correction:** Require output outside the source root, or explicitly exclude/stage generated artifacts and accurately document writes. Keep internal corpus inventories out of a public release unless reviewed.

**Status:** Conditional invocation defect; no corpus rebuild performed.

## 4. Positive findings and scientific definitions preserved

- The current primary analysis distinguishes the original100 selection frame from observed interviews and from administrative previous contact. Legacy provenance is not randomized treatment.
- Current comparisons use canonical district and heteroskedasticity-robust SEs; the14 existing model specifications reproduced. The seven multivariable outcomes exclude respondent capacity, which contains several predictors, so the reviewed specifications do not directly regress that index on its own components.
- Seven multivariable outcomes are legal knowledge, ADR, records, committee, perceived legitimacy, safeguards and reintegration. Predictors are sex, education, LC experience, prior training, prior formal coordination, administrative origin, and canonical district FE. No new causal interpretation is warranted.
- Available components are equally weighted within each current rowmean; nested composites do not give every underlying questionnaire item identical weight. Minimum coverage is one observed component. This policy should be documented, not retroactively replaced by an arbitrary threshold.
- The14 stored indices align with current construction. This does not validate every component's substantive scoring rule.
- The expanded referral plot labels separate cross-sectional measures, displays varying denominators, and does not establish a longitudinal referral funnel.
- Phase2 files distinguish source links, historical/OSM context and unapproved candidates; no accepted neighbor ownership, mentor eligibility or treatment wave is fabricated. Existing51 unresolved anchors retain missing counts rather than zeros.
- No reported substantive conclusion here is based on isolated p-values, and baseline origin associations remain noncausal.
- Original input deliveries remain in Dropbox. This audit did not overwrite them, rerun historical selection, change the baseline cohort, or refresh the accepted report.

### Core/composite component map

This map is extracted from the current preparation source and was used for the mechanical rowmean comparison. It is not a new specification.

| Index | Current rowmean components |
|---|---|
| `idx_respondent_capacity` | `lc_experience_score`, `education_score`, `record_literacy_score`, `prior_justice_training`, `prior_formal_coordination`, `case_experience_score`, `weekly_lc_time_score` |
| `idx_institutional_functioning` | `meeting_frequency_score`, `quorum_score`, `fixed_place_score`, `inst_record_exist_score`, `inst_record_uptodate_score`, `materials_score`, `record_seen_score_m2`, `recent_entries_uptodate_score_m2` |
| `idx_legal_classif_knowledge` | `m4_q01_local_scope_score`, `m4_q02_referral_scope_score`, `m4_q04_correct_refer`, `m4_q05_documentation_score`, `m4_q06_procedure_score`, `m4_q07_correct_adr_scope`, `m4_q08_authority_score`, `idx_vignette_classification` |
| `idx_adr_mediation_practice` | `m5_q01_score`, `m5_q02_score`, `m5_q03_score`, `m5_q06_score`, `m5_q07_score`, `adr_confidence_score`, `deescalation_confidence_score`, `m5_q14_score`, `noncomp_response_app`, `m5_q16_score`, `adr_methods_score` |
| `idx_referral_practice` | `referral_frequency_score`, `referral_documentation_score`, `referral_feedback_score`, `police_coordination_score`, `court_coordination_score`, `referral_path_conf_score`, `referral_explain_conf_score`, `verified_referral_record_score`, `verified_ref_dest_score` |
| `idx_record_quality` | `case_register_score`, `record_type_breadth_score`, `record_uptodate_score`, `most_recent_entry_score`, `record_fields_score`, `outcome_recorded_score`, `record_retrieval_score`, `secure_storage_score`, `verified_case_register_score`, `verified_proceedings_score`, `verified_storage_score`, `verified_record_usability_score` |
| `idx_committee_functioning` | `collective_handling_score`, `active_member_part_score`, `collective_discussion_score`, `women_participation_score`, `women_perspective_mechanism`, `record_validation_score`, `case_review_score`, `decision_process_score`, `similar_case_consistency_score`, `procedure_confidence_score`, `verified_member_part_score`, `verified_multimember_val_score` |
| `idx_perceived_legitimacy` | `perceived_lcc_fairness_score`, `perc_willing_use_lcc_score`, `low_bypass_score`, `low_favoritism_influence_score`, `conf_trust_when_referring`, `conf_fair_respect_score` |
| `idx_safeguards` | `idx_safeguard_classif_know`, `vulnerable_need_sh` |
| `idx_reintegration_norms` | `reintegration_importance_score`, `reintegration_willingness_score`, `fair_chance_reintegration_score`, `low_exclusion_norm_score`, `low_reoffending_stigma_score`, `comm_role_reint_score`, `reint_mediation_comfort`, `connect_support_willing_score`, `reint_support_breadth_score`, `reint_tension_conf_score`, `reint_referral_conf_score`, `reint_comm_justice_role`, `reint_leadership_role_score` |
| `idx_lcc_operational_capacity` | `idx_institutional_functioning`, `idx_record_quality`, `idx_committee_functioning` |
| `idx_lcc_case_handling_quality` | `idx_legal_classif_knowledge`, `idx_adr_mediation_practice`, `idx_referral_practice`, `idx_safeguards` |
| `idx_lcc_legitimacy_and_norms` | `idx_perceived_legitimacy`, `idx_reintegration_norms` |
| `idx_p1_base_mentor_ready_proxy` | `idx_respondent_capacity`, `idx_lcc_operational_capacity`, `idx_lcc_case_handling_quality`, `idx_lcc_legitimacy_and_norms` |

## 5. Code-to-output map

Paths below are project-relative. DROPBOX denotes the private project root; source data and source-dependent geographic products are not automatically public redistribution material.

| Script | Inputs / research role | Main products / consumers |
|---|---|---|
| 0 Master Code | Roots, Stata version, package lookup, disabled switches | Intended coordinator; current limitations in F01/F09 |
| 1 Data Preparation | Historical police-case frame; original and August surveys; FVL/tracker/geographic/election reconciliations | Working archives/lineage/crosswalk; coded130 cohort and separate100-row frame; reconciliation workbook |
| 2 Data Analysis | Coded cohort, selected-list/legacy flags, locked indices | Selected100_Observed workbooks, existing figure library,14 model specifications and Section10 outputs |
| 5 Phase2 Administrative .do/.py | Source administrative lists and project geographic snapshots | Administrative village frame, source crosswalks/manifests and review workbook |
| 6 Phase2 Geospatial .do/.py | Pinned historic/current sources, project identities, explicit desk decisions | Native Stata attributes/coordinates, source-link ledger, coverage, candidate pairs and maps; not random assignment |
| 6 Phase2 Geospatial Review.mjs | Existing source/review tables | Editable administrative/geographic review workbook; does not turn candidate names into approvals |
| build_dropbox_corpus_snapshot.py | Source inventory/profiles | Internal corpus metadata, not analytical observations |
| archive/3 QA | Historical cleaned/raw inputs | Historical issue/gate/check workbooks and flagged microdata; not current release authority |
| archive/4 and archive/6 regressions | Historical broad cohort | Exploratory historical models/figures, not active selected-list estimand |
| archive/5 presentation | Historical QA outputs | Assets/deck metrics; includes obsolete128/BLOCKED assumptions |
| QA presentation.qmd | Historical static narrative and existing assets | Historical presentation, not a dynamic current-data baseline report |

The current report is a separate edited Word artifact. This audit did not verify every Word table, caption or manually edited claim against the code and should not be presented as a final report audit.

## 6. External replication-package review

**Stages are distinct:** located; code inspected; logic traced to an output; executed. None of the external packages below was executed. Versions/access dates refer to the retrieved records, not a claim that an author website's working files are byte-identical to a journal deposit. Retrieval date:2026-11-01.

Privately retained reference inputs: DROPBOX/4 Deliverables and Presentations/Research Code Audit/2026-11-01/reference_packages/. These are reference materials, not adopted project dependencies. Main-session repeat Dataverse API requests were403; the package inspection relied on the downloaded inputs and records retrieved during the review, not a claim that every landing page was independently accessible twice.

| Study / authoritative route | Version / status | Actual code and output trace | Adopt / do not transplant |
|---|---|---|---|
| Blattman, Hartman & Blair2014, Liberia ADR; [article DOI](https://doi.org/10.1017/S0003055413000543), [Dataverse UNO6QU](https://doi.org/10.7910/DVN/UNO6QU), [author archive](https://chrisblattman.com/documents/data/liberia/BlattmanHartmanBlair2014.APSR.Replication.zip) | Dataverse v1.1 located but guestbook blocked download; author archive inspected/traced, not executed; author-archive license and byte-equivalence unverified | The archive's single Stata table script,1,700+ lines; Table2 block816–828 specifies weighted community-PSU/county-stratified 2SLS; appendix balance and robustness blocks inspected | Adopt explicit design and table sections; do not import IV, weights or clustering into Uganda without its own design justification |
| Krakowski & Kursani, Kosovo informal-justice vignettes; [KD3ZUN](https://doi.org/10.7910/DVN/KD3ZUN), article10.1017/XPS.2023.18 | v1.0; code inspected/traced, not executed; Dataverse metadata reportsCC0 | 1_main_survey.do, 2_news_data.do, 3_asian_barometer.do,4_pakistan.do; main Figure1/TableA1 block380–402, reshaping four scenarios to analysis observations; README says TableA12 source data unavailable | Adopt separate-case output traces; reject forced merge without diagnostics and a >1 recode that includes Stata missing values |
| Engineering informal institutions: Long run impacts of alternative dispute resolution on violence and property rights in Liberia, related supplement outside bibliography; [MN1OON](https://doi.org/10.7910/DVN/MN1OON) | v1.1; code inspected/traced, not executed; metadata reportsCC0 | master.do → import_clean_construct.do/reshape → analysis.do → set_outcomes and ate_maker_year.do; wave-specific samples, controls, attrition/balance; index helper342–359 inspected | Adopt visible stage/outcome/sample connections; median imputation, standardization and ATE wrappers are study-specific, not recommendations to alter Uganda scores |
| Blair/Karim/Morse2019, Establishing the Rule of Law in Weak and War-Torn States, related supplement outside bibliography; [ZIXH95](https://doi.org/10.7910/DVN/ZIXH95) | v1.0; cleaning/analysis/output archives inspected/traced, not executed; metadata reportsCC0 | endline_clean.do includes rowtotal,missing at520; cp_analysis_paper.do Figures1–3/Table3; cp_crime_analysis_paper.do43–66 produces Table1.tex with assignment weights, town clustering and patrol-block FE; output Table1.tex inspected | Adopt explicit forum-specific outcomes and denominators; reject copying the study's missing-tribe assumption at158 or its design-specific weighting/clustering |
| Paluck & Green2009, Deference, Dissent, and Dispute Resolution: An Experimental Intervention Using Mass Media to Change Norms and Behavior in Rwanda; [article](https://doi.org/10.1017/S0003055409990128), [Yale Dataverse ZSJNYI](https://doi.org/10.60600/YU/ZSJNYI) | v2.0, released2026-04-08; two Stata files inspected/traced, not executed; repository explicitly reports CC0 1.0 | PaluckGreen_APSR_2009.do lines9–13 construct social-distance and reverse-dissent measures; lines17–21 Table3 ordered probit and25–29 Table4 regressions expose assignment, matched sites, covariates and site-clustered SEs; PaluckGreen_APSR_2009_table_5.do uses ranksum/signrank after site-pair aggregation | Adopt visible pairing/clustering and distinct sensitivity specifications; do not copy positional variable ranges, implicit rowmean missingness, or design-specific estimators into Uganda |
| Baird et al.2018, randomized saturation design; [V50EKE](https://doi.org/10.7910/DVN/V50EKE) | v1.2 located; MATLAB methods code, not a Stata package inspection | .m design/power implementation identified; not executed | Relevant future interference/design reference, not Stata style evidence or a locked Phase2 design |
| Callaway & Sant'Anna2021 | [Author software](https://psantanna.com/software/) located; R did implementation, not inspected paper replication | No claim that locating software establishes a published replication package or Stata inspection | Do not substitute observational staggered-DiD code for the planned mentor RCT |

The original2014 author archive SHA-256 is `f8c0e87965922acbe41f759eff39c239654f6d278008e5859664ee11111b0e28`. Exact retained file names include `KD3ZUN_1_main_survey.do` through `KD3ZUN_4_pakistan.do`, `KD3ZUN_README.txt`, `MN1OON_liberia_enlinde2_dataverse.zip`, and the three `ZIXH95_*.zip` archives plus its README. No public redistribution of the author archive is inferred.

The two retained Yale files are `ZSJNYI_PaluckGreen_APSR_2009.do` ([datafile42274](https://dataverse.yale.edu/api/access/datafile/42274), SHA-256 `bdf4c938b47797a9c45339a98bf7a49814071a664c3e82010f6d214ea8a985cf`) and `ZSJNYI_PaluckGreen_APSR_2009_table_5.do` ([datafile42267](https://dataverse.yale.edu/api/access/datafile/42267), SHA-256 `0d0abbf9568d9e7b455b7db60f6c884ca25fd273bad77b041040afd80b80d165`). They were read, not run.

### Complete bibliography screening register

Source: current Dropbox `1 Literature/Uganda Advancing Justice.bib`,41 entries, checked alongside Literature Review.docx. The blanket spillover-robust ITT wording in the review is not a safe general causal claim: under interference the estimand depends on design/exposure. This is a conceptual note for future Phase2 design, not a change to the descriptive baseline.

**I/T**=actual Stata files inspected and output logic traced; **M**=non-Stata methods code located; **R**=author R software located, not a paper-package review; **H**=no verified same-title package from the initial exact-title Harvard Dataverse screen. H is **not** proof of absence, restriction or lack of Stata elsewhere. A subsequent publisher/author/institutional review of the priority empirical entries identified the Yale Paluck/Green package and the Worden/McLean restricted SPSS archive, and clarified software for several others. Many remaining entries are theory, legal/qualitative work or reviews; a full author/publisher/repository search for every H item remains unfinished. Overall, five empirical Stata packages were inspected and traced, three from the current bibliography and two closely related supplements; none was executed.

| BibTeX key | Status |
|---|---|
| `albezreh_multiyear_2022` | Publisher reports SPSS25 pre/post analysis and an assessment supplement; replication code/data availability unresolved, no code inspected |
| `baird_optimal_2018` | M; MATLAB; not executed |
| `cooper-knock_summons_2020` | H; not a negative availability determination |
| `macdonald_maybe_2022` | H; not a negative availability determination |
| `rockowitz_systematic_2024` | H; not a negative availability determination |
| `owor_creating_2012` | H; not a negative availability determination |
| `oluoch_legitimacy_2009` | H; not a negative availability determination |
| `maraire_pursuit_2025` | H; not a negative availability determination |
| `engle_merry_legal_1988` | H; not a negative availability determination |
| `woodman_legal_1996` | H; not a negative availability determination |
| `grande_alternative_1999` | H; not a negative availability determination |
| `mennen_lessons_2010` | H; not a negative availability determination |
| `pimentel_rule_2010` | H; not a negative availability determination |
| `maru_access_2010` | H; not a negative availability determination |
| `swenson_promise_2018` | H; not a negative availability determination |
| `banik_legal_2009` | H; not a negative availability determination |
| `khair_evaluating_2009` | H; not a negative availability determination |
| `stephens_commission_2009` | H; not a negative availability determination |
| `tyler_what_1988` | H; not a negative availability determination |
| `tyler_procedural_2017` | H; not a negative availability determination |
| `menkel-meadow_restorative_2007` | H; not a negative availability determination |
| `braithwaite_street-level_2021` | H; not a negative availability determination |
| `pavlich_power_1996` | H; not a negative availability determination |
| `wright_mediation_2024` | Publisher abstract describes doctrinal/legal analysis, not a quantitative trial; no empirical package inspected |
| `grajzl_does_2026` | Publisher describes authorized research access to anonymized court data; public distribution/code terms and software unresolved, no code inspected |
| `otsuka_role_2023` | H; not a negative availability determination |
| `blattman_how_2014` | I/T; not executed |
| `esposito_public_2025` | H; not a negative availability determination |
| `paluck_deference_2009` | I/T; Yale Dataverse ZSJNYI v2.0, two Stata files; not executed |
| `krakowski_why_2024` | I/T; not executed |
| `sherman_twelve_2015` | H; not a negative availability determination |
| `beckman_reducing_2024` | Publisher abstract inspected; full-text access blocked, software and package availability unresolved |
| `mccart_randomized_2022` | Full-text methods explicitly report SPSS for GLM and Cox analyses; no package located, availability unresolved |
| `factor_effect_2026` | Publisher explicitly reports Stata for matching; no replication code located, availability unresolved; confidentiality of some dates does not establish blanket data restriction |
| `creutzfeldt_dispute_2016` | H; not a negative availability determination |
| `read_village_2018` | H; not a negative availability determination |
| `hussey_design_2007` | H; not a negative availability determination |
| `callaway_difference--differences_2021` | R; software located only |
| `worden_measuring_2018` | ICPSR35467 v1, released2017-12-14, describes seven SPSS data and six syntax files plus table-to-syntax PDF; restricted-data agreement and IRB approval/exemption required; no access requested, no code inspected |
| `aronow_estimating_2017` | H; not a negative availability determination |
| `jackson_norms_2018` | H; not a negative availability determination |

Primary routes for the deeper priority screen (access2026-11-01): [Worden/McLean publisher](https://journals.sagepub.com/doi/10.1177/0887403416662505) and [ICPSR35467](https://www.icpsr.umich.edu/web/NACJD/studies/35467/publications); [Albezreh publisher](https://journals.sagepub.com/doi/10.1177/10778012221099984); [Wright publisher](https://doi.org/10.1017/S0021855324000172); [Grajzl/Cepec/Morec publisher](https://www.sciencedirect.com/science/article/pii/S0144818825000638); [McCart full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC8967213/), methods2.5.1.1 and2.5.2; [Factor publisher](https://journals.sagepub.com/doi/10.1177/00938548251372899); [Beckman publisher abstract](https://journals.sagepub.com/doi/abs/10.1177/00111287231158569?journalCode=cadc). Restricted archive records are not equivalent to having inspected restricted code. An unlocated data-availability statement is not proof that data or code do not exist.

## 7. Guides and templates actually consulted

Access date2026-11-01. These are selected resources/sections, not an exhaustive review of each institution's entire training library. Journal requirements apply only when that journal's submission rules govern; institutional recommendations and author style preferences are not automatically project mandates. The user's research-code standards govern this project.

| Resource / primary source | Scope examined / access limit | Concrete project implication |
|---|---|---|
| [DIME Handbook, reproducibility](https://worldbank.github.io/dime-data-handbook/reproducibility.html), [analysis](https://worldbank.github.io/dime-data-handbook/analysis.html), [publication](https://worldbank.github.io/dime-data-handbook/publication.html) | Selected workflow, construction, publication/dependency sections; not the whole book | Explicit raw-to-output lineage, clear assumptions, freeze dependencies and compare intended outputs; preserve the existing project organization |
| [DIME Analytics Coding Guide and Stata Style Guide](https://worldbank.github.io/dime-data-handbook/coding.html) | AppendixA principles and Stata sections | Readable variable lists/macros, coherent task sections and consequential comments; no mechanical reformatting or needless helper programs |
| [DIME standards repository](https://github.com/worldbank/dime-standards) | Repository/resource overview; not every linked document | Use as a standards reference, not an instruction to import a complete institutional framework |
| [DIME Wiki reproducible research](https://dimewiki.worldbank.org/Reproducible_Research) | Search-index content located; direct fetch403 | Do not claim full-page inspection; use the accessible Handbook for the substantive recommendations |
| [World Bank repository](https://reproducibility.worldbank.org/), [author guidance](https://worldbank.github.io/wb-reproducible-research-repository/guidance_note_wb.html), [checklist](https://github.com/worldbank/wb-reproducible-research-repository/blob/main/reproducibility_package_checklist.md), [review protocol](https://worldbank.github.io/wb-reproducible-research-repository/reproducibility_reviewer_protocol.html) | Guidance/checklist and selected protocol sections on completeness, environment, restricted access and output matching; landing page initially unrendered | Separate completeness/stability/manuscript-consistency checks from scientific validity; do not assert complete replication from individual successful scripts |
| [J-PAL cleaning and management](https://www.povertyactionlab.org/resource/data-cleaning-and-management) | File/code organization, IDs/merge diagnostics, unknowns and de-identification | Preserve originals; explicit keys and correction provenance; distinguish missing/not applicable from zero; don't import merge m:m |
| [J-PAL randomized-evaluation coding resources](https://www.povertyactionlab.org/resource/coding-resources-randomized-evaluations) | Resource and randomization-code guidance; linked training directory was inaccessible through browser | Fixed seeds need stable order; no claim that the linked exercise was executed or that Phase1 should be redrawn |
| [J-PAL data publication](https://www.povertyactionlab.org/resource/data-publication) | Selected publication/restriction documentation | Source/permission/access statements and disclosure review precede any public deposit |
| [IPA cleaning guide](https://data.poverty-action.org/data-cleaning/) and [practical-guide index](https://data.poverty-action.org/how-to-guides.html) | Cleaning stages/missingness/identification and practical-resource index, not all30 linked guides | Keep institutional recommendations proportionate; no new monitoring/software framework is needed for this audit |
| [IPA coding in Stata](https://data.poverty-action.org/software/stata/coding-stata.html), [2015 data/code management guide](https://poverty-action.org/sites/default/files/publications/IPA-Best-Practices-for-Data-and-Code-Management-Nov-2015.pdf) | Coding/organization/standard missingness/security sections | Explicit inputs/outputs and labels; extended missings can retain meaning, but changing existing scores needs separate approval; old guide recommendations are not all current mandatory policy |
| [IPA Stata template](https://github.com/PovertyAction/ipa-stata-template), actual [00_run.do](https://raw.githubusercontent.com/PovertyAction/ipa-stata-template/main/do_files/00_run.do) and [functions.do](https://raw.githubusercontent.com/PovertyAction/ipa-stata-template/main/do_files/functions.do) | Actual master root/setup/path/sequence code and key-check/regression-helper sections, not execution of the template | Adopt visible roots and setup checks; do not copy the generic regression wrapper, SCons/just infrastructure or all-global/path conventions merely because the template uses them |
| [IPA cfout](https://github.com/PovertyAction/cfout), [certification do-file](https://raw.githubusercontent.com/PovertyAction/cfout/master/cscript/cfout.do) | Help plus initial certification cases for IDs, mismatches and types; not all2259 lines or execution | Use identifier-aligned comparisons; cfout optional, not installed by this audit; native cf/assert may suffice |
| [Sean Higgins Stata Guide](https://github.com/skhiggins/Stata_guide), actual [README/code guide](https://raw.githubusercontent.com/skhiggins/Stata_guide/main/README.md) | Style/path/script separation and master-example guidance, not every linked package | Centralize roots, keep archived code separate, make output correspondence clear; recommendations such as reghdfe are not necessary for three district FE |
| [AEA data/code policy](https://www.aeaweb.org/journals/data), [step-by-step guidance](https://aeadataeditor.github.io/aea-de-guidance/) | Policy, restricted-access documentation and preparation/verification overview; not an AEA submission audit | Use a real execution README, access statements and output map; AEA compliance is not claimed or automatically required for this baseline report |
| [Stata integrated version control](https://www.stata.com/features/overview/integrated-version-control/), [community-program compatibility](https://www.stata.com/support/faqs/programming/community-contributed-programs-and-stata-version/), [DIME repado guidance](https://worldbank.github.io/repkit/articles/ado-management-with-repado.html) | Version/dependency distinction | version19 is retained; separately pin ado/GIS dependencies rather than assume version freezes them |
| Official [egen](https://www.stata.com/manuals/degen.pdf), [programming functions](https://www.stata.com/manuals/fnprogrammingfunctions.pdf), [postfile](https://www.stata.com/manuals/ppostfile.pdf) | Consequential rowmean/rowtotal, missing(any), typed-posted-result behavior | The diagnostics explicitly distinguish structural skips and float representation; use double(varlist) or explicit types for high-precision posted values when needed |

A failed URL fetch is not evidence that a resource or package does not exist. External code can contain unsafe conventions even when published in a strong journal. The adopted decision is **selective borrowing**, not institutional-template substitution.

## 8. Source inventory and coverage

There are14 tracked first-party source artifacts,14,615 lines in this snapshot. Counts include narrative/comments and the historical presentation. Hashes identify the precise source reviewed; they are not a line-by-line verification certificate.

| Source | Lines | SHA-256 |
|---|---:|---|
| `1 Code/0 Master Code_AdvJusticeUganda.do` | 77 | `ca3cf8ac3b878159aa23aab0c303f78c15c2dea5bedde7ab2ed0ac848b19e475` |
| `1 Code/1 Data Preparation_AdvJusticeUganda.do` | 2966 | `afbc72b990666088f47e99091515c8b57a199eb66a96220a4b5f8c6a79f8b2aa` |
| `1 Code/2 Data Analysis_AdvJusticeUganda.do` | 3625 | `4276963f3920a75f2eb8cc1cdd9a237da7d6b045bd8449dd1a933690249f5fd8` |
| `1 Code/5 Phase2_Administrative_Frame.do` | 109 | `eea84cfbb5960b766b37a5dcefb05a6c18a7cae553f17466791dc8c1aa0a1337` |
| `1 Code/5 Phase2_Administrative_Frame.py` | 865 | `ecd1b4c5fdb86bfe96024f7453fb8dac1b748f2aa1dc08778ae96650407bc6a4` |
| `1 Code/6 Phase2_Geospatial_Frame.do` | 958 | `1af4d4fcf200d8ab3ec6f28a756457c7e17ae6980329db695ddcbbe938fe88fa` |
| `1 Code/6 Phase2_Geospatial_Frame.py` | 2953 | `586755df050fc87b4a7301408092a5e8ca8d356daf187d2e4b7fde50a6a7ac0c` |
| `1 Code/6 Phase2_Geospatial_Review.mjs` | 219 | `8b720284f95c4f13f4446a9ad475a1d5e530e6068519db6dfc9459664ea33536` |
| `1 Code/archive/3 Baseline Data Quality_AdvJusticeUganda.do` | 1347 | `7145a822832095d957bd30221eee7c5c1bcd42becb7487e64956b5dda9a7316c` |
| `1 Code/archive/4 Key Baseline Regressions_AdvJusticeUganda.do` | 181 | `103ed054ba87e6ed44472cd5fdc3cc4b2fa3106d9dccbaec6c7664831a2b9fee` |
| `1 Code/archive/5 QA Presentation Assets_AdvJusticeUganda.do` | 320 | `592a63c669cf57f12d1e6d4131cfc9f10ff0bbc35e41548bf39c86f3eb57ac60` |
| `1 Code/archive/6 Quick Alternative Outcome Regression_AdvJusticeUganda.do` | 104 | `640f2d655af713272f035505f3771ac3cf475046d6a02bbb95e52f45f3b9d84f` |
| `1 Code/build_dropbox_corpus_snapshot.py` | 362 | `f25f4c6d9ca13bad5399ba3868876d2380bc40144bb0d4ca3e31f1e7b2eace14` |
| `2 Output/Phase1_Baseline_QA_Presentation/phase1_baseline_qa_presentation.qmd` | 529 | `ece8b45cd6fb384b5019438846e080ee754580cb28464636b12f11001e43aaac` |

Coverage is strongest for the master, current preparation/index logic, identified analysis/model/output blocks, Phase2 wrappers and scientific matching/neighborhood logic, and all specific findings. Independent second passes covered analysis helper blocks, domain tables, origin models, JLOS plots, Section10 posting identifiers and archived QA logic. Geographic/support code received source-text coverage across the listed files, with short rechecks of findings. The historical QMD's code/asset references were inspected, not every prose sentence.

Coverage is weaker for a certified lossless reread of every analysis/archive line, independent item-by-item validation of every questionnaire score against both XLSForms, every formal indicator wording/mapping, all first-party source paths not exercised by the selected checks, and every dependency's implementation. The 41-entry repository screen remains limited as stated above. These gaps must remain explicit; neither “ultimate exhaustive review” nor full-package clearance is warranted.

## 9. Smallest complete remediation sequence, subject to approval

1. **Decisions first:** settle nonapplicable/DK scoring and record-field skip conventions; distinguish pure labels from numerical changes. Do not let a style change carry a substantive correction.
2. **Entry point and documentation:** fix paths/archive references and select supported research stages without rerunning historical sampling; record exact setup and restriction boundaries. Keep the present folder structure.
3. **Targeted scientific/data fixes:** bridge crosswalk identities, repair item denominators and only approved score conventions, then compare IDs, missingness, components, indices, estimation samples, coefficients/SEs and figure/table data against the frozen baseline. Exact matches unless a documented approved change; state numerical tolerances.
4. **Output custody and release:** simple preflight source/product comparisons, fresh staging, explicit file inventory and honest status. Review disclosure/LC1 permissions separately.
5. **Final package rehearsal:** from a clean session at the documented entry point, with authorized inputs and no unintended redraw; compare every main/appendix output to its intended report location. Record runtime and any executable restricted-data boundary. Only then claim complete reproducibility.

No commit, push, public deposit, external message, new scoring rule, new regression specification, mentor ranking or assignment was authorized/performed by this audit. The14 model reruns were exact diagnostic reproductions of existing specifications, not additional analysis families.

**Unresolved:** scientific scoring decisions; source/crosswalk confirmations; LC1 permissions/current-boundary questions; remaining bibliography/source-review depth; and a genuine clean-session end-to-end run. Existing output agreement cannot resolve these by itself.

## 10. Repeating the bounded model checks

The following is the successful MCP diagnostic selection, with personal roots replaced by the existing project globals. Define `git` and `dropbox` correctly in the MCP session first; do not run the unconfigured master merely to define them. This is not a replacement project entry point. It reads the existing coded cohort and saved workbook and writes only Stata temporary results. It does not install packages, run preparation, alter indices or redraw villages. If a check fails, stop and restore the preserved dataset before unrelated work.

```stata
preserve
tempfile expected_origin expected_multi observed_origin observed_multi
local book "${git}/2 Output/Phase1_Baseline_Selected100_Observed/tables/phase1_baseline_regression_results.xlsx"
import excel using "`book'", sheet("origin_adjusted") firstrow clear
keep outcome n coef_prev_contacted se ci_low ci_high
rename (n coef_prev_contacted se ci_low ci_high) (expected_n expected_b expected_se expected_low expected_high)
save `expected_origin'
import excel using "`book'", sheet("multivariable_diagnostics") firstrow clear
keep outcome predictor n coefficient se r2
rename (n coefficient se r2) (expected_n expected_b expected_se expected_r2)
save `expected_multi'
use "${dropbox}/3 Data/3 Coded/phase1_baseline_analysis.dta", clear
keep if selected_fvl100_observed == 1 | p1_admin_previously_contacted == 1
assert _N == 115
encode canonical_district, gen(audit_district)
tempname op mp
postfile `op' str80 outcome double n double b double se double low double high using `observed_origin'
foreach y in idx_lcc_operational_capacity idx_lcc_case_handling_quality idx_lcc_legitimacy_and_norms idx_p1_base_mentor_ready_proxy idx_record_quality idx_referral_practice idx_safeguards {
 quietly regress `y' i.p1_admin_previously_contacted i.audit_district, vce(robust)
 local b = _b[1.p1_admin_previously_contacted]
 local se = _se[1.p1_admin_previously_contacted]
 post `op' ("`y'") (e(N)) (`b') (`se') (`b'-invttail(e(df_r),.025)*`se') (`b'+invttail(e(df_r),.025)*`se')
}
postclose `op'
postfile `mp' str80 outcome str50 predictor double n double b double se double r2 using `observed_multi'
foreach y in idx_legal_classif_knowledge idx_adr_mediation_practice idx_record_quality idx_committee_functioning idx_perceived_legitimacy idx_safeguards idx_reintegration_norms {
 quietly regress `y' respondent_female education_score lc_experience_years prior_justice_training prior_formal_coordination i.p1_admin_previously_contacted i.audit_district, vce(robust)
 foreach x in respondent_female education_score lc_experience_years prior_justice_training prior_formal_coordination {
  post `mp' ("`y'") ("`x'") (e(N)) (_b[`x']) (_se[`x']) (e(r2))
 }
 post `mp' ("`y'") ("p1_admin_previously_contacted") (e(N)) (_b[1.p1_admin_previously_contacted]) (_se[1.p1_admin_previously_contacted]) (e(r2))
}
postclose `mp'
use `observed_origin', clear
merge 1:1 outcome using `expected_origin'
tab _merge
assert _merge == 3
assert n == expected_n
assert abs(b-expected_b) < 1e-12
assert abs(se-expected_se) < 1e-7
assert abs(low-expected_low) < 1e-7
assert abs(high-expected_high) < 1e-7
display as result "PASS: seven origin models reproduce saved N/b/robustSE/95CI; coefficient tol1e-12; float-export tol1e-7."
use `observed_multi', clear
merge 1:1 outcome predictor using `expected_multi'
tab _merge
assert _merge == 3
assert _N == 42
assert n == expected_n
assert abs(b-expected_b) < 1e-12
assert abs(se-expected_se) < 1e-7
assert abs(r2-expected_r2) < 1e-7
display as result "PASS: seven multivariable models/all42 coefficient rows reproduce saved N/b/robustSE/R2 at declared tolerances."
restore
```

## Implementation follow-up: safe master (1 November 2026)

This section records the first approved implementation after the audit. The original findings and hashes above describe the audited baseline; they have not been silently rewritten as a release clearance.

### Scope and changes

- Replaced the disabled, author-specific master with an explicit-root Stata 19 entry point. Its third argument is 0 for preflight (the default) or 1 for the existing baseline analysis; an optional fourth argument selects an existing alternative output root.
- Preflight checks input files, the plotplain scheme, unique identifiers, consent, and correspondence between observed interviews and the 100-row original selection frame. It derives the observed counts and does not rebuild or redefine the sample.
- Removed routine package-installation attempts and the PLUS override. The master records the resolved scheme path but does not yet freeze its distribution or verify its hash automatically.
- The master never calls Data Preparation, archived scripts, Phase 2 frame builders or randomization. No historical sampling code or result was changed.
- Changed only three logging commands in Data Analysis to use the name baseline_analysis, so that its log no longer closes the independent baseline_master log.
- Added variable-name tie-breakers to three administrative-origin presentation-table sorts. An isolated run demonstrated that equal-ranked rows could exchange positions. Differences/estimates are unchanged; ordering is now explicit. This does not alter random assignment, scoring, model specifications or substantive ranks.
- Replaced the stale README with execution, input/access, dependency, output-map and limitation documentation. Paths are normalized to forward slashes without changing their destinations.

F01 is addressed for **analysis from current coded inputs**, not for raw-to-final reproduction. Its historical preparation/input-path problems remain outside the execution path. F09's routine-installation problem is removed; dependency distribution/pinning remains unfinished. No scoring or substantive-definition fix was implemented.

### Verification actually performed

All Stata execution used stata_run_selection MCP.

| Check | Result |
|---|---|
| Before implementation | A direct check failed because the explicit-root, preflight-first master interface was absent |
| Clean-state preflight | Passed after clear all and macro drop _all |
| Missing roots | Stopped with r(198) |
| Invalid run switch | Stopped with r(198) |
| Missing repository | Stopped with r(601) |
| Missing coded inputs | Stopped with r(601), without substituting another source |
| Missing explicit output root | Stopped with r(601) |
| Omitted run switch and stale path globals | Defaulted to preflight; explicit roots replaced stale globals |
| Missing plotplain | Stopped with r(601), without installation, after both PLUS and OLDPLACE lookup locations were temporarily redirected; both settings were restored |
| Full master execution | Two isolated MCP analysis runs completed with return code 0; the second used the final master/logging/tie-break source |
| Current sample relationship | 130 coded interviews; 100 frame rows; 93 observed selected interviews; 22 previous-contact observations |
| Workbooks | All 6 workbooks and 76 sheets compared; 18,532 numeric cells agreed within predeclared absolute tolerance 1e-12; counts/keys/text were checked exactly |
| Numerical round-off | 25 numeric cells were not bit-identical; maximum absolute difference 1.0061396160665481e-16, far below the tolerance and exported reporting precision |
| Output ordering | Three comparison sheets were matched by domain/variable keys to verify that presentation ordering did not change values; only final_diff_table differed in order in the final comparison |
| Figures | All 44 PNG files matched accepted PNGs byte for byte; the recreated library also contained 44 PNGs |
| Existing outputs | All 219 files under 2 Output retained their pre-validation content digest |
| Inputs | Coded cohort and 100-row frame retained their SHA-256 hashes |
| Other source code | All 12 other first-party source files retained their audited SHA-256 hashes, including Data Preparation and both Phase 2 Stata builders |

The first missing-dependency simulation redirected PLUS only and did not remove the dependency: Stata found a second copy in OLDPLACE. That failed test assumption was diagnosed rather than treated as a master failure. The successful test redirected both locations, verified r(601), and restored them before subsequent work.

The final full-run MCP wall time was approximately 106 seconds on this machine; an earlier isolated run took 122 seconds. These are observed validation times, not a cross-machine runtime guarantee. Data Analysis's existing observation-level index comparison and output-presence assertions also completed.

Validation used an alternative root in the operating-system temporary directory. Accepted output files were not overwritten. The independent cell comparison was read-only using bundled Python/openpyxl; it performed no new statistical analysis and created no helper script or analytical workbook. Formula text, labels, populated values and worksheet order were compared; no assertion is made that PDF metadata or workbook ZIP bytes are identical.

### Retained execution evidence

Private Dropbox audit folder:

4 Deliverables and Presentations/Research Code Audit/2026-11-01/

- safe_master_validation_20261101.log: final master and child execution, including completion.
- safe_master_analysis_validation_20261101.log: final detailed analysis execution.

The final MCP transcript also records FINAL_MASTER_FULL_RUN_RC=0. It is not sufficient to rely on a zero tool-level status alone.

Final modified source SHA-256:

- 0 Master Code_AdvJusticeUganda.do: `02048a465b345b7984c586747c74ba888d36cecade9ac5edc48970e8f4eccaae`
- 2 Data Analysis_AdvJusticeUganda.do: `4be73ce7e0921b2bc8a350ca942fdbef4978e55bd1053f9db38168e22d3d82a3`

The unchanged 219-file accepted-output digest is `55c459e81e98b47134b63cf8db0dae7cc2ef00a52a77476572dd0271afc2a898`, calculated over sorted absolute-path/SHA-256 pairs. It proves preservation in this workspace, not analytical validity or a portable release seal.

The AGENTS-required graphify update . was run as an AST-only update without semantic extraction or an API call. It updated graph artifacts and created a curated-graph backup. Two unrelated sources (hooks.json and dropbox_corpus_profiles_2026-08-31.json) produced no nodes; the graph is not evidence of complete Stata/document semantic coverage. No full corpus rebuild was performed.

### Explicit remaining boundary

No scoring, index definition, missingness convention, sample selection, estimation specification, historical randomization, raw input or report was changed. No commit, push or publication was performed.

Before implementing F02/F03/F08 measurement changes, obtain Jorge's item-specific approval. Raw-to-final preparation, output publication/staging safeguards, denominator reporting, disclosure review and a frozen dependency distribution remain separate audit work. This successful analytical entry-point run does not clear those outstanding issues.

## Implementation follow-up: denominators and baseline output publication (1 November 2026)

### Scope and scientific boundary

Jorge authorized the next denominator-reporting and output-publication fixes while retaining historical randomization, scoring, indices and sample definitions. This follow-up covers the active Phase 1 baseline analysis and its master entry point only. It does not clear the separate preparation/Phase 2 publication findings or the substantive measurement issues above.

Only the master, Data Analysis, README and output-folder ignore rules were changed for this implementation. No helper script, model family or analytical dataset was added. The final run used the existing 130-record coded cohort, the existing 100-row selected-village frame with 93 observed interviews, and the existing 22-record previous-contact comparison group. These are current execution facts, not a reopening of the selected frame or permission to describe 100 frame rows as 100 interviews.

### F07: item-specific denominator reporting

Nine wide grouped summaries previously displayed one reference measure's N beside several different means. They now count the nonmissing analyzed value separately for each measure using explicit Stata `collapse (count)` assignments alongside the unchanged statistics:

- Executive: `readiness_quartiles`, `chair_profile_district`, `institutional_by_district`, `caseload_by_district`.
- Administrative-origin comparisons: `fig32_core_composites`, `fig33_jlos_collaboration`, `fig34_priority_gaps`, `fig35_high_readiness_flags`.
- Expanded JLOS: `district_jlos_diagnostic`.

The executive workbook adds `denominator_dictionary` (100 mappings of workbook, sheet, measure, statistic, grouping and count column) and `vignette_scenarios` (the four already-plotted scenario means with their nonmissing Ns). The dictionary makes Stata's truncated count-column names traceable. Existing six workbooks remain the output structure; there are now 78 sheets rather than 76.

README sheets and figure notes distinguish nonmissing analyzed-score N from raw-question eligibility, all-components-complete N and records-inspected N. Existing structural-zero, unknown-code, available-component and missingness rules were not changed. Multiple-response percentages remain shares of respondents selecting options, not shares of cases.

Twelve figures received item/pairwise Ns or denominator notes: 02, 04, 05, 10, 10b, 13, 30, 31, 33, 37, 38 and 41. All 12 changed PNGs were visually inspected. The final vignette axis title and two explanatory notes were shortened/wrapped to avoid clipping without changing values. The other 32 PNGs are byte-identical to the previous bundle. PDF counterparts were generated and checked for presence, but not independently rendered page by page.

Independent native Stata verification imported the published dictionary and affected sheets, then counted nonmissing source values in the same unchanged groups: **100 mappings and 297 grouped count checks passed**. Verification initially required correction for Excel-exported value labels and the analysis's existing origin/readiness display labels; those were verification-assumption errors, not production denominator defects.

### F06: staged, serialized baseline output publication

The master is the sole publisher. Each analysis run obtains an exclusive output lock and a fresh same-parent staging directory. Data Analysis requires that stage, creates its own tables/figures directories, and never writes directly into the current published bundle. Fixed shared temporary workbook/figure paths and sequential copying over the current results were removed.

All six workbooks, 44 PNGs, 44 PDFs and both logs must pass the existing content/file checks before promotion. After closing logs, the master renames the old complete directory to a unique retained backup and promotes the validated stage. Ordinary promotion failure restores the old directory and returns native Stata error 603. Failed stages and backups are retained; no recursive deletion or automatic backup purge is performed. An existing lock is not silently removed, and an ownership/path or rollback problem requires manual recovery.

Directory locking, path checks, staging and renames use Python's standard library through Stata's built-in integration, with SFI for local status values; no statistical operation is delegated to Python. Python 3.8+ configured for Stata is now an explicit preflight dependency (tested interpreter: 3.11.15). No package was installed or updated. File operations follow the documented [Python 3.11 `os.rename` behavior](https://docs.python.org/3.11/library/os.html#os.rename); status handoff uses the [official SFI Macro API](https://www.stata.com/python/api16/Macro.html).

**This is not a single crash-atomic transaction.** The two directory renames can briefly leave the current path absent. Power interruption or rollback failure requires review of the retained lock/stage/backup; the README gives recovery instructions. A successful local output promotion is not disclosure clearance or authorization for public distribution.

### Execution and failure-path evidence

All Stata execution used `stata_run_selection`. The full finalized analysis was first run into an OS-temporary output root, then published into the ordinary production output root after the following checks:

1. A real Windows handle denying directory deletion forced promotion to fail after the old bundle had moved. The first probe exposed an unhandled Python-exception propagation problem that prevented native lock cleanup, although the old bundle was already restored. The code was corrected to catch ordinary I/O failures inside Python and return explicit Stata status locals. No scientific code was involved.
2. The corrected failure probe returned **603**, verified that the old directory had actually moved before promotion failed, restored every old published file byte-for-byte, released the owned lock and retained the failed stage. The restored isolated-bundle relative-path/SHA-256 digest was `646f80535d1c70d955b6a154588a9cf42341f7f5867e42c833169ae42b934007` both before and after the test.
3. A peer's pre-existing lock blocked execution with 603 without removing its owner marker. A direct child call targeting the published folder was rejected with 198. Read-only master preflight succeeded without producing outputs. These guards left the isolated published bundle unchanged.
4. The final production run completed and the MCP transcript explicitly recorded **`PRODUCTION_PUBLICATION_RC=0`** followed by a passing native assertion. The current output bundle is `2 Output/Phase1_Baseline_Selected100_Observed/`; the owned publication lock is absent.

The retained production backup is `2 Output/Phase1_Baseline_Selected100_Observed.backup-4tuai9_o/`. Stage, backup and lock directories are ignored by Git; the current published directory is not. The original 219-file output tree was reconstructed from unchanged non-target files plus this backup and exactly reproduced the pre-change absolute-path/SHA-256 digest `55c459e81e98b47134b63cf8db0dae7cc2ef00a52a77476572dd0271afc2a898`. The old bundle was preserved, not silently overwritten or deleted.

### Numerical and source preservation

A read-only workbook comparison matched every pre-existing sheet/cell, allowing only documented denominator/README additions and the two new sheets. All **18,532 pre-existing numeric cells** agreed at the declared absolute tolerance **1e-12**. There were 37 machine-roundoff differences; the maximum absolute difference was **2.984e-16**. Existing regressions, uncertainty estimates, statistics, labels and ranked table alignments had no unexplained differences. Removed shared-N columns were compared to their corresponding new measure-specific N, rather than omitted from the comparison.

The analysis's observation-level index comparisons passed during execution. SHA-256 checks additionally confirmed the coded cohort and selected-village frame are byte-identical to the audit baseline:

- `phase1_baseline_analysis.dta`: `dde25a5c99391e3fd29a755ed237e561c3d265af5af30e0709e478926d11a731`.
- `phase1_baseline_selected100_frame.dta`: `c1b04869a3ea8de6c072b671e35f3b7c06ceab57e5e26ca6a81b4b10df72ab00`.

All 12 other inventoried first-party source files remain byte-identical, including Data Preparation, Phase 2 scripts and archived analysis. Historical randomization was neither changed nor executed. No Word report was edited. Source/documentation `git diff --check` passes; the unedited generated Stata log contains ordinary trailing display whitespace, so an unrestricted check reports log whitespace, not a source-code defect.

Final modified code SHA-256:

- `0 Master Code_AdvJusticeUganda.do`: `f770fc1e67b429194bfa61d1d53424724002435a3b273c3e9e897ca9bcdaa4d3`.
- `2 Data Analysis_AdvJusticeUganda.do`: `02913490f3abce7b88cf514010f1dc590c32cda0ee4816d076a4478219d07bf4`.

Private execution evidence was saved without replacing the earlier audit logs under Dropbox `4 Deliverables and Presentations/Research Code Audit/2026-11-01/`:

- `denominator_publication_master_20261101.log`.
- `denominator_publication_analysis_20261101.log`.
- `publication_rollback_test_20261101.log`.
- `denominator_count_verification_20261101.log`.

These are execution/check records, not an independent substantive validation or public-release seal. No commit, push or external distribution was performed.

The required `graphify update .` completed with exit 0 using AST extraction only: 827 nodes, 1,010 edges and 77 communities. It refreshed generated navigation files and retained a curated-graph backup. It again warned that `hooks.json` and `dropbox_corpus_profiles_2026-08-31.json` produced zero nodes; two community names fell back to their hubs. No LLM labeling, semantic extraction, API request or document-corpus rebuild was performed. These graph artifacts are navigation aids, not validation evidence.

### Remaining work requiring a separate decision or pass

F02/F03/F08 scoring/missingness/interpretation questions still require item-specific approval before any numerical change. Raw-to-final reproduction, preparation/Phase 2 output safety, disclosure review, dependency freezing and other operating systems remain unvalidated by this implementation. In particular, reporting a score's correct nonmissing denominator does not resolve whether the existing score's missingness or unknown-code policy should substantively change.

## Implementation follow-up: baseline preparation and Phase 2 publication (1 November 2026)

### Authorization, scope and entry points

Jorge authorized extending the existing publication safeguards to Data Preparation and Phase 2 while retaining historical randomization, scoring, indices and samples. During implementation he separately approved making the village crosswalk's audit-only raw-geography representative deterministic. No other substantive change was authorized or made.

The existing master now has an optional fifth task argument: analysis (default), preparation, phase2_admin or phase2_geo. The existing third argument remains 0 for preflight and 1 for an explicit run. Geographic mode is argument six; the existing PDF/Excel Python runtime is supplied explicitly as argument seven for the administrative task. The README documents commands, inputs, output ownership, dependencies and recovery. No new code/helper file, branch, statistical model or analytical architecture was introduced.

The three preparation children refuse an unstaged direct call before writing. Writing CLI invocations of both existing Python companions require the master-owned workspace marker. The historical administrative-case construction and Phase 1 sampling source block remain present and unchanged but are enclosed in an unexecuted block; only baseline preparation is called. Historical sampling/randomization was not executed.

### Publication mechanism and owned files

All master workflows now honor the common private 3 Data/.workflow-publication-lock. Baseline analysis also retains its independent output-folder lock. A peer's lock is never deleted. Existing data/product receipts are checked before staging, and current files are checked again before promotion. Current code hashes are recorded separately in the new publication receipt; old code-version stamps are not silently treated as current executable code.

Maintenance uses a full private temporary project copy, not hard links to live files. This keeps source snapshots, preparation outputs, GIS conversion and workbook edits away from accepted paths. The workspace and Dropbox must be on the same filesystem; a mismatched volume stops before execution. Source paths escaping the declared root or linked publication inputs are rejected.

Owned publication units remain explicit in the master:

- Preparation: five baseline working datasets, two coded datasets, the reconciliation workbook, release-status file, durable validation log and generation receipt.
- Administrative Phase 2: source-snapshot folder, administrative-frame folder, durable validation log and receipt.
- Geographic Phase 2: geographic-source folder, geographic-frame folder, existing census workbook, durable validation log and receipt.

After the child succeeds, existing native datasets are compared observation by observation, aligning on a validated unique key where available. Tables without a listed unique key retain row-order comparison. Exactly matching native data keep the accepted file bytes rather than creating timestamp-only checksum churn. The only exception is the explicitly approved crosswalk alias correction described below.

Only newly written manifest path metadata is canonicalized from the workspace to the project location. Product hashes are reconciled only for native files whose generated values passed the exact comparison and whose accepted bytes were retained. All staged data/product receipts must then agree. The code does not silently re-pin an altered source, waive a scientific mismatch, or invalidate a later milestone's accepted inputs.

The old generation receipt is moved out first, and the new receipt is installed last. Old units are retained under unique 3 Data/.publication-backup-<run identifier>/ directories. A journal records the planned units and completed moves/installs. Ordinary partial-promotion failure restores all old units and status. There is no recursive purge of backups or failed workspaces.

These multiple renames are recoverable, not power-loss atomic. Readers must honor the project lock; a power interruption or failed rollback requires manual inspection of owner/journal, current units, stage and backup. An old READY line alone is not evidence that the latest attempt succeeded.

### Approved deterministic audit-only crosswalk choice

The safety check first found four raw-geography differences in one regenerated crosswalk. Investigation established that the existing by-canonical-LC keep-first command did not specify which survey supplied subcounty_scto, parish_scto and village_scto. This was a representative-alias ambiguity, not a different analytical respondent.

After Jorge's explicit approval, the crosswalk now takes the first record ordered by baseline_wave, baseline_source_row and unique submission_key. The comment distinguishes this audit alias from analytical selection. Compared with the accepted pre-task crosswalk, this deterministic rule changes the three-field alias combination in 10 of 144 crosswalk rows; four was the mismatch count in the initial unstable rerun, not an exhaustive count of rows affected by the final deterministic rule.

All other crosswalk variables agree exactly. A separate Stata check verified that every observed crosswalk row matches the earliest-source rule: 133 observed canonical rows matched the source records, with 11 additional historical/unobserved crosswalk rows. No respondent identifiers or village-level row examples are included in this audit record.

Initial record-lineage/all-record comparisons also showed row-order differences. Key-aligned comparisons using the unique submission key resolved them completely. The lineage, cleaned records, coded analytical cohort, selection frame and all indices/sample flags were unchanged. Row-order differences were not presented as numerical or scoring defects.

### Administrative source custody and date metadata

The administrative downloader now verifies an in-memory PDF payload against the accepted SHA-256 before creating the final snapshot file. It still uses the existing official URL/hash and size/type rules.

The first administrative staged rerun also exposed date-only provenance churn: a cached district website was relabeled as retrieved today, and an otherwise identical source manifest received a new generation date. Cached snapshot provenance is now retained from the accepted issue row; a missing documented acquisition date is explicitly unknown, not inferred from the current clock. An otherwise identical source receipt retains its original date/bytes, while the new publication receipt dates this revalidation. No village membership, discrepancy count, link, eligibility or neighbor rule changed.

### Validation actually performed

All Stata commands used stata_run_selection MCP. Assertions and real filesystem behavior, not tool-level success alone, establish the following:

| Check | Result |
|---|---|
| Pre-fix administrative direct call | Failed the new guard test: returned 601 after creating output directories, rather than refusing unstaged execution with 198 |
| All three unstaged .do children after correction | Refused before writes with 198 |
| Both writing Python CLIs | Refused an unowned root with parser status 2; test root remained empty |
| Wrong-version PDF payload | Rejected by the pinned hash before a PDF target was created; test used a fake HTTP response, not a live download |
| Altered accepted receipt | Rejected before writes in a small temporary fixture |
| Actual Windows partial-install failure | A held file prevented the second new unit from being installed after the first had installed; every old file/status was restored byte-for-byte, and the journal marked rollback complete |
| Successful fixture retry | Published the new units and retained all old units in the backup |
| Peer lock | Both preparation and baseline-analysis entry points returned 603 and preserved the peer's owner marker |
| Final baseline-preparation repeat run | Native return code 0; seven existing datasets compared, with only the approved three-field crosswalk exception |
| Final administrative repeat run | Native return code 0; both native census/crosswalk datasets compared exactly |
| Final official UBOS/MoLG workflow | Completed publication; 89 existing native datasets compared exactly; all existing linkage/geometry/candidate-frame checks retained |
| Fresh post-run receipt verification | 2,419 data/product hash checks passed; all three generation receipts, backups and durable logs present |
| Baseline-analysis regression check | Full analysis completed into an OS-temporary alternative output root; six workbooks, 44 PNGs, 44 PDFs and successful master publication log present |
| Locks after final verification | Common project lock and isolated analysis output lock absent |
| Scientific data | Coded cohort and selected frame retained their exact pre-task SHA-256 hashes |

An early administrative run published correctly but encountered a transient Windows/Dropbox error while deleting its empty lock directory. This was diagnosed from the actual receipt and filesystem, not treated as a statistical failure. The products were hash-verified before that run's own empty residual lock was removed. The publisher now retries lock-directory removal a bounded number of times, catches persistent cleanup failure, and explicitly reports whether publication had already completed. The final administrative rerun returned 0.

The final geographic-plus-analysis validation exceeded the MCP transport's fixed 300-second response limit even though a longer task timeout was requested. Stata was not restarted or overlapped. Session management later confirmed the default session was ready, the geographic receipt and durable log showed completion, and the isolated analysis master log recorded validated publication and final closure at 20:36:39 local time. A fresh MCP selection then verified all receipts/products, expected native comparison counts, both coded input hashes, all expected isolated assets, backups/logs and absence of locks. No claim is made that the timed-out combined call itself returned a captured zero status.

A final concurrency test simulated an active project lock with temporarily absent coded files. It first returned 601 because analysis confirmed data availability before inspecting the lock. The analysis preflight was reordered to check the lock before file access, and the test then returned the intended 603. A separate full isolated analysis run on the final master returned a captured native 0; its logs are extended_final_analysis_master_20261101.log and extended_final_analysis_20261101.log. The maintenance branch is byte-identical to the final preparation/administrative/geographic executions. Final maintenance preflight, 2,419 receipt checks, absence of locks and the pre-task candidate-neighbor native-file hash were reverified after this ordering fix.

The coded input hashes remain:

- phase1_baseline_analysis.dta: dde25a5c99391e3fd29a755ed237e561c3d265af5af30e0709e478926d11a731.
- phase1_baseline_selected100_frame.dta: c1b04869a3ea8de6c072b671e35f3b7c06ceab57e5e26ca6a81b4b10df72ab00.

Data Analysis is byte-identical to its accepted pre-task version (SHA-256 02913490f3abce7b88cf514010f1dc590c32cda0ee4816d076a4478219d07bf4). No new model, score, index, analytical sample, match/neighbor definition, historical randomization, mentor eligibility rule or report content was introduced.

An exact source-text comparison also passed: the historical source block is unchanged; the baseline body is unchanged except for the approved alias-choice command/comment; administrative native validation is unchanged; and the geographic Stata body/Python scientific code are unchanged apart from their entry guards. Source/documentation git diff --check passes (ordinary LF/CRLF conversion warnings are not scientific changes).

### Execution records and source versions

Durable workflow logs and receipts are in private Dropbox 3 Data/:

- preparation_validation.log and preparation_publication.json.
- phase2_admin_validation.log and phase2_admin_publication.json.
- phase2_geo_validation.log and phase2_geo_publication.json.

Additional private validation records are under 4 Deliverables and Presentations/Research Code Audit/2026-11-01/. The extended_publication_guards_20261101.log and extended_publication_final_checks_20261101.log retain the failure-path/post-run checks; isolated analysis logs are retained there separately. Intermediate failed workspaces remain in the operating-system temporary area. No restricted microdata or new output workbook was added to GitHub.

Final modified source SHA-256:

| Existing file | SHA-256 |
|---|---|
| 0 Master Code_AdvJusticeUganda.do | 2252ae9cd3c2f688a1da0a85ab3dba4c1c6593dab239ca9f3663b02f00005a78 |
| 1 Data Preparation_AdvJusticeUganda.do | 2c7ead385aad9a5a717c8ffb52c3f40e7999339ce8d01a0d8f5d16a1134dae4f |
| 5 Phase2_Administrative_Frame.do | 55519cb5a99b5ccc97eae0614852976e90637866375e2a94a95d138d62158728 |
| 5 Phase2_Administrative_Frame.py | 03f9ab31aa3b8db939880c073c104d1bf0c97dca924371a67e449346f308d23c |
| 6 Phase2_Geospatial_Frame.do | d0d12f2c07cc1581f2a963dfad29b9fb7aa409b2feeafd1e125f7e348498b3e8 |
| 6 Phase2_Geospatial_Frame.py | f45d67a97ea7ca90a82c3e3ff54f569a9404e02091cf3b4bfe194b131f4703ac |

### Remaining boundary

The entry-point safeguards cover every existing geographic mode, but full computational validation in this pass exercised the current official UBOS/MoLG mode, not every historical M2-M6 rebuild or online acquisition route. Older-mode replay that invalidates later accepted receipts is intentionally blocked pending a coordinated review; no accepted downstream receipt is silently rewritten to permit it.

Historical randomization, public-disclosure review, a completely frozen dependency distribution, other operating systems and power-loss recovery are not validated by these runs. F02/F03/F08 measurement/scoring questions still require item-specific approval. No commit, push, external distribution, report refresh, mentor selection or treatment assignment occurred.

The required final Graphify AST-only update completed with exit 0 after the last code change: 835 nodes, 1,018 edges and 81 communities. It refreshed navigation artifacts and retained a curated-graph backup. The known zero-node warnings for hooks.json and dropbox_corpus_profiles_2026-08-31.json remain; no semantic extraction, LLM labeling, API request or full document-corpus rebuild was performed. Graph output is not scientific verification.

