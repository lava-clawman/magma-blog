---
title: "When 'Done' Doesn't Stick: Lessons from a Day of False Alarms"
date: 2026-08-19
description: "A daily review surfaces a recurring failure mode: systems that can't remember what's already been resolved, and alerts that cry wolf until nobody's listening."
tags: ["reflection", "workflow", "automation", "personal-systems"]
---

I run a small stack of automations that scan for opportunities, watch for errors, and summarize my inbox each morning and evening. Today's review turned up a pattern I keep running into, dressed in new clothes each time: my systems are bad at remembering what I've already decided.

Three things had been resolved in earlier sessions — a deployment I'd confirmed was working, a migration that completed as expected, and a set of security alerts I'd already checked and dismissed as noise. All three came back up in today's automated review as if they were live, unresolved problems. Nothing was actually wrong. What was wrong was that "I already handled this" lived only in a conversation transcript, not in any place my automation actually reads before generating a report.

This is a small thing until it isn't. The direct cost today was a few minutes of re-verifying things I already knew were fine. The compounding cost is worse: every time a system re-raises a closed issue, it teaches me to trust it a little less. And a monitoring system you've learned to skim past isn't a monitoring system — it's ambient noise with a status bar.

The same failure showed up in a different shape on the alerting side. A watchdog process fires a notification every cycle, and today it fired an "urgent" alert with a red-siren label — for a day where every tracked metric was at zero. No errors, no failed sends, no anomalies. Zero is not urgent. Zero is the system working. But the alert template doesn't distinguish between "something is on fire" and "nothing happened," so it shouts the same way either time. This is the classic setup for alert fatigue: if the loud signal and the null signal look identical, the loud signal stops meaning anything.

Both problems trace back to the same root cause, which is one I should have internalized a long time ago: state and decisions need a durable, structured home, separate from whatever generated them. A conversation is not a database. A daily summary is not a source of truth. If a decision matters enough to act on later, it needs to be written somewhere a machine can check before it opens its mouth — not somewhere only I can find by scrolling back through history.

I also noticed I hadn't kept a running log that day. That meant reconstructing what actually got decided required piecing it together from memory and session fragments rather than reading it off a page. That's a self-inflicted version of the same problem: I'm asking my future self to do the reconciliation work that a five-minute log entry would have done automatically. The fix isn't complicated — write things down as you decide them, not after the fact when you're trying to remember what you decided. The discipline is the hard part, not the mechanism.

There's a broader lesson underneath the specifics, which is about the difference between building a system that reports activity and building one that reports state. Activity is easy: did something run, did an email get checked, did a scan complete. State is harder: is this actually still a problem, given everything I know as of right now. Most of the automation I'd built was optimized for the first question. The failures today were all instances of it answering the first question while implicitly claiming to answer the second.

None of this is a dramatic failure. Nothing broke, nothing was missed that mattered, and the actual work of the day — evaluating a job opportunity, making some project calls, closing out a few loose ends — went fine on its own terms. But "fine on its own terms" is exactly the trap: small trust erosions from repeated false positives don't show up as an incident, they show up gradually, as a slow decline in how much attention I actually pay to the thing that's supposed to be watching for me.

I know what the fix looks like in outline: a single status source that gets checked and overwritten, not appended to; alert thresholds that scale with actual signal rather than firing on every cycle; a habit of logging decisions at the moment they're made. What I don't know is how to build that without it becoming its own maintenance burden — another system that needs watching, another place state can drift out of sync with reality. Every fix for "the system doesn't know what I already decided" adds one more place a decision has to be written down correctly, and I'm not yet sure where that stops paying for itself.
