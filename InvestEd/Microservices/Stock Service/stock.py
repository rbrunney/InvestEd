import yfinance as yf


class Stock:
    def __init__(self, ticker : str):
        self.ticker = yf.Ticker(ticker)

    def get_current_price(self):
        return self.ticker.info['currentPrice']
    
    def get_basic_info(self):
        pass

    def get_earnings_call(self):
        pass

    def get_news(self):
        pass

    def get_moving_average(self):
        pass

