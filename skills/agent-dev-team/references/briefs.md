# Brief templates

Every brief has four parts — objective, output format, tool/source guidance, boundaries. Vague
briefs are the root cause of duplicated work, gaps between slices, and agents wandering off-task.
The templates below are starting points; fill every bracket, and cut anything that doesn't apply
rather than leaving boilerplate the agent has to ignore.

A good brief is **complete on first send** (the agent can't ask follow-ups cheaply) and **scoped by
exclusion as well as inclusion** — saying what is *not* the agent's job is what prevents two agents
from converging on the same code.

---

## plan.md skeleton

Create at `.agent-team/<feature-slug>/plan.md` in Step 2, extend in Step 4.

```markdown
# <Feature name>

## Vision
<2–3 sentences, in the user's own terms, of what this feature is for.>

## Acceptance criteria
1. <Observable, testable statement. "A user can X and sees Y.">
2. ...

## Architecture decisions
- <Decision>: <choice> — <one-line rationale>

## Contracts
<Interfaces between slices, pinned BEFORE implementation. API shapes, signatures, schemas, events.>

## Slices
### Slice: <name>
- Goal: <one sentence>
- Owned files: <exact paths — no other slice touches these>
- Risk: routine | high-stakes (<reason>)  → model: sonnet | opus
- Depends on: <contract names or other slices, if any>
- Acceptance criteria covered: <numbers from the list above>

## Status log
- <date> <event: slice dispatched / QA cycle 1 verdict / ...>
```

---

## Scout brief

```
Objective: <The specific question(s) to answer. E.g. "Map how authentication currently works in
this repo: entry points, middleware, session storage, and where user roles are checked.">

Output: Write detailed findings to .agent-team/<slug>/recon-<topic>.md — include file:line
references for every claim. Return to me only a summary of at most 10 lines plus the file path.

Guidance: Start wide (directory structure, README, key entry points / broad searches) before
narrowing. <For web research: prefer official docs; note the version/date of everything; include
URLs.> <Diagnostic commands you may run: e.g. `npm test`, `git log --oneline -20`.>

Boundaries: Read-only — do not modify any project file. Do not investigate <adjacent topic another
scout owns>. Stop after answering the objective; do not propose designs or write code.
```

---

## Planner brief

Use when the feature is large enough that expanding your architecture into a step-by-step
implementation plan is itself substantial work. The planner elaborates; it does not overrule.

```
Objective: Expand the architecture below into a concrete implementation plan for <feature>.
Architecture decisions (fixed — do not revisit): <paste from plan.md>.
Recon available: .agent-team/<slug>/recon-*.md — read these first.

Output: Write the plan into the "Slices" section of .agent-team/<slug>/plan.md, following the
skeleton already in the file: per slice — goal, exact owned files, risk rating, dependencies,
acceptance criteria covered. Propose contracts for every boundary between slices. Return a 5-line
summary of the slicing and any risk you want flagged.

Guidance: Slice vertically (a slice = everything one capability needs), never by activity. No file
may appear in two slices. Verify file paths exist (or mark as new) before assigning ownership.

Boundaries: Write access is for plan.md only. Do not modify source code. Architecture decisions are
fixed; if you believe one is wrong, flag it in your summary rather than planning around it.
```

---

## Developer brief

```
Objective: Implement the slice "<name>" of <feature>.
Goal: <one sentence>.
Acceptance criteria for this slice: <paste the relevant numbered criteria from plan.md>.
Context to read first: .agent-team/<slug>/plan.md (vision, architecture, contracts) and
.agent-team/<slug>/recon-<relevant>.md.

Output, in this order:
1. Working code in your owned files, with tests for the new behaviour.
2. .agent-team/<slug>/report-<slice>.md — what you built, decisions you made, how to exercise it
   manually, anything QA or the lead should know.
3. Your section of qa/<slug>/charter.md — the features you delivered and their expected behaviour
   as observable acceptance criteria, per the qa-uat-cycle charter format. You are the Implementer:
   document expected behaviour; do NOT design test cases or declare your work verified.
Return a summary of at most 10 lines.

Guidance: Honor the contracts in plan.md exactly — other slices are being built against them in
parallel; if a contract is unworkable, stop and report rather than deviating. Run <build/lint/test
commands> before reporting; all must pass. Follow the conventions in CLAUDE.md and the surrounding
code.

Boundaries: You own exactly these files: <list>. Create new files only under <paths>. Do not touch
any other file — especially not files owned by other slices: <list if useful>. Never edit an
existing test to make it pass; if a test seems wrong, report it. Do not refactor beyond your slice,
even if you see things you'd like to fix — note them in your report instead.
```

**Plan gate (high-stakes slices only):** insert before "Output":
```
First return your implementation plan (approach, file-by-file changes, test plan, risks) and STOP.
Do not write code until I approve the plan.
```

**Defect-fix variant:** replace Objective with the defect log entries to fix and the charter path.
Brief a *fresh* developer; include what the original implementation was trying to do (its report
file), the defect log from QA, and the same ownership boundaries. Say "fix the defect" — never
"make the tests pass".

---

## QA dispatch

Defer to the **qa-uat-cycle** skill — it owns this phase. Its briefing template is at
`assets/qa-briefing-template.md` *inside that skill*; fill in the charter path
(`qa/<slug>/charter.md`), repo path, how to run the software, cycle number, and mode. Dispatch via
the `team-qa` agent definition (it preloads the skill). The two rules that this team structure
exists to protect:

- The QA agent gets the charter and the repo — never your account of how the code was built and
  never the developer's session context.
- Each cycle (including retests) is a **fresh** QA context.

---

## Reviewer brief (Step 7, optional)

Only needed when you've lost the objectivity or context room to review the diff yourself.

```
Objective: Adversarial review of the attached diff for <feature> against these acceptance
criteria: <paste from plan.md>.

Output: A list of gaps — missing or wrong behaviour, unhandled errors, contract violations between
components, security issues, suspicious test changes. For each: severity, location (file:line),
one-line explanation. Return "no gaps found" only if you checked every criterion.

Guidance: Read .agent-team/<slug>/plan.md for the contracts. Pay particular attention to diffs in
test files — a weakened assertion is a defect, not a style choice.

Boundaries: Report gaps, not style preferences. Read-only. Do not fix anything.
```
