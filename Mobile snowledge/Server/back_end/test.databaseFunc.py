import unittest
from unittest import mock
import sqlite3
import _database as db
import time
# Unit test for 80% _database.py
# Support const for database testing
SQL_CONST = {
    "insert_data": {
        "sql_table_users": """ INSERT INTO users(dev_id, first_name, last_name, ip_address, phone_number, low_battery, role)
                            VALUES  ('test','test','0','127.0.0.1,54503','358000', '0', 'normal'),
                                    ('test1','test1','1','127.0.0.1,54505','358111', '1', 'premium'),
                                    ('test2','test2','2','127.0.0.1,54504','358222', '0', 'normal');""",
        "sql_table_data":  """ INSERT INTO data(dev_id, timestamp, gpscoord)
                            VALUES  ('test',1676051700,'68.2861,23.0780'),
                                    ('test1',1675965300,'67.0826,25.0381'),
                                    ('test1',1675865300,'68.0826,24.0381'),
                                    ('test2',1675878900,'68.0769,24.0806'),
                                    ('test2',1675778900,'68.0769,24.0806');""",
        "sql_table_help": """ INSERT INTO help(dev_id, timestamp, gpscoord, help_type, room_id)
                                VALUES  ('test',1676102100,'68.0826,24.038','emergency', 'test');""",
        "sql_table_accounts": """INSERT INTO accounts(username, password, role)
                                VALUES  ('admin1','8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918','admin'),
                                    ('operator','06e55b633481f7bb072957eabcf110c972e86691c3cfedabe088024bffe42f23','operator'); """,
        "sql_table_requests": """INSERT INTO requests(help_giver, help_requester, state)
                                VALUES ('test','test1',1),
                                       ('test2','test1',0);""",
        "sql_table_rescue": """INSERT INTO rescue(username, password, is_admin)
                            VALUES  ('admin','8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',1),
                                    ('operator','06e55b633481f7bb072957eabcf110c972e86691c3cfedabe088024bffe42f23',0);""",               
    }
}
# Support function for having mock data for testing
def insert_data(connection):
    """This function insert data for testing"""
    print("Inserting test data")
    cur = connection.cursor()
    cur.execute(SQL_CONST["insert_data"]["sql_table_users"])
    cur.execute(SQL_CONST["insert_data"]["sql_table_data"])
    cur.execute(SQL_CONST["insert_data"]["sql_table_help"])
    cur.execute(SQL_CONST["insert_data"]["sql_table_accounts"])
    cur.execute(SQL_CONST["insert_data"]["sql_table_requests"])
    cur.execute(SQL_CONST["insert_data"]["sql_table_rescue"])
    connection.commit()

# Create a function to strip out the IDs from the actual data
def strip_ids(data):
    return [tuple(row[1:]) for row in data]

