CREATE TABLE IDN_OAUTH2_AUTHZ_CODE_SCOPE(
    CODE_ID VARCHAR2(255),
    SCOPE VARCHAR2(60),
    TENANT_ID INTEGER DEFAULT -1,
    PRIMARY KEY (CODE_ID, SCOPE),
    FOREIGN KEY (CODE_ID) REFERENCES IDN_OAUTH2_AUTHORIZATION_CODE (CODE_ID) ON DELETE CASCADE)
/

CREATE TABLE IDN_OAUTH2_TOKEN_BINDING (
    TOKEN_ID VARCHAR2(255),
    TOKEN_BINDING_TYPE VARCHAR2(32),
    TOKEN_BINDING_REF VARCHAR2(32),
    TOKEN_BINDING_VALUE VARCHAR2(1024),
    TENANT_ID INTEGER DEFAULT -1,
    PRIMARY KEY (TOKEN_ID),
    FOREIGN KEY (TOKEN_ID) REFERENCES IDN_OAUTH2_ACCESS_TOKEN(TOKEN_ID) ON DELETE CASCADE)
/

CREATE TABLE IDN_FED_AUTH_SESSION_MAPPING (
    IDP_SESSION_ID VARCHAR(255) NOT NULL,
    SESSION_ID VARCHAR(255) NOT NULL,
    IDP_NAME VARCHAR(255) NOT NULL,
    AUTHENTICATOR_ID VARCHAR(255),
    PROTOCOL_TYPE VARCHAR(255),
    TIME_CREATED TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (IDP_SESSION_ID))
/

CREATE TABLE IDN_OAUTH2_CIBA_AUTH_CODE (
    AUTH_CODE_KEY CHAR(36),
    AUTH_REQ_ID CHAR(36),
    ISSUED_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSUMER_KEY VARCHAR(255),
    LAST_POLLED_TIME TIMESTAMP,
    POLLING_INTERVAL INTEGER,
    EXPIRES_IN  INTEGER,
    AUTHENTICATED_USER_NAME VARCHAR(255),
    USER_STORE_DOMAIN VARCHAR(100),
    TENANT_ID INTEGER,
    AUTH_REQ_STATUS VARCHAR(100) DEFAULT 'REQUESTED',
    IDP_ID INTEGER,
    CONSTRAINT AUTH_REQ_ID_CONSTRAINT UNIQUE(AUTH_REQ_ID),
    PRIMARY KEY (AUTH_CODE_KEY),
    FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE)
/

CREATE TABLE IDN_OAUTH2_CIBA_REQUEST_SCOPES (
    AUTH_CODE_KEY CHAR(36),
    SCOPE VARCHAR(255),
    FOREIGN KEY (AUTH_CODE_KEY) REFERENCES IDN_OAUTH2_CIBA_AUTH_CODE(AUTH_CODE_KEY) ON DELETE CASCADE)
/

CREATE TABLE IDN_OAUTH2_DEVICE_FLOW (
    CODE_ID VARCHAR2(255),
    DEVICE_CODE VARCHAR2(255),
    USER_CODE VARCHAR2(25),
    CONSUMER_KEY_ID INTEGER,
    LAST_POLL_TIME TIMESTAMP NOT NULL,
    EXPIRY_TIME TIMESTAMP NOT NULL,
    TIME_CREATED TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    POLL_TIME NUMBER(19),
    STATUS VARCHAR2(25) DEFAULT 'PENDING',
    AUTHZ_USER VARCHAR2(100),
    TENANT_ID INTEGER,
    USER_DOMAIN VARCHAR2(50),
    IDP_ID INTEGER,
    PRIMARY KEY (DEVICE_CODE),
    UNIQUE (CODE_ID),
    FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE)
/

CREATE TABLE IDN_OAUTH2_DEVICE_FLOW_SCOPES (
    ID INTEGER NOT NULL ,
    SCOPE_ID VARCHAR2(255),
    SCOPE VARCHAR2(255),
    PRIMARY KEY (ID),
    FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_DEVICE_FLOW(CODE_ID) ON DELETE CASCADE)
