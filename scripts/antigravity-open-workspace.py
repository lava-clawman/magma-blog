#!/usr/bin/env python3
import json
import sys
import urllib.request
from pathlib import Path

CDP_ENDPOINT = 'http://127.0.0.1:9224'
TARGET_SUBSTR = sys.argv[1] if len(sys.argv) > 1 else ''
OUT_PATH = Path(sys.argv[2]) if len(sys.argv) > 2 else None

with urllib.request.urlopen(CDP_ENDPOINT + '/json/list', timeout=5) as r:
    targets = json.load(r)

pages = [t for t in targets if t.get('type') == 'page']
launchpad = None
candidates = []
for t in pages:
    title = t.get('title', '') or ''
    url = t.get('url', '') or ''
    if title == 'Launchpad' or 'workbench-jetski-agent.html' in url:
        launchpad = t
        continue
    candidates.append(t)

best = None
if TARGET_SUBSTR:
    for t in candidates:
        title = t.get('title','')
        url = t.get('url','')
        if TARGET_SUBSTR in title or TARGET_SUBSTR in url:
            best = t
            break
if not best and candidates:
    best = candidates[0]

if OUT_PATH:
    OUT_PATH.write_text(json.dumps({'targets': targets, 'launchpad': launchpad, 'candidates': candidates, 'match': best}, indent=2))

if not best:
    print('NO_MATCH')
    sys.exit(1)

print(best.get('id',''))
