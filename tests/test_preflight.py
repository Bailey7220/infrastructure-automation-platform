"""Local fixture tests only; no real credentials or lab operations."""
import os
from pathlib import Path
import shlex
import shutil
import subprocess
import tempfile
import unittest

SOURCE = Path(__file__).resolve().parents[1] / "scripts/preflight.sh"


class PreflightTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.script = self.root / "scripts/preflight.sh"
        self.script.parent.mkdir()
        shutil.copyfile(SOURCE, self.script)
        for name in (
            "terraform/main.tf", "terraform/variables.tf",
            "terraform/.terraform.lock.hcl", "terraform/terraform.tfvars",
            "ansible/inventory.ini", "ansible/playbook.yml",
            "ansible/requirements.yml",
        ):
            path = self.root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("dummy fixture\n")
        self.key = self.root / "guest-public-key.pub"
        self.key.write_text("dummy fixture, not a valid public key\n")
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.marker = self.root / "command-was-executed"
        for name in ("terraform", "ansible-playbook", "ansible-galaxy", "ssh"):
            path = self.bin / name
            path.write_text(
                "#!/bin/sh\nprintf invoked > "
                + shlex.quote(str(self.marker)) + "\nexit 99\n"
            )
            path.chmod(0o700)
        os.symlink(shutil.which("dirname"), self.bin / "dirname")
        self.env = {
            "PATH": str(self.bin), "HOME": str(self.root), "LC_ALL": "C",
            "PROXMOX_VE_ENDPOINT": "https://preflight.invalid:8006",
            "PROXMOX_VE_API_TOKEN": "DUMMY_TOKEN_MUST_NOT_BE_PRINTED",
        }
        self.bash = shutil.which("bash")
        self.assertIsNotNone(self.bash, "Tests require Bash on Linux")

    def run_check(self, expected, args=None):
        result = subprocess.run(
            [self.bash, str(self.script), *(args if args is not None else [str(self.key)])],
            cwd=self.root, env=self.env, capture_output=True, text=True, timeout=10,
        )
        output = result.stdout + result.stderr
        self.assertEqual(result.returncode, expected, output)
        self.assertFalse(self.marker.exists(), "Preflight invoked an infrastructure command")
        for name in ("PROXMOX_VE_ENDPOINT", "PROXMOX_VE_API_TOKEN", "PROXMOX_VE_USERNAME", "PROXMOX_VE_PASSWORD"):
            if self.env.get(name):
                self.assertNotIn(self.env[name], output)
        return output

    def test_token_success(self):
        self.assertIn("Local presence checks passed", self.run_check(0))

    def test_password_success(self):
        self.env.pop("PROXMOX_VE_API_TOKEN")
        self.env.update(PROXMOX_VE_USERNAME="DUMMY_USER_VALUE", PROXMOX_VE_PASSWORD="DUMMY_PASSWORD_VALUE")
        self.run_check(0)

    def test_usage(self):
        self.assertIn("Usage:", self.run_check(2, []))
        self.run_check(2, [str(self.key), "extra"])

    def test_missing_inputs_are_all_reported(self):
        self.env.pop("PROXMOX_VE_ENDPOINT")
        self.env.pop("PROXMOX_VE_API_TOKEN")
        self.key.unlink()
        (self.root / "terraform/terraform.tfvars").unlink()
        (self.bin / "ansible-playbook").unlink()
        (self.bin / "ansible-galaxy").unlink()
        self.assertIn("Preflight failed: 6 check(s).", self.run_check(1))

    def test_incomplete_password_authentication(self):
        self.env.pop("PROXMOX_VE_API_TOKEN")
        self.env["PROXMOX_VE_USERNAME"] = "DUMMY_USER_VALUE"
        self.run_check(1)

    def test_empty_key(self):
        self.key.write_text("")
        self.run_check(1)


if __name__ == "__main__":
    unittest.main()
