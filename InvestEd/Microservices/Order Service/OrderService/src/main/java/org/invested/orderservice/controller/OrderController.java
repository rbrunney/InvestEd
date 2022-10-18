package org.invested.orderservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
import org.invested.orderservice.model.application.order_enums.TradeType;
import org.invested.orderservice.model.application.order_types.BasicOrder;
import org.invested.orderservice.services.BasicOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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

    @PostMapping("/basic_order")
    public ResponseEntity<Map<String, Object>> placeBasicOrder(Principal principal, @RequestBody JsonNode basicOrder) {
        // Making new Order and saving to database
        BasicOrder newOrder =  new BasicOrder(
                UUID.randomUUID().toString(),
                "rbrunney",
                basicOrder.get("ticker").asText(),
                basicOrder.get("stock_quantity").asDouble(),
                TradeType.valueOf(basicOrder.get("trade_type").asText())
        );

        basicOrderService.createBasicOrder(newOrder);

        return new ResponseEntity<>(new HashMap<>() {{
            put("message", newOrder.getTicker() + " Order Placed Successfully");
            put("results", new HashMap<>(){{
                put("order_id", newOrder.getId());
            }});
            put("date-time", LocalDateTime.now());
        }}, HttpStatus.CREATED);
    }
}
