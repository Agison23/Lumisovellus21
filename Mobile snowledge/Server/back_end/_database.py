import os
import pathlib
import sqlite3
import time
from sqlite3 import Error


with open("admin_user.txt", "r") as file:
    lines = file.readlines()
    for i in range(len(lines)):
        lines[i] = lines[i].rstrip()
    ADMIN = lines[0]
    PASSWORD = lines[1]


def create_connection(path):
    connection = None

    try:
        connection = sqlite3.connect(path, check_same_thread=False)
    except Error as e:
        pass
        #print(f"The error '{e}' occurred")

    return connection


def connect_to_database():
    """Function used for connecting to database"""
    path = pathlib.Path(__file__).parent.resolve()
    path = str(str(path) + "/db/")

    if not os.path.exists(path):
        os.makedirs(path)
        connection = create_connection(path + "database")
    else:
        connection = create_connection(path + "database")

    return connection


def user_authentication(connection, username, password):
    """Used to authenticate rescue-side users"""
    correct = False
    sql = """SELECT password FROM rescue WHERE username=?;"""

    cur = connection.cursor()
    cur.execute(sql, (username,))
    _password = cur.fetchall()
    if _password:
        _password = _password[0][0]
        correct = password == _password

    return correct


def get_latest_locations(connection, timestamp):
    sql = """SELECT dev_id, max(timestamp), gpscoord
             FROM data WHERE timestamp > ? GROUP BY dev_id;"""

    cur = connection.cursor()
    cur.execute(sql, (timestamp,))
    users = cur.fetchall()
    return users


def get_helper_count(connection, requester):
    sql = """SELECT COUNT(help_giver) 
             FROM requests 
             WHERE help_requester = ? 
             AND state = 1"""

    cur = connection.cursor()
    cur.execute(sql, (requester,))
    count = cur.fetchall()
    return count[0][0]


def get_all_pending_requests(connection, requester):
    sql = """SELECT help_giver 
             FROM requests
             WHERE help_requester = ?
             AND state = 0"""

    cur = connection.cursor()
    cur.execute(sql, (requester,))
    users = cur.fetchall()
    return users


def create_user_entry(connection, user):
    try:
        sql = """ INSERT INTO users(dev_id,first_name,last_name,ip_address,phone_number,role)
                  VALUES (?,?,?,?,?,'premium') """

        cur = connection.cursor()
        cur.execute(sql, user)
        connection.commit()
        return user[0]
    except sqlite3.Error as e:
        # Handle the error here, for example, print an error message or log it.
        print(f"Error creating user entry: {e}")
        return None



def create_data_entry(connection, data):
    sql = """ INSERT INTO data(dev_id,timestamp,gpscoord)
              VALUES (?,?,?)"""

    cur = connection.cursor()
    cur.execute(sql, data)
    connection.commit()
    return


def create_help_entry(connection, help):
    _, exists = check_if_entry_exists(
        connection, "help", "dev_id", "dev_id", help[0], False
    )
    cur = connection.cursor()

    if not exists:
        sql = """INSERT INTO help(dev_id,timestamp,gpscoord, help_type, room_id)
              VALUES (?,?,?,?,?)"""
        cur.execute(sql, help)
    else:
        sql = "UPDATE help SET timestamp=?, gpscoord=?, help_type=?, room_id=? WHERE dev_id=?"
        cur.execute(sql, (help[1], help[2], help[3], help[4], help[0]))

    connection.commit()
    return


def create_request_entry(connection, requester, helper):
    sql = """INSERT INTO requests(help_giver,help_requester,state)
             VALUES(?,?,?)"""

    entry, exists = check_if_entry_exists(
        connection, "requests", "help_giver", "help_giver", helper, False
    )

    if exists:
        return False

    cur = connection.cursor()
    cur.execute(sql, (helper, requester, 0))
    connection.commit()
    return True


def update_request_state(connection, _state, helper):
    sql = """UPDATE requests SET state=? WHERE help_giver=?"""

    cur = connection.cursor()
    cur.execute(sql, (_state, helper))
    connection.commit()


