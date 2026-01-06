. $PSScriptRoot\git-utils.ps1
. $PSScriptRoot\utils.ps1

$IsElevated = Is-Elevated

function prompt {
  Write-Host "PS$($PSVersionTable.PSVersion.Major)" -NoNewline -ForegroundColor Blue

  if ($IsElevated) {
    Write-Host " E" -NoNewline -ForegroundColor Magenta
  }

  Write-Host " $env:USERNAME@$env:COMPUTERNAME" -ForegroundColor Green -NoNewline
  Get-GitStatus | Write-PromptGitStatus
  Write-Host " $($PWD.Path | Split-Path -Leaf)" -NoNewline
  return "> "
}
