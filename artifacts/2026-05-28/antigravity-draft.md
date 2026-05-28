---
title: "On CLI Lies, Job Title Drift, and the Memory You Never Wrote"
date: 2026-05-28
description: "Three small system failures from one day's work: a CLI that exists but can't do what you assume, a job title that doesn't describe the job, and a memory layer that only works when you're already paying attention."
tags: ["reflection", "systems", "job-search", "second-brain", "workflow"]
---

There's a particular failure mode I keep bumping into: I assume a tool can do something because I know the tool exists. Today it was a database CLI. The local version was installed and working fine for local containers. I reached for it to restore a paused cloud project, and it simply... didn't apply. The subcommand wasn't available for cloud management at this version. The tool was present. The capability wasn't.

This is different from a broken tool. A broken tool announces itself. A tool with silently scoped capabilities just does nothing useful while you spend time figuring out why. The lesson isn't "always read the docs first" — I had read the docs, or thought I had. The lesson is closer to: **command existence is not capability confirmation**. Before treating a CLI as the solution to a cloud-side problem, I should have verified: does this specific subcommand work against the cloud, or only locally? That's a thirty-second check. I skipped it.

---

The job search pipeline threw up a different problem today. A role came in labeled "full stack developer." I almost routed it into my standard frontend-weighted analysis queue. But when I actually read the job description — not the title, the body — the picture was different: backend-heavy, data infrastructure focus, utility platform work. The title was almost incidental.

Job titles in small-to-mid-sized companies are frequently aspirational or inherited from whatever the hiring manager typed into the HR system three years ago. The actual shape of the work lives in the responsibilities section, sometimes in the "nice to have" list, occasionally in a throwaway sentence near the bottom. I've built a process for evaluating roles, but that process implicitly trusts that the title tells me something true about the role. It doesn't always.

What I'm working toward: treat the title as a signal to open the file, not as a classification. The real classification happens after reading the full JD, and when title and responsibilities diverge significantly, that divergence itself is information — about the company's self-image, about the actual seniority level needed, about what they think they're hiring versus what they need.

---

The third failure was quieter. At the end of the day's review, I noticed that my daily summary was drawing almost entirely from the active session — what happened in front of me, in the windows I had open. There was no independent memory log from earlier in the day. The second brain I've been building only captured what I'd explicitly written down in the moment. Which, today, wasn't much.

This is the core tension in any personal knowledge system: the moments when you most need captured memory are exactly the moments when you're too busy to write anything down. You're in the middle of debugging something, or on a call, or making a decision under time pressure. The write-up happens later, if it happens at all. But "later" is when session context is already fading.

I've tried to solve this with end-of-day reviews, and they help. But they work best as *consolidation* of notes taken throughout the day, not as a replacement for them. When I skip the in-the-moment notes, the end-of-day review becomes reconstruction from memory rather than synthesis from sources. Reconstruction is lossy in ways I can't always detect — I don't know what I forgot to include.

The email review system I've been running has actually gotten this right in a way the rest of my workflow hasn't. It maintains a state file that persists between sessions, reads it before processing, and writes back to it afterward. Deduplication is handled structurally, not by me trying to remember what I already looked at. I should be applying that same pattern more broadly: more state files, fewer assumptions that I'll remember what I decided two hours ago.

---

What I haven't resolved: the gap between the systems I've built and the habits required to use them correctly. I can architect a second brain with all the right components — daily logs, state tracking, memory files, review cadences. But the system only works if I actually write to it at the right moments. And those moments tend to arrive when I'm least inclined to stop and document.

There's no architectural fix for that. The pipeline can't force me to write the note. It can only make the note easier to write. I keep trying to design around the gap, and I keep finding that the gap is still there, just slightly relocated.
