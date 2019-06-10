#1.	Получите справку о командлете справки
Get-Help Get-Help

#2.	Пункт 1, но детальную справку, затем только примеры
Get-Help Get-Help -Full
Get-Help Get-Help -Examples

#3.	Получите справку о новых возможностях в PowerShell 4.0 (или выше)
Get-Help about_Windows_PowerShell_5.0

#4.	Получите все командлеты установки значений
Get-Command set* | Where-Object {$_.CommandType  -Like "Cmdlet"}

#5.	Получить список команд работы с файлами
Get-Command *file*

#6.	Получить список команд работы с объектами
Get-Command *object*

#7.	Получите список всех псевдонимов
cd alias:
ls

Get-Alias

#8.	Создайте свой псевдоним для любого командлета
Set-Alias -Name gh -Value Get-Help

#9.	Просмотреть список методов и свойств объекта типа процесс
Get-Process | Get-Member -MemberType Property,Method

#10.	Просмотреть список методов и свойств объекта типа строка
"string" | Get-Member -MemberType Property,Method

#11.	Получить список запущенных процессов, данные об определённом процессе
Get-Process

Get-Process viber
Get-Process | Where-Object {$_.name -eq "viber"}

#12.	Получить список всех сервисов, данные об определённом сервисе
Get-Service
Get-Service Appinfo

#13.	Получить список обновлений системы
Get-Hotfix

#14.	Узнайте, какой язык установлен для UI Windows
 Get-WinUILanguageOverride

#15.	Получите текущее время и дату
Get-Date

#16.	Сгенерируйте случайное число (любым способом)
Get-Random

# 17.	Выведите дату и время, когда был запущен процесс «explorer». Получите какой это день недели
(Get-Process explorer).StartTime
(Get-Process explorer).StartTime | Get-Date -UFormat %A

# 18.	Откройте любой документ в MS Word (не важно как) и закройте его с помощью PowerShell
(Get-Process winword).CloseMainWindow()

#19.	Подсчитать значение выражения S= . N – изменяемый параметр. Каждый шаг выводить в виде строки. (Пример: На шаге 2 сумма S равна 9)
$S=0; for ($i=1; $i -le 10; $i++) {$S=$S+3*$i; Write-Host "на шаге $i сумма равна $S"}

#20.	Напишите функцию для предыдущего задания. Запустите её на выполнение.

function MySumm ($n){
$S=0
for ($i=1; $i -le $n; $i++) {
    $S=$S+3*$i; 
    Write-Host "на шаге $i сумма равна $S"
    }
}
MySumm 7






