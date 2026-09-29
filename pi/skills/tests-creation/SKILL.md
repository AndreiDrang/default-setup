---
name: python-unit-tests
description: Creates and updates realistic Python unit tests that mirror project structure and verify observable business behavior.
---

# Python Unit Tests

## When to use this skill

Use this skill when asked to:

- add new Python unit tests;
- extend existing test coverage;
- repair failing or low-value tests;
- add regression tests for a bug;
- review whether tests verify real business behavior;
- reorganize tests so they mirror the source project structure.

This skill is project-agnostic. It must adapt to the repository's existing Python layout, test framework, fixtures, async model, and local conventions.

## Primary objective

Create tests that verify observable business behavior rather than merely execute code or confirm mocked calls.

A useful test must:

- have an independent and evidence-based expected result;
- exercise real business logic;
- fail when a realistic defect is introduced;
- mock only true external or non-deterministic boundaries;
- make the reason for failure clear.

Do not create tests only to increase coverage numbers.

## Inputs to collect

Required:

- target source file, module, class, function, or behavior;
- repository root or enough context to detect it;
- expected behavior or a source from which the behavior can be derived.

Useful repository evidence:

- `AGENTS.md` and nested agent instructions;
- `CONTRIBUTING.md`;
- `README.md`;
- `ARCHITECTURE.md`;
- `pyproject.toml`;
- `pytest.ini`;
- `setup.cfg`;
- `tox.ini`;
- `noxfile.py`;
- existing `conftest.py` files;
- existing nearby tests;
- API or domain specifications;
- bug reports, issues, or regression descriptions.

If the behavior to test cannot be determined from code, specifications, callers, or existing tests, ask one focused clarification before inventing an expected result.

## Repository and root discovery

Before writing tests, determine the repository root.

Use this priority order:

1. `git rev-parse --show-toplevel`;
2. active workspace root;
3. current working directory, treated conservatively as an inferred root.

Never create or modify tests outside the detected repository root.

## Source root discovery

Determine the Python source root from repository evidence.

Common layouts include:

```text
src/<package>/
<package>/
app/
backend/
services/<service>/
packages/<package>/
```

Use this priority order:

1. explicit user-provided source path;
2. package configuration in `pyproject.toml`, `setup.cfg`, or `setup.py`;
3. existing importable Python packages;
4. existing test-to-source mappings;
5. conservative inference from the target file.

Do not assume that every repository uses a `src/` layout.

For monorepositories, select the smallest project or package root that owns the target source file and its test configuration.

## Test root discovery

Determine the test root before creating files.

Look for existing test roots such as:

```text
tests/
test/
src/<package>/tests/
<package>/tests/
packages/<package>/tests/
```

Use this priority order:

1. test paths configured in `pyproject.toml`, `pytest.ini`, `setup.cfg`, `tox.ini`, or `noxfile.py`;
2. existing test directories associated with the selected source root;
3. repository conventions visible in nearby packages;
4. a user-provided test directory.

If no test root exists:

- ask the user where tests should live when repository intent is ambiguous;
- otherwise create a conventional `tests/` directory at the selected project root when the project is simple and the choice is unambiguous;
- do not create multiple competing test roots.

Record the selected source root and test root internally before creating any test file.

## Mandatory mirrored test structure

Tests must mirror the source structure beneath the selected source root.

Mapping rule:

```text
<source_root>/<relative/module/path>.py
→
<test_root>/<relative/module>/test_<module>.py
```

Examples:

```text
src/acme/services/billing.py
→ tests/services/test_billing.py

acme/api/users/views.py
→ tests/api/users/test_views.py

packages/orders/src/orders/domain/pricing.py
→ packages/orders/tests/domain/test_pricing.py
```

Rules:

- remove the import package prefix only when existing repository tests already do so;
- otherwise preserve the package path inside the test root;
- follow the nearest established mapping when existing tests differ from the examples;
- prefer extending the closest existing test module over creating a duplicate file;
- create a separate test file when the source module has a distinct responsibility or the existing file would become incoherent;
- do not flatten unrelated modules into one test file.

Before creating a new path, inspect nearby test paths to confirm the local convention.

## Repository convention discovery

Before writing tests, inspect the repository and determine:

