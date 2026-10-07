#!/usr/bin/env bash
# Gemini Engineering Kit - Clean Uninstaller with Backup
set -e

INSTALL_DIR="${HOME}/.gemini/config"
BACKUP_DIR="${HOME}/.gemini/backups/uninstalled_$(date +%Y%m%d_%H%M%S)"
BIN_PATH="${HOME}/.local/bin/gemini-kit"

echo "==> Gemini Engineering Kit Uninstaller"
echo "──────────────────────────────────────────"

# 1. Create safety backup
if [ -d "$INSTALL_DIR" ]; then
    echo "==> Backing up configuration to: $BACKUP_DIR"
    mkdir -p "$(dirname "$BACKUP_DIR")"
    cp -r "$INSTALL_DIR" "$BACKUP_DIR"
fi

# 2. Remove CLI symlink
if [ -L "$BIN_PATH" ] || [ -f "$BIN_PATH" ]; then
    rm -f "$BIN_PATH"
    echo "✓ Removed CLI symlink ($BIN_PATH)"
fi

# 3. Clean files while preserving user configs
echo "==> Removing rules, skills, agents, workflows, and scripts..."
rm -rf "$INSTALL_DIR/rules" \
       "$INSTALL_DIR/skills" \
       "$INSTALL_DIR/agents" \
       "$INSTALL_DIR/workflows" \
       "$INSTALL_DIR/scripts" \
       "$INSTALL_DIR/templates" \
       "$INSTALL_DIR/bin" \
       "$INSTALL_DIR/docs" \
       "$INSTALL_DIR/install.sh" \
       "$INSTALL_DIR/uninstall.sh" \
       "$INSTALL_DIR/VERSION" \
       "$INSTALL_DIR/README.md" \
       "$INSTALL_DIR/AGENTS.md" \
       "$INSTALL_DIR/.github"

echo "──────────────────────────────────────────"
echo "✓ Gemini Engineering Kit uninstalled successfully."
echo "Note: Your backup was preserved at $BACKUP_DIR"
