--Function 1: check whether the table are exist or not;

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
    TYPE TStringArray IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
    v_tables TStringArray;
BEGIN
   
    v_tables(1) := 'ACT';
    v_tables(2) := 'ACTOR';
    v_tables(3) := 'CUSTOMER';
    v_tables(4) := 'DIRECT';
    v_tables(5) := 'DIRECTOR';
    v_tables(6) := 'GENRE';
    v_tables(7) := 'PROVIDER';
    v_tables(8) := 'SHOWS';
    v_tables(9) := 'SHOW_PROV';
    v_tables(10) := 'SUBSCRIPTIONU';
    v_tables(11) := 'TRANSACTIONU';
    v_tables(12) := 'TYPE';
    v_tables(13) := 'USER_ACTOR_RATINGS';
    v_tables(14) := 'USER_DIRECTOR_RATINGS';
    v_tables(15) := 'USER_GENRE_RATINGS';
    v_tables(16) := 'USER_PROVIDER_RATINGS';
    v_tables(17) := 'USER_SHOW_RATINGS';
    
      
    FOR i IN 1 .. v_tables.COUNT LOOP
        IF check_table_exists(v_tables(i)) != 0 THEN
            EXECUTE IMMEDIATE 'DROP TABLE ' || v_tables(i) || ' CASCADE CONSTRAINTS';
            
        END IF;
    END LOOP;
    
--Start create table
EXECUTE IMMEDIATE '
CREATE TABLE act (
    show_show_id   INTEGER NOT NULL,
    actor_actor_id INTEGER NOT NULL
)';

EXECUTE IMMEDIATE '
ALTER TABLE act ADD CONSTRAINT act_pk PRIMARY KEY ( show_show_id,
                                                    actor_actor_id )';

EXECUTE IMMEDIATE '
CREATE TABLE actor (
    actor_id   INTEGER NOT NULL,
    actor_name VARCHAR2(20 CHAR) NOT NULL
)';

EXECUTE IMMEDIATE '
ALTER TABLE actor ADD CONSTRAINT actor_pk PRIMARY KEY ( actor_id )';

EXECUTE IMMEDIATE '
CREATE TABLE customer (
    user_id        INTEGER NOT NULL,
    email          VARCHAR2(50 CHAR) NOT NULL,
    password       VARCHAR2(50 CHAR) NOT NULL,
    sub_status     VARCHAR2(50 CHAR) NOT NULL,
    sub_start_date DATE ,
    sub_end_date   DATE,
    country VARCHAR2(50),
    birthday DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN (''M'', ''F'', ''O'')) 
)';

EXECUTE IMMEDIATE '
ALTER TABLE customer ADD CONSTRAINT user_pk PRIMARY KEY ( user_id )';

EXECUTE IMMEDIATE '
CREATE TABLE direct (
    show_show_id         INTEGER NOT NULL,
    director_director_id INTEGER NOT NULL
)';

EXECUTE IMMEDIATE '
ALTER TABLE direct ADD CONSTRAINT direct_pk PRIMARY KEY ( show_show_id,
                                                          director_director_id )';

EXECUTE IMMEDIATE '
CREATE TABLE director (
    director_id   INTEGER NOT NULL,
    director_name VARCHAR2(20 CHAR) NOT NULL
)';

EXECUTE IMMEDIATE '
ALTER TABLE director ADD CONSTRAINT director_pk PRIMARY KEY ( director_id )';

EXECUTE IMMEDIATE '
CREATE TABLE genre (
    genre_id  INTEGER NOT NULL,
    show_type VARCHAR2(20) NOT NULL
)';

EXECUTE IMMEDIATE '
ALTER TABLE genre ADD CONSTRAINT genre_pk PRIMARY KEY ( genre_id )';

EXECUTE IMMEDIATE '
CREATE TABLE provider (
    provider_id   INTEGER NOT NULL,
    provider_name VARCHAR2(20 CHAR) NOT NULL
)';

EXECUTE IMMEDIATE '
ALTER TABLE provider ADD CONSTRAINT provider_pk PRIMARY KEY ( provider_id )';

EXECUTE IMMEDIATE '
CREATE TABLE show_prov (
    show_show_id         INTEGER NOT NULL,
    provider_provider_id INTEGER NOT NULL
)';

EXECUTE IMMEDIATE '
ALTER TABLE show_prov ADD CONSTRAINT show_prov_pk PRIMARY KEY ( show_show_id,
                                                                provider_provider_id )';

EXECUTE IMMEDIATE '
CREATE TABLE shows (
    show_id      INTEGER NOT NULL,
    type         VARCHAR2(50 CHAR) NOT NULL,
    title        VARCHAR2(100 BYTE) NOT NULL,
    date_added   DATE NOT NULL,
    release_date DATE NOT NULL,
    age_rating      VARCHAR2(20 CHAR),
    duration     VARCHAR2(20 CHAR) NOT NULL
)';

EXECUTE IMMEDIATE '
ALTER TABLE shows ADD CONSTRAINT show_pk PRIMARY KEY ( show_id )';

EXECUTE IMMEDIATE '
CREATE TABLE subscriptionu (
    sub_plan_id          INTEGER NOT NULL,
    plan_name            VARCHAR2(20 CHAR) NOT NULL,
    plan_price           INTEGER NOT NULL,
    months_duration        INTEGER NOT NULL,
    provider_provider_id INTEGER NOT NULL
)';

EXECUTE IMMEDIATE '
ALTER TABLE subscriptionu ADD CONSTRAINT subscription_pk PRIMARY KEY ( sub_plan_id )';

EXECUTE IMMEDIATE '
CREATE TABLE transactionu (
    transaction_id           INTEGER NOT NULL,
    transaction_type         VARCHAR2(20 CHAR) NOT NULL,
    tran_ts                  TIMESTAMP(2) WITH LOCAL TIME ZONE,
    subscription_sub_plan_id INTEGER,
    user_user_id             INTEGER
)';


EXECUTE IMMEDIATE '
ALTER TABLE transactionu ADD CONSTRAINT transaction_pk PRIMARY KEY ( transaction_id )';

EXECUTE IMMEDIATE '
CREATE TABLE type (
    genre_genre_id INTEGER NOT NULL,
    show_show_id   INTEGER NOT NULL
)';

EXECUTE IMMEDIATE '
ALTER TABLE type ADD CONSTRAINT type_pk PRIMARY KEY ( genre_genre_id,
                                                      show_show_id )';

EXECUTE IMMEDIATE '
ALTER TABLE act
    ADD CONSTRAINT act_actor_fk FOREIGN KEY ( actor_actor_id )
        REFERENCES actor ( actor_id )';

EXECUTE IMMEDIATE '
ALTER TABLE act
    ADD CONSTRAINT act_show_fk FOREIGN KEY ( show_show_id )
        REFERENCES shows ( show_id )';

EXECUTE IMMEDIATE '
ALTER TABLE direct
    ADD CONSTRAINT direct_director_fk FOREIGN KEY ( director_director_id )
        REFERENCES director ( director_id )';

EXECUTE IMMEDIATE '
ALTER TABLE direct
    ADD CONSTRAINT direct_show_fk FOREIGN KEY ( show_show_id )
        REFERENCES shows ( show_id )';

EXECUTE IMMEDIATE '
ALTER TABLE show_prov
    ADD CONSTRAINT show_prov_provider_fk FOREIGN KEY ( provider_provider_id )
        REFERENCES provider ( provider_id )';

