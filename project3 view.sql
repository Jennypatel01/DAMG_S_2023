SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION check_table_exists (
    pi_tname VARCHAR
) RETURN NUMBER AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_exists
    FROM user_tables
    WHERE table_name = (pi_tname);

    RETURN v_exists;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/

DECLARE
    v_table_exists NUMBER;
BEGIN

    v_table_exists := check_table_exists('user');


    IF v_table_exists != 0 THEN
        EXECUTE IMMEDIATE 'DROP TABLE "user" CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('"user" table dropped.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('"user" table does not exist.');
    END IF;
END;
/


DECLARE
    TYPE TStringArray IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
    v_tables TStringArray;
BEGIN
   
    v_tables(1) := 'ACT';
    v_tables(2) := 'ACTOR';
    v_tables(3) := 'DIRECT';
    v_tables(4) := 'DIRECTOR';
    v_tables(5) := 'GENRE';
    v_tables(6) := 'PROVIDER';
    v_tables(7) := 'SHOW';
    v_tables(8) := 'SHOW_PROV';
    v_tables(9) := 'SUBSCRIPTION';
    v_tables(10) := 'TRANSACTION';
    v_tables(11) := 'TYPE';
    v_tables(12) := 'user';
    
      
    FOR i IN 1 .. v_tables.COUNT LOOP
        IF check_table_exists(v_tables(i)) != 0 THEN
            EXECUTE IMMEDIATE 'DROP TABLE ' || v_tables(i) || ' CASCADE CONSTRAINTS';
            
        END IF;
    END LOOP;
    




EXECUTE IMMEDIATE '
        CREATE TABLE ACT (
            show_show_id   INTEGER NOT NULL,
            actor_actor_id INTEGER NOT NULL
        )';
   
EXECUTE IMMEDIATE '
        ALTER TABLE ACT ADD CONSTRAINT act_pk PRIMARY KEY (show_show_id, actor_actor_id)';

    
EXECUTE IMMEDIATE '
        CREATE TABLE actor (
            actor_id   INTEGER NOT NULL,
            actor_name VARCHAR2(20 CHAR) NOT NULL
        )';
    

 EXECUTE IMMEDIATE '
        ALTER TABLE actor ADD CONSTRAINT actor_pk PRIMARY KEY (actor_id)';
        
EXECUTE IMMEDIATE'        
CREATE TABLE direct (
    show_show_id         INTEGER NOT NULL,
    director_director_id INTEGER NOT NULL
)';

EXECUTE IMMEDIATE'
ALTER TABLE direct ADD CONSTRAINT direct_pk PRIMARY KEY ( show_show_id,
                                                          director_director_id )';
EXECUTE IMMEDIATE'
CREATE TABLE director (
    director_id   INTEGER NOT NULL,
    director_name VARCHAR2(20 CHAR) NOT NULL
)';

EXECUTE IMMEDIATE'
ALTER TABLE director ADD CONSTRAINT director_pk PRIMARY KEY ( director_id )';

EXECUTE IMMEDIATE'
CREATE TABLE genre (
    genre_id  INTEGER NOT NULL,
    show_type VARCHAR2(20) NOT NULL
)';

EXECUTE IMMEDIATE'
ALTER TABLE genre ADD CONSTRAINT genre_pk PRIMARY KEY ( genre_id )';

EXECUTE IMMEDIATE'
CREATE TABLE provider (
    provider_id   INTEGER NOT NULL,
    provider_name VARCHAR2(20 CHAR) NOT NULL
)';

EXECUTE IMMEDIATE'
ALTER TABLE provider ADD CONSTRAINT provider_pk PRIMARY KEY ( provider_id )';

EXECUTE IMMEDIATE'
CREATE TABLE show (
    show_id      INTEGER NOT NULL,
    type         VARCHAR2(50 CHAR) NOT NULL,
    title        VARCHAR2(100 BYTE) NOT NULL,
    date_added   DATE NOT NULL,
    release_date DATE NOT NULL,
    rating     VARCHAR2(20 CHAR),
    duration     VARCHAR2(20 CHAR) NOT NULL
)';

EXECUTE IMMEDIATE'
ALTER TABLE show ADD CONSTRAINT show_pk PRIMARY KEY ( show_id )';

