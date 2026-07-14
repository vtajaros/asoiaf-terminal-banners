#!/bin/bash
# install.sh
# Installs got-banners to ~/.local/share/got-banners and adds it to ~/.bashrc

set -e

BANNER_DIR="$HOME/.local/share/got-banners"
BASHRC="$HOME/.bashrc"

echo "Installing Game of Thrones Terminal Banners..."

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
cp scripts/got-banner.sh "$BANNER_DIR/"
chmod +x "$BANNER_DIR/got-banner.sh"

# 4. Add to .bashrc if not already there
MARKER="# Game of Thrones Terminal Banner"
if ! grep -q "$MARKER" "$BASHRC"; then
    echo "Adding dispatcher to $BASHRC..."
    echo "" >> "$BASHRC"
    echo "$MARKER" >> "$BASHRC"
    echo "[ -f \"$BANNER_DIR/got-banner.sh\" ] && source \"$BANNER_DIR/got-banner.sh\"" >> "$BASHRC"
    echo "Successfully added to ~/.bashrc"
else
    echo "Dispatcher already present in ~/.bashrc"
fi

echo "Installation complete! Open a new terminal to see your banner."
