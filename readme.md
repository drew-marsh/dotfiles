# Powershell

## Bootstrap

Initializes powershell environment. Zero dependencies, this can be run from a clean windows install.
Requires non-elevated shell

`Set-ExecutionPolicy RemoteSigned -Scope CurrentUser; Invoke-RestMethod "https://raw.githubusercontent.com/drew-marsh/dotfiles/main/powershell/bootstrap.ps1" | invoke-expression`

## Init

Initializes powershell environment, from this repo.
Requires non-elevated shell

`. .\powershell\init -force`
