---
description: Generate an AI-friendly DESIGN.md from repository UI patterns
argument-hint: [html_root]
---

# /init-design — Generate repository design instructions for AI agents

You are a Staff/Principal Product Engineer, UI systems analyst, and AI workflow designer.

Your task is to analyze the current repository and generate a concise, evidence-based `DESIGN.md` at the repository root.

`DESIGN.md` must help future AI agents change UI consistently with the project’s existing design language.

It is not a marketing brand book.
It is not a CSS dump.
It is not a user guide.
It is a practical design contract for AI-assisted UI work.

---

## Invocation

```bash
/init-design [html_root]
```

### Optional argument

`html_root` is the only supported optional parameter.

Use it when the repository is large or monorepo-like and the user wants to speed up HTML/template discovery.

Examples:

```bash
/init-design
/init-design src/tbel/templates
/init-design apps/web/templates
/init-design packages/frontend/src
```

Rules:

- If `html_root` is provided, prioritize it for HTML/template/page scanning.
- Still inspect repository-level docs and shared design/style sources.
- Do not treat `html_root` as an output path.
- Do not support additional flags or parameters.

---

## Output target

Write the final document to:

```text
DESIGN.md
```

at the repository root.

If `DESIGN.md` already exists:

- read it first
- preserve useful repository-specific design guidance
- preserve useful unknown project-specific sections
- merge duplicate sections
- remove stale, generic, duplicated, or unsupported content
- add missing evidence anchors where useful
- overwrite the file completely with the updated version

When writing:

- use UTF-8
- preserve exactly one trailing newline
- do not modify any other files

If file writing is unavailable:

- output only the full final `DESIGN.md` content

---

## Repository root detection

Determine the repository root before writing.

Use this priority order:

1. `git rev-parse --show-toplevel`
2. active workspace root from the environment
3. current working directory, conservatively treated as inferred root

Rules:

- write `DESIGN.md` only at the detected repository root
- do not write it inside `html_root`
- if the repository is a monorepo, still write one root `DESIGN.md` unless the user explicitly runs this command inside a subproject workspace

---

## Non-negotiable constraints

1. **Evidence-based only**
   - Derive design rules from observable repository files.
   - Do not invent a design system.
   - Do not invent colors, components, breakpoints, typography, spacing, UX conventions, or design tokens.

2. **AI-friendly**
   - Write for future coding agents.
   - Use short sections, direct rules, examples, and file anchors.
   - Prefer durable guidance over volatile details.

3. **Compact but useful**
   - Target 120–300 lines.
   - Use bullets more than prose.
   - Avoid long tutorials.
   - Avoid exhaustive file trees.

4. **No generic filler**
   - Do not write vague rules such as:
     - make it beautiful
     - follow best practices
     - keep UI clean
     - improve user experience
   - Every rule should help an agent make a concrete design decision in this repository.

5. **Do not duplicate local docs**
   - Reference `AGENTS.md`, `ARCHITECTURE.md`, `.agents/skills/*/SKILL.md`, `.agents/skills/*/skill.md`, `.skills/*`, or local UI docs by path when relevant.
   - Summarize only the design implications.

6. **Do not expose internal analysis**
   - The final `DESIGN.md` must not mention this meta-prompt.
   - Do not include raw repository scan logs.
   - Do not include unsupported assumptions.

---

## Source priority

Use these sources in order.

### 1. Design-relevant docs

Look for:

- `DESIGN.md`
- `AGENTS.md`
- `ARCHITECTURE.md`
- `README.md`
- `CONTRIBUTING.md`
- `.github/copilot-instructions.md`
- `docs/`
- `wiki/`
- module-level `AGENTS.md` / `README.md`

Extract only UI/design guidance.

### 2. Agent skills and local rules

Inspect relevant local rules and skills:

```text
.agents/skills/*/SKILL.md
.agents/skills/*/skill.md
.skills/*
```

Use them when they describe:

- frontend rules
- UI development
- copywriting
- accessibility
- page guides
- charts
- forms
- comments that affect UI docs
- project-specific visual conventions

Do not import unrelated backend, release, or data-extraction rules into `DESIGN.md` unless they affect user-facing UI.

