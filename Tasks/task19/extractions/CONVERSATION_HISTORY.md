# Conversation History

**USER:**

can you generate sql code to create a postgres database with the following schema:

USERS (we edit this manually?)

 \- id (int)

 \- name (varchar 100\)

 \- last\_update (datetime)

WEEK\_STATUSES

 \- user\_id (int fkey)

 \- start\_day (datetime)

 \- status (blob 48\*7=336)

 \- pkey is (user\_id, start\_day)

EVENT

 \- id (int)

 \- name (varchar)

 \- location (varchar)

 \- start\_time (datetime)

 \- end\_time (datetime)

EVENT\_USERS

 \- event\_id (int fkey)

 \- user\_id (int fkey)

 \- pkey (event\_id, user\_id)

---

**ASSISTANT:**

Here's the SQL code to create the PostgreSQL database with the specified schema:

\-- Create USERS table

CREATE TABLE USERS (

    id INT PRIMARY KEY,

    name VARCHAR(100),

    last\_update TIMESTAMP

);

\-- Create WEEK\_STATUSES table

CREATE TABLE WEEK\_STATUSES (

    user\_id INT,

    start\_day TIMESTAMP,

    status BYTEA,

    PRIMARY KEY (user\_id, start\_day),

    FOREIGN KEY (user\_id) REFERENCES USERS(id),

    \-- Enforce 336-byte status size

    CHECK (octet\_length(status) \= 336\)

);

\-- Create EVENT table

CREATE TABLE EVENT (

    id INT PRIMARY KEY,

    name VARCHAR(100),

    location VARCHAR(100),

    start\_time TIMESTAMP,

    end\_time TIMESTAMP

);

\-- Create EVENT\_USERS junction table

CREATE TABLE EVENT\_USERS (

    event\_id INT,

    user\_id INT,

    PRIMARY KEY (event\_id, user\_id),

    FOREIGN KEY (event\_id) REFERENCES EVENT(id),

    FOREIGN KEY (user\_id) REFERENCES USERS(id)

);

### **Key Features:**

1. **Primary Keys**:
   * `USERS.id`, `WEEK_STATUSES(user_id, start_day)`, `EVENT.id`, and `EVENT_USERS(event_id, user_id)` are all defined as primary keys.
2. **Foreign Keys**:
   * `WEEK_STATUSES.user_id` references `USERS.id`.
   * `EVENT_USERS.event_id` and `EVENT_USERS.user_id` reference `EVENT.id` and `USERS.id` respectively.
3. **Data Types**:
   * `BYTEA` is used for the `status` field to store binary data (336 bytes as specified).
   * `TIMESTAMP` is used for datetime fields.
   * `VARCHAR(100)` is used for name and location fields (consistent with the `USERS.name` definition).
4. **Size Enforcement**:
   * A `CHECK` constraint ensures the `status` field is exactly 336 bytes long using `octet_length(status) = 336`.

### **Notes:**

* If you want to auto-generate `id` values (e.g., for `USERS` or `EVENT`), you can replace `INT` with `SERIAL` (e.g., `id SERIAL PRIMARY KEY`).
* The `CHECK` constraint for the `status` size is optional but aligns with your requirement of a fixed 336-byte blob.
