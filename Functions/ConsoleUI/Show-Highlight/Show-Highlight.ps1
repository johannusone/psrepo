function Show-Highlight {
<#
.SYNOPSIS
Show-Highlight is a function that returns a string highlighting
the matching pattern.

.DESCRIPTION
Show-Highlight returns a string highlighting the matching pattern.
The pattern is based on regular expression, use CaseSensitive switch
for matching only part of the text that is exactly matches the pattern.
The input string can be piped into the function.
The background and foreground color can be customized using parameters.
Approved colors are [System.ConsoleColor]:
    0 Black
    1 DarkBlue
    2 DarkGreen
    3 DarkCyan
    4 DarkRed
    5 DarkMagenta
    6 DarkYellow
    7 Gray
    8 DarkGray
    9 Blue
   10 Green
   11 Cyan
   12 Red
   13 Magenta
   14 Yellow
   15 White

.PARAMETER InputString
The reference string in which the function is trying to match
the given pattern.

.PARAMETER Pattern
The pattern parameter uses regular expression.

.PARAMETER BackgroundColor
It sets the background color of the matching patterns.
It accepts [System.ConsoleColor], use auto completion.

.PARAMETER ForegroundColor
It sets the foreground color of the matching patterns.
It accepts [System.ConsoleColor], use auto completion.

.PARAMETER CaseSensitive
Indicates that the cmdlet matches are case-sensitive.
By default, matches aren't case-sensitive.

.EXAMPLE
"This is a string for testing." | Show-Highlight -Pattern "T|\bis|\." -CaseSensitive

.NOTES
Tested on Powershell 5.1, Windows 10
#>
    [CmdletBinding()]

    param(
        [string]$Pattern,
        [Parameter(ValueFromPipeline)]
        [string]$InputString,
        [System.ConsoleColor]$BackgroundColor = 'Gray',
        [System.ConsoleColor]$ForegroundColor = 'DarkBlue',
        [switch]$CaseSensitive
    )

    Write-Verbose "Pattern: '$Pattern'"
    Write-Verbose "BackgroundColor: '$BackgroundColor'"
    Write-Verbose "ForegroundColor: '$ForegroundColor'"
    Write-Verbose "CaseSensitive: '$CaseSensitive'"

    $splittedString = $InputString -split "($Pattern)"

    if ($CaseSensitive){
        foreach ($innerPattern in $splittedString) {
            if($innerPattern -cmatch $Pattern){
                Write-Host $innerPattern -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
                continue
            }
                Write-Host $innerPattern -NoNewline
        }
    } else {
        foreach ($innerPattern in $splittedString) {
            if($innerPattern -match $Pattern){
                Write-Host $innerPattern -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
                continue
            }
                Write-Host $innerPattern -NoNewline
        }
    }
}