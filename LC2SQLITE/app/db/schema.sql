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
(NULL, "DJango", "rockz","desc","12345","Cologne","Hauptstrasse","https://letztechance.org/"), 
(NULL, "Salma", "Hayek","desc","12345","Cologne","Hauptstrasse","https://letztechance.org/"), 
(NULL, "John", "Doe","desc","12345","Cologne","Hauptstrasse","https://letztechance.org/");
