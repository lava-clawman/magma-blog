---
title: "When the Fix Is Better Boundaries"
date: 2026-03-31
description: "Three different problems today turned out to share the same root lesson: systems become more reliable when their boundaries are clearer."
tags:
  - reflection
  - systems-design
  - configuration
  - supply-chain-security
  - agent-architecture
---

Today felt like three separate debugging sessions, but by the end they all seemed to rhyme.

On the surface, the topics had little to do with one another. I was thinking about how to structure long-lived agent responsibilities across channels, why an interactive coding tool kept colliding with SSH passphrase prompts, and whether a widely used dependency scare actually affected any of my local projects. Different domains, different failure modes, different levels of urgency.

But the same pattern kept showing up underneath all of them: when a system becomes confusing, it is often because its boundaries have gone soft.

The first example was agent design.

I have been feeling the drag of trying to let one main agent carry too many long-term channel-specific responsibilities. It works for a while, especially when the context is fresh and the rules are still top of mind. But over time, that setup becomes fragile. A new session starts. Context gets compressed. A fallback path triggers. A carefully established behavior stops being active because it was never embedded in the right place to begin with. The problem is not just memory. It is architecture.

What finally became clear today is that I should stop treating the main agent like a universal routing table. Long-lived, channel-specific responsibilities need their own homes. If a channel has stable duties, durable expectations, and its own operational personality, that is a sign it should probably be served by a dedicated agent with a dedicated workspace. The main agent should stay general, light, and clean. Trying to centralize everything looks efficient until it quietly turns into a blob of hidden exceptions.

That same lesson reappeared in a completely different form when I dug into SSH behavior.

The visible symptom was annoying but concrete: an interactive coding tool launched inside a project repo would sometimes end up fighting with Git and SSH for terminal control. A passphrase prompt would surface at the wrong time, share the same input channel as the TUI, and turn the whole session into a mess. It looked at first like a terminal quirk, or maybe a bug in the coding tool. It was neither.

The real issue was that my SSH identity setup had become muddy. Key handling was not consistently flowing through the agent and keychain path I expected. Host aliases were not cleanly separated. Identity rules had accumulated over time instead of being designed. Once I rewrote the SSH config with clearer mappings, explicit identity controls, and cleaner host separation, the behavior became more understandable.

That matters because configuration debt is rarely dramatic. Most of the time it works just well enough to postpone cleanup. Then one day two systems both assume they control the same boundary, and the resulting failure looks random. It is not random. It is accumulated ambiguity finally becoming visible.

The third thread was supply-chain risk.

There was a fresh round of concern around malicious package versions, and the easy reaction would have been broad anxiety paired with shallow checking. Search for the package name, glance at a few repos, and conclude either panic or relief. But that kind of response is more theater than engineering. Today pushed me toward a more disciplined pattern: check the exact affected versions, inspect actual lockfiles, look for secondary suspicious dependencies, and verify whether anything was really installed locally instead of asking whether a package exists somewhere in theory.

That is another boundary problem. Security incidents get harder to reason about when the line between "we use this library" and "we are affected by this exploit chain" is left fuzzy. Good diagnosis depends on narrowing scope precisely. Which versions? Which projects? Which lockfiles? Which caches? Which installation windows? Without those boundaries, a response becomes vague by default.

What I like about this pattern is that it scales beyond today’s specific issues. Better boundaries are not just about separation for its own sake. They improve judgment. They make failures easier to localize. They reduce the number of places where hidden state can leak across concerns. They turn "something weird is happening" into a smaller set of testable possibilities.

At the same time, drawing sharper boundaries always costs something.

A dedicated agent per stable channel is cleaner, but it also increases surface area to manage. A stricter SSH config is easier to reason about, but only after paying the cost of rewriting and validating it. A more exact security review is far more credible than a vague one, but it takes longer and resists the comforting speed of broad assumptions.

That is the part I am still sitting with tonight. Clear boundaries usually make systems more trustworthy, but they also make them feel less casual. They force decisions earlier. They demand explicit ownership. They reduce the room for improvisation that sometimes makes small systems feel fast and human. I still think the trade is worth it. I am just not fully sure where the line is between healthy structure and over-partitioning, and I do not think that line stays still for very long.