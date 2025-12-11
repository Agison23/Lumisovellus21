from flask import Flask, jsonify, request
from flask_cors import CORS, cross_origin
import _database as db
import json
from time import time
from waitress import serve

time3DaysAgo = int(time()) - 259200

connection = db.connect_to_database()

app = Flask(__name__)
cors = CORS(app)


@app.route("/users", methods=["GET"])
def rescue_get_users():
    header = request.headers
    username, password = header.get("Authorization").split(":")
    auth = db.user_authentication(connection, username, password)

    if auth == False:
        return jsonify({"message": "Unauthorized"}), 401

    user_id = db.get_user_id(connection, username, password)
    is_admin = db.is_user_admin(connection, user_id)

    if is_admin == False:
        print("EI OLE ADMIN")
        print("username: " + username)
        print("password: " + password)
        user = db.get_user(connection, user_id)
        return jsonify([{"user_id": user[0], "username": user[1], "is_admin": user[3]}])

    response = db.get_rescue_users(connection)
    result_table = []
    for i in response:
        result_table.append({"user_id": i[0], "username": i[1], "is_admin": i[3]})

    return jsonify(result_table)


@app.route("/register", methods=["POST"])
def register_user():
    """
    Used to create a new user for the Rescue side
    """
    header = request.headers
    username, password = header.get("Authorization").split(":")

    auth = db.user_authentication(connection, username, password)

    if auth:
        if not request.is_json:
            return "The content isn't of type JSON"
        print("json ok")
        user = request.get_json()
        username = user.get("username")
        password = user.get("password")
        is_admin = user.get("is_admin")

        # check if some user already have requested username
        is_username_reserved = db.check_if_username_exists(connection, username)
        if is_username_reserved != None:
            response = jsonify({"message": "ERROR: Username already exists"}), 409
            print("Käyttäjänimi varattuna")
            return response
        else:
            print("käyttäjänimeä ei ole varattu")
            response = jsonify({"message": "OK: Authorized, User registered"}), 200
            db.create_rescue_user(connection, username, password, is_admin)
    else:
        response = jsonify({"message": "ERROR: Unauthorized, not registered"}), 401
        return response
    return response


@app.route("/modify", methods=["PUT"])
@cross_origin(methods=["PUT"])
def modify_user():
    """
    Used to edit user data.
    For example, if you want to change the
    user's password, username or admin rights.
    """
    if not request.is_json:
        return jsonify({"message": "ERROR: Bad request"}), 401

    header = request.headers
    username, password = header.get("Authorization").split(":")

    auth = db.user_authentication(connection, username, password)

    if auth == False:
        return jsonify({"message": "ERROR: Unauthorized, user not modified"}), 401

    user = request.get_json()
    print(user)
    user_id = user.get("user_id")
    username = user.get("username")
    password = user.get("password")
    is_admin = user.get("is_admin")

    # check if the user wants to change their username
    is_username_changed = db.check_is_same_username(connection, user_id, username)
    # check if username is already reserved for another user
    is_username_reserved = db.check_if_username_exists(connection, username)

    
    if is_username_changed == None or username == None:
        print("KÄYTTÄJÄNIMI HALUTAAN VAIHTAA")
        if username == None:
            response = jsonify({"message": "ERROR: Username is empty"}), 400
            print("Käyttäjänimi on tyhjä!")
            return response

        if is_username_reserved != None:
            response = jsonify({"message": "ERROR: Username already exists"}), 409
            print("Käyttäjänimi varattuna")
            return response

        if username is not None:
            db.set_rescue_user_username(connection, username, user_id)
        if password is not None:
            db.set_rescue_user_password(connection, password, user_id)
        if is_admin is not None:
            db.set_rescue_user_role(connection, is_admin, user_id)

    else:
        print("KÄYTTÄJÄNIMEÄ EI HALUTA VAIHTAA")
        print("käyttäjänimeä ei ole varattu")
        if user_id == None or (
            username == None and password == None and is_admin == None
        ):
            response = jsonify({"message": "ERROR: 401"}), 401
            return response

        if username is not None:
            db.set_rescue_user_username(connection ,username, user_id)
        if password is not None:
            db.set_rescue_user_password(connection, password, user_id)
        if is_admin is not None:
            db.set_rescue_user_role(connection, is_admin, user_id)

    return jsonify({"message": "OK"}), 200


