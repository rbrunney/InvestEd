from flask import Flask

import stock
from datetime import datetime

stock_api = Flask(__name__)

@stock_api.route("/invested_stock/<ticker>/price", methods=["GET"])
def getTickerPrice(ticker:str):
    response = {
        'message' : f'{ticker} Price Successfuly Fetched!',
        'results' : {
            'current_price' : stock.Stock(ticker).get_current_price(),
            'status_code' : 200 
        },
        'date-time' : datetime.now() 
    }

    return response

@stock_api.route("/invested_stock/{ticker}/basic_info", methods=["GET"])
def getTickerBasicInfo():
    pass

@stock_api.route("/invested_stock/{ticker}/earning_calls", methods=["GET"])
def getTickerEarningCalls():
    pass

@stock_api.route("/invested_stock/{ticker}/news", methods=["GET"])
def getTickerNews():
    pass

@stock_api.route("/invested_stock/{ticker}/moving_avg", methods=["GET"])
def getTickerMovingAverage():
    pass

if __name__ == '__main__':
    stock_api.run(host='0.0.0.0', port=105)