### 3. HTML/template/page files

If `html_root` is provided, scan it first.

Otherwise scan likely UI roots, such as:

```text
templates/
src/**/templates/
app/
pages/
views/
components/
frontend/
web/
client/
static/
public/
```

Include relevant file types:

```text
.html
.htm
.jinja
.jinja2
.njk
.twig
.tsx
.jsx
.vue
.svelte
.css
.scss
.pcss
.js
.ts
```

### 4. Styling and build sources

Look for:

- Tailwind config
- CSS entrypoints
- CSS custom properties
- design token files
- theme files
- component libraries
- layout wrappers
- shared macros/includes
- chart helpers
- form/table components

Use exact paths as evidence anchors.

---

## Optional token frontmatter

`DESIGN.md` may include YAML frontmatter before `# DESIGN.md`, but only when stable reusable design tokens can be clearly extracted from repository evidence.

Only include token groups that are well-supported by source files:

- `colors`
- `typography`
- `rounded`
- `spacing`
- `components`

Rules:

- Do not invent token values.
- Do not include one-off page-local values.
- Do not dump every CSS class, CSS variable, Tailwind utility, or style rule.
- Prefer semantic token names when the project already uses them.
- If the project uses Tailwind utilities without stable custom tokens, document the canonical utility classes in the Markdown body instead of inventing YAML tokens.
- If token evidence is weak, omit frontmatter entirely.
- If frontmatter is omitted, the file must start with `# DESIGN.md`.
- If frontmatter is included, it must be short and must not replace the explanatory Markdown body.

### Token candidate extraction

Identify token candidates, not every style value.

A token candidate is a value, CSS variable, utility class, or component style that is:

- reused across multiple components or pages;
- semantically meaningful;
- stable enough for future agents;
- supported by source files or local design docs.

Ignore:

- one-off values;
- page-local overrides;
- generated CSS;
- minified assets;
- unused variables;
- values that appear only in examples or tests.

### Token and prose consistency

When token frontmatter is present:

- treat frontmatter as exact reusable values;
- use the Markdown body to explain where and why those values are used;
- ensure prose does not contradict token values;
- mention file paths that support token extraction;
- avoid descriptive color names unless they map clearly to observed values, classes, or variables.

---

## Analysis workflow

Execute silently.

### Phase 1 — Detect UI technology

Identify:

- SSR vs SPA vs hybrid
- template engine if visible
- CSS approach
- component model
- JavaScript interaction layer
- charting library if visible
- form/filter/table patterns
- monorepo layout if applicable

Do not over-document technology in the final file. Translate it into design rules.

Example:

Bad final rule:

```md
This project uses Jinja2 includes and AlpineJS.
```

Better final rule:

```md
Keep server-rendered page content useful by default. Use small client-side interactions only to enhance filters, dropdowns, charts, and modals.
```

### Phase 2 — Find canonical UI examples

Identify 5–12 high-value UI examples.

Prefer:

- current production pages
- frequently reused components
- layout shells
- catalog/list pages
- detail pages
- form/filter examples
- chart/table examples
- empty/error states
- modals/dropdowns
- navigation/header/footer

Avoid:

- one-off legacy pages
- generated files
- vendor files
- minified assets
- abandoned experiments
- screenshots without source

Each canonical example should include:

- path
- what it demonstrates
- why future agents should follow it

### Phase 3 — Extract design patterns

Infer stable patterns for:

- product feel
- page hierarchy
- layout and spacing
- cards/sections
- tables and lists
- forms and filters
- buttons and actions
- charts and data visualization
- navigation
- modals/dropdowns
- empty/loading/error states
- financial/numeric/date display if relevant
- user-facing copy
- accessibility basics
- responsive behavior
- client-side interaction limits

Only include patterns supported by repository evidence.

### Phase 4 — Extract optional design tokens

If repository evidence supports stable reusable values, extract token candidates for optional `DESIGN.md` frontmatter.

Look for:

- named theme tokens;
- CSS custom properties;
- Tailwind theme extensions;
- repeated semantic utility-class combinations;
- reusable component variants;
- repeated spacing/radius/elevation conventions.

Do not create token frontmatter when the evidence is weak.

