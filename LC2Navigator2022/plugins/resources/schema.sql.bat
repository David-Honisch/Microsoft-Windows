@echo off
set out=%1
set in=%2
echo %out%
type nul > %out%
REM pause
echo select '^<h4^>%in% Plugin SQL Import^</h4^>'; >> %out%
echo drop table IF EXISTS %in%;>> %out%
echo drop table IF EXISTS %in%temp;>> %out%
echo CREATE TABLE %in% ( 'person_id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 'name' TEXT NOT NULL, 'first_name' TEXT NULL, 'description' TEXT NULL, 'zipcode' TEXT NULL, 'city' TEXT NULL,	 'street' TEXT NULL,	 'url' TEXT NULL);>> %out%
echo create table IF NOT EXISTS %in%temp ( name varchar(255), menu TEXT, url varchar(255), subtext TEXT);>> %out%
echo .separator ';'>> %out%
echo .import .\\resources\\plugins\\%in%\\import\\import.csv %in%temp>> %out%
echo INSERT INTO %in% (first_name,name, description,url) select name,name, menu,url  from %in%temp;>> %out%
echo select '^<p^>%in% count:';>> %out%
echo select count(*) from %in%;>> %out%
echo select '^</p^>';>> %out%
echo .exit>> %out%
REM pause