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


Step 2. For insert different roles, run the code below.
--user
CREATE USER reg_use IDENTIFIED BY Jennpateu150102#;
GRANT CREATE SESSION TO reg_use;
ALTER USER reg_use DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;
ALTER USER reg_use TEMPORARY TABLESPACE TEMP;
GRANT CONNECT TO reg_use;

--Transaction_manager_user
CREATE USER tran_man IDENTIFIED BY Jennpatetm150102#;
GRANT CREATE SESSION TO tran_man;
ALTER USER tran_man DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;
ALTER USER tran_man TEMPORARY TABLESPACE TEMP;
GRANT CONNECT TO tran_man;

--Content_Manager
CREATE USER cont_man IDENTIFIED BY Jennpatecm150102#;
GRANT CREATE SESSION TO cont_man;
ALTER USER cont_man DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;
ALTER USER cont_man TEMPORARY TABLESPACE TEMP;
GRANT CONNECT TO cont_man;
Run Project-DML_DDL.sql in app_admin


Step 3. Run file app_admin_project.sql in app_admin;

