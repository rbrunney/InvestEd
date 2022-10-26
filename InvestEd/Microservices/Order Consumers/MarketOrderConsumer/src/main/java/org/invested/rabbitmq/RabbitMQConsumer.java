package org.invested.rabbitmq;

import com.rabbitmq.client.*;
import org.invested.services.OrderConsumerService;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

public class RabbitMQConsumer {
    private final Connection currentConnection;

    public RabbitMQConsumer() {
        currentConnection = makeConnection();
    }

    private Connection makeConnection() {
        try {
            ConnectionFactory factory = new ConnectionFactory();
            factory.setHost(System.getenv("RABBITMQ_HOST"));
            factory.setPort(Integer.parseInt(System.getenv("RABBITMQ_PORT")));
            factory.setUsername(System.getenv("RABBITMQ_USERNAME"));
            factory.setPassword(System.getenv("RABBITMQ_PASSWORD"));
            return factory.newConnection();
        } catch(Exception e) {
            System.out.println("[ERROR] " + e.getMessage());
            return null;
        }
    }

    public void startConsumingQueueMessages() {
        try {
            Channel channel = currentConnection.createChannel();

            DefaultConsumer consumer = new DefaultConsumer(channel) {
                @Override
                public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) {
                    String rabbitmqMessage = new String(body, StandardCharsets.UTF_8);
                    // Get message and convert to a map object
                    Map<String, String> msgToMap = convertMsgToMap(rabbitmqMessage.replace("{", "")
                            .replace("}", "")
                            .replace(" ", ""));

                    // Check to see if its buy or sell
                    String buyingPowerBody = "";
                    switch (msgToMap.get("trade-type")) {
                        case "BUY" -> {
                            OrderConsumerService.buyStock(msgToMap.get("user"), msgToMap.get("ticker"), Double.parseDouble(msgToMap.get("stock-qty")), Double.parseDouble(msgToMap.get("price-per-share")));
                            System.out.println("[BUY] " + msgToMap.get("ticker") + " " + msgToMap.get("order-id"));
                            buyingPowerBody = "{\"total-purchase-price\": -" + Double.parseDouble(msgToMap.get("stock-qty")) * Double.parseDouble(msgToMap.get("price-per-share"))+ "}";
                        }
                        case "SELL" -> {
                            buyingPowerBody = "{\"total-purchase-price\":" + Double.parseDouble(msgToMap.get("stock-qty")) * Double.parseDouble(msgToMap.get("price-per-share"))+ "}";
                        }
                    }
                    // Update Users buying power from here
                    OrderConsumerService.makePutRequest(
                            "http://localhost:8081/invested_account/buying_power/" + msgToMap.get("user"), buyingPowerBody, true);
                    // Update Order to FulFilled
                    OrderConsumerService.makePutRequest("http://localhost:8080/invested_order/fulfill_order/" + msgToMap.get("order-id"), "", false);
                }
            };

            channel.basicConsume(System.getenv("RABBITMQ_QUEUE"), true, consumer);
        } catch(IOException ioe) {
            System.out.println("[ERROR] " + ioe.getMessage());
        }

    }

    private Map<String, String> convertMsgToMap(String msgToConvert) {
        Map<String, String> finalResult = new HashMap<>();

        String[] jsonPairs = msgToConvert.split(",");

        for(String pair : jsonPairs) {
            String[] keyValue = pair.split("=");
            finalResult.put(keyValue[0], keyValue[1]);
        }

        return finalResult;
    }
}
