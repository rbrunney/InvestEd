package com.invested.checkportfoliostocks.services;

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
            getTickerPrice(ticker);
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
            System.out.println(getResponse(httpCon));

            httpCon.disconnect();

        } catch(Exception e) {
            System.out.println(e.getMessage());
        }

        return currentPrice;
    }

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