/

CREATE SEQUENCE IDN_ODF_SCOPES_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/

CREATE OR REPLACE TRIGGER IDN_ODF_SCOPES_TRIG
    BEFORE INSERT
    ON IDN_OAUTH2_DEVICE_FLOW_SCOPES
    REFERENCING NEW AS NEW
    FOR EACH ROW
        BEGIN
            SELECT IDN_ODF_SCOPES_SEQ.nextval INTO :NEW.ID FROM dual;
        END;
/

ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD TOKEN_BINDING_REF VARCHAR2(32) DEFAULT 'NONE'
/

ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN DROP CONSTRAINT CON_APP_KEY
/

ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD CONSTRAINT CON_APP_KEY UNIQUE (CONSUMER_KEY_ID,AUTHZ_USER,TENANT_ID,USER_DOMAIN,USER_TYPE,TOKEN_SCOPE_HASH,TOKEN_STATE,TOKEN_STATE_ID,IDP_ID,TOKEN_BINDING_REF)
/

ALTER TABLE IDN_ASSOCIATED_ID ADD ASSOCIATION_ID CHAR(36) DEFAULT LOWER(regexp_replace(rawtohex(sys_guid()), '([A-F0-9]{8})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{12})', '\1-\2-\3-\4-\5')) NOT NULL
/

ALTER TABLE SP_APP
    ADD (
        UUID CHAR(36) DEFAULT LOWER(regexp_replace(rawtohex(sys_guid()), '([A-F0-9]{8})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{12})', '\1-\2-\3-\4-\5')),
        IMAGE_URL VARCHAR(1024),
        ACCESS_URL VARCHAR(1024),
        IS_DISCOVERABLE CHAR(1) DEFAULT '0')
/

ALTER TABLE SP_APP ADD CONSTRAINT APPLICATION_UUID_CONSTRAINT UNIQUE (UUID)
/

ALTER TABLE IDP
    ADD (
        IMAGE_URL VARCHAR(1024),
        UUID CHAR(36) DEFAULT LOWER(regexp_replace(rawtohex(sys_guid()), '([A-F0-9]{8})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{12})', '\1-\2-\3-\4-\5')))
/

ALTER TABLE IDP ADD UNIQUE (UUID)
/

BEGIN
    execute immediate 'ALTER TABLE IDN_CONFIG_FILE ADD NAME VARCHAR(255) NULL';
    dbms_output.put_line('created');
exception WHEN OTHERS THEN
    dbms_output.put_line('skipped');
END;
/

ALTER TABLE FIDO2_DEVICE_STORE
    ADD (
        DISPLAY_NAME VARCHAR(255),
        IS_USERNAMELESS_SUPPORTED CHAR(1) DEFAULT '0')
/

ALTER TABLE IDN_OAUTH2_SCOPE_BINDING
	ADD BINDING_TYPE VARCHAR(255) DEFAULT 'DEFAULT' NOT NULL
	MODIFY (SCOPE_BINDING NOT NULL)
	ADD UNIQUE (SCOPE_ID, SCOPE_BINDING, BINDING_TYPE)
/

-- Related to Scope Management --

ALTER TABLE IDN_OAUTH2_SCOPE
	ADD SCOPE_TYPE VARCHAR(255) DEFAULT 'OAUTH2' NOT NULL
	ADD UNIQUE (NAME, SCOPE_TYPE, TENANT_ID)
/

CREATE TABLE IDN_OIDC_SCOPE_CLAIM_MAPPING_NEW (
    ID INTEGER NOT NULL,
    SCOPE_ID INTEGER NOT NULL,
    EXTERNAL_CLAIM_ID INTEGER NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE(SCOPE_ID) ON DELETE CASCADE,
    FOREIGN KEY (EXTERNAL_CLAIM_ID) REFERENCES IDN_CLAIM(ID) ON DELETE CASCADE,
    CONSTRAINT IDN_OIDC_SCOPE_CLAIM_MAPPING_UNIQUE UNIQUE (SCOPE_ID, EXTERNAL_CLAIM_ID)
)
/

