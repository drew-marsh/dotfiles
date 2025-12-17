Clear-Host
. $PSScriptRoot\git-utils.ps1
. $PSScriptRoot\completions.ps1

$IsElevated = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

function Write-PSVersion {
  $psType = "wps";
  if ((get-process -id $pid).ProcessName -eq "pwsh") {
    $psType = "pwsh"
  }

  Write-Host "$($psType)$($PSVersionTable.PSVersion.Major)" -NoNewline -ForegroundColor Blue
}

function prompt {
  Write-PSVersion

  if ($IsElevated) {
    Write-Host " E" -NoNewline -ForegroundColor Magenta
  }

  Write-Host " $env:USERNAME@$env:COMPUTERNAME" -ForegroundColor Green -NoNewline
  Get-GitStatus | Write-PromptGitStatus
  Write-Host " $($PWD.Path | Split-Path -Leaf)" -NoNewline
  return "> "
}