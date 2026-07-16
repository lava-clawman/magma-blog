from pathlib import Path
import subprocess


PUBLISH_SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "publish-from-review.sh"
RETRY_SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "retry-missing-reflections.sh"


def test_publish_script_checks_claude_auth_before_draft_generation():
    script = PUBLISH_SCRIPT.read_text()

    assert "claude auth status --text" in script
    assert "grep -Eiq '^Login method:'" in script
    assert "LAST_DRAFT_STATUS=\"login_required\"" in script
    assert "claude-login-required.json" in script


def test_retry_script_skips_blind_retries_when_login_is_required():
    script = RETRY_SCRIPT.read_text()

    assert "claude-login-required.json" in script
    assert "grep -Eiq '^Login method:'" in script
    assert "login required for" in script


def test_auth_detection_rejects_expired_status_even_with_zero_exit_code(tmp_path):
    expired = tmp_path / "expired.txt"
    expired.write_text("Login: Expired — log in again\nOrganization: Example\n")

    authenticated = tmp_path / "authenticated.txt"
    authenticated.write_text("Login method: Claude Pro account\nOrganization: Example\n")

    expired_result = subprocess.run(
        ["grep", "-Eiq", "^Login method:", str(expired)], check=False
    )
    authenticated_result = subprocess.run(
        ["grep", "-Eiq", "^Login method:", str(authenticated)], check=False
    )

    assert expired_result.returncode != 0
    assert authenticated_result.returncode == 0
