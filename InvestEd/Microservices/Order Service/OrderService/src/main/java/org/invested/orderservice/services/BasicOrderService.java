package org.invested.orderservice.services;

import com.fasterxml.jackson.databind.JsonNode;
import org.invested.orderservice.model.application.order_enums.Status;
import org.invested.orderservice.model.application.order_enums.TradeType;
import org.invested.orderservice.model.application.order_types.BasicOrder;
import org.invested.orderservice.model.application.order_types.LimitOrder;
import org.invested.orderservice.model.application.order_types.StopLossOrder;
import org.invested.orderservice.model.application.order_types.StopPriceOrder;
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
    public BasicOrder makeOrder(String username, JsonNode orderInfo) {
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
     * A method for actually creating an Order in both SQL for saving and RabbitMQ for sending a email
     * @param basicOrder An Order which contains all the details for the Order
     * @param email The users email so that way we can use it for a RabbitMQ Consumer
     */
    public void createOrder(BasicOrder basicOrder, String email) {

        // Save to database
        basicOrderRepo.save(basicOrder);

        // Setting Base Hash Map with Order Information
        Map<String, Object> orderMessage = new HashMap<>() {{
            put("order-id", basicOrder.getId());
            put("user", basicOrder.getUser());
            put("email", email);
            put("ticker", basicOrder.getTicker());
            put("stock-qty", basicOrder.getStockQuantity());
            put("price-per-share", basicOrder.getPricePerShare());
            put("order-date", basicOrder.getOrderDate());
            put("status", basicOrder.getCurrentStatus());
            put("expire-time", basicOrder.getExpireTime());
            put("trade-type", basicOrder.getTradeType());
        }};

        // TODO Break this out to its own method, it has its own logic so would be better to put it in its own method
        // Checking to see what type of order it is
        // This way we can send it to the proper queue
        String queue = "order.market-order";
        if (LimitOrder.class.equals(basicOrder.getClass())) {
            queue = "order.limit-order";
            orderMessage.put("limit-price", ((LimitOrder) basicOrder).getLimitPrice());
        } else if (StopLossOrder.class.equals(basicOrder.getClass())) {
            queue = "order.stop-loss-order";
            orderMessage.put("stop-loss-price", ((StopLossOrder) basicOrder).getStopLossPrice());
        } else if (StopPriceOrder.class.equals(basicOrder.getClass())) {
            queue = "order.stop-price-order";
            orderMessage.put("limit-price", ((StopPriceOrder) basicOrder).getLimitPrice());
            orderMessage.put("stop-loss-price", ((StopPriceOrder) basicOrder).getStopLossPrice());
        }

        // Send to Market Order Queue
        sendMessageToQueue(orderMessage, "ORDER_EXCHANGE", queue);

        // TODO Replace this hashmap with the orderMessage, it is pretty much the same, but need to have certain information
        // Send Placed Order Email
        sendMessageToQueue(new HashMap<>(){{
            put("order-id", basicOrder.getId());
            put("user", basicOrder.getUser());
            put("email", email);
            put("ticker", basicOrder.getTicker());
            put("stock-qty", basicOrder.getStockQuantity());
            put("price-per-share", basicOrder.getPricePerShare());
            put("total-cost", (basicOrder.getPricePerShare() * basicOrder.getStockQuantity()));
            put("trade-type", basicOrder.getTradeType());
            put("status", basicOrder.getCurrentStatus());
        }}, "ORDER-EMAIL-EXCHANGE", "order-email.placed");
    }


    private void sendMessageToQueue(Map<String, Object> message, String exchange, String queue) {
        amqpTemplate.convertAndSend(exchange, queue, message.toString());
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

    public void checkOrderStatus(BasicOrder order, String email) {
        if(order.getCurrentStatus() == Status.CANCELED || order.getCurrentStatus() == Status.COMPLETED) {
            return;
        }

        order.setOrderFulFilledDate(LocalDateTime.now());
        order.setCurrentStatus(Status.CANCELED);
        basicOrderRepo.save(order);

        // Sending Message to Canceled Email Queue
        sendMessageToQueue(new HashMap<>() {{
            put("user", order.getUser());
            put("email", email);
            put("order_id", order.getId());
            put("order_status", order.getCurrentStatus());
        }}, "ORDER-EMAIL-EXCHANGE", "order-email.cancel");
    }

    public void cancelOrder(String orderId, String email) {
        // Need to add check to see it current status. If pending, then we can cancel it.
        // Canceling it we will update the status to cancel
        BasicOrder order = basicOrderRepo.getBasicOrderById(orderId);
        checkOrderStatus(order, email);
    }

    public void cancelAllOrders(String user, String email) {
        ArrayList<BasicOrder> usersOrders = basicOrderRepo.getBasicOrdersByUser(user);

        for(BasicOrder order : usersOrders) {
            checkOrderStatus(order, email);
        }
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
