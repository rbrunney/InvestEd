from datetime import date, datetime as current_dt
import datetime as dt
import news_article as na
import requests
import json
import os

class Stock:

    MAX_MOVING_PERIOD = 200

    def __init__(self, ticker : str):
        self.ticker = ticker
        self.polygon_key = ''

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
        
        # If it is a holiday, if so then we need to get yesterday's date
        if check_if_holiday() == str(current_date.date()):
            current_date = self.check_date(current_date - dt.timedelta(days=1))
           
        current_date_value = current_date.weekday()

        # Checking to see if it is the weekend
        if current_date_value == 5: # 5 Represents Saturday
            return current_date - dt.timedelta(days=1)
        elif current_date_value == 6:   # 6 Reporesents Sunday
            return current_date - dt.timedelta(days=2)
            
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

        # Getting closing price since it is closet to the current price
        return current_price_info['results'][0]['c']
    
    """
        Purpose
        -------
            To retrieve data points to display to some front end over a given period
        Parameters
        ----------
            period: str
                A string representing the period to retrieve from 
    """
    def get_data_points(self, period):

        # Getting the aggreagate data so we can return array of datapoints later
        def period_data_points(from_date, timespan, end_date=self.check_date().date()):
            response = requests.get(f'https://api.polygon.io/v2/aggs/ticker/{self.ticker}/range/1/{timespan}/{from_date}/{end_date}?adjusted=true&sort=asc&limit=120&apiKey={self.polygon_key}')
            aggregates = json.loads(response.text)['results']
            data_points = []

            for aggreagate in aggregates:
                # Getting closing prices for each aggreagate we get back
                data_points.append(aggreagate['c'])
            
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
    
    
    def get_basic_info(self):

        basic_info = {}

        # Getting first request data for part of basic info
        ticker_details = self.polygon_client.get_ticker_details(ticker=self.ticker)

        # Adding information into basic_info
        basic_info['ticker'] = ticker_details.ticker
        basic_info['name'] = ticker_details.name
        # basic_info['52_week_high'] = float(fetched_data['52WeekHigh'])
        # basic_info['52_week_low'] = float(fetched_data['52WeekLow'])
        basic_info['market_cap'] = ticker_details.market_cap
        # basic_info['pe_ratio'] = float(fetched_data['PERatio'])
        basic_info['description'] = ticker_details.description
        basic_info['list_date'] = ticker_details.list_date
        basic_info['total_employees'] = ticker_details.total_employees

        try:
            basic_info['hq_address'] = {
                "street" : ticker_details.address.address1,
                "city" : ticker_details.address.city,
                "state" : ticker_details.address.state,
                "zipcode" : ticker_details.address.postal_code
            }
        except:
            pass

        # Get last dividend amount and add to basic info
        dividend_amount = self.polygon_client.list_dividends(ticker=self.ticker)
        last_dividend = None
        for dividend in dividend_amount:
            last_dividend = dividend.cash_amount
            break
        basic_info['last_dividend'] = last_dividend

        # Making second request for current days open, high, and low
        try: 
            daily_info = self.polygon_client.get_daily_open_close_agg(ticker=self.ticker, date=self.check_date().date())
        except:
            try: 
                daily_info = self.polygon_client.get_daily_open_close_agg(ticker=self.ticker, date=self.check_date().date() - dt.timedelta(days=1))
            except:
                try: 
                    daily_info = self.polygon_client.get_daily_open_close_agg(ticker=self.ticker, date=self.check_date().date() - dt.timedelta(days=2))
                except:
                    daily_info = self.polygon_client.get_daily_open_close_agg(ticker=self.ticker, date=self.check_date().date() - dt.timedelta(days=3))
        # Adding open, high, low, and volume to basic information
        basic_info['open'] = daily_info.open
        basic_info['high'] = daily_info.high
        basic_info['low'] = daily_info.close
        basic_info['volume'] = daily_info.volume

        if(basic_info['low'] == None):
            basic_info['low'] = 0

        try:
            daily_info = self.polygon_client.get_daily_open_close_agg(ticker=self.ticker, date=self.check_date().date() - dt.timedelta(days=1))
        except:
            try: 
                daily_info = self.polygon_client.get_daily_open_close_agg(ticker=self.ticker, date=self.check_date().date() - dt.timedelta(days=2))
            except:
                 daily_info = self.polygon_client.get_daily_open_close_agg(ticker=self.ticker, date=self.check_date().date() - dt.timedelta(days=3))
        basic_info['previous_close'] = daily_info.close

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
        news_articles = self.polygon_client.list_ticker_news(ticker=self.ticker, limit=5)

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

print(Stock('MSFT').get_data_points('YEAR'))