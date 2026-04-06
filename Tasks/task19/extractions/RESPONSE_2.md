# Response 2

Here's the Supabase-optimized version of your schema with key enhancements for security, UUID best practices, and automatic timestamp management:

\-- Enable required extensions (Supabase default)

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

\-- Create USERS table (linked to Supabase Auth)

CREATE TABLE public.users (

    id UUID PRIMARY KEY DEFAULT uuid\_generate\_v4() REFERENCES auth.users(id) ON DELETE CASCADE,

    name VARCHAR(100) NOT NULL,

    last\_update TIMESTAMPTZ DEFAULT NOW()

);

\-- Auto-update last\_update trigger

CREATE OR REPLACE FUNCTION update\_last\_update()

RETURNS TRIGGER AS $$

BEGIN

    NEW.last\_update \= NOW();

    RETURN NEW;

END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER update\_users\_last\_update

BEFORE UPDATE ON public.users

FOR EACH ROW

EXECUTE FUNCTION update\_last\_update();

\-- Enable Row Level Security (RLS) \- Supabase requirement

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

\-- WEEK\_STATUSES table

CREATE TABLE public.week\_statuses (

    user\_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

    start\_day TIMESTAMPTZ NOT NULL,

    status BYTEA NOT NULL CHECK (octet\_length(status) \= 336),

    PRIMARY KEY (user\_id, start\_day)

);

ALTER TABLE public.week\_statuses ENABLE ROW LEVEL SECURITY;

\-- EVENT table

CREATE TABLE public.event (

    id UUID PRIMARY KEY DEFAULT uuid\_generate\_v4(),

    name VARCHAR(100) NOT NULL,

    location VARCHAR(100),

    start\_time TIMESTAMPTZ NOT NULL,

    end\_time TIMESTAMPTZ NOT NULL,

    CHECK (end\_time \> start\_time)

);

ALTER TABLE public.event ENABLE ROW LEVEL SECURITY;

\-- EVENT\_USERS junction table

CREATE TABLE public.event\_users (

    event\_id UUID NOT NULL REFERENCES public.event(id) ON DELETE CASCADE,

    user\_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

    PRIMARY KEY (event\_id, user\_id)

);

ALTER TABLE public.event\_users ENABLE ROW LEVEL SECURITY;

\-- Optional: Basic RLS policies (customize for your app)

CREATE POLICY "Users can view their own data" ON public.users

    FOR SELECT USING (auth.uid() \= id);

CREATE POLICY "Users can update their own data" ON public.users

    FOR UPDATE USING (auth.uid() \= id);

CREATE POLICY "Users can manage their week statuses" ON public.week\_statuses

    FOR ALL USING (auth.uid() \= user\_id);

CREATE POLICY "Events are viewable by all" ON public.event

    FOR SELECT USING (true);

CREATE POLICY "Event assignments are user-specific" ON public.event\_users

    FOR ALL USING (auth.uid() \= user\_id);

### **Key Supabase-Specific Enhancements:**

1. **Auth Integration**:
   * `users.id` now references `auth.users(id)` (Supabase's built-in auth table)
   * Uses UUIDs instead of integers (standard for Supabase Auth)
   * `ON DELETE CASCADE` for proper cleanup when users delete accounts
2. **Security Essentials**:
   * Row Level Security (RLS) enabled on all tables (required for Supabase)
   * Basic starter policies included (customize based on your app's needs)
   * All tables created in `public` schema (Supabase default)
3. **Timestamp Improvements**:
   * `TIMESTAMPTZ` (timestamp with time zone) instead of `TIMESTAMP`
   * Automatic `last_update` management via trigger
   * Validation for event end time \> start time
4. **Data Integrity**:
   * Added `NOT NULL` constraints where appropriate
   * Proper foreign key cascades
   * UUID generation using `uuid_generate_v4()` (more secure than sequential IDs)
5. **Storage Optimization**:
   * `BYTEA` for binary status data with enforced 336-byte size
   * Removed redundant `id` columns from junction tables

### **Recommended Next Steps in Supabase:**

**Customize RLS Policies**:
\-- Example: Allow event creation only for admins

CREATE POLICY "Admins create events" ON public.event

  FOR INSERT WITH CHECK (

    EXISTS (SELECT 1 FROM public.users WHERE id \= auth.uid() AND is\_admin \= true)

  );

1.
2. **Enable Realtime**:
   * In Supabase Dashboard: Enable Realtime for tables you want to subscribe to

**Add Storage Relations** (if needed):
\-- Example for profile pictures

ALTER TABLE public.users ADD COLUMN avatar\_url TEXT;

3.

**Set Up Database Hooks**:
\-- Example: Send notification when event is created

CREATE FUNCTION notify\_event\_creation()

RETURNS TRIGGER AS $$

BEGIN

  PERFORM pg\_notify('event\_created', NEW.id::text);

  RETURN NEW;

END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER event\_creation\_trigger

AFTER INSERT ON public.event

FOR EACH ROW EXECUTE FUNCTION notify\_event\_creation();

4.

This schema follows Supabase best practices while maintaining your original structure. The RLS policies are intentionally basic \- you'll need to customize them based on your application's specific permission requirements.
