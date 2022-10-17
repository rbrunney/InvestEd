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

    def get_earnings_call(self, year):
        request = requests.get(f'https://www.alphavantage.co/query?function=EARNINGS&symbol={self.ticker}&apikey={os.getenv("ALPHA_VANTAGE_API_KEY")}')
        
        # Checking to see if the ticker is valid
        try:
            quartley_earnings = request.json()['quarterlyEarnings']
        except:
            return 'Ticker Invalid'

        # Going through all of the quartly earnings to see if it has the year we are looking for!
        found_earnings = []
        for quarter in quartley_earnings:
            if (quarter['fiscalDateEnding'].startswith(str(year))): 
                quarter_info = {
                    'expected': quarter['estimatedEPS'],
                    'reported' : quarter['reportedEPS'],
                    'surprise' : quarter['surprise']
                }

                found_earnings.append(quarter_info)       

        # Making final earning calls dictionary, need to loop in reverse so that way we got the quarters in the right order
        final_earning_calls = {}
        for index, quater_earning_calls in enumerate(reversed(found_earnings)):
            final_earning_calls[f'Q{index + 1}'] = quater_earning_calls

        return final_earning_calls
        
    def get_news(self):
        request = requests.get(f'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&tickers={self.ticker}&topics=technology&sort=LATEST&apikey={os.getenv("ALPHA_VANTAGE_API_KEY")}')
        fetched_data = request.json()
        return fetched_data
        
    def get_moving_average(self):
        pass

