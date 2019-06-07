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

Write-Host ("Info from CSV file") -ForegroundColor Yellow
Write-Host PSComputerName`t`tHotFixID`t`tInstalledOn`t`t`tDescription
foreach ($l in $Csv1){
    Write-Host ("{0}`t`t{1}`t`t{2}`t`t{3}" -f $l.PSComputerName,$l.HotFixID,$l.InstalledOn,$l.Description) -ForegroundColor green
}

Write-Host ("Info from XML file") -ForegroundColor Yellow
Write-Host ("SubKeyCount`tValueCount`tName") 
foreach ($l in $Xml1){
    Write-Host ("{0}`t`t{1}`t`t{2}" -f $l.SubKeyCount,$l.ValueCount,$l.Name) -ForegroundColor Blue
}