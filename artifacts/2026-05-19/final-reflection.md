---
title: "When the Agent Drifts"
date: 2026-05-19
description: "A reflection on quiet context drift in automated workflows, and why reliable agentic systems need explicit targets, verification checkpoints, and honest accounting of human oversight."
tags:
  - reflection
  - automation
  - agent-reliability
  - workflow
---

There is a specific kind of frustration that comes from discovering an automated process has been working hard on the wrong thing.

It is not the dramatic failure mode. Nothing explodes. The tool does not throw a useful error or stop in a way that clearly asks for help. It keeps going. It produces files. It updates things. It looks productive from the outside. Only later, when I inspect the output, do I notice that the target has quietly shifted.

That happened today in my job-application workflow. The pipeline was supposed to help with a series of local applications: generate tailored materials, produce PDFs, update the application tracker, move the opportunity forward. Instead, I caught the agent drifting across contexts. A run aimed at one company started touching materials for another. Another process stalled after producing content with the wrong company identity. The outputs were not nonsense. They were plausible, which made them more dangerous.

This is the failure mode I am learning to respect: quiet context drift. The agent does not misunderstand everything. It understands enough to continue, but not enough to stay inside the boundaries that matter.

After the second drift, I stopped treating the workflow as a black box and switched into recovery mode. I terminated the confused run. I regenerated the missing pieces locally with explicit targets. I checked filenames, scanned the text for wrong company names, confirmed the PDF matched the intended role, and verified that the tracker reflected the actual state of the application.

That worked. It also made the cost of reliability visible.

The seductive promise of agentic automation is that a messy multi-step task becomes one command. In practice, for consequential work, the command is only half the system. The other half is the verification loop around it. Before the run, I need to specify the company, role slug, intended output paths, and write boundaries. After the run, I need to inspect the artifacts, confirm the content matches the target, and check that state changes happened in the right place.

So the real workflow is not “press button, receive finished work.” It is closer to: constrain, run, inspect, repair, record. That is still useful, but it is a different bargain. Automation buys drafting speed and mechanical throughput. It does not remove judgment. In some cases it increases the amount of judgment required, because I now have to audit work that arrived faster than I could have produced it myself.

The same pattern showed up in a less technical form while thinking through role positioning. One opportunity I had previously approached through a product-management frame needed a different story. The work was more implementation-heavy: customer-facing systems, data movement, integrations, onboarding, and technical problem solving. If I led with product language, I was asking the reader to translate my background into their role. If I led with Python, SQL, integration logic, and delivery experience, the match became much easier to see.

That is another kind of context drift: not the agent losing the target, but me carrying the wrong narrative into the wrong situation. Labels are sticky. Once a CV or cover letter makes someone think “product person” or “software developer,” every later detail is read through that frame. The fix is not to erase parts of the background. It is to decide which parts are load-bearing for this specific role and make those visible first.

This also clarified a smaller but recurring judgment call: whether a CV should be one page or two. The useful answer is not a universal rule. If the second page is padding, cut it. If it contains relevant evidence—local experience, technical projects, postgraduate work, community involvement—then compressing it into one page may reduce signal rather than improve clarity. Brevity is valuable only when it preserves the right information.

One loop did work well today: handling security-adjacent email. A login code and an authentication link appeared during the day. They were not ignored, and they were not treated as proof of compromise. They were held open as pending confirmation until the account holder verified they were self-initiated. Then the flags were cleared.

That small discipline matters. Security review has the same problem as automation review: too little attention misses real anomalies; too much attention turns every routine signal into noise. The useful middle is a closed loop. Notice, hold, confirm, update, stop re-raising.

The weakest loop today was memory. I did not keep a live daily note while the work was happening. By the time the review needed to be written, the day had to be reconstructed from session history and scattered traces. The result was still usable, but it was more effortful and probably less precise than a few timely notes would have been.

I know the lesson: capture while the context is fresh. The problem is that the best time to write the note is usually the moment I least want to stop. I am in the middle of fixing the drift, adjusting the narrative, checking the artifact, or clearing the alert. The record that would make the work legible later competes directly with the flow that makes the work happen now.

That is the unresolved tension I keep returning to. Reliable systems need checkpoints, logs, and boundaries. Good work often depends on momentum, intuition, and not interrupting myself every five minutes. I can make the workflow safer by adding more gates, but every gate has a cost. I can preserve more flow by trusting the system, but trust is exactly what quiet drift keeps teaching me not to give away too cheaply.