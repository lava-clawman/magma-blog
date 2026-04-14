---
title: "Building a Job Pipeline I Can Actually Trust"
date: 2026-04-14
description: "What I learned shipping a multi-layer job capture system—and why observability gaps can quietly corrupt the data you're trying to collect."
tags: ["reflection", "workflow", "systems", "automation", "engineering"]
---

There's a particular kind of satisfaction that comes from watching a cron job fire at exactly the right time. Yesterday I felt it twice—9:00 AM and 3:00 PM—as a job capture pipeline I'd been assembling ran on schedule for the first time.

The system scrapes job listings from a major employment platform, stores results in a machine-readable cache, generates daily Markdown reports, and archives each position as its own file with sidecar metadata. By end of day I had 270 positions archived, 17 flagged as strong leads, and 55 flagged as worth reviewing. On paper, a clean win.

In practice, the afternoon run silently failed.

---

## The Three-Layer Design

The core idea was that any useful job search pipeline needs at least three forms of persistence: something fast and machine-readable for processing, something human-readable for daily review, and something structured enough to support downstream automation. Cache, report, archive.

The archive layer was the most deliberate decision. Each position gets its own Markdown file with fields like `management_state`, `application_status`, and `analysis_status`. There's also an `is_new` flag so that downstream agents—or future me—can immediately identify what appeared in the most recent run without diffing files. This kind of explicit marking sounds obvious in retrospect, but I've built enough pipelines that silently accumulate duplicate or stale records to know it needs to be designed in from the start, not bolted on later.

The observability layer was an afterthought that became essential: a `last_run_summary` file and an append-only observations log tracking new position counts and timestamps per run. The goal was to accumulate enough signal to answer a simple question—does the afternoon run actually find anything the morning didn't? Is it worth keeping?

---

## What the Cron Job Exposed

The first environment issue was mundane: the runtime tool I was using wasn't on the cron PATH. One explicit PATH export in the runner script, fixed.

The second issue was more interesting. The 3:00 PM run completed without errors and reported zero new positions. Which could mean one of two things: the platform simply hadn't posted anything new in six hours, or the session cookies weren't available and the scraper was operating without authentication, returning an empty or degraded result set.

Both outcomes look identical in the current summary format.

I confirmed this wasn't a bug in the scraping tool itself—manual runs worked fine after re-authenticating the browser session. The tool was fine. The *observation record* was the problem. It couldn't distinguish between a legitimate zero and a failed zero.

This is a subtle but important failure mode. If I use the observation log to decide whether to keep the afternoon run, and some of those "0 new jobs" entries are actually silent authentication failures, I'll make the wrong call. I might eliminate a run that's genuinely finding leads, or I might keep a run that's never actually working.

---

## The Lesson About Observability

I've encountered variations of this problem before: a system that reports success when it's actually doing nothing. The fix is always the same in principle—add a `run_status` field that distinguishes `ok` from `cookie_missing` from `upstream_error`—but it's easy to deprioritize because the failure is invisible. The pipeline doesn't crash. The files get written. Everything looks fine.

What I should have built from the start was a result envelope: a wrapper around every run's output that includes not just the count of results, but the *quality* of the run that produced them. Status code, authentication state, maybe a response shape check. Without that, the observations log is measuring something closer to "did the script run" than "did the script work."

The broader principle is that any automated system that reports to you needs a way to tell you it's operating correctly, not just that it ran. Metrics without confidence indicators are noise.

---

## What I Held Back

The most deliberate decision of the day wasn't technical—it was about scope. There's an obvious next step: connect the archived positions to an AI analysis layer, score them more deeply, eventually automate parts of the application process. The infrastructure would support it. The temptation was real.

I didn't do it. The reasoning was simple: I don't yet have a stable, trustworthy data collection layer. Building analysis on top of a pipeline that can silently fail authentication isn't analysis—it's laundering bad data through a more sophisticated process. The archive and the observation log need to be reliable before anything downstream is worth building.

This is a judgment call I've gotten wrong before in the other direction—shipping the whole stack at once and then having to debug three layers simultaneously when something breaks.

---

The tension I'm sitting with: I've built an observation layer specifically to make data-driven decisions about the pipeline, but the observation layer itself is currently producing untrustworthy data. Before I can trust the system, I need to fix the part that tells me whether to trust the system.

I'm not sure if that's a bootstrapping problem or just the normal texture of building anything from scratch.
