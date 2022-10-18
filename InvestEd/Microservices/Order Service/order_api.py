from flask import Flask, request
from datetime import datetime
import jwt
import os

order_api = Flask(__name__)

@order_api.route('/invested_order/place_order', methods=['POST'])
def place_order():
    decoded_jwt = decode_json_web_token(request.headers["authorization"].replace('Bearer ', ''))

    # Check to see if it contains error message if so then just return error
    if(decoded_jwt.keys().__contains__ == 'message'): 
        return decoded_jwt
    
    # Make Order and place in database 

    return decoded_jwt
    

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