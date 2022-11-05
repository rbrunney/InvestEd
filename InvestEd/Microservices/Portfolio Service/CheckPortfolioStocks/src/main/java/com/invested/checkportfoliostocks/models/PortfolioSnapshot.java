package com.invested.checkportfoliostocks.models;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
public class PortfolioSnapshot {

    @Id
    private String id;

    private String portfolioId;
    private double portfolioValue;
    private LocalDateTime dateSnapped;

    public PortfolioSnapshot() {}

    public PortfolioSnapshot(String portfolioId, double portfolioValue) {
        this.id = UUID.randomUUID().toString();
        this.portfolioId = portfolioId;
        this.portfolioValue = portfolioValue;
        this.dateSnapped = LocalDateTime.now();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPortfolioId() {
        return portfolioId;
    }

    public void setPortfolioId(String portfolioId) {
        this.portfolioId = portfolioId;
    }

    public double getPortfolioValue() {
        return portfolioValue;
    }

    public void setPortfolioValue(double portfolioValue) {
        this.portfolioValue = portfolioValue;
    }

    public LocalDateTime getDateSnapped() {
        return dateSnapped;
    }

    public void setDateSnapped(LocalDateTime dateSnapped) {
        this.dateSnapped = dateSnapped;
    }
}
