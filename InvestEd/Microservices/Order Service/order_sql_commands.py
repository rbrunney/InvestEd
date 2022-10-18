import mysql.connector
import os

class MySQLConnection:
    def __init__(self):
        self.connection = mysql.connector.connect(
                user=os.getenv('MYSQL_USER'), 
                password=os.getenv('MYSQL_PASSWORD'),
                host=os.getenv('MYSQL_HOST'),
                database=os.getenv('MYSQL_DB'),
                port=os.getenv('MYSQL_PORT')
        )

def insert_basic_order(order):
    current_connection = MySQLConnection()

    # Making SQL Statement
    cursor = current_connection.connection.cursor()
    sql = "INSERT INTO basic_order (id, user, ticker, trade_type, stock_qty) VALUES(%s, %s, %s, %s, %s)"
    values = (str(order.id), order.user, order.ticker, order.trade_type, order.stock_quantity)

    cursor.execute(sql, values)
    current_connection.connection.commit()

    current_connection.connection.close()
