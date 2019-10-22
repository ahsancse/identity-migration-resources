CREATE TABLE IF NOT EXISTS IDN_OAUTH2_ACCESS_TOKEN_AUDIT (
            TOKEN_ID VARCHAR (255),
            ACCESS_TOKEN VARCHAR(2048),
            REFRESH_TOKEN VARCHAR(2048),
            CONSUMER_KEY_ID INTEGER,
            AUTHZ_USER VARCHAR (100),
            TENANT_ID INTEGER,
            USER_DOMAIN VARCHAR(50),
            USER_TYPE VARCHAR (25),
            GRANT_TYPE VARCHAR (50),
            TIME_CREATED TIMESTAMP NULL,
            REFRESH_TOKEN_TIME_CREATED TIMESTAMP NULL,
            VALIDITY_PERIOD BIGINT,
            REFRESH_TOKEN_VALIDITY_PERIOD BIGINT,
            TOKEN_SCOPE_HASH VARCHAR(32),
            TOKEN_STATE VARCHAR(25),
            TOKEN_STATE_ID VARCHAR (128) ,
            SUBJECT_IDENTIFIER VARCHAR(255),
            ACCESS_TOKEN_HASH VARCHAR(512),
            REFRESH_TOKEN_HASH VARCHAR(512),
            INVALIDATED_TIME TIMESTAMP NULL
);

