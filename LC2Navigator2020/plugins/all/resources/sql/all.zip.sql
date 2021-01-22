SELECT '<h1>CORE PLUGIN SQL SCRIPT IS RUNNING</h1>';
SELECT '<p>Deleting import script</p>';
--DELETE FROM importscripts;
SELECT '<h5>RUNNING IMPORT</h5>';
SELECT '<p>SET CLEAR</p>';
SELECT '<h4>DELETING application</h4>';
--SELECT '<h4>DELETING application</h4>';
--INSERT OR REPLACE INTO importscripts (first_name,name,url) 
--values 
--('Grab Urls v.1.0','Grab Urls v.1.0','.\\resources\\plugins\\atari.bat atariemulator.zip');
--.separator "\t"
--.import .\\plugins.csv importscripts
--SELECT first_name, COUNT(*) c FROM importscripts GROUP BY first_name HAVING c > 1;

SELECT '<h1>UPDATE SQL SCRIPT DONE</h1>';

SELECT '<h3>LC2PHP Plugin SCRIPT DONE</h3>';
INSERT OR REPLACE INTO plugins (first_name,name,url) 
values 
('LC2PHP Downloader v.1.02','LC2PHP Downloader v.1.02','exec .\\resources\\cmd\\getupdates.bat /plugins/lc2php.zip lc2php.zip');

SELECT '<h3>Excel Plugin SCRIPT DONE</h3>';
INSERT OR REPLACE INTO plugins (first_name,name,url) 
values 
('Excel Transformer Downloader v.1.02','Excel Transformer Downloader v.1.02','exec .\\resources\\cmd\\getupdates.bat /plugins/excelimport.zip excelimport.zip');
SELECT '<h3>Python Plugin SCRIPT DONE</h3>';
INSERT OR REPLACE INTO plugins (first_name,name,url) 
values 
('Python Downloader v.1.02 (not working up to now!)','Python Downloader v.1.02 (not working up to now!)','exec .\\resources\\cmd\\getupdates.bat /plugins/python.zip python.zip');
SELECT '<h3>MySQL Plugin SCRIPT DONE</h3>';
INSERT OR REPLACE INTO plugins (first_name,name,url) 
values 
('MySQLdocker v.1.01a','MySQLdocker Downloader v.1.01a','exec .\\resources\\cmd\\getupdates.bat /plugins/mysqldocker.zip mysqldocker.zip');

--INSERT OR REPLACE INTO plugins (first_name,name,url) 
--values 
--('Excel Transformer v.1.01a(IN PROGRESS!!NOT WORKING!!)','AllPlugins Menu Downloader v.1.01a(IN PROGRESS!!NOT WORKING!!)','exec .\\resources\\cmd\\getupdates.bat /plugins/excelimport.zip excelimport.zip');

SELECT '<p>Applications imported'||count(*)||'</p>' from application;

SELECT '<h5>SQL IMPORT DONE</h5>';
