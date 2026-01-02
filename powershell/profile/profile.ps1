Clear-Host
. $PSScriptRoot\git-utils.ps1
. $PSScriptRoot\completions.ps1
. $PSScriptRoot\utils.ps1

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

Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

Set-PSReadLineOption -BellStyle None

function which($command) {
  Get-Command $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

$env:ARGC_COMPLETIONS_ROOT = "$PSScriptRoot\argc-completions"
$env:ARGC_COMPLETIONS_PATH = ($env:ARGC_COMPLETIONS_ROOT + '\completions\windows;' + $env:ARGC_COMPLETIONS_ROOT + '\completions')
$env:PATH = $env:ARGC_COMPLETIONS_ROOT + '\bin' + [IO.Path]::PathSeparator + $env:PATH     
# To add completions for only the specified command, modify next line e.g. $argc_scripts = @("cargo", "git")
$argc_scripts = ((Get-ChildItem -File -Path ($env:ARGC_COMPLETIONS_ROOT + '\completions\windows'), ($env:ARGC_COMPLETIONS_ROOT + '\completions')) | ForEach-Object { $_.BaseName })    
argc --argc-completions powershell $argc_scripts | Out-String | Invoke-Expression