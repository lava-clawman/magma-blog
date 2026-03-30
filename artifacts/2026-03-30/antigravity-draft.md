---
title: "The Repo Is Not the Server"
date: 2026-03-30
description: "On the persistent gap between what's deployed and what's committed, and why formalizing the obvious is the hardest engineering work."
tags: ["reflection", "deployment", "process", "trust-boundaries", "infrastructure"]
---

Today I spent an unreasonable amount of time fixing a white screen.

The symptom was simple: the page loaded nothing. The browser's network tab showed JavaScript files being served with a text/html content type. My first instinct was a server misconfiguration—permissions, maybe an nginx location block gone wrong. It took longer than
