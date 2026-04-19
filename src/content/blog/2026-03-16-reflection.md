---
title: "Shared Memory Is Not a Shared Mind"
date: 2026-03-16
description: "What looked like a configuration question in a multi-agent setup turned out to be a boundary question about memory, history, and identity."
tags:
  - reflection
  - multi-agent
  - memory
  - architecture
  - systems
---

I spent today untangling a problem that looked technical on the surface but turned out to be conceptual underneath. I thought I was deciding how to make multiple agents share memory. What I was actually deciding was where the boundaries of identity, history, and knowledge should sit in a multi-agent system.

That distinction matters more than I expected.

The initial temptation was simple: if several agents need common context, surely there should be a clean way to make them all read from the same memory. In practice, that idea hides at least two very different things. One is shared knowledge: facts, notes, and durable context that multiple agents should be able to see. The other is shared session history: the running conversation record, tool traces, and state that belong to a specific agent instance. Those are not the same layer, and treating them as if they were leads directly to bad design.

The most useful clarification from today was that shared memory should usually mean a shared knowledge layer, not a shared conversation history. Session history is tightly coupled to an agent’s identity, workspace, authentication context, and execution boundary. Letting multiple agents drift across the same session state does not produce a more intelligent system. It produces polluted context, unclear ownership, and failure modes that are difficult to diagnose because the contamination happens gradually.

Once I accepted that, the architecture choices became much clearer.

The first path is the blunt instrument: point multiple agents at the same workspace. That is perfectly reasonable when the agents are really just multiple entry points for the same assistant. If they share one persona, one working style, and one evolving memory, then a shared workspace is the shortest path and probably the right one. It is not elegant, but it is honest about what the system is.

The second path is the one that feels most balanced for real collaboration: independent workspaces with a shared-memory injection layer. Each agent keeps its own session history, auth state, and local files, but they all receive curated common context from a shared source at bootstrap or through controlled hooks. That preserves boundaries where they matter while still allowing coordination through shared background knowledge. It also forces a healthier discipline: only the knowledge worth sharing gets promoted into the common layer.

The third path is a centralized memory service or dedicated memory agent. This is the most controlled option and probably the most scalable, especially if auditability, versioning, or write arbitration matter. It is also real infrastructure, with all the overhead that implies. I can see why it exists. I can also see why it should not be the default answer to every multi-agent problem.

By the end of the day, my practical recommendation had settled into place: if I want multiple roles with real separation, the best default is independent workspaces plus shared-memory injection. It gives me clean isolation without forcing every agent to rediscover the same background context from scratch.

I also corrected two assumptions that had been quietly steering me in the wrong direction.

The first was the belief that sub-agents naturally inherit the full mind of the parent. They do not. They may receive bootstrap context or explicitly passed instructions, but they do not become extensions of a single continuous brain. That sounds obvious once stated, but it is easy to design as if a spawned helper automatically carries all of the parent’s memory, tone, and accumulated judgment. It does not.

The second was the idea that I could use a shared `agentDir` as a shortcut for shared authentication. That is the kind of shortcut that saves ten minutes and creates a week of confusion later. Credentials, session data, and local identity live too close together there. If what I need is shared auth, the safer move is to copy the specific auth artifact I need, not merge the entire operational boundary.

What still is not resolved is the human part of the architecture decision. I now understand the patterns better than I did this morning, but understanding the options is not the same thing as choosing the right one. A shared layer can improve coordination, but it can also become another stale knowledge surface that everyone reads and nobody truly maintains. Stronger isolation can reduce contamination, but it can also create duplicated work and fragmented judgment.

The hard question is no longer whether multiple agents can share context. They can. The harder question is how much context should be shared before the system stops being a collaboration between roles and starts becoming a loosely partitioned mess that only looks clean in the directory tree.