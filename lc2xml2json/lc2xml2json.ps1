param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]$InputPath,

    [Parameter(Mandatory=$true, Position=1)]
    [string]$OutputPath
)

# 1. XML-Datei einlesen und als XML-Objekt casten
[xml]$xmlContent = Get-Content -Path $InputPath -Raw

# 2. In JSON konvertieren und speichern
# -Depth 10 stellt sicher, dass tief verschachtelte XML-Strukturen nicht abgeschnitten werden
$xmlContent | ConvertTo-Json -Depth 10 | Out-File -FilePath $OutputPath