def update_ip_address(connection, dev_id, addr_str):
    sql = """UPDATE users SET ip_address=? WHERE dev_id=?"""

    cur = connection.cursor()
    cur.execute(sql, (addr_str, dev_id))
    connection.commit()
    return


def select_request_entry(connection, entry, ID):
    sql = """SELECT help_giver,help_requester FROM requests
             WHERE {} = ?;""".format(
        ID
    )

    cur = connection.cursor()
    cur.execute(sql, (entry,))
    entry = cur.fetchall()
    return entry


def get_all_requests(connection):
    sql = """SELECT * FROM requests WHERE state = 1;"""

    cur = connection.cursor()
    cur.execute(sql)
    entry = cur.fetchall()
    return entry


def get_all_pallaksen_pollot(connection):
    sql = """SELECT * FROM users WHERE first_name= "8M0sZy" AND last_name= "FBy2sR";"""

    cur = connection.cursor()
    cur.execute(sql)
    entry = cur.fetchall()
    return entry


def delete_request_entry(connection, entry, ID):
    sql = """DELETE FROM requests
             WHERE {} = ?;""".format(
        ID
    )

    cur = connection.cursor()
    cur.execute(sql, (entry,))
    connection.commit()
    return


def delete_help_entry(connection, dev_id):
    sql = """DELETE FROM help
             WHERE dev_id = ?;"""

    cur = connection.cursor()
    cur.execute(sql, (dev_id,))
    connection.commit()
    return


def fetch_old_entries(connection, threshold):
    current_time = int(time.time())
    delete_threshold = current_time - threshold
    sql = """SELECT * FROM data
             WHERE timestamp < ?;"""
    cur = connection.cursor()
    cur.execute(sql, (delete_threshold,))
    entries = cur.fetchall()
    return entries


def delete_old_entries(connection, entries):
    sql = """DELETE FROM data
             WHERE dev_id = ?
             AND timestamp = ?;"""

    cur = connection.cursor()
    for entry in entries:
        deletion = (entry[0], entry[1])
        cur.execute(sql, deletion)
    return


def delete_old_users(connection):
    sql = """SELECT dev_id FROM users;"""
    delete_sql = """DELETE FROM users WHERE dev_id = ?;"""
    delete_sql2 = """DELETE FROM help WHERE dev_id = ?;"""

    cur = connection.cursor()
    cur.execute(sql)
    dev_ids = cur.fetchall()
    print("dev_ids", dev_ids)

    for id in dev_ids:
        _, exists = check_if_entry_exists(
            connection, "data", "dev_id", "dev_id", id[0], False
        )
        if not exists:
            cur.execute(delete_sql, (id[0],))
            cur.execute(delete_sql2, (id[0],))
    return


def create_table(connection, create_table_sql):
    """this function creates tables"""
    try:
        cur = connection.cursor()
        cur.execute(create_table_sql)
        connection.commit()
    except Error as e:
        print("hllelel")
        print(e)


