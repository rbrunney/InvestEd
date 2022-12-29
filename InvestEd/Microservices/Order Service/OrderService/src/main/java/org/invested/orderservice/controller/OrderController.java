package org.invested.orderservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
import org.invested.orderservice.model.application.order_enums.Status;
import org.invested.orderservice.model.application.order_enums.TradeType;
import org.invested.orderservice.model.application.order_types.BasicOrder;
import org.invested.orderservice.model.application.order_types.LimitOrder;
import org.invested.orderservice.model.application.order_types.StopLossOrder;
import org.invested.orderservice.model.application.order_types.StopPriceOrder;
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
    // Getting Order End Points

    /**
     * An end point to get an orders information
     * @param principal Used to get the username and email off of our UserPassAuthToken
     * @param orderId A string containing the order that the user is trying to fetch
     * @return An Order Class with it information if valid, otherwise it will be a 400 BAD_REQUEST
     */
    @GetMapping("/get_order_info/{orderId}")
    public ResponseEntity<Map<String, Object>> getOrderInformation(Principal principal, @PathVariable String orderId) {
        if(basicOrderService.isUsersOrder(orderId, principal.getName())) {
            BasicOrder order = basicOrderService.getOrder(orderId);
            return new ResponseEntity<>(new HashMap<>() {{
                put("order-info", order);
            }}, HttpStatus.OK);
        }

        return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }

    /**
     * An end-point for retrieving all the users orders from the database, based off of some filters
     * @param principal Used to get the username and email off of our UserPassAuthToken
     * @param byStatus An Enum Type of Status which helps filter by COMPLETED, PENDING, CANCELED, or None
     * @param byTradeType An Enum Type of Trade Type which helps filter by BUY, SELL, or None
     * @return A list of Orders based off of the filter parameters
     */
    @GetMapping("/get_orders")
    public ResponseEntity<Map<String, Object>> getUsersOrders(Principal principal,
                                                              @RequestParam(required = false) Status byStatus,
                                                              @RequestParam(required = false) TradeType byTradeType) {
        return new ResponseEntity<>(new HashMap<>() {{
            put("orders", basicOrderService.getUsersOrders(principal.getName(), byStatus, byTradeType));
        }}, HttpStatus.OK);
    }

    // /////////////////////////////////////////////////////////////////////
    // Making Orders End Points
    @PostMapping("/order")
    public ResponseEntity<Map<String, Object>> placeBasicOrder(Principal principal, @RequestBody JsonNode orderInfo) {

        // Getting the user information off of UserPassAuthToken from principal
        Map<String, String> userInfo = basicOrderService.convertMsgToMap(principal.getName());
        // Making an order with the given information within the request
        BasicOrder newOrder = basicOrderService.makeOrder(userInfo.get("username"), orderInfo);

        if(newOrder != null) {
            // Creating Order Object In Database
            basicOrderService.createOrder(newOrder, userInfo.get("email").replace("\"", ""));

            return new ResponseEntity<>(new HashMap<>() {{
                put("message", newOrder.getTicker() + " Order Placed Successfully");
                put("results", new HashMap<>(){{
                    put("order_id", newOrder.getId());
                }});
                put("date-time", LocalDateTime.now());
            }}, HttpStatus.CREATED);
        }
        return new ResponseEntity<>(new HashMap<>() {{
            put("message", "Could not create order at this time");
            put("date-time", LocalDateTime.now());
        }}, HttpStatus.BAD_REQUEST);
    }

    @PutMapping("/fulfill_order/{orderId}/{email}")
    public ResponseEntity<Map<String, Object>> fulfillOrder(@PathVariable String orderId, @PathVariable String email) {
        basicOrderService.fulfillOrder(orderId, email);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("/cancel_order/{orderId}")
    public ResponseEntity<Map<String, Object>> cancelOrder(Principal principal, @PathVariable String orderId) {
        Map<String, String> userInfo = basicOrderService.convertMsgToMap(principal.getName());
        if(basicOrderService.isUsersOrder(orderId, userInfo.get("username"))) {
            basicOrderService.cancelOrder(orderId, userInfo.get("email").replace("\"", ""));
            return new ResponseEntity<>(HttpStatus.OK);
        }

        return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }

    @PutMapping("/cancel_all_orders")
    public ResponseEntity<Map<String, Object>> cancelAllOrder(Principal principal) {
        Map<String, String> userInfo = basicOrderService.convertMsgToMap(principal.getName());
        basicOrderService.cancelAllOrders(userInfo.get("user"), userInfo.get("email").replace("\"", ""));

        return new ResponseEntity<>(HttpStatus.OK);
    }
}
