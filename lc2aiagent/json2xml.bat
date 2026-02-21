@echo off
set "input=data.json"
set "output=data.xml"

powershell -Command ^
    "$json = Get-Content -Raw '%input%' | ConvertFrom-Json;" ^
    "$xml = [xml]('<?xml version=\"1.0\" encoding=\"UTF-8\"?><root></root>');" ^
    "function Add-Nodes($obj, $parent) {" ^
    "    foreach ($prop in $obj.PSObject.Properties) {" ^
    "        $node = $xml.CreateElement($prop.Name);" ^
    "        if ($prop.Value.PSObject.Properties) { Add-Nodes $prop.Value $node } " ^
    "        else { $node.InnerText = $prop.Value.ToString() }" ^
    "        $parent.AppendChild($node) | Out-Null" ^
    "    }" ^
    "}" ^
    "Add-Nodes $json $xml.DocumentElement;" ^
    "$xml.Save('%output%')"

echo Konvertierung abgeschlossen: %output%