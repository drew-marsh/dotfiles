# Powershell

## Bootstrap

Initializes powershell environment. Zero dependencies, this can be run from a clean windows install.

`Set-ExecutionPolicy RemoteSigned -Scope CurrentUser; Invoke-RestMethod "https://raw.githubusercontent.com/drew-marsh/dotfiles/main/powershell/bootstrap.ps1" | invoke-expression`

## Init

Initializes powershell environment, from this repo.

`. .\powershell\init -force`