CREATE SEQUENCE IDN_OIDC_SCOPE_CLAIM_MAPPING_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/

CREATE OR REPLACE TRIGGER IDN_OIDC_SCOPE_CLAIM_MAPPING_TRIG
    BEFORE INSERT
    ON IDN_OIDC_SCOPE_CLAIM_MAPPING_NEW
    REFERENCING NEW AS NEW
    FOR EACH ROW
        BEGIN
            SELECT IDN_OIDC_SCOPE_CLAIM_MAPPING_SEQ.nextval INTO :NEW.ID FROM dual;
        END;
/

CREATE OR REPLACE PROCEDURE OIDC_SCOPE_DATA_MIGRATE_PROCEDURE IS
    oidc_scope_count INT:= 0;
    row_offset INT:= 0;
    oauth_scope_id INT:= 0;
    oidc_scope_id INT:= 0;
BEGIN
    SELECT COUNT(*) INTO oidc_scope_count FROM IDN_OIDC_SCOPE;
    WHILE row_offset < oidc_scope_count LOOP
        SELECT ID INTO oidc_scope_id FROM IDN_OIDC_SCOPE OFFSET row_offset ROWS FETCH NEXT 1 ROWS ONLY;
        INSERT INTO IDN_OAUTH2_SCOPE (NAME, DISPLAY_NAME, TENANT_ID, SCOPE_TYPE) SELECT NAME n1, NAME n2, TENANT_ID, 'OIDC' FROM IDN_OIDC_SCOPE OFFSET row_offset ROWS FETCH NEXT 1 ROWS ONLY;
        SELECT IDN_OAUTH2_SCOPE_SEQUENCE.currval INTO oauth_scope_id FROM dual;
        INSERT INTO IDN_OIDC_SCOPE_CLAIM_MAPPING_NEW (SCOPE_ID, EXTERNAL_CLAIM_ID) SELECT oauth_scope_id, EXTERNAL_CLAIM_ID FROM IDN_OIDC_SCOPE_CLAIM_MAPPING WHERE SCOPE_ID = oidc_scope_id;
        row_offset := row_offset + 1;
    END LOOP;
END;
/

CALL OIDC_SCOPE_DATA_MIGRATE_PROCEDURE()
/

BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE OIDC_SCOPE_DATA_MIGRATE_PROCEDURE';
END;
/

DROP TABLE IDN_OIDC_SCOPE_CLAIM_MAPPING
/

DROP SEQUENCE IDN_OIDC_SCOPE_CLAIM_MAP_SEQ
/

ALTER TABLE IDN_OIDC_SCOPE_CLAIM_MAPPING_NEW RENAME TO IDN_OIDC_SCOPE_CLAIM_MAPPING
/

DROP TABLE IDN_OIDC_SCOPE
/

DROP SEQUENCE IDN_OIDC_SCOPE_SEQUENCE
/

CREATE INDEX IDX_IDN_AUTH_BIND ON IDN_OAUTH2_TOKEN_BINDING (TOKEN_BINDING_REF)
/

CREATE INDEX IDX_AI_DN_UN_AI ON IDN_ASSOCIATED_ID(DOMAIN_NAME, USER_NAME, ASSOCIATION_ID)
/

CREATE INDEX IDX_AT_CKID_AU_TID_UD_TSH_TS ON IDN_OAUTH2_ACCESS_TOKEN(CONSUMER_KEY_ID, AUTHZ_USER, TENANT_ID, USER_DOMAIN, TOKEN_SCOPE_HASH, TOKEN_STATE)
/

CREATE INDEX IDX_FEDERATED_AUTH_SESSION_ID ON IDN_FED_AUTH_SESSION_MAPPING (SESSION_ID)
/
