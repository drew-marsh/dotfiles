. $PSScriptRoot\utils.ps1

$IsElevated = Is-Elevated

$Up = [char]0x2191 
$Down = [char]0x2193
$TripEq = [char]0x2261
$NotTripEq = [char]0x2262
$Ex = [char]0x00D7

Import-Module Catppuccin
$flavor = $catppuccin['Mocha']
$lavender = $flavor.lavender.foreground()
$maroon = $flavor.maroon.foreground()
$sky = $flavor.sky.foreground()
$Sapphire = $Flavor.sapphire.foreground()
$Pink = $Flavor.pink.foreground()
$reset = "$([char]0x1b)[0m"


function Write-PromptBranch {
  param([Parameter(ValueFromPipeline = $true)]
    $gs
  )

  # Write-Host "$($gs.RepoName)|" -NoNewline
  Write-Host "$lavender$($gs.branch)$reset" -NoNewline

  if (!$gs.Upstream) {
    Write-Host " $($maroon)_$reset" -NoNewline
    return
  }

  if ($gs.UpstreamGone -eq $true) {
    Write-Host " $maroon$Ex$reset" -NoNewline
    return
  }

  if (($gs.BehindBy -eq 0) -and ($gs.AheadBy -eq 0)) {
    Write-Host " $lavender$TripEq$reset" -NoNewline
    return
  }

  if (($gs.BehindBy -ge 1) -and ($gs.AheadBy -ge 1)) {
    Write-Host " $peach$NotTripEq$reset" -NoNewline
    return
  }

  if (($gs.BehindBy -ge 1)) {
    Write-Host " $maroon$Down$reset" -NoNewline
    return
  }

  if (($gs.AheadBy -ge 1)) {
    Write-Host " $sky$Up$reset" -NoNewline
    return
  }

}

function Write-PromptCommitStatus {
  param([Parameter(ValueFromPipeline = $true)]$gs)

  if ($gs.HasIndex) {
    Write-Host -NoNewline "$sky+$reset"
  }
  if ($gs.Working.Modified) {
    Write-Host -NoNewline "$maroon*$reset"
  }
  if ($gs.Working.Added) {
    Write-Host -NoNewline "$maroon?$reset"
  }
}

function Write-PromptGitStatus {
  param([Parameter(ValueFromPipeline = $true)]$gs)

  if (!$gs) {
    return
  }

  Write-Host " " -NoNewline
  $gs | Write-PromptBranch
  $gs | Write-PromptCommitStatus
}

function getShellDescription() {
  $Major = $PSVersionTable.PSVersion.Major
  if ($Major -gt 5) {
    return "pwsh$Major"
  }

  return "ps$Major"
}

$shellDescription = getShellDescription

function prompt {
  Write-Host "$Lavender$shellDescription$Reset" -NoNewline

  if ($IsElevated) {
    Write-Host " $($Maroon)E" -NoNewline
  }

  Write-Host " $Sapphire$env:COMPUTERNAME$Reset" -NoNewline
  Write-Host " $Pink$($PWD.Path | Split-Path -Leaf)$Reset" -NoNewline
  Get-GitStatus | Write-PromptGitStatus
  Write-Host ""
  return "$([char]0xf105) "
  
}

