#!/usr/bin/env python3
import subprocess
import sys
import argparse


def run(cmd):
    print("$", " ".join(cmd))
    subprocess.check_call(cmd)


def main():
    parser = argparse.ArgumentParser(description="Clean old Conan package revisions")
    parser.add_argument("pattern", nargs="?", default="*/*", help="Reference pattern, e.g., openssl/*")
    parser.add_argument("--keep", type=int, default=1, help="Number of latest revisions to keep")
    args = parser.parse_args()

    # Ensure clean command extension is available
    run(["conan", "config", "install", "https://github.com/conan-io/conan-extensions.git"]) 

    # Use the custom clean revisions command; if unavailable, fallback to cache clean
    try:
        run(["conan", "clean", "revisions", args.pattern, "--keep", str(args.keep)])
    except subprocess.CalledProcessError:
        # Fallback minimal cleanup
        run(["conan", "cache", "clean", "--build", "--download", "--source"])


if __name__ == "__main__":
    try:
        main()
    except subprocess.CalledProcessError as e:
        sys.exit(e.returncode)
