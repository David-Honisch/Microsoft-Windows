param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]$InputPath,

    [Parameter(Mandatory=$true, Position=1)]
    [string]$OutputPath
)

# Konvertierungslogik
Get-Content -Path $InputPath -Raw | 
    ConvertFrom-Json | 
    ConvertTo-Xml -As Stream -Depth 3 | 
    Out-File -FilePath $OutputPath