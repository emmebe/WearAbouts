#!/usr/bin/env python3
import os
import plistlib
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
APP_ROOT = PROJECT_ROOT / "WearAbouts"
CONFIG_PATH = Path(__file__).resolve().parent / "config.js"


def read_env_key():
    key = os.environ.get("UNSPLASH_ACCESS_KEY", "").strip()
    if key and key != "YOUR_UNSPLASH_ACCESS_KEY_HERE":
        return key
    return ""


def read_plist_key(plist_path: Path):
    if not plist_path.exists():
        return ""
    try:
        with plist_path.open("rb") as handle:
            data = plistlib.load(handle)
            key = data.get("UNSPLASH_ACCESS_KEY", "")
            if isinstance(key, str):
                key = key.strip()
                if key and key != "YOUR_UNSPLASH_ACCESS_KEY_HERE":
                    return key
    except Exception:
        return ""
    return ""


if __name__ == "__main__":
    key = read_env_key()
    if not key:
        key = read_plist_key(APP_ROOT / "Secrets.plist")

    if not key:
        print("Warning: UNSPLASH_ACCESS_KEY was not found in env or Secrets.plist.")
        print("Create website/config.js manually or export UNSPLASH_ACCESS_KEY before running this script.")

    content = f"window.UNSPLASH_ACCESS_KEY = \"{key}\";\n"
    CONFIG_PATH.write_text(content, encoding="utf-8")
    print(f"Written {CONFIG_PATH}")
