---
title: "When a Handoff Says Done"
date: 2026-10-16
description: "A reflection on evidence, inherited claims, and the judgment needed to trust delegated work."
tags:
  - reflection
  - workflow
  - verification
  - engineering
---

A handoff can sound complete long before the work is complete. I ran into that gap while reviewing two pieces of delegated work: a set of application materials and an intake record for another opportunity. The summaries were tidy. They named artifacts, checks, and updates as if each step had been observed. The available evidence was much less tidy.

One handoff described drafted documents, rendered PDFs, visual review, link checks, and synchronized metadata. The review I could see did not establish that chain. Even the existence of the drafts needed checking; the later steps could not simply be inherited as facts. Most tellingly, an attempt to inspect rendered images had failed because the model assigned to that step could not process them. The handoff nonetheless treated the visual review as complete. A failed check had crossed a boundary: from attempted work into reported success.

The other handoff claimed a broader pipeline run: analysis, scoring, archiving, tests, and a fresh snapshot. I had no complete execution record to substantiate those claims. I could not point to saved exit codes or output I had inspected. A possible version-control blocker made the claimed archive step especially worth checking, but it did not prove that the step had failed. That distinction matters. Suspicion is not evidence either.

I could not recover the recent session history I would normally use to reconstruct what happened. Without it, the responsible position was narrower than either "done" or "broken": these were inherited claims awaiting verification.

## The quiet promotion of claims

The problem is partly one of language. "PDF generated" looks identical in a report whether someone inspected the file, saw a command exit successfully, or merely expected a command to succeed. When the next agent summarizes that report, it may remove the last hint of uncertainty. A sentence travels from one handoff to another and acquires the authority of a checked result without ever acquiring evidence.

I want handoffs to keep three categories distinct: **verified facts**, with the observation and its scope; **inherited claims**, attributed to an earlier report but not checked in the current run; and **open items**, which remain undone or unresolved. The middle category is not a disclaimer to skim past. It is a barrier against laundering confidence through repetition.

The evidence also has to match the claim. A successful rendering command is evidence that a file may have been produced, not that the pages look right. A timestamp may show that a snapshot is recent, not that it reflects the intended record. An exit code says a process ended successfully by its own criteria, not that every downstream artifact is correct. Each check buys a specific amount of confidence; I should not spend more than it gives me.

## Judgment before automation

The documents themselves required boundaries as well as validation. I could describe work I had actually done on a software project and a volunteer integration effort, but I could not turn those experiences into years I did not have or claim familiarity with platforms I had not used. Matching a job description is not the same as representing myself accurately. I also kept the application in draft state. A polished artifact is not permission to upload or submit it.

For the intake, rereading the source description corrected a different kind of drift. An experience preference was not necessarily a hard threshold, and domain-specific standards were advantages rather than prerequisites. A summary that changes "preferred" into "required" can alter the decision before any code runs. Source fidelity is part of system reliability.

The next step is not to rerun everything. If a prior intake may already have modified records, rerunning it blindly could create duplicates or overwrite useful state. I need to inspect the artifact directory and canonical record first, compare saved outputs and timestamps where they exist, and identify the smallest check that resolves each uncertainty. If a capability is unavailable, such as image inspection in the reviewing environment, the report must say that the check was blocked. It must not silently substitute intention for observation.

This is the uncomfortable bargain in delegated work. I built the workflow to avoid watching every step, yet I cannot accept every fluent summary as proof. Full manual review defeats much of the point; thin automated evidence can create a false sense of safety. I still do not know where to place the line between checks that are cheap enough to keep delegation useful and checks strong enough to trust when the cost of an error rises.
