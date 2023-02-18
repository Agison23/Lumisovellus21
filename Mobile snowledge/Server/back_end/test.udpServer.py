import unittest
import threading
import time
from socket import *
from server import UdpServer
import datetime
import random
from faker import Faker
import uuid
fake = Faker()
import _parser as prs
class TestUdpServer(unittest.TestCase):

    def setUp(self):
        self.server = UdpServer()
        self.server_thread = threading.Thread(target=self.server.run)
        self.server_thread.start()
        self.connection = self.server.connection
        self.cur = self.connection.cursor()

    def tearDown(self):
        self.server.status = False
        self.server_thread.join()

    def test_server_receive_LOCATION_message(self):
        messagetype = 'LOCATION'
        # randomize to create new user every time
        devId =  str(uuid.uuid4())
        firstName = fake.first_name()
        lastName = fake.last_name()
        gpsCoord = "68.0826,24.0381"
        phoneNum = f"+358{random.randint(100, 999)}{random.randint(100, 999)}{random.randint(100, 999)}"
        message = f"{messagetype}:{datetime.datetime.now()}:{devId}:{firstName}:{lastName}:{gpsCoord}:{phoneNum}"
        #message = f"{datetime.datetime.now()}:{devId}:{firstName}:{lastName}:{gpsCoord}:{phoneNum}"
        self.server.udp.sendto(bytes(message, "utf-8"), ('::1',50943))
        time.sleep(1)

        self.assertGreater(self.connection.total_changes, 0)
        self.cur.execute(f"SELECT * FROM users WHERE first_name='{firstName}' AND last_name='{lastName}'")
        result = self.cur.fetchone()
        print(result)
        self.assertEqual(result[0], firstName)
        self.assertEqual(result[1], lastName)
        self.assertEqual(result[2], devId)
        self.assertEqual(result[3], gpsCoord)
        self.assertEqual(result[4], phoneNum)

if __name__ == '__main__':
    unittest.main()