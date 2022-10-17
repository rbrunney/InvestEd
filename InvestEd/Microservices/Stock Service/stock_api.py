from flask import Flask

import stock
from datetime import datetime

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
        'results' : {
            'ticker' : fetched_data['Symbol'],
            'open' : '',
            'high' : '',
            'low' : '',
            '52_week_high' : float(fetched_data['52WeekHigh']),
            '52_week_low' : float(fetched_data['52WeekLow']),
            'volume' : '',
            'market_cap' : int(fetched_data['MarketCapitalization']),
            'pe_ratio' : float(fetched_data['PERatio']),
            'dividend_yeild' : float(fetched_data['DividendYield']),
            'description' : fetched_data['Description'],
            'ceo' : '',
            'hq_city' : fetched_data['Address'].split(',')[1].replace(' ', ''),
            'hq_state' : fetched_data['Address'].split(',')[2].replace(' ', ''),
            'sector' : fetched_data['Sector'],
            'industry' : fetched_data['Industry'],
            'num_employees' : '',
            'year_founded' : '',
        },
        'date-time' : datetime.now()
    }

@stock_api.route("/invested_stock/<ticker>/earning_calls/<year>", methods=["GET"])
def getTickerEarningCalls(ticker: str, year: int):
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
    
    return fetched_data


@stock_api.route("/invested_stock/{ticker}/moving_avg", methods=["GET"])
def getTickerMovingAverage():
    pass

def failed_fetch(ticker):
    return {
        'message' : f'Stock {ticker} Does Not Exist!',
        'date-time' : datetime.now()
    }

if __name__ == '__main__':
    stock_api.run(host='0.0.0.0', port=105)