- test runner: `pytest`, `unittest`, or another established runner;
- async behavior: native asyncio, pytest-asyncio, anyio, framework-specific helpers, or synchronous execution;
- fixture and factory conventions;
- mocking library and style;
- naming conventions for test files, classes, and functions;
- parametrization style;
- test database or in-memory adapters;
- focused and full validation commands;
- framework-specific test clients or request builders;
- local rules from `AGENTS.md` or equivalent files.

Prefer existing repository helpers over introducing new abstractions.

Do not add shared fixtures unless they are needed by at least two test modules or clearly belong in an existing shared fixture layer.

## Business contract discovery

Before writing tests, identify the observable business contract.

For each behavior, determine internally:

- initial state;
- inputs;
- business condition being exercised;
- expected output;
- expected state transition;
- required side effects;
- forbidden side effects;
- expected failure behavior;
- evidence supporting the expectation.

Use this evidence priority:

1. explicit business requirements or specifications;
2. public API or domain contract;
3. documented invariants and architecture rules;
4. accepted regression behavior or existing authoritative tests;
5. callers and consumers;
6. implementation details only when no stronger source exists.

Do not derive every expected value directly from the implementation under test.

A test that reimplements the same algorithm as production code is not an independent test oracle.

Do not infer a complete contract from a function name, type annotation, or docstring alone when callers or specifications provide stronger evidence.

## Test layer selection

Use the smallest layer that can verify the intended behavior without hiding the business rule.

Possible layers:

- pure function or value-object test;
- domain service test;
- application service test;
- adapter or controller unit test;
- API/handler test;
- integration test;
- end-to-end test.

For a unit-test task:

- test pure business logic directly;
- test orchestration with real internal collaborators where practical;
- mock external boundaries;
- avoid full application startup unless routing, middleware, dependency injection, or lifecycle behavior is the actual contract.

Do not call an API-layer wiring test a business-logic test when the underlying service is fully mocked.

## Decision-table scenario design

Before writing tests for a non-trivial business rule, build an internal decision table.

The table must identify:

- relevant initial states;
- independent business conditions;
- equivalence classes of inputs;
- boundary values;
- expected output;
- expected state transition;
- required side effects;
- forbidden side effects;
- expected failure behavior;
- evidence supporting each expectation.

A useful internal table shape is:

```text
Initial state | Conditions | Input class | Expected result | State change | Required effects | Forbidden effects
```

Do not create one test for every theoretical combination.

Select the smallest set of scenarios that covers:

1. every distinct business outcome;
2. every permitted and rejected state transition;
3. every material validation branch;
4. every important equivalence class;
5. every material boundary;
6. every required side effect;
7. every forbidden side effect.

For every non-trivial rule, include at minimum:

1. one valid scenario;
2. one rejected, invalid, or boundary scenario;
3. one state-transition or side-effect assertion when the behavior is stateful.

Add scenarios when the contract includes:

- empty or missing input;
- duplicate operation;
- missing entity;
- invalid state transition;
- retry or idempotency behavior;
- partial dependency failure;
- permission, tenancy, or ownership rules;
- rounding, currency, date, timezone, or precision behavior;
- ordering or prioritization rules;
- concurrency or replay behavior that belongs to the unit contract.

### Boundary triplets

For every inclusive or exclusive numeric, monetary, date, time, count, size, percentage, or length boundary, test the boundary triplet when meaningful:

- immediately below the boundary;
- exactly at the boundary;
- immediately above the boundary.

Choose the delta from the domain rather than using an arbitrary value:

- integer or collection count: one unit;
- money: the smallest supported currency unit;
- datetime: the smallest meaningful application precision;
- percentage or decimal: the supported precision;
- string or collection length: one element or character.

Do not use floating-point adjacency as a business boundary unless floating-point semantics are themselves part of the contract.

If only one or two points of the triplet are valid for the domain, document the reason internally and test the meaningful points.

### Parametrization

Use parametrization when several cases verify the same contract with different inputs and the same assertion shape.

Each parameter set should have a descriptive identifier that communicates the business scenario.

Do not hide distinct business outcomes, different side effects, or different failure semantics inside one oversized parameter table. Use separate tests when separation makes the contract clearer.

## Invariants and property-based tests

Use invariant-based tests when behavior should hold across a broad input domain and a few hand-picked examples would provide weak assurance.

Useful invariants include:

