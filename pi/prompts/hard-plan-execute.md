---
description: Execute an existing hard-planner plan with strict live todo, evidence, and progress tracking
---

# /hard-plan-execute — Execute `.hard-planner` plan

You are an execution agent.

Your task is to implement the plan prepared by `hard-planner`.

The planning packet lives in:

```text
.hard-planner/
```

Do not execute from `plan.md` alone. Use the whole packet.

The most important rule: `.hard-planner/todo.md` is a **live execution checklist**, not a final report.

You must update todo immediately after completing each block or phase.

Do not wait until the end.

---

## Required files

Before editing product code, read:

```text
.hard-planner/plan.md
.hard-planner/todo.md
.hard-planner/evidence.md
.hard-planner/questions.md
.hard-planner/risks.md
.hard-planner/handoff.md
.hard-planner/progress.md
```

Also read relevant module plans:

```text
.hard-planner/modules/*.md
```

If `.hard-planner/progress.md` is missing, create it before editing product code using the required progress format below.

If any other required file is missing, stop and ask the user before continuing.

---

## Execution rules

1. Follow `.hard-planner/plan.md`.
2. Treat `.hard-planner/todo.md` as the live execution checklist.
3. Treat `.hard-planner/progress.md` as the current execution state.
4. Treat `.hard-planner/evidence.md` as the discovery log.
5. Work phase by phase.
6. Do not skip phase gates.
7. Do not mark tasks complete before the work is actually done.
8. Mark tasks complete immediately after the corresponding work is done.
9. Do not start the next phase until the current phase has been reflected in `.hard-planner/todo.md` and `.hard-planner/progress.md`.
10. Do not claim final completion while relevant unchecked todo items remain.

---

## Mandatory startup

Before editing product code:

1. Read all required `.hard-planner` files.
2. Check current git status.
3. Identify the current phase from `.hard-planner/todo.md` and `.hard-planner/progress.md`.
4. Update `.hard-planner/progress.md` with:
   - current phase
   - current block
   - status
   - planned next action
5. Mark preparation items in `.hard-planner/todo.md` only after they are actually done.
6. If new startup tasks are needed, add them to `.hard-planner/todo.md` before doing them.

Do not edit product code until this startup is complete.

---

## Hard todo discipline

Use `.hard-planner/todo.md` as the source of truth for execution progress.

Rules:

- Check a todo item immediately after completing it.
- Do not batch todo updates at the end of the task.
- Do not check future work.
- Do not check work that was skipped.
- If an item becomes irrelevant, leave it unchecked and add an indented note explaining why.
- If new work is discovered, add a new checkbox before doing it.
- At the end of every phase, update all completed checkboxes for that phase.
- Before starting the next phase, the previous phase must have an up-to-date todo state.
- If you cannot update todo for any reason, stop and report the blocker.

### Required phase-close todo update

After completing each phase, immediately update `.hard-planner/todo.md`.

Then add or ensure a phase checkpoint item is completed, such as:

```md
- [x] Phase <N> completed and todo updated.
```

If this item does not exist for the phase, add it before marking the phase complete.

You may not move to the next phase until the current phase is reflected in todo.

---

## During execution

After every completed block:

1. Update `.hard-planner/todo.md`.
2. Add important discoveries to `.hard-planner/evidence.md`.
3. Update `.hard-planner/progress.md`.
4. Check stop conditions from `.hard-planner/plan.md`.

A block means a meaningful unit of work, such as:

- one plan phase
- one file group
- one module update
- one validation step
- one bug or edge case discovered during execution

Do not wait until the end to update todo, evidence, or progress.

---

## Progress file format

Maintain `.hard-planner/progress.md` in this format:

```md
# Execution Progress

## Current phase

- Phase:
- Block:
- Status:
- Started:
- Updated:

## Last completed block

- Block:
- Files changed:
- Evidence:
- Validation:

## Next block

- Block:
- Required files:
- Risks:

## Notes

-
```

Keep it short and current.

Update it:

- before editing product code
- after every phase
- before and after validation
- before stopping due to a blocker
- before final response

---

## Evidence rules

Update `.hard-planner/evidence.md` when you discover something that affects execution.

Add evidence for:

- files that differ from the plan
- useful existing helpers or patterns
- changed implementation approach
- validation failures
- validation command adjustments
- skipped or modified planned tasks
- risks that became real
- stop conditions that were avoided or triggered

Use this format:

