function prompt {
  $IsElevated = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
  Write-Host "PS " -NoNewline -ForegroundColor Blue

  if ($IsElevated) {
    Write-Host "E " -NoNewline -ForegroundColor Red
  }

  Write-Host "$env:USERNAME@$env:COMPUTERNAME" -ForegroundColor Green -NoNewline
  return " $PWD> "
}