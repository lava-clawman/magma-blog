from pathlib import Path


PUBLISH_SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "publish-from-review.sh"
RETRY_SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "retry-missing-reflections.sh"


def test_publish_script_checks_claude_auth_before_draft_generation():
    script = PUBLISH_SCRIPT.read_text()

    assert "claude auth status --text" in script
    assert "LAST_DRAFT_STATUS=\"login_required\"" in script
    assert "claude-login-required.json" in script


def test_retry_script_skips_blind_retries_when_login_is_required():
    script = RETRY_SCRIPT.read_text()

    assert "claude-login-required.json" in script
    assert "login required for" in script
