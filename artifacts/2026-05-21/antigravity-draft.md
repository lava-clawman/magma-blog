---
title: "When Your Systems Talk Past Each Other"
date: 2026-05-21
description: "A day of job applications, sync bugs, and the slow realization that automation without verification is just chaos with extra steps."
tags: ["reflection", "workflow", "job-search", "systems", "engineering"]
---

There is a particular kind of frustration reserved for the moment you discover that two systems you built to talk to each other have been quietly maintaining separate versions of the truth.

Today I found one of those gaps.

I had submitted a job application earlier in the week. The local pipeline database was updated correctly — status marked, application date recorded, materials path noted. Everything looked clean from my end. But when I went to check the public-facing job tracker I maintain on a forum board, the tag still read "reviewing." Not "submitted." The system had done half the job and declared victory.

The fix took ten minutes once I found it. The lesson is taking longer to absorb.

---

I've been running a semi-automated job search workflow for a while now. The architecture is roughly: a script scans listings and scores them against my profile, candidates above a threshold get pushed into a local pipeline, I do manual triage and generate application materials, and then a second sync script propagates status changes to the external tracker. Two distinct steps, two distinct scripts.

The problem is that the first step feels complete. Status updated, materials filed — the feedback loop closes. The second sync step requires a separate intentional action, and on a day when I'm processing multiple applications at once, that second action is exactly the kind of thing that slips.

What I did right today: I ran a dry-run before the live sync, which surfaced that a completely different application was also flagged for status update. That would have been a bad cross-contamination — updating the wrong listing. The dry-run pattern caught it. What I did wrong: I let the gap exist in the first place by not building the two-step sync into a single atomic action.

There's a principle in distributed systems about treating state updates as transactions — either both writes succeed, or neither does. I've been running my job search like an eventually consistent database, and today I got bitten by the lag.

---

The other thing worth writing down: I caught a visual error in a generated CV.

I'd run the document through the generation pipeline, confirmed the output file existed, and was ready to move on. But something made me open the PDF. First page, content overflowing the margin. Text running past the bottom. The kind of thing that looks fine in a raw text check and catastrophic in print.

I've been automating document generation for a while, and I've been treating "file exists" as a proxy for "file is correct." Those are not the same thing. File existence is a necessary condition, not a sufficient one. Visual documents need visual checks — at minimum a one-pass screenshot review before they leave the pipeline.

I compressed the objective section, tightened the bullet points, reexported. Fifteen minutes of work that would have been a silent embarrassment if I'd submitted the original.

---

There's a framing question I keep circling in how I present myself to potential employers. The easy narrative — the one that writes itself — is "AI-augmented developer." I use language models throughout my workflow, I build tooling around them, I can talk fluently about prompting and agents and context windows.

But that framing feels like it misses the actual value I bring to a team. What I care about is delivering working software in product contexts, understanding what the system needs to do before writing code, and using whatever tools — AI or otherwise — to get there without drama. The AI part is method, not identity.

The realization isn't new, but I keep having to re-land it. Every time I draft application materials, there's a pull toward leading with the novel thing, the thing that feels distinctive right now. And every time I slow down and think about what a team actually needs from a software engineer, the answer is more boring and more durable: someone who can be trusted to figure out what needs to be built, build it, and not make a mess.

I'm trying to make sure my materials reflect the second framing, not the first. I don't always succeed.

---

The thing I haven't resolved is the automation threshold question.

Today the scanning pipeline surfaced a handful of new candidates automatically — roles I wouldn't have found through manual search, some of them plausible fits. The automation is doing what I built it to do. But the pipeline now contains more candidates than I can meaningfully evaluate in a day, and the scoring heuristics I wrote are not a substitute for actual judgment about fit, culture, or strategic value to my visa situation.

At some point, more automation creates more work, not less. I keep adding inputs to the top of the funnel without reckoning with the finite throughput at the evaluation and application stages. The backlog grows. The scoring numbers become a false sense of having processed something.

I don't know where the right cutoff is. I'm not sure it's a static number. But I suspect I've optimized for the part that feels productive — finding and ranking listings — while underfitting the part that actually matters: deciding which three things to focus on tomorrow.
