drop table IF EXISTS general;
drop table IF EXISTS audio;
drop table IF EXISTS video;
drop table IF EXISTS localtools;
drop table IF EXISTS windows;
drop table IF EXISTS linux;
drop table IF EXISTS localgames;
drop table IF EXISTS macros;
drop table IF EXISTS profile;
create table IF NOT EXISTS general (
 name varchar(255)
);
create table IF NOT EXISTS localtools (
 name varchar(255)
);
create table IF NOT EXISTS audio (
 name varchar(255)
);
create table IF NOT EXISTS video (
 name varchar(255)
);
create table IF NOT EXISTS localgames (
 name varchar(255)
);
create table IF NOT EXISTS windows (
 name varchar(255)
);
create table IF NOT EXISTS linux (
 name varchar(255)
);
create table IF NOT EXISTS macros (
 name varchar(255)
);
create table IF NOT EXISTS profile (
 name varchar(255)
);
.separator "\t"
.import .\\general.csv general
.separator "\t"
.import .\\localtools.csv localtools
.separator "\t"
.import .\\audio.csv audio
.separator "\t"
.import .\\video.csv video
.separator "\t"
.import .\\localgames.csv localgames
.separator "\t"
.import .\\windows.csv windows
.separator "\t"
.import .\\linux.csv linux
.separator "\t"
.import .\\macros.csv macros
.separator "\t"
.import .\\profile.csv profile
--.import ..\\import\\materialnohead.csv url
--INSERT INTO person VALUES (4, 'Alice', '351246233');
--DELETE FROM general where url.name = '';
.exit