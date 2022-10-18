package org.invested.orderservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
import org.invested.orderservice.model.application.order_enums.TradeType;
import org.invested.orderservice.model.application.order_types.BasicOrder;
import org.invested.orderservice.services.BasicOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/invested_order")
public class OrderController {

    @Autowired
    private BasicOrderService basicOrderService;

    // /////////////////////////////////////////////////////////////////////
    // Basic CRUD with orders
    @GetMapping("/get_order_info/{orderId}")
    public ResponseEntity<Map<String, Object>> getOrderInformation(Principal principal, @PathVariable String orderId) {
        if(basicOrderService.isUsersOrder(orderId, principal.getName())) {
            BasicOrder order = basicOrderService.getUsersOrder(orderId);
            return new ResponseEntity<>(new HashMap<>() {{
                put("order-info", order);
            }}, HttpStatus.OK);
        }

        return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }

    @GetMapping("/get_orders")
    public ResponseEntity<Map<String, Object>> getUsersOrders(Principal principal) {
        return new ResponseEntity<>(new HashMap<>() {{
            put("orders", basicOrderService.getUsersOrders(principal.getName()));
        }},HttpStatus.OK);
    }

    @PutMapping("/cancel_order/{orderId}")
    public ResponseEntity<Map<String, Object>> cancelOrder(Principal principal, @PathVariable String orderId) {
        if(basicOrderService.isUsersOrder(orderId, principal.getName())) {
            basicOrderService.cancelOrder(orderId);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }

        return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }

    // ///////////////////////////////////////////////////////////////////////////////
    // Making Orders

    @PostMapping("/basic_order")
    public ResponseEntity<Map<String, Object>> placeBasicOrder(Principal principal, @RequestBody JsonNode basicOrder) {
        try {
            // Making new Order and saving to database
            BasicOrder newOrder =  new BasicOrder(
                    UUID.randomUUID().toString(),
                    principal.getName(),
                    basicOrder.get("ticker").asText(),
                    basicOrder.get("stock_quantity").asDouble(),
                    basicOrder.get("price_per_share").asDouble(),
                    TradeType.valueOf(basicOrder.get("trade_type").asText())
            );

            // createBasicOrder
            basicOrderService.createBasicOrder(newOrder);

            return new ResponseEntity<>(new HashMap<>() {{
                put("message", newOrder.getTicker() + " Order Placed Successfully");
                put("results", new HashMap<>(){{
                    put("order_id", newOrder.getId());
                }});
                put("date-time", LocalDateTime.now());
            }}, HttpStatus.CREATED);
        } catch(Exception e) {
            return new ResponseEntity<>(new HashMap<>() {{
                put("message", e.getMessage());
                put("date-time", LocalDateTime.now());
            }}, HttpStatus.BAD_REQUEST);
        }
    }
}
