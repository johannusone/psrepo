# Powershell prompt stopwatch and full path in separate line
## Insert the function into PowerShell profile - Location: $PROFILE

function prompt {

    $promptGetLocation = Get-Location
    $promptLastCommand = Get-History -Count 1
    $promptElapsedTime = ($promptLastCommand.EndExecutionTime - $promptLastCommand.StartExecutionTime).TotalSeconds
    Write-Host "`n[$($promptElapsedTime) s] -- $promptGetLocation\" -ForegroundColor DarkGreen
    Write-Host "PS - $($promptGetLocation | Split-Path -Leaf)\>" -NoNewline -ForegroundColor Gray
    return " "
}