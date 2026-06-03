# Defects, Retest, and Sign-off

A defect log is only useful if every entry means the same thing and carries enough for someone else to
reproduce and fix it without asking you. This file defines the format, the severity scale, the
lifecycle each defect moves through, how retesting works, and when the cycle is allowed to end.

## Defect format

Log defects in `defects.md` (see `assets/defect-log-template.md`). Each defect:

```
### DEF-001 — <short, specific title>
- Status: Open
- Severity: Major
- Test case: TC-07  (and/or the feature / acceptance criterion it violates)
- Environment: <how it was run — branch, URL, role, seed data>
- Steps to reproduce:
  1. ...
  2. ...
- Expected: <what the charter says should happen>
- Actual: <what actually happened>
- Evidence: <error text / status code / screenshot path / DB state / failing command>
- Notes: <optional: suspected root cause, only as a hint to the Implementer>
```

The pairing that matters most is **Expected vs Actual**, both phrased as observable behaviour, plus
**Steps to reproduce** precise enough that the Implementer hits the same thing on the first try. If you
can't write clean repro steps, you haven't pinned the defect down yet.

## Severity

Severity is about **impact**, judged against the charter — not how hard it is to fix.

| Severity | Meaning |
|----------|---------|
| **Critical** | Core feature unusable, data loss/corruption, security hole, or the charter's primary flow is blocked. No reasonable workaround. |
| **Major** | A feature deviates significantly from its acceptance criteria. A workaround may exist but is painful or non-obvious. |
| **Minor** | Small deviation, limited impact, or a noticeable but non-blocking issue. |
| **Trivial** | Cosmetic, wording, or nitpick. Worth recording, not worth blocking on. |

If you want to capture urgency separately from impact, add an optional **Priority** (P1/P2/P3) — but
severity is what drives exit criteria, so always set it.

## Defect lifecycle

A defect moves through these statuses. Keep the status current — it's how the cycle knows what's left.

```
Open ──▶ Fixed (awaiting retest) ──▶ [QA retests] ──▶ Closed        (fix verified)
  ▲                                                 └─▶ Reopened ──▶ (back to Fixed…)
  │
  └── Deferred / Won't-fix (with rationale, agreed with the user)
```

- **Open** — QA raised it; not yet addressed.
- **Fixed** — Implementer believes it's resolved and has noted what changed. Awaiting QA retest. (The
  Implementer sets this and adds a short note on the fix; it is *not* a pass — only QA can close it.)
- **Closed** — QA retested and confirmed the fix. The only way a defect closes is a fresh QA
  verification, for the same reason the original test was independent.
- **Reopened** — QA retested and it still fails (or the fix introduced a new problem). Add what you
  observed this time; bump it back to the Implementer.
- **Deferred / Won't-fix** — explicitly accepted by the user with a stated reason. This is a decision,
  not a default — never silently drop a defect.

## Retest procedure

When the Implementer hands back fixes and requests a retest, the retest is run by a **fresh QA
context** (subagent or separate session), and it does two things:

1. **Re-run the failed cases** tied to each Fixed defect. Confirm the expected behaviour now occurs,
   with fresh evidence. Close or reopen accordingly.
2. **Regression-check neighbours.** Fixes break things. Re-run the test cases most related to what
   changed (same feature, shared data, adjacent flows). A fix that closes DEF-003 but breaks a
   previously-passing case is itself a (new) defect — raise it.

Then update the markup (below), increment the cycle in `test-report.md`'s cycle log, and produce a
fresh verdict. Repeat until exit criteria are met.

## Markup conventions (marking up completed work)

Make state scannable at a glance. Use a clear status label as the source of truth; an emoji prefix is
optional sugar on top.

- Test cases in `test-report.md`: `Pass` ✅ · `Fail` ❌ · `Blocked` ⛔ · `Pass with notes` ⚠️ ·
  `Not run` ⬜
- Defects in `defects.md`: `Open` 🔴 · `Fixed` 🟡 · `Closed` 🟢 · `Reopened` 🔵 · `Deferred` ⚪

When a defect closes, leave it in the log as **Closed** with the cycle it was verified in — don't
delete it. The history of what broke and got fixed is part of the value, and it stops the same defect
being "rediscovered" later.

## Exit criteria and sign-off

The cycle is complete (QA can sign off **PASS**) when:
- Every in-scope test case has been executed (Pass / Pass-with-notes), none left Not-run or Blocked
  without explanation.
- No **Open** Critical or Major defects remain. Each is either Closed or explicitly Deferred/Won't-fix
  with the user's agreement.
- Remaining Minor/Trivial defects are logged and triaged (the user has seen them and chosen to accept
  or defer).

Record the sign-off in `test-report.md`: the verdict (PASS / PASS WITH CONDITIONS / FAIL), the cycle
number, the pass/fail/blocked counts, the open-defect counts by severity, and a one-line rationale.
That line is the thing a human reads to trust that "done" actually means done — make it honest. If
there are open Major defects, the verdict is FAIL, however much work went in; say so plainly rather
than dressing it up.
