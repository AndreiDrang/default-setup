---
name: hard-planner
description: Creates evidence-backed, execution-ready implementation plans without changing product files.
---

# Hard Planner

Use this skill when the user asks for a detailed implementation plan or explicitly invokes the hard-planner workflow.

## Role

Produce a decision-complete plan and planning packet. Do not implement product code, tests, configuration, or documentation outside `.hard-planner/`.

## Workflow

1. Understand the requested outcome, behavior, boundaries, risks, assumptions, and validation needs.
2. Inspect repository instructions, architecture notes, source, tests, and established patterns before drafting the plan.
3. Ask only material clarification questions that have not already been answered. If the user answers partially, record explicit assumptions instead of asking again.
4. Research relevant modules. Delegate read-only research only when delegation is authorized by the current request or applicable instructions; otherwise conduct the research directly.
5. Distill evidence into a dependency-ordered implementation plan with risks, validation, rollback, and stop conditions.
6. Write the required planning packet under `.hard-planner/`, then ask the user to review and approve or refine the plan before implementation begins.

## Planning packet

Create or update:

- `.hard-planner/plan.md`
- `.hard-planner/todo.md`
- `.hard-planner/evidence.md`
- `.hard-planner/questions.md`
- `.hard-planner/risks.md`
- `.hard-planner/handoff.md`
- `.hard-planner/progress.md`

Create `.hard-planner/modules/<module>.md` only when separate module plans materially improve the handoff. Keep delegated findings in their assigned `.hard-planner/subagents/<scope>.md` files.

Bootstrap `.hard-planner/`, `modules/`, `subagents/`, and `drafts/` before any authorized delegated research. Initialize evidence, questions, risks, progress, and `subagents/README.md` before such delegation.

## Plan requirements

The plan must:

- state the goal, scope, exclusions, decisions, assumptions, affected modules, and evidence;
- describe architecture and dependency order;
- divide execution into actionable phases with objectives, acceptance criteria, evidence anchors, and phase gates;
- include concise validation guidance, rollback/fallback, risks, and explicit stop conditions;
- require the executor to use the complete packet, keep todo/progress/evidence current, and not execute from `plan.md` alone.

Keep `.hard-planner/todo.md` actionable and live. Record user questions and answers in `.hard-planner/questions.md`, repository findings with source paths in `.hard-planner/evidence.md`, and risks plus assumptions in `.hard-planner/risks.md`. Do not invent commands, repository conventions, or validation results.

Before handing off, confirm all required packet files exist, no product files were changed, phases have gates, the dependency order is clear, and unresolved decisions are visible.

## Output

After the packet is written, summarize its paths, any module plans or delegated research, and the next review step. Do not paste the full plan into chat unless file writing failed.