- normalization is idempotent;
- encoding followed by decoding preserves every supported value;
- a rejected operation never changes persisted state;
- applying the same idempotency key repeatedly produces one effect;
- a monetary discount never produces a negative payable amount;
- sorting preserves the input multiset and returns ordered output;
- a state machine preserves its domain invariants after every permitted transition;
- serialization preserves required domain fields;
- increasing an eligible input does not decrease a monotonic result;
- conserved totals remain equal before and after a transformation.

Use property-based testing when:

- the invariant applies to many possible inputs;
- input generation can be constrained to valid domain states;
- edge cases are difficult to enumerate manually;
- round-trip, idempotency, monotonicity, ordering, conservation, bounds, or state-machine behavior is central;
- generated examples improve assurance beyond a concise explicit example table.

Do not use generated data without a meaningful invariant.

Weak property tests remain weak, for example:

```python
assert result is not None
assert isinstance(result, ExpectedType)
```

when the contract supports stronger properties.

Property-based tests supplement explicit examples; they do not replace:

- named regression scenarios;
- exact business boundaries;
- examples required by specifications;
- precise error and side-effect assertions.

### Hypothesis dependency policy

For Python projects, prefer Hypothesis when property-based testing is justified and the repository already uses it.

If Hypothesis is not installed:

- do not add it automatically for an ordinary unit-test task;
- first determine whether the requested invariant materially benefits from generated cases;
- add it only when the user requested property-based tests, approved the dependency, or the repository's established test policy requires it;
- add it to the repository's test or development dependency group, never to runtime dependencies;
- use the repository's existing package manager and versioning policy;
- update the relevant lockfile when the repository normally commits lockfiles;
- do not introduce Hypothesis for a property that is clearer and fully covered by a small explicit decision table.

When Hypothesis is unavailable and adding dependencies is outside the task scope, write deterministic example-based invariant tests and state that broader generated coverage was not added.

When Hypothesis is used:

- generate valid domain values by construction where practical;
- avoid excessive `assume()` filtering;
- keep strategies close to the domain contract;
- preserve minimized failing examples reported by Hypothesis as explicit regression examples when they reveal an important named defect;
- avoid global settings changes unless the repository already defines Hypothesis profiles;
- keep tests deterministic and reproducible through the repository's established CI configuration.

## Test oracle quality

Assertions must be based on observable outcomes and independent expectations.

Prefer asserting:

- returned domain value;
- resulting state;
- changed entity fields;
- persisted record content through a fake or controlled repository;
- emitted domain event;
- exact validation error;
- rejected transition;
- absence of a forbidden side effect;
- exact boundary interaction caused by a business decision.

Avoid weak assertions such as:

```python
assert result is not None
assert response
assert len(items) > 0
```

when the contract supports a precise value or structure.

Do not calculate the expected result by calling another production function that uses the same logic being tested.

For calculations, derive expected values from explicit examples, domain rules, fixed fixtures, or independently computed constants.

## Mock boundary discipline

Mock only true external or non-deterministic boundaries, such as:

- network clients;
- databases when the database is not the subject of the test;
- message queues;
- email or notification providers;
- filesystem access;
- clocks and timers;
- random or UUID generators;
- external SDKs;
- operating-system processes.

Do not mock the business rule being tested.

Avoid mocking:

- domain calculations;
- validators;
- state-transition logic;
- value objects;
- internal helper functions solely to force a result;
- every collaborator in the same business layer.

Prefer lightweight fakes or in-memory implementations when they preserve actual domain behavior.

Patch dependencies at the import path used by the unit under test.

`assert_called_once_with` and similar interaction assertions may support a test, but must not be the sole assertion in a business-logic test.

A test that only verifies that one mock called another mock is a wiring test. Scope and name it accordingly.

## Fakes, fixtures, and test data

Use realistic but minimal test data.

Test data should:

- satisfy real domain constraints;
- use meaningful values that expose the rule;
- avoid random values unless randomness is the behavior under test;
- avoid giant fixtures copied from production payloads;
- preserve relationships required by the domain;
- make the scenario readable from the test body.

Prefer:

- small explicit factories;
- builders with sensible defaults;
- in-memory repositories;
- fixed clocks;
- deterministic IDs;
- realistic domain objects.

Avoid fixtures that produce impossible states merely because the constructor allows them.

Do not use snapshots as the only assertion for core business logic. Use snapshots only when the complete serialized output is itself the contract and reviewability remains high.

## Regression tests

A regression test must:

