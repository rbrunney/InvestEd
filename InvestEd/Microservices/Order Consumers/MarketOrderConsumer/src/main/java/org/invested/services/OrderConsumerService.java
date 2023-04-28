package org.invested.services;

import org.invested.models.application.account.Account;
import org.invested.models.application.order_enums.Status;
import org.invested.models.application.order_types.BasicOrder;
import org.invested.repositories.AccountJPARepository;
import org.invested.repositories.OrderJPARepository;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoField;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
public class OrderConsumerService {

    @Autowired
    private OrderJPARepository orderRepo;

    @Autowired
    private AccountJPARepository accountRepo;

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
     * A method for executing a buy on an order
     * @param currentOrder A Basic Order Object
     */
    public void executeBuy(BasicOrder currentOrder, String portfolioId) {

        // Getting current ticker price
        JSONObject currentPriceResponse = Requests.get("http://gateway:8888/invested_stock/" + currentOrder.getTicker() + "/price");
        double currentTickerPrice = Double.parseDouble(currentPriceResponse.get("current_price").toString());

        double originalTotalOrderPrice = currentOrder.getPricePerShare() * currentOrder.getStockQuantity();
        double newTotalOrderPrice = currentTickerPrice * currentOrder.getStockQuantity();

        if(originalTotalOrderPrice > newTotalOrderPrice) {
            // Updating User Account Information
            double buyingPowerToGiveBack = originalTotalOrderPrice - newTotalOrderPrice;
            Account userToUpdate = accountRepo.getAccountById(currentOrder.getUser());
            userToUpdate.setBuyingPower(userToUpdate.getBuyingPower() + buyingPowerToGiveBack);
            accountRepo.save(userToUpdate);

            // Updating Order information
            currentOrder.setPricePerShare(currentTickerPrice);
        }

        completeOrder(currentOrder);
        addToPortfolio(currentOrder, portfolioId);
    }

    private void addToPortfolio(BasicOrder currentOrder, String portfolioId) {
        Requests.post(
        "http://gateway:8888/invested_portfolio/portfolio_stock",
                "{" +
                        "\"id\":\"\"," +
                        "\"ticker\":\"" + currentOrder.getTicker() + "\"," +
                        "\"portfolio\":\"" + portfolioId + "\"," +
                        "\"totalShareQuantity\":" + currentOrder.getStockQuantity() + "," +
                        "\"totalEquity\":" + currentOrder.getStockQuantity() * currentOrder.getPricePerShare() + "," +
                        "\"totalInitialBuyIn\":" + currentOrder.getStockQuantity() * currentOrder.getPricePerShare() +
                        "}");

        System.out.println("{" +
                "\"id\":\"\"," +
                "\"ticker\":\"" + currentOrder.getTicker() + "\"," +
                "\"portfolio_id\":\"" + portfolioId + "\"," +
                "\"totalShareQuantity\":" + currentOrder.getStockQuantity() + "," +
                "\"totalEquity\":" + currentOrder.getStockQuantity() * currentOrder.getPricePerShare() + "," +
                "\"totalInitialBuyIn\":" + currentOrder.getStockQuantity() * currentOrder.getPricePerShare() + "," +
                "}");
    }

    /**
     * A method for executing a buy on an order
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

    static private Map<String, String> convertResponseToMap(String msgToConvert) {
        // Turn body into a string
        // Replacing the { } so we can just get straight key values
        msgToConvert = msgToConvert.replace("{", "").replace("}", "").replace(" ", "");
        Map<String, String> finalResult = new HashMap<>();

        // Splitting to get key values
        String[] jsonPairs = msgToConvert.split(",");

        // Generating map based off of message
        for(String pair : jsonPairs) {
            String[] keyValue = pair.split("=");
            finalResult.put(keyValue[0], keyValue[1]);
        }

        return finalResult;
    }
}
