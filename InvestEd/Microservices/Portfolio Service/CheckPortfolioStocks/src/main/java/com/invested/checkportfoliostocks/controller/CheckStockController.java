package com.invested.checkportfoliostocks.controller;

import com.invested.checkportfoliostocks.services.CheckStockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
@EnableScheduling
public class CheckStockController {

    @Autowired
    private CheckStockService checkService;

    @Scheduled(fixedRate = 30000)
    public void checkPortfolioStockPrice() {
        checkService.checkStockPrices();
    }

    @Scheduled(fixedRate = 30000)
    public void updatePortfolioValue() {
        checkService.updatePortfolioValue();
    }

    @Scheduled(fixedRate = 30000)
    public void takePortfolioSnapShot() {
        checkService.takePortfolioSnapshot();
    }
}
