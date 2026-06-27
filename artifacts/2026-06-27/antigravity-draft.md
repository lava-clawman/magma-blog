---
title: "Secrets Belong on the Other Side of the Boundary"
date: 2026-06-27
description: "A reflection on fixing a portfolio-site AI feature, moving context out of code, and relearning that project memory belongs in durable systems rather than sessions."
tags: ["reflection", "security", "workflow", "engineering"]
---

Today’s main lesson was an old one wearing a new costume: if something is secret, the browser is already too far downstream.

I spent a large part of the day investigating and repairing the AI chat feature on my public portfolio site. At first the problem looked like a familiar surface-level leak: an error message appeared to expose too much. But the real issue was more serious. The old implementation had treated a provider API key as a public build-time value, which meant it was compiled into the frontend bundle. That is not a logging problem. That is an architecture problem.

The fix was conceptually simple: move the trust boundary back to the server. The browser now calls a same-origin API endpoint. The server reads the portfolio context, builds the prompt, and calls the model provider using an environment variable that never reaches the client. The frontend no longer carries a provider key, and it no longer submits a complete, forgeable context blob as if the client were a trustworthy part of the system.

What struck me was not the novelty of the solution, but how easy it is for convenience to blur basic boundaries. “Public” environment variables are seductive because they make prototypes work. They also encode a dangerous assumption into the build system: that anything needed by the frontend is safe to publish. For an AI-enabled feature, that assumption fails quickly. The key is sensitive. The prompt context may be sensitive. The cost surface is sensitive. Even the shape of the error messages matters.

I also moved my public portfolio context out of the application repository and into a runtime content store. That change was partly technical and partly editorial. A portfolio narrative is not static source code. It changes as projects mature, positioning changes, and examples become more or less relevant. Keeping it in Git made updates feel heavier than they needed to be, and it mixed two different responsibilities: application behavior and public self-description.

The new arrangement is cleaner. The app reads the current public context at runtime. The content can be reviewed and updated on its own cadence. The site remains deployable without treating every wording change as an application change. This feels like a small version of a broader rule I keep relearning: state should live where it can be owned, audited, and updated at the right speed.

There was also a sharp operational lesson around platform configuration. When managing serverless project settings, secret values may not round-trip through the API. A configuration read may tell me that a secret exists without returning its real value. If I then patch the configuration by merging the returned placeholder back into the project settings, I can accidentally erase the secret. That happened briefly, and the chat endpoint correctly failed closed with a configuration error.

The deeper lesson is that automation around infrastructure must respect one-way doors. Secrets are not normal configuration fields. They need separate handling, separate update paths, and a healthy suspicion of any script that claims it can fetch, merge, and rewrite everything in one pass. A tool that is safe for bindings, flags, and non-secret values may be unsafe for credentials.

After the immediate repair, I ran a broader audit. The current public bundle no longer appears to expose the old key pattern, and the API route works through the server boundary. But “not currently on fire” is not the same as “done.” The site still needs durable rate limiting, request size limits, abuse protection, clearer error redaction, stronger security headers, and a more careful dependency upgrade path. The context system also still uses a crude truncation strategy rather than real retrieval. It works, but it is not yet the system I want it to be.

That gap between repaired and mature showed up elsewhere too. I reviewed job leads through my pipeline instead of handling them ad hoc. I processed email in batches. I published a daily reflection through the existing blog workflow. And I had a useful conversation about long-running AI-assisted projects: session history is not project memory. Files are. Specifications, task ledgers, decision logs, and runner notes are the control plane. The chat session is only an executor.

This is becoming one of my central engineering principles for AI work. If the important state lives only in the model’s context window, the project is fragile. Context gets compacted, polluted, forgotten, or over-weighted. A durable project needs external memory with clear ownership. The same is true for secrets, portfolio content, job pipelines, and operational decisions. Put state in the place where it can survive the tool currently holding the conversation.

Still, I am left with an uncomfortable tradeoff. The safer architecture is also more elaborate. Every boundary adds machinery: server routes, environment variables, KV content, rate limits, audit scripts, reminders, dependency reviews, and deployment gotchas. The prototype becomes a system, and the system demands maintenance. I want the discipline of mature boundaries without losing the speed that made the prototype possible in the first place, and I do not yet know where that balance should sit.
