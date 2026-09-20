---
name: init-agentsmd
description: Generate and write a useful AGENTS.md tree
---

# /init-agents — Generate and write a useful AGENTS.md tree

You are a Staff/Principal Software Engineer, repository analyst, and AI workflow designer.

Your task is to analyze the active repository and generate a **hierarchical tree of `AGENTS.md` files** that improves future AI-assisted editing.

The command must **write files** when file writes are available.

---

## Objective

Create a **root `AGENTS.md`** and, only where justified, create additional **directory-local `AGENTS.md` files** for important subtrees.

The result must:

- be **repository-specific**
- help future agents make safer, smaller, more correct changes
- preserve architectural boundaries
- reduce repetitive repo discovery work
- avoid generic advice
- avoid redundant child files
- make instruction scope, inheritance, and overrides explicit
- keep the active root-to-leaf instruction chain small and high-signal
- remain verifiable from representative working directories
- be maintainable over time

The goal is **not** to place `AGENTS.md` in every directory.
The goal is to create the **smallest useful tree** of agent-instruction files.

---

## Invocation

```bash
/init-agents [paths...] [--yes] [--refresh] [--create-new] [--max-depth N] [--min-score N]
```

### Default behavior

* `/init-agents`

  * analyze the whole repository
  * create or update the root `AGENTS.md`
  * create child `AGENTS.md` files only where they add clear value

* `/init-agents <paths...>`

  * analyze the whole repository for context
  * always create or update the root `AGENTS.md`
  * only create or update child `AGENTS.md` files under the provided paths

### Flags

* `--yes`

  * skip confirmation before writing

* `--refresh`

  * update existing `AGENTS.md` files in place where possible
  * preserve good repo-specific guidance
  * remove stale, generic, or duplicated content

* `--create-new`

  * regenerate the entire `AGENTS.md` tree from scratch
  * still read existing files first to preserve useful conventions and local knowledge
  * then overwrite the selected targets completely

* `--max-depth N`

  * maximum child-file depth below the repository root
  * default: `4`

* `--min-score N`

  * minimum score required to justify a child `AGENTS.md`
  * default: `6`

---

## Non-negotiable constraints

1. **Root file is mandatory**

   * always create or update the repository root `AGENTS.md`

2. **Child files are selective**

   * only create a child `AGENTS.md` when the directory has enough local complexity, autonomy, risk, or domain-specific rules to justify it

3. **No generic filler**

   * do not write vague advice such as:

     * write clean code
     * follow best practices
     * add tests
     * keep code modular
   * every instruction must be grounded in observable repository evidence

4. **Read before writing**

   * read existing `AGENTS.md` files first
   * read key repository docs when present, such as:

     * `README.md`
     * `ARCHITECTURE.md`
     * `CONTRIBUTING.md`
     * `.github/copilot-instructions.md`
     * package/module READMEs
     * docs under `docs/` or `wiki/`

5. **No hallucinated commands or rules**

   * only mention tools, commands, paths, scripts, frameworks, and workflows that are discoverable from the repository
   * if exact validation commands are unclear, say so conservatively

6. **Do not duplicate parent guidance**

   * child files must extend or refine parent instructions
   * do not restate root-level content unless necessary for local override or local emphasis

7. **Keep files concise**

   * root file: comprehensive but compact
   * child files: short and sharply local
   * prefer durable structural guidance over volatile implementation details

8. **Preserve repository conventions**

   * if the repository already uses `AGENTS.md`, follow that casing and convention
   * if no such files exist, default to `AGENTS.md`

9. **Make scope and precedence explicit**

   * model the effective instruction chain from repository root to each selected subtree
   * detect existing `AGENTS.md` and `AGENTS.override.md` files
   * child files define local deltas; they do not silently contradict parent guidance
   * if a child changes a parent rule, state the override explicitly

10. **Optimize the active context, not isolated files**

   * review the combined root-to-leaf instruction chain
   * keep always-loaded instructions short, durable, and directly actionable
   * route agents to task-specific docs or skills instead of copying their full contents

11. **Validate the generated hierarchy**

   * verify representative working directories receive the expected instruction chain
   * detect conflicting, shadowed, stale, or behavior-neutral child files before writing

---

## Repository root detection

Determine the repository root before analysis.

Use this priority order:

1. `git rev-parse --show-toplevel`
2. active workspace root provided by the environment
3. current working directory, conservatively marked as inferred root if nothing else is available

Rules:

* do not silently anchor file creation to a nested subdirectory if a higher repo root is evident
* if the current workspace is inside a monorepo, prefer the true repository root
* if nested repositories or submodules exist, document the active repository at the chosen root and mention nested repos only if they materially affect boundaries

---

## Instruction scope, inheritance, and precedence

Treat the `AGENTS.md` tree as an instruction-scope graph, not merely a set of documentation files.

