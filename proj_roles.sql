
--user
GRANT SELECT ON Shows TO reg_use;
GRANT SELECT ON Director TO reg_use;
GRANT SELECT ON Actor TO reg_use;
GRANT SELECT ON Genre TO reg_use;
GRANT SELECT ON Type TO reg_use;
GRANT EXECUTE ON app_admin.update_customer_profile TO reg_use;
GRANT EXECUTE ON app_admin.insert_new_customer TO reg_use;
GRANT EXECUTE ON app_admin.InsertActorRating TO reg_use;
GRANT EXECUTE ON app_admin.InsertDirectorRating TO reg_use;
GRANT EXECUTE ON app_admin.InsertGenreRating TO reg_use;
GRANT EXECUTE ON app_admin.InsertProviderRating TO reg_use;
GRANT EXECUTE ON app_admin.InsertShowRating TO reg_use;
GRANT EXECUTE ON app_admin.get_popular_shows TO reg_use;
GRANT EXECUTE ON app_admin.PurchaseSubscriptionPlan TO reg_use;
GRANT SELECT ON combined_affection_ratings TO reg_use;


--transaction_manager
GRANT SELECT ON Transactionu TO tran_man;
GRANT SELECT ON Subscriptionu TO tran_man;
GRANT SELECT ON Shows TO tran_man;
GRANT SELECT ON customer TO tran_man;
GRANT EXECUTE ON handle_subscription_action TO tran_man;
GRANT SELECT ON view_subscription_info TO tran_man;
GRANT SELECT ON view_provider_annual_income TO tran_man;


--Content Manager
GRANT SELECT, INSERT, UPDATE, DELETE ON Actor TO cont_man;
GRANT SELECT, INSERT, UPDATE, DELETE ON Director TO cont_man;
GRANT SELECT, INSERT, UPDATE, DELETE ON Shows TO cont_man;
GRANT SELECT, INSERT, UPDATE, DELETE ON Show_Prov TO cont_man;
GRANT SELECT, INSERT, UPDATE, DELETE ON Direct TO cont_man;
GRANT SELECT, INSERT, UPDATE, DELETE ON Type TO cont_man;
GRANT SELECT, INSERT, UPDATE, DELETE ON Genre TO cont_man;
GRANT SELECT ON Provider TO cont_man;
GRANT SELECT ON Subscriptionu TO cont_man;
GRANT EXECUTE ON show_management_pkg TO cont_man;


--DROP user cont_man;
--DROP user tran_man;
--DROP user reg_use;