EXECUTE IMMEDIATE'
CREATE TABLE show_prov (
    show_show_id         INTEGER NOT NULL,
    provider_provider_id INTEGER NOT NULL
)';

EXECUTE IMMEDIATE'
ALTER TABLE show_prov ADD CONSTRAINT show_prov_pk PRIMARY KEY ( show_show_id,
                                                                provider_provider_id )';
EXECUTE IMMEDIATE'
CREATE TABLE subscription (
    sub_plan_id          INTEGER NOT NULL,
    plan_name            VARCHAR2(20 CHAR) NOT NULL,
    plan_price           INTEGER NOT NULL,
    plan_duration        INTERVAL YEAR(1) TO MONTH NOT NULL,
    provider_provider_id INTEGER NOT NULL
)';

EXECUTE IMMEDIATE'
ALTER TABLE subscription ADD CONSTRAINT subscription_pk PRIMARY KEY ( sub_plan_id )';

EXECUTE IMMEDIATE'
CREATE TABLE transaction (
    transaction_id           INTEGER NOT NULL,
    transaction_type         VARCHAR2(20 CHAR) NOT NULL,
    tran_ts                  TIMESTAMP(2) WITH LOCAL TIME ZONE NOT NULL,
    subscription_sub_plan_id INTEGER NOT NULL,
    user_user_id             INTEGER
)';



EXECUTE IMMEDIATE'
CREATE UNIQUE INDEX transaction__idx ON transaction (subscription_sub_plan_id ASC)';


EXECUTE IMMEDIATE'
ALTER TABLE transaction ADD CONSTRAINT transaction_pk PRIMARY KEY ( transaction_id )';

EXECUTE IMMEDIATE'
CREATE TABLE type (
    genre_genre_id INTEGER NOT NULL,
    show_show_id   INTEGER NOT NULL
)';

EXECUTE IMMEDIATE'
ALTER TABLE type ADD CONSTRAINT type_pk PRIMARY KEY ( genre_genre_id,
                                                      show_show_id )';
                                                      
EXECUTE IMMEDIATE'
CREATE TABLE "user" (
    user_id        INTEGER NOT NULL,
    email          VARCHAR2(20 CHAR) NOT NULL,
    password       VARCHAR2(20 CHAR) NOT NULL,
    sub_status     VARCHAR2(20 CHAR) NOT NULL,
    sub_start_date DATE,
    sub_end_date DATE
)';

EXECUTE IMMEDIATE'
ALTER TABLE "user" ADD CONSTRAINT user_pk PRIMARY KEY ( user_id )';

EXECUTE IMMEDIATE'
ALTER TABLE act
    ADD CONSTRAINT act_actor_fk FOREIGN KEY ( actor_actor_id )
        REFERENCES actor ( actor_id )';
        
EXECUTE IMMEDIATE'
ALTER TABLE act
    ADD CONSTRAINT act_show_fk FOREIGN KEY ( show_show_id )
        REFERENCES show ( show_id )';
        
EXECUTE IMMEDIATE'
ALTER TABLE direct
    ADD CONSTRAINT direct_director_fk FOREIGN KEY ( director_director_id )
        REFERENCES director ( director_id )';

EXECUTE IMMEDIATE'
ALTER TABLE direct
    ADD CONSTRAINT direct_show_fk FOREIGN KEY ( show_show_id )
        REFERENCES show ( show_id )';
        
EXECUTE IMMEDIATE'
ALTER TABLE show_prov
    ADD CONSTRAINT show_prov_provider_fk FOREIGN KEY ( provider_provider_id )
        REFERENCES provider ( provider_id )';

EXECUTE IMMEDIATE'
ALTER TABLE show_prov
    ADD CONSTRAINT show_prov_show_fk FOREIGN KEY ( show_show_id )
        REFERENCES show ( show_id )';

EXECUTE IMMEDIATE'
ALTER TABLE subscription
    ADD CONSTRAINT subscription_provider_fk FOREIGN KEY ( provider_provider_id )
        REFERENCES provider ( provider_id )';
        
EXECUTE IMMEDIATE'
ALTER TABLE transaction
    ADD CONSTRAINT transaction_subscription_fk FOREIGN KEY ( subscription_sub_plan_id )
        REFERENCES subscription ( sub_plan_id )';

EXECUTE IMMEDIATE'
ALTER TABLE transaction
    ADD CONSTRAINT transaction_user_fk FOREIGN KEY ( user_user_id )
        REFERENCES "user" ( user_id )';
        
