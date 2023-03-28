from datetime import date, datetime as current_dt
import datetime as dt
from pytz import timezone
import requests
import json
import os

class Stock:

    MAX_MOVING_PERIOD = 200

    def __init__(self, ticker : str):
        self.ticker = ticker
        self.polygon_key = 'pWnmnyskgOhWmfE226LWf4BH4vDY1i73'

    """
        Purpose
        -------
            To check the current date so that way we can get a valid date to use in a request when fetching for info
        Parameters
        ----------
            self: Stock
                Is just referincing that it belongs to the Stock Class
            current_date: datetime
                Gets the current date based off of the local machine
    """
    def check_date(self, current_date=current_dt.today()):
        
        def check_if_holiday():
            response = requests.get(f'https://api.polygon.io/v1/marketstatus/upcoming?apiKey={self.polygon_key}')
            holidays = json.loads(response.text)
            return holidays[0]['date']

        def is_before_open(check_time):
            return check_time < current_dt(check_time.year, check_time.month, check_time.day, 9, 30, 0, 0)
        
        # If it is a holiday, if so then we need to get yesterday's date
        if check_if_holiday() == str(current_date.date()):
            current_date = self.check_date(current_date - dt.timedelta(days=1))
           
        current_date_value = current_date.weekday()

        # Checking to see if it is the weekend
        if current_date_value == 5: # 5 Represents Saturday
            return current_date - dt.timedelta(days=1)
        elif current_date_value == 6:   # 6 Reporesents Sunday
            return current_date - dt.timedelta(days=2)

        if current_date.hour < 7:
            return current_date - dt.timedelta(days=1)
            
        return current_date

    """
        Purpose
        -------
            A method for retrieving the current price of the given ticker
        Parameters
        ----------
            self: Stock
                Is just referincing that it belongs to the Stock Class

    """
    def get_current_price(self):
        # Getting the date and then checking to get the the current price, at least close to it
        date_to_retrieve = self.check_date().date()

        # Fetching ticker price for the day
        response = requests.get(f'https://api.polygon.io/v2/aggs/ticker/{self.ticker}/range/1/day/{date_to_retrieve}/{date_to_retrieve}?adjusted=true&sort=asc&limit=1&apiKey={self.polygon_key}')
        current_price_info = json.loads(response.text)

        return current_price_info['results'][0]['c']

    
    """
        Purpose
        -------
            To retrieve data points to display to some front end over a given period
        Parameters
        ----------
            self: Stock
                Is just referincing that it belongs to the Stock Class
            period: str
                A string representing the period to retrieve from 
    """
    def get_data_points(self, period):

        # Getting the aggreagate data so we can return array of datapoints later
        def period_data_points(from_date, timespan, end_date=self.check_date().date()):
            response = requests.get(f'https://api.polygon.io/v2/aggs/ticker/{self.ticker}/range/1/{timespan}/{from_date}/{end_date}?adjusted=true&sort=asc&limit=600&apiKey={self.polygon_key}')
            aggregates = json.loads(response.text)['results']
            data_points = []

            for aggreagate in aggregates:
                # Getting closing prices for each aggreagate we get back
                data_points.append(aggreagate['vw'])

            data_points.append(self.get_current_price())
            
            return data_points
        
        current_date = self.check_date().date()

        if period == "DAY":
            return period_data_points(current_date, "minute")
        elif period == "WEEK":
            return period_data_points(current_date - dt.timedelta(days=7), "minute")
        elif period == "MONTH":
            return period_data_points(current_date - dt.timedelta(days=31), "minute")
        elif period == "3-MONTH":
            return period_data_points(current_date - dt.timedelta(days=93), "minute")
        elif period == "YEAR":
            return period_data_points(current_date - dt.timedelta(days=365), "day")
        elif period == "5-YEAR":
            return period_data_points(current_date - dt.timedelta(days=1825), "day")
        else:
            # Return 400 so we know we have to send a bad request
            return 400
    
    """
        Purpose
        -------
            To retrieve basic information about a ticker
        Parameters
        ----------
            self: Stock
                Is just referincing that it belongs to the Stock Class
    """
    
    def get_basic_info(self):

        # Making the neccessary requests to get the basic information
        response = requests.get(f'https://api.polygon.io/v3/reference/tickers/{self.ticker}?apiKey={self.polygon_key}')
        ticker_details = json.loads(response.text)

        response = requests.get(f'https://api.polygon.io/v3/reference/dividends?ticker={self.ticker}&apiKey={self.polygon_key}')
        dividend_details = json.loads(response.text)

        response = requests.get(f'https://api.polygon.io/v1/open-close/{self.ticker}/{self.check_date().date()}?adjusted=true&apiKey={self.polygon_key}')
        open_close_details = json.loads(response.text)

        response = requests.get(f'https://api.polygon.io/v2/aggs/ticker/{self.ticker}/prev?adjusted=true&apiKey={self.polygon_key}')
        previous_close_details = json.loads(response.text)

        # Generating ticker information 
        basic_info = {
            'ticker': self.ticker,
            'name' : ticker_details['results']['name'],
            'list_date': ticker_details['results']['list_date'],
            'open' : open_close_details['open'],
            'high' : open_close_details['high'],
            'low' : open_close_details['low'],
            'volume' : open_close_details['volume'],
            'previous_close' : previous_close_details['results'][0]['vw'],
        }

        # Checking to see if ticker has a description (could be an etf)
        try:
            basic_info['description'] = ticker_details['results']['description']
        except:
            basic_info['description'] = None
        
        # Checking to see if ticker has a market cap
        try:
            basic_info['market_cap'] = ticker_details['results']['market_cap']
        except:
            basic_info['market_cap'] = None

        # Checking to see if ticker has an physical address
        try:
            basic_info['hq_address'] = {
                'street' : ticker_details['address']['address1'],
                'city' : ticker_details['address']['city'],
                'state' : ticker_details['address']['state'],
                'zipcode' : ticker_details['address']['postal_code']
            }
        except:
            basic_info['hq_address'] = None

        # Checking to see if ticker has total employees
        try:
            basic_info['total_employees'] = ticker_details['results']['total_employees']
        except:
            basic_info['total_employees'] = None

        # Checking to see if ticker has a dividend
        try:
            basic_info['last_dividend'] = dividend_details['results'][0]['cash_amount']
        except:
            basic_info['last_dividend'] = None

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
        
    """
        Purpose
        -------
            To get 5 recent news articles realating to this ticker
        Parameters
        ----------
            self: Stock
                Is just referincing that it belongs to the Stock Class
    """
    def get_news(self):
        response = requests.get(f'https://api.polygon.io/v2/reference/news?ticker={self.ticker}&limit=5&apiKey={self.polygon_key}')
        news_articles = json.loads(response.text)['results']

        recent_news_articles = []

        for news_article in news_articles:

            try:
                summary = news_article['description']
            except:
                summary = ''

            recent_news_articles.append(
                {
                    'title' : news_article['title'],
                    'authors' : news_article['author'],
                    'publisher' : news_article['publisher'],
                    'publish_date' : news_article['published_utc'],
                    'summary' : summary,
                    'story_link' : news_article['article_url'],
                    'thumbnail_link' : news_article['image_url'],
                }
            )

        return recent_news_articles
    
    def get_ticker_logo(self):
        try: 
            response = requests.get(f'https://api.polygon.io/v3/reference/tickers/{self.ticker}?apiKey={self.polygon_key}')
            ticker_details = json.loads(response.text)['results']

            return str(ticker_details['branding']['icon_url']) + f'?apiKey={self.polygon_key}'
        except Exception as e:
            print(e)
            return {}
        
    def get_moving_average(self, moving_period):

        moving_period = int(moving_period)

        if(moving_period > self.MAX_MOVING_PERIOD):
            return 'Moving Period Error'
        
        moving_avg_data_points = []

        sma_data_points = self.polygon_client.get_sma(ticker=self.ticker, window=moving_period)

        for data_point in sma_data_points.values:
            moving_avg_data_points.append({
                "date" : data_point.timestamp,
                "value" : data_point.value
            })

        return {
            'moving_avg_data' : moving_avg_data_points
        }