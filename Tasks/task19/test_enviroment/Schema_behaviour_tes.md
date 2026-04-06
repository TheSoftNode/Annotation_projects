1. Test users.id UUID PRIMARY KEY DEFAULT gen_random_uuid()

Query:
insert into users (name) values ('Alice')
returning id, name, last_update;

Source Excerpt/Output:

| id                                   | name  | last_update                   |
| ------------------------------------ | ----- | ----------------------------- |
| b25feb5b-f675-46c8-a0bd-cfdd3d663545 | Alice | 2026-04-06 07:11:19.393634+00 |

Expected result
id should auto-populate with a UUID.
last_update should auto-populate.
name should be Alice.

---

2. Test event.id SERIAL PRIMARY KEY

Query:
insert into event (name, location, start_time, end_time)
values
('Event 1', 'Room A', now(), now() + interval '1 hour'),
('Event 2', 'Room B', now(), now() + interval '2 hours')
returning id, name;

Source Excerpt/Output:

| id  | name    |
| --- | ------- |
| 1   | Event 1 |
| 2   | Event 2 |

Expected result
IDs should auto-increment, usually 1, 2 if the table is empty.

---

3. Test CHECK (end_time > start_time)

Query:
insert into event (name, location, start_time, end_time)
values ('Bad Event', 'Room X', now(), now() - interval '1 hour');

Source Excerpt/Output:

Error: Failed to run sql query: ERROR: 23514: new row for relation "event" violates check constraint "event_check" DETAIL: Failing row contains (3, Bad Event, Room X, 2026-04-06 07:13:30.897795+00, 2026-04-06 06:13:30.897795+00).

Expected result
This should fail with a check-constraint error.
That verifies the comment:
"CHECK (end_time > start_time) -- Ensure logical time order"

---

4a. Test status BYTEA NOT NULL CHECK (octet_length(status) = 336)
First insert a user:

insert into users (name) values ('Bob') returning id;

| id                                   |
| ------------------------------------ |
| 07db5391-fb94-4633-8cab-42ab226de4f0 |

Copy the returned UUID, then run this with that UUID:

Query: insert into week_statuses (user_id, start_day, status)
values (
'07db5391-fb94-4633-8cab-42ab226de4f0',
now(),
repeat('a', 336)::bytea
);

Source Excerpt/Output: Success. No rows returned

Expected result
This should succeed.

b. Now test the bad case:
Query:
insert into week_statuses (user_id, start_day, status)
values (
'07db5391-fb94-4633-8cab-42ab226de4f0',
now() + interval '7 days',
repeat('a', 335)::bytea
);

Source Excerpt/Output:

Error: Failed to run sql query: ERROR: 23514: new row for relation "week_statuses" violates check constraint "week_statuses_status_check" DETAIL: Failing row contains (07db5391-fb94-4633-8cab-42ab226de4f0, 2026-04-13 07:19:30.469993+00, \x61616161616161616161616161616161616161616161616161616161616161...).

Expected result
This should fail with the octet_length(status) = 336 check constraint.

---

5. Test ON DELETE CASCADE from week_statuses.user_id -> users.id
   After Bob and one valid week_statuses row exist, run:

   delete from users
   where id = '07db5391-fb94-4633-8cab-42ab226de4f0';

   Success. No rows returned

Then check:
select \*
from week_statuses
where user_id = '07db5391-fb94-4633-8cab-42ab226de4f0';

Source Excerpt/Output: Success. No rows returned

Expected result
You should get 0 rows.
That verifies:
"user_id UUID REFERENCES users(id) ON DELETE CASCADE, -- Cascade if user deleted"

---

6. Test event_users primary key and foreign keys
   First create one user and one event:

insert into users (name) values ('Carol') returning id;

output:

| id                                   |
| ------------------------------------ |
| f94b2dd3-9fb2-4563-afca-30d7574c740c |

Copy the UUID, then:

insert into event (name, location, start_time, end_time)
values ('Meeting', 'HQ', now(), now() + interval '1 hour')
returning id;

output:
| id |
| -- |
| 4 |

Copy the event ID, then:

Query: insert into event_users (event_id, user_id)
values (4, 'f94b2dd3-9fb2-4563-afca-30d7574c740c');

Source Excerpt/Output: Success. No rows returned

Expected result
This should succeed.

Now try the same insert again:

Query: insert into event_users (event_id, user_id)
values (4, 'f94b2dd3-9fb2-4563-afca-30d7574c740c');

Source Excerpt/Output:
Error: Failed to run sql query: ERROR: 23505: duplicate key value violates unique constraint "event_users_pkey" DETAIL: Key (event_id, user_id)=(4, f94b2dd3-9fb2-4563-afca-30d7574c740c) already exists.

Expected result
This should fail with a duplicate-key error because of:
PRIMARY KEY (event_id, user_id)

7. Test ON DELETE CASCADE from event_users.event_id -> event.id
   Delete the event:

   delete from event
   where id = 4;

   output: Success. No rows returned

Then check:

Query: select \*
from event_users
where event_id = 4;

output: Success. No rows returned

Expected result
You should get 0 rows.

8. Test that the indexes exist
   Query:
   select indexname, tablename
   from pg_indexes
   where schemaname = 'public'
   and tablename in ('week_statuses', 'event_users', 'event')
   order by tablename, indexname;

Source Excerpt/Output:

| indexname                   | tablename     |
| --------------------------- | ------------- |
| event_pkey                  | event         |
| idx_event_end_time          | event         |
| idx_event_start_time        | event         |
| event_users_pkey            | event_users   |
| idx_event_users_event_id    | event_users   |
| idx_event_users_user_id     | event_users   |
| idx_week_statuses_start_day | week_statuses |
| idx_week_statuses_user_id   | week_statuses |
| week_statuses_pkey          | week_statuses |

Expected result
You should see the indexes created by the response:
idx_week_statuses_user_id
idx_week_statuses_start_day
idx_event_users_user_id
idx_event_users_event_id
idx_event_start_time
idx_event_end_time
