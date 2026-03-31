function updateProfile {
  $symlinkTarget = (get-item $PSCommandPath).ResolveLinkTarget($true).FullName
  $actualPath = $PSCommandPath
  if ($symlinkTarget) {
    $actualPath = $symlinkTarget
  }

  $dotfiles = ($actualPath | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent)
  $initPath = join-path $dotfiles powershell/init.ps1
  git -C $dotfiles pull
  & $initPath
}
