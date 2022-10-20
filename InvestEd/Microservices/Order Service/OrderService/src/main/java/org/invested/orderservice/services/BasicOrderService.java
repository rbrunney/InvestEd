package org.invested.orderservice.services;

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

@Service
public class BasicOrderService {

    @Autowired
    private BasicOrderJPARepo basicOrderRepo;

    @Autowired
    private AmqpTemplate amqpTemplate;

    private void sendMessageToQueue(Map<String, Object> message, String exchange, String queue) {
        amqpTemplate.convertAndSend(exchange, queue, message.toString());
    }

    public void createBasicOrder(BasicOrder basicOrder) {

        // Save to database
        basicOrderRepo.save(basicOrder);

        // Checking to see what type of order it is
        // This way we can send it to the proper queue
        String queue = "order.market-order";
        if (LimitOrder.class.equals(basicOrder.getClass())) {
            queue = "order.limit-order";
        } else if (StopLossOrder.class.equals(basicOrder.getClass())) {
            queue = "order.stop-loss-order";
        } else if (StopPriceOrder.class.equals(basicOrder.getClass())) {
            queue = "order.stop-price-order";
        }

        // Send to Market Order Queue
        sendMessageToQueue(new HashMap<>() {{
            put("order-id", basicOrder.getId());
            put("user", basicOrder.getUser());
            put("ticker", basicOrder.getTicker());
            put("stock-qty", basicOrder.getStockQuantity());
            put("price-per-share", basicOrder.getPricePerShare());
            put("order-date", basicOrder.getOrderDate());
            put("status", basicOrder.getCurrentStatus());
            put("expire-time", basicOrder.getExpireTime());
        }}, "ORDER_EXCHANGE", queue);

        // Send Placed Order Email
        sendMessageToQueue(new HashMap<>(){{
            put("order-id", basicOrder.getId());
            put("user", basicOrder.getUser());
            put("ticker", basicOrder.getTicker());
            put("stock-qty", basicOrder.getStockQuantity());
            put("price-per-share", basicOrder.getPricePerShare());
            put("total-cost", (basicOrder.getPricePerShare() * basicOrder.getStockQuantity()));
        }}, "ORDER-EMAIL-EXCHANGE", "order-email.placed");
    }
    public boolean isUsersOrder(String orderId, String user) {
        BasicOrder order = basicOrderRepo.getBasicOrderById(orderId);

        return order != null && order.getUser().equals(user);
    }

    public BasicOrder getUsersOrder(String orderId) {
        return basicOrderRepo.getBasicOrderById(orderId);
    }

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

    public void checkOrderStatus(BasicOrder order) {
        if(order.getCurrentStatus() == Status.CANCELED || order.getCurrentStatus() == Status.COMPLETED) {
            return;
        }

        order.setOrderFulFilledDate(LocalDateTime.now());
        order.setCurrentStatus(Status.CANCELED);
        basicOrderRepo.save(order);

        // Sending Message to Canceled Email Queue
        sendMessageToQueue(new HashMap<>() {{
            put("user", order.getUser());
            put("order_id", order.getId());
            put("order_status", order.getCurrentStatus());
        }}, "ORDER-EMAIL-EXCHANGE", "order-email.cancel");
    }

    public void cancelOrder(String orderId) {
        // Need to add check to see it current status. If pending, then we can cancel it.
        // Canceling it we will update the status to cancel
        BasicOrder order = basicOrderRepo.getBasicOrderById(orderId);
        checkOrderStatus(order);
    }

    public void cancelAllOrders(String user) {
        ArrayList<BasicOrder> usersOrders = basicOrderRepo.getBasicOrdersByUser(user);

        for(BasicOrder order : usersOrders) {
            checkOrderStatus(order);
        }
    }
}
