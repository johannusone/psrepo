# Piping object containing multiple records into the function returns it coloring every other line

function Format-TwoLine {

    param (
        [System.ConsoleColor]$BGColor1 = 'DarkBlue',
        [System.ConsoleColor]$BGColor2 = 'DarkBlue',
        [System.ConsoleColor]$FGColor1 = 'DarkYellow',
        [System.ConsoleColor]$FGColor2 = 'DarkCyan'
    )

    $TwoLineInner = {
        begin {$ww = $false}
        process {
            Write-Host $_ -BackgroundColor $(if ($ww) {$BGColor1} else {$BGColor2}) -ForegroundColor $(if ($ww) {$FGColor1} else {$FGColor2})
            $ww = -not $ww
        }
    }
    $input | Out-String -Stream | & $TwoLineInner
}
# Set-Alias -Name f2 -Value Format-TwoLine