# Test Charter — <feature set / release name>

- **Author (Implementer):** <name/agent>
- **Date:** <YYYY-MM-DD>
- **Branch / build:** <branch or commit>
- **Status:** Ready for QA

## Scope — what was delivered
<!-- Plain list of the features/changes in this batch. This bounds what QA tests. -->
- Feature A — one line
- Feature B — one line

## How to run it
<!-- Everything a fresh tester needs to start the software cold and exercise it. -->
- Install / setup: `...`
- Environment / config: `...`
- Migrations / seed data: `...`
- Start the app: `...`  →  URL/port: `...`
- Test accounts / roles: `...`
- Test suite / gates: `npm run test`, `npm run typecheck`, `npm run lint`, `npm run build` (adjust to project)

## Features and acceptance criteria
<!-- For each feature: a one-line description, then observable, testable acceptance criteria.
     Include at least one boundary/error case per feature, not just the happy path.
     You document expected behaviour; QA will design the test cases. -->

### Feature A — <description>
- Given <state/precondition>, when <action>, then <observable expected result>.
- When <action with invalid/edge input>, then <expected rejection/handling + exact message if any>.
- <bullet expectation for simple behaviour>

### Feature B — <description>
- Given ..., when ..., then ...
- ...

## Out of scope / known limitations
<!-- Anything deliberately not done or known-rough, so QA doesn't raise defects for it. -->
- ...
