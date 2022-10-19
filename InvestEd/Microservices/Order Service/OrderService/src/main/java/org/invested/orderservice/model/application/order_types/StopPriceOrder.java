package org.invested.orderservice.model.application.order_types;

import javax.persistence.Entity;

@Entity
public class StopPriceOrder extends BasicOrder{
    private double stopLossPrice;
    private double limitPrice;

    public StopPriceOrder() {}

    public StopPriceOrder(double stopLossPrice, double limitPrice) {
        super();
        this.stopLossPrice = stopLossPrice;
        this.limitPrice = limitPrice;
    }

    public double getStopLossPrice() {
        return stopLossPrice;
    }

    public void setStopLossPrice(double stopLossPrice) {
        this.stopLossPrice = stopLossPrice;
    }

    public double getLimitPrice() {
        return limitPrice;
    }

    public void setLimitPrice(double limitPrice) {
        this.limitPrice = limitPrice;
    }
}
