# Claude Code Sound Notifications Installer for Windows

$ErrorActionPreference = "Stop"

$claudeDir = "$env:USERPROFILE\.claude"
$pluginCacheDir = "$claudeDir\plugins\cache\custom\sound-notifications\1.0.0"
$pluginId = "sound-notifications@custom"

Write-Host "🔧 Installing Claude Code Sound Notifications..." -ForegroundColor Cyan

# Get repository path (assuming running from repo root)
$repoDir = $PSScriptRoot

# Remove existing installation if present
if (Test-Path $pluginCacheDir) {
    Write-Host "📁 Plugin directory already exists, removing for re-install..." -ForegroundColor Yellow
    Remove-Item -Path $pluginCacheDir -Recurse -Force
}

# Create plugin directory structure
Write-Host "📁 Creating plugin directory structure..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $pluginCacheDir | Out-Null

# Copy files
Write-Host "📁 Copying plugin files..." -ForegroundColor Yellow
Copy-Item -Path "$repoDir\.claude-plugin" -Destination "$pluginCacheDir\" -Recurse -Force
Copy-Item -Path "$repoDir\skills" -Destination "$pluginCacheDir\" -Recurse -Force

# Update settings.json
$settingsFile = "$claudeDir\settings.json"

if (-not (Test-Path $settingsFile)) {
    Write-Host "❌ Error: $settingsFile not found" -ForegroundColor Red
    Write-Host "   Make sure Claude Code has been run at least once" -ForegroundColor Red
    exit 1
}

Write-Host "⚙️  Updating settings.json..." -ForegroundColor Yellow

try {
    $settings = Get-Content $settingsFile -Raw | ConvertFrom-Json

    # Ensure enabledPlugins exists
    if (-not $settings.PSObject.Properties.Name -contains "enabledPlugins") {
        $settings | Add-Member -NotePropertyName "enabledPlugins" -NotePropertyValue ([ordered]@{})
    }

    # Enable the plugin
    if (-not $settings.enabledPlugins.PSObject.Properties.Name -contains $pluginId) {
        $settings.enabledPlugins | Add-Member -NotePropertyName $pluginId -NotePropertyValue $true
    }

    # Write back with proper formatting
    $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsFile
    Write-Host "✅ Plugin $pluginId enabled in settings.json" -ForegroundColor Green
}
catch {
    Write-Host "❌ Error updating settings.json: $_" -ForegroundColor Red
    exit 1
}

# Register plugin in installed_plugins.json
$installedPluginsFile = "$claudeDir\plugins\installed_plugins.json"

Write-Host "📝 Registering plugin in installed_plugins.json..." -ForegroundColor Yellow

try {
    # Read existing file or create new structure
    if (Test-Path $installedPluginsFile) {
        $installed = Get-Content $installedPluginsFile -Raw | ConvertFrom-Json
    }
    else {
        $installed = [ordered]@{}
    }

    # Get absolute path
    $installPath = (Resolve-Path $pluginCacheDir).Path

    # Add/update plugin entry
    $timestamp = (Get-Date).ToUniversalTime().ToString("o")
    $pluginEntry = [ordered]@{
        scope = "user"
        installPath = $installPath
        version = "1.0.0"
        installedAt = $timestamp
        lastUpdated = $timestamp
    }

    # Convert to hashtable for easier manipulation
    $installedHash = @{}
    foreach ($prop in $installed.PSObject.Properties) {
        $installedHash[$prop.Name] = $prop.Value
    }
    $installedHash[$pluginId] = $pluginEntry

    # Write back with proper formatting
    $installedHash | ConvertTo-Json -Depth 10 | Set-Content $installedPluginsFile
    Write-Host "✅ Plugin $pluginId registered in installed_plugins.json" -ForegroundColor Green
}
catch {
    Write-Host "❌ Error updating installed_plugins.json: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Restart Claude Code" -ForegroundColor White
Write-Host "   2. Ask Claude a question to test the notifications" -ForegroundColor White
Write-Host ""
