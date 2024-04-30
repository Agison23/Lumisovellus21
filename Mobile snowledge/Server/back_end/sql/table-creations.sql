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

CREATE TABLE IF NOT EXISTS location_data (
    dev_id text,
    timestamp integer,
    gpscoord text,
    PRIMARY KEY(dev_id, timestamp)
);

CREATE TABLE IF NOT EXISTS help_requests (
    dev_id text,
    timestamp integer,
    gpscoord text,
    help_type text,
    room_id text,
    PRIMARY KEY (dev_id),
    FOREIGN KEY (dev_id) REFERENCES users(dev_id)
);


CREATE TABLE IF NOT EXISTS nearby_users (
    help_giver TEXT,
    help_requester TEXT,
    state INTEGER NOT NULL,
    PRIMARY KEY (help_giver, help_requester),
    FOREIGN KEY (help_giver) REFERENCES users(dev_id),
    FOREIGN KEY (help_requester) REFERENCES help_requests(dev_id)
);


CREATE TABLE IF NOT EXISTS rescue (
    user_id INTEGER PRIMARY KEY,
    username text NOT NULL,
    password text NOT NULL,
    is_admin BOOLEAN NOT NULL
    );
    
CREATE TABLE IF NOT EXISTS role (
    name TEXT PRIMARY KEY,
    permissions TEXT NOT NULL
    );
