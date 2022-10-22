package org.invested.orderservice.model.application.order_types;

import org.invested.orderservice.model.application.order_enums.ExpireTime;
import org.invested.orderservice.model.application.order_enums.Status;
import org.invested.orderservice.model.application.order_enums.TradeType;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import java.time.LocalDateTime;

@Entity
// Making use of this annotation, so we save each of the different order types into its own table in the database
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public class BasicOrder {

    @Id
    private String id;
    private String user;
    private String ticker;
    private double stockQuantity;
    private double pricePerShare;
    private TradeType tradeType;
    private ExpireTime expireTime;
    private Status currentStatus;
    private LocalDateTime orderDate;
    private LocalDateTime orderFulFilledDate;

    public BasicOrder() {}

    public BasicOrder(String id, String user, String ticker, double stockQuantity, double pricePerShare, TradeType tradeType) {
        this.id = id;
        this.user = user;
        this.ticker = ticker;
        this.stockQuantity = stockQuantity;
        this.pricePerShare = pricePerShare;
        this.tradeType = tradeType;
        this.expireTime = ExpireTime.GTC;
        this.currentStatus = Status.PENDING;
        this.orderDate = LocalDateTime.now();
        this.orderFulFilledDate = null;
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

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public LocalDateTime getOrderFulFilledDate() {
        return orderFulFilledDate;
    }

    public void setOrderFulFilledDate(LocalDateTime orderFulFilledDate) {
        this.orderFulFilledDate = orderFulFilledDate;
    }

    public double getPricePerShare() {
        return pricePerShare;
    }

    public void setPricePerShare(double pricePerShare) {
        this.pricePerShare = pricePerShare;
    }

    public ExpireTime getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(ExpireTime expireTime) {
        this.expireTime = expireTime;
    }
}
