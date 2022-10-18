package org.invested.orderservice.model.application.order_types;

import org.invested.orderservice.model.application.order_enums.Status;
import org.invested.orderservice.model.application.order_enums.TradeType;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class BasicOrder {

    @Id
    private String id;
    private String user;
    private String ticker;
    private TradeType tradeType;
    private double stockQuantity;
    private Status currentStatus;

    public BasicOrder() {}

    public BasicOrder(String id, String user, String ticker, double stockQuantity, TradeType tradeType) {
        this.id = id;
        this.user = user;
        this.ticker = ticker;
        this.stockQuantity = stockQuantity;
        this.tradeType = tradeType;
        this.currentStatus = Status.PENDING;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getTicker() {
        return ticker;
    }

    public void setTicker(String ticker) {
        this.ticker = ticker;
    }

    public TradeType getTradeType() {
        return tradeType;
    }

    public void setTradeType(TradeType tradeType) {
        this.tradeType = tradeType;
    }

    public Status getCurrentStatus() {
        return currentStatus;
    }

    public void setCurrentStatus(Status currentStatus) {
        this.currentStatus = currentStatus;
    }

    public double getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(double stockQuantity) {
        this.stockQuantity = stockQuantity;
    }
}
