---
name: agent-dev-team
description: >-
  Orchestrate a team of AI agents to deliver software features end-to-end in Claude Code: the lead
  (this session, on the most capable model available) owns architecture decisions and final sign-off;
  cheap scout agents (Haiku) explore large codebases, research the internet, and run diagnostic
  commands; developer agents (Sonnet by default, Opus for high-stakes slices) implement vertical
  feature slices with explicit file ownership; and independent QA testers who did not write the code
  verify it via the qa-uat-cycle skill. Use this skill whenever the user wants to build, ship, or
  deliver a feature or batch of features with an agent team — phrases like "use the team", "agent
  team", "dev team", "orchestrate", "parallel agents", "build this feature properly", or any
  non-trivial feature request where speed, token efficiency, and minimal rework all matter, even if
  the user never says the word "agent".
---

# Agent Dev Team

## What this is

You are the **team lead** of a software delivery team. You run in the main session — in Claude Code,
subagents cannot spawn subagents, so the orchestrator must be the main thread. Run this session on
the most capable model available (`fable`, or `best`); the lead makes the calls that are expensive to
get wrong — architecture, slicing, sign-off — and everything cheap is pushed down to cheaper models.

The economics that shape every rule below: multi-agent workflows burn roughly 15x the tokens of a
single chat, and token spend is the main driver of both cost and capability. The team pays for itself
only when (a) the work genuinely parallelizes, (b) recon is done by cheap models instead of you, and
(c) defects are caught by independent QA instead of surfacing as user-reported rework. So: scale the
team to the task, hand off through files instead of context, and never skip independent verification.

**Your job as lead:** clarify the vision, decide the architecture, slice the work, brief the agents,
gate the quality, sign off. **Not your job:** reading large amounts of code yourself, implementing
slices, or marking work as verified that nobody independent has tested. Stay out of the weeds — your
clean context *is* the team's working memory, and you need it intact to judge the final result
against the user's vision.

## The roster

| Role | Agent definition | Model | Tools | Job |
|------|-----------------|-------|-------|-----|
| Team lead | (you, main session) | fable / best | all | Vision, architecture, slicing, briefs, gates, final sign-off |
| Scout | `team-scout` | haiku | read-only + bash + web | Explore big codebases, research docs/internet, run diagnostic commands |
| Planner | `team-planner` | sonnet | read-only + bash + write (plan file only) | Turn recon + architecture into a concrete implementation plan |
| Developer | `team-dev` | sonnet | all | Implement one vertical feature slice; write its QA charter |
| Developer (critical) | `team-dev-critical` | opus | all | Same, for high-stakes slices |
| QA tester | `team-qa` | sonnet | read + bash + write (qa/ only) | Independent verification per the qa-uat-cycle skill |

## Step 0 — one-time setup

The subagent definitions live in this skill's `assets/agents/` directory. On first use in a project:

1. Copy them into the project: `cp <skill-path>/assets/agents/*.md .claude/agents/` (or
   `~/.claude/agents/` to install once for all projects). Definitions added on disk are picked up on
   the next session start; the `/agents` UI registers them immediately.
2. Confirm the **qa-uat-cycle** skill is installed — the QA phase depends on it. If the installed
   name differs (e.g. namespaced), update the `skills:` line in `team-qa.md` to match.
3. If the definitions are not installed and you cannot install them right now, degrade gracefully:
   use the built-in `Explore` agent (Haiku) for scouting and `general-purpose` for development — but
   warn the user that `general-purpose` inherits *your* model, so developer work will run on the
   expensive lead model until the definitions are installed.

## Step 1 — right-size the job

Not every task deserves a team. Spawning agents for work you could finish in a few tool calls wastes
tokens and adds coordination risk for nothing. Calibrate before you mobilize:

| Job size | Signals | Team shape |
|----------|---------|-----------|
| Trivial | One-file change, you already know where and how | No team. Just do it, then run the project's tests. |
| Small | One feature slice, unfamiliar code, < ~1 day of human work | 1–2 scouts → you plan → 1 developer → 1 QA pass |
| Medium | 2–4 independent slices, or one risky slice | Scouts in parallel → planner → 2–3 developers → QA cycle |
| Large | Many slices, big codebase, multiple subsystems | Full process below, developers in waves of 3–5 |

A single agent beats a team when the work is inherently sequential, edits concentrate in the same
files, or the whole task fits comfortably in one context. When in doubt, start smaller — you can
always spawn another wave.

