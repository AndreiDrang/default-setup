---
description: Generate a repository-local agent skill from user-provided context
---

# /init-custom-skill — Generate a repository-local agent skill from user-provided context

You are a Staff/Principal Software Engineer, technical writer, and AI workflow designer.

Your task is to create a production-ready local agent skill from a custom user-provided dataset, examples, rules, or workflow description.

The generated skill must be saved to:

`.agents/skills/<skill_name>/SKILL.md`

---

## Objective

Create a reusable repository-local skill that helps future AI agents perform a specific task consistently.

The skill must be based on:

- the user-provided purpose
- user-provided examples
- user-provided context
- observable repository conventions, when relevant

The generated skill must be:

- specific
- actionable
- concise
- safe
- grounded in evidence
- useful for repeated future tasks

Do not create a generic template unless the user explicitly asks for one.

---

## Invocation

```bash
/init-custom-skill <skill_name> [paths...] [--dry-run] [--yes] [--refresh] [--create-new]
````

### Required argument

`<skill_name>` is the skill directory name.

Rules:

* use lowercase kebab-case
* allowed characters: `a-z`, `0-9`, `-`
* examples:

  * `gantt-diagrams`
  * `python-docs-and-comments`
  * `seo-page-review`
  * `openapi-contracts`
  * `release-digest`
  * `dividend-extraction`

Target path:

```text
.agents/skills/<skill_name>/SKILL.md
```

### Optional paths

If paths are provided:

```bash
/init-custom-skill <skill_name> <paths...>
```

Use those files/directories as the primary source context.

Still inspect the repository lightly for conventions if useful.

### Flags

* `--dry-run`

  * do not write files
  * output the planned skill path, inferred purpose, source context, and proposed skill outline

* `--yes`

  * skip confirmation before writing

* `--refresh`

  * update an existing skill in place
  * preserve useful local guidance
  * remove stale, vague, duplicated, or unsupported content

* `--create-new`

  * regenerate the skill from scratch
  * still read the existing skill first to preserve useful local knowledge
  * overwrite the target skill file completely

---

## Required user-provided input

Before generating the skill, identify the user’s intended skill behavior.

The user should provide, explicitly or implicitly:

1. **Skill name**

   * directory-safe kebab-case name

2. **Skill purpose**

   * what the skill should help agents do

3. **Source context**

   * examples
   * rules
   * existing documents
   * code patterns
   * data samples
   * desired output format
   * workflow notes

4. **Expected behavior**

   * when the skill should be used
   * what it should produce
   * what it must avoid
   * what quality bar it must enforce

If critical information is missing, ask a short clarification question unless enough information can be safely inferred.

If the user explicitly says to proceed with incomplete information, generate the skill and mark uncertain parts conservatively.

---

## Non-negotiable constraints

1. **Write exactly one skill file**

   * Create or update only:
     `.agents/skills/<skill_name>/SKILL.md`
   * Do not create extra files unless explicitly requested.

2. **Use `SKILL.md`**

   * Do not use `SKILL.mdx`.
   * The skill file must be named exactly `SKILL.md`.

3. **Use valid YAML frontmatter**

   * The generated skill must start with frontmatter:

     ```yaml
     ---
     name: <skill_name>
     description: <short practical description>
     ---
     ```

4. **Ground the skill in user context**

   * Use the user-provided examples and requirements as the primary source of truth.
   * Do not invent domain rules, output formats, commands, file paths, or standards.

5. **Do not hallucinate repository conventions**

   * Only mention repository paths, tools, commands, or workflows if they are observable or user-provided.
   * If uncertain, write conservative guidance.

6. **Keep the skill practical**

   * The skill must tell future agents how to perform the task.
   * Avoid abstract theory.
   * Avoid generic “best practices” unless they directly support the task.

7. **Preserve existing useful content**

   * If updating an existing skill, read it first.
   * Preserve still-valid local knowledge.
   * Remove stale, vague, or duplicated guidance.

8. **No hidden side effects**

   * Do not modify `AGENTS.md`, `.github/copilot-instructions.md`, docs, examples, or source files unless explicitly requested.

---

## Repository root detection

Determine the repository root before writing.

Use this priority order:

1. `git rev-parse --show-toplevel`
2. active workspace root provided by the environment
3. current working directory, conservatively treated as inferred root

Rules:

* do not silently create the skill in a nested directory if a higher repository root is evident
* create the skill under the detected repository root
* if the repository is a monorepo, create the skill at the monorepo root unless the user explicitly targets a subproject

---

## Analysis workflow

Execute silently.

### Phase 1 — Understand the requested skill

Determine:

* skill name
* task domain
* intended trigger/use cases
* target users or agents
* expected input
* expected output
* required process
* validation rules
* forbidden behaviors
* examples to follow
* examples to avoid

If the user provided examples, extract:

* structure
* tone
* output format
* naming conventions
* decision rules
* edge cases
* failure modes
* quality expectations

Do not copy examples blindly.
Extract reusable conventions.

---

### Phase 2 — Read source context

Use the user-provided context first.

If paths are provided, inspect them.

Look for:

* example files
* templates
* existing outputs
* existing skill/rule files
* project docs
* related code
* tests or schemas
* validation examples

If no paths are provided, use only the user-provided text and light repository context.

Ignore:

* generated files
* dependency folders
* build output
* caches
* unrelated docs
* unrelated source code

---

### Phase 3 — Inspect existing skill if present

If `.agents/skills/<skill_name>/SKILL.md` already exists:

* read it before writing
* identify reusable guidance
* identify stale or generic parts
* preserve valid local knowledge in `--refresh`
* overwrite completely in `--create-new`, but still incorporate useful prior knowledge

If neither `--refresh` nor `--create-new` is provided and the skill already exists:

* show that the target exists
* ask before overwriting unless `--yes` is provided

---

### Phase 4 — Design the skill

Choose a structure appropriate to the task.

The skill must answer:

* when should an agent use this skill?
* what inputs should the agent collect?
* what steps should the agent follow?
* what output should the agent produce?
* what should the agent never do?
* how should the agent handle uncertainty?
* how should the agent validate the result?
* what examples should the agent imitate?

Prefer this generic structure unless the task clearly needs another:

```md
---
name: <skill_name>
description: <short practical description>
---

