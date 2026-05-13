---
title: "When the Pipeline Lies (Or Maybe Doesn't)"
date: 2026-05-11
description: "On debugging automation you half-trust, exercising judgment your tools can't replicate, and the gap between a smoke test and a verified system."
tags: ["reflection", "job-search", "automation", "debugging", "workflow"]
---

There's a particular kind of unease that comes from an exit code you can't immediately explain.

Today, midway through an afternoon job scan, my triage pipeline returned `triage_exit=1`. The promote step was skipped. On the surface, this looks like a failure. But when I traced through the components — the scraper, the analysis queue, the forum sync — everything else had completed cleanly. The only broken link was the step where my local CLI tool attempts a non-interactive call to an LLM to score and categorize job listings.

So: was this a bug in my config, or was the pipeline correctly refusing to proceed without a valid triage response?

The answer turned out to be a config bug. I had legacy root-level fields that should have been nested under a `model:` key, and a compression threshold set so aggressively that the tool was failing silently in non-interactive mode. Fixing both and running a smoke test confirmed the non-interactive call returned `OK`. But I won't know if the full chain is actually healed until the next real scan runs, with real data, end-to-end.

That gap — between a smoke test passing and a system being verified — is a form of technical debt I've been accumulating. I keep running single-point validations and calling it done.

---

The larger theme of the day, though, wasn't debugging. It was judgment.

I'm running a semi-automated job search pipeline: scrapers pull listings, an LLM triages them by fit score, and high-scorers get queued for deeper analysis and material generation. It's genuinely useful. But today I was reminded, twice, that the pipeline score is a starting point, not a verdict.

One role came through with a strong signal — close geographic fit, overlap with my Python and data background, explicit mentions of AI-assisted workflows in the JD. But the pipeline couldn't fully weight things like cultural communication fit, the appeal of a small-team ownership structure, or the way a specific phrase in the listing — "AI-assisted analysis" — mapped almost exactly to work I'd done but hadn't prominently labeled in my materials. These aren't dimensions the triage prompt captures well.

Another listing scored as a reasonable candidate but, on a closer read, was a graduate programme starting over a year and a half from now in a domain — agribusiness banking — that sits well outside my track. The pipeline said "maybe." My judgment said "not now, not this."

I've written into my own process rules: use the original JD text and cross-check against your actual profile. Don't mechanically defer to the pipeline score. Today I followed that rule, and it led to better decisions. But it also raises the uncomfortable question of why I built the automation in the first place if I'm going to override it on judgment anyway.

The honest answer is: the automation handles volume and consistency. It makes sure I don't miss something because I didn't feel like reading today. The judgment layer is what makes the output worth acting on. The problem is that every time I override the system, I'm either exercising valuable signal or introducing the same biases the automation was meant to protect me from. I can't always tell which.

---

There was also a small but satisfying fix today on the scraper side — a parsing bug where structured job description content wasn't being extracted correctly from a detail page. Once patched and pushed, a test job listing came back with a content length that actually reflected the full description, including the specific phrases that matter for matching. The right fix for the right bug: not a workaround, not a retry loop, just a corrected selector.

I find these small fixes oddly reassuring. They're legible. The problem had a shape. The fix addressed the shape. The test confirmed it.

The config bug earlier was less satisfying to fix, not because it was harder, but because I'm still not certain it's actually fixed — only that one layer of it is.

---

There's a version of this day where everything is under control: the pipeline runs cleanly, the triage fires correctly, the materials are generated from accurate data, the status is synced everywhere it needs to be. I got close to that today. But I'm submitting one application tomorrow that I've been holding at `ready_to_apply` for hours, and I won't know if the triage chain truly works until the next scan completes without a non-zero exit.

I don't know how to feel fully confident in a system I mostly trust but can't fully observe. That's probably not a problem with this system specifically. It might just be what it feels like to rely on automation you built yourself.