EXECUTE IMMEDIATE '
ALTER TABLE show_prov
    ADD CONSTRAINT show_prov_show_fk FOREIGN KEY ( show_show_id )
        REFERENCES shows ( show_id )';

EXECUTE IMMEDIATE '
ALTER TABLE subscriptionu
    ADD CONSTRAINT subscription_provider_fk FOREIGN KEY ( provider_provider_id )
        REFERENCES provider ( provider_id )';

EXECUTE IMMEDIATE '
ALTER TABLE transactionu
    ADD CONSTRAINT transaction_subscription_fk FOREIGN KEY ( subscription_sub_plan_id )
        REFERENCES subscriptionu ( sub_plan_id )';

EXECUTE IMMEDIATE '
ALTER TABLE transactionu
    ADD CONSTRAINT transaction_user_fk FOREIGN KEY ( user_user_id )
        REFERENCES customer ( user_id )';

EXECUTE IMMEDIATE '
ALTER TABLE type
    ADD CONSTRAINT type_genre_fk FOREIGN KEY ( genre_genre_id )
        REFERENCES genre ( genre_id )';

EXECUTE IMMEDIATE '
ALTER TABLE type
    ADD CONSTRAINT type_show_fk FOREIGN KEY ( show_show_id )
        REFERENCES shows ( show_id )';

EXECUTE IMMEDIATE '
CREATE TABLE user_show_ratings (
    user_id        INTEGER NOT NULL,
    show_id        INTEGER NOT NULL,
    rating         INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    PRIMARY KEY (user_id, show_id)
)';

EXECUTE IMMEDIATE '
ALTER TABLE user_show_ratings
    ADD CONSTRAINT usr_user_fk FOREIGN KEY (user_id) REFERENCES customer(user_id) ON DELETE CASCADE';

EXECUTE IMMEDIATE '
ALTER TABLE user_show_ratings
    ADD CONSTRAINT usr_show_fk FOREIGN KEY (show_id) REFERENCES shows(show_id) ON DELETE CASCADE';

EXECUTE IMMEDIATE '
CREATE TABLE user_actor_ratings (
    user_id        INTEGER NOT NULL,
    actor_id       INTEGER NOT NULL,
    rating         INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    PRIMARY KEY (user_id, actor_id)
)';

EXECUTE IMMEDIATE '
ALTER TABLE user_actor_ratings
    ADD CONSTRAINT uar_user_fk FOREIGN KEY (user_id) REFERENCES customer(user_id) ON DELETE CASCADE';

EXECUTE IMMEDIATE '
ALTER TABLE user_actor_ratings
    ADD CONSTRAINT uar_actor_fk FOREIGN KEY (actor_id) REFERENCES actor(actor_id) ON DELETE CASCADE';

EXECUTE IMMEDIATE '
CREATE TABLE user_director_ratings (
    user_id        INTEGER NOT NULL,
    director_id    INTEGER NOT NULL,
    rating         INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    PRIMARY KEY (user_id, director_id)
)';

EXECUTE IMMEDIATE '
ALTER TABLE user_director_ratings
    ADD CONSTRAINT udr_user_fk FOREIGN KEY (user_id) REFERENCES customer(user_id) ON DELETE CASCADE';

EXECUTE IMMEDIATE '
ALTER TABLE user_director_ratings
    ADD CONSTRAINT udr_director_fk FOREIGN KEY (director_id) REFERENCES director(director_id) ON DELETE CASCADE';

EXECUTE IMMEDIATE '
CREATE TABLE user_genre_ratings (
    user_id        INTEGER NOT NULL,
    genre_id       INTEGER NOT NULL,
    rating         INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    PRIMARY KEY (user_id, genre_id)
)';

EXECUTE IMMEDIATE '
ALTER TABLE user_genre_ratings
    ADD CONSTRAINT ugr_user_fk FOREIGN KEY (user_id) REFERENCES customer(user_id) ON DELETE CASCADE';

EXECUTE IMMEDIATE '
ALTER TABLE user_genre_ratings
    ADD CONSTRAINT ugr_genre_fk FOREIGN KEY (genre_id) REFERENCES genre(genre_id) ON DELETE CASCADE';

EXECUTE IMMEDIATE '
CREATE TABLE user_provider_ratings (
    user_id        INTEGER NOT NULL,
    provider_id    INTEGER NOT NULL,
    rating         INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    PRIMARY KEY (user_id, provider_id)
)';

EXECUTE IMMEDIATE '
ALTER TABLE user_provider_ratings
    ADD CONSTRAINT upr_user_fk FOREIGN KEY (user_id) REFERENCES customer(user_id) ON DELETE CASCADE';

EXECUTE IMMEDIATE '
ALTER TABLE user_provider_ratings
    ADD CONSTRAINT upr_provider_fk FOREIGN KEY (provider_id) REFERENCES provider(provider_id) ON DELETE CASCADE';  
END;
/
--The end of the process for creating tables;

--Start of the package;
BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE show_id_seq';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE = -2289 THEN
         NULL;
      ELSE
         RAISE;
      END IF;
END;
/
CREATE SEQUENCE show_id_seq
  START WITH 107
  INCREMENT BY 1
  NOMAXVALUE;


-- Package;
CREATE OR REPLACE PACKAGE show_management_pkg IS
  PROCEDURE recreate_sequence;
  PROCEDURE insert_new_show(
    p_title        VARCHAR2,
    p_date_added   DATE,
    p_release_date DATE,
    p_age_rating       VARCHAR2,
    p_duration     VARCHAR2,
    p_type         VARCHAR2,
    p_genre_name    VARCHAR2,
    p_actor_name    VARCHAR2,
    p_director_name VARCHAR2
  );
END show_management_pkg;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE genre_seq';
   EXECUTE IMMEDIATE 'DROP SEQUENCE actor_seq';
   EXECUTE IMMEDIATE 'DROP SEQUENCE director_seq';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE = -2289 THEN
         NULL;
      ELSE
         RAISE;
      END IF;
END;
/
CREATE SEQUENCE genre_seq
  START WITH 7
  INCREMENT BY 1
  NOMAXVALUE;

CREATE SEQUENCE actor_seq
  START WITH 7
  INCREMENT BY 1
  NOMAXVALUE;

CREATE SEQUENCE director_seq
  START WITH 13
  INCREMENT BY 1
  NOMAXVALUE;


