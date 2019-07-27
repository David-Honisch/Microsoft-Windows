SELECT 'UPDATING';
.mode insert
.separator ";"
.output .\\sql\\_dbexport.sql
--.dump;
SELECT 'UPDATING DONE';
--.exit;