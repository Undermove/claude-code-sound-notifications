#!/bin/bash
# Claude Code Sound Notifications Installer

set -e

CLAUDE_DIR="$HOME/.claude"
PLUGIN_CACHE_DIR="$CLAUDE_DIR/plugins/cache/custom/sound-notifications/1.0.0"
PLUGIN_ID="sound-notifications@custom"
REPO_URL="https://github.com/Undermove/claude-code-sound-notifications.git"

echo "🔧 Installing Claude Code Sound Notifications..."

# Clone the repository
if [ -d "$PLUGIN_CACHE_DIR" ]; then
    echo "📁 Plugin directory already exists, removing for re-install..."
    rm -rf "$PLUGIN_CACHE_DIR"
fi

echo "📁 Creating plugin directory structure..."
mkdir -p "$PLUGIN_CACHE_DIR"

# Get repository path (assuming running from repo root)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy files
echo "📁 Copying plugin files..."
cp -r "$REPO_DIR/.claude-plugin" "$PLUGIN_CACHE_DIR/"
cp -r "$REPO_DIR/skills" "$PLUGIN_CACHE_DIR/"

# Update settings.json
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

if [ ! -f "$SETTINGS_FILE" ]; then
    echo "❌ Error: $SETTINGS_FILE not found"
    echo "   Make sure Claude Code has been run at least once"
    exit 1
fi

echo "⚙️  Updating settings.json..."

# Use Python for reliable JSON manipulation
python3 - <<PYTHON_SCRIPT
import json
import sys
from datetime import datetime, timezone

settings_file = "$SETTINGS_FILE"
plugin_id = "$PLUGIN_ID"

try:
    with open(settings_file, 'r') as f:
        settings = json.load(f)

    # Ensure enabledPlugins exists
    if 'enabledPlugins' not in settings:
        settings['enabledPlugins'] = {}

    # Enable the plugin
    settings['enabledPlugins'][plugin_id] = True

    # Write back with proper formatting
    with open(settings_file, 'w') as f:
        json.dump(settings, f, indent=2)
        f.write('\n')

    print(f"✅ Plugin {plugin_id} enabled in settings.json")
except Exception as e:
    print(f"❌ Error updating settings.json: {e}", file=sys.stderr)
    sys.exit(1)
PYTHON_SCRIPT

# Register plugin in installed_plugins.json
INSTALLED_PLUGINS_FILE="$CLAUDE_DIR/plugins/installed_plugins.json"

echo "📝 Registering plugin in installed_plugins.json..."

# Use Python for reliable JSON manipulation
python3 - <<PYTHON_SCRIPT
import json
import sys
from datetime import datetime, timezone

installed_plugins_file = "$INSTALLED_PLUGINS_FILE"
plugin_id = "$PLUGIN_ID"
install_path = "$PLUGIN_CACHE_DIR"
version = "1.0.0"

try:
    # Read existing file or create new structure
    try:
        with open(installed_plugins_file, 'r') as f:
            installed = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        installed = {}

    # Add/update plugin entry
    installed[plugin_id] = {
        "scope": "user",
        "installPath": install_path,
        "version": version,
        "installedAt": datetime.now(timezone.utc).isoformat(),
        "lastUpdated": datetime.now(timezone.utc).isoformat()
    }

    # Write back with proper formatting
    with open(installed_plugins_file, 'w') as f:
        json.dump(installed, f, indent=2)
        f.write('\n')

    print(f"✅ Plugin {plugin_id} registered in installed_plugins.json")
except Exception as e:
    print(f"❌ Error updating installed_plugins.json: {e}", file=sys.stderr)
    sys.exit(1)
PYTHON_SCRIPT

echo ""
echo "✅ Installation complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Restart Claude Code"
echo "   2. Ask Claude a question to test the notifications"
echo ""
