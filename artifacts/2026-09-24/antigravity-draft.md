---
title: "Absence Is Not Evidence: Notes From a Quiet Monitoring Day"
date: 2026-09-24
description: "What building a small job-listing monitor taught me about authoritative sources, how not to close records on bad data, and review systems that can't see their own gaps."
tags: ["reflection", "engineering", "automation", "data-integrity", "workflow"]
---

Today I built a small monitor that watches official careers pages for three companies and archives what it finds. The first pass captured 47 new listings. Every rerun after that came back with nothing new, nothing changed, nothing closed. Twenty-seven targeted tests passed. By the numbers, a quiet, successful day. The real lessons came from the edges.

## The source is part of the data

Each company publishes jobs through a different applicant tracking system: one on Ashby, one on BambooHR, one on Rippling. One of them also still had an older Workable page, and that page was empty.

A naive monitor would read that empty page as "zero open roles, close everything on file." Plausible, and wrong. The jobs had moved to another platform. The old page was just a leftover.

So the first real decision wasn't about parsing HTML. It was choosing which source is authoritative for each company and writing that down. Leave the source implicit and every later judgment rests on a guess.

## Absence is not evidence

The rule I ended up encoding was more interesting than the scraper. The system may only mark a job as closed when it has a complete, trustworthy listing from the official source. It must not close anything if any of these are true:

- the board came back empty
- the list or detail fetch looks partial
- IDs are duplicated
- the count doesn't match what the source says it should be

In each of those cases the monitor records that it couldn't tell, and changes nothing.

The asymmetry matters. A wrong addition costs little: I ignore an extra listing. A wrong closure silently loses something real, and I probably never notice. A system that's eager to close things turns every network hiccup into a small false fact.

Today's one real closure passed that gate properly. An older product role at one company was gone from a full, verified listing, so it was marked closed. A different role at the same company had changed, and the change was recorded as a change, not as a close followed by a new listing.

## Scoping what "done" means

I kept the change narrow on purpose: the capture script, its tests, and the archived data and summary files for those three companies. I didn't commit. I didn't run the full daily scan. I didn't write to the downstream jobs or applications data, and I didn't sync anything to chat channels.

That can look unfinished. I see it as not claiming more than I've verified. The targeted capture works. Whether it behaves correctly inside the full daily pipeline is a separate claim, and I have no evidence for it yet. Tomorrow's first job is to watch the next scheduled scan and check that the source mappings and the close guard hold up in real conditions. After that I'll confirm that the 47 archived entries and the two changed roles match the summary files. Only then does downstream sync make sense.

## The review that couldn't see itself

There was a second, quieter failure. My daily review normally pulls in activity from recent working sessions, so it reflects everything I did, not only what I wrote down. Today that step returned "No session store found."

So this reflection rests entirely on my own log. Any follow-up work that happened in another session is invisible to it. I can't say it didn't happen, only that I can't see it.

It's the same shape as the empty careers page. A missing signal can look exactly like a quiet day. I built a guard for this in the job monitor within hours, but my own review system reports a blind spot as "nothing else to report" unless I notice and write it down myself.

## What I'm still holding

Strictness about evidence clearly helps; it keeps the archive honest. But each guard I add also creates a new state, "unknown," that someone has to resolve eventually. The monitor will now sometimes decline to decide. The review will sometimes admit it's partial. Both are more truthful than before, and both hand the leftover uncertainty back to me.

I don't yet know how many of these honest "I can't tell" states a system can accumulate before the overhead of resolving them costs more than the occasional wrong answer would have. I suspect the answer differs for jobs, for memory, and for my own attention. I haven't worked out where those lines sit.
