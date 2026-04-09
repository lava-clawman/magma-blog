---
title: "Archaeology of Your Own Automation"
date: 2026-04-07
description: "What I learned from auditing an old AI blog workflow—and why the gap between prototype and production is harder to see from the inside."
tags: ["reflection", "ai-workflow", "automation", "systems-thinking", "technical-debt"]
---

There's a particular kind of humility that comes from digging through your own old automation systems. Yesterday I spent the better part of a day auditing a blog workflow I had built some months ago—a multi-agent AI system designed to help manage, draft, and publish blog content. I had largely stopped using it. I wasn't sure if it had ever really worked, or if I had just convinced myself it did.

What I found was more nuanced than either "it worked" or "it didn't."

The system was real. It had genuine connections to my actual blog directory, understood my writing style to a meaningful degree, and had captured real structural knowledge about my content taxonomy. But it lived almost entirely at the layer of *prompt architecture*—it modeled how the workflow *should* behave without ever fully confronting the complexity of the actual data underneath. The moment any real messiness entered—files with spaces in paths, archive versions mixed in with canonical posts, frontmatter that was partially filled or missing entirely—the system quietly broke down or produced noise.

This is a failure mode I've started calling "ideal-world automation." It's different from a prototype, which is honest about what it doesn't handle. Ideal-world automation looks mature because it has sophisticated structure, but it has been tested only against clean, happy-path data. The moment it meets production reality, the seams show.

The specific example that crystallized this: I ran a scan across roughly 290 canonical posts and found that scripts were generating a flood of `stat: No such file or directory` errors from historical archive files mixed into the traversal. The archive files weren't supposed to be there. No one had explicitly decided they should be excluded—it just hadn't come up, because the earlier design phase never quite reached the point of handling real file system enumeration. The assumption of clean data was baked in silently.

The deeper audit decision I had to make was whether to try to resurrect the old 12-agent system or to treat it as source material for a leaner rebuild. I chose the latter, and I think it was right—but it required being honest about which parts of the old system were actual assets versus architectural nostalgia. The writing style calibration was real and worth preserving. The operational layer was not. Pulling those apart took longer than I expected, because my memory of building the system had conflated them.

What I ended up doing was extracting the genuine intellectual assets—style guides, data model definitions, workflow conventions—into standalone documents that could serve as a stable baseline for whatever comes next. Not a rewrite of the automation layer, just a documented foundation. This felt like the right kind of archaeological work: careful extraction rather than demolition or blind continuation.

The channel-based agent isolation I set up afterward reflects a different lesson. When one AI context handles too many concerns, the conversation history becomes a kind of ambient noise—past requests about unrelated things bleed into the model's working assumptions. Giving a specific workflow its own dedicated context, with its own grounding instructions and entry points, is boring infrastructure work, but it changes the quality of the interaction meaningfully. The specificity matters.

I also noticed something about how I handle incremental cleanup. I have 124 posts missing frontmatter entirely, another 34 missing tags, a handful missing titles. The tempting response is a batch normalization run—just fix them all at once. But batch operations on content you haven't read individually carry real risk: you're applying rules to cases you haven't thought about. The better approach is probably to start with the smallest, most self-contained category and work outward. Slow, deliberate, low blast radius.

What I haven't resolved is whether building these tighter systems—the baseline documents, the isolated agent context, the incremental cleanup plan—actually produces durable improvement, or just gives me better-documented artifacts of the same underlying problem: that I tend to build automation ahead of operational clarity. The discipline of separating canonical data from archives, of writing down data model assumptions before scripting against them, of scoping agents to specific workflow contexts—these feel like genuine improvements. But I've felt that before, about systems that later turned out to be optimistic in different ways.

Maybe the honest position is that every round of this work reveals a new layer of the mess. I'm not sure whether that means the process is working or just self-perpetuating.
