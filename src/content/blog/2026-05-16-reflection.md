---
title: "The Rule Was There. The Gate Wasn't."
date: 2026-05-16
description: "A reflection on turning remembered workflow rules into enforced gates, and why evidence matters more than intent in agent systems."
tags:
  - reflection
  - workflow
  - ai-agents
  - systems-thinking
  - engineering
---

Somewhere in the system, the rule already existed: before running the email review workflow, check the local state and the recent log. It had been written down after a previous mistake. The instruction was not missing. The intent was not ambiguous.

And still, the workflow repeated itself.

The agent surfaced emails that had already been processed and asked questions that had already been asked. That made the failure more interesting than a simple oversight. This was not a case where the system lacked a rule. It was a case where the rule had no structural force.

The rule was there. The gate was not.

That distinction has been bothering me in a useful way. A documented constraint feels like engineering, but often it is only advice. It can guide behavior when the agent happens to attend to it. It can improve the odds of the right thing happening. But it does not, by itself, create a precondition. It does not block the workflow from continuing when the necessary state has not been read.

A gate is different. A gate changes the shape of execution. It says: this step must happen before the next step can happen. If the state is unavailable, stop. If the item is already handled, stop. If the evidence is missing, do not pretend the process completed.

The fix was to move the email review process out of a growing pile of general instructions and into a dedicated workflow. The main agent should not carry every classification rule, deduplication policy, reply-handling convention, and follow-up heuristic in its general operating context. That is too much weight for a broad prompt to carry reliably. The main agent should route the work. The workflow should do the work.

That sounds like ordinary software design because it is. A skill, in this case, is less like a better paragraph of instructions and more like a function boundary. It gives the process a smaller surface area, a predictable entry point, and a first step that can be made explicit: read the state, read the log, decide whether this item is new, and only then continue.

The same pattern showed up somewhere else: job scanning. The search process had been relying too heavily on traditional job titles. It found roles labeled in familiar ways, but missed listings whose titles used a different vocabulary: business systems, application support, automation, low-code platforms, AI tooling, internal operations. The work was relevant, but the labels were not the labels the scanner expected.

That was another representation failure. The goal was clear: find roles that matched the actual capability profile. But the query mechanism was searching for a narrow vocabulary of titles rather than the signals of the work itself. A title is an organizational wrapper. Capability keywords are often closer to the job's real substance.

So the search strategy needed the same kind of correction as the email workflow. It had to move closer to ground truth. Search less for what I assume the thing will be called, and more for what the thing actually contains. Power Platform, SharePoint, automation, application support, business systems, internal tools: these terms may not look as clean as a job title, but they carry more signal for the roles that matter.

Both failures have the same shape. The system had a goal. The goal was represented somewhere. But the representation was not connected tightly enough to reality. In one case, a rule did not bind to execution. In the other, a query did not bind to the actual language of the market.

There was a smaller lesson too, and maybe a more practical one: do not report completion without an artifact. One generation process stalled with no real output. The correct move was not to narrate progress into existence, but to check for the file. If the file is not there, the task is not done. That seems obvious, but a lot of automation failure comes from letting the last attempted action stand in for evidence.

I want more of my systems to behave that way. Less confidence from intention. More confidence from inspected state. Less "the rule says this should happen." More "the workflow cannot proceed unless this has happened."

But I do not think this resolves cleanly. Every hard gate sits on top of something softer: an invocation path, a runtime, a human decision about what to formalize and what to leave flexible. If everything becomes a gate, the system gets brittle. If too little becomes a gate, it drifts.

The unresolved question is where judgment belongs. Some parts of a workflow should be deterministic enough to fail loudly. Some parts need room for interpretation. I can see the next layer to harden, but I can also see the cost of hardening everything. The tension is still there: build enough structure that the system does not silently repeat its mistakes, without turning every useful ambiguity into a locked door.
