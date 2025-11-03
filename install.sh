#!/bin/bash
set -e

APP_NAME="dual-output-manager"
INSTALL_PATH="/usr/local/bin/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
ICON_PATH="$HOME/.local/share/icons/$APP_NAME.png"

echo "🔧 Installing $APP_NAME ..."

# Copy main script
sudo cp "$APP_NAME.sh" "$INSTALL_PATH"
sudo chmod +x "$INSTALL_PATH"

# Create desktop entry
mkdir -p "$(dirname "$DESKTOP_FILE")"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Dual Output Manager
Comment=Manage Bluetooth and 3.5mm audio outputs with delay sync
Exec=$INSTALL_PATH
Icon=audio-card
Terminal=false
Type=Application
Categories=AudioVideo;Utility;
EOF

# Make it executable
chmod +x "$DESKTOP_FILE"

echo "✅ Installed successfully!"
echo "📂 Shortcut created: $DESKTOP_FILE"
echo "🎧 You can now find it in your app launcher as 'Dual Output Manager'."
