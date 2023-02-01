select '<h4>LC2ShortCutCLI Plugin SQL Import</h4>';
drop table IF EXISTS LC2ShortCutCLI;
drop table IF EXISTS LC2ShortCutCLItemp;
CREATE TABLE LC2ShortCutCLI ( "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "name" TEXT NOT NULL, "first_name" TEXT NULL, "description" TEXT NULL, "zipcode" TEXT NULL, "city" TEXT NULL,	 "street" TEXT NULL,	 "url" TEXT NULL);
create table IF NOT EXISTS LC2ShortCutCLItemp ( name TEXT, url TEXT, type varchar(255), tpid DECIMAL(10,5), mem DECIMAL(10,5), ktype varchar(255));
-- select 'Create table LC2ShortCutCLI Import';
-- .separator "\t"
-- .import .\\import.csv LC2ShortCutCLItemp
--.separator "\t"
.separator ";"
.import .\\resources\\plugins\\LC2ShortCutCLI\\import.csv LC2ShortCutCLItemp
--.import ..\\import\\materialnohead.csv url
--INSERT INTO person VALUES (4, 'Alice', '351246233');
-- DELETE FROM url where url.name = '';
-- select '<p>LC2ShortCutCLItemp count:';
-- select count(*) from LC2ShortCutCLItemp;
-- select '</p>';
-- select '<p>SQL Import successfully done</p>';
-- select '<p>LC2ShortCutCLI count:'+count(*)+'</p>' from LC2ShortCutCLItemp;
-- select * from LC2ShortCutCLItemp limit 1;
-- select '<p>temp table COUNT:'+count(*)+'</p>' from LC2ShortCutCLItemp;
INSERT INTO LC2ShortCutCLI (first_name,name,url) select name,name, url from LC2ShortCutCLItemp;
select '<p>LC2ShortCutCLI count:';
select count(*) from LC2ShortCutCLI;
select '</p>';
-- select '<p>COUNT:'+count(*)+'</p>' from LC2ShortCutCLI;
-- select '<p>SQL Menu:</p><br>';
-- select '';
-- select '<hr>';
-- select '<a href="'+url+'">'+name+'</a>' from LC2ShortCutCLI;
-- select '<hr>';
-- select '<p>LC2ShortCutCLI count:'+count(*)+' successfully imported.</p>' from LC2ShortCutCLI;
.exit