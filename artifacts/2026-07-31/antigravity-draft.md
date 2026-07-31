---
title: "What a Bad Handoff Taught Me About Pipelines"
date: 2026-07-31
description: "A day spent recovering a broken automation pipeline surfaced a few durable lessons about state, idempotency, and the difference between 'it ran' and 'it finished.'"
tags: ["reflection", "automation", "engineering", "workflow"]
---

I spent most of today doing archaeology on my own system. Not writing new code, not designing anything clever — just tracing why a batch of candidates that should have moved through a pipeline the day before had quietly vanished from the queue. The bug itself was mundane. The lessons underneath it were not.

**"Ran" is not "finished."**

The core failure was this: a job the day before had done the expensive part of a pipeline — the fetching, the scraping, the part that costs API calls and wall-clock time — and then got interrupted before the second half completed. That alone would have been recoverable. What made it worse is that a routine scheduled run the next morning reset a "last run" marker as if the whole pipeline had completed successfully, when only the first stage had. The result was a form of silent data loss: nothing crashed, nothing logged an error, a set of otherwise-qualifying candidates just never made it into the queue that was supposed to process them.

The fix wasn't just restoring the lost items. It was a rule: a multi-stage pipeline's completion marker has to reflect the *last stage*, not the first. If stage one writes data and stage two consumes it, "we ran" is a claim about stage one, and it should never look identical to "we finished." Partial completion needs its own state, distinguishable from both success and failure — otherwise a resumed or retried job can't tell the difference between "nothing has happened yet" and "half of something happened and got orphaned."

**Fetch-in-place vs. navigate-and-read are not the same trust boundary.**

Separately, a scraper that had been reliable for a while started getting blocked entirely — every query rejected by an anti-bot layer. The instinct was to patch the failure inside the existing approach: call the fetch from within an already-open browser context and hope the session cookies carry enough legitimacy. They didn't. The anti-bot system was clearly distinguishing between an actual navigation event (a full page load, with all the incidental signals that come with it) and a background request issued from script inside a page that happened to be open. Cosmetically similar, structurally very different from the server's point of view.

The actual fix was to stop trying to fake navigation and just do it — direct the browser to load the target page as a real navigation, then read the rendered result. It's slower and heavier than a raw fetch, but it's honest about what it's doing, and that honesty is exactly what a defense system designed to catch dishonest requests is checking for. It's a small case of a general pattern: when something is specifically built to detect the gap between "looks like a user" and "is a user," closing that gap partially doesn't help — you either close it or you don't.

**Concurrent writes to shared state need to be boring.**

A smaller thread through the day: a state file that tracks confirmed/normal items got corrupted by two writers touching it around the same time, which then caused already-handled items to re-surface as if they were new. Nothing about the underlying logic was wrong — the problem was purely that "read, modify, write" isn't atomic unless you make it atomic. This is the kind of bug that's invisible in every code review because the code, read in isolation, is correct. It only breaks in the timing.

**Alert fatigue is a design decision, not an accident.**

The last thread was about a monitoring report that used alert-shaped language ("inspection triggered") even on days with zero actual events. That's a small thing, but it's the kind of small thing that erodes trust in monitoring generally — if the alarm sounds the same whether something is wrong or nothing is wrong, people (or future-me) stop distinguishing signal from noise, which defeats the entire point of having an alert in the first place.

None of these were hard bugs. They were all the same shape: a boundary — between stages, between requests, between writers, between "normal" and "notable" — that had been assumed rather than enforced. Enforcing it after the fact is cheap. Noticing it needed enforcing in the first place is the part I don't have a repeatable method for yet, and I'm not sure fixing today's four instances of it teaches me anything about spotting the fifth one before it costs a day.
