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