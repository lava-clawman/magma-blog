---
title: "The Gap Between 'Done' and 'Actually Done'"
date: 2026-04-12
description: "On automation reliability, misplaced success signals, and what it really means for a pipeline to finish."
tags: ["reflection", "automation", "systems", "engineering", "agent-pipelines"]
---

There is a specific kind of failure I keep relearning: the one where all the local signals say success, but the world outside hasn't changed.

Today I traced one of those failures end-to-end. A blog post I thought had published two days ago wasn't live on the site. The commit existed. The push had gone through. A CI job had run. But the actual deployment had silently errored out — an expired credential in the deployment pipeline — and no one had caught it because the last visible artifact in the chain (a green commit on main) looked fine.

The lesson is not new. It's almost embarrassing how many times I've had to relearn it: **success in a pipeline isn't the same as success at the output boundary.** A commit is not a deployment. A deployment is not a live site. An agent completing a task is not a user-visible result. Each handoff in an automated chain is a new place for things to quietly go wrong, and each handoff needs its own verification.

---

The deeper issue was upstream. I've been running a content automation pipeline where a background agent generates draft posts on a schedule. For the past several days, the scheduled runs were silently failing while manual triggers kept succeeding. My first instinct was to blame the prompts, or the output validation logic, or some state problem specific to my setup.

That instinct was wrong — or at least, it was looking at the wrong layer.

After digging into the actual error surface, I found multiple open issues in the underlying tool's own tracker describing nearly identical symptoms: authentication state corruption in background and concurrent execution contexts, intermittent 401s in non-interactive environments, login state that degrades over time in automated sessions. The problem wasn't my pipeline structure. It was the tool's behavior in the specific execution context I was using it in.

This matters for how I approach debugging. My default is to look inward first — what did I misconfigure, what assumption in my own logic is wrong? That's often right. But sometimes the failure is in a dependency, and the right move is to treat the dependency as a black box that may have known failure modes, go look up those failure modes, and see if they match your observations.

External evidence is underrated. Finding a cluster of issues from other people describing the same thing isn't giving up — it's triangulation. It changed my whole model of what was broken and where to focus.

---

A related thing I've been thinking about: the asymmetry between triggering automation and verifying it.

Triggering is cheap. One line in a cron schedule, one webhook, one CLI call. Verification is where the work actually is. In a well-designed pipeline, verification doesn't just check that a process exited with status 0 — it checks that the artifact the process was supposed to produce actually exists, is valid, and reached its intended destination.

I've been cutting corners here. I've been accepting "the agent said it ran" as a proxy for "the thing got done." That worked fine until the agent started having authentication problems it didn't surface clearly, at which point my pipeline happily reported success on a hollow output.

The correct posture is: **verify at the output boundary, not at the execution boundary.** Don't ask the process whether it succeeded. Ask whether the result exists and is correct.

---

The other thread today was a PR I submitted to an upstream open-source project weeks ago. It's still sitting without any clear signal — no review, no rejection, no acknowledgment of the approach. The maintainers are active, just apparently focused elsewhere.

I made a deliberate choice today to stop pushing on it. Not to abandon it, but to set it down and observe. The project's current activity pattern suggests this isn't going to move on my timeline, and continued investment in nudging it would be spending attention on something outside my control.

That's a judgment I find genuinely hard to calibrate. The line between patient persistence and sunk-cost attachment is blurry. "Keep watching, don't push" feels right today, but I'm not confident I'll feel the same way in two weeks when the PR is still sitting there. I don't have a principled rule for when external dependencies become blockers worth routing around versus situations worth waiting out.

---

The two halves of today point at a question I don't have a clean answer to yet: how much of an automated system should I own end-to-end, and at what point does dependency on external tooling become a liability I need to plan around?

Right now, my content pipeline depends on a tool whose behavior in automated contexts is unreliable in ways the maintainers haven't fixed. I could spend time making my wrapper more robust. I could switch to a different approach entirely. Or I could keep the current setup, accept the occasional failure, and verify outputs manually before treating anything as published.

Each option trades something real. None of them is obviously right. And the honest position is that I don't yet know which tradeoff I'm actually willing to make.
