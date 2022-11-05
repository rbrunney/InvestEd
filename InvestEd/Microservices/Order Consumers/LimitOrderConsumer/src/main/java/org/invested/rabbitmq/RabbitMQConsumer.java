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

                    // Add if check here to see if its within a trading day
                    if (OrderConsumerService.isTradingHours()) {

                        String rabbitmqMessage = new String(body, StandardCharsets.UTF_8);
                        // Get message and convert to a map object
                        Map<String, String> msgToMap = convertMsgToMap(rabbitmqMessage.replace("{", "")
                                .replace("}", "")
                                .replace(" ", ""));

                        double currentPrice = OrderConsumerService.getPriceRequest("http://localhost:8888/invested_stock/" + msgToMap.get("ticker") + "/price");
                        // Check to see if buy or sell
                        switch(msgToMap.get("trade-type")) {
                            case "BUY":
                                if(OrderConsumerService.hasHitBuyLimit(Double.parseDouble(msgToMap.get("limit-price")), currentPrice)) {
                                    OrderConsumerService.putIntoQueue(channel, "order.market-order", new HashMap<>(){{
                                        put("order-id", msgToMap.get("order-id"));
                                        put("user", msgToMap.get("user"));
                                        put("email", msgToMap.get("email"));
                                        put("ticker", msgToMap.get("ticker"));
                                        put("stock-qty", msgToMap.get("stock-qty"));
                                        put("price-per-share", currentPrice);
                                        put("order-date", msgToMap.get("order-date"));
                                        put("status", msgToMap.get("status"));
                                        put("expire-time", msgToMap.get("expire-time"));
                                        put("trade-type", msgToMap.get("trade-type"));
                                    }}.toString().getBytes());
                                } else {
                                    OrderConsumerService.putIntoQueue(channel, "order.limit-order", body);
                                }
                                break;
                            case "SELL":
                                if(OrderConsumerService.hasHitSellLimit(Double.parseDouble(msgToMap.get("limit-price")), currentPrice)) {
                                    OrderConsumerService.putIntoQueue(channel, "order.market-order", new HashMap<>(){{
                                        put("order-id", msgToMap.get("order-id"));
                                        put("user", msgToMap.get("user"));
                                        put("email", msgToMap.get("email"));
                                        put("ticker", msgToMap.get("ticker"));
                                        put("stock-qty", msgToMap.get("stock-qty"));
                                        put("price-per-share", currentPrice);
                                        put("order-date", msgToMap.get("order-date"));
                                        put("status", msgToMap.get("status"));
                                        put("expire-time", msgToMap.get("expire-time"));
                                        put("trade-type", msgToMap.get("trade-type"));
                                    }}.toString().getBytes());
                                } else {
                                    OrderConsumerService.putIntoQueue(channel, "order.limit-order", body);
                                }
                                break;
                        }
                    } else {
                        OrderConsumerService.putIntoQueue(channel, "order.limit-order", body);
                    }
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
