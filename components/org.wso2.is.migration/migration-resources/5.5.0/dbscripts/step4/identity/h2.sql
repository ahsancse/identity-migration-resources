DROP INDEX IF EXISTS IDX_ATH;

CREATE INDEX IDX_ATH ON IDN_OAUTH2_ACCESS_TOKEN(ACCESS_TOKEN_HASH);

