/* User should have the Superuser permission */
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE OR REPLACE FUNCTION alter_um_user_add_user_id() RETURNS void AS $$ BEGIN IF EXISTS (SELECT column_name FROM information_schema.columns WHERE  table_name='um_user' and column_name='um_user_id') THEN RAISE NOTICE 'UM_USER table UM_USER_ID Column already exists'; ELSE ALTER TABLE UM_USER ADD COLUMN  UM_USER_ID CHAR(36) DEFAULT uuid_generate_v4(),ADD CONSTRAINT UM_USER_UUID_CONSTRAINT UNIQUE(UM_USER_ID); END IF;END;$$
LANGUAGE plpgsql;

select  alter_um_user_add_user_id();
