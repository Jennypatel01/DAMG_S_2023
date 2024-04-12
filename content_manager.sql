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
  app_admin.show_management_pkg.insert_new_show(
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