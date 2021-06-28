# Formats the output of Get-Command -syntax with line breaks
function Format-Syntax { $input -replace "(\s\[+-|\s-|\s\[<)", "`n `$1" }
Set-Alias -Name fs -Value Format-Syntax