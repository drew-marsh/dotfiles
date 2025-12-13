param([switch]$force)

$profileExists = Test-Path($PROFILE)

if ($profileExists -and !$force ) {
  $confirmation = Read-Host "Profile file exists. overwrite? (y/n)"
  if (!$confirmation.ToLower().Equals("y")) {
    Write-Output "Exiting"
    exit 0
  }
}

$dir = Split-Path $PROFILE -Parent

if (!(Test-Path $dir)) {
  md $dir | Out-Null
}

Get-Content $PSScriptRoot\profile.ps1 | Set-Content -path $PROFILE