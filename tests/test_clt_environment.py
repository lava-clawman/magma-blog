"""Check entrypoint environments without running publication or touching artifacts.

Run: python3 -m unittest discover -s tests -p test_clt_environment.py -v
"""
import os
from pathlib import Path
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]
CLT = "/Library/Developer/CommandLineTools"


class CommandLineToolsEnvironmentTest(unittest.TestCase):
    def test_both_launchagent_entrypoints_export_clt_to_python_and_git(self):
        for name in ("publish-from-review.sh", "retry-missing-reflections.sh"):
            with self.subTest(entrypoint=name):
                script = (ROOT / "scripts" / name).read_text()
                # Execute the actual startup block, stopping before scheduler,
                # locks, notifications, draft generation, or publication.
                startup = script.split("running_under_cron() {", 1)[0]
                for inherited in (None, "/Applications/Xcode.app/Contents/Developer"):
                    with self.subTest(inherited=inherited):
                        env = os.environ.copy()
                        env.pop("DEVELOPER_DIR", None)
                        if inherited is not None:
                            env["DEVELOPER_DIR"] = inherited
                        probe = (
                            '\n[ "$DEVELOPER_DIR" = "' + CLT + '" ]\n'
                            '/usr/bin/python3 -c \'import os, subprocess; '
                            'assert os.environ["DEVELOPER_DIR"] == "' + CLT + '"; '
                            'print(subprocess.check_output(["/usr/bin/git", "--version"], '
                            'text=True).strip())\'\n'
                        )
                        result = subprocess.run(
                            ["/bin/bash", "-c", startup + probe],
                            env=env, cwd=ROOT, capture_output=True, text=True,
                            timeout=20,
                        )
                        self.assertEqual(result.returncode, 0, result.stderr)
                        self.assertIn("git version", result.stdout)


if __name__ == "__main__":
    unittest.main()
