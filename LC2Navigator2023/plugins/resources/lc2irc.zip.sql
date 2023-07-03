SELECT '<h1>LC2IRC PLUGIN SQL SCRIPT IS RUNNING</h1>';
SELECT '<h5>Deleting import script</h5>';
--DELETE FROM importscripts;
SELECT '<h5>RUNNING IMPORT</h5>';
SELECT '<h4>SET CLEAR</h4>';
SELECT '<h4>DELETING application</h4>';
--INSERT OR REPLACE INTO importscripts (first_name,name,url) 
--values 
--('Grab Urls v.1.0','Grab Urls v.1.0','.\\resources\\plugins\\atari.bat atariemulator.zip');
--.separator "\t"
--.import .\\plugins.csv importscripts
--SELECT first_name, COUNT(*) c FROM importscripts GROUP BY first_name HAVING c > 1;
SELECT '<h1>UPDATE SQL SCRIPT DONE</h1>';
INSERT INTO application VALUES(25,'LC2IRC v.1.01a','LC2IRC v.1.01a','','','','','exec .\\resources\\plugins\\lc2irc\\lc2irc.bat .\\resources\\plugins\\lc2irc\\menu.csv');

SELECT '<h5>SQL IMPORT DONE</h5>';
