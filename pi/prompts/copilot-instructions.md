---
description: Generate compact GitHub Copilot PR review instructions
---

You are a Staff/Principal Software Engineer, repository analyst, and AI workflow designer.

Your task is to generate a compact, production-ready GitHub Copilot instruction file for PR review in the current repository.

Target file:

`.github/copilot-instructions.md`

The generated file must help GitHub Copilot review pull requests safely, consistently, and in a repository-specific way.

---

## Hard output limit

The final `.github/copilot-instructions.md` must be **4000 characters or fewer**.

This is a hard requirement.

After writing the file, run:

```bash
wc -m .github/copilot-instructions.md
```

Rules:

- If the count is `4000` or less, the file is valid.
- If the count is greater than `4000`, rewrite the file shorter and run `wc -m` again.
- Do not finalize until the file is within the limit.
- Prefer removing generic text before removing repository-specific guardrails.
- Keep the PR review output format block even when compressing.

If file writing is unavailable, output only the final Markdown content and ensure it is clearly under 4000 characters by being deliberately concise.

---

## Objective

Create a concise, high-signal `copilot-instructions.md` that tells Copilot how to review PRs in this repository.

The generated instructions must help Copilot:

- understand the repository shape
- respect architecture and module boundaries
- detect risky or out-of-scope changes
- review correctness, safety, maintainability, and validation
- score PR quality from `0` to `10`
- produce actionable, non-generic review comments
- use the required output format

The result must be repository-specific, not a generic review template.

---

## Non-negotiable constraints

1. Generate only the final Markdown content for `.github/copilot-instructions.md`.

2. Keep the generated file under 4000 characters.

3. Ground every repository-specific rule in observable repository evidence.

4. Do not invent:
   - tools
   - commands
   - frameworks
   - architecture rules
   - deployment workflows
   - test commands
   - ownership rules

5. Prefer concise bullets over prose.

6. Do not duplicate large local docs. Reference important docs by path.

7. If a command or convention is unclear, write conservative guidance instead of guessing.

8. The generated file must include the exact PR review output format section with emojis and blank lines.

---

## Silent repository analysis

Before writing the file, inspect the repository.

Look for:

- primary language and framework
- app type: backend, frontend, SSR, worker, CLI, library, monorepo, extension, infra
- source roots
- test roots
- build/test/lint commands
- package managers
- CI workflows
- migrations/schemas
- generated code
- API contracts
- frontend/server boundaries
- important docs:
  - `README.md`
  - `ARCHITECTURE.md`
  - `AGENTS.md`
  - `CONTRIBUTING.md`
  - module READMEs
  - docs under `docs/` or `wiki/`

Use only stable, useful findings.

---

## What to include in the generated file

The generated `copilot-instructions.md` should usually include these compact sections:

```md
# GitHub Copilot Instructions

## Repository context

## Review priorities

## Repository guardrails

## Validation

## PR scoring

## Output format
```

You may rename sections slightly, but keep the document short.

---

## Section guidance

### Repository context

Include 3–6 bullets.

Mention:

- what the repository is
- main source/test/docs directories
- important architecture or module boundaries
- where Copilot should look first

Do not include a full file tree.

### Review priorities

Tell Copilot to focus on:

- correctness
- safety
- regression risk
- architecture fit
- scope control
- maintainability
- validation/tests
- edge cases
- repository-specific contracts

### Repository guardrails

Include only rules supported by repo evidence.

Examples:

- preserve backend/frontend/SSR boundaries
- do not hand-edit generated files
- keep schema and code aligned
- avoid unrelated refactors
- keep changes scoped to the touched module
- be careful with migrations, public APIs, parser logic, SEO, auth, payments, data pipelines, browser extension permissions, or deployment files when present

### Validation

Include exact validation commands only if discoverable.

If unclear, say:

```md
Use the smallest relevant test or validation command documented in this repository.
```

Prefer scoped validation over broad commands.

### PR scoring

Include this scoring scale, compressed if needed:

- `0–2`: broken, unsafe, or careless
- `3–4`: major issues, rework needed
- `5–6`: acceptable but needs fixes or clarity
- `7–8`: solid, mergeable, minor issues only
- `9`: excellent, well-scoped and well-validated
- `10`: rare, exemplary change

Also include:

- do not inflate scores
- `10/10` should be rare
- do not give high scores to PRs that break repository boundaries
- reward small, safe, well-scoped PRs
- judge by evidence in the diff, not vibes

### Output format

The generated file must include this exact section format:

```md
**Output format:**
```

Then include this fenced block exactly, preserving emojis and blank lines between lines:

```md
🚧 **Score**: X/10

📃 **Summary**: <one paragraph>

💖 **What is strong**: <bullets>

🙅 **Problems found**: <bullets, labeled blocking/important/optional>

🪴 **Suggested improvements**: <bullets>
```

The blank lines are required for correct rendering.

---

## Problems found severity

Tell Copilot to label problems as:

- `blocking`: correctness, safety, security, data loss, broken contract, migration risk, major architecture violation
- `important`: maintainability, missing validation, fragile logic, unclear behavior, regression risk
- `optional`: naming, small clarity improvements, local simplification, polish

Copilot should avoid nitpicks unless they materially improve the PR.

---

## Compression rules

If the generated file is too long:

1. Remove generic explanations.
2. Shorten repository overview.
3. Keep only the strongest guardrails.
4. Keep validation concise.
5. Keep PR scoring compact.
6. Do not remove the required output format.
7. Do not remove the 0–10 scoring requirement.

Target length before writing: 3000–3600 characters.

Absolute maximum after `wc -m`: 4000 characters.

---

## Final generated file quality bar

Before finalizing `.github/copilot-instructions.md`, verify:

- it is under 4000 characters
- `wc -m .github/copilot-instructions.md` was run
- it is repository-specific
- it contains no hallucinated tools or commands
- it is useful for PR review
- it includes PR scoring from `0` to `10`
- it includes severity labels
- it includes the emoji output format with blank lines
- it is concise enough for GitHub Copilot to actually use

---

## File writing behavior

If file writing is supported:

1. Create `.github/` if needed.
2. Write `.github/copilot-instructions.md`.
3. Run:

```bash
wc -m .github/copilot-instructions.md
```

4. If over 4000 characters, shorten and rewrite.
5. Run the check again.
6. Final response should only be:

```text
✅ Copilot instructions created

Path:
- .github/copilot-instructions.md

Characters:
- <wc -m count>
```

If file writing is not supported:

Return only the final Markdown content for `.github/copilot-instructions.md`.

Do not include analysis, explanations, raw repository scan notes, or this meta-prompt.
