---
title: "When Done Does Not Stick"
date: 2026-08-19
description: "False alarms revealed a deeper systems problem: decisions that live only in conversations, and automation that reports activity instead of durable state."
tags:
  - reflection
  - workflow
  - automation
  - systems
---

I run a small collection of automations that scan for opportunities, watch for failures, and summarize my inbox. They are useful, but yesterday’s review exposed a recurring weakness: my systems are much better at remembering that something happened than remembering what its current status is.

Several items that had already been resolved returned as urgent work. A deployment had been confirmed as successful. A migration had completed as expected. Security notifications had been checked and dismissed. Yet the next review presented them as open problems. Nothing had broken. The failure was that the decision—“this is done” or “this does not require follow-up”—existed only in a conversation or a previous summary. It had not been written into a durable state source that the automation consulted before producing its report.

That distinction matters more than it first appears. The immediate cost of a false reminder is only a few minutes of rechecking. The larger cost is a gradual loss of trust. Each time a system re-raises a closed issue, I become more likely to skim the next alert. Eventually, a genuinely important signal arrives inside a stream I have trained myself to ignore. A monitoring system that produces noise faster than it produces useful attention is not really monitoring me; it is competing with everything else for the same limited focus.

The alerting side showed the same problem in a different form. A watchdog sent an urgent notification even though every tracked metric was zero: no failures, no abnormal events, and no delivery errors. The template treated “nothing happened” and “something is wrong” as equivalent states. But zero is often evidence that the system is working. If a normal cycle and an incident are rendered with the same urgency, the urgency eventually means nothing.

Both failures point to a common engineering lesson: activity is not state. It is easy to record that a job ran, an email was checked, or a scan completed. It is harder to answer the question that actually matters: given everything known now, is this still a problem? My automations were optimized for reporting activity while quietly implying that they understood state. Yesterday’s review showed the cost of that shortcut.

The remedy is not a more elaborate summary. It is a clearer source of truth. Decisions that affect future work need a structured home: open, resolved, waiting, dismissed, or superseded. That state must be updated rather than endlessly appended to a stream of historical observations. Before an automation raises an item, it should check that source and apply the latest decision. Likewise, alerts should distinguish failures from healthy silence, and thresholds should reflect meaningful change rather than merely the end of another polling cycle.

There is also a human part to this design. I had not kept a running log of decisions, so reconstructing the day required piecing together conversation fragments and memory. That is the manual version of the same failure. If I record a decision when it is made, the system—and my future self—has something concrete to rely on. If I postpone the entry until a review, I turn a small act of documentation into an investigation.

The challenge is that every fix introduces another maintenance obligation. A status source can drift. A log can be forgotten. A carefully designed alert can become outdated as the surrounding workflow changes. It is tempting to solve unreliable memory by adding more layers of memory, but that can create a new failure mode: a system whose upkeep costs more attention than it saves.

So I am left with an unresolved design question. How much explicit state is enough to make automation trustworthy, and when does the machinery for preserving that state become another source of noise? I want systems that remember what I decided without requiring me to maintain a second job just to keep them honest. I do not yet know where that boundary is.