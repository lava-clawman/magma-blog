---
title: "When the System Is the Bug: Fault Attribution in Long-Running AI Pipelines"
date: 2026-04-08
description: "A day of testing an AI fiction pipeline surfaced a harder question: when something degrades slowly over time, how do you know whether to blame the model, the prompt, or the architecture?"
tags: ["reflection", "ai-writing", "systems-thinking", "engineering", "fault-attribution"]
---

Yesterday I ran a real end-to-end validation of a long-form fiction pipeline I've been building. The test: generate a novel, chapter by chapter, and watch it run. By chapter ten, I had my answer — but it wasn't the answer I expected.

The system worked. That was the first surprise. Chapters advanced, word counts were tracked, state updated, audit logs accumulated. The pipeline was mechanically sound. But somewhere around chapter five, something quieter failed: the story entered a loop. Emotional arcs stalled. Pacing became monotonous. Foreshadowing kept getting added, never collected. The prose started repeating itself at the vocabulary level. By chapter ten, the machine was technically producing output while narratively going nowhere.

My first instinct was to blame the model. That's the easy move. The model is the last thing in the chain — the most visible actor — and it's producing the degraded output. Swap the model, problem solved, right?

I caught myself before making that jump.

## The Three-Layer Attribution Problem

I've started thinking about failures in AI pipelines the way I think about distributed systems failures: you almost never get a clean single-cause error. You get a cascade, and the cascade has layers.

In this case, I broke it down:

**Layer 1 — Process/Methodology.** The planner and composer components had no enforced chapter-type rotation. Nothing forced the structure to change after five chapters. The "hook" mechanism was biased toward advancement — introducing new threads — with no corresponding obligation to close old ones. The audit system could detect problems but couldn't create hard corrective pressure. This was architectural, not model-level.

**Layer 2 — Prompt and Control Surface.** The steering was mostly stylistic guidance. Soft suggestions. There were no hard constraints that said: "you have used this sentence structure four times in three chapters, this is now forbidden." No debt-collection mechanism forcing old threads to resolve before new ones opened. The control surface was expressive but not engineering-grade.

**Layer 3 — Model Capability.** Yes, the model's tendencies amplify whatever the pipeline feeds it. A weaker writer-model will degrade faster. But a stronger one will still degrade if layers one and two are feeding it a structurally broken trajectory.

The insight that felt most durable: *the pipeline was compressing a good story into a bad loop before the model ever saw it.* The model was then faithfully reproducing and extending that bad loop. Blaming the model would have sent me chasing the wrong fix.

## Controlled Variables, Actually Controlled

To test the boundary between layer-two and layer-three problems, I ran a minimal comparison: same pipeline, same chapters, only the writer model changed. One run with the lighter model, one with the next tier up. Everything else stayed identical.

This sounds obvious. In practice, I find it genuinely hard to maintain this discipline when something is broken and I have the urge to fix multiple things at once. "Better model and better prompts" is not a controlled experiment. It's two interventions that will leave me unable to explain the result either way.

If the stronger model reproduces the same degradation pattern, that's strong evidence the problem lives in layers one and two. If it meaningfully escapes the loop, I've learned something about the headroom available from model quality alone, and I know the architectural fixes can wait.

Results from that comparison are still pending.

## A Smaller Lesson About Monorepos

Separately, I spent time chasing a CI failure in an upstream open-source project I contribute to. The pipeline was red. Initial assumption: my recent changes broke something.

Actual cause: internal packages in the monorepo had been listed with pinned version numbers instead of workspace protocol links. The build system was resolving the wrong versions of its own packages — it was importing stale type declarations from a previous release rather than the live source. Nothing to do with my changes.

The fix was a one-line restoration of the workspace link syntax. Tests went green. But I'd burned time assuming I was the source of the problem before I read the dependency graph carefully enough to see what was actually happening.

Two lessons in one day with the same shape: *don't attribute failure to the most recent visible actor until you've traced the full chain.*

Splitting the fix into its own independent PR — separate from the feature work — felt important. Mixing a monorepo infrastructure repair into a feature branch makes the history harder to read and the review harder to complete. Concerns should be separated even when they're discovered together.

## What I'm Still Not Sure About

The deeper question I keep returning to: is the middle-chapter degradation problem fundamentally an engineering problem, or is there something inherent about autoregressive generation in long narrative contexts that makes structural coherence over many chapters qualitatively hard?

I believe it's mostly engineering. I believe better process constraints, harder prompt-level rules, and a genuine audit-correction loop rather than an audit-logging loop would produce substantially better results. I believe this in the same way I believe most performance problems are fixable given enough measurement.

But I don't know it yet. And there's a version of this where I spend another month tightening the process layer and discover that the model simply cannot hold a long narrative arc in working memory across thirty-plus context windows in a way that feels organic rather than mechanical. That would be a different kind of answer — not a bug to fix, but a constraint to design around.

The comparison test will tell me something. I don't know yet which answer I'm hoping for.
