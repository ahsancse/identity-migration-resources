DROP INDEX IF EXISTS IDX_ATH;
CREATE INDEX IF NOT EXISTS IDX_ATH ON IDN_OAUTH2_ACCESS_TOKEN(ACCESS_TOKEN_HASH);
