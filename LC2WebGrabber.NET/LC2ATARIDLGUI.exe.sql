drop table IF EXISTS url;
create table IF NOT EXISTS batch (
 name varchar(255)
);
create table IF NOT EXISTS roms (
 name varchar(255)
);
create table IF NOT EXISTS java (
 name varchar(255)
);
create table IF NOT EXISTS regfiles (
 name varchar(255)
);
create table IF NOT EXISTS allfiles (
 name varchar(255)
);
create table IF NOT EXISTS import (
  ActionSign varchar(255),
  ID varchar(255),
  name varchar(255),
  description varchar(255),
  gross varchar(255),
  ean varchar(255),
  size varchar(255),
  dist varchar(255),
  cat varchar(255),
  msgrp varchar(255),
  base varchar(255),
  name11 varchar(255),
  name12 varchar(255),
  name13 varchar(255),
  name14 varchar(255),
  makerno varchar(255),
  maker varchar(255),
  name17 varchar(255),
  price varchar(255),
  name19 varchar(255),
  name21 varchar(255),
  name22 varchar(255),
  name23 varchar(255),
  name24 varchar(255),
  name25 varchar(255),
  name26 varchar(255),
  name27 varchar(255),
  name28 varchar(255),
  name29 varchar(255),
  name30 varchar(255),
  name31 varchar(255),
  name32 varchar(255),
  name33 varchar(255),
  name34 varchar(255),
  name35 varchar(255),
  name36 varchar(255),
  name37 varchar(255),
  name38 varchar(255),
  name39 varchar(255),
  name40 varchar(255),
  name41 varchar(255),
  name42 varchar(255),
  name43 varchar(255),
  name44 varchar(255),
  name45 varchar(255)
);
.separator "\t"
.import .\\config\\menu.csv batch
.import .\\config\\roms.csv roms
--.import resources\\java.csv java
--.import resources\\reg.csv regFiles
--.import resources\\all.csv allFiles
---------------------------------------------------
--.headers on
--.separator ";"
--.import .\\import\\insert.csv import
--INSERT INTO person VALUES (0, 'x', 'xx');
DELETE FROM import where url.name = '';
.exit