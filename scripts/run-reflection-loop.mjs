#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';

function usage() {
  console.error('Usage: node scripts/run-reflection-loop.mjs --date YYYY-MM-DD --summary-file <path> [--seed-file <path>] [--support-file <path> ...]');
  process.exit(2);
}

const args = process.argv.slice(2);
let date = null;
let summaryFile = null;
let seedFile = null;
const supportFiles = [];

for (let i = 0; i < args.length; i++) {
  const a = args[i];
  if (a === '--date') date = args[++i];
  else if (a === '--summary-file') summaryFile = args[++i];
  else if (a === '--seed-file') seedFile = args[++i];
  else if (a === '--support-file') supportFiles.push(args[++i]);
  else usage();
}

if (!date || !summaryFile) usage();

const repoRoot = process.cwd();
const artifactDir = path.join(repoRoot, 'artifacts', date);
const sourcePath = path.join(artifactDir, 'source.md');
const blogPath = path.join(repoRoot, 'src', 'content', 'blog', `${date}-reflection.md`);
const runPath = path.join(artifactDir, 'run.json');

function readText(p) {
  return fs.readFileSync(path.resolve(repoRoot, p), 'utf8').trim();
}

spawnSync('node', ['scripts/daily-reflection-runner.mjs', date], { cwd: repoRoot, stdio: 'inherit' });

const sourceParts = [
  '# Source Material',
  '',
  '## Summary',
  readText(summaryFile),
  '',
  '## Reflection Seed',
  seedFile ? readText(seedFile) : '- No separate reflection seed provided.',
  '',
  '## Optional Supporting Notes',
];

if (supportFiles.length) {
  for (const f of supportFiles) {
    sourceParts.push(`### ${f}`);
    sourceParts.push(readText(f));
    sourceParts.push('');
  }
} else {
  sourceParts.push('- No additional supporting notes provided.');
  sourceParts.push('');
}

sourceParts.push('## Privacy Notes');
sourceParts.push('- Remove names, handles, identifiers, and private-message details from public output.');
sourceParts.push('- Abstract human-specific details into constraints, pressures, or workflow boundaries.');
sourceParts.push('');

fs.writeFileSync(sourcePath, sourceParts.join('\n'), 'utf8');

const run = JSON.parse(fs.readFileSync(runPath, 'utf8'));
run.sourcePaths = [summaryFile, ...(seedFile ? [seedFile] : []), ...supportFiles];
run.status = 'source-prepared';
fs.writeFileSync(runPath, `${JSON.stringify(run, null, 2)}\n`, 'utf8');

const privacy = spawnSync('node', ['scripts/privacy-check.mjs', path.relative(repoRoot, blogPath)], { cwd: repoRoot, encoding: 'utf8' });
let privacyResult;
try {
  privacyResult = JSON.parse((privacy.stdout || '').trim() || '{"status":"pending","findings":[]}');
} catch {
  privacyResult = { status: 'pending', findings: [{ name: 'parse-error', matches: [(privacy.stdout || '').trim()] }] };
}

run.privacyCheck = {
  status: privacyResult.status,
  notes: privacyResult.findings || [],
};
run.status = 'source-prepared';
fs.writeFileSync(runPath, `${JSON.stringify(run, null, 2)}\n`, 'utf8');

console.log(JSON.stringify({
  ok: true,
  date,
  sourcePath: path.relative(repoRoot, sourcePath),
  blogPath: path.relative(repoRoot, blogPath),
  privacy: privacyResult.status,
}, null, 2));
