package org.invested.models.application.portfolio;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import java.util.UUID;

@Entity
@Getter
@Setter
public class PortfolioStock {

    @Id
    private String id;
    private String ticker;
    private double totalShareQuantity;
    private double totalEquity;
    private double totalInitialBuyIn;
    @ManyToOne
    @JsonIgnore
    private Portfolio portfolio;

    public PortfolioStock() {
    }

    public PortfolioStock(String ticker, String portfolioId, double totalShares, double totalPurchasePrice) {
        this.id = UUID.randomUUID().toString();
        this.ticker = ticker;
        this.totalShareQuantity = getTotalShareQuantity() + totalShares;
        this.totalEquity = getTotalEquity() + totalPurchasePrice;
        this.totalInitialBuyIn = getTotalInitialBuyIn() + totalPurchasePrice;
    }
}