@app.route("/delete", methods=["DELETE"])
@cross_origin(methods=["DELETE"])
def delete_user():
    """Used to delete user data from the rescue table in the database"""
    print("/delete")
    header = request.headers
    username, password = header.get("Authorization").split(":")

    auth = db.user_authentication(connection, username, password)

    if auth == False:
        return 401

    user_id = request.args.get("user_id", None, int)

    if user_id == None:
        return 401  # "user_id parameter not provided"

    print(user_id)
    db.delete_rescue_user(connection, user_id)
    return jsonify({"message": "OK"}), 200


@app.route("/login", methods=["GET"])
def login_user():
    header = request.headers
    username, password = header.get("Authorization").split(":")
    print(header.get("Authorization"))

    auth = db.user_authentication(connection, username, password)

    if auth == False:
        return jsonify({"message": "ERROR: Unauthorized"}), 401

    user_id = db.get_user_id(connection, username, password)
    return jsonify({"message": "OK: Authorized", "user_id": user_id}), 200


@app.route("/get/users", methods=["GET"])
def get_users():
    """Get location of users"""
    header = request.headers
    username, password = header.get("Authorization").split(":")

    auth = db.user_authentication(connection, username, password)

    users = db.get_list_from_database(connection, "dev_id,first_name,last_name", "users")
    locations = db.get_latest_locations(connection, time3DaysAgo)
    result_table = []

    for user in users:
        for data in locations:
            if user[0] == data[0]:
                entry = []
                entry.append(user[0])
                entry.append(user[1])
                entry.append(user[2])
                gps = data[2].split(",")
                entry.append(gps[0])
                entry.append(gps[1])
                result_table.append(entry)

    if auth:
        response = jsonify(result_table), 200
    else:
        response = jsonify({"message": "ERROR: Unauthorized"}), 401
    return response


@app.route("/get/help", methods=["GET"])
def get_help():
    header = request.headers
    username, password = header.get("Authorization").split(":")

    auth = db.user_authentication(connection, username, password)

    help_requesters = db.get_list_from_database(connection, "dev_id, timestamp, gpscoord", "help_requests")
    users = db.get_list_from_database(connection, "dev_id, first_name, last_name", "users")
    result_table = []

    for data in help_requesters:
        for user in users:
            if user[0] == data[0]:
                entry = []
                entry.append(user[0])
                entry.append(user[1])
                entry.append(user[2])
                entry.append(data[1])
                gps = data[2].split(",")
                entry.append(gps[0])
                entry.append(gps[1])
                result_table.append(entry)

    if auth:
        response = jsonify(result_table), 200
    else:
        response = jsonify({"message": "ERROR: Unauthorized"}), 401
    return response


@app.route("/get/location", methods=["GET", "POST"])
def post_locations():
    header = request.headers
    username, password = header.get("Authorization").split(":")
    data = json.loads(request.data.decode())
    result = db.get_last_x_locations(connection, data["num_locations"], data["dev_id"])

    result_table = []

    for location in result:
        entry = []
        entry.append(location[0])
        entry.append(location[1])
        gps = location[2].split(",")
        entry.append(gps[0])
        entry.append(gps[1])
        result_table.append(entry)

    auth = db.user_authentication(connection, username, password)

    if auth:
        response = jsonify(result_table), 200
    else:
        response = jsonify({"message": "ERROR: Unauthorized"}), 401
    return response


@app.after_request
def after_request(response):
    header = response.headers
    header["Access-Control-Allow-Origin"] = "*"
    header["Access-Control-Allow-Headers"] = "*"
    # Other headers can be added here if required
    return response


if __name__ == "__main__":
    #print(f"App.py started correctly")
    serve(app, listen="*:3002")
