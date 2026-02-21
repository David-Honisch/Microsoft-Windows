@echo off
call lc2json2xml2json -i .\data.json -x .\tojson.xslt --output output.json
echo type output.json
type output.json