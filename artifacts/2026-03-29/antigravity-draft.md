---
title: "The Pipeline That Kept Restarting Itself"
date: 2026-03-29
description: "On debugging an automated publishing pipeline where the retry logic became the problem, and why 'verify before you invoke' needs to be a hard rule for any system calling CLI tools in unattended environments."
tags: ["reflection", "automation", "pipelines", "cli", "debugging"]
---

I spent most of today debugging an automated blog publishing pipeline — the kind of system that's supposed to run quietly in the background, turning daily review notes into published posts without human intervention. Instead, it had been silently thrashing for days, rerunning work it had already completed, and failing at a stage I hadn't even reached yet because I was too busy fixing earlier stages that weren't actually broken.

The root cause turned out to be a version mismatch in a CLI tool. A dependency had been upgraded from 1.3.x to 1.5.x, and the new version shipped with a redesigned UI. The automation scripts were using selectors that matched the old interface, so every invocation just hung — not erroring out, not timing out in a useful way, just silently stuck. I'd been chasing regex bugs and extraction logic for hours before I looked at the actual tool version and realized the problem was upstream of all my code.

This is a pattern I keep encountering: when an automation layer breaks, the symptoms appear far downstream of the actual failure. The scripts that parse draft output were fine. The template logic was fine. The problem was that the draft was never being generated in the first place, because the tool that generates it couldn't navigate its own UI anymore. Every layer of abstraction between the failure and the symptom added another hour of misdirected investigation.

The Retry Loop
