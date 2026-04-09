---
title: "Composite Failures Hide Behind Simple Error Messages"
date: 2026-04-09
description: "A broken publishing pipeline reminded me that the hardest automation failures are usually not singular bugs, but several weak assumptions failing at once."
tags:
  - reflection
  - automation
  - debugging
  - systems-thinking
  - pipelines
---

Today I spent hours inside a broken automation pipeline and came away with a familiar but still uncomfortable lesson: the most exhausting failures are rarely caused by one dramatic bug. They come from several smaller weaknesses lining up at the same time.

The system itself is conceptually simple. Daily review notes should become a draft, the draft should become a cleaned final article, and the article should move through the rest of the publishing path. But simplicity at the idea level is not the same thing as simplicity in operation. By the time I dug into it, the pipeline had accumulated enough overlapping failure modes that it no longer made sense to ask, "What broke?" The more accurate question was, "Which of the failures am I currently looking at?"

That distinction changed everything.

Part of the problem was upstream instability. Sometimes the draft generator simply returned busy or terminated states. But that was only one class of failure. In other cases, it produced something half-usable: a draft that contained real prose mixed with interface noise, status text, or other junk. My local success criteria were too rigid, so those mixed outputs were being classified as pure failure even when they contained enough substance to move forward. On top of that, the retry logic was too aggressive. Instead of reducing the backlog carefully, it was triggering multiple recovery attempts in the same time window and increasing contention against an already unstable upstream. And below all of that, the automation could still be tripped by a dirty working tree, because the update step assumed the repository was clean.

None of these issues was especially exotic by itself. Together, they created a system that looked randomly unreliable.

What I found most striking was how much time I had lost not because the system was broken, but because its failure reporting was too vague to be actionable. A single generic notification had been standing in for several very different conditions. That kind of message feels harmless when a system is young. It is not harmless. A vague failure message is deferred debugging debt. It pushes complexity out of the code and into the future human who has to reconstruct what actually happened under pressure.

As soon as I broke the failure states into more specific categories, the pipeline became easier to reason about. Not fixed, but legible. That is often the first real step toward repair. Systems do not become maintainable only by becoming more reliable. They become maintainable when they become easier to interpret.

This also changed how I thought about retry logic.

I have a recurring instinct to make recovery loops thorough: scan broadly, catch everything, try all missing work. That instinct sounds responsible, but in distributed or rate-limited systems it can become self-sabotage. If the upstream is already constrained, a broad retry wave is not recovery. It is load amplification. Shrinking the retry strategy to one highest-priority missing item per cycle felt slower, but it was actually more realistic. Throughput is not always maximized by pushing harder. Sometimes it improves when the system stops panicking.

Another lesson was embarrassingly mundane, which usually means it is important. Automated workflows have harsher preconditions than humans like to admit. A repository with uncommitted changes is not "mostly fine" if a scheduled process depends on pulling, rebasing, or writing with clean assumptions. Human operators tolerate partial states all the time. Cron jobs do not. The line between "mid-change" and "broken" is much thinner in unattended systems.

I also ended up validating something about execution models that I had treated as a minor implementation detail. One-shot command patterns that look elegant on paper can be surprisingly brittle in real terminal environments, especially once multiplexers, permissions, and interactive agents enter the picture. A more explicit interactive session, with direct file-writing as the target behavior, turned out to be more reliable than trying to force everything through single-line output capture. That matters because execution style is not just a convenience choice. It shapes the kinds of failures a pipeline is even able to recover from.

By the end of the day, I found myself leaning toward a larger architectural shift: move draft generation onto a more direct file-writing path and stop spending so much effort trying to salvage a conversational interface as if it were a stable production surface. That feels like the right move. But it also raises a question I have not fully answered.

If earlier stages become more permissive and downstream stages get smarter about cleaning mixed output, the pipeline may become more resilient overall. But it also means complexity migrates rather than disappears. I can simplify the extraction layer by allowing noisier drafts through, yet that makes the finalization layer more responsible for judgment. I can reduce brittleness in the middle by pushing ambiguity later, but then the later stage becomes a higher-stakes filter.

That is the tension I am left with tonight. I want the system to be less fragile, less overfit to interface noise, and easier to recover when one part misbehaves. But I cannot quite tell whether I am making it simpler or just redistributing the difficulty to a part of the pipeline that happens to be more graceful under pressure.