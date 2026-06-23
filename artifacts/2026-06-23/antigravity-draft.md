---
title: "The Metadata Is Not the Source of Truth"
date: 2026-06-23
description: "On a day spent pushing a job search system forward, three quiet system failures taught me the same lesson: the label on the box is not the contents."
tags: ["reflection", "systems-thinking", "workflow", "job-search", "second-brain"]
---

There is a particular kind of mistake I keep making, and I only notice it in retrospect. It is the mistake of trusting the summary over the document, the index entry over the primary source, the outer metadata over the inner text.

Today I was working through a batch of job listings, pushing them through a pipeline — capture, triage, analyze, generate materials. One listing showed a location I considered viable. I had already begun mentally preparing materials before I opened the actual job description. When I did, the body of the document told a different story: a different city, explicit residency requirements that would disqualify me. All that mental prep was wasted on a mismatch between what the aggregator displayed and what the employer actually wrote.

The aggregator was not lying. It was summarizing. And summaries compress, and compression loses edge cases, and edge cases in job applications are often the deciding factor.

I have now added a rule to my pipeline: before any material generation begins, the raw job description must be read for location, eligibility, and visa requirements — regardless of what the outer metadata says. This is not a complicated rule. It is the kind of rule that feels obvious after you have violated it once with real cost attached.

---

The second failure was subtler and more structural. A job I was interested in had been captured by my archiving process but had not made it into my active analysis queue. It existed in the system — technically — in a state I can only describe as *limbo*: captured but not processed, present but not actionable. The label on its record said something like "review then analyze," which is a perfectly reasonable intermediate state for data to be in. The problem is that intermediate states are where things go to be forgotten.

I have been building this pipeline incrementally over several weeks, and the gap between the archive and the active queue has existed almost from the beginning. I kept meaning to build a proper promotion step. Instead I left a label that implied someone would come back and do something. That someone was me. And I did not come back.

The lesson here is not "don't use intermediate states." Intermediate states are necessary — not everything can be immediately evaluated, and a system that demands it will stall. The lesson is that intermediate states need either a scheduled revisit or a clear promotion criterion, and they need that from the moment they are created, not retrofitted later. A state called `captured_review` that has no attached trigger is just a graveyard with a hopeful name.

---

The third failure was about signals crossing system boundaries. I have an automated email review process that summarizes incoming mail and surfaces action items. I also have a separate job-tracking system that records application status — submitted, viewed, rejected, interview scheduled, and so on. These two systems had been running in parallel, politely ignoring each other.

The consequence: when an employer opened a submitted application and a notification email arrived, that signal landed in the email log and went no further. The position record stayed marked `submitted`. Days could pass before I realized the status had changed, if I realized at all.

The fix is conceptually simple — emails about application status should trigger updates to position records — but implementing it across two systems that were not designed to talk to each other is not trivial. I have written the rule now; the harder part is verifying that it actually executes when the next relevant email arrives. Rules written in documentation and rules operating in production are different things.

---

Underneath all three of these is something I have been thinking about more abstractly in the context of agent systems and second-brain design: the difference between *appending* information and *projecting* it.

A naive approach to memory is to keep adding. Log everything, append every event, build the transcript. This feels thorough. What it actually produces is an ever-growing pile in which recent things are accessible and older things are invisible in practice even if present in theory.

A more mature approach treats context as a *projection* — a deliberate selection of what is currently load-bearing, structured for use, not for completeness. Durable facts live in one place. Current state lives in another. The event log exists but is not the primary interface.

I have been moving my systems in this direction. The job pipeline, the email review, the second brain. Each of them benefits from the same design instinct: separate what happened from what matters now, and make the latter easy to reach.

But here is where I am genuinely uncertain: every projection involves a choice about what to include, and those choices carry risk. The aggregator that showed me the wrong city was also doing a projection — it showed what it calculated was most relevant. It was wrong in exactly the case that mattered.

How do I build systems that compress intelligently without compressing away the thing that would have changed the decision? I do not have a satisfying answer. I keep running into the edge of it.
