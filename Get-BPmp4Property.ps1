<#
.SYNOPSIS
    Returns a list of properties of mp4 files

.DESCRIPTION
    Get-BPmp4Property is a function that returns a list of properties of mp4 files.
    Use Get-ChildItem to pipe the files into the function, it only evaluates the ones
    with .mp4 extension.

.EXAMPLE
    Get-ChildItem C:\files\* | Get-BPmp4Property

.INPUTS
    System.IO.FileInfo

.OUTPUTS
    PSCustomObject

.NOTES
    Tested on PowerShell 5.1, Windows 10 Pro
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory,
                ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [System.IO.FileInfo[]]$Name
)

BEGIN {}

PROCESS {

    $out = @()

    $shell = New-Object -COMObject Shell.Application

    foreach($currentItem in $Name){

        if ($currentItem.extension -eq '.mp4') {

            $folder = Split-Path $currentItem.FullName
            $file = Split-Path $currentItem.FullName -Leaf

            $shellfolder = $shell.Namespace($folder)
            $shellfile = $shellfolder.ParseName($file)

            $resobj = [PSCustomObject]@{
                'Width' = $shellfolder.GetDetailsOf($shellfile, 316)
                'Height' = $shellfolder.GetDetailsOf($shellfile, 314)
                'FPS' = ($shellfolder.GetDetailsOf($shellfile, 315)).substring(1,5)

                'Comp' = switch (($shellfolder.GetDetailsOf($shellfile, 311))) {
                    '{34363248-0000-0010-8000-00AA00389B71}' { 'H264' }
                    '{43564548-0000-0010-8000-00AA00389B71}' { 'HEVC' }
                    '{3253344D-0000-0010-8000-00AA00389B71}' { 'M4S2' }
                    Default {$currentItem}
                }

                'Bitrate' = [int] $($shellfolder.GetDetailsOf($shellfile, 320) -replace "\D*")
                'Duration' = $shellfolder.GetDetailsOf($shellfile, 27)
                'Path' = $currentItem.FullName
                # 'SizeCalc' = "$('{0:N0}' -f (($currentItem.Length / 1MB))) MB"
                'Size' = $shellfolder.GetDetailsOf($shellfile, 1)
            }
            $out += $resobj
        }
    }

    Write-Output $out
}

END {}

