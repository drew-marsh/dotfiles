. $PSScriptRoot\utils.ps1
. $PSScriptRoot\git-utils.ps1

$IsElevated = Is-Elevated

function getShellDescription() {
  $Major = $PSVersionTable.PSVersion.Major
  if ($Major -gt 5) {
    return "pwsh$Major"
  }

  return "ps$Major"
}

function prompt {
  Write-Host (getShellDescription) -NoNewline -ForegroundColor Blue

  if ($IsElevated) {
    Write-Host " E" -NoNewline -ForegroundColor Magenta
  }

  Write-Host " $env:USERNAME@$env:COMPUTERNAME" -ForegroundColor Green -NoNewline
  Write-Host " $($PWD.Path | Split-Path -Leaf)" -NoNewline
  Get-GitStatus | Write-PromptGitStatus
  Write-Host ""
  return "> "
  
}

