@echo off
set out=%1
set in=%2
echo %out%
type nul > %out%
echo SELECT '^<h1^>%in% PLUGIN SQL SCRIPT IS RUNNING^</h1^>'; >> %out%
echo SELECT '^<h5^>Deleting import script^</h5^>'; >> %out%
REM echo --DELETE FROM importscripts; >> %out%
echo SELECT '^<h5^>RUNNING IMPORT^</h5^>'; >> %out%
echo SELECT '^<h4^>SET CLEAR^</h4^>'; >> %out%
echo SELECT '^<h4^>DELETING application^</h4^>'; >> %out%
REM echo --SELECT first_name, COUNT(*) c FROM application GROUP BY first_name HAVING c ^> 1; >> %out%
echo SELECT '^<h1^>UPDATE %in% SQL SCRIPT DONE^</h1^>'; >> %out%
echo INSERT INTO application VALUES(25,'%in% v.1.01a','%in% v.1.01a','','','','','exec .\\resources\\plugins\\%in%\\%in%.bat .\\resources\\plugins\\%in%\\menu.csv'); >> %out%
echo SELECT '^<h5^>SQL %in% IMPORT DONE^</h5^>'; >> %out%
