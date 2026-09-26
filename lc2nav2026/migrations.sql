-- =============================================================================
-- LC2Nav2026 – full schema (single source of truth)
-- All statements use IF NOT EXISTS so the file is safe to re-run.
-- =============================================================================

CREATE TABLE IF NOT EXISTS "jobs" (
    "id"             INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "title"          TEXT    NOT NULL,
    "company"        TEXT    NOT NULL DEFAULT '',
    "location"       TEXT    NOT NULL DEFAULT '',
    "job_type"       TEXT    NOT NULL DEFAULT 'Full-time',
    "category"       TEXT    NOT NULL DEFAULT 'General',
    "description"    TEXT    NOT NULL DEFAULT '',
    "requirements"   TEXT    NULL,
    "benefits"       TEXT    NULL,
    "salary"         TEXT    NULL,
    "posted_date"    TEXT    NOT NULL DEFAULT '',
    "deadline"       TEXT    NULL,
    "contact_email"  TEXT    NOT NULL DEFAULT '',
    "contact_phone"  TEXT    NULL,
    "website"        TEXT    NULL,
    "featured"       INTEGER NOT NULL DEFAULT 0,
    "external_id"    TEXT    NULL,
    "last_synced"    TEXT    NULL,
    "shell_command"  TEXT    NULL,
    "download_files" TEXT    NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS "idx_jobs_external_id" ON "jobs"("external_id");

CREATE TABLE IF NOT EXISTS "users" (
    "id"      INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
    "created" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "name"    TEXT     NOT NULL,
    "command" TEXT     NULL,
    "email"   TEXT     NULL
);

CREATE TABLE IF NOT EXISTS "application" (
    "id"          INTEGER   NOT NULL PRIMARY KEY AUTOINCREMENT,
    "created"     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "modified"    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "enddate"     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "name"        TEXT      NOT NULL,
    "first_name"  TEXT      NULL,
    "last_name"   TEXT      NULL,
    "description" TEXT      NULL,
    "zipcode"     TEXT      NULL,
    "city"        TEXT      NULL,
    "street"      TEXT      NULL,
    "command"     TEXT      NULL,
    "url"         TEXT      NULL
);

CREATE TABLE IF NOT EXISTS "urls" (
    "id"      INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name"    TEXT    NOT NULL,
    "command" TEXT    NULL,
    "email"   TEXT    NULL
);

CREATE TABLE IF NOT EXISTS "files" (
    "id"      INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name"    TEXT    NOT NULL,
    "command" TEXT    NULL,
    "email"   TEXT    NULL
);

CREATE TABLE IF NOT EXISTS "core_applications" (
    "id"          INTEGER   NOT NULL PRIMARY KEY AUTOINCREMENT,
    "created"     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "modified"    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "enddate"     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "name"        TEXT      NOT NULL,
    "first_name"  TEXT      NULL,
    "last_name"   TEXT      NULL,
    "description" TEXT      NULL,
    "zipcode"     TEXT      NULL,
    "city"        TEXT      NULL,
    "street"      TEXT      NULL,
    "command"     TEXT      NULL,
    "url"         TEXT      NULL
);

CREATE TABLE IF NOT EXISTS "core_users" (
    "id"          INTEGER   NOT NULL PRIMARY KEY AUTOINCREMENT,
    "created"     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "modified"    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "name"        TEXT      NOT NULL,
    "first_name"  TEXT      NULL,
    "last_name"   TEXT      NULL,
    "description" TEXT      NULL,
    "zipcode"     TEXT      NULL,
    "city"        TEXT      NULL,
    "street"      TEXT      NULL,
    "url"         TEXT      NULL
);

CREATE TABLE IF NOT EXISTS "core_tools" (
    "id"          INTEGER   NOT NULL PRIMARY KEY AUTOINCREMENT,
    "created"     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "modified"    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "name"        TEXT      NOT NULL,
    "first_name"  TEXT      NULL,
    "last_name"   TEXT      NULL,
    "description" TEXT      NULL,
    "zipcode"     TEXT      NULL,
    "city"        TEXT      NULL,
    "street"      TEXT      NULL,
    "url"         TEXT      NULL
);

-- Seed data (safe to re-run)
INSERT OR IGNORE INTO "users"("id","name","command","email")
VALUES 
(1,'https://www.letztechance.org/','https://www.letztechance.org/start.html','admin@letztechance.org'),
(2,'LC2Navigator2027.exe','exec.bat LC2Navigator2027','test@letztechance.org');

INSERT OR IGNORE INTO "application"("id","name","description","command","url")
VALUES 
(1,'https://www.letztechance.org','exec.bat LC2Navigator2027','start LC2Navigator2027.exe','https://www.letztechance.org'),
(2,'https://www.letztechance.org','exec.bat LC2Navigator2027.exe','start LC2Navigator2027.exe','https://www.letztechance.org');
