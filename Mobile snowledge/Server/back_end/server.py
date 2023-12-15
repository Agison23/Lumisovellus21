from socket import *
import select
import _database as db
import _parser as prs
from datetime import datetime
import time
import os
from dotenv import load_dotenv
load_dotenv()
ENVIRONMENT = os.getenv('APP_ENVIRONMENT')
class UdpServer:
    def __init__(self):
        self.connection = db.connect_to_database()
        self.status = True
        self.udp = socket(AF_INET6, SOCK_DGRAM, IPPROTO_UDP)
        if ENVIRONMENT == 'development':
            self.udp = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
        self.udp.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
        if ENVIRONMENT == 'development':
            self.udp.bind(("127.0.0.1", 50943)) 
        else:
            self.udp.bind(("", 50943))

        db.init_tables(self.connection)
        self.max_time_from_closest_users = 7200
        self.max_entry_age = 172800

    def run(self):
        last_time = time.time()
        while self.status:
            curr_time = time.time()
            if curr_time - last_time > 30:
                last_time = curr_time
                timestamp = time.time() - self.max_time_from_closest_users
                prs.send_location_updates(self.connection, timestamp, self.udp)

                old_entries = db.fetch_old_entries(self.connection, self.max_entry_age)
                db.delete_old_entries(self.connection, old_entries)
                db.delete_old_users(self.connection)

            readable, _, _ = select.select([self.udp], [], [], 60)
            if not readable:
                continue

            msg, addr = readable[0].recvfrom(4096)
            message, msg_type = prs.parse_message(msg)
            print(f"{msg_type} message: {message} - address: {addr}")
            try:
                if msg_type == "HELP":
                    prs.parse_help_request(
                        self.connection,
                        message,
                        self.max_time_from_closest_users,
                        self.udp,
                    )
                elif msg_type == "REQUEST_INIT":
                    prs.send_existing_requests(
                        self.connection,
                        message, 
                        addr,
                        self.udp
                    )
                elif msg_type == "BATTERY":
                    prs.parse_battery(
                        self.connection,
                        message,
                        self.udp)
                elif msg_type == "LOCATION":
                    prs.parse_database_entry(
                        self.connection, message, addr, self.max_entry_age
                    )
                elif msg_type == "HELP_DELETE":
                    prs.parse_database_help_delete(self.connection, message, self.udp)
                elif msg_type == "HELP_RESPONSE":
                    prs.parse_help_response(
                        self.connection,
                        message,
                        self.max_time_from_closest_users,
                        self.udp,
                    )
                elif msg_type == "DECLINE":
                    prs.parse_help_decline(self.connection, message, self.udp)
                elif msg_type == "KEEP_ALIVE":
                    self.udp.sendto(bytes(message[0], "UTF-8"), addr)
                elif msg_type == "UPDATE_ROLE":
                    prs.parse_update_user_role(self.connection, message, self.udp ,addr)
                elif msg_type == "GET_ROLE":
                    prs.parse_get_user_role(self.connection, message, self.udp, addr)
            except:
                pass
                print(f"Message parse error : {msg_type} {message}")
                



if __name__ == "__main__":
    print("Server started succesfully!")
    udp = UdpServer()
    udp.run()
