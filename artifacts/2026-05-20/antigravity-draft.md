---
title: "When Shortcuts Become Debt: Lessons from a Broken Pipeline"
date: 2026-05-20
description: "A day of job applications, email automation, and the quiet cost of bypassing systems you built for a reason."
tags: ["reflection", "automation", "workflow", "job-search", "systems-thinking"]
---

There's a particular kind of technical debt that doesn't come from bad code. It comes from good systems that you choose not to use, just once, because it felt faster in the moment.

Today surfaced one of those moments clearly enough that I had to write it down.

## The Job Application Pipeline Problem

I've built a reasonably complete pipeline for processing job postings — ingestion, analysis, queueing, then syncing to a community forum where I track opportunities. The pipeline has five distinct steps, ending with a dry-run before any live post goes out. The dry-run exists specifically to catch duplicates before they happen.

Today I bypassed it. I posted manually to the forum for a job I'd found via email, and in doing so I introduced exactly the kind of duplicate risk the dry-run was designed to prevent. The script, it turns out, identifies posts by title and a lookup map — if that map doesn't know about a thread, it'll happily create a second one.

The fix was recoverable: backfill the manual thread into the map, then let the standard sync take over. But the fix took longer than just running the pipeline would have in the first place. That's almost always how it goes.

What struck me wasn't the error itself — it's that I knew the system existed and reached around it anyway. The justification in the moment was probably "this is faster." It wasn't.

## Writing Rules Where They'll Actually Be Read

The more interesting question is what to do after you catch yourself doing this. There are two obvious failure modes: write nothing down and repeat the mistake, or write it somewhere you'll never look.

I landed on writing it in two places — the skill file for the mail-review workflow, and the agent baseline file that gets consulted at the start of relevant sessions. The intent is that the rule surfaces where the temptation to bypass it is highest: when an email arrives flagging a job, right before someone (me, or an agent acting on my behalf) decides what to do next.

This is a small but real insight about documentation placement. Rules written in a README get read once. Rules written into the workflow — close to the decision point — have a better chance of influencing the actual decision.

## What eLearning Authoring Tools Actually Are

Separately from the pipeline work, I spent time today putting together application materials for a digital course developer role. In doing that, I had to clarify something I'd been fuzzy on: the distinction between eLearning authoring tools (Articulate Rise, Storyline) and the LMS platforms they feed into (Moodle, Canvas, Totara).

These are genuinely different things. Authoring tools are where you build the course content and interactions; they export to SCORM or xAPI packages. The LMS is where learners actually access and complete the course, and where completion data gets tracked. Conflating them is an easy mistake because the tools sit adjacent to each other in the workflow, but they solve different problems.

The reason this matters practically: a job description that mentions both is describing a full-stack instructional design workflow, not just one tool. Getting that distinction right shapes how you talk about relevant experience.

## The Memory Log Gap

One thing I noticed today: there was no daily memory log file for the session. That means whatever was learned or decided lives only in conversation history — ephemeral, not searchable, not reusable.

For low-stakes work that's fine. For anything that changes how future work should operate — like the pipeline bypass rule — it's a problem. The fix is obvious in theory: write durable decisions to durable places before the session ends. In practice, it's easy to close a tab and move on.

I did write the pipeline rule down today, which is a small win. But it only happened because I reviewed the day explicitly and noticed the gap. That review process is doing real work here — not as a ritual but as a forcing function for the kind of consolidation that doesn't happen automatically.

## The Tension That Remains

Here's what I haven't resolved: I built the pipeline to protect against manual errors, but I also maintain the flexibility to act manually when the situation feels like it warrants it. Today the situation didn't warrant it — I just thought it did.

How do you build systems that are robust enough to protect you from bad judgment calls, without becoming so rigid that they can't accommodate the cases where bypassing actually makes sense? If the system is too easy to override, you'll override it whenever friction spikes. If it's too hard to override, you'll either resent it or build shadow workflows around it.

I don't have a clean answer. The pipeline bypass today was a mistake, but I'm not convinced the right response is to make the bypass technically impossible. The right response might just be better judgment — which is the hardest thing to systematize.
