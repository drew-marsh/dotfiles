param([Switch]$force)

function Install-IfMissing {
  param($module)
  $installedModule = Get-Module $module -ListAvailable

  if ($installedModule) {
    return;
  }

  Install-Module `
    $module `
    -Scope CurrentUser `
    -SkipPublisherCheck `
    -Force `
    -ErrorAction SilentlyContinue `
  | Out-Null
}

Install-IfMissing posh-git
Install-IfMissing PSCompletions

# one-time setup of PSCompletions module - requires interactive session
$cmd = @"
Import-Module PSCompletions

`$e = psc menu config enable_menu_enhance

if (`$e -eq 1) {
  # only use psc menu for added extensions
  # must restart shell after, not ideal
  psc menu config enable_menu_enhance 0
}
"@

powershell.exe -NoLogo -NoProfile -Command $cmd

$profileExists = Test-Path($PROFILE)

if ($profileExists -and !$force ) {
  $confirmation = Read-Host "Profile file exists. overwrite? (y/n)"
  if (!$confirmation.ToLower().Equals("y")) {
    Write-Output "Exiting"
    exit 0
  }
}

$dir = Split-Path $PROFILE -Parent
cp $PSScriptRoot\git-utils.ps1 $dir -Force

if (!(Test-Path $dir)) {
  md $dir | Out-Null
}

Get-Content $PSScriptRoot\profile.ps1 | Set-Content -path $PROFILE