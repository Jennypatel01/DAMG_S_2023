SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION check_table_exists (
    pi_tname VARCHAR
) RETURN NUMBER AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_exists
    FROM user_tables
    WHERE table_name = UPPER(pi_tname);

    RETURN v_exists;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/



DECLARE
    v_table_exists NUMBER;
BEGIN
    v_table_exists := check_table_exists('SHOW');

    IF v_table_exists != 0 THEN
        -- Drop SHOW table if it exists
        EXECUTE IMMEDIATE 'DROP TABLE SHOW';
        DBMS_OUTPUT.PUT_LINE('Table SHOW dropped successfully.');
    END IF;

    -- Create SHOW table
    EXECUTE IMMEDIATE '
        CREATE TABLE SHOW (
            show_id       INTEGER NOT NULL,
            type          VARCHAR2(50 CHAR) NOT NULL,
            title         VARCHAR2(100 BYTE) NOT NULL,
            date_added    DATE NOT NULL,
            release_date  DATE NOT NULL,
            ratting       INTEGER,
            duration      VARCHAR2(20 CHAR) NOT NULL,
            CONSTRAINT show_pk PRIMARY KEY (show_id)
        )';
    DBMS_OUTPUT.PUT_LINE('Table SHOW created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/




DECLARE
    v_table_exists NUMBER;
BEGIN
    v_table_exists := check_table_exists('ACTOR');

    -- Check if ACTOR table exists
    IF v_table_exists != 0 THEN
        -- Drop foreign key constraints from ACT that reference the ACTOR table
        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE ACT DROP CONSTRAINT act_actor_fk';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Foreign key constraint act_actor_fk not found or ACT table does not exist.');
        END;

        -- Drop the ACTOR table
        EXECUTE IMMEDIATE 'DROP TABLE ACTOR CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table ACTOR dropped successfully.');
    END IF;

    -- Recreate the ACTOR table
    EXECUTE IMMEDIATE '
        CREATE TABLE ACTOR (
            actor_id INTEGER NOT NULL,
            actor_name VARCHAR2(20 CHAR) NOT NULL,
            CONSTRAINT actor_pk PRIMARY KEY (actor_id)
        )';
    DBMS_OUTPUT.PUT_LINE('Table ACTOR created successfully.');

    -- Recreate the foreign key constraints in ACT that reference the ACTOR table
-- EXECUTE IMMEDIATE 'ALTER TABLE ACT ADD CONSTRAINT act_actor_fk FOREIGN KEY (actor_actor_id) REFERENCES ACTOR (actor_id)';

    DBMS_OUTPUT.PUT_LINE('Foreign key constraints on ACTOR table created successfully.');

    -- Since the ACT table would have been dropped prior based on dependency, no immediate action is needed here for constraints
    -- When re-creating the ACT table, ensure to include the foreign key constraints as part of its definition

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/



DECLARE
    v_table_exists NUMBER;
