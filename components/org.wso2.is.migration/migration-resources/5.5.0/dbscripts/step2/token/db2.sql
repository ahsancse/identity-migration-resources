BEGIN
  DECLARE CONTINUE HANDLER FOR SQLSTATE '42704'
  BEGIN END;
  EXECUTE IMMEDIATE 'DROP INDEX IDX_ATH';
END
/

CREATE INDEX IDX_ATH ON IDN_OAUTH2_ACCESS_TOKEN(ACCESS_TOKEN_HASH)
/
