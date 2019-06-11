
# 1. При помощи WMI перезагрузить все виртуальные машины.
$virt_cred = Get-Credential Administrator
$names_vms = @("dokutovich-vm1","dokutovich-vm2","dokutovich-vm3")
Get-WmiObject Win32_OperatingSystem –computer $names_vms -Credential $virt_cred | Invoke-WmiMethod –Name Reboot

# 2. При помощи WMI просмотреть список запущенных служб на удаленном компьютере. 

$cred = get-credential Administrator
$rem = gwmi win32_service –credential $cred –computer dokutovich-vm1
Write-Host Name`tState -ForegroundColor Green
foreach ($i in $rem) {
    if ($i.State -eq "Running"){
        Write-Host ("{0}`t{1}" -f $i.Name,$i.State)
    }
}

# почему не работает $rem | Write-Host $_.Name ?


# 3. Настроить PowerShell Remoting, для управления всеми виртуальными машинами с хостовой.

# на клиетах выполняем (server 2012 и более свежий - не нужно)
Enable-PSRemoting
# на хосте добавляем удаленные машины в trusted
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "dokutovich-vm1,dokutovich-vm2,dokutovich-vm3"
#подключаемся
Enter-PSSession -ComputerName dokutovich-vm1 -Credential $cred

# 4. Для одной из виртуальных машин установить для прослушивания порт 42658. Проверить работоспособность PS Remoting.

# на  dokutovich-vm3 меняем порт на listening
Set-Item WSMan:\localhost\listener\Listener_1084132640\Port 42658
# подключаемся
Enter-PSSession -ComputerName dokutovich-vm3 -Credential $cred -Port 42658
 

# 5. Создать конфигурацию сессии с целью ограничения использования всех команд, кроме просмотра содержимого дисков.

$cred2 = Get-Credential administrator
# создали конфигурационный файл, можно теоретически добавить Set-Location 
New-PSSessionConfigurationFile -Path C:\1\_lim_dir.pssc `
    -VisibleCmdlets Get-ChildItem, Get-Help, Exit-PSSession, Get-Command,Get-FormatData, `
    Measure-Object, Out-Default, Select-Object
# протестировали его
Test-PSSessionConfigurationFile -Path C:\1\_lim_dir.pssc
# зарегили конфигурацию сессии, разрешили testuser удаленное подключения
Register-PSSessionConfiguration -Name lim_dir -Path C:\1\_lim_dir.pssc -RunAsCredential $cred2 -ShowSecurityDescriptorUI


#собственно  удаленное подключение
New-PSSession -ComputerName dokutovich-vm1 -ConfigurationName lim_dir -Credential testuser

