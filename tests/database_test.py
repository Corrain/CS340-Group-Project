import mysql.connector
from db_connector import CoffeeShopQueries

# replace with your actual DB credentials
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='',
    database='cs340_curracar'
)
cursor = conn.cursor()
queries = CoffeeShopQueries(cursor, conn)
