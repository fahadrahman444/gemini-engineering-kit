#!/usr/bin/env bash
# Gemini Engineering Kit - Idempotent Installer with Backup & Verification
set -e

INSTALL_DIR="${HOME}/.gemini/config"
REPO_URL="https://github.com/fahadrahman444/gemini-engineering-kit.git"
BACKUP_DIR="${HOME}/.gemini/backups/config_$(date +%Y%m%d_%H%M%S)"
BIN_DEST="${HOME}/.local/bin"

echo "==> Gemini Engineering Kit Installer"
echo "──────────────────────────────────────────"

# 1. Safe Backup of existing config if present
if [ -d "$INSTALL_DIR" ] && [ -n "$(ls -A "$INSTALL_DIR" 2>/dev/null)" ]; then
    if [ ! -d "$INSTALL_DIR/.git" ]; then
        echo "==> Creating safety backup in: $BACKUP_DIR"
        mkdir -p "$(dirname "$BACKUP_DIR")"
        cp -r "$INSTALL_DIR" "$BACKUP_DIR"
    fi
fi

# 2. Idempotent Setup / Git Sync
mkdir -p "$INSTALL_DIR"

if [ -d "$INSTALL_DIR/.git" ]; then
    echo "==> Repository exists. Pulling latest updates..."
    cd "$INSTALL_DIR"
    git pull origin main || echo "Working directory has local modifications. Preserving current state."
else
    echo "==> Setting up engineering kit in $INSTALL_DIR..."
    git clone "$REPO_URL" "$INSTALL_DIR" 2>/dev/null || (
        # Fallback if git clone fails or directory has files
        TMP_DIR=$(mktemp -d)
        git clone "$REPO_URL" "$TMP_DIR"
        cp -r "$TMP_DIR"/* "$INSTALL_DIR/"
        rm -rf "$TMP_DIR"
    )
fi

# 3. Permissions & Symlink CLI to PATH
chmod +x "$INSTALL_DIR/bin/gemini-kit" "$INSTALL_DIR/scripts/"*.sh "$INSTALL_DIR/install.sh" "$INSTALL_DIR/uninstall.sh" 2>/dev/null || true

mkdir -p "$BIN_DEST"
ln -sf "$INSTALL_DIR/bin/gemini-kit" "$BIN_DEST/gemini-kit"

echo "==> CLI installed to $BIN_DEST/gemini-kit"

# 4. Verify installation
"$INSTALL_DIR/scripts/doctor.sh"

echo "──────────────────────────────────────────"
echo "✓ Installation complete! Run 'gemini-kit help' or 'gemini-kit doctor' to start."
