package com.invested.portfolioservice.models;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.ArrayList;
import java.util.UUID;

@Entity
public class Portfolio {

    @Id
    private String id;
    private String userId;
    private double totalValue;
    private double totalGain;

    public Portfolio(String userId){
        this.id = UUID.randomUUID().toString();
        this.userId = userId;
        this.totalValue = getTotalValue();
        this.totalValue = getTotalGain();
    }

    public Portfolio() {

    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public double getTotalValue() {
        return totalValue;
    }

    public void setTotalValue(double totalValue) {
        this.totalValue = totalValue;
    }

    public double getTotalGain() {
        return totalGain;
    }

    public void setTotalGain(double totalGain) {
        this.totalGain = totalGain;
    }
}
