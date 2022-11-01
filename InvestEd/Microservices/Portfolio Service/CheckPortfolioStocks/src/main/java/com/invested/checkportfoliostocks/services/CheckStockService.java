package com.invested.checkportfoliostocks.services;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.invested.checkportfoliostocks.models.Portfolio;
import com.invested.checkportfoliostocks.models.PortfolioStock;
import com.invested.checkportfoliostocks.repositories.PortfolioJPARepository;
import com.invested.checkportfoliostocks.repositories.PortfolioStockJPARepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CheckStockService {

    @Autowired
    private PortfolioJPARepository portfolioRepo;

    @Autowired
    private PortfolioStockJPARepository portfolioStockRepo;

    public void checkStockPrices() {
        // Get Current Stocks in Portfolio's
        for (String ticker : getStocksInPortfolios()) {
            // Get current price for ticker
            double current_price = getTickerPrice(ticker);
            portfolioStockRepo.updateTickerTotalEquity(current_price, ticker);
        }

        // Then go through and update the portfolio values for everyone after check
        for(String portfolioId : portfolioStockRepo.getPortfolioIds()) {
            // Go through and get portfolio stock and add sum and update portfolio with new value
            double newEquityValue = getNewTotalValue(portfolioId);
            // Go through and get portfolio stock initial buy in and then
            updatePortfolioValue(portfolioId, 0, newEquityValue);
        }
    }

    public List<String> getStocksInPortfolios() {
        return portfolioStockRepo.getCurrentStocksInPortfolios();
    }

    public double getTickerPrice(String ticker) {
        double currentPrice = 0;
        try {
            // Open Connection to API
            URL getTickerPriceUrl = new URL("http://localhost:8888/invested_stock/" + ticker + "/price");
            URLConnection currentPriceConnection = getTickerPriceUrl.openConnection();
            HttpURLConnection httpCon = (HttpURLConnection) currentPriceConnection;

            // Get Response Information
            JsonNode response = new ObjectMapper().readTree(getResponse(httpCon));

            // Get the current price from
            currentPrice = response.get("results").get("current_price").asDouble();

            httpCon.disconnect();

        } catch(Exception e) {
            System.out.println(e.getMessage());
        }

        return currentPrice;
    }

    public void updatePortfolioValue(String portfolioId, double newTotalGain, double newTotalEquityValue) {
        // Updating Portfolio totalEquity and totalGain
        Portfolio portfolioToUpdate = portfolioRepo.getPortfolioById(portfolioId);
        portfolioToUpdate.setTotalValue(newTotalEquityValue);
        portfolioToUpdate.setTotalGain(newTotalGain);

        // Save back to database
        portfolioRepo.save(portfolioToUpdate);
    }

    public double getNewTotalValue(String portfolioId) {
        // Getting all total equity value
        double totalEquityValue = 0;
        for(PortfolioStock stock : portfolioStockRepo.getPortfolioStocksByPortfolioId(portfolioId)) {
            totalEquityValue += stock.getTotalEquity();
        }
        return totalEquityValue;
    }

//    public double getNewInitialBuyInValue(String portfolioId) {
//        double totalBuyInValue = 0;
//        for(PortfolioStock stock : portfolioStockRepo.getPortfolioStocksByPortfolioId(portfolioId)) {
//            totalBuyInValue += stock.
//        }
//    }

//    public double getNewTotalGain(double initialBuyInValue, double currentEquityValue) {
//
//    }

    // /////////////////////////////////////////////////////////////////////////////////////////
    // Util Methods for helping get price

    public String getResponse(HttpURLConnection connection) throws IOException {
        // Making Buffered Reader so we can read
        BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));

        String inputLine;
        StringBuilder response = new StringBuilder();
        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }

        in.close();

        return response.toString();
    }
}
