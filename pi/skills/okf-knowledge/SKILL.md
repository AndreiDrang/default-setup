---
name: okf-knowledge
version: "0.0.2"
description: Creates, updates, audits, and maintains repository-grounded Open Knowledge Format bundles with stable concept identities and retrieval-oriented navigation.
---

# Skill: OKF Knowledge Documentation

## Purpose

Create, update, audit, or maintain a project-local knowledge bundle based on the Open Knowledge Format (OKF).

The bundle must be:

- readable by humans without specialized tooling;
- parseable and traversable by AI agents;
- diffable and reviewable in Git;
- grounded in repository evidence;
- organized around stable domain concepts rather than source-file summaries;
- safe to regenerate without duplicating concepts or casually changing Concept IDs;
- compatible with the minimal and permissive OKF v0.1 specification.

Use this skill when the user asks to:

- initialize an OKF bundle;
- document repository knowledge as concepts;
- refresh an existing bundle from current repository evidence;
- audit bundle conformance, links, identities, or structure;
- enrich existing concepts;
- reorganize an overloaded knowledge bundle;
- reconcile stale concepts with current code and documentation.

---

## Supported parameter

This skill supports exactly one optional parameter:

```text
[root_directory]
```

Examples:

```text
okf-knowledge
okf-knowledge src/
okf-knowledge data/pipelines
okf-knowledge api/specs
```

Do not support additional flags or parameters.

### Repository-root and scope-root detection

Determine `<repository-root>` before resolving the documentation scope.

Use this priority:

1. `git rev-parse --show-toplevel`;
2. active workspace root;
3. current working directory, conservatively treated as inferred root.

If `root_directory` is provided:

- resolve it relative to `<repository-root>` or the active workspace;
- require it to exist and be a directory;
- treat it as `<scope-root>`;
- read, cite, and link repository evidence only inside `<scope-root>`;
- write bundle files only inside `<scope-root>/okf/`;
- do not follow symlinks that resolve outside `<scope-root>`;
- do not use parent-level `ARCHITECTURE.md`, `README.md`, or other documentation as bundle evidence;
- allow one explicit exception: inspect and update an already existing `<repository-root>/AGENTS.md` only for the managed OKF guidance block defined by this skill.

If `root_directory` is not provided:

- set `<scope-root>` to `<repository-root>`.

The root `AGENTS.md` exception does not expand the documentation evidence scope. Content outside the managed block must not be copied into the OKF bundle merely because the file was opened for a safe merge.

---

## Output location and write boundary

Create or update the bundle at:

```text
<scope-root>/okf/
```

Permitted writes are limited to:

1. `<scope-root>/okf/**`;
2. the existing `<repository-root>/AGENTS.md`, but only to add or refresh the managed OKF guidance block defined below.

Rules:

- never create a root `AGENTS.md` when one does not already exist;
- never modify product code, tests, configuration, or unrelated documentation;
- never rewrite unrelated `AGENTS.md` content;
- use UTF-8;
- preserve exactly one trailing newline in written Markdown files;
- prefer atomic writes when possible;
- preserve unknown frontmatter keys when updating existing concepts;
- do not create generated visualization or cache artifacts unless explicitly requested.

---

## Root AGENTS.md integration

When `<repository-root>/AGENTS.md` exists, ensure it contains a concise, idempotently managed section explaining how agents should use and maintain OKF documentation.

### Managed block

Use these exact markers:

```markdown
<!-- okf-knowledge:start -->
## Open Knowledge Format (OKF)

- OKF knowledge bundles live in an `okf/` directory under their documentation scope.
- Before changing a documented domain, read the nearest `okf/index.md` and the relevant concept documents.
- Update OKF when business rules, workflows, APIs, schemas, data contracts, architecture boundaries, operational playbooks, or canonical references materially change.
- Preserve stable Concept IDs. When moving a concept, update incoming links, directory indexes, and `okf/log.md`.
- After changes, validate frontmatter, internal links, indexes, duplicate resources, stale source paths, and lifecycle status.
- Use the `okf-knowledge` skill to initialize, refresh, reconcile, or audit a bundle.
<!-- okf-knowledge:end -->
```

