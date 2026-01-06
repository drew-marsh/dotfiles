$cmd = {
  param($profilePath)
  $t = measure-command {
    . $profilePath
  }
  "$([Math]::Round($t.totalMilliseconds)) ms"
}

pwsh.exe -NoLogo -NoProfile -Command $cmd -Args "$PSScriptRoot\profile\profile.ps1"
