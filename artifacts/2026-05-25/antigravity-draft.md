---
title: "When the Story You're Telling Isn't the Story That's True"
date: 2026-05-25
description: "On rewriting a job application narrative mid-process, and what that reveals about the gap between how we package our work and what we actually learned."
tags: ["reflection", "job-search", "agentic-workflows", "product-thinking", "self-presentation"]
---

There's a particular discomfort in realizing, halfway through polishing a video script, that the story you've been rehearsing isn't quite honest.

Not dishonest in a fabricated way. More like: you've been emphasizing the artifact — the product, the demo, the named thing — when the real substance was the messy, ongoing process that produced it. I hit that realization today while working on application materials for a role focused on agentic intelligence. I had been framing my work as "I built a career matching AI product." Clean. Impressive-sounding. Also somewhat beside the point.

The reframe I landed on feels more accurate: I've been running myself as a real user of an AI-native job search workflow, and that sustained use — with its failures, rebuilds, and judgment calls — is what actually produced any product thinking worth talking about. The product was a byproduct. The workflow was the work.

This matters for the application, but it also matters as a more general observation about how engineers and builders talk about their work. We default to artifact-first storytelling because artifacts are legible. "I shipped X" is a sentence anyone can parse. "I spent four months iterating on a workflow that kept breaking in instructive ways" is harder to package, even though it's often where the real learning lived.

---

The other thing I've been sitting with today is a failure in my own infrastructure. The daily review automation — a cron job that synthesizes what happened across my sessions and writes it to a structured log — timed out last night. I caught it, re-triggered it manually, and it ran fine. But the fact that it failed points to something fragile: the job that does "collect + synthesize" is doing too much in one pass, against a context window that's too large, with a model that isn't always the most stable choice for long-running async work.

The obvious fix is to split it: one job that collects and structures raw context, a second job that does the writing. This is a pattern I've applied in other parts of the system but haven't applied here, probably because "daily review" feels like a single coherent task even when it's actually two distinct operations with different resource profiles.

There's a broader principle hiding in this: the seams where automation breaks are usually seams that were always there in the underlying process, just invisible when a human was doing it. Humans context-switch mid-task fluidly. Automated jobs don't. When you try to encode a fuzzy human workflow into a scheduled script, the hidden joints become load-bearing — and they fail under pressure.

---

The third thing worth noting: today's review script reported "no memory logs found for today." What that means is that the events worth capturing — the reframe on the job narrative, the cron failure, the smoke test on the upgraded system — were scattered across chat sessions rather than written into the lightweight log layer that the daily review script actually reads.

This is a data provenance problem. The right events were happening. They just weren't landing in the right place in real time. The daily review then has to reconstruct from chat history, which is noisier and less reliable than a clean event log.

The improvement is obvious in retrospect: high-signal events should be written to the memory layer as they happen, not reconstructed afterward. But this requires either more discipline at the moment of decision, or an automated hook that captures session events into the log layer continuously. Both options have costs — the first costs attention during focused work, the second costs complexity in the infrastructure.

I haven't decided which cost I'm willing to pay. Probably some combination of both, with neither fully solving the problem.

---

What I keep returning to is the relationship between honest self-presentation and the systems we build to support ourselves.

The job application reframe — from "I built a product" to "I've been running a real workflow and learning from it" — is also a better description of how I think about the automation infrastructure I run. It's not a finished system. It's a living one, with failure modes I'm still discovering and design decisions I'm still second-guessing. The daily review cron is a good example: it works until it doesn't, and the failure reveals something about the design that success had been hiding.

What I can't fully resolve is whether this kind of honest framing — "here's what I learned from the breakage" — is what people evaluating you actually want to hear, or whether they want the cleaner story. The cleaner story is easier to assess. The messier story is more true.

I don't think I can have both. And I'm not sure which one I should be optimizing for.
