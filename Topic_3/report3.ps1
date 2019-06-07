#1.	Создайте сценарии *.ps1 дл я задач из labwork 2, проверьте их работоспостобность. Каждый сценарий должен иметь параметры.
#1.1.	Сохранить в текстовый файл на диске список запущенных(!) служб. Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.

[CmdletBinding()]
param (
    [parameter(Mandatory=$true,HelpMessage="Input filename for running processes")]
    [string]$OutFile
)


Get-Service | Where-Object {$_.status -like "Running"} | Format-Table -AutoSize | out-file $OutFile

Get-ChildItem .

$RunServices=Get-Content -Path $OutFile
foreach ($line in $RunServices) {
    Write-Host $line
}

#1.2.	Просуммировать все числовые значения переменных среды Windows. (Параметры не нужны)

$s = 0
$val1 = Get-ChildItem variable: | where-object {$_.Value -is [int]}
foreach ($i in $val1.Value)
{
    $s=$s+$i
}
Write-Host "The sum of enviroment variables is $s" 

#1.3.	Вывести список из 10 процессов занимающих дольше всего процессор. Результат записывать в файл.

[CmdletBinding()]
param(
[parameter(Mandatory=$true,HelpMessage="Input number for top CPU processes")]
[int]$NumberTopProcess
)

Get-Process | sort CPU -Descending | select name,CPU -first $NumberTopProcess | Out-File ".\top$NumberTopProcess.txt"

#1.3.1.	Организовать запуск скрипта каждые 10 минут


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



#1.4.	Подсчитать размер занимаемый файлами в папке (например C:\windows) за исключением файлов с заданным расширением(напрмер .tmp)

[CmdletBinding()]
param(
    [parameter(Mandatory=$true,HelpMessage="Input Directory")]
    [string]$Fldr
)

$SizeFldr = 0
foreach ($i in (Get-ChildItem $Fldr -Recurse)){
    if (!($i -like "*.tmp")){
        $SizeFldr = $SizeFldr + $i.Length
    }
}
Write-host ("Size of folder $Fldr is $($SizeFldr /1Mb) Mb") -ForegroundColor Green

#1.5.	Создать один скрипт, объединив 3 задачи:
#1.5.1.	Сохранить в CSV-файле информацию обо всех обновлениях безопасности ОС.
#1.5.2.	Сохранить в XML-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
#1.5.3.	Загрузить данные из полученного в п.1.5.1 или п.1.5.2 файла и вывести в виде списка  разным разными цветами

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true,HelpMessage="Enter path where files will be stored:")]
    [string]$Fld1,
    [Parameter(Mandatory=$false)]
    [string]$RegBranch="HKLM:\SOFTWARE\Microsoft"
)

Get-Hotfix | Export-Csv -path $Fld1\hotfixes.CSV
Get-ChildItem $RegBranch | Export-Clixml $Fld1\reg1.xml
$Csv1 = Import-Csv -path $Fld1\hotfixes.CSV
$Xml1 = Import-Clixml -path $Fld1\reg1.xml
# вывод из CSV
Write-Host ("Info from CSV file") -ForegroundColor Yellow
Write-Host PSComputerName`t`tHotFixID`t`tInstalledOn`t`t`tDescription
foreach ($l in $Csv1){
    Write-Host ("{0}`t`t{1}`t`t{2}`t`t{3}" -f $l.PSComputerName,$l.HotFixID,$l.InstalledOn,$l.Description) -ForegroundColor green
}
# вывод из XML
Write-Host ("Info from XML file") -ForegroundColor Yellow
Write-Host ("SubKeyCount`tValueCount`tName") 
foreach ($l in $Xml1){
    Write-Host ("{0}`t`t{1}`t`t{2}" -f $l.SubKeyCount,$l.ValueCount,$l.Name) -ForegroundColor Blue
}

#2.	Работа с профилем
#2.1.	Создать профиль
New-Item -ItemType file -Path $profile -force

#2.2.	В профиле изненить цвета в консоли PowerShell

(Get-Host).UI.RawUI.ForegroundColor = "green"
(Get-Host).UI.RawUI.BackgroundColor = "black"

#2.3.	Создать несколько собственный алиасов
Set-Alias gh Get-Help
Set-Alias gcom Get-Command

#2.4.	Создать несколько констант
Set-Variable TestInt -option Constant -value 100
Set-Variable TestString -option Constant -value "MyValue"

#2.5.	Изменить текущую папку

Set-Location C:\

#2.6.	Вывести приветсвие
Write-Host "POWER IS SHELL"

#2.7.	Проверить применение профиля

# Сохранили все это в C:\Users\doka\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# Изменения отбразились, но фон слетает ?

#3.	Получить список всех доступных модулей

Get-Module -listAvailable

