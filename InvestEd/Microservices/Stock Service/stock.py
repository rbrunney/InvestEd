import requests
import os

class Stock:
    def __init__(self, ticker : str):
        self.ticker = ticker

    def get_current_price(self):
        request = requests.get(f'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol={self.ticker}&apikey={os.getenv("ALPHA_VANTAGE_API_KEY")}')
        fetched_data = request.json()
        return float(fetched_data['Global Quote']['05. price'])
    
    
    def get_basic_info(self):
        request = requests.get(f'https://www.alphavantage.co/query?function=OVERVIEW&symbol={self.ticker}&apikey={os.getenv("ALPHA_VANTAGE_API_KEY")}')
        fetched_data = request.json()
        return fetched_data

    def get_earnings_call(self):
        pass

    def get_news(self):
        request = requests.get(f'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&tickers={self.ticker}&topics=technology&sort=LATEST&apikey={os.getenv("ALPHA_VANTAGE_API_KEY")}')
        fetched_data = request.json()
        return fetched_data
        
    def get_moving_average(self):
        pass

