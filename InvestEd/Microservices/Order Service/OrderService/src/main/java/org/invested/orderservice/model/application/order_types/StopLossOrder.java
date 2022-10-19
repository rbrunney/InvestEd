package org.invested.orderservice.model.application.order_types;

import javax.persistence.Entity;

@Entity
public class StopLossOrder extends BasicOrder {

    private double stopLossPrice;

    public StopLossOrder() {

    }
    public StopLossOrder(double stopLossPrice) {
        super();
        this.stopLossPrice = stopLossPrice;
    }

    public double getStopLossPrice() {
        return stopLossPrice;
    }

    public void setStopLossPrice(double stopLossPrice) {
        this.stopLossPrice = stopLossPrice;
    }
}