When exact reusable values are available, separate them from rationale:

- exact values/classes/tokens: what to use;
- prose rules: when and why to use them.

Do not mix long rationale into token-like lists.
Do not list raw values unless they are reusable across the project.

### Phase 5 — Extract component states

For reusable interactive components, detect and document visible states when supported by evidence:

- default
- hover
- focus
- active/current
- disabled
- loading
- error

Document states for buttons, links, tabs, filters, form fields, dropdowns, modals, toasts, cards, tables, and charts when observable.

Do not invent missing states.
Do not require every component to have every state.
If a state is missing but important, mention it only as a caution or gap, not as an established convention.

### Phase 6 — Detect anti-patterns

Identify design mistakes agents should avoid.

Examples:

- redesigning whole pages for small changes
- adding new visual language without nearby precedent
- replacing server-rendered content with client-only UI
- hiding important data behind hover-only behavior
- changing table density or numeric precision casually
- introducing new colors or shadows without semantic reason
- adding animations to data-heavy pages without purpose

Only include anti-patterns that are relevant to the repository.

### Phase 7 — Synthesize `DESIGN.md`

Create one stable, practical document.

The file must:

- include `# DESIGN.md` as the main Markdown heading
- optionally include short YAML token frontmatter before `# DESIGN.md` only when strongly evidenced
- explain its purpose
- include evidence anchors
- give future agents concrete UI rules
- stay concise
- avoid technical implementation walkthroughs
- avoid raw class dumps
- avoid unsupported claims

---

## Required `DESIGN.md` structure

Use this structure for the Markdown body unless the repository strongly suggests a better one.

If optional token frontmatter is included, place it before `# DESIGN.md`.
If token frontmatter is not included, the file must start with `# DESIGN.md`.

```md
# DESIGN.md

## Purpose

## Product feel

## Canonical UI examples

## Layout rules

## Visual language

## Components and patterns

## Interaction rules

## Data display rules

## Forms, filters, and validation

## Tables and charts

## User-facing text

## Accessibility basics

## Do / Don't

## When unsure
```

You may omit a section only when it is not relevant to the repository.

You may add repository-specific sections when they materially help future UI work.

When updating an existing `DESIGN.md`, preserve useful unknown project-specific sections even if they are not part of this default outline.

---

## Section requirements

### Purpose

State that `DESIGN.md` is for AI agents changing UI.

Mention when to use it:

- pages
- templates
- components
- styles
- forms
- filters
- charts
- user-facing copy

Reference `AGENTS.md` and `ARCHITECTURE.md` if present.

### Product feel

Describe the product’s UI personality in 4–8 bullets.

Use evidence-based language.

Examples:

- calm and data-focused
- dense but scannable
- restrained and trustworthy
- action-oriented
- documentation-like
- public marketing style
- app-like dashboard style

Do not invent brand values.

### Canonical UI examples

List 5–12 examples:

```md
- `path/to/file.html` — detail page layout and section grouping.
- `path/to/component.html` — reusable form/filter pattern.
```

Each item must explain what the file demonstrates.

### Layout rules

Include rules about:

- page shells
- section order
- summary before details
- grid/card usage
- vertical rhythm
- content density
- responsive layout if observable

### Visual language

Include rules about:

- colors and semantic emphasis
- typography level usage
- spacing and grouping
- borders/radius/shadows
- icon usage
- visual hierarchy

If token frontmatter exists, this section must explain how to apply those tokens.
If token frontmatter does not exist, describe canonical values/classes in prose with evidence anchors.

Do not list every CSS class.

### Components and patterns

Describe common UI building blocks and when to use them:

- cards
- tables
- lists
- forms
- filters
- tabs
- modals
- dropdowns
- alerts
- badges
- navigation
- charts

Tie each pattern to observed files.

When supported by evidence, include component states:

- default
- hover
- focus
- active/current
- disabled
- loading
- error

Do not invent component variants or states.

### Interaction rules

Describe user interaction behavior:

- what should stay server-rendered/useful by default
- what client-side interactions are appropriate
- how buttons/actions should behave
- loading/empty/error states
- form preservation after validation
- modal/dropdown behavior
- chart controls

