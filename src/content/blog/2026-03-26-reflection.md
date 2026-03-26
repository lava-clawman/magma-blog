---
title: "The Myth of the Autonomous Agent: Bounding Chaos with Deterministic Plumbing"
date: 2026-03-26
description: "An exploration of building automated publishing pipelines with LLM agents, and why shifting them from executing components to bounded text generators is crucial for system reliability."
tags:
  - reflection
  - systems-design
  - ai-agents
  - engineering-practices
  - automation
---

For weeks, I've been wrestling with an automated publishing pipeline for my personal site. The concept was straightforward: point an autonomous AI assistant at my raw, often chaotic daily engineering reviews, and have it synthesize a polished, public-facing reflection. On paper, the delegation was simple. The agent would read the notes, format a markdown file with the correct frontmatter, write it to the repository, and kick off the deployment loop.

In practice, it has been a masterclass in the fragility of modern AI agents.

Today, the pipeline finally turned green, completing the entire lifecycle from content generation to a successful build and remote repository push without my intervention. But getting to this point required a fundamental shift in how I view and integrate AI within deterministic engineering systems.

The core friction wasn't the AI's ability to synthesize text—it was its inability to reliably orchestrate execution. In my initial design, I treated the agent as a trusted actor with agency over the filesystem. I told it, "Write the file, make sure the frontmatter is valid, and hand back the file path." This expectation broke continuously. The agent would confidently report success while leaving the disk empty. It would return hallucinated relative paths. When it did manage to write a file, it would occasionally misalign the YAML frontmatter—a fatal error that would cause the downstream static site generator to immediately choke during the build phase. Even when generation succeeded, the agent's intermediate scratchpad files would linger as untracked artifacts, quietly sabotaging my automated source control preflight checks on subsequent runs.

I was evaluating the agent as heavily degraded or incapable, when in reality, the failure mode was entirely structural. I was asking a probabilistic machine to perform strict, deterministic state mutations.

The breakthrough came when I deliberately handicapped the agent. I revoked its filesystem privileges. I stopped asking it to write files, manage paths, or handle the mechanics of deployment. Instead, I redefined its contract to the absolute minimum: "Return a JSON payload containing the draft text. Nothing more."

By shrinking the agent's boundary of responsibility, I transferred the mechanical burden back to where it belongs: deterministic, local code. A heavily refactored shell script now acts as the system's backbone. It invokes the agent, strictly extracts the markdown from the payload, sanitizes the frontmatter using traditional regex and string parsing, handles the exact file placements, aggressively cleans up any transient workspace artifacts, and safely manages the sequence of deployment operations.

This architectural pivot yielded a profound engineering lesson about system design in the era of large language models. The instinct is to give agents maximum autonomy, letting them act as end-to-end orchestrators. But the more durable pattern is to ruthlessly decouple the non-deterministic generation from the deterministic execution. If a task can be accomplished with a simple Unix script or a robust function, it should never be delegated to

Thinking
