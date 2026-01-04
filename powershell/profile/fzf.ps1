# Lazy load PsFzf

$initFzf = {
  Import-Module PSFzf
  Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

Set-PSReadLineKeyHandler -Chord 'Ctrl+t' -ScriptBlock {
  & $initFzf
  Invoke-FzfPsReadlineHandlerProvider
}

Set-PSReadLineKeyHandler -Chord 'Ctrl+r' -ScriptBlock {
  & $initFzf
  Invoke-FzfPsReadlineHandlerHistory
}

Set-PSReadLineKeyHandler -Chord 'Alt+c' -ScriptBlock {
  & $initFzf
  Invoke-FzfPsReadlineHandlerSetLocation
}