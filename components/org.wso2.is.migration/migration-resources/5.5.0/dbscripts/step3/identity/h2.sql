DROP INDEX IF EXISTS IDX_IOAT_AT;
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN modify REFRESH_TOKEN VARCHAR(2048);
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN modify ACCESS_TOKEN VARCHAR(2048);