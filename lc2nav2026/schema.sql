-- --select "console.log('IMPORT INITIAL SCHEMA v.1.3')";
-- -- DROP TABLE "users"
CREATE TABLE IF NOT EXISTS "application" (
	"id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	"created" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"modified" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"enddate" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"name" TEXT NOT NULL,
	"first_name" TEXT NULL,
	"last_name" TEXT NULL,
	"description" TEXT NULL,
	"zipcode" TEXT NULL,
	"city" TEXT NULL,
	"street" TEXT NULL,
	"url" TEXT NULL
);
CREATE TABLE IF NOT EXISTS "tools" (
	"id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	"created" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"modified" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"enddate" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"name" TEXT NOT NULL,
	"first_name" TEXT NULL,
	"last_name" TEXT NULL,
	"description" TEXT NULL,
	"zipcode" TEXT NULL,
	"city" TEXT NULL,
	"street" TEXT NULL,
	"url" TEXT NULL
);
INSERT INTO "application"("name","command","email") VALUES ('Default','exec.bat test.bat','test@letztechnance.org');
INSERT INTO "users"("name","command","email") VALUES ('Default','exec.bat test.bat','test@letztechnance.org');
INSERT INTO "users"("name","command","email") VALUES ('Test','exec.bat test.bat','test@letztechnance.org');
