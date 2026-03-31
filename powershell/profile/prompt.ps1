. $PSScriptRoot\utils.ps1


$IsElevated = Is-Elevated
Import-Module Catppuccin
$flavor = $catppuccin['Mocha']

$esc = @{
  lavender = $flavor.lavender.foreground()
  maroon   = $flavor.maroon.foreground()
  sky      = $flavor.sky.foreground()
  blue     = $flavor.blue.foreground()
  Sapphire = $Flavor.sapphire.foreground()
  pink     = $Flavor.pink.foreground()
  peach    = $Flavor.peach.foreground()
  overlay2 = $Flavor.Overlay2.Foreground()
  reset    = "$([char]0x1b)[0m"
}

$chars = @{
  up        = [char]0x2191;
  down      = [char]0x2193;
  tripEq    = [char]0x2261;
  notTripEq = [char]0x2262;
  ex        = [char]0x00D7;
  gt        = [char]0xf105;
  offline   = [char]0xf4ad;
}

$promptText = "$($chars.gt) "


function Write-PromptBranch {
  param([Parameter(ValueFromPipeline = $true)]
    $gs
  )

  # Write-Host "$($gs.RepoName)|" -NoNewline
  Write-Host "$($esc.lavender)$($gs.branch)$($esc.reset)" -NoNewline

  if (!$gs.Upstream) {
    Write-Host " $($esc.lavender)$($chars.offline)$($esc.reset)" -NoNewline
    return
  }

  if ($gs.UpstreamGone -eq $true) {
    Write-Host " $($esc.maroon)$($chars.Ex)$($esc.reset)" -NoNewline
    return
  }

  if (($gs.BehindBy -eq 0) -and ($gs.AheadBy -eq 0)) {
    Write-Host " $($esc.lavender)$($chars.TripEq)$($esc.reset)" -NoNewline
    return
  }

  if (($gs.BehindBy -ge 1) -and ($gs.AheadBy -ge 1)) {
    Write-Host " $($esc.peach)$($chars.NotTripEq)$($esc.reset)" -NoNewline
    return
  }

  if (($gs.BehindBy -ge 1)) {
    Write-Host " $($esc.maroon)$($chars.down)$($esc.reset)" -NoNewline
    return
  }

  if (($gs.AheadBy -ge 1)) {
    Write-Host " $($esc.sky)$($chars.up)$($esc.reset)" -NoNewline
    return
  }

}

function Write-PromptCommitStatus {
  param([Parameter(ValueFromPipeline = $true)]$gs)

  if ($gs.HasIndex -or $gs.working.Modified -or $gs.Working.Added) {
    write-host -NoNewline " "
  }

  if ($gs.HasIndex) {
    Write-Host -NoNewline "$($esc.sky)+$($esc.reset)"
  }
  if ($gs.Working.Modified -or $gs.Working.Deleted) {
    Write-Host -NoNewline "$($esc.maroon)*$($esc.reset)"
  }
  if ($gs.Working.Added) {
    Write-Host -NoNewline "$($esc.maroon)?$($esc.reset)"
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

function getShExe() {
  $Major = $PSVersionTable.PSVersion.Major
  if ($Major -gt 5) {
    return "pwsh"
  }

  return "powershell"
}

$shExe = getShExe

function getShDesc {
  if ($shExe -eq "pwsh") {
    return "pwsh"
  }

  return "ps"
}

$shDesc = getShDesc

function Write-PromptPath {
  $path = $PWD.path
  $parent = $path | Split-Path -Parent
  if ($parent -and -not ($parent -like "*`\")) {
    $parent = "$parent`\"
  }
  $leaf = $path | Split-Path -Leaf

  Write-Host -NoNewline " $($esc.overlay2)$parent$($esc.reset)"
  Write-Host -NoNewline "$($esc.pink)$leaf$($esc.reset)"
}

function prompt {
  Write-Host "$($esc.blue)$shDesc$($esc.reset)" -NoNewline

  if ($IsElevated) {
    Write-Host "$($esc.maroon) E$($esc.reset)" -NoNewline
  }

  Write-Host " $($esc.sapphire)$env:COMPUTERNAME$($esc.Reset)" -NoNewline
  Get-GitStatus | Write-PromptGitStatus
  Write-PromptPath
  Write-Host ""
  return $promptText
}

Set-PSReadLineOption -PromptText $promptText