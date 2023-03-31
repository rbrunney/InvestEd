package org.invested.models.rabbitmq;

import org.invested.models.application.order_types.BasicOrder;
import org.invested.services.OrderConsumerService;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class RabbitMQConsumer {

    @Autowired
    private OrderConsumerService orderService;

    @Autowired
    private AmqpTemplate amqpTemplate;

    @RabbitListener(queues = "market-order-queue")
    public void consumeMarketOrderMessages(String message) {
        System.out.println(message);
        try {
//        if(orderService.isTradingHours()) {
            // Get message and convert to a map object
            Map<String, String> convertedMessage = convertMsgToMap(message);
            System.out.println(convertedMessage.get("order-id"));

            // Get Order information
            BasicOrder currentOrder = orderService.getOrder(convertedMessage.get("order-id"));

            // Checking Trade Type and Processing Accordingly
            switch (currentOrder.getTradeType()) {
                case BUY:
                    orderService.executeBuy(currentOrder, convertedMessage.get("portfolio-id"));
                case SELL:
                    orderService.executeSell(currentOrder);
            }

            // Marking Order as Fulfilled
            orderService.completeOrder(currentOrder);
        } catch(Exception e) {
            System.err.println("[ERROR] " + e.getMessage());
        }
//        } else {
//            // If not during trading hours send order back into queue
//            sendMessageToQueue(message, "ORDER_EXCHANGE", "order.market-order");
//        }
    }

    // /////////////////////////////////////////////////////////////////////////
    // Consumer Util Methods

    /**
     * A method for sending a message to a exchange and queue to RabbitMQ
     * @param message A Map containing the message we will be sending!
     * @param exchange A String defining which exchange will be handling the message
     * @param queue A String defining where the message will stay!
     */
    private void sendMessageToQueue(String message, String exchange, String queue) {
        amqpTemplate.convertAndSend(exchange, queue, message);
    }

    /**
     * A method for converting a RabbitMQ Message to a Map Object
     * @param msgToConvert A byte[] which is the message from RabbitMQ
     * @return A Map Object of the RabbitMQ Message
     */
    static private Map<String, String> convertMsgToMap(String msgToConvert) {
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
