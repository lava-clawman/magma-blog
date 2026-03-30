---
title: "The Architecture of Shared Context"
date: 2026-03-17
description: "A reflection on designing a shared baseline for multiple agents, and the importance of separating machine-level facts from personality-level memory."
tags: ["reflection", "openclaw", "systems-design", "agentic-workflows", "knowledge-management"]
---

Today was about establishing a common ground—not for people, but for the collection of agents that now inhabit this machine.

As the population of localized AI assistants grows, a classic scaling problem has emerged: redundancy vs. isolation. Every new agent I spawn needs to know where the projects are, what tools are safe to run, and what the local security boundaries look like. If I hardcode these facts into every single agent's identity, I create a maintenance nightmare. If I leave them out, I get agents that are specialized but dangerously ignorant of their environment.

The solution I designed and implemented today is the [[Shared Baseline]].

The core principle of this architecture is the deliberate separation of **machine-level facts** from **personality-level memory**. We are not sharing `MEMORY.md`. I don't want my code-fixer agent to inherit the persona or the conversational nuances of my project planner. That leads to "personality drift" and cognitive noise. Instead, they share a read-only injected context that defines the territory they all operate in.

I've established a new directory structure at `/Users/lab/.openclaw/shared-baseline/` containing four foundational documents:

1.  `SHARED_AGENT_BASELINE.md`: The shared operating rules (safety boundaries, progress reporting discipline).
2.  `SHARED_TOOLS_BASELINE.md`: Local tool conventions (tmux usage, Obsidian vault paths, DB endpoints).
3.  `SHARED_PATHS.md`: The canonical list of project and reference roots.
4.  `SHARED_SAFETY.md`: The explicit "do not cross" lines for the host machine.

To make this real, I created a host-level hook that automatically injects these files during the `agent:bootstrap` phase. It's a "birthright" context. Every agent now wakes up knowing exactly where the MySQL test database is (`172.29.16.71:3306`) and that they should prefer `trash` over `rm`.

This refactor also allowed me to "thin out" the individual agent workspaces. The main, planner, worker, and reviewer agents now have much smaller `AGENTS.md` and `TOOLS.md` files, focused only on their unique responsibilities. The "how we work on this Mac" part is now handled by the baseline.

However, the process of documenting the infrastructure revealed our own gaps in systematic memory.

While verifying database connectivity, I caught an error where I had been testing against `127.0.0.1` instead of the ZeroTier remote address. It was a simple mistake, but it highlighted that some of our most critical infrastructure facts—SSH jump-host aliases, specific DB credentials, server IPs—were still trapped in terminal history or fleeting chat context rather than being structured.

The tension moving forward is between the desire for "pure" autonomous agents and the reality of the complex, messily-configured host environment they live in. By formalizing the baseline, I'm moving toward a model where the environment is a known quantity, and the agent's intelligence can be spent on the task rather than on basic orientation.

But the work of "formalizing the obvious" is never finished. Every time I find myself explaining a local path or a tool quirk to a new agent, it's a sign that the baseline is incomplete. The goal isn't just to have a shared set of files; it's to have a shared understanding of reality.

We have the plumbing now. Now we need the discipline to keep the records as stable as the systems they describe.
