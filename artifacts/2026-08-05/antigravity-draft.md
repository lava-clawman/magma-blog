---
title: "When the Scoring Rule Hides the Opportunity"
date: 2026-08-05
description: "Notes from a day of job-search tooling failures: a location bias that buried a strong match, a deduplication bug that resurrected a closed task, and an alert that cried wolf on an all-green day."
tags: ["reflection", "job-search", "systems", "engineering-judgment"]
---

I spent part of today fixing a bug in my own judgment, encoded in software.

A few days ago, a job posting came through my scanning pipeline. It matched a real skill set — HTML/CSS/JS, a CMS platform, Git, hosting, DNS, basic server administration — the kind of practical, unglamorous stack that actually predicts whether someone can do the job. The pipeline scored it low and archived it. Not because the skills didn't match, but because of how the location and title were weighted. It sat there, correctly filed under "not worth reviewing," for days.

I only found it because I went back and looked by hand.

That's the part that bothers me. The system didn't fail loudly. It failed quietly, confidently, and correctly according to its own rules. A scoring rule doesn't know it's wrong — it just returns a number, and the number becomes the ground truth unless someone questions it. The bug wasn't in the code; it was in a weighting decision I made earlier without enough evidence, and it took a real opportunity slipping past to expose it.

The fix was straightforward: reduce the penalty on location mismatch, since a role that's a strong skills match is worth a human look regardless of where it's based. But the more interesting fix was procedural — I now have to go back through everything the old weighting might have buried. A silent scoring error doesn't just cost you the one case you caught. It costs you an unknown number of cases you didn't.

The second failure was smaller but more embarrassing: a job I had already submitted an application for showed up in a later review labeled "preparing to apply," as if the work hadn't happened yet. The root cause was boring — no single source of truth for application status, so each review pass re-derived the state from whatever context was in front of it instead of checking a canonical record. Chat history is not a database. If a decision matters — an application was submitted, a candidate was rejected, a scoring rule changed — it needs to live somewhere durable and be treated as the only fact that counts, not re-inferred every time someone looks at the problem fresh.

The third thing was smaller still, but it's the one I keep turning over. A monitoring job I have watching a pipeline sent an alert today. Red banner, urgent formatting, the whole visual language of "something is wrong." I opened it. Zero incidents. Zero errors. Zero failed sends. Every number was clean. The alert had fired because the report was generated on a schedule, not because anything happened.

That's a cheap mistake to make and an expensive one to leave uncorrected. The first time you get a red alert for nothing, you check it. The fifth time, you glance at it. The tenth time, you stop opening it at all — and that's the day something real happens inside a report styled exactly like all the false alarms before it. Alerting systems don't get to spend urgency carelessly; urgency is a limited resource that only works if it's rare and earned. An all-clear report should look boring. Looking alarming when nothing is wrong isn't a safety margin, it's a withdrawal against the one time you'll actually need someone to react fast.

None of these three things were hard to fix once I saw them. What connects them is that they're all instances of the same failure mode: a system quietly substituting its own confident, self-consistent output for a check against reality. The scoring rule was confident and wrong. The status field was confident and stale. The alert was confident and empty. In each case, the fix wasn't "add more automation" — it was "add a moment where a human re-verifies against source of truth, on a schedule, regardless of whether anything looks broken."

I don't know how to size that moment correctly. Too little verification and you drift the way the scoring rule drifted, silently, for days. Too much and you're back to doing everything by hand, which was the whole reason you built the pipeline. I don't have a rule yet for how often "trust the system" should flip to "go check by hand" — just a growing list of days like today where I found out the hard way that I'd waited too long.
