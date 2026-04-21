param([Switch]$force)

. $PSScriptRoot\profile\utils.ps1

$gitRoot = $PSScriptRoot | Split-Path -Parent

git -C $gitRoot submodule init
git -C $gitRoot submodule update

function Install-ScoopBucketIfMissing {
  param($bucket)
  $installedBucket = scoop bucket list | select-object -expandproperty name | findstr $bucket

  if ($installedBucket) {
    return;
  }

  scoop bucket add $bucket
}

function Install-ScoopPackageIfMissing {
  param($package)
  $installedPackage = scoop list 6> $null | select-object -expandproperty name | findstr $package

  if ($installedPackage) {
    return;
  }

  scoop install $package
}


function Install-ModuleIfMissing {
  param($module)
  $installedModule = Get-Module $module -ListAvailable
  
  if ($installedModule) {
    return;
  }
  
  Install-Module `
    $module `
    -Scope CurrentUser `
    -SkipPublisherCheck `
    -Force `
    -ErrorAction SilentlyContinue `
    -AllowClobber `
  | Out-Null
}

$scoop = get-command scoop -ErrorAction SilentlyContinue
if (!$scoop) {
  if (Is-Elevated) {
    throw "Scoop install requires non-elevated shell"
  }
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

$fzf = get-command fzf -ErrorAction SilentlyContinue

if (!$fzf) {
  scoop install fzf
}

Install-ModuleIfMissing PSFzf
Install-ModuleIfMissing z
Install-ModuleIfMissing Posh-Git

$catppuccinModule = Get-Module catppuccin -ListAvailable

if (-not $catppuccinModule) {
  $moduleDir = $env:PSModulePath.Split(';')[0];
  cmd /c mklink /D "$moduleDir\Catppuccin" "$PSScriptRoot\modules\catppuccin" | Out-Null
}

$psReadLine = get-module PSReadLine

if (!$psReadLine -or ($psReadLine.Version.Minor -lt 1)) {
  Install-Module PSReadLine -Force -SkipPublisherCheck -Scope CurrentUser
}

# download argc-completions tools
$GitRoot = Get-GitRoot
Set-Alias bash "$GitRoot\bin\bash.exe"
bash $PSScriptRoot\profile\argc-completions\scripts\download-tools.sh | Out-Null

# overwrite profile
$profileExists = Test-Path $PROFILE

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

ls $PSScriptRoot\profile | ForEach-Object {
  $linkPath = "$dir\$($_.name)"
  
  if (Test-Path $linkPath) {
    rm -r -force $linkPath
  }

  if ($_.PSIsContainer) {
    cmd /c mklink /D "$linkPath" "$($_.FullName)" | Out-Null
  }
  else {
    cmd /c mklink "$linkPath" "$($_.FullName)" | Out-Null
  }
}

mv -Force $dir\profile.ps1 $PROFILE

Write-Output "Start a new shell to load"