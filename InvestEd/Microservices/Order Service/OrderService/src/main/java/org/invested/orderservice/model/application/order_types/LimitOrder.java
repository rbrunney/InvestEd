package org.invested.orderservice.model.application.order_types;

import lombok.Getter;
import lombok.Setter;
import org.invested.orderservice.model.application.order_enums.TradeType;

import javax.persistence.Entity;

@Entity
@Getter
@Setter
public class LimitOrder extends BasicOrder {

    private double limitPrice;

    public LimitOrder() {

    }
    public LimitOrder(String id, String user, String ticker, double stockQuantity, double pricePerShare, TradeType tradeType, double limitPrice) {
        super(id, user, ticker, stockQuantity, pricePerShare, tradeType);
        this.limitPrice = limitPrice;
    }
}