BEGIN
    v_table_exists := check_table_exists('ACT');

    -- Check if ACT table exists
    IF v_table_exists != 0 THEN
        -- Drop the ACT table including dependent constraints
        EXECUTE IMMEDIATE 'DROP TABLE ACT CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table ACT dropped successfully.');
    END IF;

    -- Recreate the ACT table
    EXECUTE IMMEDIATE '
        CREATE TABLE ACT (
            show_show_id   INTEGER NOT NULL,
            actor_actor_id INTEGER NOT NULL,
            CONSTRAINT act_pk PRIMARY KEY (show_show_id, actor_actor_id)
        )';
    DBMS_OUTPUT.PUT_LINE('Table ACT created successfully.');

    -- Since ACT is dependent on SHOW and ACTOR, ensure those tables exist or are created before the next steps
    -- After SHOW and ACTOR tables are ensured to be created, recreate foreign key constraints

    -- Assuming SHOW and ACTOR tables exist, recreate foreign key constraints
    EXECUTE IMMEDIATE 'ALTER TABLE ACT ADD CONSTRAINT act_show_fk FOREIGN KEY (show_show_id) REFERENCES SHOW (show_id)';
    EXECUTE IMMEDIATE 'ALTER TABLE ACT ADD CONSTRAINT act_actor_fk FOREIGN KEY (actor_actor_id) REFERENCES ACTOR (actor_id)';

    DBMS_OUTPUT.PUT_LINE('Foreign key constraints on ACT table created successfully.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/



DECLARE
    v_table_exists NUMBER;
BEGIN
    v_table_exists := check_table_exists('DIRECTOR');

    -- Check if DIRECTOR table exists
    IF v_table_exists != 0 THEN
        -- Drop foreign key constraints from DIRECT that reference the DIRECTOR table
        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE DIRECT DROP CONSTRAINT direct_director_fk';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Foreign key constraint direct_director_fk not found or DIRECT table does not exist.');
        END;

        -- Drop the DIRECTOR table
        EXECUTE IMMEDIATE 'DROP TABLE DIRECTOR CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table DIRECTOR dropped successfully.');
    END IF;

    -- Recreate the DIRECTOR table
    EXECUTE IMMEDIATE '
        CREATE TABLE DIRECTOR (
            director_id   INTEGER NOT NULL,
            director_name VARCHAR2(20 CHAR) NOT NULL,
            CONSTRAINT director_pk PRIMARY KEY (director_id)
        )';
    DBMS_OUTPUT.PUT_LINE('Table DIRECTOR created successfully.');

    -- Since DIRECT is dependent on SHOW and DIRECTOR, ensure those tables exist or are created before the next steps
    -- After SHOW and DIRECTOR tables are ensured to be created, recreate foreign key constraints

    -- Assuming SHOW and DIRECTOR tables exist, recreate foreign key constraints
    --EXECUTE IMMEDIATE 'ALTER TABLE DIRECT ADD CONSTRAINT direct_director_fk FOREIGN KEY (director_director_id) REFERENCES DIRECTOR (director_id)';
    DBMS_OUTPUT.PUT_LINE('Foreign key constraints on DIRECT table created successfully.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/
    



DECLARE
    v_table_exists NUMBER;
BEGIN
    v_table_exists := check_table_exists('DIRECT');

    IF v_table_exists != 0 THEN

        EXECUTE IMMEDIATE 'DROP TABLE DIRECT CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table DIRECT dropped successfully.');
    END IF;

    EXECUTE IMMEDIATE '
        CREATE TABLE DIRECT (
            show_show_id         INTEGER NOT NULL,
            director_director_id INTEGER NOT NULL,
            CONSTRAINT direct_pk PRIMARY KEY (show_show_id, director_director_id)
        )';
    DBMS_OUTPUT.PUT_LINE('Table DIRECT created successfully.');
    
    EXECUTE IMMEDIATE 'ALTER TABLE DIRECT ADD CONSTRAINT direct_show_fk FOREIGN KEY (show_show_id) REFERENCES SHOW (show_id)';
    EXECUTE IMMEDIATE 'ALTER TABLE DIRECT ADD CONSTRAINT direct_director_fk FOREIGN KEY (director_director_id) REFERENCES DIRECTOR (director_id)';
    DBMS_OUTPUT.PUT_LINE('Foreign key constraints on DIRECT table created successfully.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/





DECLARE
    v_table_exists NUMBER;
BEGIN
    v_table_exists := check_table_exists('GENRE');

    -- Check if GENRE table exists
    IF v_table_exists != 0 THEN
        -- Drop foreign key constraints from TYPE that reference the GENRE table
        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE TYPE DROP CONSTRAINT type_genre_fk';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Foreign key constraint type_genre_fk not found or TYPE table does not exist.');
        END;

        -- Drop the GENRE table
        EXECUTE IMMEDIATE 'DROP TABLE GENRE CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table GENRE dropped successfully.');
    END IF;

    -- Recreate the GENRE table
    EXECUTE IMMEDIATE '
        CREATE TABLE GENRE (
            genre_id   INTEGER NOT NULL,
            show_show_id  INTEGER NOT NULL,
            CONSTRAINT genre_pk PRIMARY KEY (genre_id)
        )';
    DBMS_OUTPUT.PUT_LINE('Table GENRE created successfully.');

    -- Recreate the foreign key constraints in TYPE that reference the GENRE table
    BEGIN
        --EXECUTE IMMEDIATE 'ALTER TABLE TYPE ADD CONSTRAINT type_genre_fk FOREIGN KEY (genre_genre_id) REFERENCES GENRE (genre_id)';
        DBMS_OUTPUT.PUT_LINE('Foreign key constraint type_genre_fk recreated successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error occurred while recreating foreign key constraint in TYPE table: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/



DECLARE
    v_table_exists NUMBER;
BEGIN
    v_table_exists := check_table_exists('TYPE');

    -- Check if TYPE table exists
    IF v_table_exists != 0 THEN
        -- Drop the TYPE table including dependent constraints
        EXECUTE IMMEDIATE 'DROP TABLE TYPE CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table TYPE dropped successfully.');
    END IF;

    -- Recreate the TYPE table
    EXECUTE IMMEDIATE '
        CREATE TABLE TYPE (
            genre_genre_id INTEGER NOT NULL,
            show_show_id   INTEGER NOT NULL,
            CONSTRAINT type_pk PRIMARY KEY (genre_genre_id, show_show_id)
        )';
    DBMS_OUTPUT.PUT_LINE('Table TYPE created successfully.');

    -- Since TYPE is dependent on GENRE and SHOW, ensure those tables exist or are created before the next steps
    -- After GENRE and SHOW tables are ensured to be created, recreate foreign key constraints

    -- Assuming GENRE and SHOW tables exist, recreate foreign key constraints
    EXECUTE IMMEDIATE 'ALTER TABLE TYPE ADD CONSTRAINT type_genre_fk FOREIGN KEY (genre_genre_id) REFERENCES GENRE (genre_id)';
    EXECUTE IMMEDIATE 'ALTER TABLE TYPE ADD CONSTRAINT type_show_fk FOREIGN KEY (show_show_id) REFERENCES SHOW (show_id)';

    DBMS_OUTPUT.PUT_LINE('Foreign key constraints on TYPE table created successfully.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/



DECLARE
    v_table_exists NUMBER;
BEGIN
    v_table_exists := check_table_exists('PROVIDER');

   
    IF v_table_exists != 0 THEN
        BEGIN
           EXECUTE IMMEDIATE 'ALTER TABLE SHOW_PROV DROP CONSTRAINT show_prov_provider_fk';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Foreign key constraint show_prov_provider_fk not found or SHOW_PROV table does not exist.');
        END;

        EXECUTE IMMEDIATE 'DROP TABLE PROVIDER CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table PROVIDER dropped successfully.');
    END IF;

    
    EXECUTE IMMEDIATE '
        CREATE TABLE PROVIDER (
            provider_id   INTEGER NOT NULL,
            provider_name VARCHAR2(20 CHAR) NOT NULL,
            CONSTRAINT provider_pk PRIMARY KEY (provider_id)
        )';
    DBMS_OUTPUT.PUT_LINE('Table PROVIDER created successfully.');

   
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/





