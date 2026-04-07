# =============================================================================
# Windows-side Setup for WSL2 + Android Emulator
# =============================================================================
# Run from an ELEVATED PowerShell (Admin):
#   powershell -ExecutionPolicy Bypass -File \\wsl$\Ubuntu\home\ale\dotfiles\platforms\wsl\windows-setup.ps1
#
# Or from WSL:
#   powershell.exe -ExecutionPolicy Bypass -File "$(wslpath -w ~/dotfiles/platforms/wsl/windows-setup.ps1)"
# =============================================================================

$ErrorActionPreference = "Stop"

function Write-Status  { param($m) Write-Host "[INFO] $m"    -ForegroundColor Blue }
function Write-Ok      { param($m) Write-Host "[OK]   $m"    -ForegroundColor Green }
function Write-Warn    { param($m) Write-Host "[WARN] $m"    -ForegroundColor Yellow }
function Write-Err     { param($m) Write-Host "[ERR]  $m"    -ForegroundColor Red }

# -----------------------------------------------------------------------------
# 1. Check admin privileges
# -----------------------------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)
if (-not $isAdmin) {
    Write-Err "This script requires Administrator privileges."
    Write-Status "Right-click PowerShell -> Run as Administrator, then re-run this script."
    exit 1
}
Write-Ok "Running as Administrator"

# -----------------------------------------------------------------------------
# 2. Hyper-V Firewall for WSL2 (mirrored networking)
# -----------------------------------------------------------------------------
Write-Status "Configuring Hyper-V firewall for WSL2..."

$hvVmId = '{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}'
try {
    $current = Get-NetFirewallHyperVVMSetting -Name $hvVmId -ErrorAction Stop
    $needsInbound  = $current.DefaultInboundAction  -ne 'Allow'
    $needsOutbound = $current.DefaultOutboundAction -ne 'Allow'

    if ($needsInbound) {
        Set-NetFirewallHyperVVMSetting -Name $hvVmId -DefaultInboundAction Allow
        Write-Ok "Hyper-V inbound firewall set to Allow"
    } else {
        Write-Ok "Hyper-V inbound firewall already set to Allow"
    }

    if ($needsOutbound) {
        Set-NetFirewallHyperVVMSetting -Name $hvVmId -DefaultOutboundAction Allow
        Write-Ok "Hyper-V outbound firewall set to Allow"
    } else {
        Write-Ok "Hyper-V outbound firewall already set to Allow"
    }
} catch {
    Write-Warn "Could not configure Hyper-V firewall: $_"
    Write-Warn "This is expected on Windows Home (no Hyper-V management cmdlets)."
    Write-Warn "Mirrored networking still works; you may need manual firewall rules for Expo Go on physical devices."
}

# -----------------------------------------------------------------------------
# 3. Verify Android Studio / SDK
# -----------------------------------------------------------------------------
$androidHome = "$env:LOCALAPPDATA\Android\Sdk"
$studioPath  = "${env:ProgramFiles}\Android\Android Studio"

if (Test-Path "$studioPath\bin\studio64.exe") {
    Write-Ok "Android Studio found at $studioPath"
} else {
    Write-Warn "Android Studio not found at default path."
    Write-Status "Download from: https://developer.android.com/studio"
    Write-Status "Install it and re-run this script."
}

if (Test-Path "$androidHome\platform-tools\adb.exe") {
    Write-Ok "Android SDK found at $androidHome"
} else {
    Write-Err "Android SDK not found at $androidHome"
    Write-Status "Open Android Studio -> SDK Manager and install SDK Platform-Tools."
    exit 1
}

# -----------------------------------------------------------------------------
# 4. Set persistent user environment variables
# -----------------------------------------------------------------------------
Write-Status "Setting environment variables..."

$envVars = @{
    "ANDROID_HOME"     = $androidHome
    "ANDROID_SDK_ROOT" = $androidHome
    "JAVA_HOME"        = "$studioPath\jbr"
}

foreach ($key in $envVars.Keys) {
    $current = [Environment]::GetEnvironmentVariable($key, "User")
    $desired = $envVars[$key]
    if ($current -ne $desired) {
        [Environment]::SetEnvironmentVariable($key, $desired, "User")
        Write-Ok "$key = $desired"
    } else {
        Write-Ok "$key already set correctly"
    }
}

