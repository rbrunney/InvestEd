package com.invested.portfolioservice.models;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class PortfolioStock {

    @Id
    private String id;

    private String ticker;
    private String portfolioId;
    private double totalShareQuantity;
    private double initialBuyIn;
    private double totalGain;


}
