SELECT '<h1>lc2process PLUGIN SQL SCRIPT IS RUNNING</h1>';
SELECT '<p>Deleting import script</p>';
--DELETE FROM importscripts;
SELECT '<h5>RUNNING IMPORT</h5>';
SELECT '<p>SET CLEAR</p>';
SELECT '<h4>DELETING application</h4>';
SELECT '<h4>DELETING application</h4>';

SELECT '<h1>UPDATE SQL SCRIPT DONE</h1>';

INSERT OR REPLACE INTO application (first_name,name,url) 
values 
('lc2process Plugin Menu v.0.1a','lc2process Plugin Menu v.0.1a','.\\resources\\plugins\\lc2process\\main.bat .\\resources\\plugins\\lc2process\\menu.csv');


SELECT '<p>Applications imported'||count(*)||'</p>' from application;

SELECT '<h5>SQL IMPORT DONE</h5>';
