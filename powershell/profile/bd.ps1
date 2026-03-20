function getPathParts {
  (Get-Location).Path -split "\\"
}

function bd {
  param(
    [string]$Pattern
  )

  if (!$Pattern) {
    Set-Location ..
    return
  }
  
  $pathParts = getPathParts
  
  for ($i = $pathParts.Count - 1; $i -ge 0; $i--) {
    if ($pathParts[$i] -like "*$Pattern*") {
      $targetPath = [System.IO.Path]::Combine([string[]]$pathParts[0..$i])
      if ($pathParts[0] -match '^[a-zA-Z]:$') {
        $targetPath = $targetPath + "\"
      }
      Set-Location $targetPath
      return
    }
  }
  
  Write-Host "No match found for pattern: $Pattern"
}

$s = {
  param(
    $commandName,
    $parameterName,
    $wordToComplete,
    $commandAst,
    $fakeBoundParameters
  )

  $options = getPathParts  | Where-Object {
    $_ -like "$wordToComplete*"
  }

  $options[($options.count - 1)..0]
}

Register-ArgumentCompleter -CommandName bd -ParameterName Pattern -ScriptBlock $s