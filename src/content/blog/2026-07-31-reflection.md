---
title: "The Difference Between Running and Finishing"
date: 2026-07-31
description: "Recovering a partially completed automation pipeline revealed durable lessons about state, retries, trust boundaries, concurrency, and alerts."
tags:
  - reflection
  - automation
  - engineering
  - systems
---

I spent much of today doing archaeology on a system I had built myself. A batch of records had been collected successfully, yet some of them never reached the later stages that evaluated, stored, and surfaced them. Nothing had obviously crashed. The logs contained activity. The scheduler had continued running. From a distance, the workflow looked healthy.

It was not healthy. It had merely run.

The first lesson was that a multi-stage pipeline needs a precise definition of completion. One stage had performed the expensive acquisition work, then the process was interrupted before downstream processing finished. The next scheduled run replaced a marker describing the previous batch, effectively treating partial progress as a completed cycle. The data still existed, but the system had lost the knowledge that it needed more work.

That distinction now feels fundamental: execution is an event; completion is a verified state. If a workflow has five stages, success cannot be inferred from evidence that stage one happened. Each stage needs durable state, and the final completion marker should only move after the final required effect has been confirmed. Otherwise, retries become guesses and interrupted work becomes invisible.

Recovery also changed how I think about idempotency. It is tempting to design the happy path first and add retry logic later. In practice, retries are part of the normal path. Processes are interrupted, sessions disappear, networks fail, and schedules overlap. A robust pipeline should be able to resume from the last confirmed boundary without duplicating side effects or discarding unfinished work. “What happens if this runs twice?” is not an edge-case question. It is one of the first design questions.

A second failure exposed a different kind of boundary. An automated retrieval step began receiving consistent rejection from an anti-bot layer. My first workaround tried to issue a background request from inside an existing browser session. It seemed reasonable: the browser already had the relevant context, so the request should have looked legitimate.

But a scripted request from an open page is not equivalent to a real navigation. The server was evaluating more than cookies or headers; it was evaluating the shape of the interaction. The reliable fallback was heavier but simpler: navigate the browser to the page as a genuine page load, then read the resulting content.

The broader lesson is not about bypassing a particular defense. It is about respecting trust boundaries. Two operations can return similar data while having very different semantics to the system on the other side. When an integration depends on pretending those operations are interchangeable, it is fragile by construction. Sometimes the correct fallback is not a cleverer imitation of the fast path, but a slower path whose behavior matches the real interaction model.

A smaller bug reinforced the same theme. Two processes updated a shared state file at nearly the same time. Each independently performed a sensible read-modify-write sequence, yet together they produced an incorrect result. The logic was fine in isolation; the boundary between writers was not enforced.

Shared state should be boring. Writes should be atomic, ownership should be clear, and concurrent updates should either be serialized or merged through a mechanism designed for them. A plain file can be perfectly adequate, but only if I treat it as a shared resource rather than a convenient global variable. Once state controls whether work is repeated, skipped, or announced, corruption becomes a workflow problem rather than a storage detail.

Monitoring revealed one final version of the pattern. A routine report used alarm-like language even when there were no events to report. Technically, it was accurate: the check had run. Operationally, it was misleading. Alerts are part of the system’s interface, and their wording teaches me how much attention to give them. If normal and abnormal states sound alike, I will eventually ignore both.

Across all four problems, the common failure was an assumed boundary: between started and completed, browser context and browser navigation, one writer and another, routine status and actionable warning. The fixes were straightforward once the boundaries became visible. What remains unresolved is how much explicit machinery I should add to make every boundary visible in advance. More checkpoints, locks, validation, and state transitions make recovery safer, but they also make small systems heavier. I still do not know where disciplined engineering ends and defensive overengineering begins—and the next failure will probably occur exactly where I draw that line.