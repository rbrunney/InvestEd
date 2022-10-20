package org.invested.orderservice.repository;

import org.invested.orderservice.model.application.order_enums.Status;
import org.invested.orderservice.model.application.order_enums.TradeType;
import org.invested.orderservice.model.application.order_types.BasicOrder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.ArrayList;

public interface BasicOrderJPARepo extends JpaRepository<BasicOrder, String> {
    BasicOrder getBasicOrderById(String id);
    ArrayList<BasicOrder> getBasicOrdersByUser(String user);

    // Adding these so we can use them to get specific filters from Database
    ArrayList<BasicOrder> getBasicOrdersByCurrentStatusAndUser(Status currentStatus, String user);
    ArrayList<BasicOrder> getBasicOrdersByTradeTypeAndUser(TradeType tradeType, String user);
    ArrayList<BasicOrder> getBasicOrdersByCurrentStatusAndTradeTypeAndUser(Status currentStatus, TradeType tradeType, String user);
}
