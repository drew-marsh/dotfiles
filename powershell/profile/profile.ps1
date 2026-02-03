$isSsh = [bool]($env:SSH_CONNECTION -or $env:SSH_CLIENT)
$hasSshTty = [bool]($env:SSH_TTY)

if($isSsh -and -not $hasSshTty){
  return;
}

Clear-Host
. $PSScriptRoot\completions.ps1
. $PSScriptRoot\fzf.ps1
. $PSScriptRoot\utils.ps1

$GitRoot = Get-GitRoot
Set-Alias less "$GitRoot\usr\bin\less.exe"
Set-Alias bash "$GitRoot\bin\bash.exe"

Set-PSReadLineOption -BellStyle None

if ($PSStyle) {
  $PSStyle.FileInfo.Directory = "`e[34m"
}

function which($command) {
  $ErrorActionPreference = 'SilentlyContinue'
  Get-Command $command | Select-Object -ExpandProperty Path
}
function whichdir($command) {
  $ErrorActionPreference = 'SilentlyContinue'
  Get-Command $command | Select-Object -ExpandProperty Path | Split-Path
}

oh-my-posh init pwsh --config $PSScriptRoot\omp-themes\drew.omp.json | Invoke-Expression
