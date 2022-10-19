package org.invested.orderservice.model.application.order_types;

import javax.persistence.Entity;

@Entity
public class LimitOrder extends BasicOrder {

    private double limitPrice;

    public LimitOrder() {

    }
    public LimitOrder(double limitPrice) {
        super();
        this.limitPrice = limitPrice;
    }

    public double getLimitPrice() {
        return limitPrice;
    }

    public void setLimitPrice(double limitPrice) {
        this.limitPrice = limitPrice;
    }
}
