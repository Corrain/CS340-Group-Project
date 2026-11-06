import mysql.connector
from coffeeshop_database import CoffeeShopDAO

# replace with your actual DB credentials
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='',
    database='cs340_curracar'
)
cursor = conn.cursor()
queries = CoffeeShopDAO(cursor, conn)
