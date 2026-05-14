-- LetzteChance Job Database Migration Script
-- This script creates the database schema and populates it with example data
-- Create version tracking table
CREATE TABLE IF NOT EXISTS db_version (version INTEGER PRIMARY KEY);

-- Create jobs table
CREATE TABLE IF NOT EXISTS jobs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    company TEXT NOT NULL,
    location TEXT NOT NULL,
    job_type TEXT NOT NULL,
    category TEXT NOT NULL,
    description TEXT NOT NULL,
    requirements TEXT,
    benefits TEXT,
    salary TEXT,
    posted_date TEXT NOT NULL,
    deadline TEXT,
    contact_email TEXT NOT NULL,
    contact_phone TEXT,
    website TEXT,
    featured INTEGER NOT NULL DEFAULT 0,
    external_id TEXT,
    last_synced TEXT,
    shell_command TEXT,
    download_files TEXT
);

-- Create unique index on external_id for API sync
CREATE UNIQUE INDEX IF NOT EXISTS idx_external_id ON jobs(external_id);

-- Insert initial version
INSERT INTO
    db_version (version)
VALUES
    (2);

-- Insert example jobs
INSERT INTO
    jobs (
        title,
        company,
        location,
        job_type,
        category,
        description,
        requirements,
        benefits,
        salary,
        posted_date,
        deadline,
        contact_email,
        contact_phone,
        website,
        featured,
        shell_command,
        download_files
    )
