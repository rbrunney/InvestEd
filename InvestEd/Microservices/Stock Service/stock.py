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
        self.client = RESTClient()

    def check_date(self, current_date=current_dt.today()):
        saturday = 5
        sunday = 6
        date_value = current_date.weekday()

        if date_value == saturday:
            return current_date - dt.timedelta(days=1)
        elif date_value == sunday:
            return current_date - dt.timedelta(days=2)

        return current_date

    def get_current_price(self):

        # Getting the date and then checking to get the the current price, at least close to it
        date_to_retrieve = self.check_date()
        aggs = self.client.get_aggs(self.ticker, 1, "day", date_to_retrieve, date_to_retrieve)
        return aggs[0].vwap
    
    def get_data_points(self, period):

        # Getting the aggreagate data so we can return array of datapoints later
        def period_data_points(from_date, end_date, timespan):
            aggregates = self.client.get_aggs(self.ticker, multiplier=1, from_=from_date, to=end_date, timespan=timespan,limit=250)
            data_points = []

            for aggreagate in aggregates:
                data_points.append(aggreagate.vwap)
            
            return data_points

        if period == "DAY":
            return period_data_points(self.check_date(), self.check_date(), "minute")
        elif period == "WEEK":
            return period_data_points(self.check_date() - dt.timedelta(days=7), self.check_date(), "minute")
        elif period == "MONTH":
            return period_data_points(self.check_date() - dt.timedelta(days=31), self.check_date(), "minute")
        elif period == "3-MONTH":
            return period_data_points(self.check_date() - dt.timedelta(days=93), self.check_date(), "minute")
        elif period == "YEAR":
            return period_data_points(self.check_date() - dt.timedelta(days=365), self.check_date(), "day")
        elif period == "5-YEAR":
            return period_data_points(self.check_date() - dt.timedelta(days=1825), self.check_date(), "day")
        else:
            # Return 400 so we know we have to send a bad request
            return 400
    
    
    def get_basic_info(self):

        basic_info = {}

        # Getting first request data for part of basic info
        ticker_details = self.client.get_ticker_details(ticker=self.ticker)

        # Adding information into basic_info
        basic_info['ticker'] = ticker_details.ticker
        basic_info['name'] = ticker_details.name
        # basic_info['52_week_high'] = float(fetched_data['52WeekHigh'])
        # basic_info['52_week_low'] = float(fetched_data['52WeekLow'])
        basic_info['market_cap'] = float(ticker_details.market_cap)
        # basic_info['pe_ratio'] = float(fetched_data['PERatio'])
        # basic_info['dividend_yeild'] = float(fetched_data['DividendYield'])
        basic_info['description'] = ticker_details.description
        basic_info['list_date'] = ticker_details.list_date
        basic_info['total_employees'] = ticker_details.total_employees
        basic_info['hq_address'] = {
            "street" : ticker_details.address.address1,
            "city" : ticker_details.address.city,
            "state" : ticker_details.address.state,
            "zipcode" : ticker_details.address.postal_code
        }

        # Making second request for current days open, high, and low
        daily_info = self.client.get_daily_open_close_agg(ticker=self.ticker, date=self.check_date().date())
        
        # Adding open, high, low, and volume to basic information
        basic_info['open'] = daily_info.open
        basic_info['high'] = daily_info.high
        basic_info['low'] = daily_info.close
        basic_info['volume'] = daily_info.volume

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
        news_articles = self.client.list_ticker_news(ticker=self.ticker, limit=5)

        recent_news_articles = []

        for news_article in news_articles:
            recent_news_articles.append(na.NewsArticle(
                title=news_article.title,
                authors=news_article.author,
                publisher=news_article.publisher,
                publish_date=news_article.published_utc,
                summary=news_article.description,
                story_link=news_article.article_url,
                thumbnail_link=news_article.image_url
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
    
print(Stock("AAPL").get_news())