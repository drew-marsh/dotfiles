Clear-Host
. $PSScriptRoot\completions.ps1
. $PSScriptRoot\fzf.ps1
. $PSScriptRoot\utils.ps1

$GitRoot = Get-GitRoot
Set-Alias less "$GitRoot\usr\bin\less.exe"
Set-Alias bash "$GitRoot\bin\bash.exe"

Set-PSReadLineOption -BellStyle None

function which($command) {
  $ErrorActionPreference = 'SilentlyContinue'
  Get-Command $command | Select-Object -ExpandProperty Path
}
function whichdir($command) {
  $ErrorActionPreference = 'SilentlyContinue'
  Get-Command $command | Select-Object -ExpandProperty Path | Split-Path
}

oh-my-posh init pwsh --config $PSScriptRoot\omp-themes\drew.omp.json | Invoke-Expression