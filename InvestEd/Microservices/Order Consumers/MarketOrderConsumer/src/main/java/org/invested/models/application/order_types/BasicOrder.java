package org.invested.models.application.order_types;

import lombok.Getter;
import lombok.Setter;
import org.invested.models.application.order_enums.ExpireTime;
import org.invested.models.application.order_enums.Status;
import org.invested.models.application.order_enums.TradeType;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
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
}
