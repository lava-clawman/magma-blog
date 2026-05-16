---
title: "The Rule Was There. The Gate Wasn't."
date: 2026-05-16
description: "On the difference between having a constraint and actually enforcing it—and what it takes to make an AI workflow fail loud instead of silently drift."
tags: ["reflection", "workflow", "ai-agents", "systems-thinking", "job-search"]
---

Somewhere in my agent's configuration, the rule existed: before running the email review workflow, read the local state file and the recent log. The constraint had been written down after a previous incident. The agent had, in theory, been told.

It didn't matter. The agent ran the review anyway, hit emails it had already processed, and surfaced the same questions to me a second time. The rule existed. The gate did not.

This is the distinction I kept turning over today.

---

There's a seductive kind of progress that comes from writing rules into configuration files. You document the constraint, you feel like you've fixed the problem, and then you move on. But a rule written into a prompt or a guidance file is not the same thing as an enforced gate at the start of an execution path. The former is advisory. The latter is structural.

The email deduplication failure wasn't a missing rule—it was a missing check. The agent had no mechanism that *required* it to consult the state file before proceeding. It would do so if it happened to reason about it in context, but there was no hard dependency, no forced read, no invariant that blocked forward progress until the precondition was satisfied.

Once I saw it that way, the fix became obvious: extract the email review logic into a standalone skill with an explicit state-checking step baked into the workflow definition itself. Not "the agent should check the state file." But "step one of this skill is: read the state file and the recent log, and if the email has already been processed, stop here." The skill becomes the gate. The workflow is now deterministic by construction, not by hope.

I've been thinking about this pattern more broadly. The main agent configuration had accumulated a lot of email processing logic over time—classification rules, deduplication heuristics, response handling, follow-up tracking. It had grown because each edge case felt small enough to handle inline. But complexity compounds. Eventually the main configuration becomes so heavy that the agent starts to skip or reorder steps, not out of malice, but because there's simply too much context to weight correctly in every pass.

The skill extraction fixes this in the same way that a well-scoped function fixes spaghetti code: it creates a boundary. The main agent's job is routing and triggering. The skill's job is the detailed workflow. Each does one thing. Neither bleeds into the other's domain.

---

A parallel lesson surfaced today from a completely different part of the system—my job scanning pipeline.

I'd been searching a job platform using traditional title-based queries: developer, analyst, engineer. The scanner worked fine for roles labeled that way. But several positions I actually wanted—roles involving business systems, automation tooling, low-code platforms, and AI-adjacent support work—were getting missed entirely. The companies posting them weren't using the same vocabulary I was searching for.

The gap was a query strategy gap. Job titles describe organizational hierarchy. Capability keywords describe actual work. When a role involves Power Platform, SharePoint automation, or application support for internal systems, the listing might not say "developer" anywhere. Searching only by title means searching only in the space where traditional naming conventions hold.

This is the same structural problem as the email rule. The intent existed—find relevant positions—but the mechanism didn't match the reality of how those positions are actually labeled. The fix requires the same move: get closer to ground truth. Search for what the work actually involves, not for what we assume the label should be.

Both failures share a shape: the system had a goal, the goal was represented in some form, but the representation didn't connect cleanly to the real-world signal it was meant to capture. Rules that don't bind. Queries that don't recall.

---

I also noticed something about my own discipline around long-running tasks today. When the material generation process stalled with no output, I resisted claiming it had finished. That sounds obvious, but it's easy to drift—to report completion based on the last visible action rather than the actual artifact. Waiting for the file to exist before marking the task done is a small thing. But it's the same move: don't let intent substitute for evidence.

---

What I haven't resolved is this: I've built a skill with an explicit state-checking gate. But the skill only enforces the gate if it's invoked correctly, and if its own workflow definition is actually followed. At some level, every enforcement mechanism rests on a softer layer beneath it. You can formalize one step, but you can't formalize all the way down.

The question I'm sitting with is where to draw the line between structural enforcement and trust—and whether there's a version of this where the system fails loud enough, fast enough, that the drift gets caught before it compounds. I don't have a clean answer. The next run of the email review will be the first real test.
