package com.invested.portfolioservice.services;

import com.invested.portfolioservice.models.application.Portfolio;
import com.invested.portfolioservice.models.application.PortfolioStock;
import com.invested.portfolioservice.reposititories.PortfolioJPARepository;
import com.invested.portfolioservice.reposititories.PortfolioStockJPARepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
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
    // Creating Portfolio Methods

    /**
     * A method to check to see if the user has a portfolio already
     * @param principalToConvert A String that is a Map we will need to convert to get username
     * @return
     */
    public boolean hasPortfolio(String principalToConvert) {
        // Getting map from principal
        Map<String, String> userInfo = convertMsgToMap(principalToConvert);

        // If greater or equal to one they have a portfolio already
        return portfolioRepo.getPortfoliosByUserId(userInfo.get("username")).size() >= 1;
    }

    /**
     * A method to create a portfolio!
     * @param principalToConvert A String that is a Map we will need to convert to get username
     * @return A map with the new portfolio id
     */
    public Map<String, Object> createPortfolio(String principalToConvert) {
        Map<String, String> userInfo = convertMsgToMap(principalToConvert);
        // Making new portfolio
        Portfolio portfolio = new Portfolio(userInfo.get("username"));
        portfolioRepo.save(portfolio);

        return new HashMap<>(){{
           put("portfolio-id", portfolio.getId());
        }};
    }

    // ////////////////////////////////////////////////////////////////////
    // Portfolio Retrieval Methods

    /**
     * A method for fetching the information within a portfolio
     * @param userId A string containing the userId
     * @return A portfolio containing all the users information
     */
    public Portfolio getPortfolio(String userId) {
        return portfolioRepo.getPortfolioByUserId(userId);
    }

    // //////////////////////////////////////////////////////////////////
    // Portfolio Delete Methods

    /**
     * A method to delete a users portfolio
     * @param userId A String containing the users id
     */
    @Transactional
    public void deletePortfolio(String userId) {
        portfolioRepo.deletePortfolioByUserId(userId);
    }

    // ////////////////////////////////////////////////////////////////////////////////////
    // Methods with dealing with stock's within a portfolio
//    public void buyStock(String ticker, String portfolioId, double totalShares, double totalPurchasePrice) {
//        // Check to see if stock exists
//        PortfolioStock portfolioStock = portfolioStockRepo.getPortfolioStockByPortfolioIdAndTicker(portfolioId, ticker);
//        if(portfolioStock == null) {
//            portfolioStockRepo.save(new PortfolioStock(ticker, portfolioId, totalShares, totalPurchasePrice));
//        } else {
//            // If it does exist then add to the current stats
//            portfolioStock.setTotalInitialBuyIn(portfolioStock.getTotalInitialBuyIn() + totalPurchasePrice);
//            portfolioStock.setTotalEquity(portfolioStock.getTotalEquity() + totalPurchasePrice);
//            portfolioStock.setTotalShareQuantity(portfolioStock.getTotalShareQuantity() + totalShares);
//            portfolioStockRepo.save(portfolioStock);
//        }
//
//        // Update portfolio value
//        updatePortfolioValue(portfolioId, totalPurchasePrice);
//    }
//
//
//    @Transactional
//    public Map<String, Object> sellStock(String ticker, String portfolioId, double totalShares, double totalSellPrice) {
//        // Check to see if ticker exists
//        PortfolioStock portfolioStock = portfolioStockRepo.getPortfolioStockByPortfolioIdAndTicker(portfolioId, ticker);
//        if(portfolioStock != null) {
//            // Calculate avgPricePerShare
//            double avgPricePerShare = portfolioStock.getTotalEquity() / portfolioStock.getTotalShareQuantity();
//            // Get the profit total
//            double profit = totalSellPrice - (totalShares * avgPricePerShare);
//
//            // Get difference and then update the initial buy in price
//            portfolioStock.setTotalShareQuantity(portfolioStock.getTotalShareQuantity() - totalShares);
//
//            // Need to update the initial buy in price
//            portfolioStock.setTotalInitialBuyIn(portfolioStock.getTotalInitialBuyIn() - (totalShares * avgPricePerShare));
//            // Need to update current total_equity based off of current sell
//            portfolioStock.setTotalEquity((portfolioStock.getTotalEquity() - totalSellPrice) + (profit * (portfolioStock.getTotalShareQuantity() + totalShares)));
//            portfolioStockRepo.save(portfolioStock);
//
//            // Updating portfolio information
//            updatePortfolioValue(portfolioId, -totalSellPrice);
//
//            // Check to see share qty
//            if (portfolioStock.getTotalShareQuantity() <= 0) {
//                portfolioStockRepo.deletePortfolioStockByPortfolioIdAndTicker(portfolioStock.getPortfolioId(), portfolioStock.getTicker());
//            }
//
//            return new HashMap<>() {{
//                put("message", ticker + " successfully sold!");
//                put("results", new HashMap<>() {{
//                    put("total-profit", profit);
//                }});
//                put("date-time", LocalDateTime.now());
//            }};
//        }
//
//        return new HashMap<>() {{
//            put("message", portfolioId + " does not contain " + ticker);
//            put("date-time", LocalDateTime.now());
//        }};
//    }


    // ////////////////////////////////////////////////////////////////////////////////////
    // Util Methods
    public Map<String, String> convertMsgToMap(String msgToConvert) {
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