1. reproduce the original failure condition;
2. assert the corrected observable behavior;
3. fail against the known broken behavior;
4. include the smallest relevant setup;
5. avoid merely checking that no exception was raised.

Name the scenario after the behavior, not an issue number alone.

Good:

```python
def test_rejects_duplicate_payment_after_settlement():
    ...
```

Weak:

```python
def test_issue_431():
    ...
```

Issue references may be included in comments or docstrings when useful, but should not replace a descriptive test name.

## Red–Green–Mutate proof

Important business tests must prove that they are sensitive to the defect they claim to detect.

Use this priority order:

### 1. Red–Green proof

Use Red–Green proof for regressions when the original broken behavior is available.

1. Add the test against the broken implementation or known failing revision.
2. Run the focused test and confirm that it fails.
3. Confirm that it fails for the expected business reason, not because of setup, import, fixture, or environment errors.
4. Apply or retain the production fix.
5. Run the same focused test and confirm that it passes.

A regression test is incomplete when the original broken version is available but the test was run only after the fix.

Merely demonstrating Green does not prove that the test detects the regression.

### 2. Targeted mutation proof

When the original defect is no longer reproducible, temporarily apply one realistic mutation to the relevant production branch when it is safe and practical.

Suitable mutations include:

- `>` changed to `>=`, or the reverse;
- validation condition removed or inverted;
- required state assignment skipped;
- calculated value replaced by a plausible constant;
- persisted field omitted;
- dependency called with incorrect business data;
- side effect emitted zero times or twice;
- authorization, ownership, or tenancy check bypassed;
- exception incorrectly mapped to success;
- stale value returned instead of the current result.

Then:

1. run the smallest focused test expected to detect the mutation;
2. confirm that the test fails for the intended assertion;
3. revert the temporary mutation completely;
4. rerun the focused test and confirm that it passes;
5. verify the working tree contains no temporary mutation.

Never commit temporary mutations.

Never mutate unrelated code merely to make a test fail.

Do not weaken production behavior or expose private implementation details solely to support mutation proof.

### 3. Reasoned mutation

Use reasoned mutation only when historical reproduction and temporary mutation are unavailable, unsafe, or outside the task scope.

For each important test, record internally:

- the exact realistic defect the test should catch;
- the assertion expected to fail;
- why mocks or fixtures cannot make the test pass despite the defect;
- that mutation sensitivity was reasoned rather than executed.

Do not claim Red–Green or mutation proof was executed when it was only reasoned about.

### Surviving-test rule

Strengthen or reject a test if it would still pass after:

- replacing the relevant branch with a constant result;
- removing the key validation;
- skipping the required state update;
- eliminating the business calculation;
- persisting incomplete or incorrect state;
- emitting the wrong number of side effects;
- calling a dependency with materially incorrect data.

A test that survives its target defect is not sufficient evidence for that behavior, even if it increases line or branch coverage.

### Mutation tooling policy

When mutation-testing tooling already exists in the repository, use the established focused command when requested or when it is part of normal project validation.

Do not install or configure mutation-testing tooling automatically.

Prefer a single targeted manual mutation over a broad mutation run when the task concerns one specific rule and no mutation framework is established.

Report Red–Green–Mutate evidence accurately in the final summary:

- Red observed and Green observed;
- targeted mutation killed and reverted;
- reasoned mutation only;
- proof not possible, with the exact blocker.

## Async and framework adaptation

Follow the repository's established async and framework patterns.

Examples:

- do not add `@pytest.mark.asyncio` when the suite uses automatic asyncio mode;
- use framework test clients only when request lifecycle behavior matters;
- call handlers or services directly when that is the established unit-test pattern;
- do not start live servers for ordinary unit tests;
- preserve event-loop, transaction, and fixture scopes used by the project;
- avoid async mocks for synchronous callables and synchronous mocks for awaited callables.

Do not assume aiohttp, FastAPI, Django, Flask, SQLAlchemy, or any other specific framework unless repository evidence confirms it.

## Test naming and structure

Use names that state the observable behavior.

Preferred forms:

```text
test_returns_<result>_when_<condition>
test_rejects_<action>_when_<condition>
test_persists_<state>_after_<action>
test_does_not_<side_effect>_when_<condition>
test_emits_<event>_when_<condition>
```

Keep one primary behavior per test.

Use Arrange / Act / Assert separation when it improves readability, but do not add redundant comments that merely narrate obvious code.

