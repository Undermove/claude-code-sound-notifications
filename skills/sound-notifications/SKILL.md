---
name: sound-notifications
description: Send system notifications when Claude Code needs user input or completes a task
---

## When to Send Notifications

Send system notifications via Bash tool in these cases:

### ASK_USER
Send notification BEFORE:
- Using `AskUserQuestion` tool
- Asking clarifying questions
- Requesting approval/confirmation
- Needing user decision

**macOS:**
```bash
osascript -e 'display notification "🤔 Question from Claude" with title "Claude Code"'
```

**Linux:**
```bash
notify-send "Claude Code" "🤔 Question from Claude"
```

**Windows:**
```bash
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('🤔 Question from Claude', 'Claude Code')"
```

### TASK_COMPLETE
Send notification AFTER:
- Completing feature implementation
- Fixing a bug
- Finishing refactoring
- Passing tests
- Any multi-step task completion

**macOS:**
```bash
osascript -e 'display notification "✅ Task completed" with title "Claude Code"'
```

**Linux:**
```bash
notify-send "Claude Code" "✅ Task completed"
```

**Windows:**
```bash
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('✅ Task completed', 'Claude Code')"
```

## Implementation

Use Bash tool to send notifications. Detect OS and use appropriate command:

```bash
# Detect OS and send notification
if [[ "$OSTYPE" == "darwin"* ]]; then
  osascript -e 'display notification "✅ Done!" with title "Claude Code"'
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  notify-send "Claude Code" "✅ Done!"
elif [[ "$OSTYPE" == "msys" ]]; then
  powershell -Command "[System.Windows.Forms.MessageBox]::Show('✅ Done!', 'Claude Code')"
fi
```

## Note

This skill provides immediate visual/audio feedback through system notifications.
