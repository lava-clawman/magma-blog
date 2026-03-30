#!/usr/bin/env python3
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path('/Users/lab/Flash-Claude/projects/magma-blog')
OPENCLAW_BIN = Path('/Users/lab/.local/bin/openclaw')
CHANNEL_TARGET = 'channel:1484517576985022545'
LOCK_DIR = ROOT / '.locks'
LOCK_DIR.mkdir(exist_ok=True)


def run(cmd, **kwargs):
    return subprocess.run(cmd, text=True, capture_output=True, **kwargs)


def notify(text: str) -> None:
    run([
        str(OPENCLAW_BIN), 'message', 'send',
        '--channel', 'discord',
        '--target', CHANNEL_TARGET,
        '--message', text,
    ], timeout=20)


def write_state(path: Path, payload: dict) -> None:
    path.write_text(json.dumps(payload, indent=2) + '\n')


def main() -> int:
    if len(sys.argv) < 2:
        print('Usage: orchestrate-reflection-finalization.py <date>', file=sys.stderr)
        return 2

    date = sys.argv[1]
    artifact_dir = ROOT / 'artifacts' / date
    ready_file = artifact_dir / 'draft-ready.json'
    draft_file = artifact_dir / 'antigravity-draft.md'
    final_file = artifact_dir / 'final-reflection.md'
    review_file = artifact_dir / 'source-review.sanitized.md'
    improvement_file = artifact_dir / 'improvement-decision.md'
    blog_file = ROOT / 'src' / 'content' / 'blog' / f'{date}-reflection.md'
    result_file = artifact_dir / 'subagent-result.txt'
    success_flag = artifact_dir / '.success-notified'
    publish_state = artifact_dir / 'publish-complete.json'
    final_state = artifact_dir / 'final-ready.json'
    lock_file = LOCK_DIR / f'orchestrate-{date}.lock'

    if lock_file.exists():
        print(f'orchestrator lock exists: {lock_file}')
        return 0
    lock_file.write_text('running\n')
    try:
        if publish_state.exists() or success_flag.exists() or blog_file.exists() and final_file.exists():
            print(f'publish already complete for {date}')
            return 0
        if not ready_file.exists():
            print(f'draft-ready.json missing: {ready_file}', file=sys.stderr)
            return 1
        if not draft_file.exists():
            print(f'draft missing: {draft_file}', file=sys.stderr)
            return 1
        if not review_file.exists():
            print(f'sanitized review missing: {review_file}', file=sys.stderr)
            return 1

        if not final_file.exists():
            task = f'''In the current working directory, read {review_file} and {draft_file}. CRITICAL: You MUST use the `write` tool to save a clean final article directly to the file {final_file} with valid YAML frontmatter for date {date}.\n\nRequirements:\n- The Antigravity draft is only a rough draft; improve structure, clarity, and precision.\n- Produce a clean final article for publication, not notes about the process.\n- Use first-person voice.\n- 500-900 words.\n- Remove private identifiers, handles, email addresses, and overly specific personal traces.\n- Focus on durable workflow / judgment / system / engineering lessons.\n- End with an unresolved tension, not a neat conclusion.\n- Write valid markdown with valid YAML frontmatter in this exact shape:\n---\ntitle: \"...\"\ndate: {date}\ndescription: \"...\"\ntags:\n  - reflection\n  - ...\n---\n\n[body]\n\nCRITICAL RULE: Do NOT output the article text in your chat response. You must use the `write` tool to save it. After successfully writing the file using the tool, reply to the user with exactly FINAL_WRITTEN.\n'''
            notify(f'magma-blog 终稿编排开始（{date}）\n- 已检测到 draft-ready.json\n- 正在触发 worker-general 生成 final-reflection.md。')
            proc = run([
                str(OPENCLAW_BIN), 'agent',
                '--agent', 'worker-general',
                '--session-id', f'finalize-{date}',
                '--message', task,
                '--timeout', '600',
                '--json',
            ], cwd=ROOT, timeout=900)
            result_file.write_text((proc.stdout or '') + '\n' + (proc.stderr or ''))
            if proc.returncode != 0:
                notify(f'magma-blog 终稿编排失败（{date}）\n- worker-general 运行返回非 0\n- 详见 artifacts/{date}/subagent-result.txt')
                return proc.returncode
            if 'FINAL_WRITTEN' not in (proc.stdout or ''):
                notify(f'magma-blog 终稿编排失败（{date}）\n- worker-general 未返回 FINAL_WRITTEN\n- 详见 artifacts/{date}/subagent-result.txt')
                return 1
            if not final_file.exists() or final_file.stat().st_size == 0:
                notify(f'magma-blog 终稿编排失败（{date}）\n- final-reflection.md 未生成\n- 详见 artifacts/{date}/subagent-result.txt')
                return 1
            write_state(final_state, {'date': date, 'stage': 'final_ready', 'final_file': str(final_file)})

        blog_file.write_text(final_file.read_text())

        if not (ROOT / 'node_modules' / '.bin' / 'astro').exists():
            install = run(['npm', 'ci'], cwd=ROOT, timeout=1200)
            if install.returncode != 0:
                notify(f'magma-blog 正式发布失败（{date}）\n- npm ci 失败')
                return install.returncode

        privacy = run(['node', 'scripts/privacy-check.mjs', str(blog_file)], cwd=ROOT, timeout=120)
        if privacy.returncode != 0:
            notify(f'magma-blog 正式发布失败（{date}）\n- privacy check 未通过')
            return privacy.returncode

        improvement_file.write_text(f'''# Improvement Decision\n\n## Verdict\nPARTIAL\n\n## Promoted Insights\n- TOOLS.md: Antigravity is a draft source, not the final publication authority.\n- TOOLS.md: Final publishable reflection content is generated by a dedicated agent authoring stage before scripted release.\n\n## Rationale\nThe pipeline now separates exploratory drafting from final publication writing, while keeping release steps deterministic and fully automated.\n\n## Trace\n- Source: {review_file}\n- Draft: {draft_file}\n- Final: {final_file}\n- Final agent: worker-general\n''')

        build = run(['npm', 'run', 'build'], cwd=ROOT, timeout=900)
        if build.returncode != 0:
            notify(f'magma-blog 正式发布失败（{date}）\n- build 失败')
            return build.returncode

        git_add = run([
            'git', 'add',
            str(blog_file),
            str(improvement_file),
            str(ready_file),
            str(draft_file),
            str(final_file),
            str(result_file),
            str(review_file),
            str(artifact_dir / 'source-review.md'),
            str(artifact_dir / 'antigravity-read.json'),
            str(artifact_dir / 'antigravity-hints.txt'),
            str(final_state),
        ], cwd=ROOT, timeout=120)
        if git_add.returncode != 0:
            notify(f'magma-blog 正式发布失败（{date}）\n- git add 失败')
            return git_add.returncode

        diff = run(['git', 'diff', '--cached', '--quiet'], cwd=ROOT, timeout=60)
        if diff.returncode == 0:
            notify(f'magma-blog 编排完成但无新改动（{date}）')
            return 0

        commit = run(['git', 'commit', '-m', f'feat: publish {date} reflection'], cwd=ROOT, timeout=120)
        if commit.returncode != 0:
            notify(f'magma-blog 正式发布失败（{date}）\n- git commit 失败')
            return commit.returncode

        push = run(['git', 'push', 'origin', 'HEAD'], cwd=ROOT, timeout=180)
        if push.returncode != 0:
            notify(f'magma-blog 正式发布失败（{date}）\n- git push 失败')
            return push.returncode

        write_state(publish_state, {'date': date, 'stage': 'published'})
        if not success_flag.exists():
            notify(f'magma-blog 自动发布已完成（{date}）\n- 状态：正式稿已发布\n- 流程：Antigravity 草稿 → worker-general 终稿生成 → 脚本发布')
            success_flag.write_text('sent\n')
        return 0
    finally:
        lock_file.unlink(missing_ok=True)


if __name__ == '__main__':
    raise SystemExit(main())
