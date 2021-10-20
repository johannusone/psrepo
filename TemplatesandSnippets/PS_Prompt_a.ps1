# Insert the function into PowerShell profile - Location: $PROFILE

function prompt {

$promptGetLocation = Get-Location
$promptlastCommand = Get-History -Count 1
$promptelapsedTime = ($promptlastCommand.EndExecutionTime - $promptlastCommand.StartExecutionTime).TotalSeconds
Write-Host "`n[$($promptelapsedTime) s] -- " -NoNewLine -ForegroundColor DarkYellow

Write-Host "$promptGetLocation\" -ForegroundColor DarkGreen
Write-Host "PS - $($promptGetLocation | Split-Path -Leaf)\>" -NoNewline -ForegroundColor Gray
return " "
}
