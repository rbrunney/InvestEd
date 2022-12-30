package org.invested.orderservice.services;

import com.fasterxml.jackson.databind.JsonNode;
import org.invested.orderservice.model.application.account.Account;
import org.invested.orderservice.model.application.order_enums.Status;
import org.invested.orderservice.model.application.order_enums.TradeType;
import org.invested.orderservice.model.application.order_types.BasicOrder;
import org.invested.orderservice.model.application.order_types.LimitOrder;
import org.invested.orderservice.model.application.order_types.StopLossOrder;
import org.invested.orderservice.model.application.order_types.StopPriceOrder;
import org.invested.orderservice.repository.AccountJPARepo;
import org.invested.orderservice.repository.BasicOrderJPARepo;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
public class BasicOrderService {

    @Autowired
    private BasicOrderJPARepo basicOrderRepo;

    @Autowired
    private AccountJPARepo accountRepo;

    @Autowired
    private AmqpTemplate amqpTemplate;

    // /////////////////////////////////////////////////////////////////
    // Getting Order Information Methods

    /**
     * A method to check to see an order belongs to the requesting user
     * @param orderId A string containing the order id we want to view
     * @param user A string containing the username that is wanting to view the order
     * @return Returns true if it is the users order, otherwise it will be false
     */
    public boolean isUsersOrder(String orderId, String user) {
        BasicOrder order = basicOrderRepo.getBasicOrderById(orderId);

        return order != null && order.getUser().equals(user);
    }

    /**
     * A method to return an order
     * @param orderId A string containing the requested order to fetch
     * @return Returns an order based off of the id
     */
    public BasicOrder getOrder(String orderId) {
        return basicOrderRepo.getBasicOrderById(orderId);
    }

    /**
     * A method for returning a list of orders that the user has
     * @param user A string containing the username that is retrieving their orders
     * @param currentStatus Enum type Status which could be COMPLETED, PENDING, CANCELED
     * @param tradeType Enum type TradeType which could BUY and SELL
     * @return Returns a list of Orders, based off of the filters
     */
    public ArrayList<BasicOrder> getUsersOrders(String user, Status currentStatus, TradeType tradeType) {
        if(currentStatus != null && tradeType != null) {
            return basicOrderRepo.getBasicOrdersByCurrentStatusAndTradeTypeAndUser(currentStatus, tradeType, user);
        } else if (currentStatus != null) {
            return basicOrderRepo.getBasicOrdersByCurrentStatusAndUser(currentStatus, user);
        } else if (tradeType != null) {
            return basicOrderRepo.getBasicOrdersByTradeTypeAndUser(tradeType, user);
        }
        return basicOrderRepo.getBasicOrdersByUser(user);
    }

    // /////////////////////////////////////////////////////////////////
    // Creating Order Methods

    /**
     * A method for creating a Specific Order Object based off the order_type
     * @param username A string containing the username
     * @param orderInfo An JsonNode containing all necessary order information
     * @return A Basic Order object containing all the necessary information, or null if order_type was none of the cases
     */
    public BasicOrder makeOrderClass(String username, JsonNode orderInfo) {
        return switch (orderInfo.get("order_type").asText()) {
            case "basic-order" -> new BasicOrder(
                    UUID.randomUUID().toString(),
                    username,
                    orderInfo.get("ticker").asText(),
                    orderInfo.get("stock_quantity").asDouble(),
                    orderInfo.get("price_per_share").asDouble(),
                    TradeType.valueOf(orderInfo.get("trade_type").asText()));
            case "limit-order" -> new LimitOrder(
                    UUID.randomUUID().toString(),
                    username,
                    orderInfo.get("ticker").asText(),
                    orderInfo.get("stock_quantity").asDouble(),
                    orderInfo.get("price_per_share").asDouble(),
                    TradeType.valueOf(orderInfo.get("trade_type").asText()),
                    orderInfo.get("limit_price").asDouble()
            );
            case "stop-loss-order" -> new StopLossOrder(
                    UUID.randomUUID().toString(),
                    username,
                    orderInfo.get("ticker").asText(),
                    orderInfo.get("stock_quantity").asDouble(),
                    orderInfo.get("price_per_share").asDouble(),
                    TradeType.valueOf(orderInfo.get("trade_type").asText()),
                    orderInfo.get("stop_loss_price").asDouble()
            );
            case "stop-price-order" -> new StopPriceOrder(
                    UUID.randomUUID().toString(),
                    username,
                    orderInfo.get("ticker").asText(),
                    orderInfo.get("stock_quantity").asDouble(),
                    orderInfo.get("price_per_share").asDouble(),
                    TradeType.valueOf(orderInfo.get("trade_type").asText()),
                    orderInfo.get("stop_loss_price").asDouble(),
                    orderInfo.get("limit_price").asDouble()
            );
            default -> null;
        };
    }

