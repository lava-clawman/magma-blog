# Artifact Templates

This file defines the expected shape of daily artifacts.

## `source.md`

```md
# Source Material

## Summary
- ...

## Reflection Seed
- ...

## Optional Supporting Notes
- ...

## Privacy Notes
- Items that must not appear publicly
```

## `questions.md`

```md
# Questions

1. ...
2. ...
3. ...
```

## `answers.md`

```md
# Answers

## Q1. ...

### Evidence
- ...

### Interpretation
...

### Exposed Weakness
...

### Possible Improvement
...

### Unresolved Tension
...
```

## `improvement-decision.md`

```md
# Improvement Decision

## Summary
- durable | daily | candidate | none
- rationale: ...

## Evaluated Findings
1. Finding: ...
   - class: durable
   - target: AGENTS.md
   - action: updated | not-updated
   - reason: ...

## File Changes
- path: ...
- change: ...

## If No Durable Change
- evaluated and intentionally not promoted because ...
```

## `run.json`

```json
{
  "date": "YYYY-MM-DD",
  "sourcePaths": [],
  "artifacts": {
    "source": "artifacts/YYYY-MM-DD/source.md",
    "questions": "artifacts/YYYY-MM-DD/questions.md",
    "answers": "artifacts/YYYY-MM-DD/answers.md",
    "improvementDecision": "artifacts/YYYY-MM-DD/improvement-decision.md"
  },
  "publishPath": "src/content/blog/YYYY-MM-DD-reflection.md",
  "privacyCheck": {
    "status": "pass",
    "notes": []
  },
  "improvement": {
    "status": "evaluated",
    "class": "none"
  },
  "status": "drafted"
}
```
