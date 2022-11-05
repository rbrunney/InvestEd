package org.invested.services;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.rabbitmq.client.Channel;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoField;

public class OrderConsumerService {

    // In ChronoField 6 and 7 represents saturday
    private final static int SATURDAY = 6;
    private final static LocalTime MARKET_OPEN = LocalTime.of(9, 30);
    private final static LocalTime MARKET_CLOSE = LocalTime.of(16, 0);

    public static boolean hasHitBuyLimit(double limitPrice, double currentPrice) {
        // Checking to see if buy is less than so we cna get in early
        return limitPrice <= currentPrice;
    }

    public static boolean hasHitSellLimit(double limitPrice, double currentPrice) {
        // Checking to see if sell sale is greater than, so we can get the best possible price
        return limitPrice >= currentPrice;
    }

    public static void putIntoQueue(Channel channel, String queue, byte[] messageBody) {
        try {
            // Putting back into queue
            channel.basicPublish("ORDER_EXCHANGE", queue, null, messageBody);
        } catch(IOException ioe) {
            System.out.println("[ERROR] " + ioe.getMessage());
        }
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
    // Util methods
    public static double getPriceRequest(String requestUrl) {
        try {
            // Making connection and opening it up
            URL url = new URL(requestUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");

            JsonNode response = new ObjectMapper().readTree(connection.getResponseMessage());
            connection.disconnect();

            return response.get("results").get("price").asDouble();
        } catch(Exception e) {
            System.out.println("[ERROR] " + e.getMessage());
        }

        return 0;
    }
}