    /**
     * A method for actually creating an Order in both SQL for saving and RabbitMQ for sending an email
     * @param basicOrder An Order which contains all the details for the Order
     * @param email The users email so that way we can use it for a RabbitMQ Consumer
     */
    public void createOrder(BasicOrder basicOrder, String email) {

        // Save to database
        basicOrderRepo.save(basicOrder);

        // Update Users Buying Power
        Account userAccount = accountRepo.getAccountByEmail(email);
        double totalOrderPrice = basicOrder.getStockQuantity() * basicOrder.getPricePerShare();
        userAccount.setBuyingPower(userAccount.getBuyingPower() - totalOrderPrice);
        accountRepo.save(userAccount);

        // Setting Base Order Information, because we will fetch information off on the consumer
        Map<String, Object> orderMessage = new HashMap<>() {{
            put("order-id", basicOrder.getId());
            put("user", basicOrder.getUser());
            put("email", email);
        }};

        // Checking to see what type of order it is
        // This way we can send it to the proper queue
        String queue = defineOrderQueue(basicOrder);

        // Send to Specified Order Queue
        sendMessageToQueue(orderMessage, "ORDER_EXCHANGE", queue);

        // Send Placed Order Email
        sendMessageToQueue(orderMessage, "ORDER-EMAIL-EXCHANGE", "order-email.placed");
    }

    /**
     * A method to define which queue to send for the market orders
     * @param order A Basic Order which is going to help determine which queue to send it to
     * @return A string containing the queue we will be sending to
     */
    public String defineOrderQueue(BasicOrder order) {
        if (LimitOrder.class.equals(order.getClass())) {
            return "order.limit-order";
        } else if (StopLossOrder.class.equals(order.getClass())) {
            return "order.stop-loss-order";
        } else if (StopPriceOrder.class.equals(order.getClass())) {
            return "order.stop-price-order";
        }

        return "order.market-order";
    }

    // //////////////////////////////////////////////////////////////////////////////////////////////
    // Util Methods

    /**
     * A method for sending a message to a exchange and queue to RabbitMQ
     * @param message A Map containing the message we will be sending!
     * @param exchange A String defining which exchange will be handling the message
     * @param queue A String defining where the message will stay!
     */
    private void sendMessageToQueue(Map<String, Object> message, String exchange, String queue) {
        amqpTemplate.convertAndSend(exchange, queue, message.toString());
    }

    // /////////////////////////////////////////////////////////////
    // Update Order Methods

    /**
     * A method for canceling a specific order
     * @param orderId A string containing the order we will be canceling!
     * @param email A string containing the email of the user wanting to cancel their order
     */
    public void cancelOrder(String orderId, String email) {
        BasicOrder order = basicOrderRepo.getBasicOrderById(orderId);

        // Check to see if order is pending
        if(order.getCurrentStatus() == Status.PENDING) {
            // Update order fulfilled date and status
            order.setOrderFulFilledDate(LocalDateTime.now());
            order.setCurrentStatus(Status.CANCELED);
            basicOrderRepo.save(order);

            // Update Accounts Buying Power
            Account userAccount = accountRepo.getAccountByEmail(email);
            double totalOrderPrice = order.getStockQuantity() * order.getPricePerShare();
            userAccount.setBuyingPower(userAccount.getBuyingPower() + totalOrderPrice);
            accountRepo.save(userAccount);

            // Sending Message to Canceled Email Queue
            sendMessageToQueue(new HashMap<>() {{
                put("user", order.getUser());
                put("email", email);
                put("order_id", order.getId());
                put("order_status", order.getCurrentStatus());
            }}, "ORDER-EMAIL-EXCHANGE", "order-email.cancel");
        }
    }

    /**
     * A method to CANCEL all orders that are pending
     * @param user A string containing the users id
     * @param email A string containing the users email
     */
    public void cancelAllOrders(String user, String email) {
        ArrayList<BasicOrder> usersOrders = basicOrderRepo.getBasicOrdersByUser(user);

        for(BasicOrder order : usersOrders) {
            cancelOrder(order.getId(), email);
        }
    }

    public void fulfillOrder(String orderId, String email) {
        BasicOrder order = basicOrderRepo.getBasicOrderById(orderId);
        order.setCurrentStatus(Status.COMPLETED);
        order.setOrderFulFilledDate(LocalDateTime.now());
        basicOrderRepo.save(order);

        sendMessageToQueue(new HashMap<>(){{
            put("order-id", order.getId());
            put("status", order.getCurrentStatus());
            put("ticker", order.getTicker());
            put("trade-type", order.getTradeType());
            put("total-cost", order.getStockQuantity() * order.getPricePerShare());
            put("email", email);
        }}, "ORDER-EMAIL-EXCHANGE", "order-email.fulfilled");
    }

    // Adding this so we can decode Principal information
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
