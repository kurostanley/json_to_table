CREATE PROCEDURE json_to_table(json_obj TEXT)
BEGIN
  DECLARE error_msg VARCHAR(255);
  SET error_msg = 'Invalid JSON object';

  IF JSON_VALID(json_obj) != 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_msg;
  END IF;
 
 
  WITH  cte_json AS (
	SELECT       
	    `key`,
	    JSON_EXTRACT(json_obj, CONCAT('$."', `key`, '"')) AS value,
	     0 AS lvl
	FROM JSON_TABLE(JSON_KEYS(json_obj), "$[*]" COLUMNS (`key` VARCHAR(100) PATH "$")) as jt
  )
  
  SELECT `key`, value FROM cte_json WHERE lvl = 0;


END