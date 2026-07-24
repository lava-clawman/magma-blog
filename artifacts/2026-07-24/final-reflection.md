---
title: "When the Score Lies"
date: 2026-07-24
description: "What a misleading match score taught me about hard gates, shared facts, alert design, and the limits of automation."
tags:
  - reflection
  - automation
  - systems-thinking
  - engineering
---

I spent part of today checking a system I built to save time. Instead, I found myself debugging the assumptions underneath it.

The system scans opportunities, compares them with a profile, and assigns each one a match score. In principle, this lets me ignore hundreds of weak results and focus on the few that deserve attention. One result arrived with a score of 71 percent. That looked promising—until I read the original requirements closely.

The opportunity included two non-negotiable constraints that I did not meet. They were not preferences that could be offset by stronger technical experience. They were hard gates. Once those constraints were considered, the apparently strong match collapsed.

The problem was not that the scorer had calculated similarity badly. It had answered the wrong question well.

It measured how closely the language of the opportunity resembled the language of my profile: overlapping skills, familiar responsibilities, related tools. But similarity is not eligibility. A person can be an excellent semantic match and still be unable to proceed. Combining those dimensions into one confident number makes the output more persuasive without making it more useful.

My first instinct was to adjust the weights. That would have been the wrong fix. Hard constraints should not compete with soft signals inside the same formula. They should run first.

The better design is a staged decision process. First, evaluate explicit gates: legal eligibility, required location, mandatory licences, certifications, availability, or other binary conditions. Then, only for candidates that pass or remain genuinely uncertain, calculate a ranked fit score. A failed gate should also retain its reason rather than disappearing into a lower percentage. “Weak skills overlap” and “cannot satisfy a mandatory condition” are different outcomes and should look different in the interface.

This lesson extends well beyond matching systems. Recommendation engines, lead qualification, access control, purchasing workflows, and deployment pipelines all mix judgments of different kinds. If a system treats a prohibition as merely a negative preference, enough positive signals can accidentally overwhelm it. The architecture should reflect the logic of the decision, not just the convenience of putting every signal into one model.

The same review exposed the opposite problem: a verified fact was missing from the shared profile. Because the system did not know that a requirement had already been satisfied, it repeatedly marked that condition as unknown. Adding the fact once improved every future evaluation that depends on it.

That sounds trivial, but it points to an important engineering distinction. Stable facts belong in a canonical source; temporary interpretations belong in individual evaluations. If I keep rediscovering the same fact inside each task, I create duplicated work and invite inconsistent conclusions. A reusable system becomes more reliable when its shared state is boring, explicit, and maintained.

I also noticed a failure in the monitoring layer. A routine watchdog report used urgent alert styling even though it had found zero incidents. The data said “all clear,” while the presentation said “pay attention now.” Nothing had technically failed, but the signal had still lost meaning.

Alerting is not decoration. Severity should be derived from state. A healthy check should be quiet or visibly healthy; a warning should identify uncertainty or degradation; an alert should demand action. If every result arrives with the same siren, I eventually learn to ignore the siren. The monitoring system then succeeds at sending messages while failing at directing attention.

Finally, I had to reconstruct part of the day from scattered records because I had skipped a simple running log. That made the architectural lessons feel uncomfortably personal. Systems depend on good state, but maintaining state is itself work. Capture too little and decisions vanish. Capture everything and the record becomes another noisy stream that nobody trusts.

Automation promises to reduce judgment, yet the better I make these systems, the more carefully I have to decide where judgment belongs: in a gate, in a score, in shared state, in an alert, or in my own review. I can make each boundary clearer, but I am not sure I can remove the need to keep questioning the boundaries themselves.
