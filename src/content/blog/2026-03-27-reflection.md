---
title: "Workflow Lessons from a Daily Review"
date: 2026-03-27
description: "Reflections on daily workflows and system engineering principles."
tags: [workflow, system engineering, git, monorepo]
---
Recently, I've been diving deep into my daily workflow, and I'm uncovering some critical insights. The exercise of reviewing my day, especially when guided by a prompt to look for durable lessons, is proving to be incredibly valuable. One issue that keeps cropping up, and that deserves special attention, is the management of environment state, particularly in the context of Git worktrees, and monorepos.
The recurring problem seems to be an insidious leakage of bad monorepo state into sub-projects. The problem manifests as confusion. As a simple example, imagine working on a project that requires a very specific version of a build tool. In a well-managed single repository or modularized project, this is usually handled with per-project tools like `.tool-versions` or `.nvmrc` files. However, in my current workflow, I often find myself in a situation where the global environment has somehow become tangled with the requirements of a specific worktree. I suspect the initial problem is the use of a simple, but not robust, initialization script.
What's really insidious about this state leakage is the diagnostic difficulty. I can spend a considerable amount of time troubleshooting why a command isn't working, only to discover that the issue is due to some environment variable or installed package conflict. The solution, I've realized, isn’t simply to declare this specific issue. It’s to institute robust guardrails to prevent this. I need to be more deliberate about isolating each work environment. I think this will require rethinking how I initialize my environment.
One way to address this is to ensure that a very limited set of files are sourced in my shell's start-up, so that my shell start-up script loads very little. Then, when I enter a project directory, I will use a tool like direnv or asdf to load any environment dependencies. Doing this will let me be assured that a specific sub-project is not accidentally polluting my entire environment.
The use of `asdf` as a tool for managing different versions of programming languages is, I think, an under-appreciated technique. Using asdf, I can specify a specific version of a tool such as `node`, and that version will be used when I open a new terminal or when I `cd` into a directory. This offers a major upgrade compared to the older approach.
I also need to improve my discipline. It's too easy to quickly make some changes and then move on without fully cleaning up the environment. For example, if I make a temporary change to the shell environment to solve a problem, I then need to make sure to undo these changes after the experiment is done, or add that configuration into an appropriate initialization file.
So what's the next step? It's clear that it isn’t enough to just recognize this kind of problem and mentally commit to doing better. I need a concrete set of steps. I am going to:
1.  audit my shell initialization files
2.  determine where environment variables and aliases are defined
3.  isolate project-specific requirements with `.tool-versions` or similar files
4.  consider adopting direnv or a similar tool to automatically load project-specific environment variables
This approach might seem overly cautious to some. However, the time I waste trying to diagnose environment-related issues far outweighs the time investment in implementing and maintaining a more disciplined approach.
A final, related point has to do with making it easier for me to explore and debug using tools like `grep`. In particular, it can be useful to see how a specific setting or shell variable is defined. I've found that `grep` is a very useful tool for understanding how a shell variable is defined. With the standard command line tools, such as `grep`, `sed`, etc, I'm often forced to write commands using arcane syntax in order to achieve something seemingly simple. I am not suggesting that these tools be discarded, since they offer excellent capabilities. However, when I start to use tools like `grep`, I need to take a few seconds and make a list of the tools that are related to the problem. If I am searching for a variable name, I
**Refining Architectural Abstractions**
I am now focusing on refining architectural abstractions, explicitly isolating contexts rather than relying on assumed hierarchies. I've identified several key areas: network connectivity assumptions (specifically, SSH vs. HTTPS for Git), deployment path coupling, and AI tool evaluation (balancing safety and velocity). My aim is to decouple experimental deployments from production routing and validate connectivity before complex authentication. I am also working on isolating system dependencies.
**Isolating System Dependencies**
I'm now writing about the costs of assumed context and bleed-through in system boundaries. I'm focusing on network defaults (SSH vs. HTTPS for Git), deployment paths, and even evaluating AI tools, constantly balancing safety and agility. I want to decouple experimental deployments from production routing and validate connectivity first, before dealing with authentication. I am also making sure I focus on isolating system dependencies, and making sure that all connections are known and managed.
```markdown
---
title: "The Friction of Bounded Contexts: When Systems Bleed"
date: 2026-03-27
description: "A reflection on the hidden costs of assumed context, network defaults, and routing entanglement in software engineering."
tags: ["reflection", "engineering", "systems-design", "deployment"]
---
There is a specific kind of exhaustion that comes not from writing code, but from fighting the environment it lives in. Today was a masterclass in the friction of bounded contexts—the moments when you realize the boundaries you thought existed between systems, directories, and networks are actually porous, bleeding state and assumptions where they shouldn’t.
My primary objective today seemed straightforward: take over a fresh frontend project, initialize its repository, and stand up a test deployment. But software engineering is rarely about the happy path. It is almost entirely about navigating the constraints and ghosts of previous decisions.
### The Illusion of Inher

Analyzing Contextual Dependencies

I'm now diving into the interplay of assumed context and its associated costs. I'm focusing on the issue of directory hierarchy and bleed-through. The project's current state is that assumed directory hierarchy has caused issues, so the project must use explicit isolation instead. I'm prioritizing the isolation of each project's context. I am also working on isolating dependencies, such as the problem of network defaults.

Evaluating Network Constraints

I'm now focusing on network constraints, particularly the assumption of direct SSH connectivity. The earlier HTTPS workaround highlights the risks of assumed network configurations. I'm prioritizing validating connectivity first and then authentication. I am aiming to ensure that systems don't depend on assumed network defaults.

Thinking...

Ask anything, @ to mention, / for workflows

Planning
Gemini 3.1 Pro (High)
Model
Gemini 3.1 Pro (High)
New
Gemini 3.1 Pro (Low)
New
Gemini 3 Flash
Claude Sonnet 4.6 (Thinking)
Claude Opus 4.6 (Thinking)
GPT-OSS 120B (Medium)
