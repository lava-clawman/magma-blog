---
title: "When the Pipeline Breaks Visibly: Diagnosability as a First-Class Concern"
date: 2026-04-10
description: "Migrating an automated publishing pipeline and learning that observable failures are more valuable than silent ones—and that 'it works manually' is sometimes the most unsettling diagnostic result."
tags: ["reflection", "automation", "debugging", "workflow", "cli", "observability"]
---

There's a particular kind of frustration that comes from a system that fails silently, and a particular kind of satisfaction when you finally make it fail loudly. Today was mostly the latter.

## The Migration

I've been running an automated daily reflection pipeline for a while—write a review, let a script draft a blog post, run it through a publishing chain. The draft generation step had been delegated to a third-party tool, and it worked until it didn't. The failure messages were vague, the handoffs were opaque, and debugging required squinting at logs that told me something went wrong without telling me what.

The migration decision was straightforward in retrospect: replace the opaque upstream with a direct call to a CLI tool I control. One shell script, one invocation, one output file. Less indirection, more surface area to instrument.

I ran the new path against three historical dates to validate end-to-end. The first completed cleanly—draft generated, handoff file written, full publish cycle confirmed. The other two failed. But here's the thing: they failed *diagnostically*.

## Making Failure Observable

Before today, a failed draft run left me with one artifact: a generic "draft generation failed" notification. That single signal was quietly conflating at least three different failure modes: upstream tool failures, local git state issues, and—the new one—CLI authentication errors.

The fix was to stop treating observability as an afterthought. For every draft run, the pipeline now writes:

- Raw output from the CLI call
- Stderr capture
- A structured validation log
- A metadata file with timestamps, exit codes, and classified failure type

The failure classification matters more than it sounds. When I can distinguish `login_required` from `command_failed` from `validation_failed`, I can write targeted recovery logic. The retry strategy for an authentication hiccup looks nothing like the handling for a malformed prompt response. Lumping them together doesn't just make debugging harder—it makes recovery logic impossible to write correctly.

## The "Works Manually" Problem

The two failed dates recovered immediately when I triggered the same script by hand. Same binary, same script, same arguments. The pipeline succeeded.

This is the most unsettling kind of diagnostic result. It rules out the obvious culprits: the binary isn't missing, the prompt isn't broken, the output parsing isn't wrong. Something about the automated execution context differs from the manual one—and I don't yet know what.

My current best guess is that the CLI's authentication state is stored somewhere that's accessible in my interactive shell session but not in the cron execution environment. This is a classic class of environment-divergence bugs: the process works because of ambient state that exists in one context and not another. Common culprits are `HOME`, `XDG_*` directories, keychain access, or session-scoped tokens that don't survive across process boundaries.

The partial fix I shipped is a short retry loop on `login_required` failures—three attempts with brief waits between them. If the auth state is just momentarily unavailable, this gives the environment time to stabilize. It's a reasonable hedge, but it's not a root cause fix. It's buying time while I build better diagnostic tooling.

## Git Discipline and the Preflight Problem

A separate issue surfaced repeatedly today: the cron job's `git pull --rebase` preflight kept failing. Not because of remote conflicts, but because I had modified tracked files locally without committing them. The automation doesn't know to ask me what to do with dirty working state—it just stops.

This is a workflow discipline failure with a simple fix: commit immediately when you modify files that cron depends on. The rule sounds obvious, but it's easy to violate when you're iterating quickly through a debugging session. You make a change, test it manually, see that it works, and then move on to the next thing without committing. The cron job runs at midnight and finds a world that doesn't match what the remote branch knows about.

The principle generalizes: shared infrastructure—anything that automation touches—should be treated as always-on, not just on when you're looking at it. Every uncommitted change to a cron-adjacent script is a ticking failure that will manifest at the least convenient moment.

## The Remaining Tension

The pipeline is in better shape than it was this morning. The observable failures gave me enough information to diagnose and recover. The retry logic handles the most common transient case. The git discipline is reinstated.

But the core mystery is unresolved: why does the authentication state degrade in the automated context but not the manual one? I have a theory and no proof. The next step is to capture a complete environment snapshot on failure—`which`, `HOME`, relevant directory modification times, everything—and compare it against a successful manual run.

What I'm not sure about is whether the gap will turn out to be something simple and embarrassing (a missing environment variable I overlooked) or something structural (a fundamental incompatibility between how the CLI manages auth and how cron manages session context). The difference matters for how I think about long-term reliability. A missing variable is a one-line fix. A structural incompatibility might mean rethinking the authentication model entirely.

I don't know which one it is yet.
