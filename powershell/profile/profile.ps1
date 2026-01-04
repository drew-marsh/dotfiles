Clear-Host
. $PSScriptRoot\git-utils.ps1
. $PSScriptRoot\completions.ps1
. $PSScriptRoot\utils.ps1
. $PSScriptRoot\fzf.ps1

$IsElevated = Is-Elevated
$GitRoot = Get-GitRoot
Set-Alias less "$GitRoot\usr\bin\less.exe"
Set-Alias bash "$GitRoot\bin\bash.exe"

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

Set-PSReadLineOption -BellStyle None

function which($command) {
  Get-Command $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}