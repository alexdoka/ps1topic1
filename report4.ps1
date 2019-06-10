# 1.	Вывести список всех классов WMI на локальном компьютере. 
gwmi –list


# 2.	Получить список всех пространств имён классов WMI. 
Function Get-WmiNamespace {
    Param (
        $Namespace='root'
    )
    Get-WmiObject -Namespace $Namespace -Class __NAMESPACE | ForEach-Object {
            ($ns = '{0}\{1}' -f $_.__NAMESPACE,$_.Name)
            Get-WmiNamespace $ns
    }
}
Get-WmiNamespace


# 3.	Получить список классов работы с принтером.

gwmi –list | where {$_.Name -like "*printer*"}


# 4.	Вывести информацию об операционной системе, не менее 10 полей.

gwmi win32_operatingsystem | Select PSComputerName,BuildNumber,CodeSet,CurrentTimeZone,Description,InstallDate,Name,Organization,OSType,Version

# 5.	Получить информацию о BIOS.
gwmi -class Win32_BIOS | select * | fl

# 6.	Вывести свободное место на локальных дисках. На каждом и сумму.

$LogicDisk = gwmi -class Win32_LogicalDisk 
$TotalFreeSpace = 0
foreach ($ld in $LogicDisk) {
    Write-Host "Free space on logical disk $($ld.DeviceID) is  $([math]::Round($($($ld.Freespace)/1Gb),2)) Gb"
    $TotalFreeSpace += $ld.Freespace
}
Write-Host "Total free space on all disks is $([math]::Round($($TotalFreeSpace/1Gb),2)) Gb"


# 7.	Написать сценарий, выводящий суммарное время пингования компьютера (например 10.0.0.1) в сети.

function PingIP {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory=$true,HelpMessage="Input IP address or FQDN",Position=0)]
        [String] $SiteAddress,
        [Parameter(Mandatory=$false,HelpMessage="Input pings number",Position=1)]
        [int] $NumberOfPings = 4
    )
    $SumResponseTime = 0
    $Addr = "Address=`""+$SiteAddress+"`""
    for ($i = 0; $i -lt $NumberOfPings; $i++) {
        $SumResponseTime += (Get-WmiObject -Class Win32_PingStatus -Filter $Addr).ResponseTime     
    }
    Write-Output "Total response time for ICMP requests is $SumResponseTime ms"
}
 
PingIP -SiteAddress "ya.ru" 20

# 8.	Создать файл-сценарий вывода списка установленных программных продуктов в виде таблицы с полями Имя и Версия.

gwmi Win32_Product | select Name, Version | Format-Table

# 9.	Выводить сообщение при каждом запуске приложения MS Word.
Get-EventSubscriber | Unregister-Event
$qry = "SELECT * FROM __InstanceCreationEvent WITHIN 1 WHERE TargetInstance isa 'Win32_Process'"
Register-WmiEvent -Query $qry -SourceIdentifier NewWord -Action {
    $e = $EventArgs.NewEvent.TargetInstance
    if($e.Name -eq 'winword.exe')
    {
        Write-host "The app Word was started"
    }
}



