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
        print("Set up")
        self.server = UdpServer()
        self.server_thread = threading.Thread(target=self.server.run)
        self.server_thread.start()
        self.connection = self.server.connection
        self.cur = self.connection.cursor()

    def tearDown(self):
        print("Tear down")
        self.server.status = False
        self.server_thread.join()

    def test_server_receive_LOCATION_message(self):
        messagetype = "LOCATION"
        # randomize to create new user every time
        devId = str(uuid.uuid4())
        firstName = fake.first_name()
        lastName = fake.last_name()
        gpsCoord = "68.0826,24.0381"
        phoneNum = f"+358{random.randint(100, 999)}{random.randint(100, 999)}{random.randint(100, 999)}"
        secondsSinceEpoch = round(datetime.datetime.now().timestamp())
        message = f"{messagetype}:{secondsSinceEpoch}:{devId}:{firstName}:{lastName}:{gpsCoord}:{phoneNum}"
        # message = f"{datetime.datetime.now()}:{devId}:{firstName}:{lastName}:{gpsCoord}:{phoneNum}"
        self.server.udp.sendto(bytes(message, "utf-8"), ("::1", 50943))
        time.sleep(1)

        self.assertGreater(self.connection.total_changes, 0)
        self.cur.execute(
            f"SELECT * FROM users WHERE first_name='{firstName}' AND last_name='{lastName}'"
        )
        resultUser = self.cur.fetchone()
        self.assertEqual(resultUser[0], devId)
        self.assertEqual(resultUser[1], firstName)
        self.assertEqual(resultUser[2], lastName)
        self.assertEqual(resultUser[3], "::1,50943")
        self.assertEqual(resultUser[4], phoneNum)

        self.cur.execute(
            f"SELECT * FROM data WHERE dev_id='{devId}' AND timestamp='{secondsSinceEpoch}'"
        )
        resultData = self.cur.fetchone()
        self.assertEqual(resultData[0], devId)
        self.assertEqual(resultData[1], secondsSinceEpoch)
        self.assertEqual(resultData[2], gpsCoord)

    def test_server_receive_HELP_message(self):
        messagetype = "LOCATION"

        # add new user to database
        devId = str(uuid.uuid4())
        firstName = fake.first_name()
        lastName = fake.last_name()
        gpsCoord = "68.0826,24.0381"
        phoneNum = f"+358{random.randint(100, 999)}{random.randint(100, 999)}{random.randint(100, 999)}"
        secondsSinceEpoch = round(datetime.datetime.now().timestamp())
        message = f"{messagetype}:{secondsSinceEpoch}:{devId}:{firstName}:{lastName}:{gpsCoord}:{phoneNum}"
        self.server.udp.sendto(bytes(message, "utf-8"), ("::1", 50943))
        time.sleep(1)

        # send help request
        messagetype = "HELP"
        message = (
            f"{messagetype}:{secondsSinceEpoch}:{devId}:{gpsCoord}:'Varusteongelma'"
        )
        self.server.udp.sendto(bytes(message, "utf-8"), ("::1", 50943))
        time.sleep(1)

        print(devId)

        self.assertGreater(self.connection.total_changes, 0)
        self.cur.execute(
            f"SELECT * FROM help WHERE dev_id='{devId}' AND timestamp='{secondsSinceEpoch}'"
        )

        resultHelp = self.cur.fetchone()
        self.assertEqual(resultHelp[0], devId)
        self.assertEqual(resultHelp[1], secondsSinceEpoch)
        self.assertEqual(resultHelp[2], gpsCoord)
        self.assertEqual(resultHelp[3], "'Varusteongelma'")

        # delete help request
        messagetype = "HELP_DELETE"
        message = f"{messagetype}:{devId}"
        self.server.udp.sendto(bytes(message, "utf-8"), ("::1", 50943))
        time.sleep(1)

        self.cur.execute(f"SELECT * FROM help WHERE dev_id='{devId}'")

        resultHelp = self.cur.fetchone()
        self.assertIsNone(resultHelp)


if __name__ == "__main__":
    unittest.main()
