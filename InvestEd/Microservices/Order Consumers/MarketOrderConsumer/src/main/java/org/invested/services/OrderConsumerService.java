package org.invested.services;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Time;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoField;
import java.util.Base64;

public class OrderConsumerService {

    // In ChronoField 6 and 7 represents saturday
    private final static int SATURDAY = 6;
    private final static LocalTime MARKET_OPEN = LocalTime.of(9, 30);
    private final static LocalTime MARKET_CLOSE = LocalTime.of(16, 0);


    public static void buyStock(String userId, String ticker, double stockQty, double pricePerShare) {
        makePutRequest("http://localhost:8888/invested_portfolio/buy_stock/" + userId,
                "{\"ticker\":\"" + ticker + "\", \"stock-qty\":" + stockQty + ", \"price-per-share\":" + pricePerShare + "}", false);
    }

    public static void sellStock(String userId, String ticker, double stockQty, double pricePerShare) {
        makePutRequest("http://localhost:8888/invested_portfolio/sell_stock/" + userId,
                "{\"ticker\":\"" + ticker + "\", \"stock-qty\":" + stockQty + ", \"price-per-share\":" + pricePerShare + "}", false);
    }

    public static boolean isTradingHours() {
        // Get current date time
        ZonedDateTime currentTime = ZonedDateTime.now();
        // Get ET current time
        ZonedDateTime currentET = currentTime.withZoneSameInstant(ZoneId.of("America/New_York"));

        // Checking to see if it is not the weekend
        return (currentTime.get(ChronoField.DAY_OF_WEEK) < SATURDAY) &&
                // Checking to see if current time is within market hours
                LocalTime.of(currentET.getHour(), currentET.getMinute(), currentET.getSecond()).isAfter(MARKET_OPEN) &&
                LocalTime.of(currentET.getHour(), currentET.getMinute(), currentET.getSecond()).isBefore(MARKET_CLOSE);
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
