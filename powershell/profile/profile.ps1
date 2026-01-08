Clear-Host
. $PSScriptRoot\git-utils.ps1
. $PSScriptRoot\completions.ps1
. $PSScriptRoot\fzf.ps1
. $PSScriptRoot\prompt.ps1

$GitRoot = Get-GitRoot
Set-Alias less "$GitRoot\usr\bin\less.exe"
Set-Alias bash "$GitRoot\bin\bash.exe"

Set-PSReadLineOption -BellStyle None

function which($command) {
  Get-Command $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

oh-my-posh init pwsh --config $PSScriptRoot\omp-themes\drew.omp.json | Invoke-Expression