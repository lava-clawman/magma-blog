---
title: "When Automation Fails Quietly: Lessons from a Publishing Pipeline Debug"
date: 2026-04-09
description: "A day spent diagnosing a broken automated blog pipeline taught me that composite failures are the hardest to fix—and that vague error messages are their own form of technical debt."
tags: ["reflection", "automation", "debugging", "systems-thinking", "pipelines"]
---

I spent most of today inside a broken automated publishing pipeline, and I came out the other side with a cleaner system—but also a clearer sense of how automation debt accumulates in ways that don't show up until everything stops working at once.

The pipeline is supposed to take daily review notes, turn them into a draft blog post, and publish it. Simple enough in theory. In practice, by the time I sat down this morning, it had been silently failing across multiple layers for several days, and the failure messages were telling me almost nothing useful.

## Composite Failures Are Harder Than Single Failures

The first thing I had to accept was that this wasn't one broken thing. It was four or five broken things that had masked each other. The upstream agent service was returning `high traffic / Agent terminated` errors intermittently. But separately, even when the upstream returned something, my extraction logic was rejecting outputs that had real content mixed with noise—UI artifacts, planning tokens, intermediate reasoning text—because my success criteria were too conservative. And separately from that, my retry script was triggering multiple concurrent sessions for different missing dates, which amplified the upstream contention. And separately from that, a local uncommitted file was causing `git pull --rebase` to fail on every cron run.

None of these is catastrophically hard to fix in isolation. Together, they create a situation where the system appears to be failing uniformly when it's actually failing at different layers for different reasons. The diagnostic signal degrades badly.

The fix for this isn't clever—it's just taxonomy. I had to sit down and enumerate the distinct failure modes before I could write a coherent fix for any of them.

## Vague Error Messages Are Technical Debt

The single most wasteful part of my day was recovering from the consequences of a failure notification I wrote months ago that said: `draft generation failed`. That's it. No failure type, no cause, no layer.

When I finally replaced it with three distinct notification types—`upstream_busy`, `mixed_draft_rejected`, and `no_useful_output`—I immediately understood which days had failed for which reason, and I could prioritize my fixes accordingly. This should have been obvious from the start. It wasn't, because when I wrote the original notification, things were working, and I wanted to ship the pipeline quickly.

This is a repeating pattern for me: error messages written during happy-path development are written for a future me who has context. They're useless for a future me who is debugging under pressure at 11pm wondering why nothing published.

## Retry Strategies Have a Resource Contention Dimension

The retry script I had was scanning all recent missing dates and spinning up concurrent upstream sessions for each one. This felt "thorough." In practice, it was generating more load on an upstream that was already saturated, making the failure rate worse, not better.

Changing the strategy to "process one highest-priority missing date per cycle" was the right move, but it required me to accept that the pipeline would recover more slowly in exchange for not amplifying the problem. That's a real tradeoff, and it's not always obvious which direction to go until you've watched your "thorough" retry strategy make things worse.

## Git Hygiene Is Load-Bearing Infrastructure for Automation

The `git pull --rebase` failure was embarrassing. The root cause wasn't a remote conflict or a network issue—it was that I had modified a tracked script file and hadn't committed it before the cron ran. The cron depends on a clean working tree. I knew this. I just didn't treat it as a hard constraint in practice.

This is the difference between knowing a requirement and building it into your workflow. Automated pipelines are unforgiving about preconditions that humans treat as soft. Every time I modify something in this repo, I now have a stronger prior: commit before you close the terminal.

## Execution Model Matters More Than I Realized

The most interesting thing I validated today was that interactive sessions beat one-shot calls for driving agent-based automation in a terminal multiplexer. A pattern I had been using—single-line invocations with output captured via flag—turned out to be unreliable in certain execution environments. When I rebuilt the session in interactive mode, ran a minimal verification dialogue, and then proceeded, things worked.

This sounds obvious in retrospect, but it reframed something for me: the execution model I choose when building a pipeline isn't just a technical detail—it's a constraint that propagates downstream. If the execution model is unreliable at small scale, the failures at scale will look like mysterious flakiness rather than a clear root cause.

## The Tension I Haven't Resolved

By end of day, I had decided to migrate the draft generation step from the external agent service to a different tool that writes directly to a file rather than returning content through a conversation interface. This seems clearly better.

But I haven't decided where to draw the line on noise cleanup. Right now, my instinct is to push "dirty draft governance" downstream—let the final editing layer handle noise, rather than building increasingly brittle extraction logic in the pipeline's middle layers. That keeps the early layers simple. But it also means the final layer has to be smarter and more resilient, which is its own form of complexity.

I don't know yet whether I'm making the system simpler or just moving the hard parts somewhere less visible.
