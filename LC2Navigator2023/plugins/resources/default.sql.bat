@echo off
set out=%1
set in=%2
echo %out%
type nul > %out%
echo SELECT '^<h1^>%in% PLUGIN SQL SCRIPT IS RUNNING^</h1^>'; >> %out%
REM echo SELECT '^<h5^>Deleting import script^</h5^>'; >> %out%
REM echo --DELETE FROM importscripts; >> %out%
echo SELECT '^<h5^>RUNNING IMPORT^</h5^>'; >> %out%
echo SELECT '^<h4^>COUNT BEFORE^</h4^>'; >> %out%
echo select count(*) as count from application; >> %out%
echo SELECT '^<h4^>DELETING application^</h4^>'; >> %out%
REM echo --SELECT first_name, COUNT(*) c FROM application GROUP BY first_name HAVING c ^> 1; >> %out%
echo SELECT '^<h1^>UPDATE %in% SQL SCRIPT DONE^</h1^>'; >> %out%
REM echo INSERT OR REPLACE INTO application(name, first_name, description, zipcode, city, street, url)VALUES('%in% Plugin v.1.02a','%in% Plugin v.1.01a','','','','','execCMD(''exec .\\resources\\plugins\\%in%\\index.bat .\\resources\\plugins\\%in%\\menu.csv'', ''out'');');  >> %out%
echo INSERT OR REPLACE INTO application(name, first_name, description, zipcode, city, street, url)VALUES('%in% Plugin v.1.2','%in% Plugin v.1.01a','','','','','execPluginCMD(''out'',''%in%'');'); >> %out%
echo SELECT '^<h4^>COUNT AFTER DATA IMPORT^</h4^>'; >> %out%
echo select count(*) as count from application; >> %out%
echo SELECT '^<h5^>SQL %in% IMPORT DONE^</h5^>'; >> %out%
