SELECT '<h4>INSERT INTO importscripts</h4>';
INSERT OR REPLACE INTO importscripts (first_name,name,url) 
values 
('.\resources\cmd\updates.bat','.\resources\cmd\updates.bat','.\\resources\\cmd\\updates.bat');
SELECT '<h4>DELETING</h4>';
INSERT OR REPLACE INTO application (first_name,name,url) 
values 
('backupprofile.bat','backupprofile.bat','backupprofile.bat');
INSERT OR REPLACE INTO application (first_name,name,url) 
values 
('.\resources\cmd\updates.bat','.\resources\cmd\updates.bat','.\\resources\\cmd\\updates.bat');
INSERT OR REPLACE INTO application (first_name,name,url) 
values 
('.\resources\cmd\updates.bat','.\resources\cmd\updates.bat','.\\resources\\cmd\\updates.bat');

--.separator "\t"
--.import .\\plugins.csv importscripts
--SELECT first_name, COUNT(*) c FROM importscripts GROUP BY first_name HAVING c > 1;

