# Claude Code Sound Notifications

> 🔔 System notifications when Claude Code needs your input or completes a task

## How It Works

This plugin adds a skill that sends system notifications when:
- **Claude needs to ask you a question** 🤔
- **A task is completed** ✅

## Installation

### Step 1: Download or Clone

```bash
# Clone the repository
git clone https://github.com/yourusername/claude-code-sound-notifications.git ~/.claude/plugins/sound-notifications

# Or download and extract to ~/.claude/plugins/sound-notifications/
```

### Step 2: Enable the Plugin

Edit `~/.claude/settings.json` and add the plugin:

```json
{
  "enabledPlugins": {
    "superpowers@claude-plugins-official": true,
    "figma@claude-plugins-official": true,
    "sound-notifications": true
  }
}
```

### Step 3: Restart Claude Code

Restart Claude Code or the VS Code extension to load the new plugin.

## Requirements

- **macOS**: No additional requirements (uses built-in `osascript`)
- **Linux**: `libnotify-bin` or `notify-send`
- **Windows**: PowerShell (built-in)

## File Structure

```
~/.claude/plugins/sound-notifications/
├── plugin.json
└── skills/
    └── sound-notifications/
        └── SKILL.md
```

## Testing

After installation, ask Claude Code a simple question to test:

> "Can you help me with..."

You should see a notification popup!

## Troubleshooting

### Notifications Not Showing

**macOS:**
- Check System Settings > Notifications > Claude Code
- Make sure notifications are enabled for your terminal/app

**Linux:**
- Ensure `notify-send` is installed:
  ```bash
  sudo apt install libnotify-bin  # Debian/Ubuntu
  sudo dnf install libnotify    # Fedora
  ```

**Windows:**
- Notifications appear as popups; check Windows notification settings

### Plugin Not Loading

1. Verify `~/.claude/settings.json` has `"sound-notifications": true`
2. Check file structure matches the layout above
3. Restart Claude Code completely

## Customization

Want different sounds or messages? Edit the notification commands in `skills/sound-notifications/SKILL.md`.

## Contributing

Feel free to submit issues and pull requests!

## License

MIT
