#!/bin/env python
import os
import sys
import sqlite3
import _database as db
# import _rescue_database as rdb
from flask import Flask, jsonify, request
from flask_cors import CORS, cross_origin
from time import time
from waitress import serve

time3DaysAgo = int(time()) - 259200

connection = db.connect_to_database()

app = Flask(__name__)
cors = CORS(app)


# 1 GET Login
@app.route('/rescue_login', methods=['GET'])

def rescue_login_user():
    """ 
    This function is used for user login to rescue side 
    tää on vähän mysteeri, että toimiiko vai ei
    en oo ehtinyt paneutua asiaan mut erroia ei anna. 
    Ainoastaan tuo user authentication ei toimi tän kaa vielä
    en oo toki sitä kovinkaa vielä yrittäny tehdä
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
    Tämä funktio on kesken vielä, aloin äsken tekemään tätä ku sain idean,
    tällä hetkellä tää tarkistaa nyt sen, että onko admin vai ei ja sen mukaan printtaa
    tarvii vielä käyttäjän authenticoinnin
    Tätä jatkan illalla,
    """
    if not request.is_json:
        return "The content isn't of type JSON"
    print("json ok")
    user = request.get_json()
    user_id = user.get('user_id')
    username = user.get('username')
    password = user.get('password')
    is_admin = user.get('is_admin')

    if is_admin == 1:
        query = f'SELECT * FROM rescue'
        db.rescue_users_from_db(connection)
        print("Admin")
    else:
        query = f'SELECT * FROM rescue WHERE user_id = "{user_id}"'
        print("Not admin")

    cur = connection.cursor()
    cur.execute(query)
    connection.commit()

    return jsonify(request.get_json())

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
    Tämä funktio toimii tällä hetkellä MUTTA
    ei kryptaa salasanaa, kuitenkin se luo uuden käyttäjän tietokantaan. 
    lisään tähän myöhemmin kryptauksen ku kerkeen,
    """
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

    return jsonify(request.get_json())


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
    """
    msg = ''
    if not request.is_json:
        return "The content isn't of type JSON"
    print("json ok")
    user = request.get_json()
    user_id = user.get('user_id')
    username = user.get('username')
    password = user.get('password')
    is_admin = user.get('is_admin')
    
    query = f'UPDATE rescue SET username = "{username}", password = "{password}", is_admin = "{is_admin}" WHERE user_id = "{user_id}"'
   
    cur = connection.cursor()
    cur.execute(query)
    connection.commit()

    return jsonify(request.get_json())

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
    tän pitäs olla käytännössä valmis
    tää poistaa ihan oikein ku syöttää user_id postmanilla. 
    """
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

    return jsonify(request.get_json())

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




if __name__ == "__main__":
    print(f"Rescue management started correctly")
    serve(app, port=3003)

"""
    header = request.headers
    username, password = header.get('Authorization').split(':')

    auth = db.rescue_user_authentication(connection, username, password)
# if authenticated then
    if auth:
        response = jsonify(result_table), 200
    else:
        response = jsonify({"message": "ERROR: Unauthorized"}), 401

    users = get_list_from_database("user_id,username,is_admin", "rescue")
    # else error code

    result_table = []

    
    return response"""

# tällä hetkellä ei taida olla tarpeellinen uudenlaisen get users toteutuksen takia
"""def get_list_from_database(data, source):
    sql = '''SELECT {} FROM {};'''.format(data, source)

    cur = connection.cursor()
    cur.execute(sql)
    _list = cur.fetchall()

    return _list"""