import _database as db
from math import radians, cos, sin, asin, sqrt
import time

PORT = 50943
COUNT = 5
DISTANCE_HELP_RESOLVED = 0.5 #the distance to indicate if the requester move more than this within 2 location update, help resolved -> delete

def parse_message(msg):
    message = msg.decode()
    message = message.split(":")
    msg_type = message[0]
    return message[1:], msg_type


def parse_help_request(connection, message, max_time_from_closest_users, s):
    timestamp = message[0]
    dev_id = message[1]
    gpscoord = message[2]
    helptype = message[3]
    chatRoomId = message[4]
    user_id, exists = db.check_if_entry_exists(
        connection, "users", "dev_id", "dev_id", dev_id, False
    )
    if not exists:
        return

    help = (user_id, timestamp, gpscoord, helptype, chatRoomId)
    db.create_help_entry(connection, help)
    if helptype == "Vakava hätä, avunpyytäjä on ohjeistettu soittamaan 112":
        max_distance = 1
    else:
        max_distance = 3

    users = get_closest_users(
        connection, gpscoord, max_distance, int(timestamp) - max_time_from_closest_users
    )
    if len(users) == 1:
        ip_address, _ = db.check_if_entry_exists(
            connection, "users", "ip_address", "dev_id", dev_id, False
        )
        message = "NO_USERS_NEARBY"
        ip_address, port = ip_address.split(",")
        s.sendto(bytes(message, "UTF-8"), (ip_address, int(port)))
    for user in users:
        if user[0] == dev_id:
            continue
        if not db.create_request_entry(connection, dev_id, user[0]):
            continue
        ip_address, _ = db.check_if_entry_exists(
            connection, "users", "ip_address", "dev_id", user[0], False
        )
        battery_status = db.get_battery_by_dev_id(connection, user[0])
        message = "NOTIFY:{}:{}:{:.2f}km:Syy {}:{}:{}".format(
            user[0], gpscoord, user[1], helptype, chatRoomId, battery_status
        )
        ip_address, port = ip_address.split(",")
        s.sendto(bytes(message, "UTF-8"), (ip_address, int(port)))
    pallaksenpollot = db.get_all_pallaksen_pollot(connection)

    for user in pallaksenpollot:
        if user[0] == dev_id:
            continue
        ip_address, _ = db.check_if_entry_exists(
            connection, "users", "ip_address", "dev_id", user[0], False
        )
        battery_status = db.get_battery_by_dev_id(connection, user[0])
        message = "NOTIFY:{}:{}:Syy {}:{}:{}".format(user[0], gpscoord, helptype, chatRoomId, battery_status)
        ip_address, port = ip_address.split(",")
        s.sendto(bytes(message, "UTF-8"), (ip_address, int(port)))


def parse_database_entry(connection, message, addr, max_entry_age):
    timestamp = message[0]
    dev_id = message[1]
    etunimi = message[2]
    sukunimi = message[3]
    gpscoord = message[4]
    phone_number = message[5]

    addr_str = "{},{}".format(addr[0], addr[1])
    user = (dev_id, etunimi, sukunimi, addr_str, phone_number)
    user_entry_id, exists = db.check_if_entry_exists(
        connection, "users", "dev_id", "dev_id", dev_id, False
    )

    if not exists:
        user_id = db.create_user_entry(connection, user)
    else:
        user_id = user_entry_id

    data = (user_id, timestamp, gpscoord)
    try:
        db.update_ip_address(connection, dev_id, addr_str)
        db.create_data_entry(connection, data)
    except:
        print("INFO:Entry already exists")


def parse_database_help_delete(connection, message, s):
    dev_id = message[0]
    _, exists = db.check_if_entry_exists(
        connection, "help", "dev_id", "dev_id", dev_id, False
    )
    if not exists:
        return

    users = db.select_request_entry(connection, dev_id, "help_requester")
    for user in users:
        ip_address, _ = db.check_if_entry_exists(
            connection, "users", "ip_address", "dev_id", user[0], False
        )
        message = "HELP_OVER:{}".format(user[0])
        ip_address, port = ip_address.split(",")
        s.sendto(bytes(message, "UTF-8"), (ip_address, int(port)))
        db.delete_request_entry(connection, user[0], "help_giver")
    db.delete_help_entry(connection, dev_id)
    db.delete_request_entry(connection, dev_id, "help_requester")


def calculate_distance(lat1, lon1, lat2, lon2):
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])

    # haversine formula
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlon / 2) ** 2
    c = 2 * asin(sqrt(a))
    r = 6371
    return c * r  # distance in km


def get_closest_users(connection, gpscoord, max_distance, timestamp):
    users = db.get_latest_locations(connection, timestamp)
    users_in_range = []

    for user in users:
        gps1 = user[2].split(",")
        gps2 = gpscoord.split(",")
        lat1 = float(gps1[0])
        lon1 = float(gps1[1])
        lat2 = float(gps2[0])
        lon2 = float(gps2[1])

        distance = calculate_distance(lat1, lon1, lat2, lon2)

        if distance <= max_distance:
            users_in_range.append((user[0], distance))

    return users_in_range

