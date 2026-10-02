---
title: "Done Is Not One State"
date: 2026-10-02
description: "I misreported a job pipeline step as complete because I let one visible state stand in for four. Here is what I changed in how I verify and report progress."
tags: ["reflection", "workflow", "verification", "automation", "judgment"]
---

Today I told myself something was finished, and it wasn't.

I run a small personal pipeline for tracking job openings. A scanner pulls new listings and archives them. Some get posted to a forum channel where I can browse them. A quick chat-based screen flags a few as worth a closer look, and those are formally added to a positions database with an analysis attached. Earlier I had reported that eight new listings were "in." Then I checked each forum post against the database. All eight posts existed, but three of the roles had never been added. People could see them, but the system didn't know they existed.

Nothing broke. The fix is three new entries and three analyses. What bothers me is how easy the mistake was. It was a wording error before it was a data error.

## Four states, one word

The pipeline has at least four distinct states:

1. **Archived**: the listing exists in raw storage.
2. **Posted**: a readable thread exists in the forum.
3. **Screened**: a conversational pass has flagged it as interesting.
4. **Ingested**: it has a linked record in the positions database, with an analysis.

Each one looks like progress and makes the next more likely. But they are different facts, and each has its own source of truth. When I said "done," I was looking at state 2 because it was the easiest to see, and I assumed states 3 and 4 had followed.

I suspect this happens in most multi-stage systems. The stage closest to a human interface feels the most real. A ticket moved to "Done," a deploy notification in chat, a green check on a pull request: each one is evidence of a single transition. It's tempting to read it as evidence of all of them.

The rule I wrote down is simple, and it costs time: **a status report names which state it's about and is checked against that state's own source of truth.** "Eight posted" and "eight ingested" are separate claims. Making the second claim means checking the database index, the pipeline links and the threads with their tags. It isn't enough to confirm that a post exists.

## The tidy explanation

While checking, I noticed that none of the eight posts had tags. Anyone filtering the forum by tag wouldn't have seen them. I wanted that to explain why they seemed to be missing. But I haven't checked which filters were active at the time, so it remains a possible cause and not a confirmed one.

Holding back here is harder than the original verification was. Once I've found one real defect, the next plausible one feels like it closes the case. That pull is a reason to check it.

## Scores are not judgment

Two scanning rounds brought in a few dozen listings. The automated analysis recommended a small handful. Several others, in product, engineering and business analysis, deserved a human look even though their keyword scores were ordinary. The reverse happens too: a high score can hide a mismatch in location, seniority or the actual work.

Keyword scoring is useful for triage, but it doesn't tell me whether a role fits. An automated score should decide what I read first, not what I ignore.

## A line the assistant doesn't cross

One application required creating an account on an employer's hiring portal. The assistant helping me could fill in nearly everything, but I set the password myself, in the site's own field. Credentials never go through a channel that keeps a transcript, however convenient that would be. So that application waits until I can do that one step by hand.

## What I'm changing

- Reports name the state (archived, posted, screened or ingested) and never say "done" on its own.
- Each claim is checked against the system that owns that state, not whichever system is in front of me.
- My notes keep confirmed causes separate from possible ones.
- Scores set reading order. They don't filter anything out.

## The part I haven't solved

All of this adds friction. Checking four sources of truth takes longer than the update itself, and part of why I automated the pipeline was to stop doing that kind of bookkeeping by hand. If every report needs an audit, the automation has mostly moved my work from doing things to checking them.

The obvious fix is a reconciliation job that compares forum threads against database records and flags gaps. But that job produces a report too. Eventually I'd read its summary and trust it, and I'd be back where I started this morning, letting a visible signal stand in for the facts behind it.

The regress has to stop somewhere, and where it stops will depend on judgment more than on verification. I'm not yet sure my judgment about when to stop checking is better than the mistake I made today.
