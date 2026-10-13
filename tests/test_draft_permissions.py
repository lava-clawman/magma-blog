"""Exercise the actual draft task template without invoking an agent or service."""
import json
import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "scripts/publish-from-review.sh"


class DraftPermissionsTest(unittest.TestCase):
    def render_task(self, directory, prompt, output):
        script = SCRIPT.read_text()
        # Run only task construction from the real function, before agent execution.
        function = script.split("agent_generate_draft() {", 1)[1].split("\n  set +e\n", 1)[0]
        env = os.environ.copy()
        env.update(ARTIFACT_DIR=str(directory), DATE="2026-10-13")
        proc = subprocess.run(
            ["/bin/bash", "-c", "set -eu\nrender() {" + function + "\n}\nrender \"$1\" \"$2\"",
             "test", str(prompt), str(output)], env=env, capture_output=True, text=True, timeout=10,
        )
        self.assertEqual(proc.returncode, 0, proc.stderr)
        return (directory / "claude-draft.agent-task.txt").read_text()

    def test_generated_task_preserves_permissions_and_disables_tools(self):
        with tempfile.TemporaryDirectory() as tmp:
            directory = Path(tmp)
            prompt = directory / "prompt.txt"
            prompt.write_text("draft source")
            task = self.render_task(directory, prompt, directory / "draft.md")
            self.assertNotIn("bypassPermissions", task)
            self.assertNotIn("skip-permissions", task)
            self.assertNotIn("--allowedTools", task)
            command = next(line for line in task.splitlines() if line.startswith("claude "))
            self.assertEqual(shlex.split(command)[:4], ["claude", "--tools", "", "--print"])
            self.assertIn("Do NOT bypass permissions", task)

    def test_command_quotes_paths_and_passes_source_verbatim_without_execution(self):
        with tempfile.TemporaryDirectory() as tmp:
            directory = Path(tmp)
            prompt = directory / "prompt ' $(touch INJECTED) ; source.txt"
            output = directory / "draft ' $(touch INJECTED) ; output.md"
            source = "Literal $(touch INJECTED) `touch INJECTED` ' \" $HOME\nsecond line\n"
            prompt.write_text(source)
            task = self.render_task(directory, prompt, output)
            command = next(line for line in task.splitlines() if line.startswith("claude "))
            fake = directory / "claude"
            fake.write_text("#!/usr/bin/env python3\nimport json, sys\nfrom pathlib import Path\nPath('argv.json').write_text(json.dumps(sys.argv[1:]))\nsys.stdout.write(sys.stdin.read())\n")
            fake.chmod(0o700)
            env = os.environ.copy()
            env["PATH"] = str(directory) + os.pathsep + env["PATH"]
            proc = subprocess.run(["/bin/bash", "-c", command], cwd=directory,
                                  env=env, capture_output=True, text=True, timeout=10)
            self.assertEqual(proc.returncode, 0, proc.stderr)
            self.assertEqual(output.read_text(), source)
            self.assertEqual(json.loads((directory / "argv.json").read_text()),
                             ["--tools", "", "--print"])
            self.assertFalse((directory / "INJECTED").exists())


if __name__ == "__main__":
    unittest.main()