EXECUTE IMMEDIATE'
ALTER TABLE type
    ADD CONSTRAINT type_genre_fk FOREIGN KEY ( genre_genre_id )
        REFERENCES genre ( genre_id )';
        
EXECUTE IMMEDIATE'
ALTER TABLE type
    ADD CONSTRAINT type_show_fk FOREIGN KEY ( show_show_id )
        REFERENCES show ( show_id )';
    

   
    

END;
/

INSERT ALL
INTO show (show_id, type, title, date_added, release_date, rating, duration) VALUES (101, 'TV Show', 'Breaking Bad', TO_DATE('2023-07-11', 'YYYY-MM-DD'), TO_DATE('2008-01-20', 'YYYY-MM-DD'), 'TV-MA', '5 seasons')
INTO show (show_id, type, title, date_added, release_date, rating, duration) VALUES (102, 'TV Show', 'Better Call Saul', TO_DATE('2022-03-05', 'YYYY-MM-DD'), TO_DATE('2015-02-08', 'YYYY-MM-DD'), 'TV-MA', '6 seasons')
INTO show (show_id, type, title, date_added, release_date, rating, duration) VALUES (103, 'Movie', 'Lucy', TO_DATE('2022-11-16', 'YYYY-MM-DD'), TO_DATE('2014-07-25', 'YYYY-MM-DD'), 'R', '89 minutes')
INTO show (show_id, type, title, date_added, release_date, rating, duration) VALUES (104, 'TV Show', 'Arcane: League of Legends', TO_DATE('2023-12-22', 'YYYY-MM-DD'), TO_DATE('2021-11-06', 'YYYY-MM-DD'), 'TV-14', '1 season')
INTO show (show_id, type, title, date_added, release_date, rating, duration) VALUES (105, 'TV Show', 'The Walking Dead', TO_DATE('2024-01-19', 'YYYY-MM-DD'), TO_DATE('2010-10-31', 'YYYY-MM-DD'), 'TV-MA', '11 seasons')
INTO show (show_id, type, title, date_added, release_date, rating, duration) VALUES (106, 'Movie', 'Spider-Man: Across the Spider-Verse', TO_DATE('2023-05-27', 'YYYY-MM-DD'), TO_DATE('2022-10-07', 'YYYY-MM-DD'), 'PG', '120 minutes')
SELECT * FROM dual;

INSERT ALL 
INTO actor (actor_id, actor_name) VALUES (1, 'Bryan Cranston')
INTO actor (actor_id, actor_name) VALUES (2, 'Aaron Paul')
INTO actor (actor_id, actor_name) VALUES (3, 'Bob Odenkirk')
INTO actor (actor_id, actor_name) VALUES (4, 'Scarlett Johansson')
INTO actor (actor_id, actor_name) VALUES (5, 'Morgan Freeman')
INTO actor (actor_id, actor_name) VALUES (6, 'Hailee Steinfeld')
SELECT * FROM dual;

INSERT ALL
  INTO act (show_show_id, actor_actor_id) VALUES (101, 1)
  INTO act (show_show_id, actor_actor_id) VALUES (101, 2)
  INTO act (show_show_id, actor_actor_id) VALUES (102, 3)
  INTO act (show_show_id, actor_actor_id) VALUES (103, 4)
  INTO act (show_show_id, actor_actor_id) VALUES (103, 5)
  INTO act (show_show_id, actor_actor_id) VALUES (104, 6)
  INTO act (show_show_id, actor_actor_id) VALUES (106, 6)
SELECT * FROM dual;

INSERT ALL
  INTO director (director_id, director_name) VALUES (7, 'George Vincent')
  INTO director (director_id, director_name) VALUES (8, 'John Shiban')
  INTO director (director_id, director_name) VALUES (9, 'Luc Besson')
  INTO director (director_id, director_name) VALUES (10, 'Pascal Charrue')
  INTO director (director_id, director_name) VALUES (11, 'Michelle MacLaren')
  INTO director (director_id, director_name) VALUES (12, 'Justin K. Thompson')
  INTO direct (show_show_id, director_director_id) VALUES (101, 7)
  INTO direct (show_show_id, director_director_id) VALUES (102, 8)
  INTO direct (show_show_id, director_director_id) VALUES (103, 9)
  INTO direct (show_show_id, director_director_id) VALUES (104, 10)
  INTO direct (show_show_id, director_director_id) VALUES (105, 11)
  INTO direct (show_show_id, director_director_id) VALUES (106, 12)
