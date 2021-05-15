# WPF Application Async - Short description

Add-Type -AssemblyName PresentationCore, PresentationFramework

# VIEW - XAML UI

# $Xaml = Get-Content "$(Split-Path $MyInvocation.MyCommand.Definition)\WPF_Async.xaml"
$Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
 Width="361" Height="215"
 HorizontalAlignment="Left" VerticalAlignment="Top" Margin="0,0,0,0">
    <Grid>
        <Button Content="Start" HorizontalAlignment="Center" VerticalAlignment="Top" Width="186" Margin="0,125,0,0" Height="39" Name="Button_StartCounting"/>
        <TextBlock HorizontalAlignment="Center" VerticalAlignment="Top" TextWrapping="Wrap" Text="text" Margin="{Binding counter}" Name="TextBlock_CounterDisplay"/>
    </Grid>
</Window>
"@

$Window = [Windows.Markup.XamlReader]::Parse($Xaml)
[xml]$xml = $Xaml
$xml.SelectNodes("//*[@Name]").ForEach({ Set-Variable -Name $_.Name -Value $Window.FindName($_.Name) })

# DataBinding
Function Set-Binding {
    Param($Target, $Property, $Index, $Name)

    $Binding = New-Object System.Windows.Data.Binding
    $Binding.Path = "[" + $Index + "]"
    $Binding.Mode = [System.Windows.Data.BindingMode]::TwoWay

    [void]$Target.SetBinding($Property, $Binding)
}

function FillDataContext($props) {
    For ($i = 0; $i -lt $props.Length; $i++) {
        $prop = $props[$i]
        $DataContext.Add($DataObject."$prop")

        $getter = [scriptblock]::Create("return `$DataContext['$i']")
        $setter = [scriptblock]::Create("param(`$val) return `$DataContext['$i']=`$val")
        $State | Add-Member -Name $prop -MemberType ScriptProperty -Value  $getter -SecondValue $setter
    }
}

# Functions

function start-counting {

    Async {
        $count = 3
        while ($State.controlFlag -eq "start") {
            $State.displayText = $count
            Start-Sleep -Seconds 1
            $count++
        }
    }
}

# MAIN method

$Button_StartCounting.Add_Click(
    {
        if ($State.controlFlag -eq "stop") {
            $State.controlFlag = "start"
            $Button_StartCounting.Content = "Stop"
            start-counting $this $_
        }
        else {
            $State.controlFlag = "stop"
            $Button_StartCounting.Content = "Start"
        }
    }
)

# DataContext

$State = [PSCustomObject]@{}

$DataObject =  ConvertFrom-Json @"
{
    "counter" : 5,
    "displayText": "X",
    "controlFlag" : "stop"
}
"@

$DataContext = New-Object System.Collections.ObjectModel.ObservableCollection[Object]
FillDataContext @("counter","displayText","controlFlag")

$Window.DataContext = $DataContext
Set-Binding -Target $TextBlock_CounterDisplay -Property $([System.Windows.Controls.TextBlock]::MarginProperty) -Index 0 -Name "counter"
Set-Binding -Target $TextBlock_CounterDisplay -Property $([System.Windows.Controls.TextBlock]::TextProperty) -Index 1 -Name "displayText"

# Handler for async function

$Global:SyncHash = [HashTable]::Synchronized(@{})
$Jobs = [System.Collections.ArrayList]::Synchronized([System.Collections.ArrayList]::new())
$initialSessionState = [initialsessionstate]::CreateDefault()

Function Start-RunspaceTask {
    [CmdletBinding()]
    Param([Parameter(Mandatory=$True,Position=0)][ScriptBlock]$ScriptBlock,
          [Parameter(Mandatory=$True,Position=1)][PSObject[]]$ProxyVars)

    $Runspace = [RunspaceFactory]::CreateRunspace($InitialSessionState)
    $Runspace.ApartmentState = 'STA'
    $Runspace.ThreadOptions  = 'ReuseThread'
    $Runspace.Open()
    ForEach($Var in $ProxyVars){$Runspace.SessionStateProxy.SetVariable($Var.Name, $Var.Variable)}
    $Thread = [PowerShell]::Create('NewRunspace')
    $Thread.AddScript($ScriptBlock) | Out-Null
    $Thread.Runspace = $Runspace
    [Void]$Jobs.Add([PSObject]@{ PowerShell = $Thread ; Runspace = $Thread.BeginInvoke() })
}

$JobCleanupScript = {
    Do {
        ForEach($Job in $Jobs) {
            If($Job.Runspace.IsCompleted) {
                [Void]$Job.Powershell.EndInvoke($Job.Runspace)
                $Job.PowerShell.Runspace.Close()
                $Job.PowerShell.Runspace.Dispose()
                $Runspace.Powershell.Dispose()

                $Jobs.Remove($Runspace)
            }
        }
        Start-Sleep -Seconds 1
    }
    While ($SyncHash.CleanupJobs)
}

Get-ChildItem Function: | Where-Object {$_.name -notlike "*:*"} |  Select-Object name -ExpandProperty name |
ForEach-Object {
    $Definition = Get-Content "function:$_" -ErrorAction Stop
    $SessionStateFunction = New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry -ArgumentList "$_", $Definition
    $InitialSessionState.Commands.Add($SessionStateFunction)
}

$Window.Add_Closed({
    Write-Verbose 'Halt runspace cleanup job processing'
    $SyncHash.CleanupJobs = $False
})

$SyncHash.CleanupJobs = $True

function Async($scriptBlock) {
     Start-RunspaceTask $scriptBlock @([PSObject]@{ Name='DataContext' ; Variable=$DataContext},[PSObject]@{Name="State"; Variable=$State})
}

Start-RunspaceTask $JobCleanupScript @([PSObject]@{ Name='Jobs' ; Variable=$Jobs })

$Window.ShowDialog()