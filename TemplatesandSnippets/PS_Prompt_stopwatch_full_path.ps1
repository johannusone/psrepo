# Powershell prompt stopwatch and full path in separate line
## Insert the function into PowerShell profile - Location: $PROFILE

function prompt {

    $promptLastCommand = Get-History -Count 1
    $promptElapsedTime = ([timespan]($promptLastCommand.EndExecutionTime - $promptLastCommand.StartExecutionTime)).TotalSeconds
    Write-Host "`nExecution time: [$promptElapsedTime s]" -ForegroundColor DarkGray

    $lineCharacterForPrompt       = [string][char]0x2500
    $promptExecutionSeparatorLine = $lineCharacterForPrompt * $Host.UI.RawUI.WindowSize.Width
    Write-Host "$promptExecutionSeparatorLine" -ForegroundColor DarkGreen

    $currentLocationForPrompt = $PWD.Path
    Write-Host "LOCATION: [$currentLocationForPrompt\]" -ForegroundColor DarkGreen

    $global:counterForPowerShellConsolePrompt++
    Write-Host "[$counterForPowerShellConsolePrompt] - $($currentLocationForPrompt | Split-Path -Leaf)\>" -NoNewline -ForegroundColor Gray
    return " "

}