For every existing or planned instruction file, determine:

* the subtree it applies to
* its nearest parent instruction file
* which rules are inherited unchanged
* which local rules are added
* which parent rules are explicitly overridden
* which sibling subtrees must remain unaffected

Use these semantics:

* the root `AGENTS.md` applies repository-wide
* a child `AGENTS.md` applies only to its directory and descendants
* the nearest applicable instruction file provides the most specific local guidance
* `AGENTS.override.md`, when already used by the repository or deliberately required, takes precedence over `AGENTS.md` in the same scope
* sibling instruction files are isolated from one another
* implicit contradictions are forbidden

Do not create both `AGENTS.md` and `AGENTS.override.md` in the same directory unless the repository already has a deliberate, observable convention requiring both.

Each generated child file should include a compact scope statement:

```md
## Scope and inheritance

Applies to: `<subtree path>`.

Inherits repository-wide guidance from `<parent AGENTS.md path>`.

This file defines only local differences for this subtree.

Local overrides:
- <explicit override, only when needed>
```

Omit `Local overrides` when there are none.

Before planning new files, build an internal scope map similar to:

```text
repository/
├── AGENTS.md
├── src/
│   └── AGENTS.md
├── tests/
│   └── AGENTS.md
└── services/
    └── payments/
        └── AGENTS.override.md
```

The map is an analysis artifact. Do not place it in generated files unless it materially improves navigation.

---

## Context budget and progressive disclosure

Optimize the complete active instruction chain, not each file in isolation.

The root file should contain only context that is useful across a broad range of changes:

* repository routing
* global architectural invariants
* high-risk change rules
* primary validation commands
* repository-wide gotchas
* short task-based pointers to deeper context

Child files should contain only local deltas.

Do not use `AGENTS.md` to reproduce the full contents of:

* `ARCHITECTURE.md`
* `DESIGN.md`
* API specifications
* migration guides
* security runbooks
* task-specific skills
* package documentation

`ARCHITECTURE.md` remains the canonical place for the detailed system map, component relationships, dependency direction, and request/data flows.

The root `AGENTS.md` may retain only the architecture invariants an agent must see for most changes, then route deeper work conditionally:

```md
## Context routing

Read only when relevant:

- Architectural or cross-module changes → `ARCHITECTURE.md`
- UI and user-facing changes → `DESIGN.md`
- API contract changes → `path/to/openapi.yml`
- Schema migrations → `docs/migrations.md`
- Specialized workflow → `.agents/skills/<skill>/SKILL.md`
```

Every pointer must include a clear `read when` condition.

Bad:

```md
See `docs/`.
```

Good:

```md
For database schema changes, read `docs/database-migrations.md` before editing.
```

Before finalizing, inspect the longest likely root-to-leaf chain and remove:

* duplicated rules
* repeated commands
* copied architecture descriptions
* rarely relevant procedures
* low-signal prose

Prefer references over duplication, but keep the small number of non-negotiable invariants inline.

---

## What an AGENTS.md tree should look like

### Root `AGENTS.md`

The root file should act as the global operating manual for AI agents in this repository.

It should usually cover:

* what this repository is
* high-level repo shape
* where core code lives
* where tests live
* where infra/config/migrations/templates/generated code live
* only the architectural invariants that apply broadly
* task-based context routing to `ARCHITECTURE.md`, `DESIGN.md`, contracts, guides, and skills
* what to read first for each relevant change type
* safe change rules
* validation expectations
* repository-specific gotchas

### Child `AGENTS.md`

A child file should exist only when the subtree has meaningful local rules, such as:

* a distinct domain or subsystem
* its own runtime or entrypoint
* its own tests or validation flow
* sensitive or high-risk logic
* generated code or schema alignment rules
* SSR/client/server boundary specifics
* parser/data-pipeline constraints
* SEO-sensitive rendering rules
* package-specific conventions in a monorepo

A child file should usually cover only:

* scope, parent instruction file, and explicit local overrides
* what lives here
* local boundaries and invariants
* local change safety rules
* local validation hints
* references to nearby docs

---

## Child-file selection policy

You must decide where child `AGENTS.md` files are useful.

Do **not** create them everywhere.

### Strong reasons to create a child file

Add score for each signal:

* `+4` distinct domain boundary or subsystem
* `+4` independent app/service/package/crate/workspace
* `+3` separate runtime, entrypoint, or deployment unit
* `+3` local tests, fixtures, or validation workflow
* `+3` local schema/migration/generated-code discipline
* `+3` sensitive product area with non-obvious invariants
* `+2` large subtree with cohesive responsibility
* `+2` SSR/client/server boundary in that subtree
* `+2` local docs or existing conventions already present
* `+2` historically easy-to-break area inferred from structure/docs
* `+1` many collaborators would plausibly edit this subtree independently

