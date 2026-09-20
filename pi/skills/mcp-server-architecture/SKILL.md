---
name: mcp-server-architecture
description: Analyzes, prepares, and reviews MCP server architecture using MCP patterns, anti-pattern checks, tool budgets, security, versioning, and observability.
---

# MCP Server Architecture

## When to use this skill

Use this skill when asked to design, review, refactor, or document the architecture of a Model Context Protocol (MCP) server or a fleet of MCP servers.

Typical triggers:

- "design an MCP server"
- "review this MCP server architecture"
- "prepare architecture for an MCP server"
- "split these MCP tools correctly"
- "analyze MCP tools/resources/prompts"
- "check MCP anti-patterns"
- "create an MCP architecture plan"
- "decide whether this should be one MCP server or several"
- "prepare an MCP server for public/production use"

Use this skill for both new and existing MCP servers.

This skill is architecture-focused. It does not replace implementation-specific SDK documentation, but it should guide the structure of tools, resources, prompts, state, transport, authentication, versioning, observability, and maintenance seams.

## Core model

Treat MCP server design as API design for an LLM client.

The LLM chooses tools by reading names, descriptions, schemas, and returned content. Tool descriptions, resource naming, prompt contracts, and error messages are load-bearing architecture artifacts, not comments.

MCP servers expose three primary primitives:

- `tools` — callable operations with names, natural-language descriptions, and JSON Schema input contracts.
- `resources` — URI-addressed readable data, static or dynamic.
- `prompts` — reusable server-managed templates surfaced to clients or users.

Common transports:

- `stdio` — usually local, low-overhead, good for local developer tooling.
- `streamable-http` — remote-capable, supports HTTP deployment and transport-layer authentication.

## Inputs to collect

Required for architecture analysis:

- Existing MCP server code or planned capability list.
- Tool list, names, descriptions, input schemas, outputs, and side effects.
- Resource list, URI scheme, data origin, response shape, and sanitization policy.
- Prompt list, parameters, intended use, and ownership.
- Transport mode: `stdio`, `streamable-http`, or both.
- Backend systems the server reads from or writes to.
- Authentication and authorization requirements.
- Expected users/clients and deployment environment.

Optional but useful:

- Existing architecture docs.
- API contracts/OpenAPI schemas for upstream systems.
- Current logs or telemetry.
- Known failure modes.
- Security constraints.
- Versioning/release policy.
- Performance or latency requirements.
- Multi-tenant requirements.
- Existing MCP client constraints, especially tool-count/context limits.

If the task lacks enough information, make a best-effort analysis and clearly mark unknowns. Do not invent capabilities, security guarantees, or deployment constraints.

## Analysis modes

Choose the appropriate mode based on the user request.

### 1. Existing-server review

Use when a server already exists.

Inspect:

- registration of tools, resources, and prompts;
- JSON schemas and validation;
- tool descriptions;
- transport configuration;
- auth handling;
- state/session handling;
- delegation to other MCP servers or upstream APIs;
- error handling;
- logging/metrics;
- versioning and migration behavior.

Produce an architecture review with findings, pattern classification, anti-pattern risks, and recommended changes.

### 2. New-server design

Use when designing a server from requirements.

Produce:

- chosen primary architecture pattern;
- tool/resource/prompt inventory;
- decomposition rationale;
- state policy;
- transport choice;
- auth and authorization model;
- versioning policy;
- observability plan;
- risks and implementation checklist.

### 3. Refactor plan

Use when the user has too many tools, vague tools, overloaded workflows, or mixed responsibilities.

Produce:

- current structure diagnosis;
- target pattern or pattern mix;
- tool/resource split;
- deprecation/migration plan;
- backwards compatibility notes;
- test/validation strategy.

## Pattern taxonomy

Classify every MCP server with one primary pattern. Also identify cross-cutting attributes such as statefulness, domain adaptation, aggregation, or resource-heavy behavior.

A server may have one primary pattern and several secondary characteristics.

### Resource Gateway

Use when the server primarily exposes backend data for LLM grounding.

Best fit:

- databases;
- document stores;
- internal catalogs;
- read-mostly APIs;
- company, product, finance, CRM, or knowledge data.

Design rules:

- Expose stable read surfaces as `resources` when URI addressing is natural.
- Use `tools` for parameterized queries that do not fit safe URI templates.
- Add a sanitization layer before returning externally sourced or user-generated content to the LLM.
- Keep resource names and URIs predictable.
- Keep backend schema churn behind the MCP layer when possible.

Watch for:

- prompt injection through resource content;
- leaking raw backend schema details;
- complex joins hidden in unclear resources;
- weak access control on read paths.

### Tool Orchestrator

Use when the server primarily exposes actions or multi-step workflows.

Best fit:

