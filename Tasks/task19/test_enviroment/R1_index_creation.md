1. -- Optional: Add indexes for better performance

Query: CREATE INDEX idx_week_statuses_user_id ON week_statuses(user_id);
CREATE INDEX idx_week_statuses_start_day ON week_statuses(start_day);
CREATE INDEX idx_event_users_user_id ON event_users(user_id);
CREATE INDEX idx_event_users_event_id ON event_users(event_id);
CREATE INDEX idx_event_start_time ON event(start_time);
CREATE INDEX idx_event_end_time ON event(end_time);

Source Excerpt/output: Success. No rows returned

2. -- Optional: Enable Row Level Security (RLS) if using Supabase Auth
   -- (Only enable if you're using Supabase Auth and want to restrict access per user)

Query: ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE week_statuses ENABLE ROW LEVEL SECURITY;
ALTER TABLE event ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_users ENABLE ROW LEVEL SECURITY;

Source Excerpt/output: Success. No rows returned

3. -- Example RLS policy: Users can only see their own week_statuses
   -- (You'll need to create policies for each table based on your auth logic)

Query: CREATE POLICY "Users can view their own week statuses"
ON week_statuses FOR SELECT
TO authenticated
USING (user_id = auth.uid());

Source Excerpt/output: Success. No rows returned

4. -- Example: Users can only join events they are invited to (via event_users)

Query: CREATE POLICY "Users can view event_users they belong to"
ON event_users FOR SELECT
TO authenticated
USING (user_id = auth.uid());

Source Excerpt/output: Success. No rows returned

5. -- Example: Users can insert themselves into events (if you allow self-join)

Query: CREATE POLICY "Users can insert themselves into events"
ON event_users FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

Source Excerpt/output: Success. No rows returned
