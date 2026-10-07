#!/usr/bin/env bash
# Gemini Engineering Kit - Automated Setup Script for New Machines
set -e

TARGET_DIR="$HOME/.gemini/config"
REPO_URL="https://github.com/fahadrahman444/gemini-engineering-kit.git"

echo "==> Setting up Gemini Engineering Kit in $TARGET_DIR..."

mkdir -p "$TARGET_DIR"

if [ -d "$TARGET_DIR/.git" ]; then
    echo "==> Updating existing configuration..."
    cd "$TARGET_DIR"
    git pull origin main
else
    echo "==> Cloning engineering kit..."
    git clone "$REPO_URL" "$TARGET_DIR/tmp_kit"
    cp -r "$TARGET_DIR/tmp_kit/rules" "$TARGET_DIR/"
    cp -r "$TARGET_DIR/tmp_kit/skills" "$TARGET_DIR/"
    cp "$TARGET_DIR/tmp_kit/AGENTS.md" "$TARGET_DIR/"
    cp "$TARGET_DIR/tmp_kit/README.md" "$TARGET_DIR/"
    cp "$TARGET_DIR/tmp_kit/.gitignore" "$TARGET_DIR/"
    rm -rf "$TARGET_DIR/tmp_kit"
fi

echo "==> Verification:"
ls -la "$TARGET_DIR/skills"
echo "==> Successfully installed Gemini Engineering Kit!"
