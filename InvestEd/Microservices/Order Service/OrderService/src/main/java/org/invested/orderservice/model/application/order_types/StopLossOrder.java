package org.invested.orderservice.model.application.order_types;

public class StopLossOrder extends BasicOrder {

    private double stopLossPrice;

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
