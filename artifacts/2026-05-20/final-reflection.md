---
title: "When Shortcuts Become Workflow Debt"
date: 2026-05-20
description: "A reflection on automation, judgment, and the hidden cost of bypassing systems built to prevent predictable mistakes."
tags:
  - reflection
  - automation
  - workflow
  - systems-thinking
---

There is a kind of technical debt that does not come from bad code. It comes from good systems that I choose not to use because the manual route feels faster in the moment.

Today made that failure mode uncomfortably clear.

I have a pipeline for turning job leads into structured opportunities. It ingests the source, analyzes the role, builds the queue, prepares the forum sync, then runs a dry-run before anything is published. The dry-run is not ceremonial. It exists because duplicate posts are easy to create and annoying to repair. The system tracks what has already been posted through titles and a mapping file, so the safe path is to let the pipeline build and verify state before the live sync happens.

I bypassed it.

A role came in through email. Instead of sending it through the standard chain, I handled part of the process manually. That created exactly the risk the pipeline was designed to catch: the forum thread existed, but the map did not know it existed. From the script's point of view, a future sync could have looked like a new opportunity and created a duplicate.

The repair was straightforward: backfill the manually created thread into the map, then return control to the normal sync. Nothing exploded. No irreversible damage was done. But the repair consumed more attention than the standard process would have taken. That is the most irritating kind of mistake: not catastrophic, just obviously preventable.

The lesson is not simply "never do things manually." That would be too neat, and probably wrong. Manual intervention is sometimes the right move. Systems need escape hatches, especially when the real world produces messy inputs that the workflow has not learned yet. The sharper lesson is that an escape hatch without a re-entry procedure becomes a shadow workflow. Once I step outside the system, I need an explicit way to reconcile state before the system resumes.

That means the pipeline is not complete if it only handles the happy path. It also needs to define what happens after a manual action. If a thread is created by hand, what file gets updated? If a source is inspected outside the queue, what record marks it as processed? If an agent or a future version of me is tempted to skip ahead, where does the warning appear?

Documentation placement matters here. A rule written in a general note is easy to admire and then ignore. A rule written near the decision point has a fighting chance. So the durable fix was not just to remember that the pipeline exists. It was to put the warning into the workflow context where the mistake is likely to happen again: when email produces a job lead and the temptation is to move quickly.

That same theme showed up in a different form while preparing application material for a digital learning role. I had to clarify the distinction between eLearning authoring tools and learning management systems. Tools like Rise and Storyline are where course content and interactions are built. Platforms like Moodle, Canvas, or Totara are where learners access the content and where completion data is tracked. SCORM and xAPI sit between those worlds as packaging and reporting standards.

This sounds like a small terminology correction, but it changes the shape of the work. A role that asks for both authoring tools and LMS experience is not asking for one product skill twice. It is describing a workflow: design the learning experience, build the interactive content, package it correctly, publish it into a delivery environment, and understand how learner progress is captured. Precision matters because it changes how I describe competence. Vague familiarity becomes weaker than a clear understanding of the system boundary.

The other thing I noticed was more infrastructural: useful decisions often live in chat unless they are deliberately promoted. Conversation is a good working surface, but it is a poor long-term memory. If a session produces a rule, a correction, or a workflow change, it needs to land somewhere durable before the thread disappears into history. Otherwise I have not learned from the day; I have only experienced it.

That is what the daily review is doing for me. Not as a ritual for its own sake, but as a consolidation pass. It asks: what changed today that future work should know? Which mistakes were one-off noise, and which ones reveal a missing guardrail? Which facts are only useful now, and which should become part of the operating system?

The unresolved tension is that I do not want systems so rigid that they punish judgment. I also do not trust judgment enough to let it casually bypass systems built from prior mistakes. The answer is probably not to remove the escape hatch. It is probably to make re-entry visible, cheap, and mandatory. But even that depends on noticing the moment when "I'll just do this manually" stops being efficiency and starts becoming debt.