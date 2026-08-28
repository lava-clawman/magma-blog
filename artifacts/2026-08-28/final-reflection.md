---
title: "When a Metric Arrives Before Its Story"
date: 2026-08-28
description: "A reflection on alert fatigue, evidence-first automation, and the limits of using better systems to compensate for imperfect judgment."
tags:
  - reflection
  - automation
  - systems
  - judgment
---

A dashboard told me today that automated traffic had climbed to 92% of all requests. The number looked urgent. My first impulse was to tighten a rule, upgrade protection, or otherwise prove that I was responding. Fortunately, a slower question interrupted me: 92% of what, coming from where, doing what, and at what cost?

The dashboard could not answer. It had given me a ratio without request paths, sources, user agents, volume, or evidence of harm. The metric was real, but its meaning was still undecided.

I keep running into this distinction in the systems I build for myself. I automate email review, job discovery, publishing, and operational checks because I want routine work to happen consistently. Most days, these systems do exactly that. They process ordinary events, move information into the right place, and stay out of the way.

But automation does more than execute work. It also decides what reaches my attention and how that information is framed. That is where a small design choice can quietly become a judgment problem.

One of my monitoring routines produces a daily report. Even when every counter is zero—no failures, no delivery problems, no cleanup required—it presents the report as an alert. The facts are accurate, but the label is wrong. “Alert: nothing happened” sounds harmless until it repeats often enough to train me to ignore the word *alert*.

That is not merely a wording issue. It is a feedback-system failure. A monitor should help me distinguish normal operation from a condition requiring investigation or a decision. If every status is urgent, urgency loses information. The system then optimizes for producing notifications rather than preserving my ability to respond well.

The traffic metric exposed the inverse problem. Instead of making a normal event sound urgent, it made an ambiguous event look actionable. A percentage arrived before the evidence needed to interpret it. Reacting immediately would have meant allowing the presentation layer to choose the response.

I am starting to think that useful automation needs an evidence contract. A signal should carry enough context for the next decision: what changed, compared with what baseline, where the change came from, what impact is visible, and what action—if any—is justified. When that context is unavailable, the system should say so explicitly. “Needs investigation” is a legitimate state. It is better than manufacturing certainty from a dramatic number.

The same lesson appeared in a different workflow. Automated scans collected a large batch of opportunities and scored a smaller group as worth reviewing. That reduced the search space, but it did not produce a final shortlist. A score based on keywords and titles cannot reliably judge practical fit, seniority, location constraints, or whether the underlying work is actually appealing.

Without a human gate, the automation simply converts an infinite external stream into a growing internal queue. The list looks like progress because it is filtered and ranked, but every item still represents deferred judgment. If the queue grows faster than I can examine it, the system has not saved attention; it has packaged attention debt more neatly.

I also noticed a weakness outside the automations themselves: I had not recorded important decisions as they happened. The day’s review had to be reconstructed from session history. That worked, but reconstruction preserves outcomes better than reasoning. Weeks later, “I chose not to act” can look like neglect unless I also retain the evidence and trade-off that made restraint the deliberate choice.

A running decision log is therefore not clerical overhead. It is part of the system’s observability. Logs should capture not only what an automation did, but where I intervened, what I declined to do, and why. Otherwise I can inspect the machinery while losing sight of the judgment that governed it.

Nothing broke today. That is precisely why these problems were visible. Quiet days reveal whether a system respects attention, whether labels match reality, and whether queues represent genuine progress or merely organized uncertainty.

I can respond by engineering richer signals, stricter alert states, smaller queues, and better decision logs. Or I can accept that no system will supply enough context to remove the need for a deliberate pause. I suspect the durable answer requires both, but I still do not know where better instrumentation ends and the harder work of better judgment begins.