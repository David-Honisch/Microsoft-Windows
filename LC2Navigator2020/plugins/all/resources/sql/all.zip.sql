SELECT '<h1>ALLPLUGINS PLUGIN SQL SCRIPT IS RUNNING</h1>';
SELECT '<p>Deleting import script</p>';
--DELETE FROM importscripts;
SELECT '<h5>RUNNING IMPORT</h5>';
SELECT '<p>SET CLEAR</p>';
SELECT '<h4>DELETING application</h4>';
--SELECT '<h4>DELETING application</h4>';
--.separator "\t"
--.import .\\plugins.csv importscripts
--SELECT first_name, COUNT(*) c FROM importscripts GROUP BY first_name HAVING c > 1;

SELECT '<h1>UPDATE SQL SCRIPT DONE</h1>';

SELECT '<h3>ALLPLUGINS Plugin SCRIPT DONE</h3>';
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

INSERT OR REPLACE INTO plugins (first_name,name,url) 
values 
('Maven v.3.5.2 Downloader v.1.01','Maven v.3.5.2 Downloader v.1.01','exec .\\resources\\cmd\\getupdates.bat /plugins/apache-maven.zip apache-maven.zip');


SELECT '<p>All Plugin Downloaders imported'||count(*)||'</p>' from application;

SELECT '<h5>SQL IMPORT DONE</h5>';