--Package body;
CREATE OR REPLACE PACKAGE BODY show_management_pkg IS

  PROCEDURE recreate_sequence AS
    v_exists NUMBER;
  BEGIN

    SELECT COUNT(*)
    INTO v_exists
    FROM user_sequences
    WHERE sequence_name = 'SHOW_ID_SEQ'; 

    IF v_exists > 0 THEN
      EXECUTE IMMEDIATE 'DROP SEQUENCE show_id_seq';
    END IF;


    DECLARE
      v_max_id NUMBER;
    BEGIN
      SELECT COALESCE(MAX(show_id), 0) INTO v_max_id FROM shows;
      EXECUTE IMMEDIATE 'CREATE SEQUENCE show_id_seq START WITH ' || TO_CHAR(v_max_id + 1) || ' INCREMENT BY 1';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE show_id_seq START WITH 1 INCREMENT BY 1';
    END;

  END recreate_sequence;


   PROCEDURE insert_new_show(
      p_title        VARCHAR2,
      p_date_added   DATE,
      p_release_date DATE,
      p_age_rating   VARCHAR2,
      p_duration     VARCHAR2,
      p_type         VARCHAR2,
      p_genre_name   VARCHAR2,  
      p_actor_name   VARCHAR2,  
      p_director_name VARCHAR2  
  ) AS
      v_show_id NUMBER;
      v_genre_id NUMBER;
      v_actor_id NUMBER;
      v_director_id NUMBER;
  BEGIN
     
      SELECT show_id_seq.NEXTVAL INTO v_show_id FROM DUAL;
      INSERT INTO shows (show_id, title, date_added, release_date, age_rating, duration, type)
      VALUES (v_show_id, p_title, p_date_added, p_release_date, p_age_rating, p_duration, p_type);
      
      BEGIN
          SELECT genre_id INTO v_genre_id FROM genre WHERE show_type = p_genre_name;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              INSERT INTO genre (genre_id, show_type) VALUES (genre_seq.NEXTVAL, p_genre_name) RETURNING genre_id INTO v_genre_id;
      END;
      INSERT INTO type (genre_genre_id, show_show_id) VALUES (v_genre_id, v_show_id);

      BEGIN
          SELECT actor_id INTO v_actor_id FROM actor WHERE actor_name = p_actor_name;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              INSERT INTO actor (actor_id, actor_name) VALUES (actor_seq.NEXTVAL, p_actor_name) RETURNING actor_id INTO v_actor_id;
      END;
      INSERT INTO act (actor_actor_id, show_show_id) VALUES (v_actor_id, v_show_id);

      
      BEGIN
          SELECT director_id INTO v_director_id FROM director WHERE director_name = p_director_name;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              INSERT INTO director (director_id, director_name) VALUES (director_seq.NEXTVAL, p_director_name) RETURNING director_id INTO v_director_id;
      END;
      INSERT INTO direct (director_director_id, show_show_id) VALUES (v_director_id, v_show_id);

      COMMIT;
  END insert_new_show;

END show_management_pkg;
/




--Procedure start;
BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE transactionu_seq';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE = -2289 THEN
         NULL;
      ELSE
         RAISE;
      END IF;
END;
/
CREATE SEQUENCE transactionu_seq
START WITH 431
INCREMENT BY 1
NOMAXVALUE;

CREATE OR REPLACE PROCEDURE handle_subscription_action (
    p_user_id IN customer.user_id%TYPE,
    p_action IN VARCHAR2,
    p_sub_plan_id IN subscriptionu.sub_plan_id%TYPE DEFAULT NULL
) AS
    v_months_duration NUMBER;
    v_new_end_date DATE;
BEGIN
    IF p_action = 'renew' AND p_sub_plan_id IS NOT NULL THEN

        SELECT months_duration INTO v_months_duration
        FROM subscriptionu
        WHERE sub_plan_id = p_sub_plan_id;
        

        SELECT ADD_MONTHS(SYSDATE, v_months_duration) INTO v_new_end_date
        FROM dual;
        

        UPDATE customer
        SET sub_status = 'Subscribe',
            sub_start_date = SYSDATE,
            sub_end_date = v_new_end_date
        WHERE user_id = p_user_id;
        
        INSERT INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id)
        VALUES (transactionu_seq.NEXTVAL, 'subscription', SYSDATE, p_sub_plan_id, p_user_id);
        
    ELSIF p_action = 'cancel' THEN

        UPDATE customer
        SET sub_status = 'Unsubscribe',
            sub_end_date = SYSDATE
        WHERE user_id = p_user_id;
        
        INSERT INTO transactionu (transaction_id, transaction_type, tran_ts, user_user_id)
        VALUES (transactionu_seq.NEXTVAL, 'unsubscribe', SYSDATE, p_user_id);
        
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Invalid action specified.');
    END IF;
    
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Subscription plan not found.');
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE update_customer_profile (
    p_user_id IN customer.user_id%TYPE,
    p_email IN customer.email%TYPE,
    p_password IN customer.password%TYPE,
    p_country IN customer.country%TYPE,
    p_birthday IN customer.birthday%TYPE,
    p_gender IN customer.gender%TYPE
) AS
    v_current_email customer.email%TYPE;
    v_current_password customer.password%TYPE;
BEGIN
    IF p_user_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20003, 'Invalid user ID.');
    END IF;
    
    IF p_email IS NULL THEN
        RAISE_APPLICATION_ERROR(-20004, 'Email cannot be NULL.');
    ELSIF p_password IS NULL THEN
        RAISE_APPLICATION_ERROR(-20005, 'Password cannot be NULL.');
    ELSIF p_country IS NULL THEN
        RAISE_APPLICATION_ERROR(-20006, 'Country cannot be NULL.');
    ELSIF p_birthday IS NULL THEN
        RAISE_APPLICATION_ERROR(-20007, 'Birthday cannot be NULL.');
    ELSIF p_gender IS NULL THEN
        RAISE_APPLICATION_ERROR(-20008, 'Gender cannot be NULL.');
    END IF;
    
    SELECT email, password INTO v_current_email, v_current_password FROM customer WHERE user_id = p_user_id;
    IF v_current_email = p_email AND v_current_password = p_password THEN
        RAISE_APPLICATION_ERROR(-20009, 'Cannot update. Email and password are the same as existing records.');
    END IF;

    UPDATE customer
    SET
        email = p_email,
        password = p_password, 
        country = p_country,
        birthday = p_birthday,
        gender = p_gender
    WHERE user_id = p_user_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No update occurred. User may not exist.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20010, 'User ID does not exist.');
    WHEN OTHERS THEN
        RAISE;
END update_customer_profile;
/



CREATE OR REPLACE PROCEDURE EnsureNotNull(param IN VARCHAR2, paramName IN VARCHAR2) IS
BEGIN
  IF param IS NULL THEN
    RAISE_APPLICATION_ERROR(-20010, paramName || ' must not be null.');
  END IF;
END EnsureNotNull;
/


CREATE OR REPLACE PROCEDURE EnsureRatingRange(p_rating IN NUMBER) IS
BEGIN
  IF p_rating < 1 OR p_rating > 5 THEN
    RAISE_APPLICATION_ERROR(-20004, 'Rating must be between 1 and 5.');
  END IF;
END EnsureRatingRange;
/


CREATE OR REPLACE PROCEDURE InsertActorRating(p_email IN VARCHAR2, p_actor_name IN VARCHAR2, p_rating IN NUMBER) IS
  v_user_id CUSTOMER.USER_ID%TYPE;
  v_actor_id ACTOR.ACTOR_ID%TYPE;
  v_rating_count NUMBER;
BEGIN
  EnsureNotNull(p_email, 'Email');
  EnsureNotNull(p_actor_name, 'Actor Name');
  EnsureRatingRange(p_rating);

  SELECT USER_ID INTO v_user_id FROM CUSTOMER WHERE EMAIL = p_email;
  SELECT ACTOR_ID INTO v_actor_id FROM ACTOR WHERE ACTOR_NAME = p_actor_name;

  SELECT COUNT(*) INTO v_rating_count FROM USER_ACTOR_RATINGS 
  WHERE USER_ID = v_user_id AND ACTOR_ID = v_actor_id;

  IF v_rating_count = 0 THEN
    INSERT INTO USER_ACTOR_RATINGS (USER_ID, ACTOR_ID, RATING) 
    VALUES (v_user_id, v_actor_id, p_rating);
  ELSE
    UPDATE USER_ACTOR_RATINGS 
    SET RATING = p_rating 
    WHERE USER_ID = v_user_id AND ACTOR_ID = v_actor_id;
  END IF;

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'User or actor not found.');
  WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20002, 'Duplicate rating found.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20003, 'An unexpected error occurred: ' || SQLERRM);
