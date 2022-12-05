#!/bin/env python
import _database as db
from flask import Flask, jsonify, request
from flask_cors import CORS, cross_origin
from time import time
from waitress import serve

connection = db.connect_to_database()

app = Flask(__name__)
cors = CORS(app)


@app.route('/users', methods=['GET'])
def rescue_get_users():
    header = request.headers
    username, password = header.get('Authorization').split(':')
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

    query = f'SELECT * FROM rescue;'
    cur = connection.cursor()
    cur.execute(query)
    response= cur.fetchall()

    result_table = []
    for i in response:
        result_table.append({"user_id": i[0], "username": i[1], "is_admin": i[3]})
        
    return jsonify(result_table)
    
"""
    cur = connection.cursor()
    cur.execute(query)
    connection.commit()

    return jsonify(request.get_json())"""

# postman testausta varten json. Muista laittaa headereissa päällee
# Key = Content type, Value = application/json
"""
{
    "user_id": "5",
    "username": "Sampo",
    "password": "snowledge",
    "is_admin": 0
}
"""


@app.route('/register', methods=['POST'])
def register_user():
    """
    Used to create a new user for the Rescue side
    """
    header = request.headers
    username, password = header.get('Authorization').split(':')

    auth = db.user_authentication(connection, username, password)

    if auth:
        if not request.is_json:
            return "The content isn't of type JSON"
        print("json ok")
        user = request.get_json()
        username = user.get('username')
        password = user.get('password')
        is_admin = user.get('is_admin')

        # check if some user already have requested username
        is_username_reserved = db.check_if_username_exists(connection, username)
        if is_username_reserved != None:
            response = jsonify({"message": "ERROR: Username already exists"}), 409
            print("Käyttäjänimi varattuna")
            return response
        else:
            print("käyttäjänimeä ei ole varattu")
            response = jsonify({"message": "OK: Authorized, User registered"}), 200
            query = f'INSERT INTO rescue (username, password, is_admin)\
                        VALUES ("{username}", "{password}", "{is_admin}");'

            cur = connection.cursor()
            cur.execute(query)
            connection.commit()
    else:
        response = jsonify({"message": "ERROR: Unauthorized, not registered"}), 401
        return response
    return response


# postman testausta varten json. Muista laittaa headereissa päällee
# Key = Content type, Value = application/json
"""
{
    "username": "Sampo",
    "password": "snow",
    "is_admin": "1"
}
"""


# 4 PUT users
@app.route('/modify', methods=['PUT'])
@cross_origin(methods=['PUT'])
def modify_user():
    """
    Used to edit user data. 
    For example, if you want to change the 
    user's password, username or admin rights.
    """
    if not request.is_json:
        return jsonify({"message": "ERROR: Bad request"}), 401

    header = request.headers
    username, password = header.get('Authorization').split(':')

    auth = db.user_authentication(connection, username, password)

    if auth == False:
        return jsonify({"message": "ERROR: Unauthorized, user not modified"}), 401
    
    user = request.get_json()
    print(user)
    user_id = user.get('user_id')
    username = user.get('username')
    password = user.get('password')
    is_admin = user.get('is_admin')

    #check if the user wants to change their username
    is_username_changed = db.check_is_same_username(connection, user_id, username)
    # check if username is already reserved for another user
    is_username_reserved = db.check_if_username_exists(connection, username)

    if is_username_changed == None:
        print("KÄYTTÄJÄNIMI HALUTAAN VAIHTAA")
        if is_username_reserved != None:
            response = jsonify({"message": "ERROR: Username already exists"}), 409
            print("Käyttäjänimi varattuna")
            return response
        
        query = f'UPDATE rescue SET '
        if(username != None):
            query += f'username = "{username}",'
        if(password != None):
            query += f'password = "{password}",'
        if(is_admin != None):
            query += f'is_admin = "{is_admin}",'

    else:
        print("KÄYTTÄJÄNIMEÄ EI HALUTA VAIHTAA")
        print("käyttäjänimeä ei ole varattu")
        if user_id == None or (username == None and password == None and is_admin == None):
            response = jsonify({"message": "ERROR: 401"}), 401
            return response
            
        query = f'UPDATE rescue SET '
        if(username != None):
            query += f'username = "{username}",'
        if(password != None):
            query += f'password = "{password}",'
        if(is_admin != None):
            query += f'is_admin = "{is_admin}",'
    
        
    #viimenen pilkku pois
 
    query = query[:-1]
    query += f'WHERE user_id = {user_id}'
    print(query)    
    cur = connection.cursor()
    cur.execute(query)
    connection.commit()
   
    return jsonify({"message": "OK"}), 200


# postman testausta varten json. Muista laittaa headereissa päällee
# Key = Content type, Value = application/json
"""{
    "username": "Sampo",
    "password": "snow",
    "is_admin": 1
}"""


@app.route('/delete', methods=['DELETE'])
@cross_origin(methods=['DELETE'])
def delete_user():
    """ Used to delete user data from the rescue table in the database """
    print("/delete")
    header = request.headers
    username, password = header.get('Authorization').split(':')

    auth = db.user_authentication(connection, username, password)

    if auth == False:
        return 401
        
    user_id = request.args.get('user_id', None, int)
    
    if user_id == None:
        return 401 #"user_id parameter not provided"

    print(user_id);
    query = f'DELETE FROM rescue WHERE user_id = {user_id};'
    cur = connection.cursor()
    cur.execute(query)
    connection.commit()

    return  jsonify({"message": "OK"}), 200

@app.after_request
def rescue_after_request(response):
    header = response.headers
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Allow-Headers'] = '*'

    # Other headers can be added here if required
    return response

if __name__ == "__main__":
    print(f"Rescue management started correctly")
    serve(app, port=3003)


