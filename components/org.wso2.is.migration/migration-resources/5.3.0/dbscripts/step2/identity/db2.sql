BEGIN
  DECLARE CONTINUE HANDLER FOR SQLSTATE '42704'
  BEGIN END;
  EXECUTE IMMEDIATE 'DROP INDEX IDX_IOAT_AT';
END
/
CREATE INDEX IDX_AT ON IDN_OAUTH2_ACCESS_TOKEN(ACCESS_TOKEN)
/

