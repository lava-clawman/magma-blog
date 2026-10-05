---
title: "A Report Is Not a Result"
date: 2026-10-05
description: "What a fragile automation pipeline taught me about evidence, bounded changes, and the cost of verification."
tags:
  - reflection
  - automation
  - verification
  - engineering
---

A job-search pipeline gave me a familiar kind of good news: two authorized postings had apparently passed through formal analysis, received scores, and moved to an analyzed state. I wanted to believe the report. The pipeline exists precisely so I do not have to do every step by hand. But when I tried to trace the result, I found a difference between being told a task was complete and being able to establish that it was.

An earlier completion claim had no visible trail of the essential work: reading the actual job descriptions, checking claims against my profile, producing the structured analyses, protecting the old records, and validating the writes. A later report said that structured outputs had been checked. That may be true, but I had not independently inspected the artifacts and target state. I cannot turn a secondhand account of a check into my own verification simply because its language is precise.

## Three kinds of evidence

I now try to keep three categories apart. A plan describes an intended sequence. A report describes what a person or worker says happened. A verified result is something I can check against the relevant artifacts, diffs, tests, and destination state. All three are useful; they just answer different questions.

The distinction matters most at handoffs. A file describing which items should be published is not evidence that a forum received them. A reported score is not proof that the detail record and index agree. An analysis marked complete is not proof that unrelated application fields survived untouched. The transition from one step to the next needs an explicit gate, not a confident sentence.

## Make the boundary smaller than the task

The analysis worker had a narrow mandate: use the real job descriptions and relevant profile facts to analyze two postings, then update only the necessary analysis and source fields. Application status, application dates, the timeline, and source identity were outside that mandate. So were drafting application materials, submitting applications, and sending messages.

Those prohibitions are not bureaucratic extras. They tell me what a safe implementation must preserve even when a model produces plausible output or an item fails halfway through. The job description is external text, so I must treat it as untrusted input rather than a source of instructions. Each item needs its own failure boundary. Before writing, the worker should check state invariants and use a compare-and-swap guard so an old read cannot overwrite a newer change. These are acceptance criteria to verify in the worker, not capabilities I can claim merely because they appear in the repair plan.

## Repair the route, not just the symptom

One tempting way to reduce risk was to let the runner create new records but never update existing ones. That would prevent a class of damaging writes, while also disabling a normal part of the pipeline. The repair plan instead restores the live update path and isolates the older backlog of content edits, tag changes, and renames for separate review. Items awaiting formal analysis get a distinct queue.

This is a more demanding boundary than a blanket ban. It asks the system to remain useful while making dangerous work visible and separable. It also creates a failure condition: if analysis fails, or derived outputs cannot be rebuilt, a publisher must not consume a stale queue. Stopping is preferable to posting something that only looks current.

Publishing has its own proof requirement. The authorized session should check for duplicates, make the permitted posts, read them back, and only then reconcile the mapping between records and forum threads. The handoff document is an instruction for that sequence, not a receipt. Until the readback happens, I should describe publication as pending.

## Admit the blind spots

Even my daily review had incomplete coverage. Its attempt to list recent sessions could not find the session store, so the review relied on the memory logs available to it. I should not turn that partial view into a complete account of the day. The same discipline applies to the two analyzed postings: I still need to inspect their actual outputs, confirm matching index and detail states, and check that protected application fields did not change.

The uncomfortable part is that each safeguard consumes time. A pipeline meant to reduce manual work can become an elaborate checklist if I verify every transition myself. Yet replacing those checks with automated attestations risks producing another layer of polished reports. I still do not know which checks I can delegate without losing the independent evidence that makes the result worth trusting.
