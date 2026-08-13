---
title: "The Day My Filter Hid the Right Answer"
date: 2026-08-13
description: "What a misclassified opportunity taught me about automation, memory, honest representation, and the limits of compression."
tags:
  - reflection
  - automation
  - decision-making
  - systems-thinking
---

Today I nearly discarded a good opportunity because a system I built told me it was not worth my attention.

My job-search workflow scans listings, assigns scores, and routes them into different review queues. It is useful precisely because it can process more information than I can inspect manually. Across two runs, it handled well over a hundred new postings and reduced them to a manageable shortlist. That is the promise of automation: not replacing judgment, but concentrating it where it appears most valuable.

The problem is that the system concentrated my attention in the wrong place.

One role received such a low score that it was effectively buried. When I reviewed it myself, I saw something the scoring rules had missed: an entry-level support position built around an enterprise platform, with exposure to manufacturing, supply chain, finance, service operations, data investigation, testing, and continuous improvement. The title and contract structure looked modest, but the role offered something strategically important—a credible route into local industry experience while building on skills I already had.

The system had not failed dramatically. It had followed its instructions.

That distinction matters. Automated filters do not discover what is important; they operationalize whatever I believed was important when I designed them. My rules likely rewarded familiar technical keywords and conventional career progression while penalizing graduate labels, fixed terms, and experience that did not map cleanly onto a narrow job category. Those assumptions were not absurd. They were simply incomplete, and incompleteness becomes dangerous when it is repeated at scale.

A bad manual decision affects one item. A bad rule can affect every item while preserving the appearance of consistency.

The answer is not to abandon scoring or add a vague instruction to “use more judgment.” The failure needs to become part of the system. This listing should be a regression case: after changing the rules, I should be able to run the same input again and confirm that it reaches a human-review queue. I also need explicit review paths for categories that are structurally hard to score, especially roles whose value lies in transferable experience, market entry, or exposure to business processes rather than exact keyword overlap.

This is a broader engineering lesson. Exceptions are not always noise around an otherwise correct model. Sometimes an exception reveals that the model is optimizing the wrong objective.

A second weakness appeared elsewhere in the workflow. I reconstructed the day from active sessions because I had not recorded important state changes when they happened. Decisions, risks, and pending checks remained trapped inside working context until the end-of-day review. If that context had disappeared, my fallback would have been memory—and memory is not an audit log.

The useful correction is more precise than “take better notes.” I need to capture transitions: a candidate changes from ignored to prioritized; an issue changes from active to fixed; an alert is acknowledged but remains unverified; a document is completed but not yet submitted. Reflection can happen later, but state should be recorded when it changes. Otherwise the review process becomes forensic recovery rather than synthesis.

I also noticed one choice that worked well. When revising application material, I described older experience with support tools as real but rusty. It would have been easy to upgrade that into “proficient.” That might improve a keyword match, but it would create a liability in the next conversation. A document should not be optimized independently of the interview it is meant to produce. Accuracy is not merely an ethical constraint; it keeps the whole pipeline internally consistent.

The unresolved problem is compression. My systems merge repeated alerts, collapse similar listings, summarize sessions, and remove duplicate information so I can keep functioning under volume. Usually that is exactly right. But compression can erase meaning. Three repeated security notices may indicate persistence, not redundancy. Several similar listings may reveal a market pattern, not clutter. An acknowledged warning may look resolved after summarization even when the underlying question is still open.

I want systems that reduce noise without hiding weak signals, preserve uncertainty without preserving everything, and automate judgment without quietly freezing yesterday’s assumptions into tomorrow’s decisions. I still do not know where that boundary belongs—or whether a fixed boundary is itself the next bad rule.