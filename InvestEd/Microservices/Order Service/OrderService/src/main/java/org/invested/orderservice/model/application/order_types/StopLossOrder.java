package org.invested.orderservice.model.application.order_types;

import org.invested.orderservice.model.application.order_enums.TradeType;

import javax.persistence.Entity;

@Entity
public class StopLossOrder extends BasicOrder {

    private double stopLossPrice;

    public StopLossOrder() {

    }
    public StopLossOrder(String id, String user, String ticker, double stockQuantity, double pricePerShare, TradeType tradeType, double stopLossPrice) {
        super(id, user, ticker, stockQuantity, pricePerShare, tradeType);
        this.stopLossPrice = stopLossPrice;
    }

    public double getStopLossPrice() {
        return stopLossPrice;
    }

    public void setStopLossPrice(double stopLossPrice) {
        this.stopLossPrice = stopLossPrice;
    }
}
