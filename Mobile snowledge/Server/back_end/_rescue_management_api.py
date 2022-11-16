#!/bin/env python
import os
import sys
import sqlite3
import _database as db
from flask import Flask, jsonify, request
from flask_cors import CORS, cross_origin
from time import time
from waitress import serve

time3DaysAgo = int(time()) - 259200

connection = db.connect_to_database()

app = Flask(__name__)
cors = CORS(app)

# test
# 1 GET Login
@app.route('/rescue_login', methods=['GET'])

def rescue_login_user():
    """ 
    Toimii, jos käyttäjä oikein ja salasana oikein. 
    Tietokannassa tällä hetkellä voi olla useita samannimisiä käyttäjiä
    ja sama salasana nii vähä mysteeri kumpaa käyttää
    PYSTYY DEMOAMAAN
    """
    header = request.headers
    username, password = header.get('Authorization').split(':')

    auth = db.rescue_user_authentication(connection, username, password)

    if auth:
        response = jsonify({"message": "OK: Authorized"}), 200
    else:
        response = jsonify({"message": "ERROR: Unauthorized"}), 401
    return response



# 2. GET Users
@app.route('/users', methods=['GET'])
def rescue_get_users():
    """ 
    Tää pitäs olla jone sul toimivana
    """

    # lisää tälläinen tarkastin auth varten 
#    header = request.headers
#    username, password = header.get('Authorization').split(':')

#    auth = db.rescue_user_authentication(connection, username, password)

#    if auth:
#        response = jsonify({"message": "OK: Authorized"}), 200
#    else:
#        response = jsonify({"message": "ERROR: Unauthorized"}), 401
#    return response
    ##########

    if not request.is_json:
        return "The content isn't of type JSON"
    print("json ok")
    user = request.get_json()
    user_id = user.get('user_id')
    username = user.get('username')
    password = user.get('password')
    is_admin = user.get('is_admin')

    list = get_list_from_database("user_id, username, password, is_admin,", "rescue")
    result_table = []
    for i in list:
        for user in list:
            if user[0] == list[0]:
                entry = []
                entry.append(user[0])
                entry.append(user[1])
                entry.append(user[2])
                entry.append(list[1])
        result_table.append(entry)
## errorriiia
    if is_admin == 1:
        response = jsonify(result_table), 200
    else:
        response = jsonify({"message": "ERROR: Unauthorized: Not admin"}), 401

    return response
    
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


# 3 POST user
@app.route('/register', methods=['POST'])
def register_user():
    """
    Toimii,
    tekee authentikoinnin oikein ja tarkistaa onko käyttäjä kirjautunut sisälle
    ei kuitenkaan tarkista mitenkää onko käyttäjä admin -> jatkokehitys
    pitää lisätä tarkastin siihen, että onko olemassa saman niminen käyttäjä. -> jatkokehitys
    """
    header = request.headers
    username, password = header.get('Authorization').split(':')

    auth = db.rescue_user_authentication(connection, username, password)

    if auth:
        response = jsonify({"message": "OK: Authorized, User registered"}), 200
        if not request.is_json:
            return "The content isn't of type JSON"
        print("json ok")
        user = request.get_json()
        username = user.get('username')
        password = user.get('password')
        is_admin = user.get('is_admin')
    
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
def modify_user():
    """
    Toimii tällä hetkellä ainoastaan kun käyttäjä vaihtaa kaikki tiedot
    Esim jos jotain jättää tyhjäksi nii tietokannassaki tyhjää
    teen tähän tarkistimen, että se ei muokkaa tyhjiä asioita
    autentikointi toimii kuitenkin
    demossa kannattaa melkeen muokata aina kaikkia osia
    """
    msg = ''
    if not request.is_json:
        return "The content isn't of type JSON"
    print("json ok")
    header = request.headers
    username, password = header.get('Authorization').split(':')

    auth = db.rescue_user_authentication(connection, username, password)

    if auth:
        response = jsonify({"message": "OK: Authorized, User modified"}), 200
        user = request.get_json()
        user_id = user.get('user_id')
        username = user.get('username')
        password = user.get('password')
        is_admin = user.get('is_admin')
        
        # tähän teen tarkastimen, joka estää NONE valueiden menemisen 
        query = f'UPDATE rescue SET username = "{username}", password = "{password}", is_admin = "{is_admin}" WHERE user_id = "{user_id}"'
        
    else: 
        response = jsonify({"message": "ERROR: Unauthorized, user not modified"}), 401
        return response
    
    cur = connection.cursor()
    cur.execute(query)
    connection.commit()
    return response


# postman testausta varten json. Muista laittaa headereissa päällee
# Key = Content type, Value = application/json
"""{
    "username": "Sampo",
    "password": "snow",
    "is_admin": 1
}"""


# 5 DELETE users
@app.route('/delete', methods=['DELETE'])
def delete_user():
    """
    toimii,
    autentikointi toimii
    -> pitää lisätä admin tarkastus -> jatkokehitys
    """
    header = request.headers
    username, password = header.get('Authorization').split(':')

    auth = db.rescue_user_authentication(connection, username, password)

    if auth:
        response = jsonify({"message": "OK: Authorized, Delete user"}), 200
        msg = ''
        if not request.is_json:
            return "The content isn't of type JSON"
        print("json ok")
        user = request.get_json()
        user_id = user.get('user_id')
        query = f'DELETE FROM rescue WHERE user_id = {user_id};'
        cur = connection.cursor()
        cur.execute(query)
        connection.commit()
    else:
        response = jsonify({"message": "ERROR: Unauthorized, not deleted"}), 401
        return response
    return response

# to test delete on postman
"""{
    "user_id": "5",
}"""


@app.after_request
def rescue_after_request(response):
    header = response.headers
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Allow-Headers'] = '*'
    # Other headers can be added here if required
    return response


def get_list_from_database(data, source):
    sql = '''SELECT {} FROM {};'''.format(data, source)

    cur = connection.cursor()
    cur.execute(sql)
    _list = cur.fetchall()

    return _list


if __name__ == "__main__":
    print(f"Rescue management started correctly")
    serve(app, port=3003)