DECLARE
    v_table_exists NUMBER;
BEGIN

    v_table_exists := check_table_exists('SUBSCRIPTION');

    IF v_table_exists != 0 THEN
        
        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE TRANSACTION DROP CONSTRAINT transaction_subscription_fk';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Foreign key constraint transaction_subscription_fk on Transaction table not found or Transaction table does not exist.');
        END;


        EXECUTE IMMEDIATE 'DROP TABLE SUBSCRIPTION CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table SUBSCRIPTION dropped successfully.');
    END IF;


    EXECUTE IMMEDIATE '
        CREATE TABLE SUBSCRIPTION (
            sub_plan_id          INTEGER NOT NULL,
            plan_name            VARCHAR2(20 CHAR) NOT NULL,
            plan_price           INTEGER NOT NULL,
            plan_duration        INTERVAL YEAR(1) TO MONTH NOT NULL,
            provider_provider_id INTEGER NOT NULL,
            CONSTRAINT subscription_pk PRIMARY KEY (sub_plan_id)
        )';
    DBMS_OUTPUT.PUT_LINE('Table SUBSCRIPTION created successfully.');


    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE SUBSCRIPTION ADD CONSTRAINT subscription_provider_fk FOREIGN KEY (provider_provider_id) REFERENCES PROVIDER (provider_id)';
        DBMS_OUTPUT.PUT_LINE('Foreign key constraint subscription_provider_fk on SUBSCRIPTION table recreated successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error occurred while recreating foreign key constraint on SUBSCRIPTION table: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/


DECLARE
    v_table_exists NUMBER;
BEGIN
    v_table_exists := check_table_exists('SHOW_PROV');


    IF v_table_exists != 0 THEN

--        BEGIN
--            EXECUTE IMMEDIATE 'ALTER TABLE SHOW_PROV DROP CONSTRAINT show_prov_provider_fk';
--        EXCEPTION
--            WHEN OTHERS THEN
--                DBMS_OUTPUT.PUT_LINE('Foreign key constraint show_prov_provider_fk not found or SHOW_PROV table does not exist.');
--        END;

       
        EXECUTE IMMEDIATE 'DROP TABLE SHOW_PROV CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table SHOW_PROV dropped successfully.');
    END IF;

    EXECUTE IMMEDIATE '
        CREATE TABLE SHOW_PROV (
            show_show_id    INTEGER NOT NULL,
            provider_provider_id  INTEGER NOT NULL,
            CONSTRAINT show_prov_pk PRIMARY KEY (show_show_id, provider_provider_id)
        )';
    DBMS_OUTPUT.PUT_LINE('Table SHOW_PROV created successfully.');


    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE SHOW_PROV ADD CONSTRAINT show_prov_provider_fk FOREIGN KEY (provider_provider_id) REFERENCES PROVIDER (provider_id)';
        EXECUTE IMMEDIATE 'ALTER TABLE SHOW_PROV ADD CONSTRAINT show_prov_show_fk FOREIGN KEY (show_show_id) REFERENCES SHOW (show_id)';
        DBMS_OUTPUT.PUT_LINE('Foreign key constraints show_prov_provider_fk and show_prov_show_fk recreated successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error occurred while recreating foreign key constraints in SHOW_PROV table: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/






DECLARE
    v_table_exists NUMBER;
BEGIN
    -- Check if USER table exists
    v_table_exists := check_table_exists('USER');

    IF v_table_exists != 0 THEN
    
        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE TRANSACTION DROP CONSTRAINT transaction_user_fk';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Foreign key constraints on TRANSACTION table not found or TRANSACTION table does not exist.');
        END;

        -- Drop the USER table
        EXECUTE IMMEDIATE 'DROP TABLE "USER" CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table "USER" dropped successfully.');
    END IF;

    -- Recreate the USER table
    EXECUTE IMMEDIATE '
        CREATE TABLE "USER" (
            user_id        INTEGER NOT NULL,
            email          VARCHAR2(20 CHAR) NOT NULL,
            password       VARCHAR2(20 CHAR) NOT NULL,
            sub_status     VARCHAR2(20 CHAR) NOT NULL,
            sub_start_date DATE NOT NULL,
            sub_end_date   DATE NOT NULL,
            CONSTRAINT user_pk PRIMARY KEY (user_id)
        )';
    DBMS_OUTPUT.PUT_LINE('Table "USER" created successfully.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/



DECLARE
    v_table_exists NUMBER;
BEGIN
    -- Check if TRANSACTION table exists
    v_table_exists := check_table_exists('TRANSACTION');

    IF v_table_exists != 0 THEN
        -- Drop foreign key constraint from TRANSACTION table
--        BEGIN
--            EXECUTE IMMEDIATE 'ALTER TABLE TRANSACTION DROP CONSTRAINT transaction_subscription_fk';
--            EXECUTE IMMEDIATE 'ALTER TABLE TRANSACTION DROP CONSTRAINT transaction_user_fk';
--        EXCEPTION
--            WHEN OTHERS THEN
--                DBMS_OUTPUT.PUT_LINE('Foreign key constraints on TRANSACTION table not found or TRANSACTION table does not exist.');
--        END;

        -- Drop the TRANSACTION table
        EXECUTE IMMEDIATE 'DROP TABLE TRANSACTION CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table TRANSACTION dropped successfully.');
    END IF;

    -- Recreate the TRANSACTION table
    EXECUTE IMMEDIATE '
        CREATE TABLE TRANSACTION (
            transaction_id           INTEGER NOT NULL,
            transaction_type         VARCHAR2(20 CHAR) NOT NULL,
            tran_ts                  TIMESTAMP(2) WITH LOCAL TIME ZONE NOT NULL,
            subscription_sub_plan_id INTEGER NOT NULL,
            user_user_id             INTEGER,
            CONSTRAINT transaction_pk PRIMARY KEY (transaction_id)
        )';
    DBMS_OUTPUT.PUT_LINE('Table TRANSACTION created successfully.');

    -- Recreate foreign key constraints in TRANSACTION table
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE TRANSACTION ADD CONSTRAINT transaction_subscription_fk FOREIGN KEY (subscription_sub_plan_id) REFERENCES SUBSCRIPTION (sub_plan_id)';
        EXECUTE IMMEDIATE 'ALTER TABLE TRANSACTION ADD CONSTRAINT transaction_user_fk FOREIGN KEY (user_user_id) REFERENCES "USER" (user_id)';
        DBMS_OUTPUT.PUT_LINE('Foreign key constraints on TRANSACTION table recreated successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error occurred while recreating foreign key constraints on TRANSACTION table: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/





DROP TABLE ACT;
DROP TABLE DIRECT;
DROP TABLE TYPE;
DROP TABLE SHOW;
DROP TABLE ACTOR;
DROP TABLE DIRECTOR;
DROP TABLE GENRE;
Drop TABLE subscription;
Drop Table Provider;
Drop table SUBSCRIPTION;
DROP Table SHOW_PROV;
DROP Table USER;
Drop TAble TRansaction;



--SELECT * FROM USER_CONSTRAINTS;

