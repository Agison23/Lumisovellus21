#!/bin/env python
import os
import pathlib
import sqlite3
import time
from sqlite3 import Error
from _database import check_if_entry_exists
import _database as db


def rescue_user_authentication(connection, username, password):
    """Used for rescue side user authentication"""
    correct = False
    sql = """SELECT password FROM rescue WHERE username=?;"""

    cur = connection.cursor()
    cur.execute(sql, (username,))
    _password = cur.fetchall()
    if _password:
        _password = _password[0][0]
        correct = password == _password

    return correct


def delete_rescue_users(connection):
    sql = """SELECT user_id FROM rescue;"""
    delete_sql = """DELETE FROM rescue WHERE user_id = ?;"""

    cur = connection.cursor()
    cur.execute(sql)
    user_ids = cur.fetchall()

    for id in user_ids:
        _, exists = check_if_entry_exists(
            connection, "data", "user_id", "user_id", id[0], False
        )
        if not exists:
            cur.execute(delete_sql, (id[0],))

    return


### tarviiko?????
def rescue_create_user_entry(connection, user):
    sql = """ INSERT INTO users(dev_id,first_name,last_name,ip_address)
              VALUES (?,?,?,?) """

    cur = connection.cursor()
    cur.execute(sql, user)
    connection.commit()
    return user[0]


"""
def create_connection(path):
    connection = None
    try:
        connection = sqlite3.connect(path, check_same_thread=False)
    except Error as e:
        print(f"The error '{e}' occurred")

    return connection

def connect_to_database():
    path = pathlib.Path(__file__).parent.resolve()
    path = str(str(path) + '/db/')

    if not os.path.exists(path):
        os.makedirs(path)
        connection = create_connection(path+'database')
    else:
        connection = create_connection(path+'database')

    return connection
"""


# how to generate unique user_id?
