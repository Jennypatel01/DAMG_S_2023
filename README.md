# DAMG_S_2023

Project link: https://github.com/Jennypatel01/DAMG_S_2023/tree/main

Step 1. Create a user app_admin while running below code;
CREATE USER app_admin IDENTIFIED BY Jennpateadmin150102#;
GRANT CREATE SESSION TO app_admin;
ALTER USER app_admin DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;
ALTER USER app_admin TEMPORARY TABLESPACE TEMP;

GRANT CONNECT TO app_admin;
GRANT CREATE PROCEDURE TO app_admin;
GRANT DROP ANY TABLE TO app_admin;
GRANT CREATE ANY TABLE, ALTER ANY TABLE, DROP ANY TABLE, CREATE ANY SEQUENCE, DROP ANY SEQUENCE TO app_admin;
GRANT CREATE VIEW TO app_admin;
GRANT DROP ANY VIEW TO app_admin;
GRANT CREATE TRIGGER TO app_admin;
GRANT GRANT ANY OBJECT PRIVILEGE TO app_admin;
GRANT SELECT ANY TABLE TO app_admin;


Step 2. 
Run Project3.1-DML_DDL_FIXED.sql and project3 views final.sql  in app_admin





P.S.
proj_roles.sql  consists of different roles and grants for users.