- DevOps operations;
- CI/CD workflows;
- issue/ticket workflows;
- customer support actions;
- cross-system operations;
- business processes where the LLM should call one workflow, not many low-level APIs.

Design rules:

- Expose complete user-intent operations, not raw internal API steps.
- Keep each tool name specific and action-oriented.
- Handle partial failure inside the server and return a clear structured result.
- Avoid forcing the LLM to coordinate multiple low-level calls when the sequence is deterministic.
- Describe side effects explicitly.

Watch for:

- too many narrow tools;
- too few over-broad tools;
- hidden multi-step side effects;
- vague descriptions that do not tell the LLM when to use the tool.

### Stateful Session Server

Use only when later calls genuinely depend on state established earlier.

Best fit:

- browser automation;
- code editing sessions;
- open file/edit/save workflows;
- database transactions;
- multi-step forms;
- long-running interactive workflows.

Design rules:

- Document what state exists, where it lives, and when it expires.
- Use session IDs or equivalent handles explicitly.
- Reap idle sessions.
- Use a distributed store when horizontally scaled.
- Avoid state if the same result can be achieved with explicit tool arguments.

Watch for:

- memory leaks from unreaped sessions;
- LLM failing to pass session IDs reliably;
- hidden state that makes behavior hard to debug;
- state that should have been an explicit resource or job object.

### Proxy Aggregator

Use when one endpoint presents capabilities from multiple upstream MCP servers or domains.

Best fit:

- enterprise MCP gateway;
- multi-domain assistant backend;
- centralized auth/audit layer;
- server fleet routing;
- client configuration simplification.

Design rules:

- Namespace upstream tools to avoid collisions.
- Preserve upstream identity and failure boundaries.
- Prefer scoped aggregation over static merging when the tool set is large.
- Route only relevant tools into a given client context.
- Centralize audit logging and auth policy.

Watch for:

- single point of failure;
- ambiguous tool namespaces;
- static union of too many tools;
- upstream failures hidden behind generic proxy errors;
- aggregation that worsens tool selection.

### Domain-Specific Adapter

Use when the upstream API is useful but not LLM-friendly.

Best fit:

- APIs with machine IDs or complex parameters;
- domain systems requiring normalization;
- financial, healthcare, CRM, legal, or enterprise systems;
- systems where raw API errors need translation.

Design rules:

- Translate domain concepts into LLM-friendly tool names and descriptions.
- Normalize inputs such as dates, names, identifiers, and user-facing labels.
- Enrich outputs by resolving IDs to display names when safe.
- Translate upstream errors into actionable, plain-language structured errors.
- Avoid reimplementing core business logic when the upstream system already owns it.

Watch for:

- over-engineering an already LLM-friendly API;
- duplicating upstream business rules;
- stale mappings after upstream API changes;
- hiding important domain constraints.

## Pattern selection guide

Use this decision logic:

1. Is the main goal to read and ground data? Prefer `Resource Gateway`.
2. Is the main goal to perform multi-step actions? Prefer `Tool Orchestrator`.
3. Does the server require persistent per-session state? Add `Stateful Session Server` as primary or cross-cutting.
4. Does the server combine multiple upstream MCP servers? Prefer `Proxy Aggregator`.
5. Is the upstream API too low-level or domain-heavy for LLM use? Prefer `Domain-Specific Adapter`.

If two patterns fit, choose the one that explains the dominant maintenance seam.

Examples:

- A database connector with sanitized readable rows: `Resource Gateway`.
- A GitHub issue workflow that creates an issue, assigns it, and posts a Slack update: `Tool Orchestrator`.
- A browser automation server with open tabs and page state: `Stateful Session Server`.
- A gateway that exposes GitHub, Slack, database, and filesystem tools through one endpoint: `Proxy Aggregator`.
- A financial system wrapper that accepts ticker/name/date inputs and normalizes them into internal IDs: `Domain-Specific Adapter`.

## Tool design rules

Every tool must have a clear job.

For each tool, document:

- name;
- purpose;
- when to use it;
- when not to use it;
- input schema;
- required vs optional fields;
- output shape;
- side effects;
- authorization scope;
- expected latency;
- failure modes;
- idempotency;
- examples if helpful.

### Tool naming

Use names that are:

- specific;
- domain-readable;
- action-oriented for side-effect tools;
- retrieval-oriented for query tools;
- stable across backend refactors.

Avoid names like:

- `do_anything`;
- `execute`;
- `send_message` without domain context;
- `handle_request`;
- `query` when several distinct query types exist.

### Tool descriptions

Tool descriptions must explain:

1. what the tool does;
2. when the LLM should use it;
3. what the tool returns;
4. important constraints or side effects.

Bad:

```text
send_message: Sends a message.
```

Better:

```text
send_support_update: Posts a customer-support status update to the selected Slack channel for an existing ticket. Use only after the ticket ID is known. Returns the Slack message URL and delivery status.
```

## Tool-count budget

Keep the active tool context small enough for reliable LLM tool selection.

Rules:

- Treat `10–15 tools` as the practical warning zone for a single LLM context.
- If a server exposes more than roughly 10–15 active tools, consider grouping, splitting, or scoped retrieval.
- Avoid static aggregation of large unrelated tool sets.
- Prefer per-task tool scoping when using a Proxy Aggregator.
- Merge low-level tools into workflow tools when the LLM should not manage the sequence.
- Split God Tools when one schema hides many unrelated actions.

Do not treat the number as a hard universal limit. Use it as an architecture review trigger.

## Resource design rules

Use resources for stable, readable, URI-addressed data.

For each resource family, document:

- URI scheme;
- list/read behavior;
- MIME type;
- data source;
- access control;
- sanitization policy;
- caching/freshness policy;
- pagination or size limits;
- broken/not found behavior.

Rules:

- Sanitize external or user-generated content before it reaches the LLM.
- Avoid returning hidden instructions, raw HTML noise, or untrusted text without boundaries.
- Prefer predictable URI patterns.
- Keep responses focused; avoid huge resource dumps.
- Include enough metadata for the LLM to cite or reason about the resource.

## Prompt design rules

Use server-side prompts only for reusable workflows or templates that should be versioned with the server.

For each prompt, document:

- name;
- intended user/task;
- parameters;
- expected context/resources;
- output contract;
- versioning policy;
- limitations.

Avoid prompts that duplicate tool descriptions or hide business logic that should be enforced server-side.

## State and long-running work

Avoid hidden state by default.

Use state only when it materially improves correctness or user workflow.

For stateful servers:

- define session scope;
- define session expiration;
- define storage backend;
- document cleanup/reaping;
- include state handles in outputs when the LLM must reuse them;
- provide recovery behavior for expired/missing sessions.

For long-running operations:

- do not expose them as synchronous tools if they can exceed normal client timeout expectations;
- return a job ID quickly;
- expose a separate status/polling tool;
- document terminal states and retry behavior.

## Authentication and authorization

Prefer transport-layer authentication for remote MCP servers.

Rules:

- Authenticate streamable-http servers at the transport layer.
- Do not bury primary authentication inside individual tool handlers unless required by upstream delegation.
- Scope credentials to tool sets or resource families.
- Log caller identity for each tool call.
- Separate read-only tools from mutating tools in scopes and descriptions.
- Avoid exposing powerful write tools without explicit authorization boundaries.

## Error handling

Return structured, LLM-readable errors where possible.

Error responses should include:

- stable error code;
- short human-readable message;
- retryability;
- missing/invalid field if applicable;
- whether user action is needed;
- safe next step.

Avoid throwing opaque exceptions when the LLM can recover by changing inputs, asking the user, or retrying later.

## Versioning and compatibility

MCP tool schemas are contracts.

Rules:

- Include server version in initialization metadata when possible.
- Treat breaking tool schema changes as major-version changes.
- Keep old schemas available during a migration window when clients may still depend on them.
- Prefer adding optional fields over changing required fields.
- Document deprecated tools with replacements.
- Avoid silently changing output shape.

## Observability

MCP server logs are the primary debugging surface for LLM misbehavior.

Log per call:

- tool or resource name;
- caller identity or tenant when available;
- input hash, not raw sensitive input;
- latency;
- output size;
- error code;
- upstream system called;
- session ID or job ID when applicable.

Do not log secrets, raw credentials, personal data, or large unredacted payloads.

For production architecture, also consider:

- per-tool success/error rates;
- timeout counts;
- schema validation failures;
- tool selection confusion signals;
- resource sanitization failures;
- upstream dependency health.

## Anti-pattern checks

Always check for these anti-patterns.

### God Tool

Symptoms:

- one tool accepts `action`, `operation`, or arbitrary `params`;
- schema is too broad;
- the LLM must infer an internal command language.

Fix:

- split into named tools with specific schemas and descriptions.

### Unsanitized Resource Content

Symptoms:

- user-generated content is returned directly;
- documents/comments/pages can include instructions to the LLM;
- HTML or external text is passed through without boundaries.

Fix:

- sanitize, escape, quote, or clearly delimit untrusted content before returning it.

### Synchronous Long-Running Operation

Symptoms:

- tool performs large file processing, crawling, rendering, video/audio processing, or batch jobs synchronously;
- client timeouts are likely.

Fix:

- return job ID and add status/polling tool.

### Missing or Vague Tool Descriptions

Symptoms:

- description repeats the tool name;
- description omits use case, return value, or side effects;
- similar tools are hard to distinguish.