### Update rules

- If both markers exist, replace only the content from the opening marker through the closing marker with the canonical block above.
- If neither marker exists, append the canonical block after the existing content, separated by one blank line.
- If only one marker exists, treat the block as malformed: do not guess the intended boundary; leave `AGENTS.md` unchanged and report it as unresolved.
- Do not create a second managed block.
- Do not replace or merge similarly named human-written sections outside the markers.
- Preserve all unrelated text, ordering, encoding, and final newline conventions where practical.
- Keep this block short. Detailed OKF rules belong in this skill and the bundle, not in `AGENTS.md`.
- Update `AGENTS.md` only after the OKF bundle write succeeds, so it never points agents to an initialization that failed.
- If the root `AGENTS.md` does not exist, skip this integration without creating the file.

---

## Standards model

Do not conflate the OKF specification with this skill's stronger producer-quality rules.

### Level 1 — OKF v0.1 conformance

These are format requirements. Violations are errors.

1. A bundle is a directory tree containing Markdown files.
2. Every non-reserved `.md` file is a concept document.
3. Every concept document has parseable YAML frontmatter.
4. Every concept frontmatter contains a non-empty `type` field.
5. `index.md` and `log.md` are reserved filenames and are not concept documents.
6. A directory `index.md`, when present, follows the index-file format.
7. A `log.md`, when present, follows the chronological log format.
8. Only the bundle-root `index.md` may contain frontmatter, and this skill uses it only to declare `okf_version`.

Consumers are expected to tolerate:

- unknown `type` values;
- unknown additional frontmatter fields;
- missing optional fields;
- missing optional index or log files;
- broken links.

Consumer tolerance does not mean this producer should intentionally generate low-quality or accidentally broken bundles.

### Level 2 — Producer profile

Unless the repository provides a better established convention, this skill should also produce:

- stable concept paths and identities;
- useful `title` and `description` metadata;
- repository provenance through `source_paths`;
- progressive-disclosure indexes;
- meaningful concept cross-links;
- an update log for material bundle changes;
- duplicate, orphan, stale-source, and accidental-link checks;
- concise concept documents optimized for retrieval.

These are quality requirements of this skill, not universal OKF conformance requirements.

### Level 3 — Project extensions

This skill may use producer-defined fields such as:

```yaml
source_paths:
  - src/domain/rules.py
confidence: observed
status: current
owners:
  - payments-domain
superseded_by: /rules/new-qualification-rule.md
```

Rules:

- preserve unknown existing fields during updates;
- do not require consumers to understand extension fields;
- do not invent values;
- omit unsupported fields rather than filling them speculatively;
- do not create a project-wide taxonomy registry unless the repository already has one.

---

## Reserved filenames

The following filenames have defined OKF meaning and must not be used for concepts:

```text
index.md
log.md
```

All other Markdown files under the bundle are concept documents and require frontmatter with `type`.

---

## Concept identity and granularity

### Concept ID

A concept's ID is its bundle-relative file path without the `.md` suffix.

Examples:

```text
tables/customers.md       -> tables/customers
rules/portfolio-limit.md  -> rules/portfolio-limit
```

Treat the path as a persistent public identifier, not merely a cosmetic filename.

### One concept, one stable responsibility

A concept should represent one stable unit of knowledge, such as:

- a domain entity;
- a business rule;
- a workflow;
- a metric;
- an API contract;
- a data asset;
- a service boundary;
- a policy;
- a playbook;
- a decision;
- a reference source.

Do not generate one concept per source file by default.

Do not combine unrelated rules, workflows, or entities into a large catch-all document merely because they are implemented in the same module.

Split a candidate when its parts:

- have different identities or lifecycle;
- are independently referenced;
- change for different reasons;
- have different canonical resources;
- require materially different evidence.