# Add to user PATH if not present
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathEntries = @(
    "$androidHome\platform-tools",
    "$androidHome\emulator",
    "$androidHome\cmdline-tools\latest\bin",
    "$studioPath\jbr\bin"
)

$pathModified = $false
foreach ($p in $pathEntries) {
    if ($userPath -notlike "*$p*") {
        $userPath = "$p;$userPath"
        $pathModified = $true
        Write-Ok "Added to PATH: $p"
    } else {
        Write-Ok "Already in PATH: $p"
    }
}

if ($pathModified) {
    [Environment]::SetEnvironmentVariable("Path", $userPath, "User")
    Write-Ok "User PATH updated"
}

# Refresh current session
$env:ANDROID_HOME     = $androidHome
$env:ANDROID_SDK_ROOT = $androidHome
$env:JAVA_HOME        = "$studioPath\jbr"
$env:Path             = $userPath + ";" + [Environment]::GetEnvironmentVariable("Path", "Machine")

# -----------------------------------------------------------------------------
# 5. Install/verify SDK components
# -----------------------------------------------------------------------------
$sdkmanager = "$androidHome\cmdline-tools\latest\bin\sdkmanager.bat"

if (Test-Path $sdkmanager) {
    Write-Status "Accepting Android SDK licenses..."
    $yesInput = ("y`n" * 20)
    $yesInput | & $sdkmanager --licenses 2>$null | Out-Null

    Write-Status "Installing/updating SDK components..."
    & $sdkmanager --install `
        "platform-tools" `
        "emulator" `
        "platforms;android-35" `
        "platforms;android-36" `
        "build-tools;35.0.0" `
        "build-tools;36.0.0" 2>$null
    Write-Ok "SDK components up to date"
} else {
    Write-Warn "sdkmanager not found at $sdkmanager"
    Write-Status "Install 'Android SDK Command-line Tools' via Android Studio -> SDK Manager -> SDK Tools tab."
}

# -----------------------------------------------------------------------------
# 6. Verify emulator AVDs
# -----------------------------------------------------------------------------
$emulatorExe = "$androidHome\emulator\emulator.exe"

if (Test-Path $emulatorExe) {
    $avds = & $emulatorExe -list-avds 2>$null
    if ($avds) {
        Write-Ok "Available AVDs:"
        foreach ($avd in $avds) { Write-Host "  - $avd" -ForegroundColor Cyan }
    } else {
        Write-Warn "No AVDs found."
        Write-Status "Create one: Android Studio -> Virtual Device Manager -> Create Device"
        Write-Status "Recommended: Medium Phone with latest API level, x86_64 image"
    }
} else {
    Write-Warn "Emulator not found. Install via SDK Manager."
}

# -----------------------------------------------------------------------------
# 7. ADB connectivity check
# -----------------------------------------------------------------------------
Write-Status "Checking ADB..."
$adbExe = "$androidHome\platform-tools\adb.exe"
& $adbExe start-server 2>$null
& $adbExe devices
Write-Ok "ADB server running"

# -----------------------------------------------------------------------------
# 8. .wslconfig verification
# -----------------------------------------------------------------------------
$wslconfig = "$env:USERPROFILE\.wslconfig"
if (Test-Path $wslconfig) {
    $content = Get-Content $wslconfig -Raw
    if ($content -match "networkingMode\s*=\s*mirrored") {
        Write-Ok ".wslconfig has networkingMode=mirrored"
    } else {
        Write-Warn ".wslconfig exists but missing networkingMode=mirrored"
        Write-Status "Run the WSL setup (platforms/wsl/setup.sh) to configure this."
    }
    if ($content -match "hostAddressLoopback\s*=\s*true") {
        Write-Ok ".wslconfig has hostAddressLoopback=true"
    } else {
        Write-Warn ".wslconfig missing hostAddressLoopback=true (recommended for localhost forwarding)"
    }
} else {
    Write-Warn ".wslconfig not found. Run the WSL setup script to create it."
}

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host " Windows-side setup complete!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Status "Next steps:"
Write-Host "  1. Restart WSL:        wsl --shutdown" -ForegroundColor Cyan
Write-Host "  2. Open new WSL shell and run:  cd ~/dotfiles && bash install.sh" -ForegroundColor Cyan
Write-Host "  3. Start emulator:     android-emu" -ForegroundColor Cyan
Write-Host "  4. Run your app:       npx expo run:android" -ForegroundColor Cyan
Write-Host ""