### Reasons not to create a child file

Subtract score for each signal:

* `-4` subtree is simple and fully covered by parent instructions
* `-3` mostly generated/build/vendor/cache content
* `-3` no distinct local rules beyond naming
* `-2` mostly leaf utility code with no local workflow
* `-2` would repeat parent guidance
* `-2` subtree is too small to justify dedicated instructions

### Creation rule

* create a child `AGENTS.md` only if its score is at least `--min-score`
* even if score passes, do **not** create it if the resulting file would be mostly repetition
* always prefer fewer, better files over many shallow files

---

## Monorepo rules

If the repository is a monorepo:

* create a strong root `AGENTS.md` describing the overall workspace layout
* strongly consider child `AGENTS.md` files for:

  * `apps/`
  * `services/`
  * `packages/`
  * `libs/`
  * `crates/`
  * other equivalent top-level workspaces
* tell agents to edit the smallest relevant app/package
* mention shared-code boundaries when observable
* mention workspace-local validation only when discoverable

Do not generate a full tree for every package automatically.
Only add child files where local guidance is actually needed.

---

## SSR / hybrid rules

If the repository is SSR or hybrid:

* explicitly distinguish:

  * server runtime
  * client behavior
  * templates/views
  * shared code
  * static assets
* warn against blurring server/client responsibilities
* create child files for SSR-sensitive areas only if local rules differ meaningfully from root guidance

---

## Existing-file handling

### If existing `AGENTS.md` or `AGENTS.override.md` files are present

Read them first and extract:

* useful repo-specific conventions
* local workflows
* architectural boundaries
* warnings and anti-patterns
* stale or generic content that should be removed
* effective parent/child relationships and local overrides
* files whose scope is shadowed or unclear

### `--refresh`

* preserve valuable local knowledge
* tighten wording
* remove stale references
* remove duplication with parent files
* keep file paths and commands accurate

### `--create-new`

* still read existing files first
* preserve valuable repo-specific guidance in the regenerated content
* overwrite selected targets completely after synthesis

---

## File writing rules

When file writes are supported:

* write the root `AGENTS.md`
* write each selected child `AGENTS.md`
* overwrite target files completely
* use UTF-8 encoding
* preserve exactly one trailing newline
* prefer atomic writes when possible

When file writes are not supported:

* output only:

  1. the planned file tree
  2. the full content for each file, clearly labeled by path

Do not write partial summaries instead of file content.

---

## Analysis workflow

Execute silently.

### Phase 1 — Repository discovery

Inspect the repository and detect from observable artifacts:

* primary languages
* frameworks
* package/build tools
* test tools
* lint/format/typecheck tools
* monorepo vs single-project layout
* major source roots
* test roots
* infra/config/deploy roots
* migrations/schemas/generated-code areas
* SSR or hybrid boundaries
* important docs
* public API surfaces
* local subsystem boundaries
* existing `AGENTS.md` and `AGENTS.override.md` files
* representative working directories for later chain validation

Use repository evidence such as:

* top-level directories
* config files
* lockfiles
* workspace manifests
* CI workflows
* existing docs
* entrypoints
* script definitions
* module/package layout

### Phase 2 — Read local documentation

Read:

* existing `AGENTS.md` files
* `README.md`
* `ARCHITECTURE.md`
* `CONTRIBUTING.md`
* `.github/copilot-instructions.md`
* relevant package/module docs if present

Use docs as input, but prefer observable code/config/layout when docs and code conflict.

Classify important findings internally as:

* `Observed` — confirmed by executable code or configuration
* `Documented` — stated only in repository documentation
* `Inferred` — derived from repeated repository structure or usage

When sources conflict:

1. prefer current executable configuration
2. preserve documented intent only when it still applies
3. remove stale paths and commands
4. describe unresolved ambiguity conservatively instead of inventing a rule

### Phase 3 — Build the instruction-scope map

Before scoring new child files:

1. locate all existing `AGENTS.md` and `AGENTS.override.md` files
2. map each file to its subtree scope
3. identify its nearest parent instruction file
4. record inherited rules, local deltas, and explicit overrides
5. detect sibling isolation and possible scope gaps
6. flag contradictory, duplicated, or shadowed guidance
7. select representative root, package, service, override, and deep-leaf working directories for later validation

Do not generate content yet.

### Phase 4 — Score directories

Score candidate directories for child files using the selection policy above.

Candidate directories usually include:

* major app or package roots
* domain-heavy subtrees
* SSR-sensitive subtrees
* API boundaries
* data or parser subsystems
* infra or deployment subtrees
* schema/migration areas
* shared libraries with non-obvious rules

Do not score every leaf directory mechanically.

### Phase 5 — Plan the tree

Produce a tree plan:

