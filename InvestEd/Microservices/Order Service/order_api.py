from flask import Flask, request
import jwt
import os

order_api = Flask(__name__)

@order_api.route('/invested_order/place_order', methods=['POST'])
def place_order():
    return decode_json_web_token(request.headers["authorization"].replace('Bearer ', ''))

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
    decoded_jwt = jwt.decode(
            jwt=incoming_jwt, 
            key=str(os.getenv('JWT_SECERT')), 
            algorithms=[str(os.getenv('JWT_ALGORITHM'))], 
            issuer=str(os.getenv('JWT_ISSUER'))
    )
    return decoded_jwt
    

if __name__ == '__main__':
    order_api.run(host='0.0.0.0', port=105)