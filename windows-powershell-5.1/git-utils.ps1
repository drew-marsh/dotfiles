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
    Write-Host "$branch $Ex" -NoNewline -ForegroundColor $BehindColor
    return
  }

  if (($gs.BehindBy -eq 0) -and ($gs.AheadBy -eq 0)) {
    Write-Host "$branch $TripEq" -NoNewline -ForegroundColor $NeutralColor
    return
  }

  if (($gs.BehindBy -ge 1) -and ($gs.AheadBy -ge 1)) {
    Write-Host "$branch $UpDown" -NoNewline -ForegroundColor $AheadBehindColor
  }

  if (($gs.BehindBy -ge 1)) {
    Write-Host "$branch $Down" -NoNewline -ForegroundColor $BehindColor
    return
  }

  if (($gs.AheadBy -ge 1)) {
    Write-Host "$branch $Up" -NoNewline -ForegroundColor $AheadColor
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
