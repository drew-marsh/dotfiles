
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
    -ErrorAction SilentlyContinue `
  | Out-Nul
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

& $PSScriptRoot\set-profile.ps1