SELECT * FROM dual;

INSERT ALL
    INTO genre (genre_id, show_type) VALUES (1,'Crime Drama')
    INTO genre (genre_id, show_type) VALUES (2, 'Legal Drama')
    INTO genre (genre_id, show_type) VALUES (3, 'Action')
    INTO genre (genre_id, show_type) VALUES (4,'Adventure')
    INTO genre (genre_id, show_type) VALUES (5, 'Horror')
    INTO genre (genre_id, show_type) VALUES (6, 'Animation')
SELECT * FROM dual;

INSERT ALL
    INTO type (genre_genre_id, show_show_id) VALUES (1, 101)
    INTO type (genre_genre_id, show_show_id) VALUES (2, 102)
    INTO type (genre_genre_id, show_show_id) VALUES (3, 103)
    INTO type (genre_genre_id, show_show_id) VALUES (4, 104)
    INTO type (genre_genre_id, show_show_id) VALUES (5, 105)
    INTO type (genre_genre_id, show_show_id) VALUES (6, 106)
SELECT * FROM dual;

INSERT ALL
    INTO provider (provider_id, provider_name) VALUES (1, 'Netflex')
    INTO provider (provider_id, provider_name) VALUES (2, 'HuluTV')
    INTO provider (provider_id, provider_name) VALUES (3, 'AmazonPrimeTV')
    INTO provider (provider_id, provider_name) VALUES (4, 'DisneyPlus')
SELECT * FROM dual;

INSERT ALL
    INTO show_prov (show_show_id, provider_provider_id) VALUES (101,1)
    INTO show_prov (show_show_id, provider_provider_id) VALUES (102,2)
    INTO show_prov (show_show_id, provider_provider_id) VALUES (103,3)
    INTO show_prov (show_show_id, provider_provider_id) VALUES (104,4)
    INTO show_prov (show_show_id, provider_provider_id) VALUES (105,3)
    INTO show_prov (show_show_id, provider_provider_id) VALUES (106,1)
SELECT * FROM dual;

INSERT ALL
    INTO subscription (sub_plan_id, plan_name, plan_price, plan_duration, provider_provider_id)
        VALUES (201, 'Basic Plan', 9, INTERVAL '0-1' YEAR TO MONTH, 1)
    INTO subscription (sub_plan_id, plan_name, plan_price, plan_duration, provider_provider_id)
        VALUES (202, 'Prime Plan', 59, INTERVAL '1-0' YEAR TO MONTH, 1)
    INTO subscription (sub_plan_id, plan_name, plan_price, plan_duration, provider_provider_id)
        VALUES (203, 'Basic Plan', 9, INTERVAL '0-1' YEAR TO MONTH, 2)
    INTO subscription (sub_plan_id, plan_name, plan_price, plan_duration, provider_provider_id)
        VALUES (204, 'Prime Plan', 59, INTERVAL '1-0' YEAR TO MONTH, 2)
    INTO subscription (sub_plan_id, plan_name, plan_price, plan_duration, provider_provider_id)
        VALUES (205, 'Basic Plan', 9, INTERVAL '0-1' YEAR TO MONTH, 3)
    INTO subscription (sub_plan_id, plan_name, plan_price, plan_duration, provider_provider_id)
        VALUES (206, 'Prime Plan', 59, INTERVAL '1-0' YEAR TO MONTH, 3)
    INTO subscription (sub_plan_id, plan_name, plan_price, plan_duration, provider_provider_id)
        VALUES (207, 'Basic Plan', 9, INTERVAL '1-0' YEAR TO MONTH, 4)
    INTO subscription (sub_plan_id, plan_name, plan_price, plan_duration, provider_provider_id)
        VALUES (208, 'Prime Plan', 59, INTERVAL '0-1' YEAR TO MONTH, 4)
SELECT * FROM dual;