def points_not_in_range(gpscoord_giver, gpscoord_receiver, max_distance):
    gps1 = gpscoord_giver.split(",")
    gps2 = gpscoord_receiver.split(",")
    lat1 = float(gps1[0])
    lon1 = float(gps1[1])
    lat2 = float(gps2[0])
    lon2 = float(gps2[1])
    distance = calculate_distance(lat1, lon1, lat2, lon2)
    if distance > max_distance:
        return True
    return False



def parse_help_response(connection, message, max_time_from_closest_users, s):
    timestamp = int(time.time() / 1000) - max_time_from_closest_users
    helper = message[0]
    state = message[1]
    _, exists = db.check_if_entry_exists(
        connection, "requests", "state", "help_giver", helper, False
    )
    if not exists:
        return

    requester, _ = db.check_if_entry_exists(
        connection, "requests", "help_requester", "help_giver", helper, False
    )

    if state == "0":
        db.delete_request_entry(connection, helper, "help_giver")
        return

    db.update_request_state(connection, state, helper)

    count = db.get_helper_count(connection, requester)

    entry = db.select_request_entry(connection, helper, "help_giver")
    ip_address, _ = db.check_if_entry_exists(
        connection, "users", "ip_address", "dev_id", entry[0][1], False
    )
    users = db.get_latest_locations(connection, timestamp)
    for user in users:
        if user[0] == helper:
            gpscoord = user[2]
            break

    message = "HELPER_ACCEPTED:{}:{}".format(helper, gpscoord)
    ip_address, port = ip_address.split(",")
    s.sendto(bytes(message, "UTF-8"), (ip_address, int(port)))
    # check low battery for both helper and help requester
    low_battery_helper, _ = db.check_if_entry_exists(
        connection, "users", "low_battery", "dev_id", helper, False
    )
    if low_battery_helper == 1:
        send_low_battery_current_requests(connection, helper, s)     

    low_battery_helpee, _ = db.check_if_entry_exists(
        connection, "users", "low_battery", "dev_id", requester, False
    )
    if low_battery_helpee == 1:
        send_low_battery_current_requests(connection, requester, s)       
    if count >= COUNT:
        pending_helpers = db.get_all_pending_requests(connection, requester)

        for _helper in pending_helpers:
            address, _ = db.check_if_entry_exists(
                connection, "users", "ip_address", "dev_id", _helper[0], False
            )
            message = "HELP_OVER:{}".format(_helper[0])
            addr = address.split(",")
            s.sendto(bytes(message, "UTF-8"), (addr[0], int(addr[1])))
            db.delete_request_entry(connection, _helper[0], "help_giver")

    return


def parse_help_decline(connection, message, s):
    helper = message[0]
    _, exists = db.check_if_entry_exists(
        connection, "requests", "state", "help_giver", helper, False
    )

    if not exists:
        return

    entry = db.select_request_entry(connection, helper, "help_giver")
    db.delete_request_entry(connection, helper, "help_giver")

    ip_address, _ = db.check_if_entry_exists(
        connection, "users", "ip_address", "dev_id", entry[0][1], False
    )
    message = "HELPER_WITHDRAWN:{}".format(helper)
    ip_address, port = ip_address.split(",")
    s.sendto(bytes(message, "UTF-8"), (ip_address, int(port)))

    return


def do_work(giver, requester, coordinates):
    connection = db.connect_to_database()

    j = len(coordinates) - 1
    requester_gps = 0
    giver_gps = 0

    for i in range(len(coordinates)):
        user1 = coordinates[i][0]
        if user1 == requester:
            requester_gps = coordinates[i][2]
        elif user1 == giver:
            giver_gps = coordinates[i][2]

    requester_addr, _ = db.check_if_entry_exists(
        connection, "users", "ip_address", "dev_id", giver, False
    )
    requester_message = "HELP_TARGET_UPDATE:{}:{}".format(giver, requester_gps)

    giver_addr, _ = db.check_if_entry_exists(
        connection, "users", "ip_address", "dev_id", requester, False
    )
    giver_message = "HELPER_UPDATED:{}:{}".format(giver, giver_gps)

    result = [[requester_message, requester_addr], [giver_message, giver_addr]]
    return result


