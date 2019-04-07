CREATE TABLE "app" (
	 "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "name" TEXT(255,0) NOT NULL,
	 "first_name" TEXT(255,0) NULL,	 
	 "description" TEXT(255,0) NULL,
	 "zipcode" TEXT(255,0) NULL,
	 "city" TEXT(255,0) NULL,
	 "street" TEXT(255,0) NULL,
	 "url" TEXT(255,0) NULL
);
CREATE TABLE "batch" (
	 "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "name" TEXT(255,0) NOT NULL,
	 "first_name" TEXT(255,0) NULL,	 
	 "description" TEXT(255,0) NULL,
	 "zipcode" TEXT(255,0) NULL,
	 "city" TEXT(255,0) NULL,
	 "street" TEXT(255,0) NULL,
	 "url" TEXT(255,0) NULL
);
CREATE TABLE "games" (
	 "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "name" TEXT(255,0) NOT NULL,
	 "first_name" TEXT(255,0) NULL,	 
	 "description" TEXT(255,0) NULL,
	 "zipcode" TEXT(255,0) NULL,
	 "city" TEXT(255,0) NULL,
	 "street" TEXT(255,0) NULL,
	 "url" TEXT(255,0) NULL
);
CREATE TABLE "movies" (
	 "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "name" TEXT(255,0) NOT NULL,
	 "first_name" TEXT(255,0) NULL,	 
	 "description" TEXT(255,0) NULL,
	 "zipcode" TEXT(255,0) NULL,
	 "city" TEXT(255,0) NULL,
	 "street" TEXT(255,0) NULL,
	 "url" TEXT(255,0) NULL
);
CREATE TABLE "music" (
	 "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "name" TEXT(255,0) NOT NULL,
	 "first_name" TEXT(255,0) NULL,	 
	 "description" TEXT(255,0) NULL,
	 "zipcode" TEXT(255,0) NULL,
	 "city" TEXT(255,0) NULL,
	 "street" TEXT(255,0) NULL,
	 "url" TEXT(255,0) NULL
);
CREATE TABLE "exe" (
	 "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "name" TEXT(255,0) NOT NULL,
	 "first_name" TEXT(255,0) NULL,	 
	 "description" TEXT(255,0) NULL,
	 "zipcode" TEXT(255,0) NULL,
	 "city" TEXT(255,0) NULL,
	 "street" TEXT(255,0) NULL,
	 "url" TEXT(255,0) NULL
);
CREATE TABLE "radio" (
	 "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "name" TEXT(255,0) NOT NULL,
	 "first_name" TEXT(255,0) NULL,	 
	 "description" TEXT(255,0) NULL,
	 "zipcode" TEXT(255,0) NULL,
	 "city" TEXT(255,0) NULL,
	 "street" TEXT(255,0) NULL,
	 "url" TEXT(255,0) NULL
);
CREATE TABLE "tv" (
	 "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "name" TEXT(255,0) NOT NULL,
	 "first_name" TEXT(255,0) NULL,	 
	 "description" TEXT(255,0) NULL,
	 "zipcode" TEXT(255,0) NULL,
	 "city" TEXT(255,0) NULL,
	 "street" TEXT(255,0) NULL,
	 "url" TEXT(255,0) NULL
);
CREATE TABLE "tools" (
	 "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "name" TEXT(255,0) NOT NULL,
	 "first_name" TEXT(255,0) NULL,	 
	 "description" TEXT(255,0) NULL,
	 "zipcode" TEXT(255,0) NULL,
	 "city" TEXT(255,0) NULL,
	 "street" TEXT(255,0) NULL,
	 "url" TEXT(255,0) NULL
);
CREATE TABLE "ebooks" (
	 "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "name" TEXT(255,0) NOT NULL,
	 "first_name" TEXT(255,0) NULL,	 
	 "description" TEXT(255,0) NULL,
	 "zipcode" TEXT(255,0) NULL,
	 "city" TEXT(255,0) NULL,
	 "street" TEXT(255,0) NULL,
	 "url" TEXT(255,0) NULL
);
CREATE TABLE "other" (
	 "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "name" TEXT(255,0) NOT NULL,
	 "first_name" TEXT(255,0) NULL,	 
	 "description" TEXT(255,0) NULL,
	 "zipcode" TEXT(255,0) NULL,
	 "city" TEXT(255,0) NULL,
	 "street" TEXT(255,0) NULL,
	 "url" TEXT(255,0) NULL
);
CREATE TABLE "people" (
	 "person_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "name" TEXT(255,0) NOT NULL,
	 "first_name" TEXT(255,0) NULL,	 
	 "description" TEXT(255,0) NULL,
	 "zipcode" TEXT(255,0) NULL,
	 "city" TEXT(255,0) NULL,
	 "street" TEXT(255,0) NULL,
	 "url" TEXT(255,0) NULL
);
CREATE INDEX "first_name_index" ON people ("first_name" COLLATE NOCASE ASC);
CREATE INDEX "name_index" ON people ("name" COLLATE NOCASE ASC);
INSERT INTO `people` 
VALUES 
(NULL, "LCAdressbookSQLite.exe", "","","","","","LCAdressbookSQLite.exe"),
(NULL, "LCAdressbookSQLite.exe.bat", "","","","","","LCAdressbookSQLite.exe.bat")
;
INSERT INTO `app` 
VALUES 
(NULL, "explorer.exe", "explorer.exe","explorer.exe","","","","explorer.exe");
INSERT INTO `tools` 
VALUES 
(NULL, "explorer.exe", "explorer.exe","explorer.exe","","","","explorer.exe");
INSERT INTO `games` 
VALUES 
(NULL, "calc.exe", "calc.exe","calc.exe","","","","calc.exe");
INSERT INTO `ebooks` 
VALUES 
(NULL, "Stephen King", "Firechild","Firechild","","","","Firechild");
