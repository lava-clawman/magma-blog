---
title: "The Gap Between 'Sent' and 'Delivered': Lessons from a Broken Publishing Pipeline"
date: 2026-04-13
description: "On the difference between observability layers, misattributed root causes, and the strategic question of when to stop waiting for upstream."
tags: ["reflection", "automation", "devops", "open-source", "systems-thinking"]
---

There's a particular kind of false confidence that automation systems are very good at producing. The job runs, the script exits zero, the notification fires — and somewhere downstream, nothing actually changed. Today was a day spent dismantling that confidence in a few places at once.

## When "Published" Doesn't Mean Published

My blog runs on an automated pipeline: a daily review triggers draft generation, the draft gets finalized, pushed to a repository, and a deployment service picks it up and publishes the site. For the last two days, I had been receiving "publish complete" notifications. The site hadn't changed.

The actual failure was two layers below where I thought to look. The deployment service was returning authentication errors — an access token had expired or been rotated and the secret was never updated. The pipeline didn't surface this clearly; it logged the error, but the notification logic upstream of that step had already declared victory based on a successful repository push.

This is a deceptively common failure mode in multi-stage pipelines: each stage reports its own success without knowing whether the downstream stage can receive what it just handed off. "Git push succeeded" is true. "Article is live" is not. These are not the same statement, and conflating them costs you two days of silent drift before you notice.

The fix isn't just updating the credential. It's redesigning the success signal. A pipeline that emits one notification at the end needs to be replaced by one that emits distinct signals at each meaningful stage: draft generated, final copy approved, repository updated, deployment confirmed. If any stage fails, the signal stops there. No downstream notification gets promoted to "success" by default.

## Misattributing the Root Cause

There was a second issue: the retry logic for missed articles was only kicking in after a certain hour in the morning. My first instinct was to inspect the cron schedule. The schedule was fine.

The actual cause was a hardcoded time threshold inside the script itself — a guard that said "only prioritize catching up on yesterday's article after 7 AM." The cron was running on schedule. The script was self-gating.

This kind of misattribution is subtle because both hypotheses — bad cron, bad script logic — have the same observable symptom: the thing doesn't run when you expect it to. But the remediation is completely different, and if you fix the wrong layer, you burn time and leave the actual bug in place.

What helped was stepping back and asking not "why isn't the cron working?" but "what would have to be true for this symptom to appear even if the cron were perfect?" That reframing led directly to the script internals.

## Preflight Probes as a Design Pattern

One improvement I've been thinking about: before kicking off a long-running draft generation call to an AI system, run a cheap preflight probe first. Something small and fast that verifies the service is reachable and authenticated, before committing to a 30-second or 60-second generation run that will fail at the end with a cryptic authentication error.

The probe doesn't solve the underlying authentication problem. But it changes the failure mode from "long task fails at the end, emits a confusing error, possibly triggers a misleading retry loop" to "preflight fails immediately, stops the pipeline early, emits a clear diagnostic." The information content is higher, and the noise is lower.

This pattern generalizes: anywhere you have a long task with a dependency that can silently fail at the start, a cheap preflight check moves the failure earlier and makes it legible. It's not clever, but most useful engineering patterns aren't.

## When to Stop Waiting for Upstream

The other significant decision today was about an open source dependency I've been contributing a feature branch to. The upstream project is actively maintained and has continued to release versions. My pull request is still open, but it's now in a conflicted, out-of-date state — not because nobody cares, but because upstream kept moving.

I've been implicitly treating this as "waiting for review." The actual state is "needs synchronization before it's even reviewable again." That's a different problem, and it requires a different strategy.

The decision I landed on: stop orienting the branch around the hope that the pull request merges. Instead, maintain the feature branch as a long-lived internal fork — absorbing upstream changes selectively when they matter, running our own validation, and treating upstream as a reference rather than a gatekeeper.

This feels like a small strategic concession, but I think it's the right one. Maintaining the fiction of "waiting for merge" was producing a kind of learned helplessness: we couldn't update the branch for fear of disrupting the PR, but the PR wasn't moving, so the branch drifted. Breaking that loop required explicitly naming what we were actually doing.

---

What I haven't resolved: there's a version of "maintaining your own fork" that is a pragmatic, sustainable engineering decision, and there's a version that is a quiet admission that the contribution model broke down somewhere. I'm not sure which one this is. The upstream project is healthy and moving. The feature we needed is real. Whether the right answer was a different PR structure, more aggressive follow-up, or just the inherent difficulty of cross-project coordination — I genuinely don't know. The branch works. The question of whether it *should* have to work this way is still open.
