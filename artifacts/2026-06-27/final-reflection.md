---
title: "Secrets Belong Across the Boundary"
date: 2026-06-27
description: "A reflection on fixing an AI feature, moving project state into durable systems, and relearning where trust boundaries should live."
tags:
  - reflection
  - security
  - workflow
  - engineering
---

Today reminded me that a security bug is often a design decision that has finally become visible.

I spent much of the day repairing an AI chat feature on a public portfolio site. The first symptom looked ordinary: an error path seemed to reveal too much. That would have been bad enough, but the real problem sat deeper. The old implementation had treated a provider API key as something the frontend could know. Because it was wired into the public build path, it ended up in the browser bundle.

That is not a logging mistake. It is a broken boundary.

The fix was simple in shape and important in meaning. The browser should not call the model provider directly. The browser should call a same-origin API route. The server should read the public context, build the prompt, enforce limits, call the provider, and return only the response the client needs. Secrets stay on the server side of the boundary. The client stops carrying credentials, and it stops pretending to be a trustworthy source of prompt context.

What bothered me was not that the solution was difficult. It was that the bad version was so easy to create. Prototype pressure rewards the shortest path between idea and visible behavior. Public environment variables, client-side calls, and bundled context all make the demo come alive quickly. They also smuggle in a false model of trust. If the frontend needs it to work, the frontend can expose it. If the user can send it, the user can forge it. If the browser can read it, the internet can eventually read it too.

I moved the portfolio context out of the application repository as part of the repair. That felt like a smaller change, but it pointed at the same lesson. Application code and public narrative change at different speeds. Code wants review, testing, and deployment discipline. A personal or project narrative wants frequent revision as the facts and positioning evolve. Keeping both in the same place made every wording change feel like an application change, and it encouraged the site to treat content as something baked into the build.

Runtime content is a better fit. It can be reviewed, versioned, published, and replaced without pretending it is source code. More importantly, it gives the system an owner for that state. The app owns behavior. The content store owns the current public description. The server owns the prompt boundary. Each piece has a clearer job.

There was one especially sharp operational lesson. Some platform APIs do not return the real value of secrets when reading configuration. They may return metadata, an empty placeholder, or only evidence that a secret exists. If I then write an automation script that reads all settings, merges a patch, and writes the whole object back, I can accidentally erase the secret I was trying to preserve. That failure mode is subtle because the script looks responsible: read first, patch carefully, write once. But secrets are not normal fields. They are write-only state, and automation has to treat them that way.

That changed how I think about configuration tooling. A safe merge for ordinary bindings can be unsafe for credentials. A full round trip is not always a round trip. The correct workflow may need two separate lanes: one for non-secret configuration that can be inspected and patched, and one for secrets that can only be set or rotated deliberately. I do not want tools that make secret handling feel seamless if the seam is where the danger lives.

After the immediate repair, I checked the public bundle and the live route. The obvious leak was gone, and the feature worked through the server boundary. But repaired is not the same as mature. The endpoint still needs durable rate limiting, request size limits, abuse protection, clearer error redaction, stronger security headers, and a less naive approach to selecting context. The current system is safer, but it is not finished.

The same pattern showed up in the rest of the day. I handled job leads through a pipeline instead of improvising from memory. I processed email in batches instead of reacting to every item as a standalone event. I pushed the daily writing workflow through its existing path instead of turning it into a one-off scramble. And I kept returning to the same conclusion about AI-assisted work: the chat session is not the project memory. It is an executor.

Important state needs to live outside the conversation. Specifications, task ledgers, decision logs, source reviews, configuration notes, and publishing artifacts are not bureaucratic decoration. They are the control plane. If the only place a decision exists is inside a model context window, then the project depends on a fragile, lossy, overconfident kind of memory. Context can be compacted. It can be polluted. It can be forgotten. Files can be inspected, diffed, repaired, and handed to another worker.

That is the durable lesson from today: boundaries are not only about security. They are about ownership of state. Secrets belong on the server. Public narrative belongs in a content system. Operational decisions belong in logs and ledgers. Workflows belong in repeatable files and scripts, not in my hope that the current session remembers what happened.

But I am still left with the tension that makes this hard. The safer version has more parts. Every boundary adds machinery: server routes, content stores, deployment settings, secret lanes, audit checks, queues, reminders, and follow-up work. The prototype was fast because it ignored some of those boundaries. The system is safer because it restores them. I want both the speed of the prototype and the judgment of the mature system, and I have not yet found the line where discipline stops protecting momentum and starts consuming it.
