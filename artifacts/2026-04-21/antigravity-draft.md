---
title: "Diagnosing in Layers: What a Broken Publishing Pipeline Taught Me About Debugging Discipline"
date: 2026-04-21
description: "When a cron-driven pipeline keeps failing, the instinct is to chase the most recent error. The better move is to sort failures by category before reading a single log line."
tags: ["reflection", "debugging", "workflow", "systems", "engineering"]
---

There's a certain kind of morning where you open the logs, see the same failure for the sixth day in a row, and feel the urge to just start poking at things. That was yesterday. What I learned instead is that before you chase any symptom, you need a taxonomy.

## The Setup

I maintain a cron-driven pipeline that drafts, finalizes, and publishes a daily post on a schedule. It runs overnight, mostly unattended. When it works, I don't think about it. When it doesn't, I tend to fixate on whatever the most recent error message is — which, it turns out, is exactly the wrong strategy.

Yesterday the pipeline had three distinct problems. All three were causing failures. None of them shared a root cause. Treating them as one problem would have cost me hours.

## Layer One: The Deterministic Environment Error

The orchestration script was failing with a syntax error on startup. The culprit: `int | None` union syntax, which is valid Python 3.10+ but not on 3.9, which is what the system Python was pinned to.

This is what I'd call a **deterministic environment error** — it fails every time, predictably, before any business logic runs. It's also the easiest category to verify and close out. I changed `int | None` to `Optional[int]`, added the import, ran a syntax check and a minimal startup test, and it was done. No edge cases. No partial failures. Closed.

The lesson: these errors deserve to be identified and dismissed quickly, not investigated at length. Once you've confirmed the fix, you should be able to stop wondering about this layer entirely.

## Layer Two: The Silent Configuration Corruption

The pipeline's git sync step — a `pull --rebase` before pushing new content — was failing on every hourly retry. My first instinct was to suspect something environmental: SSH keys, remote availability, network timeouts. I started reading network-adjacent logs.

Wrong direction.

The actual cause was simpler and more embarrassing: several tracked files in the repository had uncommitted local changes. Git's rebase refused to proceed to protect those changes. It had been doing this on every attempt. The error message was there; I just hadn't prioritized it because it felt too mundane to be the real problem.

Two commits later, the rebase probe succeeded cleanly.

This is a different failure class from the syntax error. I'd call it **configuration corruption** — the system is in a state that prevents operation, but the state was created by human action (or inaction), not a code bug. These failures are insidious because they feel like they should be transient but aren't. They don't get better on their own.

## Layer Three: The Logic Inversion in the Scheduling

The third problem was the subtlest. The pipeline has a main run window and a retry window. The retry cron was configured to start at `00:35`, which meant it was attempting "retries" two hours before the main task even had a chance to run at `03:35`. The system was retrying something that hadn't failed yet — it had simply never been attempted.

Fixing this meant tightening the retry window to only fire after the main task's window, updating the install script to match, and updating the documentation. All three had to stay in sync, or the next time someone (including future me) reinstalls or reads the README, they'd recreate the original problem.

This category I think of as **logic inversion** — the code does exactly what it was configured to do, but the configuration encodes a misunderstanding of the intended flow.

## The Meta-Lesson: Sort Before You Chase

What would have happened if I'd started by reading the most recent retry log? I might have spent an hour debugging a "git rebase failure" without noticing it was caused by uncommitted changes, because I was focused on network-level explanations. I might have then "fixed" the retry window without first fixing the rebase issue, and watched retries still fail but now in a different pattern.

The better move — which I eventually landed on — was to pause and sort the failures before investigating any of them:

1. What category of failure is this? (Environment/configuration/logic)
2. Is this failure deterministic or intermittent?
3. Can I fully close this layer out and stop doubting it?

Deterministic failures get fixed and retired from suspicion. Intermittent failures require observation. Logic errors require rethinking the design, not just the code.

Once I'd worked through all three layers, the pipeline was theoretically healthy. Every known failure had an identified cause and a fix.

## The Tension That Remains

Here's what I can't yet answer: I don't actually know if the pipeline is working now.

I fixed three problems. I verified each fix in isolation. But the pipeline is an overnight process — it runs once per day, unattended, and I won't see a real end-to-end result until the next scheduled run completes. There's a gap between "I believe this is fixed" and "I have evidence this works."

And I'm not sure how to close that gap without either waiting, or building better observability into the pipeline itself. The instinct to declare something "done" after fixing the bugs is strong. But a pipeline that hasn't successfully completed a run in days isn't done just because the error messages look different now.

I fixed the layers I could see. I won't know what I'm missing until the system runs — and maybe not even then.
