import uuid

class Order:

    def __init__(self, user: str, ticker: str, trade_type: str, stock_quantity: float):
        self.id = uuid.uuid4()
        self.user = user
        self.ticker = ticker,
        self.trae_type = trade_type
        self.stock_quantity = stock_quantity

    def place_order(self):
        # Put order in queue
        pass
