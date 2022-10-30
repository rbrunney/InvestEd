from polygon import RESTClient
from datetime import datetime as current_dt
import datetime as dt
import news_article as na
import requests
import os
import sys

class Stock:

    MAX_MOVING_PERIOD = 50

    def __init__(self, ticker : str):
        self.ticker = ticker
        self.client = RESTClient(os.getenv("POLYGON_API_KEY"))

    def get_current_price(self):

        def check_date(current_date=current_dt.today()):
            saturday = 5
            sunday = 6
            date_value = current_date.weekday()

            if date_value == saturday:
                return current_date - dt.timedelta(days=1)
            elif date_value == sunday:
                return current_date - dt.timedelta(days=2)

            return current_date
        
        # Getting the date and then checking to get the the current price, at least close to it
        date_to_retrieve = check_date()
        aggs = self.client.get_aggs(self.ticker, 1, "day", date_to_retrieve, date_to_retrieve)
        return aggs[0].vwap
    
    def get_data_points(self, period):

        def check_date(current_date=current_dt.today()):
            saturday = 5
            sunday = 6
            date_value = current_date.weekday()

            if date_value == saturday:
                return current_date - dt.timedelta(days=1)
            elif date_value == sunday:
                return current_date - dt.timedelta(days=2)

            return current_date

        def period_data_points(from_date, end_date, timespan):
            aggregates = self.client.get_aggs(self.ticker, multiplier=1, from_=from_date, to=end_date, timespan=timespan,limit=250)
            data_points = []

            for aggreagate in aggregates:
                data_points.append(aggreagate.vwap)
            
            return data_points

        if period == "DAY":
            return period_data_points(check_date(), check_date(), "minute")
        elif period == "WEEK":
            return period_data_points(check_date() - dt.timedelta(days=7), check_date(), "minute")
        elif period == "MONTH":
            return period_data_points(check_date() - dt.timedelta(days=31), check_date(), "minute")
        elif period == "3-MONTH":
            return period_data_points(check_date() - dt.timedelta(days=93), check_date(), "minute")
        elif period == "YEAR":
            return period_data_points(check_date() - dt.timedelta(days=365), check_date(), "day")
        elif period == "5-YEAR":
            return period_data_points(check_date() - dt.timedelta(days=1825), check_date(), "day")
        else:
            # Return 400 so we know we have to send a bad request
            return 400
    
    
    def get_basic_info(self):

        basic_info = {}

        # Getting first request data for part of basic info
        first_request = requests.get(f'https://www.alphavantage.co/query?function=OVERVIEW&symbol={self.ticker}&apikey={os.getenv("ALPHA_VANTAGE_API_KEY")}')
        fetched_data = first_request.json()

        # Adding information into basic_info
        basic_info['ticker'] = fetched_data['Symbol']
        basic_info['52_week_high'] = float(fetched_data['52WeekHigh'])
        basic_info['52_week_low'] = float(fetched_data['52WeekLow'])
        basic_info['market_cap'] = int(fetched_data['MarketCapitalization'])
        basic_info['pe_ratio'] = float(fetched_data['PERatio'])
        basic_info['dividend_yeild'] = float(fetched_data['DividendYield'])
        basic_info['description'] = fetched_data['Description']
        basic_info['hq_city'] = fetched_data['Address'].split(',')[1].replace(' ', '')
        basic_info['hq_state'] = fetched_data['Address'].split(',')[2].replace(' ', '')
        basic_info['sector'] = fetched_data['Sector']
        basic_info['industry'] = fetched_data['Industry']

        # Making second request for current days open, high, and low
        second_request = requests.get(f'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol={self.ticker}&interval=5min&apikey={os.getenv("ALPHA_VANTAGE_API_KEY")}')
        fetched_data = second_request.json()

        open = 0
        high = 0
        low = sys.maxsize
        volume = 0

        # Need to loop through all keys
        for key in fetched_data["Time Series (5min)"].keys():
            if (open == 0):
                open = float(fetched_data["Time Series (5min)"][key]["1. open"])

            # Check to see if its hit the highest yet
            if (high < float(fetched_data["Time Series (5min)"][key]["2. high"])):
                high = float(fetched_data["Time Series (5min)"][key]["2. high"])

            # Check to see if its hit the lowest yet
            if (low > float(fetched_data["Time Series (5min)"][key]["3. low"])):
                low = float(fetched_data["Time Series (5min)"][key]["3. low"])

            # Adding volume traded to the total volue traded
            volume += float(fetched_data["Time Series (5min)"][key]["5. volume"])
        
        # Adding open, high, low, and volume to basic information
        basic_info['open'] = open
        basic_info['high'] = high
        basic_info['low'] = low
        basic_info['volume'] = volume

        return basic_info

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

        recent_news_articles = []

        for article in fetched_data['feed']:
            recent_news_articles.append(na.NewsArticle(
                    article['title'], 
                    article['authors'],
                    article['source'], 
                    article['time_published'],
                    article['summary'],
                    article['url'],
                    article['banner_image']
                ).to_json()
            )

        return recent_news_articles
        
    def get_moving_average(self, moving_period):

        moving_period = int(moving_period)

        if(moving_period > self.MAX_MOVING_PERIOD):
            return 'Moving Period Error'
        
        request = requests.get(f'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol={self.ticker}&apikey={os.getenv("ALPHA_VANTAGE_API_KEY")}')
        fetched_data = request.json()

        # Check to see if the current day use date.today() is on list, if so fetched its current price. To use for calculation
        # Else keep checking for previous x days bases on moving_period
        moving_avg_data_points = []

        for index in range(0, moving_period):
            moving_avg_price = 0

            # Check to see if first one, because then we need to get the current price other wise get the previous day
            if(index == 0):
                moving_avg_price = float(requests.get(f'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol={self.ticker}&apikey={os.getenv("ALPHA_VANTAGE_API_KEY")}').json()['Global Quote']['05. price'])
                for key in list(fetched_data['Time Series (Daily)'].keys())[index: index + (moving_period - 1)]:
                    moving_avg_price += float(fetched_data['Time Series (Daily)'][key]['4. close'])

                moving_avg_data_points.append(moving_avg_price / moving_period)
            else:
                # Need to get the first index all the way to the end index of the moving average so we can calculate
                for key in list(fetched_data['Time Series (Daily)'].keys())[index: index + moving_period]:
                    moving_avg_price += float(fetched_data['Time Series (Daily)'][key]['4. close'])

                moving_avg_data_points.append(moving_avg_price / moving_period)

        return {
            'moving_avg_data' : moving_avg_data_points
        }
    
print(Stock("VOO").get_data_points(""))