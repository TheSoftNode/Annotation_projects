✅ Supabase-Optimized SQL Schema

1. -- USERS table: Use UUID for ID to align with Supabase Auth

Query: CREATE TABLE users (
id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Supabase standard
name VARCHAR(100) NOT NULL,
last_update TIMESTAMPTZ NOT NULL DEFAULT NOW() -- Timezone-aware
)

Source Excerpt/output: Success. No rows returned

2. -- WEEK_STATUSES table

Query: CREATE TABLE week_statuses (
user_id UUID REFERENCES users(id) ON DELETE CASCADE, -- Cascade if user deleted
start_day TIMESTAMPTZ NOT NULL,
status BYTEA NOT NULL CHECK (octet_length(status) = 336), -- 48 \* 7 = 336 bytes
PRIMARY KEY (user_id, start_day)
);

Source Excerpt/output: Success. No rows returned

3. -- EVENT table
   Query: CREATE TABLE event (
   id SERIAL PRIMARY KEY, -- SERIAL is fine for non-auth entities
   name VARCHAR(100) NOT NULL,
   location VARCHAR(100),
   start_time TIMESTAMPTZ NOT NULL,
   end_time TIMESTAMPTZ NOT NULL,
   CHECK (end_time > start_time) -- Ensure logical time order
   );

Source Excerpt/output: Success. No rows returned

4. -- EVENT_USERS junction table
   Query: CREATE TABLE event_users (
   event_id INTEGER REFERENCES event(id) ON DELETE CASCADE,
   user_id UUID REFERENCES users(id) ON DELETE CASCADE,
   PRIMARY KEY (event_id, user_id)
   );

Source Excerpt/output: Success. No rows returned
