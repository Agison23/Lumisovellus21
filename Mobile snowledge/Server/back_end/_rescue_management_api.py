import _database as db
from flask import Flask, jsonify, request
from flask_cors import CORS, cross_origin
from time import time
from waitress import serve

connection = db.connect_to_database()

app = Flask(__name__)
cors = CORS(app)

# 2. GET Users
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

    auth = db.user_authentication(connection, username, password)

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
@cross_origin(methods=['PUT'])
def modify_user():
    """
    Toimii tällä hetkellä ainoastaan kun käyttäjä vaihtaa kaikki tiedot
    Esim jos jotain jättää tyhjäksi nii tietokannassaki tyhjää
    teen tähän tarkistimen, että se ei muokkaa tyhjiä asioita
    autentikointi toimii kuitenkin
    demossa kannattaa melkeen muokata aina kaikkia osia
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

    if user_id == None or (username == None and password == None and is_admin == None):
        return 401

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


# 5 DELETE users
@app.route('/delete', methods=['DELETE'])
@cross_origin(methods=['DELETE'])
def delete_user():
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


