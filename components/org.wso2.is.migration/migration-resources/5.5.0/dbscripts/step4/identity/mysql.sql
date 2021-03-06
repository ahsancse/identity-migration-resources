DROP PROCEDURE IF EXISTS drop_idx_ath;
CREATE PROCEDURE drop_idx_ath() BEGIN IF((SELECT COUNT(*) AS index_exists FROM information_schema.statistics WHERE TABLE_SCHEMA = DATABASE() and table_name = 'IDN_OAUTH2_ACCESS_TOKEN' AND index_name = 'IDX_ATH') > 0) THEN SET @s = 'DROP INDEX IDX_ATH ON IDN_OAUTH2_ACCESS_TOKEN'; PREPARE stmt FROM @s; EXECUTE stmt; END IF; END;
CALL drop_idx_ath();
DROP PROCEDURE IF EXISTS drop_idx_ath;

CREATE INDEX IDX_ATH ON IDN_OAUTH2_ACCESS_TOKEN(ACCESS_TOKEN_HASH);
