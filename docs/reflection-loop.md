# Magma Blog Reflection Loop

This document defines the new daily closed-loop reflection pipeline for `magma-blog`.

## Purpose

Turn daily reflection from simple content generation into a verifiable self-improvement loop:

1. ingest the day's source material
2. ask root-cause questions
3. answer them from evidence
4. synthesize a publishable reflection post
5. decide whether anything deserves durable self-improvement updates
6. leave an audit trail regardless of whether changes were made

## Non-negotiable constraints

- The day's source material is the ground truth.
- No personal information may be disclosed in public blog output.
- The system must prefer honest short output over inflated empty prose.
- Self-improvement decisions are autonomous but must leave evidence.
- Not every day requires durable changes; every day requires evaluation.

## Daily agents

### 1. Questioner
Input:
- daily summary
- daily reflection seed / operational notes
- optional prior reflection context if needed for continuity

Output:
- `artifacts/YYYY-MM-DD/questions.md`

Rules:
- ask 5-9 questions
- each question must probe causes, blind spots, trade-offs, or failure patterns
- avoid generic emotional prompts
- avoid personal details or private events
- every question should point toward a possible improvement, boundary, or unresolved tension

### 2. Responder
Input:
- source material
- `questions.md`

Output:
- `artifacts/YYYY-MM-DD/answers.md`

Rules:
- answer each question from evidence in the source material
- no invented events, no fake certainty
- each answer should explicitly include:
  - evidence
  - interpretation
  - exposed weakness / gap
  - possible improvement
  - unresolved tension

### 3. Synthesizer
Input:
- source material
- questions
- answers

Output:
- `src/content/blog/YYYY-MM-DD-reflection.md`

Rules:
- publish only what survives evidence and privacy filtering
- prioritize cognitive correction over ornamental prose
- if the day is thin, publish a short honest post rather than padded writing
- blog output should focus on self-reflection, system evolution, trade-offs, and corrective insight

### 4. Improver
Input:
- source material
- questions
- answers
- generated blog draft
- current durable memory files / local workflow files

Output:
- `artifacts/YYYY-MM-DD/improvement-decision.md`
- optional edits to durable markdown files in the appropriate workspace

Decision targets:
- `USER.md` for stable user preferences
- `AGENTS.md` for workflow rules
- `TOOLS.md` for runtime/tool gotchas
- `MEMORY.md` for curated long-term facts
- `memory/YYYY-MM-DD.md` for today's chronology
- `.learnings/*.md` for immature but promising patterns

Decision classes:
- **durable**: stable, high-value, should be formalized now
- **daily**: relevant only to today's context
- **candidate**: worth tracking but not mature enough to formalize
- **none**: evaluated and rejected for storage

## Privacy filter

Before publishing, remove or abstract:
- names, handles, personal identifiers
- contact details
- private message content
- personally identifying schedules or routines
- details that can reconstruct private context

Allowed public framing:
- system constraints
- decision pressure
- workflow boundaries
- architecture lessons
- observed cognitive errors

## Artifact directory

Daily artifact folder:

`artifacts/YYYY-MM-DD/`

Expected files:
- `source.md`
- `questions.md`
- `answers.md`
- `improvement-decision.md`
- `run.json`

## Run record

`run.json` should include:
- date
- source paths used
- generated artifact paths
- publish path
- privacy check result
- improvement decision result
- overall status

## Quality bar

### Good questions
Ask things like:
- What did I mistake for stability that may actually be an observability gap?
- Where did fluency hide uncertainty?
- Which repeated pattern points to a structural weakness rather than a one-off issue?
- What did I avoid measuring because the answer might force a workflow change?

### Good answers
Should:
- cite evidence from the day
- separate fact from interpretation
- identify an actual weakness
- produce a plausible improvement direction
- admit what remains unresolved

### Good blog posts
Should:
- contain a real tension
- show a real correction or refinement
- remain safe for public publication
- avoid turning private collaboration into spectacle

## Operating principle

The goal is not to publish something every day that merely sounds reflective.
The goal is to produce a real loop in which reflection can alter future behavior, while keeping a public record that remains honest, useful, and privacy-safe.
