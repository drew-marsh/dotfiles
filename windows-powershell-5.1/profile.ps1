$IsElevated = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
function prompt {
  Write-Host "PS " -NoNewline -ForegroundColor Blue

  if ($IsElevated) {
    Write-Host "E " -NoNewline -ForegroundColor Red
  }

  Write-Host "$env:USERNAME@$env:COMPUTERNAME" -ForegroundColor Green -NoNewline
  return " $PWD> "
}

# lazy loading cannot be done well:
# https://github.com/PowerShell/PowerShell/issues/17283

# 70ms
$pscam = Get-Module PSCompletions -ListAvailable
if (!$pscam) {
  Install-Module PSCompletions -Scope CurrentUser -ErrorAction SilentlyContinue | Out-Null
}

# 800 ms :/
# must be imported manually
# autoimport does not work because module must be used before cmdlet is called
Import-Module PSCompletions | Out-Null

# 100 ms
# only use psc menu for added extensions
# must restart shell after, not ideal
$e = psc menu config enable_menu_enhance

if ($e -eq 1) {
  psc menu config enable_menu_enhance 0
}

function Add-Completion {
  param($executable)
  $resolvedEx = Get-Command $executable -ErrorAction SilentlyContinue

  if (!$resolvedEx) {
    return
  }

  # parse information stream output
  $whichRes = psc which $executable 6>&1
  if (!($whichRes | findstr "you haven't added")) {
    return
  }

  psc add $executable
}

# 200 ms
Add-Completion git
Add-Completion winget
Add-Completion choco
Add-Completion scoop
Add-Completion node
Add-Completion npm
Add-Completion nvm
Add-Completion cargo
Add-Completion wsl
Add-Completion docker
Add-Completion wt
Add-completion powershell
Add-completion pwsh
Add-Completion 7z

