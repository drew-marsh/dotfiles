function getBackDirs {
  $parentPath = (Get-Location).Path | Split-Path -Parent
  $parentPath -split "\\" | Where-Object { $_.Length }
}

function bd {
  param(
    [string]$Pattern
  )

  if (!$Pattern) {
    Set-Location ..
    return
  }
  
  $backDirs = @(getBackDirs)
  
  for ($i = $backDirs.Count - 1; $i -ge 0; $i--) {
    if ($backDirs[$i] -like "$Pattern*") {
      $targetPath = [System.IO.Path]::Combine([string[]]$backDirs[0..$i])
      if ($backDirs[0] -match '^[a-zA-Z]:$') {
        $targetPath = $targetPath + "\"
      }
      Set-Location $targetPath
      return
    }
  }
  Write-Output "No match found for: $Pattern"
}

$s = {
  param(
    $commandName,
    $parameterName,
    $wordToComplete,
    $commandAst,
    $fakeBoundParameters
  )

  $options = @(getBackDirs | Where-Object {
      $_ -like "$wordToComplete*"
    })

  if (-not $options.count) {
    return "";
  }

  $options[($options.count - 1)..0]
}

Register-ArgumentCompleter -CommandName bd -ParameterName Pattern -ScriptBlock $s