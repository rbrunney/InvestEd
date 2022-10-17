from flask import Flask

order_api = Flask(__name__)

@order_api.route('/invested_order/place_order', methods=['POST'])
def place_order():
    pass

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

if __name__ == '__main__':
    order_api.run(host='0.0.0.0', port=105)