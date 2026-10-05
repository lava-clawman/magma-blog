---
title: "A Report Is Not a Result"
date: 2026-10-05
description: "Notes from fixing a small automation pipeline, mostly about keeping plans, reports, and verified evidence separate."
tags: ["reflection", "automation", "verification", "workflow", "engineering-judgment"]
---

Today was mostly repair work on a small automation pipeline I use for my job search. A daily step pulls in postings, a formal analysis step scores each one against my background, and a final step posts selected roles to a discussion forum. Two postings were authorized to go through it. By the end of the day I had reports saying both had been analyzed and scored. I did not have independent verification of those reports, and that gap is what this post is about.

## A report is not a result

Earlier in the day, a completion claim came in that looked fine: analysis done, status updated. When I looked for the trail behind it, I couldn't find any of it. There was no visible read of the job description, no cross-check against my profile, no model call, no backup before the write, and no validation step. A later report described checking the structured output for both roles. But a description of a check is not the same as me reading the artifact on disk.

So I now put claims into three buckets. A plan says what should happen. A report says what someone or something says happened. Verified evidence is what I can re-derive from artifacts, diffs, tests, and the target state. Most of my mistakes with automated workflows come from quietly moving a claim from the second bucket into the third because it sounded confident.

## Limit what a step can touch

I kept the scope of the analysis tight on purpose. The worker could touch the detail record, the index, and a few source fields. It could not touch application status, application dates, the timeline, or the original source identity. It could not generate application materials, submit anything, or send messages.

Writing down what a step must not change has helped me more than describing what it should do. The design came from that list. The worker is bounded. Errors are handled per item instead of failing the whole batch. State invariants are checked before writing, and a compare-and-swap keeps a stale read from overwriting newer state. The job description counts as untrusted input, because it is outside text that gets passed to a model.

## Don't fix a bug by removing a capability

The runner had drifted toward a safer-looking mode: create new items, never update existing ones. That's tempting, because create-only can't damage records. It also stops the pipeline from doing its job. The repair restored normal live behavior and set aside only the risky backlog, a few dozen stale content updates, tag changes, and renames, for separate review. Items waiting for formal analysis got their own queue instead of sharing one with everything else.

A permanent restriction would have felt responsible while hiding the problem until I forgot why the restriction existed.

## A handoff file is a plan, not proof of delivery

Publishing to the forum belongs to a parent session that has permission to create threads and replies. The repair produced a handoff file listing what should be posted. It's easy to mistake that file for a record of what was posted. The rule I'm keeping: check for duplicates, publish, read the result back from the forum, and only then update the mapping between postings and threads.

If the analysis worker fails, or rebuilding the derived outputs fails, the publisher must not act on an outdated queue. A failed verification should stop publishing and leave application state alone. Quietly succeeding on stale data is worse than halting with an error.

## Say what the review can't see

The daily review had a blind spot of its own. The script that lists the last day's active sessions reported that no session store was found, so this reflection draws only on the memory logs it was given. Work done in other sessions is missing. The review should state that coverage plainly instead of implying it's complete.

## What's still open

Tomorrow is mostly verification. I need the worker's actual result, a review of its failure paths and state guards, a check of both postings' artifacts against the index and detail records, and confirmation that the application fields didn't change. Only then will I decide whether to publish.

What I haven't settled is cost. Every distinction I drew today between plan, report, and evidence adds a verification step, and each step eats into a pipeline that was supposed to save time. If I verify everything by hand, the automation turns into an elaborate to-do list. If I trust the reports, I'm back to confident claims nobody checked. I don't know yet which checks can safely be automated and which have to stay manual. I also don't know whether any verifier I build would just become one more report to verify.
