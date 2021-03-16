SELECT '<h1>lc2process PLUGIN SQL SCRIPT IS RUNNING</h1>'; 
SELECT '<h5>Deleting import script</h5>'; 
SELECT '<h5>RUNNING IMPORT</h5>'; 
SELECT '<h4>SET CLEAR</h4>'; 
SELECT '<h4>DELETING application</h4>'; 
select count(*) as count from application;
SELECT '<h1>UPDATE lc2process SQL SCRIPT DONE</h1>'; 
INSERT OR REPLACE INTO application(person_id, name, first_name, description, zipcode, city, street, url)
VALUES(8,'lc2process v.1.01a','lc2process v.1.01a','','','','','exec .\\resources\\plugins\\lc2process\\lc2process.bat .\\resources\\plugins\\lc2process\\menu.csv'); 
select count(*) as count from application;
SELECT '<h5>SQL lc2process IMPORT DONE</h5>'; 
