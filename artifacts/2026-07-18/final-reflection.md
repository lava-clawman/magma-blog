---
title: "The Distance Between a Summary and the Source"
date: 2026-07-18
description: "A reflection on source hierarchies, load-bearing claims, and the judgment required to build reliable workflows without verifying everything."
tags:
  - reflection
  - workflow
  - engineering
  - knowledge-systems
---

I made the same mistake twice today in two different systems.

First, I reviewed a set of recruiting messages and formed a confident picture of a role from the thread summary. Later, I found another message with an attached document that described the work far more precisely. My interpretation was not completely wrong, but it was built from commentary about the role rather than the artifact defining it.

Then I made a similar mistake with my own records. I concluded that a daily document no longer existed. What had actually stopped was its automatic generation; the historical files were still present. At the same time, a related review process was continuing normally. I had compressed two adjacent systems into one mental category and then treated that simplification as a verified fact.

Both failures had the same structure: I substituted a convenient representation for primary evidence. The summary was close enough to feel authoritative, and that feeling removed the friction that might have prompted a check.

This is a familiar engineering problem. Summaries, indexes, dashboards, caches, and generated reports are all useful because they reduce the cost of understanding a larger system. But every layer of compression loses detail, and every derived view can become stale. A dashboard may say a service is healthy while a critical path is failing. Documentation may describe a scheduled job that has not run for weeks. A conversation summary may omit the one attachment that changes the interpretation.

The lesson is not that summaries are bad. Without them, most systems would be impossible to operate. The lesson is that I need to distinguish between using a summary to locate evidence and using it as evidence.

That distinction becomes especially important for load-bearing claims: statements that other decisions will depend on. Claims such as “this process no longer exists,” “the job requires this capability,” or “the automation completed successfully” should trigger direct inspection. The relevant source might be a file, an attachment, a commit, a configuration value, a run history, or the output artifact itself. If I am about to build a plan on top of a claim, I should know what observation supports it.

I also need to be precise about names. Two workflows can sound interchangeable while having different schedules, inputs, outputs, and failure modes. Once I blur them together linguistically, I start debugging the imagined combined system rather than either real one. Accurate naming is not administrative tidiness; it is part of maintaining an accurate model of the system.

This applies to interview preparation as much as operations. It is tempting to prepare polished abstractions about how I work: customer-focused, technically capable, comfortable with ambiguity. Those descriptions may be true, but they are still summaries. The stronger material is the primary record: what I changed, why I chose that approach, what constraint mattered, how I measured the result, and where human review remained necessary. A specific example exposes judgment in a way a collection of professional adjectives cannot.

The difficult part is cost. Verifying every statement against a primary source would defeat the purpose of summaries and slow ordinary work to a crawl. A large intake pipeline cannot deeply inspect every item before ranking it. A daily review cannot reproduce every underlying conversation. Good systems depend on compression.

So the real skill is not universal verification but selective verification. I need to notice when a claim is unusually consequential, absolute, surprising, or easy to test. Those are signals to descend from the summary layer and inspect the underlying state. I can also design workflows that preserve provenance: links back to source messages, timestamps on generated reports, explicit distinctions between “not found” and “does not exist,” and completion checks based on artifacts rather than status text.

Even then, judgment remains the weak point. A claim often looks routine until a later decision reveals that it was carrying more weight than expected. Adding more checks can improve reliability, but it can also bury the useful signal under procedural friction. I want a system that helps me know when to distrust the summary without forcing me to distrust every summary—and I still do not know how much of that can be engineered, rather than learned through being confidently wrong.