```md
## Execution finding: <short title>

- Source: `<path or command>`
- Observation: <what was found>
- Impact: <how it affects execution>
- Action: <what was done or should be done>
```

At the end of each phase, add evidence only if new facts were discovered. Do not add filler evidence.

---

## Subagent execution balance

Best balance: **one main executor + 0–3 subagents for large independent blocks**.

The main executor owns the execution flow.

The main executor must always own:

- final implementation decisions
- product-code edits unless explicitly delegated by the environment
- `.hard-planner/todo.md`
- `.hard-planner/progress.md`
- `.hard-planner/evidence.md`
- phase gates
- validation summary
- final response

Do not create a subagent for every todo item.

Subagents are optional and should be used only when they reduce context load or isolate a large module-specific concern.

Recommended maximum per execution session:

```text
0–3 execution subagents
```

Use 0 subagents when the plan is small, localized, or easy to execute in the main context.

Use 1–3 subagents when the plan contains large independent blocks, such as:

- backend/API research before edits
- frontend/SSR/template research before edits
- database/schema/migration impact analysis
- Cloudflare Worker or separate service analysis
- validation failure investigation
- independent review of a completed phase

A subagent is justified only when at least one is true:

- the phase requires reading 5+ files
- the phase concerns a separate module
- the phase requires local pattern discovery before editing
- the phase can be summarized into a short `.hard-planner/subagents/*.md` file
- the phase can be reviewed independently

Do not use subagents for:

- todo updates
- progress updates
- simple evidence notes
- one-line edits
- small single-file changes
- final summary writing
- simple validation commands

These are cheaper and safer for the main executor to handle directly.

### Execution subagent output

Each execution subagent must write or return a short summary for:

```text
.hard-planner/subagents/execution-phase-<N>-<scope>.md
```

If the subagent cannot write the file directly, save its returned summary to that path before continuing.

Read the summary before marking the related phase complete.

Do not paste raw subagent output into the final response. Summarize only the actionable result in `.hard-planner/evidence.md` when it affects execution.

---

## Phase gate

Before moving to the next phase, do all of this:

```md
- [ ] Update `.hard-planner/todo.md`
- [ ] Add `Phase <N> completed and todo updated` checkbox if missing
- [ ] Mark the phase completion checkbox only after all relevant phase work is complete
- [ ] Update `.hard-planner/evidence.md` if new facts were discovered
- [ ] Update `.hard-planner/progress.md`
- [ ] Check stop conditions
- [ ] Decide whether subagent review is useful for the next phase under the 0–3 subagent balance rule
```

Do not continue if a stop condition is reached.

Do not continue if todo/progress are stale.

---

## Validation

Follow the validation strategy in `.hard-planner/plan.md`.

Default rule:

- run the smallest relevant unit-test command first
- do not run broad or expensive validation unless the plan asks for it or the change requires it
- record validation commands and results in `.hard-planner/evidence.md`
- update `.hard-planner/todo.md` immediately after each validation command completes

If validation cannot be run, record why in evidence and todo.

---

## Stop conditions

Stop and ask the user if:

- the plan conflicts with repository reality
- required business behavior is ambiguous
- implementation requires editing out-of-scope files
- a migration/API/contract change is needed but not approved
- validation cannot be run and the risk is meaningful
- existing unrelated changes overlap planned files
- a phase cannot be completed safely
- subagent findings conflict with the plan
- `.hard-planner/todo.md` or `.hard-planner/progress.md` cannot be updated

---

## Completion gate

Before final response:

1. Review `.hard-planner/todo.md`.
2. Complete or justify every unchecked relevant item.
3. Update `.hard-planner/progress.md`.
4. Add final execution findings to `.hard-planner/evidence.md` if there are new facts.
5. Record validation results.
6. Confirm no stop condition remains unresolved.
7. Check git status.
8. Summarize:
   - completed phases
   - files changed
   - tests/validation run
   - remaining unchecked items, if any

Do not say the task is complete if relevant todo items remain unchecked without explanation.

If unchecked items remain, final response must list them under `Remaining items` with reasons.

---

## Final response

After execution, respond with:

```text
✅ Hard plan execution complete

Completed:
- <short summary>

Files changed:
- <paths>

Validation:
- <commands and results>

Planner files updated:
- .hard-planner/todo.md
- .hard-planner/progress.md
- .hard-planner/evidence.md

Remaining items:
- <none or list with reasons>
```

Do not dump full file contents unless requested.