def send_location_updates(connection, timestamp, s):
    requests = db.get_all_requests(connection)
    coordinates = db.get_latest_locations(connection, timestamp)
    
    messages = []
    for request in requests:
        message = do_work(request[0], request[1], coordinates)
        past_requester_gps = db.get_2_latest_location_dev_id(connection,request[1])
        if len(past_requester_gps) < 2:
            messages.append(message)
        else:
            two_latest_requester_gps = [past_requester_gps[0][0], past_requester_gps[1][0]]
            if (points_not_in_range(two_latest_requester_gps[0],two_latest_requester_gps[1], DISTANCE_HELP_RESOLVED)):
                dev_id = request[1]
                users = db.select_request_entry(connection, dev_id, "help_requester")

                for user in users:
                    ip_address, _ = db.check_if_entry_exists(
                        connection, "users", "ip_address", "dev_id", user[0], False
                    )
                    message = "HELP_OVER:{}:AUTOMATIC_END".format(user[0])
                    ip_address, port = ip_address.split(",")
                    s.sendto(bytes(message, "UTF-8"), (ip_address, int(port)))

                db.delete_help_entry(connection, dev_id)
                requester_message_distance_cancel = "HELP_ENDED_BY_GPS"
                requester_ip, _ = db.check_if_entry_exists(
                        connection, "users", "ip_address", "dev_id", dev_id, False
                    )
                requester_ip_addr, requester_p = requester_ip.split(",")
                s.sendto(bytes(requester_message_distance_cancel, "UTF-8"), (requester_ip_addr, int(requester_p)))
                db.delete_request_entry(connection, dev_id, "help_requester")
            else:
                messages.append(message)

    for message in messages:       
        requester_message, requester_addr = message[0][0], message[0][1]
        giver_message, giver_addr = message[1][0], message[1][1]
        requester_addr, requester_port = requester_addr.split(",")
        giver_addr, giver_port = giver_addr.split(",")
        s.sendto(
            bytes(requester_message, "UTF-8"), (requester_addr, int(requester_port))
        )
        s.sendto(bytes(giver_message, "UTF-8"), (giver_addr, int(giver_port)))

    return

def parse_battery(connection, message, s):
    dev_id = message[0]
    battery_status = message[1]
    db.set_user_battery(connection, dev_id, battery_status)
    if (battery_status == 'low'):
        send_low_battery_current_requests(connection, dev_id, s)
    return

def send_low_battery_current_requests(connection, dev_id, s):
    # Send when help requester have low battery to helper
    _, isHelpee = db.check_if_entry_exists(connection, "help", "dev_id", "dev_id", dev_id, False)

    if (isHelpee):
        helpers = db.get_helpers(connection, dev_id)
        message = "LOW_BATTERY_HELPEE"
        for helper in helpers:
            helper_ip = db.get_user_ip_by_dev_id(connection, helper)
            ip_address, port = helper_ip.split(",")
            s.sendto(bytes(message, "UTF-8"), (ip_address, int(port)))

    # Send to help requester when helper have low battery
    else:
        helpee_dev_id, helper_exists = db.check_if_entry_exists(connection, "requests", "help_requester", "help_giver", dev_id, False)
        if (helper_exists):
            helpee_ip = db.get_user_ip_by_dev_id(connection, helpee_dev_id)
            helper_phone_num, _ = db.check_if_entry_exists(connection,"users","phone_number","dev_id", dev_id, False)
            message = f"LOW_BATTERY_HELPER:{helper_phone_num}"
            ip_address, port = helpee_ip.split(",")
            s.sendto(bytes(message, "UTF-8"), (ip_address, int(port)))
    return

def send_existing_requests(connection, message, addr, s):
    # create user entry but not get auto location
    timestamp = message[0]
    dev_id = message[1]
    etunimi = message[2]
    sukunimi = message[3]
    gpscoord = message[4]
    phone_number = message[5]
    addr_str = "{},{}".format(addr[0], addr[1])
    user = (dev_id, etunimi, sukunimi, addr_str, phone_number)
    user_entry_id, exists = db.check_if_entry_exists(
        connection, "users", "dev_id", "dev_id", dev_id, False
    )

    if not exists:
        user_id = db.create_user_entry(connection, user)
    else:
        user_id = user_entry_id

    data = (user_id, timestamp, gpscoord)
    try:
        db.create_data_entry(connection, data)
    except:
        print("INFO:Entry already exists")

    helps = db.get_all_help_requests(connection)
    for help in helps:
        req_dev_id = help[0]
        if (req_dev_id == dev_id):
            db.delete_request_entry(connection, "help_giver", dev_id)
        req_gpscoord = help[2]
        helptype = help[3]
        chatRoomId = help[4]
        if helptype == "Vakava hätä, avunpyytäjä on ohjeistettu soittamaan 112":
            max_distance = 1
        else:
            max_distance = 3
        if not points_not_in_range(gpscoord, req_gpscoord, max_distance):
            db.create_request_entry(connection, req_dev_id, dev_id)
            gps1 = gpscoord.split(",")
            gps2 = req_gpscoord.split(",")
            dist = calculate_distance(float(gps1[0]),float(gps1[1]),float(gps2[0]),float(gps2[1]))
            battery_status = db.get_battery_by_dev_id(connection, dev_id)
            message = "NOTIFY:{}:{}:{:.2f}km:Syy {}:{}:{}".format(
            dev_id, gpscoord, dist, helptype, chatRoomId,battery_status
            )
            s.sendto(bytes(message, "UTF-8"), (addr[0], int(addr[1])))
    return
