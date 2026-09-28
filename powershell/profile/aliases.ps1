. $PSScriptRoot\utils.ps1

$GitRoot = Get-GitRoot

Set-Alias less "$GitRoot\usr\bin\less.exe"
Set-Alias bash "$GitRoot\bin\bash.exe"
Set-Alias -Name fd -Value "Invoke-FuzzySetLocation"
Set-Alias -Name fkill -Value "Invoke-FuzzyKillProcess"

${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { set-location ..\.. }
${function:....} = { set-location ..\..\.. }
${function:.....} = { set-location ..\..\..\.. }
${function:......} = { set-location ..\..\..\..\..\.. }
${function:~} = { set-location ~ }
${function:gs} = { git status @args }
${function:ga} = { git add @args }

if (Get-Command curl.exe -ErrorAction SilentlyContinue | Test-Path) {
  rm alias:curl -ErrorAction SilentlyContinue
  ${function:curl} = { curl.exe @args }
  ${function:gurl} = { curl --compressed @args }
}
else {
  ${function:gurl} = { curl -TransferEncoding GZip }
}