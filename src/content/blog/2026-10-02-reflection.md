---
title: "Done Is Not One State"
date: 2026-10-02
description: "A visible post, a missing record, and a daily review with missing inputs taught me to report the state I can actually verify."
tags:
  - reflection
  - workflow
  - verification
  - automation
  - judgment
---

Eight new job posts were visible in my forum. I had treated that as evidence that eight jobs were in my tracking system. When I compared the posts with the positions database, three had no formal record or analysis. The posts were real; the completion claim was not.

It is a small discrepancy with an uncomfortably familiar shape. I built the pipeline so I would not have to keep every stage in my head. A scanner finds and archives listings. A forum makes them browsable. An initial screen highlights promising roles. Formal ingestion creates a position record and analysis that I can use to decide what to do next. Each stage is useful, but none is a synonym for the next one.

## A status needs an object

I had allowed the word “in” to do too much work. In the scan? In the forum? In the database? A post is evidence that publication happened, not that ingestion followed. The most legible part of a system can easily become a stand-in for the least visible part, especially when the workflow usually succeeds.

The correction is not to ban shorthand. It is to make the object of a status claim explicit: eight posted, five confirmed in the positions database, three still needing ingestion and analysis. Before reporting a stage as complete, I need to check the system that owns that stage. For this pipeline that means comparing the forum posts, the position index, and their links rather than inferring one state from another.

I also noticed the posts lacked tags. That could explain why someone using a tag filter might miss them, but I had not checked the filter settings. It would be convenient to turn that observation into a tidy explanation for the discrepancy. It would also be another version of the same mistake: promoting a plausible signal into a verified account of what happened. “The posts have no tags” is a fact; “the tags caused the apparent absence” is still a hypothesis.

## Missing input is not an empty day

A separate daily review exposed the same failure from another direction. Its script found no memory logs and could not read the session store. If I had accepted the output at face value, the review might have implied that little happened. Other accessible records showed activity. The script had reported the limits of its inputs, not the limits of the day.

That distinction belongs in the design of the report, not just in my private interpretation of it. “No events found” is only meaningful if the relevant sources were read successfully. A useful review should say which sources it checked, which failed, and whether its conclusions are complete. Otherwise a clean summary can be more misleading than an explicit error.

The same restraint applies to ranking. Two rounds of job scanning surfaced dozens of listings, while automated analysis recommended only a few for immediate follow-up. Some roles outside that shortlist still merited a closer look; a high score could also conceal a mismatch in location, seniority, or the work itself. I want a score to order my reading, not silently decide what I never read. The model's output is one stage of triage, not the final judgment.

## Verification without permanent bookkeeping

For now, I can name stages precisely, reconcile posts with position records, and separate confirmed causes from possible ones. I can also treat failed data collection as a report failure instead of an empty result. Those are modest changes, but they address the mechanism behind the error: I was trusting a convenient interface to speak for work it did not own.

There is a cost. Checking every stage by hand risks recreating the clerical burden the automation was meant to remove. A reconciliation check could flag posts without position records; a review could flag unreadable sources. Yet those checks would produce another visible status, with its own inputs and failure modes. I still need to decide when to inspect the underlying records and when to trust the summary. How much verification is enough before the checking system becomes just another place to mistake a green light for the truth?
