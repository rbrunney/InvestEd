package org.invested.services;

import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoField;

public class OrderConsumerService {

    // In ChronoField 6 and 7 represents saturday
    private final static int SATURDAY = 6;
    private final static LocalTime MARKET_OPEN = LocalTime.of(9, 30);
    private final static LocalTime MARKET_CLOSE = LocalTime.of(16, 0);

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
}
