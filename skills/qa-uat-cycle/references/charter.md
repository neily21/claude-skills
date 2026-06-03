# Writing the Test Charter (Implementer)

The charter is the **contract** QA tests against. It is the one artifact you (the Implementer) own in
the cycle, and it has exactly one job: state *what was delivered* and *what "working" means* clearly
enough that someone who never saw your code can verify it. Everything QA does flows from this document,
so vague acceptance criteria produce vague testing.

Crucially, **you document expected behaviour; you do not write the test cases.** QA designs its own
tests from your acceptance criteria. Your job is to make the target unambiguous, not to hand QA a
happy-path script to re-run.

## What goes in the charter

Use `assets/charter-template.md` as the starting point. The sections, and why each matters:

### 1. Scope — what was delivered
A plain list of the features/changes in this batch. This bounds the cycle: QA tests these, and treats
anything outside the list as out of scope. Be honest about partial work — if a feature is half-built,
say so under "Out of scope / known limitations" so QA doesn't raise defects for known gaps.

### 2. How to run it
The exact commands or steps to get the software running and exercise it: install, env, migrations,
seed data, start commands, URLs/ports, test accounts/roles, and the relevant test suite/lint/build
commands. QA is in a fresh context — it knows nothing your conversation knew. Missing run instructions
are the single biggest cause of "Blocked" test cases.

### 3. Features and acceptance criteria
The heart of the charter. For each feature:
- A one-line description of what it does and who it's for.
- **Acceptance criteria**: observable, testable statements of expected behaviour — what a user or
  caller should be able to do and see. Write them so pass/fail is unambiguous to someone who didn't
  build it.

Good acceptance criteria are **observable** (describe behaviour you can see, not internal code),
**specific** (exact values, states, messages where they matter), and **complete enough to fail**
(they include the boundaries and error cases, not just "it works").

Prefer Given/When/Then for anything with state or conditions; bullet expectations are fine for simple
behaviour.

**Weak (untestable):**
> Users can manage support tickets.

**Strong (testable):**
> - Given a ticket with severity "Critical", when it is created, then its SLA target is set to 4 hours
>   from creation and shown on the ticket.
> - Given a ticket owned by user A, when user B (not an admin) tries to change its status, then the
>   change is rejected with a 403 and the status is unchanged.
> - When a ticket is created with no title, then creation is rejected and the form shows "Title is
>   required".

The second version tells QA exactly what to try and exactly what counts as a defect. Notice it
includes an unhappy path (permission denied) and a validation case (missing title) — those are where
real defects hide, so name them in the criteria even if you're confident they work.

### 4. Out of scope / known limitations
Anything deliberately not done, known rough edges, or behaviour intentionally deferred. This stops QA
from spending the cycle raising defects you already know about, and tells it where *not* to look.

## Quality bar before you hand off

Before you hand the charter to QA, sanity-check it as if you were the tester:
- Could someone with no knowledge of the code design tests from this and know what "pass" means?
- Does every feature have at least one acceptance criterion covering an error/boundary case, not just
  the happy path?
- Are the run instructions complete enough to actually exercise the feature from a cold start?

If yes, hand it off. If no, the gaps will come back as Blocked cases or weak testing — fix them now.

## What you do NOT do

You do not decide the verdict, you do not write the test cases, and you do not test the work yourself
to "save QA time". Documenting what you built is fine and expected (that's this charter). Judging
whether it works is QA's job — that separation is the entire point of the cycle.