def init_tables(connection):
    
    sql_table_users = """ CREATE TABLE IF NOT EXISTS users (
                            dev_id text PRIMARY KEY,
                            first_name text NOT NULL,
                            last_name text NOT NULL,
                            ip_address text NOT NULL,
                            phone_number text,
                            low_battery INTEGER DEFAULT '0',
                            role TEXT,
                            FOREIGN KEY (role) REFERENCES Role(name)
                         ); """

    sql_table_data = """CREATE TABLE IF NOT EXISTS data (
                            dev_id text,
                            timestamp integer,
                            gpscoord text,
                            PRIMARY KEY(dev_id, timestamp)
                        );"""

    sql_table_help = """ CREATE TABLE IF NOT EXISTS help (
                            dev_id text PRIMARY KEY,
                            timestamp integer,
                            gpscoord text,
                            help_type text,
                            room_id text
                        );"""

    sql_table_accounts = """CREATE TABLE IF NOT EXISTS accounts (
                            username text PRIMARY KEY,
                            password text NOT NULL,
                            role text NOT NULL
                            );"""

    sql_table_requests = """CREATE TABLE IF NOT EXISTS requests (
                            help_giver text PRIMARY KEY,
                            help_requester text NOT NULL,
                            state INTEGER NOT NULL
                            );"""

    sql_table_rescue = """CREATE TABLE IF NOT EXISTS rescue (
                            user_id INTEGER PRIMARY KEY,
                            username text NOT NULL,
                            password text NOT NULL,
                            is_admin INTEGER NOT NULL
                            );"""
    
    sql_table_role = """CREATE TABLE IF NOT EXISTS role (
                            name TEXT PRIMARY KEY,
                            permissions TEXT NOT NULL
                            );"""
    
    create_table(connection, sql_table_role)
    create_table(connection, sql_table_users)
    create_table(connection, sql_table_data)
    create_table(connection, sql_table_help)
    create_table(connection, sql_table_accounts)
    create_table(connection, sql_table_requests)
    create_table(connection, sql_table_rescue)
    sql = "DELETE FROM accounts WHERE role = 'Admin'"
    sql1 = "DELETE FROM rescue WHERE password = ?;"
    sql2 = "INSERT OR IGNORE INTO accounts(username,password,role) VALUES(?,?,?);"
    sql3 = "INSERT OR IGNORE INTO rescue (username,password,is_admin) VALUES(?,?,1);"
    sql4 = "INSERT OR IGNORE INTO role (name, permissions) VALUES ('normal', 'rescue');"
    sql5 = "INSERT OR IGNORE INTO role (name, permissions) VALUES ('premium', 'rescue, snow condition');"
    sql6 = "UPDATE users SET role='premium' WHERE role IS NULL"
    username = ADMIN
    password = PASSWORD
    role = "Admin"
    cur = connection.cursor()
    cur.execute(sql)
    cur.execute(sql1, (password,))
    cur.execute(sql2, (username, password, role))
    cur.execute(sql3, (username, password))
    cur.execute(sql4)
    cur.execute(sql5)
    cur.execute(sql6)
    rescue_users_from_db(connection)
    connection.commit()


def get_user_id(connection, username, password):
    """
    It is used, for example, to get the right user whose data you want to change on the Rescue side.
    Used if the user wants to edit their own data,
    OR if the admin user wants to edit another user
    """
    sql = """SELECT user_id FROM rescue WHERE username=? AND password=?;"""
    try:
        cur = connection.cursor()
        cur.execute(sql, (username, password))
        user_id = cur.fetchone()  # Use fetchone to get a single result
        if user_id:
            return user_id[0]
        else:
            return None  # Return None if user is not found
    except sqlite3.Error as e:
        print(f"Error in get_user_id: {e}")
        return None  # Handle the error gracefully and return None


def is_user_admin(connection, user_id):
    """Check if the user has admin rights for user management on the rescue side"""

    sql = """SELECT is_admin FROM rescue WHERE user_id=?;"""
    cur = connection.cursor()
    cur.execute(sql, (user_id,))
    result = cur.fetchall()
    return result[0][0] == 1


def get_user(connection, user_id):
    """
    Retrieve user information (user ID, username, and admin status) from the Rescue user management panel.
    """
    sql = """SELECT * FROM rescue WHERE user_id=?;"""
    try:
        cur = connection.cursor()
        cur.execute(sql, (user_id,))
        result = cur.fetchone()  # Use fetchone instead of fetchall
        if result:
            return result
        else:
            return None  # Return None if no user is found
    except sqlite3.Error as e:
        # Handle any database-related errors here
        print("Error while fetching user:", e)
        return None  # Return None in case of an error


def check_if_username_exists(connection, username):
    """
    Used to check if the username is reserved on the site.
    This function is used to prevent the application
    from having users with the same name.
    """
    sql = """SELECT username FROM rescue WHERE username==?;"""
    cur = connection.cursor()
    cur.execute(sql, (username,))
    result = cur.fetchone()
    return result


