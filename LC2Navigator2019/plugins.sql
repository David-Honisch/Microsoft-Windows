SELECT '<h4>DELETING</h4>';
--delete from importscripts where person_id > 2;
--delete from application where person_id > 2;
--commit;
SELECT '<h4>ALTER TABLE</h4>';
--ALTER IGNORE TABLE importscripts ADD UNIQUE INDEX (first_name, name, url);
--ALTER IGNORE TABLE application ADD UNIQUE INDEX (first_name, name, url);
SELECT '<h4>DELETING DUPLICATES from TABLE</h4>';
DELETE FROM importscripts 
where rowid not in (select min(rowid)
                    from importscripts
                    group by first_name,name,url);
SELECT '<h4>DELETING DUPLICATES DONE</h4>';
SELECT '<h4>DELETING DUPLICATES from application TABLE</h4>';
DELETE FROM application 
where rowid not in (select min(rowid)
                    from application
                    group by first_name,first_name,url);
SELECT '<h4>INSERT INTO importscripts</h4>';
INSERT OR REPLACE INTO importscripts (first_name,name,url) 
values 
('.\\resources\\cmd\\updates.bat','.\\resources\\cmd\\updates.bat','.\\resources\\cmd\\updates.bat');
SELECT '<h4>INSERT INTO importscripts</h4>';
INSERT OR REPLACE INTO importscripts (first_name,name,url) 
values 
('.\\resources\\cmd\\updates.bat','.\\resources\\cmd\\updates.bat','.\\resources\\cmd\\updates.bat');
--.separator "\t"
--.import .\\plugins.csv importscripts
SELECT first_name, COUNT(*) c FROM importscripts GROUP BY first_name HAVING c > 1;

