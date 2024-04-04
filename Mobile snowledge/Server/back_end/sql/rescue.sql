
CREATE TABLE IF NOT EXISTS users (
    dev_id text PRIMARY KEY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    ip_address text NOT NULL,
    phone_number text,
    low_battery INTEGER DEFAULT '0',
    role TEXT,
    FOREIGN KEY (role) REFERENCES Role(name)
    ); 

CREATE TABLE IF NOT EXISTS data (
    dev_id text,
    timestamp integer,
    gpscoord text,
    PRIMARY KEY(dev_id, timestamp)
);

CREATE TABLE IF NOT EXISTS help (
    dev_id text PRIMARY KEY,
    timestamp integer,
    gpscoord text,
    help_type text,
    room_id text
);

CREATE TABLE IF NOT EXISTS accounts (
    username text PRIMARY KEY,
    password text NOT NULL,
    role text NOT NULL
    );

CREATE TABLE IF NOT EXISTS requests (
    help_giver text PRIMARY KEY,
    help_requester text NOT NULL,
    state INTEGER NOT NULL
    );

CREATE TABLE IF NOT EXISTS rescue (
    user_id INTEGER PRIMARY KEY,
    username text NOT NULL,
    password text NOT NULL,
    is_admin INTEGER NOT NULL
    );
    
CREATE TABLE IF NOT EXISTS role (
    name TEXT PRIMARY KEY,
    permissions TEXT NOT NULL
    );
