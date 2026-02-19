# Claude Code Sound Notifications Installer for Windows

$ErrorActionPreference = "Stop"

$claudeDir = "$env:USERPROFILE\.claude"
$pluginDir = "$claudeDir\plugins\sound-notifications"

Write-Host "🔧 Installing Claude Code Sound Notifications..." -ForegroundColor Cyan

# Create plugin directory
New-Item -ItemType Directory -Force -Path "$pluginDir\skills\sound-notifications" | Out-Null

# Copy files
Write-Host "📁 Copying plugin files..." -ForegroundColor Yellow
Copy-Item -Path "plugin.json" -Destination "$pluginDir\" -Force
Copy-Item -Path "skills" -Destination "$pluginDir\" -Recurse -Force

# Update settings.json
$settingsFile = "$claudeDir\settings.json"

if (-not (Test-Path $settingsFile)) {
    Write-Host "❌ Error: $settingsFile not found" -ForegroundColor Red
    Write-Host "   Make sure Claude Code has been run at least once" -ForegroundColor Red
    exit 1
}

Write-Host "⚙️  Updating settings.json..." -ForegroundColor Yellow

$settings = Get-Content $settingsFile -Raw | ConvertFrom-Json

if ($settings.enabledPlugins.PSObject.Properties.Name -contains "sound-notifications") {
    Write-Host "✅ Plugin already enabled in settings.json" -ForegroundColor Green
} else {
    $settings.enabledPlugins | Add-Member -NotePropertyName "sound-notifications" -NotePropertyValue $true
    $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsFile
}

Write-Host ""
Write-Host "✅ Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Restart Claude Code" -ForegroundColor White
Write-Host "   2. Ask Claude a question to test the notifications" -ForegroundColor White
Write-Host ""
