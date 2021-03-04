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
SELECT '<h3>Importing Checksqlite3 Plugin SCRIPT</h3>'; 
"INSERT OR REPLACE INTO plugins (first_name,name,url) values ('Checksqlite3 Download','Checksqlite3 Download','exec .\\resources\\cmd\\getupdates.bat /plugins/Checksqlite3 Checksqlite3');" 
SELECT '<h3>Importing Checksqlite3 Plugin SCRIPT DONE</h3>'; 	
SELECT '<h3>Importing core.zip core.zip Plugin SCRIPT</h3>'; 
"INSERT OR REPLACE INTO plugins (first_name,name,url) values ('core.zip core.zip Download','core.zip core.zip Download','exec .\\resources\\cmd\\getupdates.bat /plugins/core.zip core.zip core.zip core.zip');" 
SELECT '<h3>Importing core.zip core.zip Plugin SCRIPT DONE</h3>'; 	
SELECT '<h3>Importing all.zip all.zip Plugin SCRIPT</h3>'; 
"INSERT OR REPLACE INTO plugins (first_name,name,url) values ('all.zip all.zip Download','all.zip all.zip Download','exec .\\resources\\cmd\\getupdates.bat /plugins/all.zip all.zip all.zip all.zip');" 
SELECT '<h3>Importing all.zip all.zip Plugin SCRIPT DONE</h3>'; 	
SELECT '<h3>Importing lc2php.zip Plugin SCRIPT</h3>'; 
"INSERT OR REPLACE INTO plugins (first_name,name,url) values ('lc2php.zip Download','lc2php.zip Download','exec .\\resources\\cmd\\getupdates.bat /plugins/lc2php.zip lc2php.zip');" 
SELECT '<h3>Importing lc2php.zip Plugin SCRIPT DONE</h3>'; 	
SELECT '<h3>Importing excelimport.zip Plugin SCRIPT</h3>'; 
"INSERT OR REPLACE INTO plugins (first_name,name,url) values ('excelimport.zip Download','excelimport.zip Download','exec .\\resources\\cmd\\getupdates.bat /plugins/excelimport.zip excelimport.zip');" 
SELECT '<h3>Importing excelimport.zip Plugin SCRIPT DONE</h3>'; 	
SELECT '<h3>Importing python.zip Plugin SCRIPT</h3>'; 
"INSERT OR REPLACE INTO plugins (first_name,name,url) values ('python.zip Download','python.zip Download','exec .\\resources\\cmd\\getupdates.bat /plugins/python.zip python.zip');" 
SELECT '<h3>Importing python.zip Plugin SCRIPT DONE</h3>'; 	
SELECT '<h3>Importing mysqldocker.zip Plugin SCRIPT</h3>'; 
"INSERT OR REPLACE INTO plugins (first_name,name,url) values ('mysqldocker.zip Download','mysqldocker.zip Download','exec .\\resources\\cmd\\getupdates.bat /plugins/mysqldocker.zip mysqldocker.zip');" 
SELECT '<h3>Importing mysqldocker.zip Plugin SCRIPT DONE</h3>'; 	
SELECT '<h3>Importing apache-maven.zip Plugin SCRIPT</h3>'; 
"INSERT OR REPLACE INTO plugins (first_name,name,url) values ('apache-maven.zip Download','apache-maven.zip Download','exec .\\resources\\cmd\\getupdates.bat /plugins/apache-maven.zip apache-maven.zip');" 
SELECT '<h3>Importing apache-maven.zip Plugin SCRIPT DONE</h3>'; 	
SELECT '<h3>Importing lc2irc.zip Plugin SCRIPT</h3>'; 
"INSERT OR REPLACE INTO plugins (first_name,name,url) values ('lc2irc.zip Download','lc2irc.zip Download','exec .\\resources\\cmd\\getupdates.bat /plugins/lc2irc.zip lc2irc.zip');" 
SELECT '<h3>Importing lc2irc.zip Plugin SCRIPT DONE</h3>'; 	
SELECT '<h3>Importing graburls.zip Plugin SCRIPT</h3>'; 
"INSERT OR REPLACE INTO plugins (first_name,name,url) values ('graburls.zip Download','graburls.zip Download','exec .\\resources\\cmd\\getupdates.bat /plugins/graburls.zip graburls.zip');" 
SELECT '<h3>Importing graburls.zip Plugin SCRIPT DONE</h3>'; 

-- SELECT '<h1>UPDATE SQL SCRIPT DONE</h1>';

-- SELECT '<h3>ALLPLUGINS Plugin SCRIPT DONE</h3>';
-- INSERT OR REPLACE INTO plugins (first_name,name,url) 
-- values 
-- ('LC2PHP Downloader v.1.02','LC2PHP Downloader v.1.02','exec .\\resources\\cmd\\getupdates.bat /plugins/lc2php.zip lc2php.zip');

-- SELECT '<h3>Excel Plugin SCRIPT DONE</h3>';
-- INSERT OR REPLACE INTO plugins (first_name,name,url) 
-- values 
-- ('Excel Transformer Downloader v.1.02','Excel Transformer Downloader v.1.02','exec .\\resources\\cmd\\getupdates.bat /plugins/excelimport.zip excelimport.zip');
-- SELECT '<h3>Python Plugin SCRIPT DONE</h3>';
-- INSERT OR REPLACE INTO plugins (first_name,name,url) 
-- values 
-- ('Python Downloader v.1.02 (not working up to now!)','Python Downloader v.1.02 (not working up to now!)','exec .\\resources\\cmd\\getupdates.bat /plugins/python.zip python.zip');
-- SELECT '<h3>MySQL Plugin SCRIPT DONE</h3>';
-- INSERT OR REPLACE INTO plugins (first_name,name,url) 
-- values 
-- ('MySQLdocker v.1.01a','MySQLdocker Downloader v.1.01a','exec .\\resources\\cmd\\getupdates.bat /plugins/mysqldocker.zip mysqldocker.zip');

-- INSERT OR REPLACE INTO plugins (first_name,name,url) 
-- values 
-- ('Maven v.3.5.2 Downloader v.1.01','Maven v.3.5.2 Downloader v.1.01','exec .\\resources\\cmd\\getupdates.bat /plugins/apache-maven.zip apache-maven.zip');

-- INSERT OR REPLACE INTO plugins (first_name,name,url) 
-- values 
-- ('LC2IRC Downloader v.0.01','LC2IRC Downloader v.0.01','exec .\\resources\\cmd\\getupdates.bat /plugins/lc2irc.zip lc2irc.zip');

-- INSERT OR REPLACE INTO plugins (first_name,name,url) 
-- values 
-- ('LC2GrabUrls Downloader v.0.01','LC2GrabUrls Downloader v.0.01','exec .\\resources\\cmd\\getupdates.bat /plugins/graburls.zip graburls.zip');

SELECT '<p>All Plugin Downloaders imported'||count(*)||'</p>' from application;

SELECT '<h5>SQL IMPORT DONE</h5>';
