$t = Measure-Command {
  . $PSScriptRoot\profile.ps1
}

Write-Output "ms: $($t.TotalMilliseconds)"