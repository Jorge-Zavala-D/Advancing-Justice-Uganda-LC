## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip graphify if the task is about stale or incorrect graph output, or the user explicitly says not to use it.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).

## Standing empirical-research and Stata standards

These are Jorge's project instructions, adopted 1 November 2026. Apply them to
development, review, refactoring and replication preparation. This is an academic
social-science project: another competent researcher must be able to understand
the research decisions without learning a custom programming framework.

- Execute every Stata command through `stata_run_selection` MCP, never a shell or
  direct Stata executable. Do not rerun or change historical randomization without
  explicit authorization. Preserve approved data, samples and scientific results.
- Before major development/refactoring, inspect relevant actual published Stata
  replication files, starting with the project's bibliography. Record authoritative
  repository/version, files inspected, output traces, useful and unsuitable
  practices, and whether code was merely located, read, traced or executed.
  Consult DIME/World Bank, J-PAL, IPA, Sean Higgins, AEA and official Stata resources
  selectively. Institutional recommendations are not automatically requirements.
- Reuse the existing research organization. Keep a clear master, documented roots,
  coherent task scripts, and an explicit source-to-dataset/table/figure map. Keep
  raw inputs, working data, analytical data and outputs distinct. Do not impose a
  new framework, folder architecture or dependency for stylistic conformity.
- Prefer explicit conventional syntax, descriptive names, readable indentation,
  useful local macros and straightforward loops for genuinely repeated work.
  Expose scientifically different specifications. Avoid excessive globals,
  indirect macro chains, positional variable ranges and unnecessary helpers.
- Make units, keys, sample restrictions, exclusions, recodes, scores, aggregation,
  missing-component rules and subgroup definitions inspectable. Preserve source
  variables when meaning changes. Never force an unresolved sample to a target N.
- Check keys and intended merge relationships; inspect unmatched observations.
  Do not use `merge m:m` or forced duplicate removal to conceal identity problems.
  Distinguish zero, unknown, refusal, structural skip and missing. Guard numeric
  comparisons and all-missing aggregation deliberately; preserve ID precision.
- Comment consequential assumptions and choices, linking to the questionnaire,
  protocol or approved decision. Do not add repetitive command translations,
  decorative banners or conversational notes to the replication code.
- Estimation blocks must expose outcomes, treatment/controls, fixed effects,
  weights, samples and inference. Export intended stored results before they are
  overwritten. Generate tables/figures from results, not manual transcription.
  Baseline associations are not treatment effects; component correlations can be
  mechanical. The baseline mentor proxy is not the final selection rule.
- Specify Stata/settings and separately record dependencies; `version` does not
  freeze community packages. Keep setup separate where useful; do not silently
  install/update dependencies on every run. Stochastic work requires a documented
  seed and stable unique ordering, without altering frozen historical draws.
- Retain direct research-relevant checks, not a defensive framework around every
  command. Do not suppress consequential errors or silently substitute inputs,
  samples or methods. Stop clearly on failed assumptions.
- Before stylistic revision, establish the analytical baseline. Compare keys,
  contents, missingness, indices, estimation samples, coefficients/uncertainty and
  table/figure data. Use exact comparisons where appropriate and justify any
  numerical tolerance. Separate representation changes from scientific changes.
  Report a substantive defect or ambiguity separately; do not fix it under the
  label of cleanup without approval.
- A release README must explain environment, dependencies, access, entry point,
  script/output mapping, runtime when known, and restricted-data boundaries.
  Verify the actual complete entry-point run before claiming full reproducibility.
  Exclude credentials, personal paths, sensitive microdata and internal
  correspondence from public materials. Restricted LC1 geography needs explicit
  redistribution terms. Preparing a package is not authorization to publish it.
- Review comprehensively at stable milestones, not repeatedly for cosmetics.
  For each task report what changed, why, what was verified, whether scientific
  behavior changed, and what remains unresolved. Never overstate review coverage.

The dated audit and reference-review record is
`project_context/STATA_RESEARCH_CODE_AUDIT_2026-11-01.md`. Its remaining gaps and
scientific decisions are explicit; it is not an exhaustive replication clearance.
