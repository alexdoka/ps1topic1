# 1.	Просмотреть содержимое ветви реeстра HKCU
dir HKLM:\SYSTEM\CurrentControlSet\Services\ACPI\Parameters | fl

# 2.	Создать, переименовать, удалить каталог на локальном диске
mkdir f:\MyFolder
Rename-Item -path F:\MyFolder -NewName Aliaksandr_Dakutovich
Remove-Item F:\Aliaksandr_Dakutovich

# 3.	Создать папку C:\M2T2_ФАМИЛИЯ. Создать диск ассоциированный с папкой C:\M2T2_ФАМИЛИЯ.
mkdir c:\M2T2_Dakutovich
New-PSDrive -Name "PersonalFolder" -PSProvider "FileSystem" -Root C:\M2T2_Dakutovich

# 4.	Сохранить в текстовый файл на созданном диске список запущенных(!) служб. Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.
Get-Service | Where-Object {$_.status -like "Running"} | Format-Table -AutoSize | out-file PersonalFolder:\service_running.txt

Get-ChildItem PersonalFolder:

$RunServices=Get-Content -Path PersonalFolder:\service_running.txt
foreach ($line in $RunServices) {
    Write-Host $line
}

# 5.	Просуммировать все числовые значения переменных текущего сеанса.
$s = 0
$val1 = Get-ChildItem variable: | where-object {$_.Value -is [int32]}
foreach ($i in $val1.Value)
{
    $s=$s+$i
}
Write-Host $s

# 6.	Вывести список из 6 процессов занимающих дольше всего процессор.
Get-Process | sort CPU -Descending | select name,CPU -first 6

# 7.	Вывести список названий и занятую виртуальную память (в Mb) каждого процесса, разделённые знаком тире, 
# при этом если процесс занимает более 100Mb – выводить информацию красным цветом, иначе зелёным.
$FullProcess = Get-Process
foreach ($proc in $FullProcess){
    $ProcInMb = $proc.VM /1Mb
    
    if ($ProcInMb -gt 100){$fgrnd = "red"}
    else {$fgrnd = "green"}

    Write-Host ("{0} - {1} MB" -f $proc.Name,$($proc.VM /1Mb) ) -ForegroundColor $fgrnd
}

# 8.	Подсчитать размер занимаемый файлами в папке C:\windows (и во всех подпапках) за исключением файлов *.tmp
$Fldr = "d:\mp3\Brainstorm\"
$SizeFldr = 0
foreach ($i in (Get-ChildItem $Fldr -Recurse)){
    if (!($i -like "*.tmp")){
        $SizeFldr = $SizeFldr + $i.Length
    }
}
Write-host ("Size of folder $Fldr is $($SizeFldr /1Mb) Mb") -ForegroundColor Green


# 9.	Сохранить в CSV-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
Get-ChildItem HKLM:\SOFTWARE\Microsoft | Export-Csv D:\microsoft.csv

# 10.	Сохранить в XML -файле историческую информацию о командах выполнявшихся в текущем сеансе работы PS.
Get-History | Export-Clixml "d:\hist.xml"

# 11.	Загрузить данные из полученного в п.10 xml-файла и вывести в виде списка информацию о каждой записи, 
# в виде 5 любых (выбранных Вами) свойств.
Write-Host ("{0}`t{1}`t{2}`t{3}`t{4}" -f "id","StartExecutionTime","EndExecutionTime","ExecutionStatus","CommandLine") -BackgroundColor Blue
foreach ($lst in (Import-Clixml "d:\hist.xml")){
    Write-Host ("{0}`t{1}`t{2}`t{3}`t{4}" -f $lst.id,$lst.StartExecutionTime,$lst.EndExecutionTime,$lst.ExecutionStatus,$lst.CommandLine)
}

# 12.	Удалить созданный диск и папку С:\M2T2_ФАМИЛИЯ
Remove-PSDrive PersonalFolder
Remove-Item c:\M2T2_Dakutovich\

