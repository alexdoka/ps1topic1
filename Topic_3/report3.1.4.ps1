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
