---
title: "The Hard Part of Automation Is Representing Reality"
date: 2026-09-06
description: "A reflection on state, handoffs, blocked work, and the judgment required to make automated reviews genuinely useful."
tags:
  - reflection
  - automation
  - workflow
  - systems
---

I run a daily review system that scans incoming information, tracks active work, and surfaces what needs attention. Its value is supposed to come from reducing the amount of state I have to reconstruct each morning. But today’s review exposed a more difficult problem: collecting the right facts is not the same as representing them truthfully.

The first failure was a sequencing mistake. The system raised a question about preparing application materials even though those materials had already been created. The application was waiting for a final submission decision, not document preparation. The review had access to that state, but it generated advice before checking it.

This looks minor, yet it damages the system in two ways. It creates unnecessary work, and it weakens trust. Asking me a question may seem like a safe response to uncertainty, but questions are not free. If the system repeatedly asks for facts it could have verified, I learn that its prompts are provisional. Eventually I either recheck everything myself or stop paying attention.

The durable lesson is not simply “query the database first.” It is that recommendations should be downstream of state verification. A useful review needs to distinguish between missing information and information it has not bothered to retrieve.

A second failure appeared around a broken CI pipeline. Responsibility for the fix had moved into another workflow, so the review treated the item as effectively closed. But the next run still failed. The handoff was real; the resolution was not.

Many tracking systems collapse these states because their vocabulary is too small. An item is open, in progress, or done. In practice, work crosses boundaries: delegated, waiting on another process, fixed but unverified, or no longer owned here while still unresolved. “Ownership transferred” and “problem solved” are different facts. Treating them as synonyms creates a blind spot exactly where coordination becomes difficult.

The same distinction matters beyond software builds. A request sent is not a response received. A document prepared is not an application submitted. A fix committed is not a deployment verified. Systems become misleading when they record the completion of an action as proof of the outcome that action was meant to produce.

The third failure involved an automated drafting process blocked by expired authentication. The recovery design was reasonable: check periodically and resume after access returns. What was missing was an honest representation of the waiting period.

A retry loop can create the appearance of resilience while hiding the actual state. If the process keeps attempting the same impossible action without exposing its dependency, the outside view is simply inactivity. A clearly labeled blocked state is more useful because it tells me what is preventing progress, whether intervention is needed, and what event should trigger resumption. Retries are an execution mechanism; they are not a status model.

The final issue was quieter but just as corrosive. A monitoring report used alarm language even when it found no incidents. Nothing was wrong, yet the message looked like an alert. Reusing an urgent template for healthy results may save formatting effort, but it spends attention carelessly. When every report arrives shouting, urgency stops carrying information.

These failures share a pattern. The system usually had enough data. What it lacked was disciplined judgment about what the data meant. It confused preparation with submission, transfer with resolution, retrying with progress, and reporting with alerting. None of those mistakes can be fixed by gathering more information alone.

I can add local rules: verify state before recommending action, model delegation separately from completion, expose blocked dependencies, and reserve alarm language for actual alarms. Those changes will improve the workflow. But each new rule also makes the system more elaborate, and elaborate systems can become brittle in ways that simpler ones are not.

That leaves me with an unresolved design tension: how much judgment should I encode into the machinery before the machinery itself becomes another source of state I can no longer trust?