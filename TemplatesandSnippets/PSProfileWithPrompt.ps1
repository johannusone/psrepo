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

$verPatchInfo  = ''
$psEdit        = $PSVersionTable.PSEdition
$versionMajor  = $PSVersionTable.PSVersion.Major
$versionMinor  = $PSVersionTable.PSVersion.Minor
$versionPatch  = $PSVersionTable.PSVersion.Patch
$verPatchInfo  = if($versionMajor -gt 5) { if($null -ne $versionPatch) { ".${versionPatch}" } else { '' } }
$psVerInfo     = "${versionMajor}.${versionMinor}${verPatchInfo}"
$psInfoDisplay = "PowerShell $psVerInfo ($psEdit)"

Write-Host "$('{0} - Profile loading time: [{1} s]' -f $psInfoDisplay, ((New-TimeSpan -Start $startProfile).TotalSeconds))" -ForegroundColor Green