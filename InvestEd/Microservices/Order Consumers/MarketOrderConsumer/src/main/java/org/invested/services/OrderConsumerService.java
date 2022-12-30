package org.invested.services;

import org.invested.models.application.order_enums.Status;
import org.invested.models.application.order_types.BasicOrder;
import org.invested.repositories.OrderJPARepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoField;
import java.util.Map;

@Service
public class OrderConsumerService {

    @Autowired
    private OrderJPARepository orderRepo;

    /**
     * A method to determine if current time is within trading hours
     * @return true if it is trading hours, false otherwise
     */
    public boolean isTradingHours() {

        // Setting Base Trading Hours Information
        final int SATURDAY = 6;
        final LocalTime MARKET_OPEN = LocalTime.of(9, 30);
        final LocalTime MARKET_CLOSE = LocalTime.of(16, 0);

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

    /**
     * A method for getting an order based off its id
     * @param orderId A String containing the order id
     * @return A BasicOrder object with all of its information
     */
    public BasicOrder getOrder(String orderId) {
        return orderRepo.getBasicOrderById(orderId);
    }

    /**
     * A method for executing a buy on a order
     * @param currentOrder A Basic Order Object
     */
    public void executeBuy(BasicOrder currentOrder) {
        double originalTotalOrderPrice = currentOrder.getPricePerShare() * currentOrder.getStockQuantity();

        // TODO Get Current Price
        Map<String, String> getPriceResponse = Requests.get("http://localhost:8888/invested_stock/" + currentOrder.getTicker() + "/price");
        // TODO Calculate new totalOrderPrice
        // TODO Get Original and New and check the difference
            // TODO if more than call execute buy else take it
            // TODO Update account buying power accordingly
    }

    /**
     * A method for executing a buy on a order
     * @param currentOrder A Basic Order Object
     */
    public void executeSell(BasicOrder currentOrder) {

    }

    /**
     * A method for marking the order as complete and updating its status to complete!
     * @param currentOrder A Basic Order Object
     */
    public void completeOrder(BasicOrder currentOrder) {
        currentOrder.setOrderFulFilledDate(LocalDateTime.now());
        currentOrder.setCurrentStatus(Status.COMPLETED);
        orderRepo.save(currentOrder);
    }
}
