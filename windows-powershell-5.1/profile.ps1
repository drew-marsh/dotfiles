Clear-Host

Import-Module posh-git

$Up = [char]0x2191 
$Down = [char]0x2193
$UpDown = [char]0x2195
$TripEq = [char]0x2261
$Ex = [char]0x00D7

$AheadColor = 'Green'
$BehindColor = 'Red'
$NeutralColor = 'Cyan'
$AheadBehindColor = 'Yellow'

function Write-Branch {
  param([Parameter(ValueFromPipeline = $true)]
    $gs
  )

  $branch = $gs.Branch

  if (!$gs.Upstream) {
    Write-Host $branch -NoNewline -ForegroundColor $AheadColor
    return
  }

  if ($gs.UpstreamGone -eq $true) {
    Write-Host "$Ex $branch" -NoNewline -ForegroundColor $BehindColor
    return
  }

  if (($gs.BehindBy -eq 0) -and ($gs.AheadBy -eq 0)) {
    Write-Host "$branch$TripEq" -NoNewline -ForegroundColor $NeutralColor
    return
  }

  if (($gs.BehindBy -ge 1) -and ($gs.AheadBy -ge 1)) {
    Write-Host "$UpDown $branch" -NoNewline -ForegroundColor $AheadBehindColor
  }

  if (($gs.BehindBy -ge 1)) {
    Write-Host "$Down $branch" -NoNewline -ForegroundColor $BehindColor
    return
  }

  if (($gs.AheadBy -ge 1)) {
    Write-Host "$Up $branch" -NoNewline -ForegroundColor $AheadColor
    return
  }

}

function Write-CommitStatus {
  param([Parameter(ValueFromPipeline = $true)]$gs)

  if ($gs.HasIndex) {
    Write-Host -ForegroundColor Green -NoNewline "+"
  }
  if ($gs.HasWorking) {
    Write-Host -ForegroundColor Red -NoNewline "*"
  }
  if ($gs.HasUntracked) {
    Write-Host -ForegroundColor Red -NoNewline "!"
  }
}

function Write-GitStatus {
  param([Parameter(ValueFromPipeline = $true)]$gs)

  if (!$gs) {
    return
  }

  Write-Host " " -NoNewline
  $gs | Write-Branch
  $gs | Write-CommitStatus
}

$IsElevated = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

function prompt {
  Write-Host "PS" -NoNewline -ForegroundColor DarkBlue

  if ($IsElevated) {
    Write-Host " E" -NoNewline -ForegroundColor Red
  }

  Write-Host " $env:USERNAME@$env:COMPUTERNAME" -ForegroundColor DarkGreen -NoNewline
  # from posh-git
  Get-GitStatus | Write-GitStatus
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