VALUES
    (
        'lc2-maven-plugin Developer Edition',
        'Apache Maven',
        'Apache Maven',
        'Full-time',
        'Development & IT',
        'Maven 3.383.',
        'Development & IT',
        'Apache Maven',
        '€0,0 - €0/month',
        '2026-05-01T10:00:00Z',
        '2026-05-13T23:59:59Z',
        'webmaster@letztechance.org',
        '+49 30 12345678',
        'https://www.letztechance.org/lc/webservices/client.php?q=getListJSON&value1=1&value2=1',
        1,
        'mvn install',
        '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/LC2CRC32.zip","filename":"LC2CRC32.zip","destination":"./","extractArchive":false,"createDirectory":true}]'
    ),
    (
        'lc2-ant-plugin Developer Edition',
        'Apache Ant',
        'Apache Ant',
        'Full-time',
        'Development & IT',
        'Maven 3.383.',
        'Development & IT',
        'Apache Maven',
        '€0,0 - €0/month',
        '2026-05-01T10:00:00Z',
        '2026-05-14T23:59:59Z',
        'webmaster@letztechance.org',
        '+49 30 12345678',
        'https://www.letztechance.org/lc/webservices/client.php?q=getListJSON&value1=1&value2=1',
        1,
        'mvn install',
        '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/LC2CRC32.zip","filename":"LC2CRC32.zip","destination":"./","extractArchive":false,"createDirectory":true}]'
    ),
    (
        'LC2CRC32 Developer Edition',
        'LC2CRC32',
        'LC2CRC32',
        'Full-time',
        'Development & IT',
        'LC2CRC32 v.1.0',
        'Development & IT',
        'Apache Maven',
        '€0,0 - €0/month',
        '2026-05-01T10:00:00Z',
        '2026-05-20T23:59:59Z',
        'webmaster@letztechance.org',
        '+49 30 12345678',
        'https://www.letztechance.org/lc/webservices/client.php?q=getListJSON&value1=1&value2=1',
        1,
        'mvn install',
        '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/LC2CRC32.zip","filename":"LC2CRC32.zip","destination":"./","extractArchive":false,"createDirectory":true}]'
    ),
    (
        'lc2self-extract-go packer Developer Edition',
        'lc2self-extract-go packer',
        'lc2self-extract-go packer',
        'Full-time',
        'Development & IT',
        'lc2self-extract-go packer Developer Edition v.1.0',
        'Development & IT',
        'packer',
        '€0,0 - €0/month',
        '2026-05-01T10:00:00Z',
        '2026-05-10T23:59:59Z',
        'webmaster@letztechance.org',
        '+49 30 12345678',
        'https://www.letztechance.org/lc/webservices/client.php?q=getListJSON&value1=1&value2=1',
        1,
        'lc2packer.exe',
        '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/lc2self-extract-go/bin/lc2packer.exe","filename":"lc2packer.exe","destination":"./","extractArchive":false,"createDirectory":true}]'
    ),
    (
        'lc2self-extract-go lc2loader Developer Edition',
        'lc2self-extract-go lc2loader',
        'lc2self-extract-go lc2loader',
        'Full-time',
        'Development & IT',
        'lc2self-extract-go lc2loader Developer Edition v.1.0',
        'Development & IT',
        'lc2loader',
        '€0,0 - €0/month',
        '2026-05-01T10:00:00Z',
        '2026-05-10T23:59:59Z',
        'webmaster@letztechance.org',
        '+49 30 12345678',
        'https://www.letztechance.org/lc/webservices/client.php?q=getListJSON&value1=1&value2=1',
        1,
        'lc2packer.exe',
        '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/lc2self-extract-go/bin/lc2loader.exe","filename":"lc2loader.exe","destination":"./","extractArchive":false,"createDirectory":true}]'
    ),
    (
        'LC2CRC32 Developer Edition',
        'LC2CRC32',
        'LC2CRC32',
        'Full-time',
        'Development & IT',
        'LC2CRC32 v.1.0',
        'Development & IT',
        'LC2CRC32',
        '€0,0 - €0/month',
        '2026-05-01T10:00:00Z',
        '2026-05-20T23:59:59Z',
        'webmaster@letztechance.org',
        '+49 30 12345678',
        'https://www.letztechance.org/lc/webservices/client.php?q=getListJSON&value1=1&value2=1',
        0,
        'mvn install',
        '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/LC2CRC32.zip","filename":"LC2CRC32.zip","destination":"./","extractArchive":true,"createDirectory":true}]'
    ),
    (
        'LC2ShortCutCLI Developer Edition',
        'LC2ShortCutCLI',
        'LC2ShortCutCLI',
        'Full-time',
        'Development & IT',
        'LC2ShortCutCLI v.1.0',
        'Development & IT',
        'LC2ShortCutCLI',
        '€0,0 - €0/month',
        '2026-05-01T10:00:00Z',
        '2026-05-20T23:59:59Z',
        'webmaster@letztechance.org',
        '+49 30 12345678',
        'https://www.letztechance.org/lc/webservices/client.php?q=getListJSON&value1=1&value2=1',
        0,
        'mvn install',
        '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/LC2ShortCutCLI.zip","filename":"LC2ShortCutCLI.zip","destination":"./","extractArchive":true,"createDirectory":true}]'
    ),
    (
        'allexe.csv ',
        'allexe.csv ',
        'Remote:allexe.csv ',
        'Full-time',
        'Development & IT',
        'LC2ShortCutCLI v.1.0',
        'Development & IT',
        'LC2ShortCutCLI',
        '€0,0 - €0/month',
        '2026-05-01T10:00:00Z',
        '2026-05-20T23:59:59Z',
        'webmaster@letztechance.org',
        '+49 30 12345678',
        'https://www.letztechance.org/lc/webservices/client.php?q=getListJSON&value1=1&value2=1',
        0,
        'exec.bat type allexe.csv ',
        '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/allexe.csv ","filename":"allexe.csv ","destination":"./","extractArchive":false,"createDirectory":true}]'
    ),
    (
        'lc2licensing_server.exe ',
        'lc2licensing_server.exe ',
        'Remote:lc2licensing_server.exe ',
        'Full-time',
        'Development & IT',
        'LC2ShortCutCLI v.1.0',
        'Development & IT',
        'LC2ShortCutCLI',
        '€0,0 - €0/month',
        '2026-05-01T10:00:00Z',
        '2026-05-20T23:59:59Z',
        'webmaster@letztechance.org',
        '+49 30 12345678',
        'https://www.letztechance.org/lc/webservices/client.php?q=getListJSON&value1=1&value2=1',
        0,
        'exec.bat lc2licensing_server.exe ',
        '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/lc2licensing_server/license.json ","filename":"license.json","destination":"./","extractArchive":false,"createDirectory":true},{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/lc2licensing_server/lc2licensing_server.exe ","filename":"lc2licensing_server.exe ","destination":"./","extractArchive":false,"createDirectory":true}]'
    )
    ;

