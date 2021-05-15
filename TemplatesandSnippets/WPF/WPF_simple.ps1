# WPF Application - Short description

Add-Type -AssemblyName PresentationCore, PresentationFramework

# VIEW - XAML UI

# $Xaml = Get-Content "$(Split-Path $MyInvocation.MyCommand.Definition)\WPF_simple.xaml"
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

# Functions



# MAIN method



$Window.ShowDialog() | Out-Null