$cmd = @"
`$t = measure-command {
  . $PSScriptRoot\profile.ps1
  }
"`$([Math]::Round(`$t.totalMilliseconds)) ms"
"@

# profile needs interactive session
powershell.exe -NoLogo -NoProfile -Command $cmd
