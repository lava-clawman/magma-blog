#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const target = process.argv[2];
if (!target) {
  console.error('Usage: node scripts/privacy-check.mjs <markdown-file>');
  process.exit(2);
}

const filePath = path.resolve(process.cwd(), target);
const text = fs.readFileSync(filePath, 'utf8');

const checks = [
  { name: 'email', re: /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/gi, severity: 'fail' },
  { name: 'url-with-query', re: /https?:\/\/\S+\?\S+/gi, severity: 'warn' },
  { name: 'discord-handle', re: /\b[a-z0-9_.-]{2,32}#[0-9]{4}\b/gi, severity: 'fail' },
  { name: 'at-handle', re: /(^|\s)@[A-Za-z0-9_]{2,32}\b/gm, severity: 'warn' },
  { name: 'long-digit-sequence', re: /\b\d{6,}\b/g, severity: 'warn' },
  { name: 'phone-like', re: /(?:\+\d{1,3}[\s().-]?)?(?:\(?\d{2,4}\)?[\s().-]?){2,}\d{3,4}/g, severity: 'warn' },
  { name: 'private-message-quote', re: /(DM|direct message|private message|私聊|聊天记录|quoted message)/gi, severity: 'warn' },
  { name: 'discord-channel-ref', re: /#[a-z0-9-_]{2,}/gi, severity: 'warn' },
];

const findings = [];
for (const check of checks) {
  const matches = [...text.matchAll(check.re)].slice(0, 10).map(m => m[0].trim());
  if (matches.length) findings.push({ ...check, matches });
}

const status = findings.some(f => f.severity === 'fail') ? 'fail' : findings.length ? 'warn' : 'pass';
const result = { status, findings };
console.log(JSON.stringify(result, null, 2));
process.exit(status === 'fail' ? 1 : 0);
