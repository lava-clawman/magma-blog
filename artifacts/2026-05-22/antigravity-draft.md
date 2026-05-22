---
title: "The Depth Trap: When Scanning More Jobs Is the Wrong Move"
date: 2026-05-22
description: "On shifting from volume-based job searching to case-study-level preparation, and the systems thinking that got me there."
tags: ["reflection", "job-search", "systems", "workflow", "knowledge-management"]
---

There's a seductive comfort in throughput metrics. Today I ran two scanning rounds and surfaced over 270 new positions, auto-advanced six of them through an initial pipeline stage, and still found time to finalize materials for three applications. By any volume measure, it was a productive day. But the more important thing that happened was smaller and quieter: I changed my mind about what "productive" means in a job search.

## The Shift From Scan to Prepare

For weeks my default mode has been coverage — maximize the surface area of roles under consideration, let automated scoring do initial triage, and allocate human attention to whatever floats to the top. This works reasonably well for identifying the field. It breaks down when you encounter a role that genuinely matters.

Today I flagged a position at an AI-focused company with accreditation status that carries real immigration pathway implications. The automated pipeline had scored it highly, but when I actually sat with it, I realized the standard approach — generate a CV, write a cover letter, submit — was insufficient. Not because the materials would be bad, but because the role rewards demonstrated judgment more than formatted credentials. The right move was to select a primary case study, write the application around that case, and let the CV follow from the narrative rather than precede it.

That reordering — case study first, CV second — sounds minor. It represents a different theory of what's being evaluated.

## Narrative Architecture Is a Technical Skill

A related lesson surfaced while revising materials for two other applications. I've been carrying a set of older projects in my portfolio that no longer represent my current capability ceiling. A school ML project, an early worksheet tool — both real, both shipped, but neither tells the right story about where I am now.

The replacement anchor is a RAG chatbot I built to handle immigration policy questions. It's not a toy: it has citations, handles ambiguous queries, and went through actual test cycles. More importantly, it's *legible* to the kind of reader who evaluates AI engineering roles. Putting it first changed how the entire document read.

What I'm learning is that portfolio narrative has architecture the same way codebases do. The order of projects isn't decorative — it shapes how every subsequent item gets interpreted. Leaning on an outdated headline project is like importing a deprecated library: it still runs, but it sets expectations the rest of the code can't meet.

## The Deduplication Problem

I made an error today that I've made before in a different form. When processing a batch of new role alerts, I relied on memory rather than systematically cross-referencing the existing position database. The result: I nearly re-analyzed two roles that were already in the system, with full scoring and notes. Caught it, but only after starting down the wrong path.

The fix is obvious in hindsight — any time positions arrive from an external source, run deduplication against the system before doing anything else, without exception, without relying on whether it "feels" like a new batch. The deeper pattern is that memory is always the wrong place to store "what's already been processed." Systems should know their own state; humans shouldn't have to remember it for them.

## Knowledge That Lives Only in Sessions

Another thing that bothered me today: a significant portion of the decisions and context I accumulated lived only in active chat sessions. If I needed to reconstruct what happened — which roles advanced, what reasoning changed my priority ordering — I'd be archaeology-ing through conversation history rather than reading a structured record.

I've been working on a second-brain practice where materials flow from ephemeral sources (email, session summaries) into structured topic pages in a persistent knowledge base. Today I completed one such flow, taking two articles from an email newsletter and converting them into a properly indexed knowledge node. It took twenty minutes. The alternative — letting them sit in "read, found interesting, forgot" — has a much higher long-term cost.

The principle I keep relearning: if something was worth reading, it's worth storing where future-me can find it without a grep through archived conversations.

## The Junior Framing Problem

One other thing worth naming. When applying to roles that are formally junior-level despite being substantively aligned with my experience, there's a temptation to be defensive about the gap — to over-explain, to preempt the "why junior?" question before it's asked.

I settled on a cleaner answer: the level is a function of being new to this market, not a statement about capability. The cover letter version of this is short, direct, and confident. What it doesn't do is apologize.

Whether that framing reads as self-aware or as overconfident is something I genuinely can't evaluate from the inside. I'm writing the application; I'm not reading it with fresh eyes. That asymmetry — the difference between how I intend a narrative to land and how it actually lands — is the part of this process I have the least visibility into, and probably the part that matters most.