--,
-- (
--     'cmp.bat ',
--     'cmp.bat ',
--     'Remote:cmp.bat ',
--     'Full-time',
--     'Development & IT',
--     '1.0.0',
--     'cmp.bat ',
--     'Development & IT',
--     'cmp.bat @cmp.bat ',
--     '+4900000000',
--     'https://www.letztechance.org/lc/',
--     1,
--     'exec cmp.bat ',
--     '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/cmp.bat ","filename":"cmp.bat ","destination":"./","extractArchive":false,"createDirectory":true}]'
-- )
;

--  ('allexe.csv ', 'allexe.csv ', 'Remote:allexe.csv ', 'Full-time', 'Development & IT', '1.0.0', 'allexe.csv ', 'Development & IT', 'allexe.csv @allexe.csv ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec allexe.csv ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/allexe.csv ","filename":"allexe.csv ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('cmp.bat ', 'cmp.bat ', 'Remote:cmp.bat ', 'Full-time', 'Development & IT', '1.0.0', 'cmp.bat ', 'Development & IT', 'cmp.bat @cmp.bat ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec cmp.bat ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/cmp.bat ","filename":"cmp.bat ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('cmp.ps1 ', 'cmp.ps1 ', 'Remote:cmp.ps1 ', 'Full-time', 'Development & IT', '1.0.0', 'cmp.ps1 ', 'Development & IT', 'cmp.ps1 @cmp.ps1 ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec cmp.ps1 ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/cmp.ps1 ","filename":"cmp.ps1 ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('create.lc2sfv.bat ', 'create.lc2sfv.bat ', 'Remote:create.lc2sfv.bat ', 'Full-time', 'Development & IT', '1.0.0', 'create.lc2sfv.bat ', 'Development & IT', 'create.lc2sfv.bat @create.lc2sfv.bat ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec create.lc2sfv.bat ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/create.lc2sfv.bat ","filename":"create.lc2sfv.bat ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('createjoblist.bat ', 'createjoblist.bat ', 'Remote:createjoblist.bat ', 'Full-time', 'Development & IT', '1.0.0', 'createjoblist.bat ', 'Development & IT', 'createjoblist.bat @createjoblist.bat ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec createjoblist.bat ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/createjoblist.bat ","filename":"createjoblist.bat ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('dirs.csv ', 'dirs.csv ', 'Remote:dirs.csv ', 'Full-time', 'Development & IT', '1.0.0', 'dirs.csv ', 'Development & IT', 'dirs.csv @dirs.csv ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec dirs.csv ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/dirs.csv ","filename":"dirs.csv ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('files.md ', 'files.md ', 'Remote:files.md ', 'Full-time', 'Development & IT', '1.0.0', 'files.md ', 'Development & IT', 'files.md @files.md ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec files.md ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/files.md ","filename":"files.md ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('joblist.csv ', 'joblist.csv ', 'Remote:joblist.csv ', 'Full-time', 'Development & IT', '1.0.0', 'joblist.csv ', 'Development & IT', 'joblist.csv @joblist.csv ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec joblist.csv ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/joblist.csv ","filename":"joblist.csv ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('json2xml.bat ', 'json2xml.bat ', 'Remote:json2xml.bat ', 'Full-time', 'Development & IT', '1.0.0', 'json2xml.bat ', 'Development & IT', 'json2xml.bat @json2xml.bat ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec json2xml.bat ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/json2xml.bat ","filename":"json2xml.bat ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2antibruteforce.exe ', 'lc2antibruteforce.exe ', 'Remote:lc2antibruteforce.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2antibruteforce.exe ', 'Development & IT', 'lc2antibruteforce.exe @lc2antibruteforce.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2antibruteforce.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2antibruteforce.exe ","filename":"lc2antibruteforce.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2asciipatcher.exe ', 'lc2asciipatcher.exe ', 'Remote:lc2asciipatcher.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2asciipatcher.exe ', 'Development & IT', 'lc2asciipatcher.exe @lc2asciipatcher.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2asciipatcher.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2asciipatcher.exe ","filename":"lc2asciipatcher.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2bat.exe ', 'lc2bat.exe ', 'Remote:lc2bat.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2bat.exe ', 'Development & IT', 'lc2bat.exe @lc2bat.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2bat.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2bat.exe ","filename":"lc2bat.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2batwrapper.exe ', 'lc2batwrapper.exe ', 'Remote:lc2batwrapper.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2batwrapper.exe ', 'Development & IT', 'lc2batwrapper.exe @lc2batwrapper.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2batwrapper.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2batwrapper.exe ","filename":"lc2batwrapper.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2bf6trainer.exe ', 'lc2bf6trainer.exe ', 'Remote:lc2bf6trainer.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2bf6trainer.exe ', 'Development & IT', 'lc2bf6trainer.exe @lc2bf6trainer.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2bf6trainer.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2bf6trainer.exe ","filename":"lc2bf6trainer.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2calljar.exe ', 'lc2calljar.exe ', 'Remote:lc2calljar.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2calljar.exe ', 'Development & IT', 'lc2calljar.exe @lc2calljar.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2calljar.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2calljar.exe ","filename":"lc2calljar.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2ce.exe ', 'lc2ce.exe ', 'Remote:lc2ce.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2ce.exe ', 'Development & IT', 'lc2ce.exe @lc2ce.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2ce.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2ce.exe ","filename":"lc2ce.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2compress.rs ', 'lc2compress.rs ', 'Remote:lc2compress.rs ', 'Full-time', 'Development & IT', '1.0.0', 'lc2compress.rs ', 'Development & IT', 'lc2compress.rs @lc2compress.rs ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2compress.rs ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2compress.rs ","filename":"lc2compress.rs ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2copy_protection.exe ', 'lc2copy_protection.exe ', 'Remote:lc2copy_protection.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2copy_protection.exe ', 'Development & IT', 'lc2copy_protection.exe @lc2copy_protection.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2copy_protection.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2copy_protection.exe ","filename":"lc2copy_protection.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2copy_protection_impl.exe ', 'lc2copy_protection_impl.exe ', 'Remote:lc2copy_protection_impl.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2copy_protection_impl.exe ', 'Development & IT', 'lc2copy_protection_impl.exe @lc2copy_protection_impl.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2copy_protection_impl.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2copy_protection_impl.exe ","filename":"lc2copy_protection_impl.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2crcdirs.csv ', 'lc2crcdirs.csv ', 'Remote:lc2crcdirs.csv ', 'Full-time', 'Development & IT', '1.0.0', 'lc2crcdirs.csv ', 'Development & IT', 'lc2crcdirs.csv @lc2crcdirs.csv ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2crcdirs.csv ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2crcdirs.csv ","filename":"lc2crcdirs.csv ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2csv_xslt_to_json.exe ', 'lc2csv_xslt_to_json.exe ', 'Remote:lc2csv_xslt_to_json.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2csv_xslt_to_json.exe ', 'Development & IT', 'lc2csv_xslt_to_json.exe @lc2csv_xslt_to_json.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2csv_xslt_to_json.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2csv_xslt_to_json.exe ","filename":"lc2csv_xslt_to_json.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2curl.exe ', 'lc2curl.exe ', 'Remote:lc2curl.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2curl.exe ', 'Development & IT', 'lc2curl.exe @lc2curl.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2curl.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2curl.exe ","filename":"lc2curl.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2custommultiui.exe ', 'lc2custommultiui.exe ', 'Remote:lc2custommultiui.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2custommultiui.exe ', 'Development & IT', 'lc2custommultiui.exe @lc2custommultiui.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2custommultiui.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2custommultiui.exe ","filename":"lc2custommultiui.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2dir2json.exe ', 'lc2dir2json.exe ', 'Remote:lc2dir2json.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2dir2json.exe ', 'Development & IT', 'lc2dir2json.exe @lc2dir2json.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2dir2json.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2dir2json.exe ","filename":"lc2dir2json.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2dirmarkup.exe ', 'lc2dirmarkup.exe ', 'Remote:lc2dirmarkup.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2dirmarkup.exe ', 'Development & IT', 'lc2dirmarkup.exe @lc2dirmarkup.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2dirmarkup.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2dirmarkup.exe ","filename":"lc2dirmarkup.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2dl.exe ', 'lc2dl.exe ', 'Remote:lc2dl.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2dl.exe ', 'Development & IT', 'lc2dl.exe @lc2dl.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2dl.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2dl.exe ","filename":"lc2dl.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2ecolor.exe ', 'lc2ecolor.exe ', 'Remote:lc2ecolor.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2ecolor.exe ', 'Development & IT', 'lc2ecolor.exe @lc2ecolor.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2ecolor.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2ecolor.exe ","filename":"lc2ecolor.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2execasdadmin.exe ', 'lc2execasdadmin.exe ', 'Remote:lc2execasdadmin.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2execasdadmin.exe ', 'Development & IT', 'lc2execasdadmin.exe @lc2execasdadmin.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2execasdadmin.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2execasdadmin.exe ","filename":"lc2execasdadmin.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2gitreadme.exe ', 'lc2gitreadme.exe ', 'Remote:lc2gitreadme.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2gitreadme.exe ', 'Development & IT', 'lc2gitreadme.exe @lc2gitreadme.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2gitreadme.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2gitreadme.exe ","filename":"lc2gitreadme.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2httpclient.exe ', 'lc2httpclient.exe ', 'Remote:lc2httpclient.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2httpclient.exe ', 'Development & IT', 'lc2httpclient.exe @lc2httpclient.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2httpclient.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2httpclient.exe ","filename":"lc2httpclient.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2httpserver.exe ', 'lc2httpserver.exe ', 'Remote:lc2httpserver.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2httpserver.exe ', 'Development & IT', 'lc2httpserver.exe @lc2httpserver.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2httpserver.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2httpserver.exe ","filename":"lc2httpserver.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2httpserver2026.exe ', 'lc2httpserver2026.exe ', 'Remote:lc2httpserver2026.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2httpserver2026.exe ', 'Development & IT', 'lc2httpserver2026.exe @lc2httpserver2026.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2httpserver2026.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2httpserver2026.exe ","filename":"lc2httpserver2026.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2imgtag.exe ', 'lc2imgtag.exe ', 'Remote:lc2imgtag.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2imgtag.exe ', 'Development & IT', 'lc2imgtag.exe @lc2imgtag.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2imgtag.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2imgtag.exe ","filename":"lc2imgtag.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2import_json2sqlite.exe ', 'lc2import_json2sqlite.exe ', 'Remote:lc2import_json2sqlite.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2import_json2sqlite.exe ', 'Development & IT', 'lc2import_json2sqlite.exe @lc2import_json2sqlite.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2import_json2sqlite.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2import_json2sqlite.exe ","filename":"lc2import_json2sqlite.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2indexpc.exe ', 'lc2indexpc.exe ', 'Remote:lc2indexpc.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2indexpc.exe ', 'Development & IT', 'lc2indexpc.exe @lc2indexpc.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2indexpc.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2indexpc.exe ","filename":"lc2indexpc.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2irc.exe ', 'lc2irc.exe ', 'Remote:lc2irc.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2irc.exe ', 'Development & IT', 'lc2irc.exe @lc2irc.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2irc.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2irc.exe ","filename":"lc2irc.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2json2xml2json.exe ', 'lc2json2xml2json.exe ', 'Remote:lc2json2xml2json.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2json2xml2json.exe ', 'Development & IT', 'lc2json2xml2json.exe @lc2json2xml2json.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2json2xml2json.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2json2xml2json.exe ","filename":"lc2json2xml2json.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2kubectrl.exe ', 'lc2kubectrl.exe ', 'Remote:lc2kubectrl.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2kubectrl.exe ', 'Development & IT', 'lc2kubectrl.exe @lc2kubectrl.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2kubectrl.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2kubectrl.exe ","filename":"lc2kubectrl.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2licensing_server.exe ', 'lc2licensing_server.exe ', 'Remote:lc2licensing_server.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2licensing_server.exe ', 'Development & IT', 'lc2licensing_server.exe @lc2licensing_server.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2licensing_server.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2licensing_server.exe ","filename":"lc2licensing_server.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2makehrefs.cpp ', 'lc2makehrefs.cpp ', 'Remote:lc2makehrefs.cpp ', 'Full-time', 'Development & IT', '1.0.0', 'lc2makehrefs.cpp ', 'Development & IT', 'lc2makehrefs.cpp @lc2makehrefs.cpp ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2makehrefs.cpp ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2makehrefs.cpp ","filename":"lc2makehrefs.cpp ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2makehrefs.rs ', 'lc2makehrefs.rs ', 'Remote:lc2makehrefs.rs ', 'Full-time', 'Development & IT', '1.0.0', 'lc2makehrefs.rs ', 'Development & IT', 'lc2makehrefs.rs @lc2makehrefs.rs ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2makehrefs.rs ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2makehrefs.rs ","filename":"lc2makehrefs.rs ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2markup.exe ', 'lc2markup.exe ', 'Remote:lc2markup.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2markup.exe ', 'Development & IT', 'lc2markup.exe @lc2markup.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2markup.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2markup.exe ","filename":"lc2markup.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2memmod.exe ', 'lc2memmod.exe ', 'Remote:lc2memmod.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2memmod.exe ', 'Development & IT', 'lc2memmod.exe @lc2memmod.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2memmod.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2memmod.exe ","filename":"lc2memmod.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2memory.exe ', 'lc2memory.exe ', 'Remote:lc2memory.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2memory.exe ', 'Development & IT', 'lc2memory.exe @lc2memory.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2memory.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2memory.exe ","filename":"lc2memory.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2mysql.exe ', 'lc2mysql.exe ', 'Remote:lc2mysql.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2mysql.exe ', 'Development & IT', 'lc2mysql.exe @lc2mysql.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2mysql.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2mysql.exe ","filename":"lc2mysql.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2nav.png ', 'lc2nav.png ', 'Remote:lc2nav.png ', 'Full-time', 'Development & IT', '1.0.0', 'lc2nav.png ', 'Development & IT', 'lc2nav.png @lc2nav.png ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2nav.png ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2nav.png ","filename":"lc2nav.png ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('LC2Navigator2024.zip ', 'LC2Navigator2024.zip ', 'Remote:LC2Navigator2024.zip ', 'Full-time', 'Development & IT', '1.0.0', 'LC2Navigator2024.zip ', 'Development & IT', 'LC2Navigator2024.zip @LC2Navigator2024.zip ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec LC2Navigator2024.zip ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/LC2Navigator2024.zip ","filename":"LC2Navigator2024.zip ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('LC2Navigator2025.zip ', 'LC2Navigator2025.zip ', 'Remote:LC2Navigator2025.zip ', 'Full-time', 'Development & IT', '1.0.0', 'LC2Navigator2025.zip ', 'Development & IT', 'LC2Navigator2025.zip @LC2Navigator2025.zip ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec LC2Navigator2025.zip ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/LC2Navigator2025.zip ","filename":"LC2Navigator2025.zip ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2openapi_core.exe ', 'lc2openapi_core.exe ', 'Remote:lc2openapi_core.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2openapi_core.exe ', 'Development & IT', 'lc2openapi_core.exe @lc2openapi_core.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2openapi_core.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2openapi_core.exe ","filename":"lc2openapi_core.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2patcher.exe ', 'lc2patcher.exe ', 'Remote:lc2patcher.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2patcher.exe ', 'Development & IT', 'lc2patcher.exe @lc2patcher.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2patcher.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2patcher.exe ","filename":"lc2patcher.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2replaceinfile.exe ', 'lc2replaceinfile.exe ', 'Remote:lc2replaceinfile.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2replaceinfile.exe ', 'Development & IT', 'lc2replaceinfile.exe @lc2replaceinfile.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2replaceinfile.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2replaceinfile.exe ","filename":"lc2replaceinfile.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2serdejson.exe ', 'lc2serdejson.exe ', 'Remote:lc2serdejson.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2serdejson.exe ', 'Development & IT', 'lc2serdejson.exe @lc2serdejson.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2serdejson.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2serdejson.exe ","filename":"lc2serdejson.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2sfv.exe ', 'lc2sfv.exe ', 'Remote:lc2sfv.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2sfv.exe ', 'Development & IT', 'lc2sfv.exe @lc2sfv.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2sfv.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2sfv.exe ","filename":"lc2sfv.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2sfv_v1_0.exe ', 'lc2sfv_v1_0.exe ', 'Remote:lc2sfv_v1_0.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2sfv_v1_0.exe ', 'Development & IT', 'lc2sfv_v1_0.exe @lc2sfv_v1_0.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2sfv_v1_0.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2sfv_v1_0.exe ","filename":"lc2sfv_v1_0.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2sha1_cracker.exe ', 'lc2sha1_cracker.exe ', 'Remote:lc2sha1_cracker.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2sha1_cracker.exe ', 'Development & IT', 'lc2sha1_cracker.exe @lc2sha1_cracker.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2sha1_cracker.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2sha1_cracker.exe ","filename":"lc2sha1_cracker.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('lc2streamripper.exe ', 'lc2streamripper.exe ', 'Remote:lc2streamripper.exe ', 'Full-time', 'Development & IT', '1.0.0', 'lc2streamripper.exe ', 'Development & IT', 'lc2streamripper.exe @lc2streamripper.exe ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec lc2streamripper.exe ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/lc2streamripper.exe ","filename":"lc2streamripper.exe ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('moveall_exe.bat ', 'moveall_exe.bat ', 'Remote:moveall_exe.bat ', 'Full-time', 'Development & IT', '1.0.0', 'moveall_exe.bat ', 'Development & IT', 'moveall_exe.bat @moveall_exe.bat ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec moveall_exe.bat ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/moveall_exe.bat ","filename":"moveall_exe.bat ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('paginate.md ', 'paginate.md ', 'Remote:paginate.md ', 'Full-time', 'Development & IT', '1.0.0', 'paginate.md ', 'Development & IT', 'paginate.md @paginate.md ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec paginate.md ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/paginate.md ","filename":"paginate.md ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('paginate.xslt ', 'paginate.xslt ', 'Remote:paginate.xslt ', 'Full-time', 'Development & IT', '1.0.0', 'paginate.xslt ', 'Development & IT', 'paginate.xslt @paginate.xslt ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec paginate.xslt ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/paginate.xslt ","filename":"paginate.xslt ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('readme.md ', 'readme.md ', 'Remote:readme.md ', 'Full-time', 'Development & IT', '1.0.0', 'readme.md ', 'Development & IT', 'readme.md @readme.md ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec readme.md ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/readme.md ","filename":"readme.md ","destination":"./","extractArchive":false,"createDirectory":true}]');
--  ('tools.md ', 'tools.md ', 'Remote:tools.md ', 'Full-time', 'Development & IT', '1.0.0', 'tools.md ', 'Development & IT', 'tools.md @tools.md ', '+4900000000', 'https://www.letztechance.org/lc/', 1, 'exec tools.md ', '[{"url":"https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2Navigator2027/plugins/tools/tools.md ","filename":"tools.md ","destination":"./","extractArchive":false,"createDirectory":true}]');
-- Made by David Honisch