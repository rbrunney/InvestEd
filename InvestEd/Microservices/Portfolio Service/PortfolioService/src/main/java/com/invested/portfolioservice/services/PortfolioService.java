package com.invested.portfolioservice.services;

import com.invested.portfolioservice.models.Portfolio;
import com.invested.portfolioservice.models.PortfolioStock;
import com.invested.portfolioservice.reposititories.PortfolioJPARepository;
import com.invested.portfolioservice.reposititories.PortfolioStockJPARepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.InvalidKeyException;
import java.security.Principal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@Service
public class PortfolioService {

    @Autowired
    private PortfolioJPARepository portfolioRepo;

    @Autowired
    private PortfolioStockJPARepository portfolioStockRepo;


    // ///////////////////////////////////////////////////////////////
    // Dealing with portfolio information
    public Map<String, Object> createPortfolio(String msgToConvert) {
        Map<String, String> userInfo = convertMsgToMap(msgToConvert);
        // Making new portfolio
        Portfolio portfolio = new Portfolio(userInfo.get("username"));
        portfolioRepo.save(portfolio);

        return new HashMap<>(){{
           put("portfolio-id", portfolio.getId());
        }};
    }

    public boolean hasPortfolio(String principalToConvert) {
        // Getting map from principal
        Map<String, String> userInfo = convertMsgToMap(principalToConvert);
        return portfolioRepo.getPortfoliosByUserId(userInfo.get("username")).size() >= 1;

        // Meaning they have reached the portfolio limit
    }

    public boolean portfolioExists(String portfolioId) {
        return portfolioRepo.getPortfolioById(portfolioId) != null;
    }

    public boolean isUsersPortfolio(String msgToConvert, String portfolioId) {
        Map<String, String> userInfo = convertMsgToMap(msgToConvert);
        return portfolioRepo.getPortfolioById(portfolioId).getUserId().equals(userInfo.get("username"));
    }

    public String getPortfolioId(String msgToConvert) {
        Map<String, String> userInfo = convertMsgToMap(msgToConvert);

        return portfolioRepo.getPortfolioIdByUsername(userInfo.get("username"));
    }

    public Map<String, Object> getPortfolio(String portfolioId) {
        // Getting all stock information
        Portfolio portfolio = portfolioRepo.getPortfolioById(portfolioId);
        ArrayList<PortfolioStock> portfolioStocks = portfolioStockRepo.getPortfolioStocksByPortfolioId(portfolioId);

        // Creating result
        return new HashMap<>(){{
            put("portfolio", new HashMap<>(){{
                put("portfolio-id", portfolioId);
                put("total-value", portfolio.getTotalValue());
                put("total-gain", portfolio.getTotalGain());
                put("current-stocks", portfolioStocks);
            }});
        }};
    }

    public void deletePortfolio(String portfolioId) {
        portfolioRepo.deleteById(portfolioId);
    }

    public void updatePortfolioValue(String portfolioId, double stockPurchaseValue) {
        // Updating portfolio value so when orders go through portfolio value goes up
        Portfolio portfolio = portfolioRepo.getPortfolioById(portfolioId);
        portfolio.setTotalValue(portfolio.getTotalValue() + stockPurchaseValue);
        portfolioRepo.save(portfolio);
    }

    // ////////////////////////////////////////////////////////////////////////////////////
    // Methods with dealing with stock's within a portfolio
    public void buyStock(String ticker, String portfolioId, double totalShares, double totalPurchasePrice) {
        // Check to see if stock exists
        PortfolioStock portfolioStock = portfolioStockRepo.getPortfolioStockByPortfolioIdAndTicker(portfolioId, ticker);
        if(portfolioStock == null) {
            portfolioStockRepo.save(new PortfolioStock(ticker, portfolioId, totalShares, totalPurchasePrice));
        } else {
            // If it does exist then add to the current stats
            portfolioStock.setTotalEquity(portfolioStock.getTotalEquity() + totalPurchasePrice);
            portfolioStock.setTotalShareQuantity(portfolioStock.getTotalShareQuantity() + totalShares);
            portfolioStockRepo.save(portfolioStock);
        }

        // Update portfolio value
        updatePortfolioValue(portfolioId, totalPurchasePrice);
    }


    public Map<String, Object> sellStock(String ticker, String portfolioId, double totalShares, double totalSellPrice) {
        // Check to see if ticker exists
        PortfolioStock portfolioStock = portfolioStockRepo.getPortfolioStockByPortfolioIdAndTicker(portfolioId, ticker);
        if(portfolioStock != null) {
            // Calculate avgPricePerShare
            double avgPricePerShare = portfolioStock.getTotalEquity() / portfolioStock.getTotalShareQuantity();
            // Get the profit total
            double profit = totalSellPrice - (totalShares * avgPricePerShare);

            // Get difference and then update the initial buy in price
            portfolioStock.setTotalShareQuantity(portfolioStock.getTotalShareQuantity() - totalShares);

            // Need to update current total_equity based off of current sell
            portfolioStock.setTotalEquity(portfolioStock.getTotalEquity() - totalSellPrice);
            portfolioStockRepo.save(portfolioStock);

            // Updating portfolio information
            updatePortfolioValue(portfolioId, -totalSellPrice);

            return new HashMap<>() {{
                put("message", ticker + " successfully sold!");
                put("results", new HashMap<>() {{
                    put("total-profit", profit);
                }});
                put("date-time", LocalDateTime.now());
            }};
        }

        return new HashMap<>() {{
            put("message", portfolioId + " does not contain " + ticker);
            put("date-time", LocalDateTime.now());
        }};
    }


    // ////////////////////////////////////////////////////////////////////////////////////
    // Util Methods
    private Map<String, String> convertMsgToMap(String msgToConvert) {
        Map<String, String> finalResult = new HashMap<>();

        // Getting rid of all the unnecessary characters to split the string easier.
        msgToConvert = msgToConvert.replace("{", "").replace("}", "").replace(" ", "");

        String[] jsonPairs = msgToConvert.split(",");

        for(String pair : jsonPairs) {
            String[] keyValue = pair.split("=");
            finalResult.put(keyValue[0], keyValue[1]);
        }

        return finalResult;
    }
}