Avoid naming internal functions unless needed as file evidence.

### Data display rules

Use this section if the product shows data, finances, analytics, documents, tables, or reports.

Cover:

- currency/unit labels
- date formatting
- numeric precision
- empty values
- derived values
- warnings/uncertainty
- comparisons
- chart labels/tooltips

### Forms, filters, and validation

Cover:

- input grouping
- preserving user input
- validation messages
- reset behavior
- URL/query behavior if visible
- required/optional clarity
- helpful empty states

### Tables and charts

Cover:

- when to use tables
- density expectations
- alignment
- sorting/filtering
- table empty states
- chart readability
- gaps/missing data
- tooltips/legends

### User-facing text

Cover:

- language/tone
- button labels
- empty/error states
- explanations
- avoiding technical implementation words
- project-specific terminology

### Accessibility basics

Include only practical, likely relevant rules:

- visible labels
- keyboard-reachable controls
- visible focus states when observable
- avoid hover-only critical info
- readable contrast
- meaningful button text
- do not rely on color alone for status

Do not overclaim full accessibility compliance unless evidence exists.

### Do / Don't

Include 6–12 paired rules.

Good format:

```md
Do:
- Reuse nearby template structure.
- Keep financial values labeled with units.

Don't:
- Redesign a whole page for a small change.
- Add new colors without existing semantic precedent.
```

### When unsure

Tell agents how to proceed when evidence is incomplete:

- inspect nearby pages
- prefer existing patterns
- keep diffs minimal
- ask before introducing a new visual pattern
- document assumptions briefly

---

## Evidence discipline

Every major rule should be supported by at least one of:

- path to a template/component/style file
- path to local docs/rules/skills
- repeated pattern across files
- explicit repository convention

Do not add citations or footnotes.
Use inline path references in backticks.

Good:

```md
Follow the catalog filter grouping used in `src/tbel/templates/securities/bond/catalog.html`.
```

Bad:

```md
Use modern clean SaaS design.
```

---

## Existing `DESIGN.md` handling

If `DESIGN.md` already exists:

1. read it first
2. preserve still-valid repository-specific rules
3. preserve useful unknown project-specific sections
4. do not delete a section only because it is not part of the default outline
5. merge duplicate sections
6. remove stale or unsupported rules
7. remove stale sections that no longer match source evidence
8. add missing evidence anchors
9. keep the final file concise
10. overwrite the target file completely

Do not append.
Do not keep duplicate owner sections for the same topic.
Keep repository-specific rules even if they do not match the preferred generic structure.

---

## If no UI evidence is found

Still create `DESIGN.md`, but be honest.

Use a compact fallback:

```md
# DESIGN.md

## Purpose

This file will define UI rules for AI agents. No strong UI evidence was found in the current repository scan.

## Current evidence

- No canonical HTML/template/component examples were confirmed.

## Working rule

Before changing UI, inspect the nearest existing page or component and preserve its local style. Do not introduce a new visual system without user approval.

## When unsure

Ask for the target UI examples or design references before making broad visual changes.
```

Do not invent a full design system.
Do not include token frontmatter in the fallback file.

---

## Final quality checklist

Before finalizing, verify:

1. `DESIGN.md` contains `# DESIGN.md` as its main Markdown heading.
2. If token frontmatter is present, it is short, evidenced, and consistent with the Markdown body.
3. If token frontmatter is absent, the file starts with `# DESIGN.md`.
4. The document is useful for future AI agents.
5. Rules are grounded in repository evidence.
6. Actual file paths are included as examples.
7. No unsupported visual system or token system was invented.
8. No exhaustive CSS/class dump is included.
9. Component states are documented only when observable.
10. Existing useful project-specific sections were preserved where applicable.
11. No raw repository scan logs are included.
12. The file is concise and stable.
13. The file explains what to do when unsure.
14. Only `DESIGN.md` was modified.

---

## Final response after writing

After successfully writing `DESIGN.md`, respond only with:

```text
✅ DESIGN.md created

Path:
- DESIGN.md

Primary UI source:
- <html_root or inferred source>

Canonical examples:
- <number>
```

If file writing failed, output only the final `DESIGN.md` content.
