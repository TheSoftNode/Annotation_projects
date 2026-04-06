1. Check that the tables exist

Query: select table_name
from information_schema.tables
where table_schema = 'public'
and table_name in ('users', 'week_statuses', 'event', 'event_users')
order by table_name;

Source Excerpt/Output:

| table_name    |
| ------------- |
| event         |
| event_users   |
| users         |
| week_statuses |

---

2.  Check the column types

Query: select table_name, column_name, data_type, udt_name
from information_schema.columns
where table_schema = 'public'
and table_name in ('users', 'week_statuses', 'event', 'event_users')
order by table_name, ordinal_position;

Source Excerpt/Output:

| table_name    | column_name | data_type                | udt_name    |
| ------------- | ----------- | ------------------------ | ----------- |
| event         | id          | integer                  | int4        |
| event         | name        | character varying        | varchar     |
| event         | location    | character varying        | varchar     |
| event         | start_time  | timestamp with time zone | timestamptz |
| event         | end_time    | timestamp with time zone | timestamptz |
| event_users   | event_id    | integer                  | int4        |
| event_users   | user_id     | uuid                     | uuid        |
| users         | id          | uuid                     | uuid        |
| users         | name        | character varying        | varchar     |
| users         | last_update | timestamp with time zone | timestamptz |
| week_statuses | user_id     | uuid                     | uuid        |
| week_statuses | start_day   | timestamp with time zone | timestamptz |
| week_statuses | status      | bytea                    | bytea       |

What to compare:
Check whether:
users.id is uuid
users.last_update is timestamp with time zone
week_statuses.status is bytea
event.id is integer/serial-backed
event_users.user_id is uuid

---

3. Check whether gen_random_uuid() works in your Supabase project

Query: select gen_random_uuid();

Source Excerpt/Output:

| gen_random_uuid                      |
| ------------------------------------ |
| 489d0e3f-72e2-46dc-8ac3-ac51c8a601e7 |

---

4. Check whether pgcrypto is actually enabled

Query: select extname
from pg_extension
where extname = 'pgcrypto';

Source Excerpt/Output:

| extname  |
| -------- |
| pgcrypto |

Expected result
If you get pgcrypto, then it is enabled in your project.
If you get no rows, that is evidence against the response’s “pgcrypto enabled by default” claim.

---

5. Check whether uuid-ossp is enabled

Query: select extname
from pg_extension
where extname = 'uuid-ossp';

Source Excerpt/Output:

| extname   |
| --------- |
| uuid-ossp |

Expected result
If this returns uuid-ossp, that lines up with the current Supabase docs stating uuid-ossp is enabled by default. (Supabase)

---

6. Check RLS status on the tables

Query: select
n.nspname as schema_name,
c.relname as table_name,
c.relrowsecurity as rls_enabled
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
and c.relname in ('users', 'week_statuses', 'event', 'event_users')
order by c.relname;

Source Excerpt/Output:

| schema_name | table_name    | rls_enabled |
| ----------- | ------------- | ----------- |
| public      | event         | true        |
| public      | event_users   | true        |
| public      | users         | true        |
| public      | week_statuses | true        |

Expected result
All four tables should show true for rls_enabled.

---

7. Check that the policies were actually created

Query: select schemaname, tablename, policyname, roles, cmd
from pg_policies
where schemaname = 'public'
and tablename in ('week_statuses', 'event_users')
order by tablename, policyname;

Source Excerpt/Output:

| schemaname | tablename     | policyname                                | roles           | cmd    |
| ---------- | ------------- | ----------------------------------------- | --------------- | ------ |
| public     | event_users   | Users can insert themselves into events   | {authenticated} | INSERT |
| public     | event_users   | Users can view event_users they belong to | {authenticated} | SELECT |
| public     | week_statuses | Users can view their own week statuses    | {authenticated} | SELECT |

Expected result
You should see the created policies for week_statuses and event_users.

---
