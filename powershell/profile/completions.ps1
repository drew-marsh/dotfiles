$env:ARGC_COMPLETIONS_ROOT = "$PSScriptRoot\argc-completions"
$env:ARGC_COMPLETIONS_PATH = ($env:ARGC_COMPLETIONS_ROOT + '\completions\windows;' + $env:ARGC_COMPLETIONS_ROOT + '\completions')
$env:PATH = $env:ARGC_COMPLETIONS_ROOT + '\bin' + [IO.Path]::PathSeparator + $env:PATH     

$argc_scripts = @(
  "7z",
  "bash",
  "cargo",
  "code",
  "curl",
  "docker",
  "docker-compose",
  "doppler",
  "eslint",
  "ftp",
  "git",
  "gh",
  "less",
  "node",
  "npm",
  "npx",
  "nvm",
  "php",
  "scoop",
  "scp",
  "sftp",
  "sftpgo",
  "ssh-keygen",
  "ssh",
  "tsc",
  "tsx",
  "vite",
  "winget",
  "wsl",
  "yq"
)

argc --argc-completions powershell $argc_scripts | Out-String | Invoke-Expression