from datetime import datetime
from flask import Flask, request
import stock

stock_api = Flask(__name__)

@stock_api.route("/invested_stock/<ticker>/price", methods=["GET"])
def getTickerPrice(ticker:str):
    fetched_data = stock.Stock(ticker).get_current_price()

    if(fetched_data == {}):
        return failed_fetch(ticker), 404

    return {
        'message' : f'{ticker} Price Successfully Fetched!',
        'results' : {
            'current_price' : stock.Stock(ticker).get_current_price()
        },
        'date-time' : datetime.now()
    }

@stock_api.route("/invested_stock/<ticker>/basic_info", methods=["GET"])
def getTickerBasicInfo(ticker: str):
    fetched_data = stock.Stock(ticker).get_basic_info()

    if(fetched_data == {}):
        return failed_fetch(ticker), 404

    return {
        'message' : f'{ticker} Basic Information Successfuly Fetched!',
        'results' : fetched_data,
        'date-time' : datetime.now()
    }

@stock_api.route("/invested_stock/<ticker>/earning_calls", methods=["GET"])
def getTickerEarningCalls(ticker: str):
    year = request.args['year']
    fetched_data = stock.Stock(ticker).get_earnings_call(year)

    if(fetched_data == 'Ticker Invalid'):
        return failed_fetch(ticker), 404
    elif(fetched_data == {}):
        return {
            'message' : f'{year} is not a valid year',
            'date-time' : datetime.now()
        }, 404
    
    return {
        'message' : f'{ticker} Earning Calls Successfuly Fetched!',
        'results' : {
            'year' : year,
            'earning_calls' : fetched_data
        },
        'date-time' : datetime.now()
    }

@stock_api.route("/invested_stock/<ticker>/news", methods=["GET"])
def getTickerNews(ticker:str):
    fetched_data = stock.Stock(ticker).get_news()

    if(fetched_data == {}):
        return failed_fetch(ticker), 404
    
    return {
        'message' : f'{ticker} News Successfuly Fetched!',
        'results' : {
            'recent_news' : fetched_data
        },
        'date-time' : datetime.now()
    }


@stock_api.route("/invested_stock/<ticker>/moving_avg", methods=["GET"])
def getTickerMovingAverage(ticker: str):
    fetched_data = stock.Stock(ticker).get_moving_average(request.args['moving_period'])

    if(fetched_data == {}):
        return failed_fetch(ticker), 404
    
    return fetched_data


def failed_fetch(ticker):
    return {
        'message' : f'Stock {ticker} Does Not Exist!',
        'date-time' : datetime.now()
    }

if __name__ == '__main__':
    stock_api.run(host='0.0.0.0', port=105)
