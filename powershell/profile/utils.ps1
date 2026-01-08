function Is-Elevated {
  (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Get-GitRoot {
  if ($env:GIT_INSTALL_ROOT) {
    return $env:GIT_INSTALL_ROOT
  }

  $GitCmdDir = Get-Command git | Select-Object -ExpandProperty Source | Split-Path
  [System.IO.Path]::GetFullPath((join-path $GitCmdDir ..))
}
