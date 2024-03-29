import py_eureka_client.eureka_client as eureka_client
from datetime import datetime
from flask import Flask, request
import web_scrape
import stock
import os

eureka_client.init(eureka_server="http://eureka:8761/eureka",
                   app_name="stock-service",
                   instance_port=105)

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

@stock_api.route("/invested_stock/<ticker>/logo", methods=["GET"])
def getTickerLogo(ticker:str):
    fetched_data = stock.Stock(ticker).get_ticker_logo()

    print(fetched_data)
    
    if(fetched_data == {}):
        return failed_fetch(ticker), 404

    return {
        'message' : f'{ticker} Price Successfully Fetched!',
        'results' : {
            'logo' : stock.Stock(ticker).get_ticker_logo()
        },
        'date-time' : datetime.now()
    }

@stock_api.route("/invested_stock/<ticker>/<period>", methods=["GET"])
def getPricePeriodTicker(ticker:str, period:str):
    fetched_data = stock.Stock(ticker).get_data_points(period)

    if(fetched_data == 400):
        return failed_fetch(ticker), 404
    
    return {
        'message' : f'{ticker} Price Period Successfully Fetched!',
        'results' : {
            'period_info' : fetched_data
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
    
    return {
        'message' : f'{ticker} Moving Average Successfuly Fetched!',
        'results' : fetched_data,
        'date-time' : datetime.now()
    }

@stock_api.route("/invested_stock/trending", methods=["GET"])
def getTrendingStocks():
    return {
        'message' : f'Trending Stocks Retreived',
        'results' :  web_scrape.get_trending_stocks(),
        'date-time' : datetime.now()
    }


def failed_fetch(ticker):
    return {
        'message' : f'Stock {ticker} Does Not Exist!',
        'date-time' : datetime.now()
    }

if __name__ == '__main__':
    from waitress import serve
    serve(stock_api, host='0.0.0.0', port=105)
