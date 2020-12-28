# Counts how many available or loaded Cmdlets are using the piped values as paramernames
function Get-BPParameterCount {
	[CmdletBinding()]
    param (
		[Parameter(Mandatory,
					ValueFromPipeline)]
        [string[]]$ParameterName
    )
	PROCESS {
		foreach ($Parameter in $ParameterName) {
			$Results = Get-Command -ParameterName $Parameter -ErrorAction SilentlyContinue

			[pscustomobject]@{
				ParameterName = $Parameter
				NumberOfCmdlets = $Results.Count
			}
		}
	}
}

function Get-BPmp4Property {
<#
.SYNOPSIS
    Returns a list of properties of mp4 files

.DESCRIPTION
    Get-BPmp4Property is a function that returns a list of properties of mp4 files.
    Use Get-ChildItem to find files then pipe them into the function or use full path.
    It only evaluates files with .mp4 extension.

    Returns:
            Width    : horizontal pixel count
            Height   : vertical pixel count
            FPS      : frames / second
            Comp     : video compression type
            Bitrate  : average bitrate (kbps)
            Duration : duration in hh:mm:ss
            Path     : full path
            Size     : file size in MB

.EXAMPLE
    PS C:\> Get-ChildItem C:\files\* | Get-BPmp4Property

.EXAMPLE
    PS C:\> Get-BPmp4Property C:\test.mp4

.INPUTS
    System.IO.FileInfo

.OUTPUTS
    PSCustomObject

.PARAMETER Path
    Specifies the path to a file. Wildcard characters are prohibited.
    It can evaluate one file using full path, for multiple files
    use Get-ChildItem and pipe the result into this function.

.NOTES
    Tested on PowerShell 5.1, Windows 10 Pro
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias("Name")]
               [System.IO.FileInfo]
               $Path
)

BEGIN { $shell = New-Object -COMObject Shell.Application }

PROCESS {

    $out = @()

    foreach($currentItem in $Path){

        if ($currentItem.extension -eq '.mp4' -and $currentItem.Attributes -ne "Directory") {

            $folder = Split-Path $currentItem.FullName
            $file = Split-Path $currentItem.FullName -Leaf

            $shellfolder = $shell.Namespace($folder)
            $shellfile = $shellfolder.ParseName($file)

            $resobj = [PSCustomObject]@{
                'Width' = $shellfolder.GetDetailsOf($shellfile, 316)
                'Height' = $shellfolder.GetDetailsOf($shellfile, 314)
                'FPS' = ($shellfolder.GetDetailsOf($shellfile, 315)) -replace "[^\d{1,3}\.\d{1,3}]"

                'Comp' = switch (($shellfolder.GetDetailsOf($shellfile, 311))) {
                    '{34363248-0000-0010-8000-00AA00389B71}' { 'H264' }
                    '{43564548-0000-0010-8000-00AA00389B71}' { 'HEVC' }
                    '{3253344D-0000-0010-8000-00AA00389B71}' { 'M4S2' }
                    Default {$_}
                }

                'Bitrate' = [int] $($shellfolder.GetDetailsOf($shellfile, 320) -replace "\D*")
                'Duration' = $shellfolder.GetDetailsOf($shellfile, 27)
                'Path' = $currentItem.FullName
                'Size' = $shellfolder.GetDetailsOf($shellfile, 1)
            }
            $out += $resobj
        }
    }
    Write-Output $out
}
END {}
}
