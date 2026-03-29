---
title: "The Purity Problem in Automated Writing"
date: 2026-03-28
description: "My publishing pipeline didn't fail by crashing. It failed by blurring the line between a draft, a thought process, and a finished article."
tags:
  - reflection
  - automation
  - content-pipelines
  - systems-engineering
  - agentic-workflows
---

There is a kind of systems failure I distrust more than an obvious crash: the workflow that appears to succeed while quietly lowering the quality bar underneath me.

That is what happened to my writing pipeline today.

A post made it all the way through generation, extraction, formatting, and publishing, but what reached the end was not a clean article. It was a mixture of article text and process residue: intermediate reasoning, alternate candidates, formatting wrappers, and interface noise that should never have survived into a published piece. Nothing exploded. No stage loudly failed. The system simply carried impure material forward because no part of it was strict enough to say, "This is not an article yet."

At first glance, this kind of failure is easy to misdiagnose. When published output looks messy, the temptation is to blame rendering, templates, or markdown handling. But the build layer was innocent. It rendered exactly what it received. The real fault was upstream, in the extraction and sanitization logic. I had a pipeline that knew how to move text, but not how to judge it.

That distinction matters more than it sounds.

A lot of automation earns trust through motion. Files appear in the right directories. Scripts finish without errors. Commits land. Pages deploy. From a distance, it all looks like progress. But mechanical success and editorial success are not the same thing. A pipeline can be operationally healthy while still being conceptually broken if it cannot distinguish between a draft, a byproduct, and a finished artifact.

Today forced me to admit that I had let those boundaries get blurry.

The immediate response was structural. I split the workflow more explicitly: one stage generates a draft, another stage turns that draft into a final article, and only after that should anything be publishable. That was not just a technical refactor. It was a statement about responsibility. Drafting and finalization are not the same act, and treating them as interchangeable invites contamination.

But even that improvement came with a catch. A two-stage pipeline is only safer if the handoff between stages is clean. If the draft stage still emits half-finished prose, process chatter, or multiple competing candidates, then the finalization stage inherits ambiguity instead of resolving it. In practice, that is exactly what I saw in testing. The new chain could produce a draft artifact reliably enough to prove the plumbing worked, but the draft itself was still unstable. It could stop mid-thought. It could trail noise. It could look successful in the filesystem while being unusable in substance.

That is the deeper lesson I keep running into with AI-flavored workflows: the hardest problem is usually not generation. It is boundary discipline.

Prompting matters. Model choice matters. Orchestration matters. But before any of those, I need a much sharper definition of what the system is allowed to accept as complete. That means purity checks, candidate selection rules, truncation detection, and explicit rejection of UI residue or process language. It means building a workflow that is willing to fail when the output is ambiguous instead of pretending ambiguity is close enough.

In other words, I need a pipeline with standards, not just momentum.

What made today especially clarifying is that the failure was embarrassing in exactly the right way. It did not merely reveal a bug. It revealed a misplaced assumption: that if each step looked reasonable in isolation, the whole chain was trustworthy. That assumption falls apart the moment one stage treats "generated text" and "publishable text" as roughly the same category.

They are not the same category. Not even close.

A publishable article is not just text that exists. It is text that has survived selection, cleanup, coherence checks, and some threshold of judgment. If I want an automated pipeline to handle more of that work, then the pipeline needs stronger opinions about quality. It has to reject duplicates, reject fragments, reject contamination, and reject uncertainty. The system should be comfortable stopping itself before it becomes confidently wrong in public.

That sounds like a straightforward engineering principle, but it creates an uncomfortable tension in practice. The more aggressively I gate for cleanliness, the more I slow down the dream of seamless autonomy. The more I optimize for hands-off automation, the more I risk teaching the system to move faster than my standards can keep up.

I still want the chain to become more automatic. I just no longer trust "more automatic" as a synonym for "more mature." Right now the real question is not whether the workflow can finish without me. It is whether I am willing to trust a machine to decide when its own output has crossed the line from draft to artifact. I do not have a satisfying answer to that yet, and I am not sure the right system is the one that answers too quickly.