def check_is_same_username(connection, user_id, username):
    """
    When the user wants to change information,
    this function is used to check
    whether the user wants to change his username
    or only admin rights or password
    """
    sql = """SELECT username FROM rescue WHERE user_id=? AND username=?;"""
    cur = connection.cursor()
    cur.execute(sql, (user_id, username))
    result = cur.fetchone()
    return result


def check_if_entry_exists(connection, table, key1, key2, entry, full_return):
    try:
        cur = connection.cursor()
    except Error as e:
        print(e)

    _query = "SELECT {} FROM {} WHERE {}=?;".format(key1, table, key2)
    cur.execute(_query, (entry,))

    exists = cur.fetchall()

    if exists:
        if full_return:
            return exists, True
        return exists[0][0], True
    else:
        return None, False


def rescue_users_from_db(connection):
    """TEST FOR DEVELOPMENT"""
    cur = connection.cursor()
    cur.execute("SELECT * FROM rescue")
    print(cur.fetchall())

def get_all_help_requests(connection):
    sql = """SELECT * FROM help;"""

    cur = connection.cursor()
    cur.execute(sql)
    entry = cur.fetchall()
    return entry

def set_user_battery(connection, dev_id, battery_status):
    sql = "UPDATE users SET low_battery=? WHERE dev_id=?"
    cur = connection.cursor()
    if (battery_status == "low") :
        cur.execute(sql, (1,dev_id))     
    else:
        cur.execute(sql, (0,dev_id))
    connection.commit()
    return

def set_user_role(connection, dev_id, role):
    sql = "UPDATE users SET role=? WHERE dev_id=?"
    cur = connection.cursor()
    cur.execute(sql, (role, dev_id))
    connection.commit()
    return

def get_user_role(connection, dev_id):
    sql = """SELECT users.role AS role, role.permissions AS permissions
             FROM users
             INNER JOIN role ON role.name = users.role
             WHERE users.dev_id=?
          """
    cur = connection.cursor()
    try:
        cur.execute(sql, (dev_id,))
        result = cur.fetchone()
        return result
    except Exception as e:
        print("Error:", e)
        return None

def get_helpers(connection, requester):
    try:
        sql = """SELECT help_giver
                 FROM requests 
                 WHERE help_requester = ? 
                 AND state = 1;"""

        cur = connection.cursor()
        cur.execute(sql, (requester,))
        help_givers = cur.fetchall()

        if help_givers:
            return help_givers[0]
        else:
            return None  # No results found

    except sqlite3.Error as e:
        # Handle the exception (e.g., log the error or return an error message)
        print(f"SQLite error: {e}")
        return None  # Return an error indicator


def get_user_ip_by_dev_id(connection, dev_id):
    try:
        sql = """SELECT ip_address
                FROM users
                WHERE dev_id = ?;"""

        cur = connection.cursor()
        cur.execute(sql, (dev_id,))
        user_ip = cur.fetchone()

        if user_ip:
            return user_ip[0]
        else:
            return None  # No results found

    except sqlite3.Error as e:
        # Handle the exception (e.g., log the error or return an error message)
        print(f"SQLite error: {e}")
        return None  # Return an error indicator

def get_2_latest_location_dev_id(connection, dev_id):
    try:
        sql = """SELECT gpscoord
                FROM data
                WHERE dev_id = ?
                ORDER BY timestamp DESC
                LIMIT 2;"""

        cur = connection.cursor()
        cur.execute(sql, (dev_id,))
        user_coords = cur.fetchall()

        if user_coords:
            return user_coords
        else:
            return None  # No results found

    except sqlite3.Error as e:
        # Handle the exception (e.g., log the error or return an error message)
        print(f"SQLite error: {e}")
        return None  # Return an error indicator


def get_battery_by_dev_id(connection, dev_id):
    sql = """SELECT low_battery
             FROM users
             WHERE dev_id = ?;"""
    cur = connection.cursor()
    cur.execute(sql,(dev_id,))
    low_battery = cur.fetchone()
    if (low_battery[0] == 1):
        return "low"
    return "high"