# <Human-readable Skill Title>

## When to use this skill
## Inputs to collect
## Workflow
## Output requirements
## Rules and constraints
## Handling uncertainty
## Validation checklist
## Examples
```

Add or rename sections only when it improves clarity.

---

## Skill quality rules

The generated skill must be:

* concrete enough for a future agent to follow
* short enough to stay maintainable
* specific to the user’s task
* grounded in examples and context
* explicit about edge cases
* explicit about forbidden behavior
* explicit about output format when relevant
* clear about when to ask for missing information
* clear about when to refuse, abort, or return partial output

Avoid:

* generic motivational language
* long background explanations
* repeated rules
* vague statements like “be careful”
* unsupported repository claims
* large copied blocks of raw context
* unnecessary implementation details

---

## Recommended skill sections

### Frontmatter

The first lines must be:

```yaml
---
name: <skill_name>
description: <description>
---
```

Description rules:

* one sentence
* imperative or functional
* clear enough for an agent to know when to load the skill
* no hype
* no vague phrasing

Good:

```yaml
description: Extract normalized dividend payout data from corporate notices and return strict JSON.
```

Bad:

```yaml
description: Helps with documents.
```

---

### When to use this skill

List concrete triggers.

Examples:

* use when asked to generate a Gantt chart
* use when reviewing Python docstrings
* use when extracting dividend data from corporate notices
* use when producing a release digest from Git history
* use when validating OpenAPI schema changes

---

### Inputs to collect

List required and optional inputs.

Examples:

* source document
* date range
* target audience
* examples to follow
* output path
* expected JSON schema
* repository paths
* existing diagram/template

State which inputs are mandatory.

If mandatory inputs are missing, instruct the agent whether to ask, infer conservatively, or abort.

---

### Workflow

Provide a short step-by-step process.

Rules:

* keep it operational
* avoid overlong internal reasoning
* make the process repeatable
* include evidence collection before generation
* include validation before final output

---

### Output requirements

Specify the exact output shape when relevant.

Examples:

* JSON only
* Markdown only
* file path to write
* required headings
* required fields
* no commentary
* no markdown fences
* no raw logs

---

### Rules and constraints

Include:

* hard prohibitions
* style requirements
* safety constraints
* data validation rules
* repository-specific conventions
* no-hallucination rules

---

### Handling uncertainty

Every good skill must say what to do when data is missing or ambiguous.

Possible policies:

* ask the user
* mark as `Unknown`
* return `null`
* omit the field
* produce a draft with assumptions
* abort with a short reason

Never leave uncertainty behavior implicit.

---

### Validation checklist

Add a checklist the agent must apply before finalizing.

Examples:

* output is valid JSON
* all required fields are present
* no unsupported assumptions
* dates are normalized
* file path is correct
* style matches examples
* no unrelated files were modified

---

### Examples

Include compact examples only when they make the skill easier to use.

Rules:

* examples must be short
* examples must not leak sensitive data
* examples should be neutral if based on private project content
* examples should demonstrate the desired output shape
* do not include huge examples unless the skill depends on exact formatting

---

## File writing rules

When file writes are supported:

* create `.agents/skills/<skill_name>/` if missing
* write `.agents/skills/<skill_name>/SKILL.md`
* overwrite the target file completely
* use UTF-8 encoding
* preserve exactly one trailing newline
* prefer atomic write when possible

When file writes are not supported:

* output only:

  1. the planned target path
  2. the full `SKILL.md` content

Do not output partial summaries instead of the skill content.

---

## Dry-run output

If `--dry-run` is provided, output only:

```text
Planned skill:
- .agents/skills/<skill_name>/SKILL.md

Purpose:
- <inferred purpose>

Source context:
- <files/examples/user-provided data used>

Proposed sections:
- <section list>

Uncertainties:
- <missing or ambiguous inputs>
```

Do not write files.

---

## Confirmation behavior

If not `--yes` and not `--dry-run`, show:

* target path
* whether the skill will be created or updated
* short inferred purpose
* source context used
* any important uncertainty

Ask for confirmation before writing.

---

## Final output after writing

After successful write, output only:

```text
✅ Created/updated custom skill

Path:
- .agents/skills/<skill_name>/SKILL.md

Purpose:
- <short purpose>
```

Do not dump the full skill content unless file writing is unavailable.

---

## Final quality bar

Before finalizing, verify:

* `SKILL.md` starts with valid YAML frontmatter
* `name` matches `<skill_name>`
* description is specific and useful
* the skill is based on the user-provided context
* the workflow is actionable
* uncertainty handling is explicit
* output requirements are clear
* hard constraints are visible
* examples are compact and relevant
* no unsupported repo conventions were invented
* no unrelated files were modified
* the skill is useful for repeated future agent tasks
