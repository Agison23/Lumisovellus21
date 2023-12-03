import _database as db


def insert_data(connection):
    """This function insert data for testing"""
    print("Inserting test data")
    sql_table_users = """ INSERT INTO users(dev_id, first_name, last_name, ip_address, phone_number)
                            VALUES  ('test','test','0','127.0.0.1,54503','358000'),
                                    ('test1','test1','1','127.0.0.1,54505','358111'),
                                    ('test2','test2','2','127.0.0.1,54504','358222'); 
                       """
    """Following gps coord is taken from file Koordinaatit.sql, timestamp is Epoch time"""
    sql_table_data = """ INSERT INTO data(dev_id, timestamp, gpscoord)
                            VALUES  ('test',1676051700,'68.2861,23.0780'),
                                    ('test1',1675965300,'68.0826,24.0381'),
                                    ('test2',1675878900,'68.0769,24.0806');
    
    
                        """
    sql_table_help = """ INSERT INTO help(dev_id, timestamp, gpscoord, help_type, room_id)
                            VALUES  ('test',1676102100,'68.0826,24.038','emergency', 'test');
                        """
    """Password of admin is admin; of operator is operator, below are the hased value of them when store in the database"""
    sql_table_accounts = """INSERT INTO accounts(username, password, role)
                            VALUES  ('admin','8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918','admin'),
                                    ('operator','06e55b633481f7bb072957eabcf110c972e86691c3cfedabe088024bffe42f23','operator');
                        """

    sql_table_requests = """INSERT INTO requests(help_giver, help_requester, state)
                            VALUES ('test','test1',0);"""

    sql_table_rescue = """INSERT INTO rescue(username, password, is_admin)
                            VALUES  ('admin','8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',1),
                                    ('operator','06e55b633481f7bb072957eabcf110c972e86691c3cfedabe088024bffe42f23',0);
                        """
    cur = connection.cursor()
    cur.execute(sql_table_users)
    cur.execute(sql_table_data)
    cur.execute(sql_table_help)
    cur.execute(sql_table_accounts)
    cur.execute(sql_table_requests)
    cur.execute(sql_table_rescue)
    connection.commit()


connection = db.connect_to_database()
db.init_tables(connection)
insert_data(connection)