Test classes are optional. Use them only when the repository convention or shared scenario grouping makes them useful.

## Editing existing tests

When modifying an existing test file:

- read the complete file first;
- inspect relevant fixtures and helpers;
- preserve established naming and grouping conventions;
- remove obsolete assertions when behavior changed intentionally;
- strengthen weak assertions when the contract is known;
- update stale mocks after dependency boundaries change;
- avoid duplicating setup already provided by a clear local fixture;
- do not preserve a misleading test solely to avoid changing test code.

When a test passes for the wrong reason, rewrite it rather than adding another superficial assertion.

## Validation workflow

Run the smallest relevant test command first.

Examples:

```bash
pytest path/to/test_module.py -q
pytest path/to/test_module.py::test_specific_behavior -q
python -m unittest path.to.test_module
```

Then run the repository's established broader validation command, such as:

```text
pytest
make test
tox
nox
uv run pytest
poetry run pytest
```

Discover the correct command from project configuration, CI workflows, Makefiles, task runners, or local docs.

Do not claim tests pass unless they were actually executed successfully.

If execution is blocked by missing services, environment variables, dependencies, or permissions:

- report the exact blocker;
- still validate syntax and test collection when possible;
- do not silently weaken the test to make it pass.

## Output requirements

When creating or updating tests:

- write only inside the selected test root;
- mirror the source structure;
- preserve repository naming and framework conventions;
- keep assertions concrete;
- avoid unrelated production-code changes unless required to make the code testable and the user requested implementation changes;
- do not create generated artifacts, coverage files, caches, or logs;
- summarize what behavior is covered and what validation was run.

If the test root had to be created, state where it was created and how the source-to-test mapping was chosen.

## Handling uncertainty

- If repository root detection is ambiguous, use the smallest safe project root and state the assumption.
- If multiple test roots exist, select the one associated with the target package; ask when ownership is unclear.
- If no test root exists and a conventional location is not obvious, ask where tests should live.
- If expected business behavior is unclear, inspect specifications, callers, domain models, and existing tests before asking.
- If ambiguity remains, ask one focused question instead of inventing a test oracle.
- If a live external service would be required, mock or fake the boundary for a unit test unless integration coverage was explicitly requested.
- If code is difficult to test because boundaries are missing, describe the minimum refactor needed; do not build tests around private implementation accidents.

## Validation checklist

Before finalizing, verify:

### Repository and paths

- repository root was detected;
- source root was detected;
- test root was detected or created deliberately;
- no file outside the test root was added or modified for a tests-only task;
- each test path mirrors the source path according to repository convention;
- no duplicate or competing test file was created.

### Business behavior

- each test has a clear business or contract-level purpose;
- expected results are supported by independent evidence;
- tests do not merely reproduce the implementation algorithm;
- a decision table was built internally for each non-trivial rule;
- selected cases cover every distinct outcome, material condition, and state transition;
- meaningful boundaries include below, exact, and above cases where applicable;
- state transitions and required and forbidden side effects are asserted;
- regression tests reproduce the original failure condition when the broken behavior is available.

### Invariants and generated cases

- broad input domains are tested through meaningful invariants when appropriate;
- generated data is constrained to valid or deliberately invalid domain states;
- property-based tests contain strong contract assertions rather than type or non-null checks;
- explicit regression examples and exact boundaries remain covered separately;
- Hypothesis was added only when justified and approved or already established;
- any new Hypothesis dependency is test-only and follows repository package-management conventions.

### Mocks and realism

- only true external or non-deterministic boundaries are mocked;
- the business rule under test remains real;
- interaction assertions are not the only proof of correctness;
- fixtures represent valid and realistic domain states;
- no test passes solely because mocks return the expected answer.

### Red–Green–Mutate evidence

- each important test targets at least one specific realistic defect;
- regression tests demonstrated Red then Green when the broken behavior was available;
- targeted mutations were fully reverted and the clean test rerun when mutation proof was used;
- reasoned-only mutation evidence is labeled accurately;
- key validation removal would break the relevant test;
- missing state updates, wrong calculations, or incorrect side-effect counts would be detected;
- constant-return implementations would not satisfy the relevant tests;
- no test survived the specific defect it claims to prevent.

### Execution

- the focused test command was run where possible;
- the broader project test command was discovered and run where practical;
- failures or environmental blockers are reported accurately;
- no passing status is claimed without execution evidence.
