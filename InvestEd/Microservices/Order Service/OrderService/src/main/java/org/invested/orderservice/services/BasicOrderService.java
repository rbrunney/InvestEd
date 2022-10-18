package org.invested.orderservice.services;

import org.invested.orderservice.model.application.order_types.BasicOrder;
import org.invested.orderservice.repository.BasicOrderJPARepo;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;

@Service
public class BasicOrderService {

    @Autowired
    private BasicOrderJPARepo basicOrderRepo;

    @Autowired
    private AmqpTemplate amqpTemplate;

    public String createBasicOrder(BasicOrder basicOrder) {

        // Save to database
        basicOrderRepo.save(basicOrder);

        // Send to Market Order Queue
        amqpTemplate.convertAndSend("ORDER_EXCHANGE", "order.market-order", new HashMap<String, Object>() {{
            put("order-id", basicOrder.getId());
            put("user", basicOrder.getUser());
            put("ticker", basicOrder.getTicker());
            put("stock-qty", basicOrder.getStockQuantity());
            put("price-per-share", basicOrder.getPricePerShare());
            put("order-date", basicOrder.getOrderDate());
            put("status", basicOrder.getCurrentStatus());
            put("expire-time", basicOrder.getExpireTime());
        }}.toString());

        // Send Placed Order Email
        amqpTemplate.convertAndSend("ORDER-EMAIL-EXCHANGE", "order-email.placed", new HashMap<String, Object>(){{
            put("order-id", basicOrder.getId());
            put("user", basicOrder.getUser());
            put("ticker", basicOrder.getTicker());
            put("stock-qty", basicOrder.getStockQuantity());
            put("price-per-share", basicOrder.getPricePerShare());
            put("total-cost", (basicOrder.getPricePerShare() * basicOrder.getStockQuantity()));
        }}.toString());
        return basicOrder.getId();
    }
    public boolean isUsersOrder(String orderId, String user) {
        BasicOrder order = basicOrderRepo.getBasicOrderById(orderId);

        return order != null && order.getUser().equals(user);
    }

    public BasicOrder getUsersOrder(String orderId) {
        return basicOrderRepo.getBasicOrderById(orderId);
    }

    public ArrayList<BasicOrder> getUsersOrders(String user) {
        return basicOrderRepo.getBasicOrdersByUser(user);
    }
}
