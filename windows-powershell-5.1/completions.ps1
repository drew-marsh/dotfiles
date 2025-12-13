# These would be nice to have 
# BUT importing pscompletions module turned out to be flaky
# So, run this manually if you want it

# individual completions should lazy load per command

$pscam = Get-Module PSCompletions -ListAvailable
if (!$pscam) {
  Write-Output "Installing PSCompletions"
  Install-Module PSCompletions -Scope CurrentUser | Out-Null
}

$pscm = Get-Module PSCompletions
if (!$pscm) {
  Write-Output "Importing PSCompletions"
  Import-Module PSCompletions | Out-Null
}
if ($pscm) {
  Write-Output "pscm found"
  $pscm
}

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

  # redirect verbose stream output
  $whichRes = psc which $executable 6>&1
  if (!($whichRes | findstr "you haven't added")) {
    return
  }

  psc add $executable
}

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

