Clear-Host
. $PSScriptRoot\git-utils.ps1
. $PSScriptRoot\completions.ps1
. $PSScriptRoot\utils.ps1

$IsElevated = Is-Elevated
Set-Alias less "$(Get-GitRoot)\usr\bin\less.exe"

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

Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

Set-PSReadLineOption -BellStyle None

function which($command) {
  Get-Command $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}