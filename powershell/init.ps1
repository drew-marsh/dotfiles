param([Switch]$force)

# must dot source
# Import-Module PSCompletions only works in global scope
if ($MyInvocation.InvocationName -ne '.') {
  throw "This script must be dot-sourced"
}

# dependencies
$scoop = get-command scoop -ErrorAction SilentlyContinue
if (!$scoop) {
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

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
    -AllowClobber `
  | Out-Null
}

Install-IfMissing posh-git
Install-IfMissing PSCompletions

# one-time setup of PSCompletions:
# only use custom menu for completions added with psc
if (!(Get-Module PSCompletions)) {
  Import-Module PSCompletions
}

$e = psc menu config enable_menu_enhance

if ($e -eq 1) {
  psc menu config enable_menu_enhance 0
}

# completions via PSCompletions
function Add-PSCompletion {
  param($executable)

  # parse information stream output (could break)
  $whichRes = psc which $executable 6>&1
  if (!($whichRes | findstr "you haven't added")) {
    return
  }

  psc add $executable
}

Add-PSCompletion choco
Add-PSCompletion scoop
Add-PSCompletion node
Add-PSCompletion npm
Add-PSCompletion nvm
Add-PSCompletion cargo
Add-PSCompletion wsl
Add-PSCompletion docker
Add-PSCompletion wt
Add-PScompletion powershell
Add-PScompletion pwsh
Add-PSCompletion 7z

# overwrite profile
$profileExists = Test-Path($PROFILE)

if ($profileExists -and !$force ) {
  $confirmation = Read-Host "Profile file exists. overwrite? (y/n)"
  if (!$confirmation.ToLower().Equals("y")) {
    Write-Output "Exiting"
    exit 0
  }
}

$dir = Split-Path $PROFILE -Parent

if (!(Test-Path $dir)) {
  md $dir | Out-Null
}

cp -r $PSScriptRoot\profile\* $dir -Force
mv -Force $dir\profile.ps1 $PROFILE

# Fzf
$fzf = get-command fzf -ErrorAction SilentlyContinue
if (!$fzf) {
  scoop install fzf
}

Install-IfMissing PSFzf
Install-IfMIssing z

$psReadLine = get-module PSReadLine
if (!$psReadLine -or ($psReadLine.Version.Minor -lt 1)) {
  Install-Module PSReadLine -Force -SkipPublisherCheck -Scope CurrentUser
}