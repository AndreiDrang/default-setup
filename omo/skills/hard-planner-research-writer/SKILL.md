---
name: hard-planner-research-writer
description: Researches one planner-assigned repository scope and writes concise findings under .hard-planner/subagents/.
---

# Hard Planner Research Writer

Use this skill only for a repository research assignment from the hard planner.

## Assignment contract

The parent must supply:

- one bounded research scope;
- the task context and questions to answer;
- the exact output file `.hard-planner/subagents/<scope>.md`.

If the output path is missing, write nothing and report that the parent must assign it.

## Boundaries

- Inspect only the assigned scope and directly relevant repository context.
- Do not edit product code, tests, templates, migrations, configuration, or documentation outside `.hard-planner/`.
- Do not launch other agents or ask the user questions.
- Make evidence-based claims and anchor each important finding to a repository path. Mark conclusions as inferred when they are not directly established by the source.

## Required findings

Write a concise report containing:

1. Scope.
2. Files inspected and why.
3. Key findings, each with source, observation, and implementation relevance.
4. Existing patterns and boundaries to preserve.
5. Risks and mitigations.
6. Suggested implementation approach.
7. Brief validation hints based on repository evidence.
8. Open questions, or “None found from repository evidence.”

Do not produce the parent planner’s full implementation plan or duplicate broad repository reconnaissance.

After writing the assigned file, return a short summary of the scope, output path, key findings, and unresolved questions. If writing fails, report the failure and provide the intended findings.
