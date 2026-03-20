#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function todayIso() {
  return new Date().toISOString().slice(0, 10);
}

function writeIfMissing(filePath, content) {
  if (!fs.existsSync(filePath)) {
    fs.writeFileSync(filePath, content, 'utf8');
  }
}

const date = process.argv[2] || todayIso();
const repoRoot = process.cwd();
const artifactDir = path.join(repoRoot, 'artifacts', date);
const blogPath = path.join(repoRoot, 'src', 'content', 'blog', `${date}-reflection.md`);

ensureDir(artifactDir);
ensureDir(path.dirname(blogPath));

const files = {
  source: path.join(artifactDir, 'source.md'),
  questions: path.join(artifactDir, 'questions.md'),
  answers: path.join(artifactDir, 'answers.md'),
  improvementDecision: path.join(artifactDir, 'improvement-decision.md'),
  run: path.join(artifactDir, 'run.json'),
};

writeIfMissing(files.source, `# Source Material\n\n## Summary\n- TODO\n\n## Reflection Seed\n- TODO\n\n## Optional Supporting Notes\n- TODO\n\n## Privacy Notes\n- TODO\n`);
writeIfMissing(files.questions, '# Questions\n\n1. TODO\n');
writeIfMissing(files.answers, '# Answers\n\n## Q1. TODO\n\n### Evidence\n- TODO\n\n### Interpretation\nTODO\n\n### Exposed Weakness\nTODO\n\n### Possible Improvement\nTODO\n\n### Unresolved Tension\nTODO\n');
writeIfMissing(files.improvementDecision, '# Improvement Decision\n\n## Summary\n- class: none\n- rationale: TODO\n\n## Evaluated Findings\n1. Finding: TODO\n   - class: none\n   - target: none\n   - action: not-updated\n   - reason: TODO\n');
writeIfMissing(blogPath, `---\ntitle: \"TODO\"\ndate: ${date}\ndescription: \"TODO\"\ntags: [\"reflection\"]\ndraft: true\n---\n\n## Spark\n\nTODO\n`);

const runRecord = {
  date,
  sourcePaths: [],
  artifacts: {
    source: path.relative(repoRoot, files.source),
    questions: path.relative(repoRoot, files.questions),
    answers: path.relative(repoRoot, files.answers),
    improvementDecision: path.relative(repoRoot, files.improvementDecision),
  },
  publishPath: path.relative(repoRoot, blogPath),
  privacyCheck: {
    status: 'pending',
    notes: [],
  },
  improvement: {
    status: 'pending',
    class: 'none',
  },
  status: 'initialized',
};

fs.writeFileSync(files.run, `${JSON.stringify(runRecord, null, 2)}\n`, 'utf8');

console.log(JSON.stringify({
  ok: true,
  date,
  artifactDir: path.relative(repoRoot, artifactDir),
  publishPath: path.relative(repoRoot, blogPath),
}, null, 2));