INSERT ALL
    INTO "user" (user_id, email, password, sub_status, sub_start_date, sub_end_date) VALUES
    (301, 'gary@gmail.com', 'password1', 'Subscribe', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-06-01', 'YYYY-MM-DD'))
    INTO "user" (user_id, email, password, sub_status, sub_start_date, sub_end_date) VALUES
    (302, 'jjking@gmail.com', 'password2', 'Subscribe', TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2025-02-01', 'YYYY-MM-DD'))
    INTO "user" (user_id, email, password, sub_status, sub_start_date, sub_end_date) VALUES
    (303, 'jenny@gmail.com', 'password3', 'Subscribe', TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2024-06-01', 'YYYY-MM-DD'))
    INTO "user" (user_id, email, password, sub_status, sub_start_date, sub_end_date) VALUES
    (304, 'oliver@gmail.com', 'password4', 'Unsubscribe', NULL, NULL)
    INTO "user" (user_id, email, password, sub_status, sub_start_date, sub_end_date) VALUES
    (305, 'lion@gmail.com', 'password5', 'Unsubscribe', NULL, NULL)
    INTO "user" (user_id, email, password, sub_status, sub_start_date, sub_end_date) VALUES
    (306, 'james@gmail.com', 'password6', 'Unsubscribe', NULL, NULL)
SELECT * FROM dual;

INSERT ALL
    INTO transaction (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES
    (401, 'subscription', CURRENT_TIMESTAMP, 201, 301)
    INTO transaction (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES
    (402, 'subscription', TO_TIMESTAMP('2024-01-01 10:00:42', 'YYYY-MM-DD HH24:MI:SS'), 202, 302)
    INTO transaction (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES
    (403, 'subscription', TO_TIMESTAMP('2024-03-04 09:07:31', 'YYYY-MM-DD HH24:MI:SS'), 203, 303)
SELECT * FROM dual;

BEGIN
   EXECUTE IMMEDIATE 'DROP VIEW ShowDetailsView';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE VIEW ShowDetailsView AS
SELECT 
  show.title,
  show.type,
  show.date_added,
  show.release_date,
  show.rating,
  show.duration,
  director.director_name,
  actor.actor_name,
  genre.show_type
FROM 
  show
  JOIN direct ON show.show_id = direct.show_show_id
  JOIN director ON direct.director_director_id = director.director_id
  JOIN act ON show.show_id = act.show_show_id
  JOIN actor ON act.actor_actor_id = actor.actor_id
  JOIN type ON show.show_id = type.show_show_id
  JOIN genre ON type.genre_genre_id = genre.genre_id;


BEGIN
   EXECUTE IMMEDIATE 'DROP VIEW UserTransactionsView';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE VIEW UserTransactionsView AS
SELECT 
  "user".USER_ID,
  "user".EMAIL,
  transaction.TRANSACTION_ID,
  transaction.TRANSACTION_TYPE,
  transaction.TRAN_TS,
  subscription.SUB_PLAN_ID,
  subscription.PLAN_NAME,
  subscription.PLAN_PRICE,
  show.TITLE AS show_title
FROM 
  "user"
  JOIN transaction ON "user".USER_ID = transaction.USER_USER_ID
  JOIN subscription ON transaction.SUBSCRIPTION_SUB_PLAN_ID = subscription.SUB_PLAN_ID
  JOIN show_prov ON subscription.PROVIDER_PROVIDER_ID = show_prov.PROVIDER_PROVIDER_ID
  JOIN show ON show_prov.SHOW_SHOW_ID = show.SHOW_ID;


BEGIN
   EXECUTE IMMEDIATE 'DROP VIEW SubscriptionDetailsView';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE VIEW SubscriptionDetailsView AS
SELECT 
  subscription.sub_plan_id,
  subscription.plan_name,
  subscription.plan_price,
  subscription.plan_duration,
  provider.provider_name,
  show_prov.show_show_id
FROM 
  subscription
  JOIN provider ON subscription.provider_provider_id = provider.provider_id
  JOIN show_prov ON provider.provider_id = show_prov.provider_provider_id;

BEGIN
   EXECUTE IMMEDIATE 'DROP VIEW ActorDirectorView';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE VIEW ActorDirectorView AS
SELECT
    actor.actor_id,
    actor.actor_name,
    show.title AS show_title,
    director.director_id,
    director.director_name
FROM
    actor
JOIN act ON actor.actor_id = act.actor_actor_id
JOIN show ON act.show_show_id = show.show_id
JOIN direct ON show.show_id = direct.show_show_id
JOIN director ON direct.director_director_id = director.director_id;
