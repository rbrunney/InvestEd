package org.invested.orderservice.model.application.order_types;

import lombok.Getter;
import lombok.Setter;
import org.invested.orderservice.model.application.order_enums.TradeType;

import javax.persistence.Entity;

@Entity
@Getter
@Setter
public class StopPriceOrder extends BasicOrder{
    private double stopLossPrice;
    private double limitPrice;

    public StopPriceOrder() {}

    public StopPriceOrder(String id, String user, String ticker, double stockQuantity, double pricePerShare, TradeType tradeType, double stopLossPrice, double limitPrice) {
        super(id, user, ticker, stockQuantity, pricePerShare, tradeType);
        this.stopLossPrice = stopLossPrice;
        this.limitPrice = limitPrice;
    }
}
