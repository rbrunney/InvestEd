package org.invested.services;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
public class OrderConsumerService {

    public static void buyStock(String userId, String ticker, double stockQty, double pricePerShare) {
        makePutRequest("http://localhost:8082/invested_portfolio/buy_stock/" + userId,
                "{\"ticker\":\"" + ticker + "\", \"stock-qty\":" + stockQty + ", \"price-per-share\":" + pricePerShare + "}");
    }
    // /////////////////////////////////////////////////////////
    // Util Methods

    public static void makePutRequest(String url, String requestBody) {
        try {
            // Opening connection for body request
            URL putUrl = new URL(url);
            HttpURLConnection request = (HttpURLConnection) putUrl.openConnection();

            // Setting up basic properties for request
            request.setRequestMethod("PUT");
            request.setRequestProperty("Content-Type", "application/json");
            request.setRequestProperty("Accept", "application/json");
            request.setDoOutput(true);
            request.setDoInput(true);

            // Adding body to request
            try (DataOutputStream writer = new DataOutputStream(request.getOutputStream())) {
                writer.write(requestBody.getBytes());
            }

            // Had to add this so that way the request would actually go through, I don't like this
            request.getResponseMessage();
            request.disconnect();
        } catch(Exception e) {
            System.out.println("[ERROR] " + e.getMessage());
        }
    }
}