Merge candidates when they are only implementation fragments of one domain concept and would not be useful independently.

### Stable naming

Use lowercase kebab-case concept filenames.

Good:

```text
portfolio-valuation.md
user-verification.md
order-completion-policy.md
```

Bad:

```text
service_logic.md
stuff.md
new_file.md
ControllerRules.md
```

A display-title change does not justify renaming a concept file.

Rename or move an existing concept only when its current path is materially misleading or conflicts with the intended semantic structure.

---

## Concept identity ledger

Before creating or updating files, build an internal concept ledger for the current bundle and all confirmed candidates.

Record at least:

- concept ID;
- file path;
- `type`;
- normalized title;
- canonical `resource`, when present;
- `source_paths`;
- matched repository entity or idea;
- outgoing concept links;
- incoming concept links;
- lifecycle status;
- confidence;
- detected conflicts or duplicates;
- intended action: keep, update, create, move, deprecate, or leave unchanged.

Do not write this ledger into the bundle unless the user explicitly requests an audit report.

### Existing-concept matching priority

Map repository knowledge to existing concepts using this order:

1. exact canonical `resource`;
2. stable domain identifier represented in the concept and source evidence;
3. matching source paths and responsibility;
4. matching title, type, and semantic purpose;
5. create a new concept only when no existing concept represents the same knowledge.

Rules:

- do not create multiple active concepts for the same canonical resource;
- do not duplicate an existing concept under a new filename because wording changed;
- do not merge concepts solely because titles are similar;
- preserve the existing Concept ID when identity is still the same;
- treat ambiguous matches as unresolved rather than guessing.

### Duplicate and stale detection

Before writing, detect:

- duplicate `resource` values;
- multiple concepts mapped to the same repository entity;
- multiple active concepts with the same stable responsibility;
- missing or renamed `source_paths`;
- concepts with no current evidence;
- concepts marked both current and deprecated;
- concepts that link to themselves accidentally;
- incoming links to concepts planned for a move;
- duplicate index entries.

Do not automatically delete a suspicious concept. Preserve it and record the uncertainty unless the user requested cleanup or the replacement is unambiguous.

---

## Concept frontmatter

Every concept document must start with YAML frontmatter.

Recommended producer shape:

```yaml
---
type: Business Rule
title: Portfolio concentration limit
description: Limits exposure to a single issuer when calculating portfolio eligibility.
source_paths:
  - src/portfolio/rules/concentration.py
  - tests/portfolio/rules/test_concentration.py
confidence: observed
status: current
tags:
  - portfolio
  - risk
---
```

### Required field

```yaml
type: <descriptive concept type>
```

Use short, descriptive, self-explanatory type values.

Examples:

| Domain | Example types |
|---|---|
| Data | Dataset, BigQuery Table, Metric, Data Pipeline, Data Quality Rule, View |
| API | API Endpoint, Schema, Contract, Authentication Method, Webhook |
| ML | ML Model, Feature, Training Pipeline, Evaluation Metric, Model Card |
| Infrastructure | Service, Deployment, Configuration, Network, Cluster |
| Business | Business Rule, Use Case, Workflow, Process, Policy, Validation Rule |
| Universal | Concept, Entity, Reference, Playbook, Decision, Principle |

There is no central OKF type registry. Do not force all repositories into one fixed taxonomy.

### Recommended fields

Use when supported:

```yaml
title: <human-readable title>
description: <one-sentence routing summary>
resource: <canonical URI for the described asset>
tags:
  - <cross-cutting tag>
timestamp: <ISO 8601 datetime of meaningful concept change>
```

Rules:

- `description` should help a reader decide whether to open the concept;
- `resource` identifies the underlying described asset, not a supporting source file;
- use `source_paths` for repository provenance;
- add `timestamp` only when the actual meaningful update time is known;
- preserve existing timestamp formatting when valid;
- do not update timestamps for formatting-only changes unless the repository convention requires it;
- use small, stable tag sets rather than verbose keyword lists.

### Producer extension fields

