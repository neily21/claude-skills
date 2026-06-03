---
name: qa-uat-cycle
description: >-
  Independent QA/UAT testing cycle for verifying that delivered features actually work — run by a
  tester with a fresh context, never the agent that wrote the code. Use this skill whenever a batch
  of features or a whole solution has just been implemented and needs to be verified before you claim
  it works; when the user asks to "QA this", "test it properly", "do a UAT pass", "verify these
  features", "acceptance test", "sign off", or worries about an agent "marking its own homework" or
  "testing its own code". Also use it to document delivered features and their expected behaviour as a
  test charter, to design and run test cases, to log and format defects, to retest fixes, and to mark
  up completed tests and resolved defects. Trigger this even when the user doesn't say "QA" explicitly:
  any time work is "done" and someone is about to sign off on it, an independent QA pass belongs here.
---

# QA / UAT Cycle

## Why this exists

The agent that builds a feature is the worst possible judge of whether it works. It carries the
context that produced the code, so it tends to test the happy path it already had in mind, trust its
own assumptions, and read green tests it wrote itself as proof. That is *marking your own homework*.
Real software teams solve this with **separation of duties**: the person who builds the thing and the
person who signs off that it works are different people, working from a shared, written contract of
expected behaviour.

This skill recreates that discipline. It defines three roles, a documented contract, and a repeatable
cycle so that "done" means *an independent tester confirmed the expected behaviour*, not *the author
believes it works*.

## The three roles

| Role | Owns | Never does |
|------|------|------------|
| **Implementer** | The **what**: the feature list + expected behaviour, written as a *test charter*. Fixing defects on retest. | Decide whether their own work passes. |
| **QA Tester** | The **how** and the **verdict**: designs its own test cases, exercises the running system, raises defects, signs off. Runs in a **fresh context**. | Fix the code. (Diagnose, yes; patch, no.) |
| **Orchestrator** | Routing between roles, dispatching the fresh QA context, relaying results, deciding when to loop. | Blur the roles by quietly doing QA's job in the builder's context. |

The split between Implementer and QA is deliberate and load-bearing. **The Implementer documents
expected behaviour; QA designs the tests.** If the builder also wrote the test cases, QA would just
re-run the builder's happy path and the bias problem returns. QA must form its own expectations from
the charter's acceptance criteria and then try to break the system.

## The cycle

```
  Implementer ──writes──▶ CHARTER ──handed to──▶ QA (fresh context)
                                                     │
                                          designs + runs TEST CASES
                                                     │
                                   ┌──── all pass ───┴──── any fail ────┐
                                   ▼                                     ▼
                              SIGN-OFF                            raise DEFECTS
                                                                         │
                                                         (test run finishes first)
                                                                         │
                                              hand defect report back to Implementer
                                                                         │
                                              Implementer fixes, updates defect status,
                                                       requests RETEST
                                                                         │
                                              fresh QA retests fixed cases + regression
                                                                         │
                                                  close / reopen ──▶ back to top until exit criteria met
```

Two rules keep the cycle honest:
- **Finish the run before handing back.** QA tests *all* in-scope cases and logs *all* defects before
  returning. Stopping at the first failure produces a trickle of one-defect round-trips and hides
  defects that interact. (See `references/qa-execution.md`.)
- **Each QA pass is a fresh context.** Retests are run by a tester that did not just fix the code,
  for the same reason the first pass was independent.

## Determine your role first

When this skill triggers, work out which role you are being asked to play, then read the matching
reference file:

- **"I just built X; document it for QA"** → you are the **Implementer** writing the charter.
  Read `references/charter.md`.
- **"QA / test / verify these features"** with a charter present (or after authoring one) → dispatch
  the **QA Tester**. Read `references/qa-execution.md` and the dispatch instructions below.
- **"Here are the defects from QA — fix them"** → you are the **Implementer** on retest. Read
  `references/defects.md` (lifecycle + status markup).
- **"Run the whole QA cycle on what I just built"** → you are the **Orchestrator**. Author the charter
  (or confirm one exists), then dispatch a fresh QA Tester, then follow the chosen mode below.

If it is ambiguous, ask one short question rather than guessing — getting the role wrong wastes a full
cycle.

## Dispatching the independent QA Tester

This is the step that makes QA's verdict trustworthy, so do not skip it. The QA Tester must run in a
context that has **not** seen the implementation conversation. Two supported ways, in order of
preference:

1. **Fresh subagent (default).** Spawn a subagent (the Agent/Task tool, general-purpose type) and hand
   it the briefing in `assets/qa-briefing-template.md` with the blanks filled in: the charter path,
   the repo path, how to run the software, the cycle number, and the mode. Give it the charter and
   repo access — **not** a summary of how you built things. Its fresh context *is* the independence.
2. **Separate session (high-stakes work).** For releases or anything where you want maximum
   independence, tell the user to open a new Claude session, point this skill at the charter, and run
   QA there as its own process. Use this when a subagent feels too entangled with the build context.

Whichever path, the QA Tester returns a **test report** and a **defect log** (formats in the
references). The Orchestrator relays these — it does not edit verdicts.

## Modes (configurable loop)

- **Report-and-stop (default).** QA completes the run, writes the test report + defect log, and stops
  at a human gate. The user decides when to dispatch fixes and when to retest. Human gates between
  phases are the cleanest guarantee that roles stay separated — use this unless asked otherwise.
- **Loop-until-clean (opt-in).** When the user explicitly asks to "keep going until it passes" or
  "loop until clean", run: fresh QA → defect report → fresh Implementer fixes → fresh QA retest →
  repeat until exit criteria are met or no progress is made across a cycle. Announce each cycle and
  stop with a summary if two consecutive cycles fail to close any defects (you are likely stuck and a
  human should look).

## Artifacts and layout

QA artifacts live together so the cycle's state is always visible. Default location is a `qa/`
directory at the repo root, one folder per feature set or release:

```
qa/
  <feature-set-slug>/          e.g. qa/support-ticket-sla/
    charter.md                 contract: scope, features, acceptance criteria, how to run   (Implementer)
    test-report.md             QA's test cases + results + verdict, updated each cycle       (QA)
    defects.md                 living defect log across cycles                               (QA raises; Implementer responds)
```

Templates for each are in `assets/`. Keep the charter stable (it is the contract); update statuses in
`test-report.md` and `defects.md` as the cycle progresses. For an audit trail on formal releases you
may snapshot `test-report.md` per cycle (`test-report-cycle-01.md`), but the living-document form is
the lean default.

## Reference files

Read the one that matches what you are doing — don't load all of them up front:

- `references/charter.md` — Implementer: how to write the charter (features + acceptance criteria that
  are observable and testable), with a worked example.
- `references/qa-execution.md` — QA: how to design test cases from acceptance criteria, how to exercise
  the running system (tests, build/lint gates, UI, API, DB), what evidence to capture, and how to
  avoid the two failure modes — rubber-stamping (passing things you didn't really verify) and crying
  wolf (raising "defects" for unspecified or working behaviour).
- `references/defects.md` — defect format, severity/priority definitions, the defect lifecycle, retest
  procedure (including regression checks), markup conventions, and sign-off / exit criteria.

## The non-negotiable

Whatever the mode or mechanism: **the context that wrote the code does not get to declare it passing.**
Everything else in this skill is in service of that one principle. If you find yourself about to mark
your own work as verified, stop and dispatch a fresh tester instead.