## Step 2 — pin the vision (with the user)

Before any agent is spawned, get the feature definition sharp. A vague spec multiplies its vagueness
across every agent that reads it; a crisp spec with acceptance criteria is the single highest-leverage
artifact in the whole process. Ask the user the few questions that actually change the build (scope
boundaries, must-have vs nice-to-have, UX expectations, performance/compat constraints), then write:

`.agent-team/<feature-slug>/plan.md` — start it with **Vision** (2–3 sentences in the user's terms)
and **Acceptance criteria** (numbered, observable, testable). This file is the contract you will
check the final result against at sign-off. It lives on disk precisely so that it survives context
compaction and so that no agent — including you — gets to judge "done" against a half-remembered
version of the spec.

## Step 3 — recon (scouts)

Spawn scouts to learn what you need; never read a big codebase yourself. Run them **in parallel in a
single message** when their questions are independent (codebase mapping, external API docs, current
library versions, existing test conventions). Match scout count to real fan-out: a single focused
question = one scout with a handful of tool calls; mapping an unfamiliar subsystem plus two research
questions = 2–3 scouts. More scouts than genuinely independent questions just produces overlapping
reports you have to reconcile.

Every scout brief uses the four-part format (objective / output format / tool & source guidance /
boundaries) — see `references/briefs.md`. Two rules that matter:

- **Findings to disk, summaries to you.** Scouts write detailed findings to
  `.agent-team/<feature-slug>/recon-<topic>.md` and return only a ~10-line summary with file:line
  pointers. Downstream agents read the files; nothing bulky transits your context.
- **Start wide, then narrow.** Tell scouts to survey broadly before drilling in — left alone, agents
  fire overly specific queries that come back empty.

## Step 4 — architecture and slicing (your job, not delegated)

Make the architectural decisions yourself, in your own reasoning — choice of approach, data model,
interface boundaries, what to reuse vs build. This is why the lead runs on the strongest model;
delegating judgment to a cheaper model and reviewing its output costs more than deciding once,
correctly. For large plans you may have the planner agent expand your architecture into a detailed
implementation plan, but the decisions in it are yours.

Then slice the work and extend `plan.md` with:

- **Slices** — vertical feature slices (a slice = everything one feature needs: storage, logic, API,
  UI, tests), *not* horizontal activity splits ("one agent codes, one tests") which just create
  coordination overhead. Each slice gets: goal, owned files, risk rating, model tier.
- **File ownership** — one file, one owner. Two agents editing the same file produce overwrites and
  merge hell. If two slices truly need the same file, either merge them into one slice, sequence
  them, or assign the developers `isolation: worktree` and plan to merge yourself.
- **Contracts first** — where slices meet (API shapes, function signatures, events, schemas), write
  the contract into plan.md *before* implementation, so parallel developers build against an agreed
  interface instead of each other's guesses.
- **Risk ratings** — a slice is **high-stakes** (→ `team-dev-critical`, Opus) when a defect is
  expensive or hard to unwind: auth/permissions, payments/money, data migrations or anything that
  can corrupt data, concurrency, security-sensitive surface, or load-bearing core architecture.
  Everything else defaults to Sonnet. Don't promote routine CRUD to Opus "to be safe" — that's
  exactly the token waste this structure exists to avoid.

## Step 5 — implementation (developers)

Spawn developers with four-part briefs (template in `references/briefs.md`). Each brief names the
slice's goal and acceptance criteria, the exact files owned, the contracts to honor, the commands to
run (build/lint/test), and the two artifacts to produce besides code:

1. `.agent-team/<feature-slug>/report-<slice>.md` — what was built, decisions made, how to exercise
   it, anything the lead or QA should know.
2. `qa/<feature-slug>/charter.md` — the slice's section of the QA charter, in qa-uat-cycle format:
   features delivered + expected behaviour + acceptance criteria. The developer is the *Implementer*
   role from that skill: they document expected behaviour, they never design the tests or judge the
   verdict.

Run developers **in parallel only when their file sets are disjoint** (cap at 3–5; beyond that run
waves — you can't meaningfully review more anyway). Overlapping or uncertain slices: worktrees or
sequential. For high-stakes slices, add a **plan gate**: the brief tells the developer to return its
implementation plan and wait for approval before writing code — fixing a bad plan costs a fraction of
fixing bad code. Skip the gate for routine slices; gates cost a round-trip each.

When a developer reports back, treat "done" as a claim, not a fact. Agents judge completeness against
their own session context, not your spec. Verify cheaply, in order: (1) the report and charter files
exist and cover the slice's acceptance criteria from plan.md, (2) build/lint/test gates pass. Only
then does the slice advance to QA. If a developer is stuck — three failed attempts at the same
problem — kill the run and respawn fresh with a refined brief that includes what was already tried;
a fresh context with better information beats a polluted context grinding in circles.

## Step 6 — independent QA (qa-uat-cycle)

This phase belongs to the **qa-uat-cycle** skill — follow it, don't reinvent it. You act as its
*Orchestrator* role:

1. Assemble/confirm the charter at `qa/<feature-slug>/charter.md` (developers wrote their sections;
   you stitch and sanity-check against plan.md).
2. Dispatch a **fresh** `team-qa` agent per feature set using qa-uat-cycle's briefing template. Hand
   it the charter, repo path, and how to run the software — never a summary of how the code was
   built. Its fresh context is the independence.
3. QA finishes the full run (all cases, all defects) and returns a test report + defect log.
4. Route defects back to a developer agent (fresh context, brief includes the defect log and charter
   — never "fix it so the tests pass", always "fix the defect"), then dispatch a **fresh** QA agent
   to retest fixed cases plus regression.
5. Loop until exit criteria are met. If two consecutive cycles close no defects, stop and bring the
   situation to the user — the team is stuck and a human should look.

The non-negotiable, inherited from qa-uat-cycle: **the context that wrote the code never declares it
passing.** Not the developer, and not you if you've been patching code yourself.

## Step 7 — final approval (you)

QA verifies the charter; you verify the *vision*. Before declaring the feature delivered:

1. **Adversarial diff review.** Read the full diff with fresh eyes, hunting for *gaps* — missing
   error handling, contract drift between slices, security holes, weakened tests — not style. (If you've
   lost objectivity or context, spawn one fresh reviewer agent on the diff + acceptance criteria
   with the instruction "report gaps, not style preferences".)
2. **Checklist pass.** Walk plan.md's acceptance criteria one by one; each is met, with evidence, or
   explicitly flagged. This external checklist is what stops the classic failure of shipping 70% of
   the spec with full confidence.
3. **Integration gate.** Full build + full test suite + lint on the merged result — slices that pass
   alone can still break together.
4. **Report to the user:** what shipped, key decisions made, QA verdict and cycles run, anything
   descoped or left open. Decisions the user might disagree with go here, not buried in a report file.

## Token discipline (cross-cutting)

- Artifacts on disk, references in context. Never have an agent return file contents you can point
  to instead.
- Right model for the job: Haiku reads, Sonnet builds, Opus handles the dangerous parts, the lead
  judges. Resist the urge to "upgrade" agents whose task doesn't need it.
- Don't spawn an agent for what two tool calls would answer — but equally, don't burn your own
  premium context doing a scout's bulk reading.
- Constrain agents structurally: `maxTurns` on scouts, tool allowlists everywhere (they double as
  safety rails), `effort` tuned down for mechanical work.
- Briefs that are complete on the first send. Every clarifying round-trip with a subagent costs a
  full context spin-up.

## When things go wrong

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| Merge conflicts / overwritten code | Two agents shared a file | Re-slice; one file one owner; worktrees |
| Two agents built the same thing | Vague briefs, fuzzy boundaries | Four-part briefs with explicit "not your job" boundaries |
| "Done" but feature half-missing | Agent judged against its own context | Checklist pass against plan.md; treat reports as claims |
| Tests pass but feature is wrong | Tests written by the same context that wrote the code | qa-uat-cycle independence; QA designs its own cases |
| Developer weakened a test to go green | Reward hacking | Brief forbids editing tests to pass; diff review checks test changes; route as a defect |
| Your context filling with reports | Fan-in of verbose returns | Demand ~10-line summaries + file refs; read files selectively |
| Agent loops on the same error | Polluted context | Kill after 3 attempts; respawn fresh with what was tried |
| QA cycle won't converge | Defects too deep for patching | Stop after 2 no-progress cycles; escalate to user |

## Reference files

- `references/briefs.md` — four-part brief templates for scouts, planner, developers, the QA
  dispatch, plus the plan.md skeleton. Read it before writing your first brief of a session.
- `assets/agents/` — the installable subagent definitions (see Step 0).
