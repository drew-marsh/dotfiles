$Up = [char]0x2191 
$Down = [char]0x2193
$UpDown = [char]0x2195
$TripEq = [char]0x2261
$Ex = [char]0x00D7

$AheadColor = 'Green'
$BehindColor = 'Red'
$NeutralColor = 'Cyan'
$AheadBehindColor = 'Yellow'

function Write-PromptBranch {
  param([Parameter(ValueFromPipeline = $true)]
    $gs
  )

  # Write-Host "$($gs.RepoName)|" -NoNewline -ForegroundColor $NeutralColor
  Write-Host "$($gs.branch)" -NoNewline -ForegroundColor $NeutralColor

  if (!$gs.Upstream) {
    Write-Host " _" -NoNewline -ForegroundColor $AheadColor
    return
  }

  if ($gs.UpstreamGone -eq $true) {
    Write-Host " $Ex" -NoNewline -ForegroundColor $BehindColor
    return
  }

  if (($gs.BehindBy -eq 0) -and ($gs.AheadBy -eq 0)) {
    Write-Host " $TripEq" -NoNewline -ForegroundColor $NeutralColor
    return
  }

  if (($gs.BehindBy -ge 1) -and ($gs.AheadBy -ge 1)) {
    Write-Host " $UpDown" -NoNewline -ForegroundColor $AheadBehindColor
    return
  }

  if (($gs.BehindBy -ge 1)) {
    Write-Host " $Down" -NoNewline -ForegroundColor $BehindColor
    return
  }

  if (($gs.AheadBy -ge 1)) {
    Write-Host " $Up" -NoNewline -ForegroundColor $AheadColor
    return
  }

}

function Write-PromptCommitStatus {
  param([Parameter(ValueFromPipeline = $true)]$gs)

  if ($gs.HasIndex) {
    Write-Host -ForegroundColor Green -NoNewline "+"
  }
  if ($gs.Working.Modified) {
    Write-Host -ForegroundColor Red -NoNewline "*"
  }
  if ($gs.Working.Added) {
    Write-Host -ForegroundColor Red -NoNewline "?"
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

function Get-GitRoot {
  if ($env:GIT_INSTALL_ROOT) {
    return $env:GIT_INSTALL_ROOT
  }

  $GitCmdDir = Get-Command git | Select-Object -ExpandProperty Source | Split-Path
  [System.IO.Path]::GetFullPath((join-path $GitCmdDir ..))
}
