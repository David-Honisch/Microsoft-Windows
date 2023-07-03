select '<h1>PROCESSIMPORT</h1>';
drop table IF EXISTS processtemplist;
create table IF NOT EXISTS processtemplist (
 name varchar(255),
 pid DECIMAL(10,5),
 type varchar(255),
 tpid DECIMAL(10,5),
 mem DECIMAL(10,5),
 ktype varchar(255)
);
.separator "\t"
.import .\\processlist.csv processtemplist
--.import ..\\import\\materialnohead.csv url
--INSERT INTO person VALUES (4, 'Alice', '351246233');
-- DELETE FROM url where url.name = '';
select * from processtemplist limit 10;
INSERT INTO procs (first_name,name) select name,name from processtemplist;
select 'COUNT:'+count(*) from procs;
.exit