function updateProfile {
  $PSCommandPath
  $symlinkTarget = (get-item $PSCommandPath).ResolveLinkTarget($true).FullName
  $actualPath = $PSCommandPath
  if ($symlinkTarget) {
    $actualPath = $symlinkTarget
  }

  $psDir = ($actualPath | Split-Path -Parent | Split-Path -Parent)
  $initPath = join-path $psDir init.ps1
  & $initPath
}
