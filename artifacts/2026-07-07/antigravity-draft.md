---
title: "When Automation Asks the Wrong Question"
date: 2026-07-07
description: "A reflection on email triage, job pipelines, recovery paths, and the difference between automation that reports work and automation that does the first layer of judgment."
tags: ["reflection", "automation", "workflow", "engineering", "systems"]
---

Today’s main lesson was not that automation failed. It was that automation almost worked, but stopped one step too early.

In the morning, the email review system did what I want it to do. It noticed two account-related messages that needed attention: one about a tax certification deadline and another about a new device login. These were the right kind of alerts to surface immediately. They were security- and account-sensitive, time-bound, and not something I wanted buried in a mailbox. After I confirmed the actions were expected, the system recorded them as handled and suppressed duplicate reminders.

That is the good version of automation: detect, classify, escalate, and then remember the outcome.

The weaker version appeared later in the day. The afternoon email review noticed job-related messages and event listings, but instead of opening the job details, deduplicating the alerts, and giving me a ranked recommendation, it asked whether I wanted them analyzed. That sounds polite, but it is actually a workflow failure. The whole point of the system is to absorb the first layer of repetitive judgment. If it simply notices a possible task and hands the decision back to me, it has converted one inbox problem into another inbox problem.

I had already clarified this rule before: job alerts are not supposed to be treated as vague opportunities requiring permission. They should be treated as inputs to a filtering system. Open the description. Compare it against my current direction. Look for local relevance, implementation work, AI tooling, customer-facing delivery, and evidence that the role can support a builder narrative. Then give me a recommendation: ignore, monitor, apply, or prioritize.

That distinction feels small, but it is important. “Do you want me to look?” is a question that preserves uncertainty. “I looked, and this is the best candidate” is a judgment that reduces it.

The fix was straightforward: tighten the prompt at the execution layer. Job emails, alerts, and batch postings should no longer default to asking for permission. The system should perform the smallest useful analysis first, merge duplicate pushes, and report a conclusion with priority and next action. There is still room for me to override it, but the default should be movement, not hesitation.

This also clarified a broader pattern in my workflow design. Different categories of messages need different escalation rules. Security and account messages should interrupt quickly, but then become quiet once confirmed. Job messages should not interrupt as emergencies, but they should still receive enough processing to avoid becoming a backlog. A good assistant is not uniformly loud or uniformly passive. It changes behavior by category.

The job pipeline itself continued to run in the background, discovering a large number of new postings and automatically advancing a handful of candidates. That is useful, but it creates a second responsibility: auditing the pipeline’s judgment. Automated scoring can drift away from the actual text of a role. A posting may look promising by title but be weak in substance. Another may seem ordinary but contain exactly the right combination of implementation, tooling, customer delivery, and local context. The pipeline should accelerate discovery, not replace reading.

One role emerged as the strongest lead today: a local AI implementation position with a customer-facing angle. It connects several threads I care about—AI tools, real deployment, early-career accessibility, and the ability to translate systems into business outcomes. That kind of role is more valuable to me than a generic software position with a prestigious title but a weaker story. The lesson is that the best opportunity is not always the highest-scoring one. It is the one that lets my current trajectory make sense.

The blog automation also had a useful failure. The first draft stage failed because an upstream CLI command did not complete correctly. But the system recovered: a later draft was generated, the handoff artifact was produced, the final assembly ran, and the post was published. That matters because reliable systems are not systems that never fail. Reliable systems are systems with visible failure points and recovery paths.

Still, I do not want to romanticize recovery too much. A fallback path can hide an unstable dependency if I stop investigating the original failure. The right posture is to be grateful the pipeline completed, while preserving the evidence needed to debug the weak link later. Recovery is not a substitute for diagnosis.

The most concerning observation was quieter: the daily memory log did not appear to be generated, so the review had to rely on recent session summaries. That is acceptable once, but dangerous as a habit. Daily review works best when it has a durable event trail. Without that, it becomes a reconstruction exercise, and reconstruction favors whatever was most recent, most visible, or easiest to summarize.

Today left me thinking about the boundary between automation and judgment. I do not want systems that merely notify me of every possible concern. I also do not want systems that silently decide too much. The hard part is designing the middle layer: enough initiative to reduce cognitive load, enough memory to avoid repetition, enough transparency to audit mistakes, and enough restraint to keep me in charge.

I fixed the obvious prompt issue today. But I am not sure I have solved the deeper problem: how to tell when an assistant is being appropriately cautious, and when it is quietly pushing the work back onto me.
