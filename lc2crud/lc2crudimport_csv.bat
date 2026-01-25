@echo off
SETLOCAL
call %~dp0..\..\resources\cmd\config.bat h5 UPDATECONFIG
@echo off
REM set SQLFILE=%1
set "BR=%LT%hr%RT%"
set LINE==================================
REM set SQLFILE=%1
set IMPORTFILE=import.csv
set table=application
set btable=application_bin
set "resdir=%cd%\resources\"
set "dbfile2=%cd%\db.db"
REM set "RPATH=https://raw.githubusercontent.com/David-Honisch/Microsoft-Windows/master/LC2Navigator2023/"
SET DB_PATH=lc.db
REM SET NEW_STATUS='active'
SET NEW_FILENAME='media.csv'
SET TABLE_ID=application
echo %LT%h1%RT%Import files to %table%%LT%/h1%RT%
echo %LT%p%RT%Importing %IMPORTFILE% to %table% inside %dbfile%%LT%p%RT%
REM Pass parameters to sqlite3 using the .param set command before .read
%sexec% "%DB_PATH%" ".param set :file_name %NEW_FILENAME%" ".param set :tableid %TABLE_ID%" ".read import_application.sql"
REM echo %LT%hr%RT%
REM echo %LT%hr%RT%
REM echo READING CSV %table% to %dbfile%
REM echo %LT%hr%RT%
REM call %sexec% %dbfile% -csv "INSERT INTO systables(name,first_name, description,url)VALUES('%table% Data','%table%','%table%','execCMD(\\'.\\\\resources\\\\cmd\\\\showdb.bat %table%\\', \\'out\\')');"
REM call %sexec% %dbfile% -csv "INSERT INTO systables(name,first_name, description,url)VALUES('%table% Data','%table%','%table%','execCMD(''.\\resources\\cmd\\showdb.bat %table%'', ''out'')');"
REM echo call %sexec% %dbfile% -csv "INSERT INTO systables(name,first_name, description,url)VALUES('%table%','%table%','%table%','execCMD(''.\\resources\\cmd\\showdb.bat %table%'', ''out'')');"
REM call %sexec% %dbfile% -csv "INSERT INTO systables(name,first_name, description,url)VALUES('%table%','%table%','%table%','execCMD(''.\\resources\\cmd\\showdb.bat %table%'', ''out'')');"
REM echo Creating table %table%
REM call %sexec% %dbfile% -csv "CREATE TABLE %table% ( "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "name" TEXT NOT NULL, "first_name" TEXT NULL, "description" TEXT NULL, "zipcode" TEXT NULL, "city" TEXT NULL,	 "street" TEXT NULL,	 "url" TEXT NULL);"
REM echo importing..
REM call %sexec% %dbfile% -csv "INSERT INTO %table%(name,first_name, description,url)VALUES('%table%','%table%','%table%','execCMD(''.\\resources\\cmd\\showdb.bat %table%'', ''out'')');"
REM call %sexec% %dbfile% -csv "INSERT INTO %table%(name,first_name, description,url)VALUES('%table% List','%table%','%table%','showDB(''%table%'')');"
REM real table
REM call %sexec% %dbfile2% -csv "CREATE TABLE %table% ( "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "name" TEXT NOT NULL, "first_name" TEXT NULL,"last_name" TEXT NULL, "description" TEXT NULL, "zipcode" TEXT NULL, "city" TEXT NULL, "street" TEXT NULL, "url" TEXT NULL);"
REM call %sexec% %dbfile2% -csv "CREATE TABLE %btable% ( "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "name" TEXT NOT NULL, "first_name" TEXT NULL,"last_name" TEXT NULL, "description" TEXT NULL, "zipcode" TEXT NULL, "city" TEXT NULL, "street" TEXT NULL, "url" TEXT NULL, "content" BLOB NULL);"
REM echo %LT%p%RT%Importing %IMPORTFILE% to %table% inside %dbfile2%%LT%p%RT%
for /f "usebackq tokens=1-20 delims=," %%a in ("%IMPORTFILE%") do (
	  echo %sexec% %dbfile2% -csv "INSERT INTO %table%(name, cmd,url) VALUES(REPLACE('%%~na','\','\\'),'execCMD(''\""'||REPLACE('%%a','\','\\')||'\""'',''out'')',REPLACE('%%a','\','\\'));"
	  REM %sexec% %dbfile2% -csv "INSERT INTO %table%(name, cmd,url) VALUES(REPLACE('%%~na','\','\\'),'execCMD(''\""'||REPLACE('%%a','\','\\')||'\""'',''out'')',REPLACE('%%a','\','\\'));"
	  %sexec% %dbfile2% -csv "INSERT INTO %table%(name, cmd,url) VALUES(REPLACE('%%~na','\','\\'),REPLACE('%%a','\','\\'),REPLACE('%%a','\','\\'));"
	  REM %sexec% %dbfile2% -csv "INSERT INTO %table%(first_name,last_name,name,city, description,url) VALUES(REPLACE('%%~pa','\','\\'),REPLACE('%%~xa','\','\\'),REPLACE('%%a','\','\\'),REPLACE('%%~za','\','\\'),REPLACE('%%a','\','\\'),'getFileLink('''||REPLACE(REPLACE(REPLACE('%%a','%%~xa',''),'%%~na',''),'\','\\')||''','''||REPLACE('%%~na%%~xa','\','\\')||''',''out'')');"	  
	  REM %sexec% %dbfile2% -csv "INSERT INTO %table%(first_name,last_name,name,city, description,url) VALUES(REPLACE('%%~pa','\','\\'),REPLACE('%%~xa','\','\\'),REPLACE('%%a','\','\\'),REPLACE('%%~za','\','\\'),REPLACE('%%a','\','\\'),'getSQLQueryFileContent(''out'',''%table%'',''false'',''true'')');"
	  REM btable
	  REM %sexec% %dbfile2% -csv "INSERT INTO %btable%(first_name,last_name,name,city, description,url,content) VALUES(REPLACE('%%~pa','\','\\'),REPLACE('%%~xa','\','\\'),REPLACE('%%a','\','\\'),REPLACE('%%~za','\','\\'),REPLACE('%%a','\','\\'),'getExecSQLQuery(''select content from %%~na limit 1'',''out'')',readfile('%%a'));"	 
	  REM @echo off
)
echo %LT%hr%RT%
echo Importing files done
echo %LT%hr%RT%
call %sexec% %dbfile2% -csv "select '%table% COUNT:'|| count(*) from %table%;"
REM call %sexec% %dbfile2% -csv "select '%btable% COUNT:'|| count(*) from %btable%;"
echo %LT%hr%RT%
echo list.html?db=%dbfile2%&table=%table%
echo %LT%a href="list.html?db=%dbfile2%&table=%table%" target="_parent"%RT%go to %table%%LT%/a%RT%
echo %LT%hr%RT%
REM type %resdir%\html\clearbutton.html