Use only when evidence supports them:

```yaml
source_paths:
  - <scope-root-relative path>
confidence: observed | inferred | unknown
owners:
  - <observable module or team>
status: current | deprecated | unknown
superseded_by: /path/to/replacement.md
```

Do not invent owners, lifecycle state, resource URIs, or timestamps.

---

## Evidence and provenance

### Evidence priority

Use this priority when sources conflict:

1. executable schemas, contracts, dependency rules, and architecture tests;
2. current runtime entrypoints, source code, migrations, and configuration;
3. tests that demonstrate expected behavior;
4. generated artifacts that are authoritative for the relevant contract;
5. current repository documentation;
6. naming conventions or framework assumptions.

When executable evidence and documentation disagree:

- prefer current executable evidence;
- describe the conflict in the affected concept when it matters;
- add a concise conflict entry to `log.md` when the bundle was changed because of it;
- do not silently preserve stale documentation as fact.

### Repository provenance

Use `source_paths` to identify repository files used to derive a concept.

```yaml
source_paths:
  - src/domain/qualification.py
  - tests/domain/test_qualification.py
```

Rules:

- use paths relative to `<scope-root>`;
- include only material sources;
- do not list every file read during analysis;
- do not use nonexistent paths;
- do not cite files outside `<scope-root>` when a scoped run is active.

### External and first-class citations

Use a `# Citations` section for external sources or first-class reference material that supports body claims.

Preferred form:

```markdown
# Citations

[1] [Canonical API specification](https://example.com/spec)
[2] [Local reference concept](/references/canonical-api.md)
```

Rules:

- place `# Citations` at the bottom of the concept body;
- number citations sequentially when more than one source is listed;
- cite actual sources only;
- do not invent URLs or references;
- use normal Markdown links;
- keep repository implementation provenance in `source_paths` rather than duplicating every path in citations;
- when no external or first-class reference is needed, omit the section;
- do not force citations into index files.

### Confidence

Use confidence conservatively:

- `observed`: directly supported by repository evidence;
- `inferred`: a conservative synthesis from multiple observable signals;
- `unknown`: evidence is insufficient for a material conclusion.

Do not label speculative statements as observed.

In the body, make uncertainty explicit when it affects interpretation:

```markdown
# Open Questions

- Unknown: The exact retry policy is not visible in the selected scope.
```

---

## Source discovery

Analyze only files permitted by the selected scope.

Prioritize stable, shareable knowledge sources:

- scope-local `README.md`, `ARCHITECTURE.md`, `DESIGN.md`, `AGENTS.md`, and `CONTRIBUTING.md`;
- OpenAPI, GraphQL, Protobuf, AsyncAPI, and other contract definitions;
- domain models, service interfaces, validation rules, and policy code;
- SQL DDL, migrations, dbt models, views, and data quality rules;
- tests that reveal expected behavior and edge cases;
- deployment and infrastructure manifests;
- runtime entrypoints and integration boundaries;
- diagrams and decision records;
- existing local OKF concepts;
- local skill documents that materially define project rules.

Ignore or de-prioritize:

- generated build output;
- caches;
- vendored dependencies;
- minified files;
- lockfiles except when they establish tooling or workspace structure;
- low-level implementation detail with no durable domain meaning;
- duplicated or obviously stale notes.

Do not browse external sources by default. Preserve or use external sources already present in permitted repository evidence. Fetch additional external material only when the user explicitly asks and it does not violate the selected scope boundary.

The root `<repository-root>/AGENTS.md` may be inspected outside a scoped run only to preserve unrelated content and maintain the managed OKF block. Do not treat its non-managed content as bundle evidence unless it is also inside `<scope-root>`.

---

## Bundle structure planning

OKF does not prescribe a fixed directory taxonomy. Organize concepts according to stable semantics in the current scope.

Possible semantic groups include:

```text
okf/
├── index.md
├── log.md
├── domains/
├── entities/
├── rules/
├── workflows/
├── services/
├── APIs/
├── datasets/
├── tables/
├── metrics/
├── pipelines/
├── decisions/
├── playbooks/
└── references/
```

