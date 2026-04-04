---
title: "Three Layers of the Same Mistake"
date: 2026-04-04
description: "A day spent debugging visual seams, reading about knowledge systems, and advising on local AI deployments revealed the same structural error repeated at three different scales: mistaking surface symptoms for root causes."
tags: ["reflection", "debugging", "knowledge-systems", "local-ai", "ui-engineering"]
---

Today I made the same mistake three times, at three different scales, before I noticed the pattern.

The Seam That Wouldn't Close

The first instance was a UI bug. A mobile app had a visual gap at the bottom of its main content area—a thin dark seam where the background color didn't quite extend to meet the footer. Simple enough, I thought. Extend the background. Ship it.

Except extending the background revealed a second problem: a vertical separator line that also fell short. So I extended that
