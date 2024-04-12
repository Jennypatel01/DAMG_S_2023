BEGIN
   app_admin.insert_new_customer(
        p_email => 'user100@example.com',
        p_password => 'password123',
        p_country => 'China',
        p_birthday => DATE '2000-01-01',
        p_gender => 'M'
    );
END;


BEGIN
    app_admin.PurchaseSubscriptionPlan(p_email => 'user100@example.com', p_provider_name => 'Netflix', p_plan_name => 'Prime Plan');
END;

BEGIN

    app_admin.update_customer_profile(
        p_user_id => 303,
        p_email => 'newuser303@example.com',
        p_password => 'newpassword', 
        p_country => 'New Country',
        p_birthday => TO_DATE('1995-06-14', 'YYYY-MM-DD'), 
        p_gender => 'F' 
    );
    commit;
END;


BEGIN
    app_admin.InsertActorRating(p_email => 'user4@example.com', p_actor_name => 'Aaron Paul', p_rating => 4);
END;
BEGIN
    app_admin.InsertProviderRating(p_email => 'user4@example.com', p_provider_name => 'Netflix', p_rating => 4);
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


SELECT TITLE FROM app_admin.shows;
SELECT * FROM app_admin.customer;