import requests

import json


class Stock:
    def __init__(self, ticker : str):
        self.ticker = ticker

    def get_current_price(self):
        print(json.dumps(getQuotes('AAPL'), indent=2))
    
    def get_basic_info(self):
        pass

    def get_earnings_call(self):
        pass

    def get_news(self):
        pass

    def get_moving_average(self):
        pass

