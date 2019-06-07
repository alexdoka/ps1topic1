#1.3.	Вывести список из 10 процессов занимающих дольше всего процессор. Результат записывать в файл.
#1.3.1.	Организовать запуск скрипта каждые 10 минутparam(
[CmdletBinding()]
param(
[parameter(Mandatory=$true,HelpMessage="Input number for top CPU processes")]
[int]$NumberTopProcess
)

Get-Process | sort CPU -Descending | select name,CPU -first $NumberTopProcess | Out-File "f:\Dropbox\_epam\homework\2_powershell\Topic_3\top$NumberTopProcess.txt"