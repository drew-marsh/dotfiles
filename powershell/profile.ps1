. $PSScriptRoot\git-utils.ps1

Clear-Host

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

  Write-Host " $env:USERNAME@$env:COMPUTERNAME" -ForegroundColor Blue -NoNewline
  # from posh-git
  Get-GitStatus | Write-PromptGitStatus
  Write-Host " $($PWD.Path | Split-Path -Leaf)" -NoNewline
  return "> "
}

# lazy loading cannot be done well:
# https://github.com/PowerShell/PowerShell/issues/17283

# must be imported manually
# autoimport does not work because module must be used before cmdlet is called
# slow
try {
  Import-Module PSCompletions | Out-Null
}
catch { Write-Output "Error importing PSCompletions module" }
 
function Add-Completion {
  param($executable)
  $resolvedEx = Get-Command $executable -ErrorAction SilentlyContinue

  if (!$resolvedEx) {
    return
  }

  # parse information stream output
  $whichRes = psc which $executable 6>&1
  if (!($whichRes | findstr "you haven't added")) {
    return
  }

  psc add $executable
}

# 150 ms total
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

# winget completions
if (Get-Command winget -ErrorAction SilentlyContinue) {
  Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
  }
}