Use lowercase directory names. The example is illustrative, not mandatory.

### Structure rules

- create only directories that contain useful concepts;
- do not create empty directories to satisfy a template;
- prefer semantic groups over groups that merely mirror source folders;
- keep concepts that users search for together close together;
- use cross-links for relationships that do not fit the directory hierarchy;
- avoid deep nesting unless each level materially improves routing;
- prefer stable domain boundaries over temporary implementation teams;
- preserve existing useful bundle organization during updates;
- do not reorganize the whole bundle for cosmetic consistency.

### Directory split threshold

Consider splitting an overloaded directory when:

- it contains clearly distinct reusable subdomains;
- concept types or responsibilities differ materially;
- the index becomes repetitive or difficult to scan;
- a reader must review roughly more than 20–30 entries to choose the next concept;
- the directory mixes active concepts with a large reference corpus.

Do not split only to satisfy a numeric threshold.

Do not create single-concept directory layers unless the hierarchy communicates an important stable boundary.

---

## Two-pass generation workflow

Execute the following workflow before final writes.

### Pass 0 — Existing bundle and AGENTS.md reconciliation

If `<scope-root>/okf/` already exists:

1. read all concept frontmatter;
2. read all indexes and logs;
3. build the concept identity ledger;
4. map incoming and outgoing links;
5. identify unknown extension fields that must be preserved;
6. detect duplicate resources, stale source paths, and structural conflicts;
7. preserve valid human-written knowledge before generating replacements.

Also inspect `<repository-root>/AGENTS.md` when it exists:

1. detect whether the managed OKF markers are both present, both absent, or malformed;
2. preserve all content outside the managed block;
3. plan one of: add block, refresh block, keep unchanged, or skip as unresolved;
4. do not write the planned `AGENTS.md` change until the bundle update succeeds.

Do not overwrite the existing bundle or root agent instructions blindly.

### Pass 1 — Deterministic inventory

Extract candidate concepts from authoritative repository evidence.

For each candidate:

- identify the stable domain concept;
- identify its likely type;
- collect material source paths;
- determine whether a canonical resource exists;
- match it to an existing Concept ID;
- determine confidence;
- record candidate relationships without writing speculative links;
- decide whether it should be created, updated, kept, or left unresolved.

During Pass 1:

- do not write final prose;
- do not generate indexes;
- do not invent relationships;
- do not create concepts solely because a source file exists;
- do not choose final directory structure until the concept inventory is sufficiently complete.

### Pass 2 — Enrichment and graph construction

Enrich confirmed concepts using permitted evidence.

For each concept:

- write a routing-quality title and description;
- describe stable meaning, contract, rules, or usage;
- include structured sections appropriate to the type;
- add examples only when evidence supports them;
- add meaningful links to related concepts;
- explain the relationship in surrounding prose;
- add citations when external or first-class references support claims;
- record open questions instead of filling gaps speculatively;
- keep implementation walkthroughs out unless they are essential to the concept.

After concept bodies are stable:

1. choose or preserve the semantic directory structure;
2. update internal links;
3. generate directory indexes;
4. update `log.md`;
5. run conformance and graph-quality validation;
6. write bundle changes atomically where practical;
7. after successful bundle writes, add or refresh the managed OKF block in the existing root `AGENTS.md`;
8. validate that unrelated `AGENTS.md` content is byte-for-byte unchanged where practical.

---

## Concept body design

There are no mandatory body sections beyond valid Markdown. Use sections that fit the concept type.

General pattern:

```markdown
# <Concept Title>

<Concise explanation of what the concept is and why it matters.>

# Current Behavior

<Stable observable behavior or contract.>

# Rules

- <Business or technical invariant.>

# Relationships

- This concept depends on [Related concept](/path/related.md).

# Open Questions

- Unknown: <material unresolved point>.

# Citations

[1] [Authoritative reference](https://example.com/reference)
```

