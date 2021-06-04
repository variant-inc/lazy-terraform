CREATE table IF NOT EXISTS public.awsdms_ddl_audit
(
  c_key    bigserial primary key,
  c_time   timestamp,    -- Informational
  c_user   varchar(64),  -- Informational: current_user
  c_txn    varchar(16),  -- Informational: current transaction
  c_tag    varchar(24),  -- Either 'CREATE TABLE' or 'ALTER TABLE' or 'DROP TABLE'
  c_oid    integer,      -- For future use - TG_OBJECTID
  c_name   varchar(64),  -- For future use - TG_OBJECTNAME
  c_schema varchar(64),  -- For future use - TG_SCHEMANAME. For now - holds current_schema
  c_ddlqry  text         -- The DDL query associated with the current DDL event
);

CREATE OR REPLACE FUNCTION public.awsdms_intercept_ddl()
  RETURNS event_trigger
LANGUAGE plpgsql
SECURITY DEFINER
  AS $$
  declare _qry text;
BEGIN
  if (tg_tag='CREATE TABLE' or tg_tag='ALTER TABLE' or tg_tag='DROP TABLE') then
         SELECT current_query() into _qry;
         insert into public.awsdms_ddl_audit
         values
         (
         default,current_timestamp,current_user,cast(TXID_CURRENT()as varchar(16)),tg_tag,0,'',current_schema,_qry
         );
         delete from public.awsdms_ddl_audit;
end if;
END;
$$;

DROP event TRIGGER IF EXISTS awsdms_intercept_ddl;
CREATE EVENT trigger awsdms_intercept_ddl ON ddl_command_end
EXECUTE PROCEDURE public.awsdms_intercept_ddl();

grant all on public.awsdms_ddl_audit to public;
grant all on public.awsdms_ddl_audit_c_key_seq to public;

create extension IF NOT EXISTS pglogical;

SELECT * FROM pg_create_logical_replication_slot('replication_slot', 'pglogical');

select pglogical.create_replication_set('ireplication_slot', true, false, false, true);
select pglogical.create_replication_set('replication_slot', false, true, true, false);
