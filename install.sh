#!/bin/bash
# install.sh
# Installs banners to ~/.local/share/archgot and adds it to ~/.bashrc

set -e

BANNER_DIR="$HOME/.local/share/archgot"
BASHRC="$HOME/.bashrc"

echo "Installing ASOIAF Terminal Banners..."

# 1. Create target directory
mkdir -p "$BANNER_DIR"

# 2. Check if banners have been generated
if [[ ! -d "out" ]] || [[ -z "$(ls -A out/*.txt 2>/dev/null)" ]]; then
    echo "Banners have not been generated yet."
    echo "Running generator script first..."
    ./scripts/generate_banners.sh
fi

# 3. Copy files
echo "Copying banners to $BANNER_DIR..."
cp out/*.txt "$BANNER_DIR/"
cp scripts/archgot "$BANNER_DIR/archgot"
chmod +x "$BANNER_DIR/archgot"

# Install binary to ~/.local/bin if directory exists or create it
mkdir -p "$HOME/.local/bin"
ln -sf "$BANNER_DIR/archgot" "$HOME/.local/bin/archgot"

# 4. Add to shell RC files (~/.bashrc and ~/.zshrc if present)
MARKER="# ArchGot - ASOIAF Terminal Banners"
TARGET_RCS=("$BASHRC")
[[ -f "$HOME/.zshrc" ]] && TARGET_RCS+=("$HOME/.zshrc")

for rc in "${TARGET_RCS[@]}"; do
    sed -i '/# Game of Thrones Terminal Banner/d' "$rc" 2>/dev/null || true
    sed -i '/# ASOIAF Terminal Banner/d' "$rc" 2>/dev/null || true
    sed -i '/got-banner.sh/d' "$rc" 2>/dev/null || true
    sed -i '|/usr/share/archgot/archgot|d' "$rc" 2>/dev/null || true

    if ! grep -q "$MARKER" "$rc"; then
        echo "Adding dispatcher to $rc..."
        echo "" >> "$rc"
        echo "$MARKER" >> "$rc"
        echo "[ -f \"$BANNER_DIR/archgot\" ] && source \"$BANNER_DIR/archgot\"" >> "$rc"
        echo "Successfully added to $rc"
    else
        echo "Dispatcher already present in $rc"
    fi
done

echo "Installation complete! Run 'archgot' or open a new terminal tab to see your banner."
