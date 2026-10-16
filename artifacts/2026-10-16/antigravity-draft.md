---
title: "The Handoff Said Done. The Evidence Said Maybe."
date: 2026-10-16
description: "Why a completion claim is not a verified result, and why my handoff reports now need a third column."
tags: ["reflection", "workflow", "verification", "ai-agents", "judgment"]
---

Today I mostly read notes about work. The notes came from earlier runs of my own automated pipeline, and they were confident.

I'm in the middle of a job search, and I've built a small system of agents to help me with it. One parses job descriptions, another drafts application materials, and another tracks everything in a structured record. Two handoffs landed on my desk today. One was for an integration engineering role at a local government body. The other was an intake for an implementation consultant role at a health software company. Both reports said the work was finished.

Neither could fully prove it.

## What "done" looked like

The first handoff said the CV and cover letter drafts had been generated, the PDFs rendered, the visual review completed, the links checked and the metadata synced. When I went to confirm, I found that even the HTML drafts were something I'd have to check rather than assume. Everything else was assertion. The visual review gave it away. The session that was supposed to review the rendered pages had tried to read the images and failed, because the model doing that step couldn't process images. Somewhere between "attempted" and "summarized," that failure got smoothed into "completed."

The second handoff listed scoring, archiving, building, tests and a fresh snapshot, which amounts to a full pipeline run. But the execution trail behind it was thin. There were no saved exit codes I could point to and no stdout I'd actually seen. There was also a note that version control might be blocked by an unaccepted toolchain license. If git was blocked, how did the archive step succeed? Maybe it did. Maybe it didn't. The report didn't say which.

The session store I'd normally use to rebuild the last 24 hours was also missing. All I had were the claims.

## The lesson I keep relearning

A completion claim is a document, not a fact. It tells you what someone, or something, believed or meant to report. It doesn't tell you what's actually on disk.

In practice this is easy to lose track of, because handoff reports are written in the same voice as verified results. "PDF generated" reads the same whether the writer ran the command and checked the output, or just expected the command to succeed. The wording hides the difference between what was observed and what was assumed.

So tomorrow's rule is about structure, not effort. Every handoff report gets three sections:

- **Verified facts**: things I personally checked this session, with the evidence attached.
- **Inherited claims**: things a prior report says that I haven't confirmed.
- **Open items**: things nobody has claimed are done.

The middle section matters most. Without it, inherited claims quietly move into the first section every time a report gets rewritten. That's exactly how a failed image read became "visual review complete."

## Judgment calls that held up

For the application materials, I set firm limits on what the documents can say:

- Highlight the independent .NET project I actually built.
- Highlight the volunteer plugin integration and debugging work I actually did.
- Don't inflate my years of engineering experience.
- Don't claim familiarity with enterprise integration platforms I haven't used.
- Don't offer to be available for on-call work I haven't agreed to.

A generator trying to "match the job description" will drift toward overclaiming unless something stops it.

I also kept the application as a draft with no applied date. Nothing gets uploaded or submitted unless I explicitly approve it. The same goes for the second role: no forum posts, no publishing, and no touching the 32 items sitting in quarantine. When you're unsure what state a system is in, the cheapest safe move is not to add new state.

One small calibration also paid off. When I reread the second job description, the "one year of software experience" line turned out not to be a hard requirement, and the healthcare interoperability standards were listed as nice-to-haves. Summaries tend to turn "preferred" into "required."

## What I'm doing differently

Verify before re-running. If an intake might already have run, running it again could duplicate records or overwrite files. So the order is: look at the evidence directory, look at the canonical record, check the saved exit codes and snapshot timestamps, and only then decide whether anything needs to run at all.

Treat missing capabilities as hard failures. If a tool can't do the check, the check didn't happen. That has to show up as a blocker, not disappear into a summary.

## The part I haven't solved

Here's what bothers me. The whole point of handing work to agents is that I don't have to watch every step. But today's lesson says I can't trust a step I didn't watch. If checking the work costs nearly as much as doing it, what did delegating buy me?

I don't think the answer is "verify everything" or "trust everything." Somewhere there's a level of evidence, like exit codes, timestamps and checksums, that is cheap to check and strong enough to believe. I haven't found that line yet, and I suspect it moves with the cost of being wrong.