Use only relevant sections.

### Type-oriented section examples

Data assets may use:

- `# Schema`;
- `# Grain`;
- `# Joins`;
- `# Quality Rules`;
- `# Common Query Patterns`.

Business concepts may use:

- `# Current Behavior`;
- `# Rules`;
- `# Inputs and Outputs`;
- `# Exceptions`;
- `# Relationships`.

APIs may use:

- `# Contract`;
- `# Authentication`;
- `# Request`;
- `# Response`;
- `# Failure Modes`.

Workflows may use:

- `# Trigger`;
- `# Preconditions`;
- `# Steps`;
- `# Outcomes`;
- `# Failure Handling`.

Decisions may use:

- `# Context`;
- `# Decision`;
- `# Consequences`;
- `# Alternatives`.

Do not force every concept into one universal template.

### Writing quality

Concept bodies should be:

- concise;
- factual;
- domain-oriented;
- structurally formatted;
- stable across small code refactors;
- explicit about uncertainty;
- useful independently of source-code familiarity.

Avoid:

- marketing language;
- speculative claims;
- exhaustive source-file descriptions;
- long implementation tutorials;
- repeated repository-wide context already available elsewhere;
- prose that merely restates frontmatter.

---

## Cross-linking and graph semantics

Use standard Markdown links.

### Bundle-relative links

Preferred for cross-directory relationships:

```markdown
This workflow applies the [portfolio valuation rule](/rules/portfolio-valuation.md).
```

The leading `/` is interpreted relative to the OKF bundle root.

### Relative links

Useful for nearby concepts:

```markdown
See the [neighboring concept](./other-concept.md).
```

### Relationship semantics

A link creates a directed relationship. Explain the relationship in surrounding prose.

Good:

```markdown
This workflow depends on [User verification](/workflows/user-verification.md).
```

Bad:

```markdown
Related: [User verification](/workflows/user-verification.md).
```

when the relationship can be described more precisely.

Rules:

- create links only for real relationships;
- do not add artificial links solely to make the graph dense;
- do not duplicate every link bidirectionally unless both directions aid retrieval;
- use the stable Concept ID in links;
- update all known incoming links when moving a concept;
- tolerate intentionally unresolved links when representing planned knowledge, but mark them clearly;
- do not introduce accidental broken links.

---

## Index files and progressive disclosure

Create `index.md` files when they materially improve navigation.

This producer should normally create:

- a bundle-root `okf/index.md`;
- a directory `index.md` for each nontrivial semantic group.

### Root index

The bundle-root index may declare the OKF version:

```markdown
---
okf_version: "0.1"
---

# Knowledge Bundle

- [Domains](domains/) — Core business domains represented by this bundle.
- [Rules](rules/) — Stable business and validation rules.
- [References](references/) — External or canonical supporting material.
```

Do not add other frontmatter fields to index files.

### Directory index

```markdown
# Business Rules

- [Portfolio concentration limit](portfolio-concentration-limit.md) — Limits exposure to a single issuer.
- [Eligibility policy](eligibility-policy.md) — Defines eligibility for restricted operations.
```

### Index context budget

An index is a routing surface, not a summary document.

Rules:

- list immediate child concepts and subdirectories only;
- use one-sentence descriptions;
- derive descriptions from concept frontmatter when possible;
- do not copy schemas, rules, examples, or citations into indexes;
- group entries under headings only when grouping improves selection;
- use a stable sort order within each group;
- do not create one root index containing every concept in a large bundle;
- do not include frontmatter in non-root indexes;
- ensure index entries match actual immediate contents.

---

## Log files

`log.md` is optional under OKF, but this producer should maintain a bundle-root log when material changes occur.

Path:

```text
<scope-root>/okf/log.md
```

Use newest-first ISO date sections:

```markdown
# Knowledge Bundle Update Log

## 2026-07-14

- **Creation**: Added [Portfolio valuation](/rules/portfolio-valuation.md).
- **Update**: Refreshed [User verification](/workflows/user-verification.md) from current code and tests.
- **Move**: Moved `concepts/limits` to `rules/portfolio-limits` and updated incoming links.
- **Conflict**: Repository documentation and executable validation disagree; current executable behavior was used.
```

Rules:

- log only changes made or material conflicts discovered during the current run;
- do not invent historical entries;
- do not log formatting-only edits unless they matter to bundle consumers;
- use links to affected concepts when available;
- do not rewrite older valid entries;
- use the scope-local date available to the execution environment.

---

## Existing bundle lifecycle

### Default update behavior

When a bundle exists:

- read it before writing;
- preserve valid human-written content;
- preserve unknown frontmatter fields;
- preserve stable Concept IDs;
- update stale sections using current evidence;
- avoid whole-bundle rewrites when only a few concepts changed;
- preserve meaningful organization and links;
- do not delete concepts merely because they were not rediscovered in one scan;
- record material changes in `log.md`.

### Keep, update, create, move, deprecate

Use these actions deliberately:

**Keep**

- concept identity and content remain valid;
- no meaningful change is required.

**Update**

- identity remains stable;
- content, evidence, metadata, or relationships changed.

**Create**

- no existing concept represents the confirmed knowledge;
- the candidate is independently useful and evidence-backed.

**Move**

- current path is materially misleading;
- the new path improves stable semantic organization;
- all known incoming links can be updated.

**Deprecate**

- repository evidence confirms the concept is no longer current;
- preserving discoverability is still useful.

Do not deprecate or move concepts solely because a new directory template looks cleaner.

### Concept moves

Before moving or renaming a concept:

1. confirm that identity remains the same;
2. map all incoming and outgoing links;
3. preserve frontmatter extension fields;
4. update links atomically where practical;
5. update indexes;
6. record the move in `log.md`;
7. verify that no duplicate active concept remains.

When backward discoverability materially helps consumers, the old path may remain as a small deprecated concept:

```yaml
---
type: Reference
title: Previous concept location
description: This concept moved to a new stable location.
status: deprecated
superseded_by: /rules/new-concept.md
---

This concept has moved to [the current concept](/rules/new-concept.md).
```

Do not create redirect-like deprecated concepts automatically when they add no retrieval value.

### Stale concepts

A missing source path is a signal, not proof of deprecation.

Before changing lifecycle status:

- search permitted evidence for renamed or moved sources;
- inspect related concepts and tests;
- check whether the concept is abstract and no longer tied to one source file;
- mark uncertainty instead of guessing.

---

## Audit and validation

Run both conformance validation and producer-quality validation.

### OKF v0.1 conformance checks

1. Every non-reserved Markdown file has parseable YAML frontmatter.
2. Every concept has a non-empty `type`.
3. Reserved `index.md` files follow index semantics.
4. Reserved `log.md` files follow newest-first ISO-date structure when present.
5. Only the bundle-root index has frontmatter.
6. Bundle-root index frontmatter contains the declared `okf_version` and no unrelated producer metadata.

### Producer-quality checks

1. Bundle writes remain inside `<scope-root>/okf/`.
2. The only permitted write outside the bundle is the managed block in an already existing `<repository-root>/AGENTS.md`.
3. No disallowed source outside `<scope-root>` was read, cited, or linked during a scoped run; root `AGENTS.md` inspection is limited to safe managed-block reconciliation.
4. Concepts are domain-oriented rather than one-per-file summaries.
5. Existing stable Concept IDs were preserved unless a justified move occurred.
6. No duplicate active concepts represent the same canonical resource.
7. No accidental duplicate `resource` values remain.
8. `source_paths` exist and are material to the concept.
9. Unknown frontmatter fields were preserved.
10. Generated internal links resolve unless intentionally marked as planned or unresolved.
11. Relationships are explained by surrounding prose.
12. Indexes match actual immediate directory contents.
13. Index descriptions help route readers without duplicating concept bodies.
14. No accidental orphan concept was introduced.
15. Orphan concepts are not linked artificially merely to satisfy validation.
16. Moved concepts have updated incoming links and log entries.
17. Deprecated concepts identify replacements when known.
18. `# Citations` sections are at the bottom and contain actual sources.
19. Inferred and unknown claims are not presented as observed fact.
20. No empty semantic directories were created.
21. Product code and unrelated files were not modified.


