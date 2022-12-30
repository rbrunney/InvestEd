package com.invested.portfolioservice.models.application;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.sound.sampled.Port;
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
