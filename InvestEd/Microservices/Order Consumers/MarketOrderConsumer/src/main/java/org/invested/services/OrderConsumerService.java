package org.invested.services;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;

public class OrderConsumerService {

    public static void buyStock(String userId, String ticker, double stockQty, double pricePerShare) {
        makePutRequest("http://localhost:8888/invested_portfolio/buy_stock/" + userId,
                "{\"ticker\":\"" + ticker + "\", \"stock-qty\":" + stockQty + ", \"price-per-share\":" + pricePerShare + "}", false);
    }

    public static void sellStock(String userId, String ticker, double stockQty, double pricePerShare) {
        makePutRequest("http://localhost:8888/invested_portfolio/sell_stock/" + userId,
                "{\"ticker\":\"" + ticker + "\", \"stock-qty\":" + stockQty + ", \"price-per-share\":" + pricePerShare + "}", false);
    }
    // /////////////////////////////////////////////////////////
    // Util Methods

    public static void makePutRequest(String url, String requestBody, boolean enableAuthorization) {
        try {
            // Opening connection for body request
            URL putUrl = new URL(url);
            HttpURLConnection request = (HttpURLConnection) putUrl.openConnection();

            // Setting up basic properties for request
            request.setRequestMethod("PUT");
            if(enableAuthorization) {
                // Setting Basic Authorization header so we cna limit who is getting into potential end-point
                request.setRequestProperty("Authorization", "Basic " +
                        new String(Base64.getEncoder().encode(
                                (System.getenv("CUSTOM_USERNAME") + ":" + System.getenv("CUSTOM_PASSWORD")
                                ).getBytes())));
            }
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
