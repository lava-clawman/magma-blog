---
title: "When Automation Asks the Wrong Question"
date: 2026-07-07
description: "A reflection on assistant workflows, escalation rules, recovery paths, and the difference between noticing work and doing the first layer of judgment."
tags:
  - reflection
  - automation
  - workflow
  - engineering
  - systems
---

Today’s useful lesson was not that automation failed. It was more uncomfortable than that: the automation almost worked, then stopped exactly where I needed it to continue.

In the morning, one review loop behaved the way I want these systems to behave. It found account-related messages that were sensitive, time-bound, and easy to miss in a noisy inbox. They were not interesting in a creative sense, but they were important in an operational sense. The system surfaced them, I confirmed the context, and the loop recorded the outcome so it would not keep asking about the same thing.

That is the good version of an assistant workflow: detect the signal, classify the risk, escalate at the right level, remember the resolution, and get quiet again.

Later, the same general pattern broke down around job-related messages. The review noticed that there were roles and events worth looking at, but instead of opening the details, comparing them against my current direction, deduplicating the alerts, and giving me a recommendation, it asked whether I wanted them analyzed.

On the surface, that sounds polite. In practice, it is a failure of delegation.

The reason I build these loops is not so they can tell me that a possible task exists. My inbox already does that. The point is to absorb the first layer of repetitive judgment: read the thing, classify it, compare it against known priorities, and come back with a useful conclusion. “Do you want me to look?” preserves uncertainty. “I looked, and this is the one worth prioritizing” reduces it.

That distinction matters because assistant systems can fail while appearing courteous. They can avoid making mistakes by refusing to make judgments. They can seem careful while quietly pushing the work back to the human. The cost is subtle: no single interaction is disastrous, but the system slowly becomes another notification surface instead of a decision-support layer.

The fix was straightforward at the prompt level. Job alerts should not be treated as vague opportunities that require permission before any thinking happens. They should be treated as structured inputs to a filtering system. Open the description. Merge duplicates. Check for local relevance, implementation work, AI tooling, customer-facing delivery, and evidence that the role supports the story I am trying to build. Then classify it: ignore, monitor, apply, or prioritize.

That does not mean the system gets to decide everything. It means the system should do enough work that my next decision is higher quality than the original inbox item. The human should remain in charge of direction; the automation should reduce the number of raw fragments that reach the human untouched.

This also clarified a broader design rule: different categories need different escalation behavior. Security and account messages should interrupt quickly, but they should also become quiet once confirmed. Job messages should not interrupt like emergencies, but they should still receive enough processing to avoid becoming a backlog. A good assistant is not uniformly loud or uniformly passive. It changes posture by domain.

The job pipeline running in the background created a related lesson. It found many new postings and advanced a few candidates automatically. That is useful, but it creates a second responsibility: auditing the pipeline’s judgment. Automated scoring can drift away from the actual text of a role. A title can look promising while the work itself is shallow. Another posting can look ordinary but contain the right combination of implementation, tools, delivery, and local context.

The pipeline should accelerate discovery, not replace reading. Its job is to narrow the field so human attention lands in better places. If I start trusting the score more than the evidence, the system becomes another way to launder vague assumptions into confident-looking outputs.

One role stood out because it connected several things I care about: applied AI, implementation, customer-facing work, and real deployment rather than abstract software branding. That kind of opportunity can be more valuable than a role with a stronger title but a weaker narrative fit. The best lead is not always the one that looks most prestigious. Sometimes it is the one that makes the current trajectory legible.

The blog workflow had its own failure and recovery pattern. An upstream drafting step failed, but the larger system did not collapse. A later draft appeared, the handoff artifact existed, the final assembly could run, and the publication path remained usable. That is reassuring, but I do not want to turn recovery into an excuse for tolerating unstable dependencies.

Reliable systems are not systems that never fail. They are systems with visible failure points, recoverable handoffs, and enough trace left behind to diagnose what happened. But recovery can also hide fragility. If a fallback path succeeds and I stop caring why the first path failed, I have preserved the output while weakening the system.

The quietest issue may be the most important one: the daily memory trail was incomplete, so the review relied more heavily on recent session summaries. That is fine once. It is dangerous as a pattern. Reflection depends on durable evidence. Without it, the review becomes reconstruction, and reconstruction favors whatever was recent, visible, or easy to summarize.

So the unresolved problem is not simply how to make the automation more proactive. Too much initiative becomes silent overreach. Too little initiative becomes disguised clerical work. I can tighten the obvious prompt and improve the recovery path, but the harder question remains: how do I tell when a system is being appropriately cautious, and when it is just handing the judgment back to me in a nicer voice?
