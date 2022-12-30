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
