package com.invested.portfolioservice.models.application;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import java.util.List;
import java.util.UUID;

@Entity
@Getter
@Setter
public class Portfolio {

    @Id
    private String id;
    private String userId;
    private double totalValue;
    private double totalGain;

    @OneToMany(mappedBy = "portfolio")
    private List<PortfolioStock> stocks;

    public Portfolio(String userId){
        this.id = UUID.randomUUID().toString();
        this.userId = userId;
    }

    public Portfolio() {

    }
}