END InsertActorRating;
/


CREATE OR REPLACE PROCEDURE InsertDirectorRating(p_email IN VARCHAR2, p_director_name IN VARCHAR2, p_rating IN NUMBER) IS
  v_user_id CUSTOMER.USER_ID%TYPE;
  v_director_id DIRECTOR.DIRECTOR_ID%TYPE;
  v_rating_count NUMBER;
BEGIN
  EnsureNotNull(p_email, 'Email');
  EnsureNotNull(p_director_name, 'Director Name');
  EnsureRatingRange(p_rating);

  SELECT USER_ID INTO v_user_id FROM CUSTOMER WHERE EMAIL = p_email;
  SELECT DIRECTOR_ID INTO v_director_id FROM DIRECTOR WHERE DIRECTOR_NAME = p_director_name;

  SELECT COUNT(*) INTO v_rating_count FROM USER_DIRECTOR_RATINGS 
  WHERE USER_ID = v_user_id AND DIRECTOR_ID = v_director_id;

  IF v_rating_count = 0 THEN
    INSERT INTO USER_DIRECTOR_RATINGS (USER_ID, DIRECTOR_ID, RATING) 
    VALUES (v_user_id, v_director_id, p_rating);
  ELSE
    UPDATE USER_DIRECTOR_RATINGS 
    SET RATING = p_rating 
    WHERE USER_ID = v_user_id AND DIRECTOR_ID = v_director_id;
  END IF;

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'User or director not found.');
  WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20002, 'Duplicate rating found.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20003, 'An unexpected error occurred: ' || SQLERRM);
END InsertDirectorRating;
/


CREATE OR REPLACE PROCEDURE InsertGenreRating(p_email IN VARCHAR2, p_show_type IN VARCHAR2, p_rating IN NUMBER) IS
  v_user_id CUSTOMER.USER_ID%TYPE;
  v_genre_id GENRE.GENRE_ID%TYPE;
  v_rating_count NUMBER;
BEGIN
  EnsureNotNull(p_email, 'Email');
  EnsureNotNull(p_show_type, 'Show Type');
  EnsureRatingRange(p_rating);

  SELECT USER_ID INTO v_user_id FROM CUSTOMER WHERE EMAIL = p_email;
  SELECT GENRE_ID INTO v_genre_id FROM GENRE WHERE SHOW_TYPE = p_show_type;

  SELECT COUNT(*) INTO v_rating_count FROM USER_GENRE_RATINGS 
  WHERE USER_ID = v_user_id AND GENRE_ID = v_genre_id;

  IF v_rating_count = 0 THEN
    INSERT INTO USER_GENRE_RATINGS (USER_ID, GENRE_ID, RATING) 
    VALUES (v_user_id, v_genre_id, p_rating);
  ELSE
    UPDATE USER_GENRE_RATINGS 
    SET RATING = p_rating 
    WHERE USER_ID = v_user_id AND GENRE_ID = v_genre_id;
  END IF;

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'User or genre not found.');
  WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20002, 'Duplicate rating found.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20003, 'An unexpected error occurred: ' || SQLERRM);
END InsertGenreRating;
/




CREATE OR REPLACE PROCEDURE InsertProviderRating(p_email IN VARCHAR2, p_provider_name IN VARCHAR2, p_rating IN NUMBER) IS
  v_user_id CUSTOMER.USER_ID%TYPE;
  v_provider_id PROVIDER.PROVIDER_ID%TYPE;
  v_rating_count NUMBER;
BEGIN
 EnsureNotNull(p_email, 'Email');
  EnsureNotNull(p_provider_name, 'Provider Name');
  EnsureRatingRange(p_rating);

  SELECT USER_ID INTO v_user_id FROM CUSTOMER WHERE EMAIL = p_email;
  SELECT PROVIDER_ID INTO v_provider_id FROM PROVIDER WHERE PROVIDER_NAME = p_provider_name;

  SELECT COUNT(*) INTO v_rating_count FROM USER_PROVIDER_RATINGS 
  WHERE USER_ID = v_user_id AND PROVIDER_ID = v_provider_id;

  IF v_rating_count = 0 THEN
    INSERT INTO USER_PROVIDER_RATINGS (USER_ID, PROVIDER_ID, RATING) 
    VALUES (v_user_id, v_provider_id, p_rating);
  ELSE
    UPDATE USER_PROVIDER_RATINGS 
    SET RATING = p_rating 
    WHERE USER_ID = v_user_id AND PROVIDER_ID = v_provider_id;
  END IF;

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'User or provider not found.');
  WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20002, 'Duplicate rating found.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20003, 'An unexpected error occurred: ' || SQLERRM);
END InsertProviderRating;
/


CREATE OR REPLACE PROCEDURE InsertShowRating(p_email IN VARCHAR2, p_title IN VARCHAR2, p_rating IN NUMBER) IS
  v_user_id CUSTOMER.USER_ID%TYPE;
  v_show_id SHOWS.SHOW_ID%TYPE;
  v_rating_count NUMBER;
BEGIN
  EnsureNotNull(p_email, 'Email');
  EnsureNotNull(p_title, 'Title');
  EnsureRatingRange(p_rating);

  SELECT USER_ID INTO v_user_id FROM CUSTOMER WHERE EMAIL = p_email;
  SELECT SHOW_ID INTO v_show_id FROM SHOWS WHERE TITLE = p_title;

  SELECT COUNT(*) INTO v_rating_count FROM USER_SHOW_RATINGS 
  WHERE USER_ID = v_user_id AND SHOW_ID = v_show_id;

  IF v_rating_count = 0 THEN
    INSERT INTO USER_SHOW_RATINGS (USER_ID, SHOW_ID, RATING) 
    VALUES (v_user_id, v_show_id, p_rating);
  ELSE
    UPDATE USER_SHOW_RATINGS 
    SET RATING = p_rating 
    WHERE USER_ID = v_user_id AND SHOW_ID = v_show_id;
  END IF;

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'User or show not found.');
  WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20002, 'Duplicate rating found.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20003, 'An unexpected error occurred: ' || SQLERRM);
END InsertShowRating;
/



CREATE OR REPLACE PROCEDURE PurchaseSubscriptionPlan (
    p_email          VARCHAR2,
    p_provider_name  VARCHAR2,
    p_plan_name      VARCHAR2
) AS
    v_user_id        customer.user_id%TYPE;
    v_sub_plan_id    subscriptionu.sub_plan_id%TYPE;
    v_provider_id    provider.provider_id%TYPE;
    v_tran_ts        TIMESTAMP := SYSTIMESTAMP; 
BEGIN
    SELECT user_id INTO v_user_id FROM customer WHERE email = p_email;

    SELECT provider_id INTO v_provider_id FROM provider WHERE provider_name = p_provider_name;
    
    SELECT sub_plan_id INTO v_sub_plan_id FROM subscriptionu WHERE plan_name = p_plan_name AND provider_provider_id = v_provider_id;
    
    INSERT INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id)
    VALUES (transactionu_seq.NEXTVAL, 'subscription', v_tran_ts, v_sub_plan_id, v_user_id);
    
    UPDATE customer
    SET sub_status = 'Subscribe',
        sub_start_date = v_tran_ts
    WHERE user_id = v_user_id;
    
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'User, provider, or subscription plan not found.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'An unexpected error occurred: ' || SQLERRM);
END PurchaseSubscriptionPlan;
/


BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE customer_user_id_seq';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE = -2289 THEN
         NULL;
      ELSE
         RAISE;
      END IF;
END;
/

CREATE SEQUENCE customer_user_id_seq
  START WITH 301
  INCREMENT BY 1
  NOMAXVALUE;


CREATE OR REPLACE PROCEDURE insert_new_customer(
    p_email          VARCHAR2,
    p_password       VARCHAR2,
    p_country        VARCHAR2,
    p_birthday       DATE,
    p_gender         CHAR
) AS
    v_email_count NUMBER;
    v_user_id customer.user_id%TYPE;
BEGIN
    SELECT COUNT(*)
    INTO v_email_count
    FROM customer
    WHERE email = p_email;

    IF v_email_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Email address already exists.');
    END IF;
    
    SELECT customer_user_id_seq.NEXTVAL INTO v_user_id FROM DUAL;

    INSERT INTO customer (
        user_id,
        email,
        password,
        sub_status,
        sub_start_date,
        sub_end_date,
        country,
        birthday,
        gender
    ) VALUES (
        v_user_id,
        p_email,
        p_password, 
        'Unsubscribe', 
        NULL,
        NULL,
        p_country,
        p_birthday,
        p_gender
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20001 THEN
            RAISE;
        ELSE
            NULL; 
        END IF;
END;
/

--End of procedure

--Function 2 ;
CREATE OR REPLACE FUNCTION get_popular_shows(p_min_rating NUMBER) RETURN SYS_REFCURSOR AS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
    SELECT s.show_id, s.title, AVG(r.rating) AS avg_rating
    FROM shows s
    JOIN user_show_ratings r ON s.show_id = r.show_id
    GROUP BY s.show_id, s.title
    HAVING AVG(r.rating) >= p_min_rating
    ORDER BY avg_rating DESC;
    
    RETURN v_cursor;
END;
/

--Trigger
CREATE OR REPLACE TRIGGER trg_update_sub_start_date
AFTER INSERT OR UPDATE OF TRAN_TS ON TRANSACTIONU
FOR EACH ROW
BEGIN
    UPDATE CUSTOMER
    SET SUB_START_DATE = :NEW.TRAN_TS
    WHERE USER_ID = :NEW.USER_USER_ID;
END;
/

CREATE OR REPLACE TRIGGER trg_update_sub_status_expiry
BEFORE UPDATE OF sub_end_date ON customer
FOR EACH ROW
BEGIN
    IF :NEW.sub_end_date IS NOT NULL AND :NEW.sub_end_date <= SYSDATE THEN
        :NEW.sub_status := 'Expired';
    ELSIF :NEW.sub_end_date IS NULL THEN
        :NEW.sub_status := 'Unsubscribe';
    ELSE
        :NEW.sub_status := 'Subscribe';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_auto_fill_sub_end_date
AFTER INSERT ON transactionu
FOR EACH ROW
DECLARE
    v_months_duration NUMBER;
BEGIN

    IF :NEW.subscription_sub_plan_id IS NOT NULL THEN
        SELECT months_duration INTO v_months_duration
        FROM subscriptionu
        WHERE sub_plan_id = :NEW.subscription_sub_plan_id;
        
        UPDATE customer
        SET sub_start_date = :NEW.tran_ts,
            sub_end_date = ADD_MONTHS(:NEW.tran_ts, v_months_duration)
        WHERE user_id = :NEW.user_user_id;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No matching subscription plan found for ID: ' || :NEW.subscription_sub_plan_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/


--Start insert data into tables;
INSERT ALL
INTO shows (show_id, type, title, date_added, release_date, age_rating, duration) VALUES (101, 'TV Show', 'Breaking Bad', TO_DATE('2023-07-11', 'YYYY-MM-DD'), TO_DATE('2008-01-20', 'YYYY-MM-DD'), 'TV-MA', '5 seasons')
INTO shows (show_id, type, title, date_added, release_date, age_rating, duration) VALUES (102, 'TV Show', 'Better Call Saul', TO_DATE('2022-03-05', 'YYYY-MM-DD'), TO_DATE('2015-02-08', 'YYYY-MM-DD'), 'TV-MA', '6 seasons')
INTO shows (show_id, type, title, date_added, release_date, age_rating, duration) VALUES (103, 'Movie', 'Lucy', TO_DATE('2022-11-16', 'YYYY-MM-DD'), TO_DATE('2014-07-25', 'YYYY-MM-DD'), 'R', '89 minutes')
INTO shows (show_id, type, title, date_added, release_date, age_rating, duration) VALUES (104, 'TV Show', 'Arcane: League of Legends', TO_DATE('2023-12-22', 'YYYY-MM-DD'), TO_DATE('2021-11-06', 'YYYY-MM-DD'), 'TV-14', '1 season')
INTO shows (show_id, type, title, date_added, release_date, age_rating, duration) VALUES (105, 'TV Show', 'The Walking Dead', TO_DATE('2024-01-19', 'YYYY-MM-DD'), TO_DATE('2010-10-31', 'YYYY-MM-DD'), 'TV-MA', '11 seasons')
INTO shows (show_id, type, title, date_added, release_date, age_rating, duration) VALUES (106, 'Movie', 'Spider-Man: Across the Spider-Verse', TO_DATE('2023-05-27', 'YYYY-MM-DD'), TO_DATE('2022-10-07', 'YYYY-MM-DD'), 'PG', '120 minutes')
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
    INTO provider (provider_id, provider_name) VALUES (1, 'Netflix')
    INTO provider (provider_id, provider_name) VALUES (2, 'HuluTV')
SELECT * FROM dual;

INSERT ALL
    INTO show_prov (show_show_id, provider_provider_id) VALUES (101,1)
    INTO show_prov (show_show_id, provider_provider_id) VALUES (102,2)
    INTO show_prov (show_show_id, provider_provider_id) VALUES (103,2)
    INTO show_prov (show_show_id, provider_provider_id) VALUES (104,1)
    INTO show_prov (show_show_id, provider_provider_id) VALUES (105,2)
    INTO show_prov (show_show_id, provider_provider_id) VALUES (106,1)
SELECT * FROM dual;

INSERT ALL
    INTO subscriptionu (sub_plan_id, plan_name, plan_price, months_duration, provider_provider_id)
        VALUES (201, 'Basic Plan', 9, 3, 1)
    INTO subscriptionu (sub_plan_id, plan_name, plan_price, months_duration, provider_provider_id)
        VALUES (202, 'Prime Plan', 17, 6, 1)
    INTO subscriptionu (sub_plan_id, plan_name, plan_price, months_duration, provider_provider_id)
        VALUES (203, 'Prime Plan Plus', 25, 9, 1)
    INTO subscriptionu (sub_plan_id, plan_name, plan_price, months_duration, provider_provider_id)
        VALUES (204, 'Basic Plan', 9, 3, 2)
    INTO subscriptionu (sub_plan_id, plan_name, plan_price, months_duration, provider_provider_id)
        VALUES (205, 'Prime Plan', 17, 6, 2)
    INTO subscriptionu (sub_plan_id, plan_name, plan_price, months_duration, provider_provider_id)
        VALUES (206, 'Prime Plan Plus', 25, 9, 2)
SELECT * FROM dual;


BEGIN
  insert_new_customer('user1@example.com', 'password123', 'Spain', TO_DATE('2013-06-14', 'YYYY-MM-DD'), 'F');
  insert_new_customer('user2@example.com', 'password123', 'Germany', TO_DATE('27-08-2012', 'DD-MM-YYYY'), 'F');
  insert_new_customer('user3@example.com', 'password123', 'India', TO_DATE('28-03-1990', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user4@example.com', 'password123', 'China', TO_DATE('31-05-2001', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user5@example.com', 'password123', 'Australia', TO_DATE('30-03-2022', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user6@example.com', 'password123', 'France', TO_DATE('19-08-2012', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user7@example.com', 'password123', 'Spain', TO_DATE('10-02-2006', 'DD-MM-YYYY'), 'F');
  insert_new_customer('user8@example.com', 'password123', 'China', TO_DATE('18-09-2003', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user9@example.com', 'password123', 'UK', TO_DATE('04-02-2008', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user10@example.com', 'password123', 'Spain', TO_DATE('27-01-1969', 'DD-MM-YYYY'), 'F');
  insert_new_customer('user11@example.com', 'password123', 'Germany', TO_DATE('23-09-1945', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user12@example.com', 'password123', 'Italy', TO_DATE('13-08-2010', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user13@example.com', 'password123', 'Canada', TO_DATE('09-12-1999', 'DD-MM-YYYY'), 'F');
  insert_new_customer('user14@example.com', 'password123', 'Canada', TO_DATE('27-09-1939', 'DD-MM-YYYY'), 'F');
  insert_new_customer('user15@example.com', 'password123', 'Spain', TO_DATE('11-02-1959', 'DD-MM-YYYY'), 'F');
  insert_new_customer('user16@example.com', 'password123', 'UK', TO_DATE('20-05-1975', 'DD-MM-YYYY'), 'F');
  insert_new_customer('user17@example.com', 'password123', 'Canada', TO_DATE('26-09-1973', 'DD-MM-YYYY'), 'F');
  insert_new_customer('user18@example.com', 'password123', 'Germany', TO_DATE('05-11-1997', 'DD-MM-YYYY'), 'F');
  insert_new_customer('user19@example.com', 'password123', 'USA', TO_DATE('21-07-2001', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user20@example.com', 'password123', 'Spain', TO_DATE('21-04-1999', 'DD-MM-YYYY'), 'F');
  insert_new_customer('user21@example.com', 'password123', 'UK', TO_DATE('05-02-1941', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user22@example.com', 'password123', 'USA', TO_DATE('21-02-1973', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user23@example.com', 'password123', 'Australia', TO_DATE('05-06-2002', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user24@example.com', 'password123', 'India', TO_DATE('12-09-1990', 'DD-MM-YYYY'), 'F');
  insert_new_customer('user25@example.com', 'password123', 'Australia', TO_DATE('25-03-2006', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user26@example.com', 'password123', 'Italy', TO_DATE('29-03-2005', 'DD-MM-YYYY'), 'F');  
  insert_new_customer('user27@example.com', 'password123', 'Spain', TO_DATE('18-05-1952', 'DD-MM-YYYY'), 'M');
  insert_new_customer('user28@example.com', 'password123', 'USA', TO_DATE('06-08-1958', 'DD-MM-YYYY'), 'F');
  insert_new_customer('user29@example.com', 'password123', 'Spain', TO_DATE('21-10-1963', 'DD-MM-YYYY'), 'F');
  insert_new_customer('user30@example.com', 'password123', 'Canada', TO_DATE('23-05-1955', 'DD-MM-YYYY'), 'F');
  
END;
/


--UPDATE customer SET
--    sub_status = CASE
--        WHEN sub_end_date IS NOT NULL AND sub_end_date < SYSDATE THEN 'Expired'
--        WHEN sub_end_date IS NULL THEN 'Unsubscribe'
--        ELSE 'Subscribe'
--    END;



INSERT ALL
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (401, 'unsubscribe', NULL, NULL, 301)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (402, 'unsubscribe', NULL, NULL, 302)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (403, 'unsubscribe', NULL, NULL, 303)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (404, 'unsubscribe', NULL, NULL, 304)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (405, 'unsubscribe', NULL, NULL, 305)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (406, 'unsubscribe', NULL, NULL, 306)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (407, 'unsubscribe', NULL, NULL, 307)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (408, 'unsubscribe', NULL, NULL, 308)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (409, 'unsubscribe', NULL, NULL, 309)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (410, 'unsubscribe', NULL, NULL, 310)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (411, 'subscription', TO_TIMESTAMP('2021-12-22 04:13:27', 'YYYY-MM-DD HH24:MI:SS'), 202, 311)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (412, 'subscription', TO_TIMESTAMP('2021-03-27 18:49:37', 'YYYY-MM-DD HH24:MI:SS'), 203, 312)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (413, 'subscription', TO_TIMESTAMP('2021-03-24 07:14:05', 'YYYY-MM-DD HH24:MI:SS'), 206, 313)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (414, 'subscription', TO_TIMESTAMP('2021-06-05 20:17:09', 'YYYY-MM-DD HH24:MI:SS'), 204, 314)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (415, 'subscription', TO_TIMESTAMP('2021-01-08 03:25:11', 'YYYY-MM-DD HH24:MI:SS'), 205, 315)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (416, 'subscription', TO_TIMESTAMP('2022-05-16 00:21:41', 'YYYY-MM-DD HH24:MI:SS'), 203, 316)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (417, 'subscription', TO_TIMESTAMP('2022-03-18 21:35:27', 'YYYY-MM-DD HH24:MI:SS'), 201, 317)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (418, 'subscription', TO_TIMESTAMP('2022-03-07 12:22:37', 'YYYY-MM-DD HH24:MI:SS'), 205, 318)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (419, 'subscription', TO_TIMESTAMP('2022-02-13 16:56:09', 'YYYY-MM-DD HH24:MI:SS'), 204, 319)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (420, 'subscription', TO_TIMESTAMP('2022-03-09 10:07:25', 'YYYY-MM-DD HH24:MI:SS'), 203, 320)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (421, 'subscription', TO_TIMESTAMP('2023-12-17 23:33:20', 'YYYY-MM-DD HH24:MI:SS'), 203, 321)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (422, 'subscription', TO_TIMESTAMP('2023-11-07 01:19:26', 'YYYY-MM-DD HH24:MI:SS'), 202, 322)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (423, 'subscription', TO_TIMESTAMP('2023-03-21 06:40:27', 'YYYY-MM-DD HH24:MI:SS'), 205, 323)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (424, 'subscription', TO_TIMESTAMP('2023-03-27 04:26:46', 'YYYY-MM-DD HH24:MI:SS'), 205, 324)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (425, 'subscription', TO_TIMESTAMP('2023-03-26 14:06:01', 'YYYY-MM-DD HH24:MI:SS'), 204, 325)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (426, 'subscription', TO_TIMESTAMP('2024-03-10 05:39:05', 'YYYY-MM-DD HH24:MI:SS'), 201, 326)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (427, 'subscription', TO_TIMESTAMP('2024-03-16 18:47:28', 'YYYY-MM-DD HH24:MI:SS'), 203, 327)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (428, 'subscription', TO_TIMESTAMP('2024-02-19 20:57:32', 'YYYY-MM-DD HH24:MI:SS'), 205, 328)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (429, 'subscription', TO_TIMESTAMP('2024-01-27 00:46:09', 'YYYY-MM-DD HH24:MI:SS'), 205, 329)
    INTO transactionu (transaction_id, transaction_type, tran_ts, subscription_sub_plan_id, user_user_id) VALUES (430, 'subscription', TO_TIMESTAMP('2024-03-16 19:53:43', 'YYYY-MM-DD HH24:MI:SS'), 204, 330)
SELECT * FROM dual;


INSERT ALL
    INTO user_director_ratings (user_id, director_id, rating) VALUES (311, 8, 3)
    INTO user_director_ratings (user_id, director_id, rating) VALUES (318, 10, 5)
    INTO user_director_ratings (user_id, director_id, rating) VALUES (324, 9, 2)
    INTO user_director_ratings (user_id, director_id, rating) VALUES (328, 7, 5)
    INTO user_director_ratings (user_id, director_id, rating) VALUES (303, 12, 1)
    INTO user_director_ratings (user_id, director_id, rating) VALUES (302, 10, 2)
    INTO user_director_ratings (user_id, director_id, rating) VALUES (317, 11, 5)
    INTO user_director_ratings (user_id, director_id, rating) VALUES (315, 12, 4)
    INTO user_director_ratings (user_id, director_id, rating) VALUES (327, 12, 3)
    INTO user_director_ratings (user_id, director_id, rating) VALUES (303, 11, 4)
SELECT * FROM dual;

INSERT ALL
    INTO user_genre_ratings (user_id, genre_id, rating) VALUES (330, 1, 2)
    INTO user_genre_ratings (user_id, genre_id, rating) VALUES (310, 3, 4)
    INTO user_genre_ratings (user_id, genre_id, rating) VALUES (316, 6, 5)
    INTO user_genre_ratings (user_id, genre_id, rating) VALUES (316, 3, 2)
    INTO user_genre_ratings (user_id, genre_id, rating) VALUES (329, 1, 1)
    INTO user_genre_ratings (user_id, genre_id, rating) VALUES (310, 2, 2)
    INTO user_genre_ratings (user_id, genre_id, rating) VALUES (301, 2, 1)
    INTO user_genre_ratings (user_id, genre_id, rating) VALUES (329, 4, 5)
    INTO user_genre_ratings (user_id, genre_id, rating) VALUES (301, 3, 2)
    INTO user_genre_ratings (user_id, genre_id, rating) VALUES (323, 2, 4)
SELECT * FROM dual;

INSERT ALL
    INTO user_provider_ratings (user_id, provider_id, rating) VALUES (316, 1, 4)
    INTO user_provider_ratings (user_id, provider_id, rating) VALUES (329, 1, 4)
    INTO user_provider_ratings (user_id, provider_id, rating) VALUES (321, 2, 5)
    INTO user_provider_ratings (user_id, provider_id, rating) VALUES (303, 1, 5)
    INTO user_provider_ratings (user_id, provider_id, rating) VALUES (329, 2, 1)
    INTO user_provider_ratings (user_id, provider_id, rating) VALUES (301, 1, 5)
    INTO user_provider_ratings (user_id, provider_id, rating) VALUES (310, 1, 2)
    INTO user_provider_ratings (user_id, provider_id, rating) VALUES (317, 1, 5)
    INTO user_provider_ratings (user_id, provider_id, rating) VALUES (307, 2, 1)
    INTO user_provider_ratings (user_id, provider_id, rating) VALUES (323, 2, 4)
SELECT * FROM dual;

INSERT ALL
    INTO user_show_ratings (user_id, show_id, rating) VALUES (310, 101, 4)
    INTO user_show_ratings (user_id, show_id, rating) VALUES (307, 101, 5)
    INTO user_show_ratings (user_id, show_id, rating) VALUES (330, 102, 1)
    INTO user_show_ratings (user_id, show_id, rating) VALUES (323, 105, 5)
    INTO user_show_ratings (user_id, show_id, rating) VALUES (303, 103, 5)
    INTO user_show_ratings (user_id, show_id, rating) VALUES (330, 104, 2)
    INTO user_show_ratings (user_id, show_id, rating) VALUES (321, 106, 2)
    INTO user_show_ratings (user_id, show_id, rating) VALUES (316, 105, 5)
    INTO user_show_ratings (user_id, show_id, rating) VALUES (307, 103, 1)
    INTO user_show_ratings (user_id, show_id, rating) VALUES (330, 105, 3)
SELECT * FROM dual;

INSERT ALL
    INTO USER_ACTOR_RATINGS (USER_ID, ACTOR_ID, RATING) VALUES (330, 1, 5)
    INTO USER_ACTOR_RATINGS (USER_ID, ACTOR_ID, RATING) VALUES (302, 2, 4)
    INTO USER_ACTOR_RATINGS (USER_ID, ACTOR_ID, RATING) VALUES (309, 5, 3)
    INTO USER_ACTOR_RATINGS (USER_ID, ACTOR_ID, RATING) VALUES (315, 4, 4)
    INTO USER_ACTOR_RATINGS (USER_ID, ACTOR_ID, RATING) VALUES (322, 5, 4)
    INTO USER_ACTOR_RATINGS (USER_ID, ACTOR_ID, RATING) VALUES (329, 6, 3)
    INTO USER_ACTOR_RATINGS (USER_ID, ACTOR_ID, RATING) VALUES (319, 4, 4)
    INTO USER_ACTOR_RATINGS (USER_ID, ACTOR_ID, RATING) VALUES (313, 3, 2)
    INTO USER_ACTOR_RATINGS (USER_ID, ACTOR_ID, RATING) VALUES (315, 3, 2)
    INTO USER_ACTOR_RATINGS (USER_ID, ACTOR_ID, RATING) VALUES (301, 4, 4)
SELECT * FROM dual;
--End of inserting values;



--Create views
BEGIN
   EXECUTE IMMEDIATE 'DROP VIEW view_subscription_info';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
CREATE OR REPLACE VIEW view_subscription_info AS
SELECT
    t.transaction_id,
    t.transaction_type,
    t.tran_ts AS transaction_timestamp,
    s.sub_plan_id,
    s.plan_name,
    s.plan_price,
    s.months_duration,
    s.provider_provider_id,
    p.provider_name,
    c.user_id,
    c.email,
    c.sub_status,
    c.sub_start_date,
    c.sub_end_date,
    c.country,
    c.birthday,
    c.gender
FROM
    transactionu t
    LEFT JOIN subscriptionu s ON t.subscription_sub_plan_id = s.sub_plan_id
    LEFT JOIN customer c ON t.user_user_id = c.user_id
    LEFT JOIN provider p on s.provider_provider_id = p.provider_id;


BEGIN
   EXECUTE IMMEDIATE 'DROP VIEW regional_age_preferences';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
CREATE OR REPLACE VIEW regional_age_preferences AS
SELECT c.country, 
       c.gender,
       TRUNC((SYSDATE - c.birthday) / 365.25) AS age, 
       g.show_type AS Genre,
       AVG(us.rating) AS average_rating
FROM customer c
JOIN user_genre_ratings us ON c.user_id = us.user_id
JOIN genre g ON us.genre_id = g.genre_id
GROUP BY c.country, c.gender, TRUNC((SYSDATE - c.birthday) / 365.25), g.show_type;


BEGIN
   EXECUTE IMMEDIATE 'DROP VIEW combined_affection_ratings';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
CREATE OR REPLACE VIEW combined_affection_ratings AS
SELECT * FROM (
    SELECT 'Actor' AS category, a.actor_id AS id, a.actor_name AS name, ROUND(AVG(ua.rating), 2) AS average_rating
    FROM actor a
    JOIN user_actor_ratings ua ON a.actor_id = ua.actor_id
    GROUP BY a.actor_id, a.actor_name
    UNION ALL
    SELECT 'Director', d.director_id, d.director_name, ROUND(AVG(ud.rating), 2)
    FROM director d
    JOIN user_director_ratings ud ON d.director_id = ud.director_id
    GROUP BY d.director_id, d.director_name
    UNION ALL
    SELECT 'Show', s.show_id, s.title, ROUND(AVG(us.rating), 2)
    FROM shows s
    JOIN user_show_ratings us ON s.show_id = us.show_id
    GROUP BY s.show_id, s.title
    UNION ALL
    SELECT 'Provider', p.provider_id, p.provider_name, ROUND(AVG(up.rating), 2)
    FROM provider p
    JOIN user_provider_ratings up ON p.provider_id = up.provider_id
    GROUP BY p.provider_id, p.provider_name
) ORDER BY category, id;

CREATE OR REPLACE VIEW view_provider_annual_income AS
SELECT
    p.provider_id,
    p.provider_name,
    EXTRACT(YEAR FROM t.tran_ts) AS year,
    SUM(s.plan_price) AS annual_income
FROM
    provider p
    JOIN subscriptionu s ON p.provider_id = s.provider_provider_id
    JOIN transactionu t ON s.sub_plan_id = t.subscription_sub_plan_id
WHERE
    EXTRACT(YEAR FROM t.tran_ts) BETWEEN 2019 AND 2024
GROUP BY
    p.provider_id,
    p.provider_name,
    EXTRACT(YEAR FROM t.tran_ts)
ORDER BY
    p.provider_id,
    EXTRACT(YEAR FROM t.tran_ts);



BEGIN
   EXECUTE IMMEDIATE 'DROP VIEW subscription_peak_periods_extended';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
CREATE OR REPLACE VIEW subscription_peak_periods_extended AS
SELECT
    EXTRACT(YEAR FROM t.tran_ts) AS year,
    EXTRACT(MONTH FROM t.tran_ts) AS month,
    p.provider_name,
    s.plan_name,
    AVG(s.months_duration) AS avg_duration_months,
    COUNT(*) AS total_subscriptions
FROM
    transactionu t
    JOIN subscriptionu s ON t.subscription_sub_plan_id = s.sub_plan_id
    JOIN provider p ON s.provider_provider_id = p.provider_id
WHERE
    t.transaction_type = 'subscription'
GROUP BY
    EXTRACT(YEAR FROM t.tran_ts),
    EXTRACT(MONTH FROM t.tran_ts),
    p.provider_name,
    s.plan_name
ORDER BY
    total_subscriptions DESC;






--------------------------------------------------------------------------------
--TEST
--------------------------------------------------------------------------------
/*
-- Test Procedure Execution
BEGIN

    update_customer_profile(
        p_user_id => 301,
        p_email => 'newuser301@example.com',
        p_password => 'newpassword', 
        p_country => 'New Country',
        p_birthday => TO_DATE('1995-06-14', 'YYYY-MM-DD'), 
        p_gender => 'F' 
    );
END;
/
--If you run the upward code again, you will get an error handling 'ORA-20009: Cannot update. Email and password are the same as existing records.'


--Test for purchase subscription
BEGIN
    PurchaseSubscriptionPlan(p_email => 'user2@example.com', p_provider_name => 'Netflix', p_plan_name => 'Prime Plan');
END;
/

--Test for handle subscription action;
BEGIN
    handle_subscription_action(314, 'renew', 201);
END;
/

BEGIN
    handle_subscription_action(312, 'cancel', NULL);
END;
/
--As we can see, the user_id 314&312 has changed due to the 'renew' and 'cancel' actions;

--Test for insert_new_customer
BEGIN
    insert_new_customer(
        p_email => 'newuser123@example.com',
        p_password => 'password123',
        p_country => 'China',
        p_birthday => DATE '2000-01-01',
        p_gender => 'M'
    );
END;
/
-- error handling, due to the repeating email, the system will raise an error called 20001 email address already exist, 


--Test for show_management_package
DECLARE
  v_title        VARCHAR2(100) := 'New Fantasy Adventure';
  v_date_added   DATE := SYSDATE;
  v_release_date DATE := SYSDATE;
  v_age_rating   VARCHAR2(10) := 'PG-13';
  v_duration     VARCHAR2(20) := '120 minutes';
  v_type         VARCHAR2(20) := 'Movie';
  v_genre_name   VARCHAR2(50) := 'Fantasy';  -- Assuming this is a new genre
  v_actor_name   VARCHAR2(50) := 'John Smith';  -- Assuming this is a new actor
  v_director_name VARCHAR2(50) := 'Mary Johnson';  -- Assuming this is a new director
BEGIN
  show_management_pkg.insert_new_show(
    p_title        => v_title,
    p_date_added   => v_date_added,
    p_release_date => v_release_date,
    p_age_rating   => v_age_rating,
    p_duration     => v_duration,
    p_type         => v_type,
    p_genre_name   => v_genre_name,
    p_actor_name   => v_actor_name,
    p_director_name=> v_director_name
  ); 
  DBMS_OUTPUT.PUT_LINE('New show and its related information have been successfully inserted.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--test for insert actor rating
BEGIN
    InsertActorRating(p_email => 'user1@example.com', p_actor_name => 'Aaron Paul', p_rating => 4);
END;
BEGIN
    InsertProviderRating(p_email => 'user4@example.com', p_provider_name => 'Netflix', p_rating => 4);
END;
BEGIN
    app_admin.InsertGenreRating(p_email => 'user4@example.com', p_show_type => 'Action', p_rating => 4);
END;
BEGIN
    app_admin.InsertShowRating(p_email => 'user4@example.com', p_title => 'Lucy', p_rating => 4);
END;
BEGIN
    app_admin.InsertDirectorRating(p_email => 'user4@example.com', p_director_name => 'George Vincent', p_rating => 4);
END;


--Test Function about get_popular_shows
DECLARE
  v_cursor SYS_REFCURSOR;
  v_show_id shows.show_id%TYPE;
  v_title shows.title%TYPE;
  v_avg_rating NUMBER;
BEGIN
  v_cursor := get_popular_shows(4); 
  
  LOOP
    FETCH v_cursor INTO v_show_id, v_title, v_avg_rating;
    EXIT WHEN v_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_show_id || ', ' || v_title || ', ' || v_avg_rating);
  END LOOP;
  
  CLOSE v_cursor;
END;
/

--Test for all insert rating precedure
BEGIN
    InsertActorRating(p_email => 'user2@exaple.com', p_actor_name => 'Aaron Paul', p_rating => 10);
END;
-- **Error Handling**  If the rating is out of the range 1 to 5, it will raise error 'Rating must be between 1 and 5.' 
-- And if null enter, it will raise error 'Email must not be null.'
*/