### Root AGENTS.md integration checks

When `<repository-root>/AGENTS.md` exists:

1. exactly one opening and one closing managed marker exist after a successful update;
2. the opening marker precedes the closing marker;
3. the managed block matches the canonical guidance in this skill;
4. no unrelated root instructions were removed, reordered, or rewritten;
5. the block does not contain detailed concept content or duplicate the full skill;
6. a scoped run did not use unrelated root instructions as OKF evidence;
7. when markers were malformed, the file was left unchanged and reported as unresolved.

When root `AGENTS.md` does not exist, confirm that the skill did not create it.

### Graph-quality review

After writing candidate contents but before finalizing:

- compute or inspect outgoing links;
- compute incoming links;
- identify hubs with excessive unrelated links;
- identify isolated concepts;
- detect self-links and duplicate links;
- detect link targets planned for moves;
- ensure indexes provide a route to important concepts;
- ensure the root index does not require loading the entire bundle into context.

Broken links are allowed by permissive OKF consumers, but this producer must not introduce accidental broken links.

---

## Handling uncertainty

When evidence is incomplete:

- preserve an existing stable concept rather than replacing it speculatively;
- use `confidence: inferred` only for conservative synthesis;
- use `confidence: unknown` when a material conclusion cannot be reached;
- add a concise `# Open Questions` section when uncertainty matters to future users;
- do not invent owners, resources, status, relationships, schema details, or behavior;
- do not ask for clarification when the ambiguity can be represented honestly in the bundle;
- ask the user only when a required structural decision cannot be made safely, such as an ambiguous scope root or conflicting bundle ownership.

---

## Language and style

Use the language requested by the user. Otherwise prefer the predominant language of repository documentation.

Rules:

- keep filenames in lowercase kebab-case Latin characters unless the repository has an established alternative;
- preserve established domain terminology;
- keep descriptions to one routing-quality sentence;
- prefer headings, lists, tables, and fenced blocks over dense prose;
- write concise, factual, non-marketing content;
- explain domain meaning rather than implementation trivia;
- avoid copying large source passages;
- do not expose internal analysis, ledgers, or scan logs in concept documents.

---

## Error handling

Abort with a clear message when:

- the provided `root_directory` does not exist;
- the provided path is not a directory;
- the scope root cannot be read;
- `<scope-root>/okf/` cannot be created or written;
- the permitted scope contains no usable repository evidence;
- symlink resolution would require reading or writing outside the scope;
- the request requires modifying product code or files outside the bundle, except for the explicitly permitted managed block in an existing root `AGENTS.md`;
- existing bundle corruption prevents safe update and cannot be preserved conservatively.

Use this form:

```text
Cannot generate OKF knowledge documentation: <reason>.
```

When only part of the bundle can be updated safely, complete the safe portion and report unresolved files rather than inventing replacements.

---

## Final response

After successful writes, respond concisely:

```text
✅ OKF knowledge documentation updated

Version:
- Skill 0.0.2
- OKF 0.1

Repository root:
- <repository-root>

Scope root:
- <scope-root>

Bundle:
- <scope-root>/okf/

Root AGENTS.md:
- updated | unchanged | not present | unresolved

Created/updated:
- <key paths>

Unresolved:
- <count or none>
```

Do not dump all concept documents into chat unless the user explicitly asks.

If file writing is unavailable, output:

1. the planned bundle tree;
2. the complete contents of the root `index.md`;
3. the complete contents of all concepts that would be created or changed;
4. the proposed `log.md` update;
5. the canonical managed OKF block that would be added to or refreshed in an existing root `AGENTS.md`.
