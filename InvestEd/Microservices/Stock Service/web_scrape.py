from urllib.request import urlopen, Request
from bs4 import BeautifulSoup


def get_trending_stocks():

    trending_stocks = []

    url = f'https://stockanalysis.com/trending/'
    request = Request(url)
    request.add_header('User-Agent', 'Mozilla/5.0')
    page = urlopen(request)
    
    html = page.read().decode('utf-8')
    soup = BeautifulSoup(html, 'html.parser')

    trending_table = soup.find('table', {'class' : {'symbol-table svelte-1b2xolw'}})
    table_body = trending_table.find('tbody')
    table_rows = table_body.find_all('tr', {'class' : {'svelte-1b2xolw'}})
    
    for tr_index, row in enumerate(table_rows):
        if (tr_index < 5):
            for td_index, td in enumerate(row.find_all('td')):
                if td_index == 1:
                    trending_stocks.append(td.text)

    return trending_stocks