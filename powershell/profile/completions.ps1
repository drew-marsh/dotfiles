# modified from https://github.com/CoLogler/PSLazyCompletion

$completions = @{}

$completions["winget"] = { if (Get-Command winget -ErrorAction SilentlyContinue) {
        Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
            param($wordToComplete, $commandAst, $cursorPosition)
            [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
            $Local:word = $wordToComplete.Replace('"', '""')
            $Local:ast = $commandAst.ToString().Replace('"', '""')
            winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
    } }

$getExecutionContextFromTLS = [PowerShell].Assembly.GetType('System.Management.Automation.Runspaces.LocalPipeline').GetMethod(
    'GetExecutionContextFromTLS',
    [System.Reflection.BindingFlags]'Static,NonPublic'
)
$internalExecutionContext = $getExecutionContextFromTLS.Invoke(
    $null,
    [System.Reflection.BindingFlags]'Static, NonPublic',
    $null,
    $null,
    $psculture
)

$argumentCompletersProperty = $internalExecutionContext.GetType().GetProperty(
    'NativeArgumentCompleters',
    [System.Reflection.BindingFlags]'NonPublic, Instance'
)

$loaded = New-Object System.Collections.Generic.HashSet[string]

$completions.GetEnumerator().ForEach({
        $Command = $_.Key
        $Script = $_.Value

        Register-ArgumentCompleter -Native -CommandName $command -ScriptBlock {
            if (!$loaded.Add($command)) {
                return;
            }
        
            . $Script
        
            $argumentCompleters = $argumentCompletersProperty.GetGetMethod($true).Invoke(
                $internalExecutionContext,
                [System.Reflection.BindingFlags]'Instance, NonPublic, GetProperty',
                $null,
                @(),
                $psculture
            )
        
            if ($argumentCompleters.ContainsKey($command)) {
                $scriptBlock = $argumentCompleters[$command];
                return Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $args
            }
        }.GetNewClosure() # make sure local variables in the context were copied
    })