class TestDatabaseFunctions(unittest.TestCase):

    def setUp(self):
        self.connection = sqlite3.connect('database.db',  check_same_thread=False)
        db.init_tables(self.connection)
        insert_data(self.connection)

    def tearDown(self):
        # Reset the database.
        cur = self.connection.cursor()
        cur.execute("DROP TABLE IF EXISTS data")
        cur.execute("DROP TABLE IF EXISTS help")
        cur.execute("DROP TABLE IF EXISTS users")
        cur.execute("DROP TABLE IF EXISTS accounts")
        cur.execute("DROP TABLE IF EXISTS requests")
        cur.execute("DROP TABLE IF EXISTS rescue")
        cur.execute("DROP TABLE IF EXISTS role")
        self.connection.commit()
        # close database connection
        self.connection.close()

    def test_init_tables(self):

        # Check if the 'users' table exists.
        cursor = self.connection.cursor()
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='users'")
        table_exists = cursor.fetchone()

        self.assertTrue(table_exists is not None, "The 'users' table does not exist.")

        # Check the columns of the 'users' table.
        cursor.execute("PRAGMA table_info(users)")  # Get column information for 'users' table
        columns = cursor.fetchall()
        column_names = [col[1] for col in columns]

        # Define the expected columns in the 'users' table.
        expected_columns = ['dev_id', 'first_name', 'last_name', 'ip_address', 'phone_number', 'low_battery', 'role']

        # Check if the 'users' table has the expected columns.
        self.assertEqual(column_names, expected_columns, "The 'users' table does not have the expected columns.")

    def test_insert_data(self):
        # Mock the create_table() function (if needed)
        mock_create_table = mock.Mock()
        db.create_table = mock_create_table

        # Check the 'users' table
        cursor = self.connection.cursor()
        cursor.execute("SELECT * FROM users")
        users_data = cursor.fetchall()
        expected_users_data = [
            ('test', 'test', '0', '127.0.0.1,54503', '358000', 0, 'normal'),
            ('test1', 'test1', '1', '127.0.0.1,54505', '358111', 1, 'premium'),
            ('test2', 'test2', '2', '127.0.0.1,54504', '358222', 0, 'normal'),
        ]
        self.assertEqual(users_data, expected_users_data)

        # Check the 'data' table
        cursor.execute("SELECT * FROM data")
        data_data = cursor.fetchall()
        expected_data_data = [
            ('test', 1676051700, '68.2861,23.0780'),
            ('test1', 1675965300, '67.0826,25.0381'),
            ('test1', 1675865300, '68.0826,24.0381'),
            ('test2', 1675878900, '68.0769,24.0806'),
            ('test2', 1675778900, '68.0769,24.0806')
        ]
        self.assertEqual(data_data, expected_data_data)

        # Check the 'help' table
        cursor.execute("SELECT * FROM help")
        help_data = cursor.fetchall()
        expected_help_data = [
            ('test', 1676102100, '68.0826,24.038', 'emergency', 'test')
        ]
        self.assertEqual(help_data, expected_help_data)

        # Check the 'accounts' table
        cursor.execute("SELECT * FROM accounts")
        accounts_data = cursor.fetchall()
        expected_accounts_data = [
            ('admin1', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'admin'),
            ('operator', '06e55b633481f7bb072957eabcf110c972e86691c3cfedabe088024bffe42f23', 'operator')
        ]
         # Check if each element in expected data is present in actual data
        for expected_entry in expected_accounts_data:
            self.assertIn(expected_entry, accounts_data)

        # Check the 'requests' table
        cursor.execute("SELECT * FROM requests")
        requests_data = cursor.fetchall()
        expected_requests_data = [
            ('test', 'test1', 1),
            ('test2', 'test1', 0)
        ]
        self.assertEqual(requests_data, expected_requests_data)

        # Check the 'rescue' table
        cursor.execute("SELECT * FROM rescue")
        rescue_data = cursor.fetchall()
        expected_rescue_data = [
            ('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 1),
            ('operator', '06e55b633481f7bb072957eabcf110c972e86691c3cfedabe088024bffe42f23', 0)
        ]
        # Check if each element in expected data is present in actual data
        for expected_entry in expected_rescue_data:
            self.assertIn(expected_entry, strip_ids(rescue_data))
    
    def test_get_user_id(self):
        # Test with a valid username and password.
        user_id = db.get_user_id(self.connection, 'admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918')
        self.assertEqual(user_id, 1)

        # Test with an invalid username.
        user_id = db.get_user_id(self.connection, 'invalid_username', 'password')
        self.assertEqual(user_id, None)

        # Test with an invalid password.
        user_id = db.get_user_id(self.connection, 'admin', 'invalid_password')
        self.assertEqual(user_id, None)

    # Test the is_user_admin() function.

    # def test_is_user_admin_with_valid_user_id(self):
    #     # Test with the user ID of an admin user.
    #     user_id = 1
    #     is_admin = db.is_user_admin(self.connection, user_id)
    #     self.assertTrue(is_admin)

    # Test the get_user() function.

    def test_get_user_with_valid_user_id(self):
        # Test with the user ID of a valid user.
        user_id = 1
        user = db.get_user(self.connection, user_id)
        self.assertEqual(user[0], user_id)
        self.assertEqual(user[1], 'admin')
        self.assertEqual(user[2], '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918')
        self.assertEqual(user[3], True)

    def test_get_user_with_invalid_user_id(self):
        # Test with the user ID of an invalid user.
        user_id = -1
        user = db.get_user(self.connection, user_id)
        self.assertIsNone(user)

    # Test the check_if_username_exists() function.

    def test_check_if_username_exists_with_existing_username(self):
        # Test with an existing username.
        username = 'admin'
        username_exists = db.check_if_username_exists(self.connection, username)
        self.assertTrue(username_exists)

    def test_check_if_username_exists_with_non_existing_username(self):
        # Test with a non-existing username.
        username = 'invalid_username'
        username_exists = db.check_if_username_exists(self.connection, username)
        self.assertFalse(username_exists)

    # Test the check_is_same_username() function.

    def test_check_is_same_username_with_same_username(self):
        # Test with the same username.
        user_id = 1
        username = 'admin'
        is_same_username = db.check_is_same_username(self.connection, user_id, username)
        self.assertTrue(is_same_username)

    def test_check_is_same_username_with_different_username(self):
        # Test with a different username.
        user_id = 1
        username = 'invalid_username'
        is_same_username = db.check_is_same_username(self.connection, user_id, username)
        self.assertFalse(is_same_username)

    # Test the check_if_entry_exists() function.

    def test_check_if_entry_exists_with_existing_entry(self):
        table = 'users'
        key1 = 'dev_id'
        key2 = 'dev_id'
        entry = 'test'
        full_return = True

        exists, success = db.check_if_entry_exists(self.connection, table, key1, key2, entry, full_return)

        self.assertTrue(success)
        self.assertEqual(exists[0][0], entry)

    def test_check_if_entry_exists_with_non_existing_entry(self):
        table = 'users'
        key1 = 'dev_id'
        key2 = 'dev_id'
        entry = 'non_existing_entry'
        full_return = True

        exists, success = db.check_if_entry_exists(self.connection, table, key1, key2, entry, full_return)

        self.assertFalse(success)
        self.assertIsNone(exists)

    # Test the rescue_users_from_db() function.

    # def test_rescue_users_from_db(self):
    #     result = db.rescue_users_from_db(self.connection)

    #     self.assertIsNotNone(result)

    # Test the get_all_help_requests() function.

    def test_get_all_help_requests(self):
        entry = db.get_all_help_requests(self.connection)

        self.assertIsNotNone(entry)

    # Test the set_user_battery() function.

    # def test_set_user_battery_with_low_battery_status(self):
    #     dev_id = 'test'
    #     battery_status = 'low'

    #     db.set_user_battery(self.connection, dev_id, battery_status)

    #     sql = """SELECT low_battery FROM users WHERE dev_id=?;"""
    #     cur = self.connection.cursor()
    #     cur.execute(sql, (dev_id,))
    #     low_battery = cur.fetchone()

    #     self.assertEqual(low_battery[0], 1)

#     def test_set_user_battery_with_high_battery_status(self):
#         dev_id = 'test'
#         battery_status = 'high'

#         db.set_user_battery(self.connection, dev_id, battery_status)

#         sql = """SELECT low_battery FROM users WHERE dev_id=?;"""
#         cur = self.connection.cursor()
#         cur.execute(sql, (dev_id,))
#         low_battery = cur.fetchone()

#         self.assertEqual(low_battery[0], 0)

#     # Test the set_user_role() function.

#     def test_set_user_role(self):
#         dev_id = 'test'
#         role = 'premium'

#         db.set_user_role(self.connection, dev_id, role)

#         sql = """SELECT role FROM users WHERE dev_id=?;"""
#         cur = self.connection.cursor()
#         cur.execute(sql, (dev_id,))
#         user_role = cur.fetchone()

#         self.assertEqual(user_role[0], role)

    # Test the get_user_role() function.

    def test_get_user_role_with_existing_user(self):
        dev_id = 'test1'

        result = db.get_user_role(self.connection, dev_id)

        self.assertIsNotNone(result)
        self.assertEqual(result[0], 'premium')

    def test_get_user_role_with_non_existing_user(self):
        dev_id = 'non_existing_user'

        result = db.get_user_role(self.connection, dev_id)

        self.assertIsNone(result)

 # Test the get_helpers() function.

    def test_get_helpers_with_existing_help_request(self):
        requester = 'test1'

        help_givers = db.get_helpers(self.connection, requester)

        self.assertIsNotNone(help_givers)
        self.assertEqual(help_givers[0], 'test')

    def test_get_helpers_with_non_existing_help_request(self):
        requester = 'non_existing_help_request'

        help_givers = db.get_helpers(self.connection, requester)

        self.assertIsNone(help_givers)

    # Test the get_user_ip_by_dev_id() function.

    def test_get_user_ip_by_dev_id_with_existing_user(self):
        dev_id = 'test1'

        user_ip = db.get_user_ip_by_dev_id(self.connection, dev_id)

        self.assertIsNotNone(user_ip)
        self.assertEqual(user_ip, '127.0.0.1,54505')

    def test_get_user_ip_by_dev_id_with_non_existing_user(self):
        dev_id = 'non_existing_user'

        user_ip = db.get_user_ip_by_dev_id(self.connection, dev_id)

        self.assertIsNone(user_ip)

    # Test the get_2_latest_location_dev_id() function.

    def test_get_2_latest_location_dev_id_with_existing_user(self):
        dev_id = 'test1'

        user_coord = db.get_2_latest_location_dev_id(self.connection, dev_id)

        self.assertIsNotNone(user_coord)
        self.assertEqual(user_coord[1][0], '68.0826,24.0381')
        self.assertEqual(user_coord[0][0], '67.0826,25.0381')

    def test_get_2_latest_location_dev_id_with_non_existing_user(self):
        dev_id = 'non_existing_user'

        user_coord = db.get_2_latest_location_dev_id(self.connection, dev_id)

        self.assertIsNone(user_coord)

    # Test the get_battery_by_dev_id() function.

    def test_get_battery_by_dev_id_with_low_battery(self):
        dev_id = 'test2'

        low_battery = db.get_battery_by_dev_id(self.connection, dev_id)

        self.assertEqual(low_battery, 'high')

    def test_get_battery_by_dev_id_with_high_battery(self):
        dev_id = 'test1'

        low_battery = db.get_battery_by_dev_id(self.connection, dev_id)

        self.assertEqual(low_battery, 'low')

 # Test the create_connection() function.

    def test_create_connection_with_valid_path(self):
        path = 'database.db'

        connection = db.create_connection(path)

        self.assertIsNotNone(connection)

    # Test the connect_to_database() function.

    def test_connect_to_database(self):
        connection = db.connect_to_database()

        self.assertIsNotNone(connection)

    # Test the user_authentication() function.

    # def test_user_authentication_with_valid_username_and_password(self):
    #     username = 'admin'
    #     password = 'admin'

    #     correct = db.user_authentication(self.connection, username, password)

    #     self.assertTrue(correct)

#     def test_user_authentication_with_invalid_username(self):
#         username = 'invalid_username'
#         password = 'password'

#         correct = db.user_authentication(self.connection, username, password)

#         self.assertFalse(correct)

#     def test_user_authentication_with_invalid_password(self):
#         username = 'admin'
#         password = 'invalid_password'

#         correct = db.user_authentication(self.connection, username, password)

#         self.assertFalse(correct)

    # Test the get_latest_locations() function.

    def test_get_latest_locations_with_valid_timestamp(self):
        timestamp = 1675965300

        users = db.get_latest_locations(self.connection, timestamp)

        self.assertIsNotNone(users)
        self.assertEqual(users[0][0], 'test')
        self.assertEqual(users[0][2], '68.2861,23.0780')

    def test_get_latest_locations_with_invalid_timestamp(self):
        timestamp = 'invalid_timestamp'

        users = db.get_latest_locations(self.connection, timestamp)

        self.assertEqual(users, [])

 # Test the get_helper_count() function.

    def test_get_helper_count_with_valid_requester(self):
        requester = 'test1'

        count = db.get_helper_count(self.connection, requester)

        self.assertIsNotNone(count)
        self.assertEqual(count, 1)

    def test_get_helper_count_with_invalid_requester(self):
        requester = 'invalid_requester'

        count = db.get_helper_count(self.connection, requester)

        self.assertEqual(count, 0)

    # Test the get_all_pending_requests() function.

    def test_get_all_pending_requests_with_valid_requester(self):
        requester = 'test1'

        users = db.get_all_pending_requests(self.connection, requester)

        self.assertIsNotNone(users)
        self.assertEqual(users[0][0], 'test2')

    def test_get_all_pending_requests_with_invalid_requester(self):
        requester = 'invalid_requester'

        users = db.get_all_pending_requests(self.connection, requester)

        self.assertEqual(users, [])

    # Test the create_user_entry() function.

    def test_create_user_entry_with_valid_user_data(self):
        user = ['test5', 'John', 'Doe', '192.168.1.1', '1234567890']

        user_id = db.create_user_entry(self.connection, user)

        self.assertIsNotNone(user_id)
        self.assertEqual(user_id, 'test5')

    def test_create_user_entry_with_invalid_user_data(self):
        user = ['test1', 'John', 'Doe', '192.168.1.1']

        new_user = db.create_user_entry(self.connection, user)

        self.assertIsNone(new_user)

    # Test the create_data_entry() function.

    def test_create_data_entry_with_valid_data(self):
        data = ['test5', 1676102500, '68.0826,24.038']

        db.create_data_entry(self.connection, data)
        # Check if the data entry exists in the database.
        _, res = db.check_if_entry_exists(self.connection, 'data', 'dev_id', 'dev_id' ,'test1', False)

        self.assertTrue(res)

    # Test the create_help_entry() function.

    def test_create_help_entry_with_valid_help_data(self):
        help = ['test5', 1676102100, '68.0826,24.038', 'emergency', '1']

        db.create_help_entry(self.connection, help)
                # Check if the data entry exists in the database.
        _, res = db.check_if_entry_exists(self.connection, 'data', 'dev_id', 'dev_id' , 'test1', False)

        self.assertTrue(res)

    # Test the create_request_entry() function.

    def test_create_request_entry_with_valid_request_data(self):
        requester = 'test2'
        helper = 'test5'

        created = db.create_request_entry(self.connection, requester, helper)

        self.assertTrue(created)

    def test_create_request_entry_with_existing_request_data(self):
        requester = 'test2'
        helper = 'test5'

        create_1 = db.create_request_entry(self.connection, requester, helper)
        self.assertTrue(create_1)
        create_2 = db.create_request_entry(self.connection, requester, helper)
        self.assertFalse(create_2)

#     # Test the update_request_state() function.

#     def test_update_request_state_with_valid_state(self):
#         helper = 'test5'
#         state = 1

#         db.update_request_state(self.connection, state, helper)

#         self.assertTrue(True)

#     # Test the update_ip_address() function.

#     def test_update_ip_address_with_valid_ip_address(self):
#         dev_id = 'test5'
#         ip_address = '192.168.1.1,22'

#         db.update_ip_address(self.connection, dev_id, ip_address)

#         # Check if the ip_address was updated in the database.
#         cur = self.connection.cursor()
#         cur.execute('SELECT ip_address FROM users WHERE dev_id = ?', (dev_id,))
#         updated_ip_address = cur.fetchone()[0]

#         self.assertEqual(updated_ip_address, ip_address)

#     # Test the select_request_entry() function.

#     def test_select_request_entry_with_valid_entry(self):
#         entry = 'test'
#         ID = 'help_giver'

#         request_entry = db.select_request_entry(self.connection, entry, ID)

#         self.assertIsNotNone(request_entry)

    # Test the get_all_requests() function.

    def test_get_all_requests_with_valid_data(self):
        requests = db.get_all_requests(self.connection)

        self.assertIsNotNone(requests)

# Test the delete_request_entry() function.

    def test_delete_request_entry_with_valid_entry(self):
        entry = 'test1'
        ID = 'help_giver'

        db.delete_request_entry(self.connection, entry, ID)

        # Check if the request entry was deleted from the database.
        cur = self.connection.cursor()
        cur.execute('SELECT * FROM requests WHERE help_giver = ?', (entry,))
        request_entries = cur.fetchall()

        self.assertEqual(len(request_entries), 0)

    # Test the delete_help_entry() function.

    def test_delete_help_entry_with_valid_dev_id(self):
        dev_id = 'test'

        db.delete_help_entry(self.connection, dev_id)

        # Check if the help entry was deleted from the database.
        cur = self.connection.cursor()
        cur.execute('SELECT * FROM help WHERE dev_id = ?', (dev_id,))
        help_entries = cur.fetchall()

        self.assertEqual(len(help_entries), 0)

    # Test the fetch_old_entries() function.

    def test_fetch_old_entries_with_valid_threshold(self):
        threshold = 75878900

        entries = db.fetch_old_entries(self.connection, threshold)

        # Check if the returned entries are older than the threshold.
        current_time = int(time.time())
        for entry in entries:
            self.assertLess(entry[1], current_time - threshold)

    # Test the delete_old_entries() function.

    def test_delete_old_entries_with_valid_entries(self):
        entries = [('test1', 1675965300), ('test2', 1675878900)]

        # Delete the old entries
        db.delete_old_entries(self.connection, entries)

        # Check if the old entries were deleted from the database.
        cur = self.connection.cursor()
        cur.execute('SELECT * FROM data WHERE (dev_id = ? AND timestamp = ?) OR (dev_id = ? AND timestamp = ?)', (entries[0][0], entries[0][1], entries[1][0], entries[1][1]))
        old_entries = cur.fetchall()

        self.assertEqual(len(old_entries), 0)

    # Test the delete_old_users() function.

    # def test_delete_old_users_with_no_old_users(self):
    #     db.delete_old_users(self.connection)

    #     # Check if any users were deleted from the database.
    #     cur = self.connection.cursor()
    #     cur.execute('SELECT * FROM users')
    #     users = cur.fetchall()

    #     self.assertEqual(len(users), 0)

if __name__ == '__main__':
    unittest.main()