Fix:

- rewrite descriptions as decision aids for the LLM.

## Architecture output templates

Use these templates when producing analysis or design artifacts.

### MCP Architecture Review

```md
# MCP Architecture Review

## Summary

## Current server shape

- Primary pattern:
- Secondary characteristics:
- Transport:
- Tool count:
- Resource families:
- Prompt count:
- State model:

## Pattern classification

| Area | Finding | Evidence | Recommendation |
| --- | --- | --- | --- |

## Tool inventory

| Tool | Purpose | Side effects | Schema quality | Description quality | Action |
| --- | --- | --- | --- | --- | --- |

## Resource inventory

| Resource family | Data source | URI shape | Sanitization | Access control | Action |
| --- | --- | --- | --- | --- | --- |

## Prompt inventory

| Prompt | Purpose | Parameters | Output contract | Action |
| --- | --- | --- | --- | --- |

## Anti-patterns

| Anti-pattern | Present? | Evidence | Fix |
| --- | --- | --- | --- |

## Cross-cutting concerns

### Authentication and authorization

### Error handling

### Versioning

### Observability

### State and long-running work

## Recommended architecture

## Migration plan

## Open questions
```

### MCP New Server Design Brief

```md
# MCP Server Design Brief

## Goal

## Users and clients

## Backend systems

## Primary architecture pattern

## Tool/resource/prompt split

## Tool inventory

| Tool | When to use | Input schema | Output | Side effects | Auth scope |
| --- | --- | --- | --- | --- | --- |

## Resource inventory

| URI | Description | Data source | Sanitization | Freshness |
| --- | --- | --- | --- | --- |

## Prompt inventory

| Prompt | Use case | Parameters | Output contract |
| --- | --- | --- | --- |

## State policy

## Transport and deployment

## Security model

## Error model

## Versioning policy

## Observability plan

## Anti-pattern prevention

## Implementation checklist
```

## Workflow

1. Understand the server goal.
   - Identify users, clients, backend systems, and operations.
   - Separate read-only context from side-effect actions.

2. Inventory primitives.
   - List tools, resources, prompts, transports, state, and upstream systems.

3. Classify the architecture.
   - Pick one primary pattern.
   - Mark secondary characteristics.
   - Explain the dominant maintenance seam.

4. Evaluate decomposition.
   - Check if reads should be resources.
   - Check if parameterized reads should be tools.
   - Check if workflows are too granular or too broad.
   - Check active tool-count budget.

5. Review tool descriptions and schemas.
   - Ensure each tool is specific, distinguishable, and LLM-usable.
   - Validate required fields and output shape.

6. Review resources.
   - Check URI design, access control, freshness, size, and sanitization.

7. Review prompts.
   - Keep only reusable templates with clear parameters and contracts.

8. Review state and long-running operations.
   - Justify state explicitly.
   - Add session cleanup or job polling where needed.

9. Review cross-cutting concerns.
   - Authentication, authorization, structured errors, versioning, observability.

10. Produce the output.
   - Use the requested format if the user specified one.
   - Otherwise use the architecture review or design brief template.

## Rules and constraints

- Do not invent tools, resources, prompts, or backend capabilities.
- Do not assume state is needed unless the workflow requires it.
- Do not expose raw backend APIs directly when a domain adapter would make the interface safer and clearer.
- Do not hide side effects.
- Do not treat tool descriptions as optional.
- Do not return untrusted resource content without sanitization guidance.
- Do not recommend static aggregation for large unrelated tool sets without scoping.
- Do not claim production readiness without auth, error handling, versioning, and observability coverage.
- Do not overfit to a single pattern when the server has clear cross-cutting attributes.

## Handling uncertainty

- If pattern classification is ambiguous, name the two closest patterns and explain the boundary.
- If tool-count is high but exact client context is unknown, flag it as a risk rather than a guaranteed failure.
- If auth or deployment details are missing, state that production readiness cannot be assessed.
- If resource content origin is unknown, assume sanitization must be reviewed.
- If a tool has unclear side effects, mark it as a blocking design question.

## Validation checklist

Before finalizing an MCP architecture analysis or design, verify:

- A primary architecture pattern is identified.
- Secondary characteristics are listed where relevant.
- Tools, resources, and prompts are separated by purpose.
- Tool count risk is assessed.
- Every tool has a clear description requirement.
- Side-effect tools are explicitly marked.
- Resource sanitization is addressed.
- State is either avoided or explicitly justified.
- Long-running operations have async/job handling if needed.
- Authentication and authorization are covered.
- Structured error handling is covered.
- Versioning and migration are covered.
- Observability includes per-call logs.
- Anti-patterns are checked.
- Recommendations are actionable and grounded in available evidence.
