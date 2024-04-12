BEGIN
    app_admin.handle_subscription_action(314, 'renew', 201);
END;
/

BEGIN
    app_admin.handle_subscription_action(326, 'cancel', NULL);
END;
/

SELECT * FROM app_admin.transactionu;
SELECT * FROM app_admin.customer;