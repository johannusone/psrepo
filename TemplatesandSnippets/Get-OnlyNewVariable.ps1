function Get-OnlyNewVariable {
    <#
    .SYNOPSIS
        Returns a list of variable names that have been created newly in the current session
    .DESCRIPTION
        Get-OnlyNewVariable is a function that returns a list of variable names that have been
        created newly in the current session.
        If there is no user variable created in the current session it returns $null
    .EXAMPLE
        PS C:\> Get-OnlyNewVariable
    #>

    Compare-Object -ReferenceObject $(Get-Variable).Name -DifferenceObject '$',
        '?',
        '^',
        'args',
        'ConfirmPreference',
        'ConsoleFileName',
        'DebugPreference',
        'Error',
        'ErrorActionPreference',
        'ErrorView',
        'ExecutionContext',
        'false',
        'FormatEnumerationLimit',
        'HOME',
        'Host',
        'InformationPreference',
        'input',
        'MaximumAliasCount',
        'MaximumDriveCount',
        'MaximumErrorCount',
        'MaximumFunctionCount',
        'MaximumHistoryCount',
        'MaximumVariableCount',
        'MyInvocation',
        'NestedPromptLevel',
        'null',
        'OutputEncoding',
        'PID',
        'PROFILE',
        'ProgressPreference',
        'PSBoundParameters',
        'PSCommandPath',
        'PSCulture',
        'PSDefaultParameterValues',
        'PSEdition',
        'PSEmailServer',
        'PSHOME',
        'PSScriptRoot',
        'PSSessionApplicationName',
        'PSSessionConfigurationName',
        'PSSessionOption',
        'PSUICulture',
        'PSVersionTable',
        'PWD',
        'ShellId',
        'StackTrace',
        'true',
        'VerbosePreference',
        'WarningPreference',
        'WhatIfPreference',
        'EnabledExperimentalFeatures',
        'IsCoreCLR',
        'IsLinux',
        'IsMacOS',
        'IsWindows' |
     Where-Object SideIndicator -eq '<=' |
      Select-Object -ExpandProperty InputObject
}
