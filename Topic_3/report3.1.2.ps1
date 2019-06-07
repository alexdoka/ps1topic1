#1.2.	Просуммировать все числовые значения переменных среды Windows. (Параметры не нужны)
$s = 0
$val1 = Get-ChildItem variable: | where-object {$_.Value -is [int]}
foreach ($i in $val1.Value)
{
    $s=$s+$i
}
Write-Host "The sum of enviroment variables is $s" 