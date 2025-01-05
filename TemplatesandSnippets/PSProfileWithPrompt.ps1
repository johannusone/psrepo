$startProfile = [datetime]::Now

# Set-PSDebug -Trace 1

# Formats the output of Get-Command -syntax with line breaks
function Format-Syntax { $input -replace "(\s\[+-|\s-|\s\[<)", "`n `$1" }
Set-Alias -Name fs   -Value Format-Syntax


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


# Set-PSDebug -Trace 0

Write-Host "$('Profile loading time: [{0} s]' -f ((New-TimeSpan -Start $startProfile).TotalSeconds))" -ForegroundColor Green