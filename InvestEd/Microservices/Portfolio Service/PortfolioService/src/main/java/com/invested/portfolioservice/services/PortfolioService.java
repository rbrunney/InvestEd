package com.invested.portfolioservice.services;

import com.invested.portfolioservice.models.Portfolio;
import com.invested.portfolioservice.models.PortfolioStock;
import com.invested.portfolioservice.reposititories.PortfolioJPARepository;
import com.invested.portfolioservice.reposititories.PortfolioStockJPARepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@Service
public class PortfolioService {

    @Autowired
    private PortfolioJPARepository portfolioRepo;

    @Autowired
    private PortfolioStockJPARepository portfolioStockRepo;

    private void createPortfolio(String username) {
        // Making new portfolio
        portfolioRepo.save(new Portfolio(username));
    }

    public boolean hasPortfolio(String principalToConvert) {
        // Getting map from principal
        Map<String, String> userInfo = convertMsgToMap(principalToConvert);
        if(portfolioRepo.getPortfoliosByUserId(userInfo.get("username")).size() < 1) {
           createPortfolio(userInfo.get("username"));
           return false;
        }

        // Meaning they have reached the portfolio limit
        return true;
    }

    public boolean portfolioExists(String portfolioId) {
        return portfolioRepo.getPortfolioById(portfolioId) != null;
    }

    public boolean isUsersPortfolio(String msgToConvert, String portfolioId) {
        Map<String, String> userInfo = convertMsgToMap(msgToConvert);
        return portfolioRepo.getPortfolioById(portfolioId).getUserId().equals(userInfo.get("username"));
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
