$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -argument "full_path_of_the_ps1_file"
$trigger = New-ScheduledTaskTrigger -Daily -At 18:00
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "_name_of_the_task" -Description "Description_text"