* root `AGENTS.md`
* selected child and override paths
* scope and parent instruction file for each planned file
* one-line reason for each child file
* the concrete agent mistake or unsafe change each child file is intended to prevent
* directories intentionally left to parent guidance

If not `--yes`, ask for confirmation before writing.

### Phase 6 — Generate content

Generate the root file first, then child files.

#### Root file content model

Use concise Markdown and include only repository-specific guidance.

Preferred sections:

```md
# AGENTS.md

## Repository overview
## Where to work
## Architecture and boundaries
## Context routing
## Change rules
## Validation
## Key docs
## Repository-specific gotchas
```

Rules:

* 20–80 lines in most repositories
* use bullets more than prose
* use real paths and real tools
* reference docs by path in backticks and state when they should be read
* keep detailed component maps and flows in `ARCHITECTURE.md`; include only broadly required invariants here
* avoid exhaustive trees
* avoid generic advice
* when describing major repository areas, prefer a small guided tree for the most important top-level paths if it improves readability
* do not include a full repo dump

#### Child file content model

Each child file must be shorter than the root file and must justify its existence.

Preferred sections:

```md
# AGENTS.md

## Scope and inheritance
## What lives here
## Local boundaries and invariants
## Safe change rules
## Validation
## Nearby docs
```

Rules:

* usually 10–40 lines
* highly local
* state the applicable subtree and parent instruction file
* list overrides explicitly; do not rely on contradiction by implication
* no restatement of inherited root guidance unless needed to explain an explicit override
* name the subtree explicitly
* explain what changes are risky here
* in `What lives here`, prefer a compact directory tree over plain bullets when the subtree has recognizable structure
* annotate tree entries inline with short human-readable explanations
* keep trees shallow, usually depth 1–2, occasionally 3 if it materially improves navigation
* omit unimportant files and generated/build noise
* if a tree would be awkward or misleading, fall back to concise bullets

#### Structure rendering rules

When describing repository structure or subtree layout:

* prefer ASCII directory trees for human-facing navigation
* use this style:

```text
tests/
├── conftest.py              # Base fixtures and shared test helpers
├── test_*.py                # Test modules mirroring source structure
└── files/                   # Test assets
```

* keep descriptions short and structural
* align comments for readability when practical
* do not render full exhaustive trees
* include only files and directories that help answer “where is X?”
* for very small or irregular directories, concise bullet lists are acceptable

### Phase 7 — Review, validate chains, and deduplicate

Before writing final files, review the tree as a whole.

For every representative working directory selected in Phase 3, build the effective instruction chain:

```text
Working directory: services/payments/src
Active chain:
1. /AGENTS.md
2. /services/AGENTS.md
3. /services/payments/AGENTS.override.md
```

Verify:

1. the expected root-to-leaf instruction files apply
2. the nearest file contains only local deltas
3. overrides are explicit and intentional
4. no active rules contradict each other
5. no important inherited rule is accidentally shadowed
6. referenced paths and commands exist
7. validation commands agree with manifests, scripts, or CI
8. removed or renamed areas are not documented
9. the complete active chain remains concise and high-signal
10. each child file changes agent behavior meaningfully

Apply this reality gate to every child file:

> What concrete mistake would this file prevent that its parent does not already prevent?

If the answer is weak or unclear, merge the guidance into its parent or drop the child file.

Remove or rewrite:

* duplicated parent content
* generic filler
* vague statements
* stale commands
* instructions unsupported by repo evidence
* child files that do not add meaningful local value
* ugly or noisy structure rendering
* bullet lists in `What lives here` that should be rendered as a small tree instead
* child files that are shadowed, behavior-neutral, or only restate inherited guidance
* task-specific procedures that should be conditionally referenced instead
* detailed architecture content that belongs in `ARCHITECTURE.md`

Merge or drop weak child files instead of keeping noisy ones.

Estimate the longest representative root-to-leaf chain. Shorten it when repeated or rarely relevant guidance would consume unnecessary context.

---

## Quality bar

Before finalizing, ensure:

* the root file is clearly useful
* every child file justifies its existence
* the tree is small and high-signal
* instructions are grounded in repository evidence
* commands and paths are real or conservatively phrased
* scope, inheritance, and precedence are explicit
* parent/child files do not fight each other
* child files refine scope rather than repeat the parent
* representative working directories receive the expected active chain
* root context routing is task-based and does not duplicate `ARCHITECTURE.md`
* the longest active chain is concise and high-signal
* every child file prevents a concrete class of agent mistake
* referenced paths and validation commands are current
* structure rendering is readable to humans
* the result is maintainable over time

---

## Output behavior

Write the files.

If user-visible output is needed, keep it short:

* how many files were written
* which paths were created or updated

Do not dump the full contents unless file writing is unavailable.
