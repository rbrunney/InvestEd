package com.invested.portfolioservice.models;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.UUID;

@Entity
public class PortfolioStock {

    @Id
    private String id;
    private String ticker;
    private String portfolioId;
    private double totalShareQuantity;
    private double totalEquity;

    private double totalInitialBuyIn;

    public PortfolioStock() {
    }

    public PortfolioStock(String ticker, String portfolioId, double totalShares, double totalPurchasePrice) {
        this.id = UUID.randomUUID().toString();
        this.ticker = ticker;
        this.portfolioId = portfolioId;
        this.totalShareQuantity = getTotalShareQuantity() + totalShares;
        this.totalEquity = getTotalEquity() + totalPurchasePrice;
        this.totalInitialBuyIn = getTotalInitialBuyIn() + totalPurchasePrice;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTicker() {
        return ticker;
    }

    public void setTicker(String ticker) {
        this.ticker = ticker;
    }

    public String getPortfolioId() {
        return portfolioId;
    }

    public void setPortfolioId(String portfolioId) {
        this.portfolioId = portfolioId;
    }

    public double getTotalShareQuantity() {
        return totalShareQuantity;
    }

    public void setTotalShareQuantity(double totalShareQuantity) {
        this.totalShareQuantity = totalShareQuantity;
    }

    public double getTotalEquity() {
        return totalEquity;
    }

    public void setTotalEquity(double totalEquity) {
        this.totalEquity = totalEquity;
    }

    public double getTotalInitialBuyIn() {
        return totalInitialBuyIn;
    }

    public void setTotalInitialBuyIn(double totalInitialBuyIn) {
        this.totalInitialBuyIn = totalInitialBuyIn;
    }
}
