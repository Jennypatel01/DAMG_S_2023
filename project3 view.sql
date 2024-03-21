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
