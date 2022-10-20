from flask import Flask, request
import order_sql_commands as mysql_con
from datetime import datetime
import order
import json
import jwt
import os

order_api = Flask(__name__)
 
@order_api.route('/invested_order/basic_order', methods=['POST'])
def place_order():
    decoded_jwt = decode_json_web_token(request.headers["authorization"].replace('Bearer ', ''))
    # Check to see if it contains error message if so then just return error
    if(list(decoded_jwt.keys())[0] == 'message'): 
        return decoded_jwt
    
    # Make Order and place in RabbitMQ
    order_info = json.loads(request.data)

    try:
        new_order = order.BasicOrder(decoded_jwt['sub'], order_info['ticker'], order_info['trade_type'], order_info['stock_quantity'])
        mysql_con.insert_basic_order(new_order)
    except KeyError as ke:
        return {
            'message' : '[ERROR] Invalid Key in Request Body',
            'date-time' : datetime.now()
        }, 400
        
    return {
        'message' : f'{order_info["ticker"]} Order Placed Successully!',
        'results' : {
            'order_id' : new_order.id
        },
        'date-time' : datetime.now()
    }, 201
    

@order_api.route('/invested_order/get_order_info/<order_id>', methods=['GET'])
def get_order(order_id: str):
    pass

@order_api.route('/invested_order/get_all_orders', methods=['GET'])
def get_all_orders():
    pass

@order_api.route('/invested_order/cancel_order/<order_id>', methods=['DELETE'])
def cancel_order(order_info: str):
    pass

@order_api.route('/invested_order/cancel_all_orders', methods=['DELETE'])
def cancel_all_orders():
    pass

def decode_json_web_token(incoming_jwt:str):

    try:
        decoded_jwt = jwt.decode(
            jwt=incoming_jwt, 
            key=str(os.getenv('JWT_SECRET')), 
            algorithms=[str(os.getenv('JWT_ALGORITHM'))], 
        )
    except jwt.ExpiredSignatureError as ese:
        return {
            'message' : f'[ERROR] {str(ese)}',
            'date-time' : datetime.now()
        }
    except jwt.DecodeError as de:
        return {
            'message' : f'[ERROR] {str(de)}',
            'date-time' : datetime.now()
        }
    
    return decoded_jwt
    

if __name__ == '__main__':
    order_api.run(host='0.0.0.0', port=105)