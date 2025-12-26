# Zero-requirement script to initialize powershell environment

# must dot source
if ($MyInvocation.InvocationName -ne '.') {
  throw "This script must be dot-sourced"
}

$IsElevated = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

$scoop = get-command scoop -ErrorAction SilentlyContinue
if (!$scoop) {
  if ($IsElevated) {
    throw "Scoop install requires non-elevated shell"
  }
  
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

$git = get-command git -ErrorAction SilentlyContinue
if (!$git) {
  scoop install git
  git config --global user.name "Drew Marshall"
  git config --global user.email "thedrewguy@gmail.com"
  git config --global init.defaultbranch main
  git config --global push.autosetupremote true
}

git clone git@github.com:drew-marsh/dotfiles
. .\dotfiles\powershell\init.ps1