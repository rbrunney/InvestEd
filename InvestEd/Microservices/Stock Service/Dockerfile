FROM python
WORKDIR /code
COPY REQUIREMENTS.txt /code/
RUN pip install -r REQUIREMENTS.txt
COPY . /code/
CMD python stock_api.py