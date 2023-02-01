select '<h4>allplugins Plugin SQL Import</h4>';
drop table IF EXISTS plugins;
drop table IF EXISTS allpluginstemp;
CREATE TABLE plugins ( "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "name" TEXT NOT NULL, "first_name" TEXT NULL, "description" TEXT NULL, "zipcode" TEXT NULL, "city" TEXT NULL,	 "street" TEXT NULL,	 "url" TEXT NULL);
create table IF NOT EXISTS allpluginstemp ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT, url TEXT);
-- select 'Create table allplugins Import';
select '<h4>Import initializing...</h4>';
.mode csv
--.separator "\t"
.separator ";"
.import .\\all.csv allpluginstemp
select '<h4>Import done.</h4>';
--.import ..\\import\\materialnohead.csv url
--INSERT INTO person VALUES (4, 'Alice', '351246233');
-- DELETE FROM url where url.name = '';
-- select '<p>allpluginstemp count:';
-- select count(*) from allpluginstemp;
-- select '</p>';
-- select '<p>SQL Import successfully done</p>';
-- select '<p>allplugins count:'+count(*)+'</p>' from allpluginstemp;
-- select * from allpluginstemp limit 1;
-- select '<p>temp table COUNT:'+count(*)+'</p>' from allpluginstemp;
INSERT INTO plugins (person_id,name,url) select id,name, url from allpluginstemp;
select '<p>plugins count:';
select 'allpluginstemp:'+count(*) from allpluginstemp;
select 'plugins:'+count(*) from plugins;
select '</p>';
-- select '<p>COUNT:'+count(*)+'</p>' from allplugins;
-- select '<p>SQL Menu:</p><br>';
-- select '';
-- select '<hr>';
-- select '<a href="'+url+'">'+name+'</a>' from allplugins;
-- select '<hr>';
-- select '<p>allplugins count:'+count(*)+' successfully imported.</p>' from allplugins;
.exit