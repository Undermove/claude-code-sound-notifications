#!/bin/bash
# Claude Code Sound Notifications Installer

set -e

CLAUDE_DIR="$HOME/.claude"
PLUGIN_DIR="$CLAUDE_DIR/plugins/sound-notifications"

echo "🔧 Installing Claude Code Sound Notifications..."

# Create plugin directory
mkdir -p "$PLUGIN_DIR/skills/sound-notifications"

# Copy files
echo "📁 Copying plugin files..."
cp plugin.json "$PLUGIN_DIR/"
cp -r skills "$PLUGIN_DIR/"

# Update settings.json
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

if [ ! -f "$SETTINGS_FILE" ]; then
    echo "❌ Error: $SETTINGS_FILE not found"
    echo "   Make sure Claude Code has been run at least once"
    exit 1
fi

echo "⚙️  Updating settings.json..."

# Check if sound-notifications already enabled
if grep -q '"sound-notifications"' "$SETTINGS_FILE"; then
    echo "✅ Plugin already enabled in settings.json"
else
    # Add sound-notifications to enabledPlugins
    if grep -q '"enabledPlugins"' "$SETTINGS_FILE"; then
        # Insert after "superpowers" line
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' '/"superpowers@claude-plugins-official": true,/a\
    "sound-notifications": true
' "$SETTINGS_FILE"
        else
            sed -i '/"superpowers@claude-plugins-official": true,/a\    "sound-notifications": true' "$SETTINGS_FILE"
        fi
    else
        echo "❌ Error: No enabledPlugins section in settings.json"
        exit 1
    fi
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Restart Claude Code"
echo "   2. Ask Claude a question to test the notifications"
echo ""
