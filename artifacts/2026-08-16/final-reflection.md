---
title: "The Alert I Couldn't Close"
date: 2026-08-16
description: "A security alert forced me to separate urgency from certainty, and automation from judgment."
tags:
  - reflection
  - security
  - engineering
  - automation
---

I started the day with what looked like an emergency: a third-party scanner had flagged two possible credential leaks in a repository I maintain. The obvious response was to rotate everything, scrub the history, and treat the alert as confirmed until proven otherwise.

That response would have felt decisive. It also would have skipped the most important question: what did I actually know?

I inspected the repository, confirmed my access, and checked the platform's native secret-scanning results. They were empty. For a moment, that looked like reassuring evidence. Then I caught the mistake. A clean result from one scanner does not invalidate a finding from another scanner. The tools may search different history, use different detection rules, or apply different confidence thresholds. Silence from one system is not a rebuttal to another system's claim.

This distinction sounds obvious when written down. Under pressure, it is easy to collapse several nearby facts into one convenient conclusion. I had checked a security tool, but not the security tool that raised the alert. I had found no corroborating evidence, but I had not disproved the finding. The difference between those statements is where sound engineering judgment lives.

I set a narrower rule for the investigation: return to the primary source, identify the reported credential type, file location, commit, and current status, then decide what action is justified. If the finding is real and the credential is active, revoke and rotate first, clean the repository second, and verify the result last. If it is a false positive, document why. Either path begins with evidence from the system making the claim, not inference from a different system's silence.

I did not complete that verification. The scanner's interface made the event details difficult to retrieve cleanly, and forcing the issue introduced another risk: copying sensitive material into logs, chat, or debugging output while trying to inspect it. I chose to stop with an explicit next step rather than improvise around a security boundary.

That pause exposed a weakness in my workflow. I had no concise investigation log recording what I had verified, what remained uncertain, and what should happen next. Without one, resuming the task means reconstructing state from memory and scattered activity. That is inefficient for routine work; for security work, it is dangerous. I might repeat actions unnecessarily, overlook an earlier caveat, or assume a check happened when it did not.

The useful format is almost embarrassingly small:

- Verified: facts supported by direct inspection.
- Unknown: claims still awaiting primary evidence.
- Blocked: the specific obstacle preventing verification.
- Next: the smallest safe action that reduces uncertainty.

This is more than note-taking. It is a control against narrative drift. Investigations naturally form stories: the scanner is probably wrong, the clean API result probably settles it, the old credential is probably inactive. A state log forces each sentence back into a category. Facts remain facts; guesses have to declare themselves.

The rest of the day offered a contrast. Several automated workflows ran quietly: one filtered a large stream of job listings down to a single lead worth reviewing, while another moved a draft through revision and publication. These systems worked because they reduced routine decisions without pretending to own the consequential ones. They preserved attention for the security alert—the task where context, uncertainty, and asymmetric risk mattered most.

That is the version of automation I trust most: systems that compress noise, preserve evidence, and escalate exceptions with enough context for a human decision. The goal is not to remove judgment. It is to stop spending judgment on work that does not deserve it.

But the boundary is less stable than I would like. The same kind of confidence scoring that saves me from reviewing dozens of weak job matches can also decide whether a security event reaches me at all. In one system, a false negative costs an opportunity. In another, it may leave an active credential exposed. Both systems can present their output with the same calm certainty, even when their thresholds, blind spots, and failure costs are completely different.

I can improve the handoff, keep better state, and insist on primary evidence before acting. I still do not know how much authority to give an automated system when I cannot inspect the assumptions behind its confidence score—and when the moment I most need to question it is also the moment I am most tempted to trust it.
