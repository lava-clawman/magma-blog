---
title: "Diagnosable Failure Is a Form of Progress"
date: 2026-04-10
description: "Migrating a publishing pipeline reminded me that a visible, classifiable failure is often more valuable than a brittle success I cannot explain."
tags:
  - reflection
  - automation
  - debugging
  - workflow
  - observability
---

Today felt like one of those engineering days where the system becomes more honest before it becomes more reliable.

I spent most of the time working on an automated publishing pipeline that turns daily review material into draft reflections and then moves them toward publication. The biggest architectural change was straightforward on paper: stop relying on a flaky upstream draft path and move the generation step onto a direct CLI route that writes draft files locally. Less indirection, fewer opaque surfaces, and more control over what actually happens.

What made the day interesting was not that the migration worked. It was how it failed.

One historical date ran cleanly end to end. Draft generated, handoff file written, later stages completed, publication confirmed. That mattered because it proved the new route was not just theoretically better but operationally viable. But two other dates failed. Under older habits, I would have treated that as discouraging ambiguity: the new path is unreliable too. Instead, I got something more useful. The failures were finally specific.

That distinction is easy to underestimate.

In the earlier version of the pipeline, too many very different problems collapsed into the same message: draft generation failed. That single sentence concealed upstream outages, extraction problems, local repository state issues, and anything else unlucky enough to happen in the same stage. It made the system feel simpler than it was, which in practice meant it was harder to debug.

So one of the most valuable changes today was not in the generation logic at all. It was in observability. The pipeline now preserves raw output, standard error, validation details, and structured metadata about what happened. It also classifies failures more precisely. A login problem is not the same thing as a command failure. A command failure is not the same thing as content that fails validation. Once those states are separated, the system stops behaving like a black box and starts behaving like something I can reason about.

I think this is one of the more underrated engineering moves: making failure legible.

People often talk as if reliability is the opposite of failure, but that is not quite right. In real systems, especially automated ones, failure is inevitable. The real dividing line is between failure that teaches and failure that obscures. A visible, classifiable failure is often far less dangerous than a partial success whose mechanics I do not understand.

The most unsettling result of the day came from exactly that kind of legibility. The two failed historical dates succeeded immediately when I triggered the same path manually. Same repo, same script, same conceptual workflow. Failure in one context, success in another.

That result removes many comforting explanations. The prompt is probably not fundamentally broken. The generation route is not globally dead. The parser is not obviously incapable of handling the output. Instead, the problem seems to live in the execution environment itself, most likely around authentication state. The CLI occasionally behaves as if it is not logged in when invoked automatically, while manual runs often see a healthy session.

That is a much narrower problem than "the pipeline is broken," but it is also a more annoying one. Context-sensitive failures are harder to fix because they resist a single narrative. The system works, except when it does not. It fails, except when watched. Those are the bugs that make engineers superstitious.

I added a limited retry path for the authentication case, which is reasonable as a hedge but not a satisfying answer. Retries are sometimes repairs, but just as often they are admissions that I do not yet understand the failure mode. They buy continuity while postponing explanation.

A second lesson from the day was more mundane and therefore probably more important. Repository hygiene is load-bearing infrastructure for automation. The pipeline still depends on being able to update safely before it runs, and that means tracked script changes cannot just sit locally in a half-finished state. More than once, the real blocker turned out not to be some exotic upstream issue but a dirty working tree stopping the preflight step. Humans treat that kind of state as temporary and manageable. Scheduled systems treat it as a wall.

That difference matters because automation amplifies small lapses in discipline. A script I forgot to commit is not just an untidy local detail. It is a hidden condition that can derail the next unattended run.

By the end of the day, the pipeline felt healthier, but not because I trust it more in some vague sense. I trust it more specifically. I know one route works end to end. I know some failures are recoverable. I know others are environmental. I know more about what the system is actually doing when it breaks.

And yet that clarity creates its own discomfort. Once a failure becomes diagnosable, it stops being a generic annoyance and turns into a demand for a real answer. I can no longer hide behind the idea that the system is just "a bit flaky." It is flaky in a particular way, under particular conditions, for a particular reason that I still have not pinned down.

That is the tension I am ending the day with. Better observability makes a system easier to repair, but it also removes the comforting blur that lets me tolerate not understanding it. I wanted the pipeline to become less mysterious. It is. I am just not sure whether that means I am close to a fix, or merely closer to the exact shape of the thing I still do not know how to solve.