$STName = "OutputTopCPUProcesses"
$STDescription = "Output Top CPU Processes"
$STAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File f:\Dropbox\_epam\homework\2_powershell\Topic_3\report3.1.3.ps1 -NumberTopProcess 7"
$STTrigger = New-ScheduledTaskTrigger -Daily -At 11am
$STSettings = New-ScheduledTaskSettingsSet
$STUserName = "$Env:USERDOMAIN`\$Env:USERNAME"
$STCredentials = Get-Credential -UserName $STUserName -Message "Enter password"
$STPassword = $STCredentials.GetNetworkCredential().Password

Register-ScheduledTask -TaskName $STName -Description $STDescription -Action $STAction -Trigger $STTrigger -User $STUserName -Password $STPassword -RunLevel Highest -Settings $STSettings
Start-Sleep -Seconds 3

$STModify = Get-ScheduledTask -TaskName $STName
$STModify.Triggers.repetition.Duration = 'P1D'
$STModify.Triggers.repetition.Interval = 'PT10M'
$STModify | Set-ScheduledTask -User $STUserName -Password $STPassword