param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]$XmlPath,

    [Parameter(Mandatory=$true, Position=1)]
    [string]$XsltPath,

    [Parameter(Mandatory=$true, Position=2)]
    [string]$OutputPath
)

# Volle Pfade auflösen (wichtig für .NET-Methoden)
$XmlPath = Resolve-Path $XmlPath
$XsltPath = Resolve-Path $XsltPath
$OutputPath = New-Item -Path $OutputPath -Force | Select-Object -ExpandProperty FullName

# XSLT-Objekt erstellen und Stylesheet laden
$xslt = New-Object System.Xml.Xsl.XslCompiledTransform
$xslt.Load($XsltPath)

# Transformation durchführen
# Die Transform-Methode kann direkt Pfade als Strings verarbeiten
$xslt.Transform($XmlPath, $OutputPath)

Write-Host "Transformation abgeschlossen: $OutputPath" -ForegroundColor Green