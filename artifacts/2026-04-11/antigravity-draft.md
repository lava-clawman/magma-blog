---
title: "Debugging the Pipeline You Thought You'd Already Fixed"
date: 2026-04-11
description: "On tracing intermittent failures to the right layer, simplifying validation logic, and the uncomfortable gap between 'it ran' and 'it ran correctly'."
tags: ["reflection", "automation", "systems", "engineering", "multi-agent"]
---

There's a particular kind of debugging session that humbles you — not because the problem was hard, but because the problem was exactly where you should have looked first, and you didn't.

Today was one of those days.

I've been running an automated content pipeline that generates draft posts from daily review notes. The pipeline has two broad stages: a draft generation phase and a finalization/publish phase. For months the finalization stage has been stable. The draft stage kept misfiring — intermittent failures, hard to reproduce, easy to blame on prompt quality or validation logic. So I kept patching those parts.

The actual culprit was simpler and older: the draft stage was still invoking the language model CLI directly from a cron script. The finalization stage had long since been migrated to route through an agent. Direct CLI calls accumulate session state issues in ways that agent-routed calls don't. The two stages of the same pipeline were using fundamentally different execution models, which is why they had fundamentally different reliability profiles. I had been debugging the wrong layer for weeks.

Once I saw that, the fix was obvious: route the cron trigger through the agent, and let the agent own that execution surface. Not a complicated architectural change. The kind of change that, in hindsight, you wonder why you deferred.

---

But the more interesting part of today was what happened after I made that change.

My first instinct for validating the new path was to check whether the agent returned the right acknowledgment text — something like `DRAFT_WRITTEN` in its response. It seemed like the natural thing to verify: did the agent say it succeeded?

The first test run generated the draft file correctly. And then failed validation, because I'd gotten the expected text slightly wrong.

This is a trap I fall into repeatedly with agent pipelines: treating the agent's verbal output as the source of truth for success, when the actual artifact — the file, the database row, the state change — is right there to check directly. Text parsing of agent responses introduces a whole class of fragility that has nothing to do with whether the work was done. I caught it quickly this time, but only after a failed test that didn't need to fail.

The better success criterion: does the target draft file exist and pass format validation? If yes, the stage succeeded. Simple, stable, not dependent on parsing natural language output. I should have started there.

---

There was also a smaller lesson today, one I've learned before but apparently need to relearn on a schedule: cron scripts depend on a clean repository state. I ran a regression test using an older date, which meant pulling recent changes — and hit a `git pull --rebase` failure because of uncommitted local modifications. The cron environment makes no allowances for developer-mode working state. If there are tracked changes sitting in the working tree, the automated run the next morning will fail in the same way.

The fix is simple: commit before you're done for the day, even if the commits feel preliminary. The discipline is the point. Automation assumes a clean handoff.

---

One thing I deliberately chose not to resolve today: whether the agent is actually invoking the underlying tooling the way I intended, or whether it found a different path to produce the correct output file.

On one hand, this doesn't matter. The success criterion is the file. The file exists. The downstream stages don't care how it got there.

On the other hand, it does matter. If the agent is taking a shortcut I didn't sanction, that shortcut may not hold under different inputs, different dates, different review lengths. I'd be sitting on a silent assumption that only surfaces the next time it breaks.

I made a pragmatic call: stop here, ship the commit, observe the real cron run tomorrow. Don't over-engineer the verification layer before you know whether the basic automation works in production. Reasonable, I think. But I'm aware I'm trading correctness-of-mechanism for speed-of-learning, and I don't fully know yet whether that's the right trade.

Tomorrow I'll find out if the new path holds up when no one is watching. That's the only test that matters for cron automation — not the regression playback, not the manual trigger, but the unattended scheduled run at a time when you're not in front of the terminal.

The tension I'm sitting with: at what point does "the output is correct" become sufficient evidence that "the process is correct"? In deterministic systems, you can inspect the mechanism. In agent-routed pipelines, the mechanism is partially opaque by design. I haven't found a satisfying answer for when to trust the output and when to demand transparency into the path.
