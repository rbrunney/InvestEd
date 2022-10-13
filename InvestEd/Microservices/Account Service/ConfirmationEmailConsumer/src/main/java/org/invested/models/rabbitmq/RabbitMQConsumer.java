package org.invested.models.rabbitmq;

import com.rabbitmq.client.*;
import org.invested.models.email.SendEmail;

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
                    Map<String, String> msgToMap = convertMsgToMap(rabbitmqMessage.replace("{", "")
                            .replace("}", "")
                            .replace(" ", ""));

                    String emailBody = "<div>\n" +
                            "        <img src=\"https://i.pinimg.com/736x/ba/92/7f/ba927ff34cd961ce2c184d47e8ead9f6.jpg\"></img>\n" +
                            "    </div>\n" +
                            "    <div>\n" +
                            "        <h1 style=\"text-align:center;\">Welcome to InvestEd!</h1>\n" +
                            "    </div>\n" +
                            "    <div>\n" +
                            "        <h3 style=\"text-align:center;\"> Hello " + msgToMap.get("fname") + " " + msgToMap.get("lname") + " </h3>\n" +
                            "    </div>";

                    new SendEmail(msgToMap.get("email"), "Confirmation Email", emailBody);
                }
            };

            channel.basicConsume("confirmation-email-queue", true, consumer);
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

    private void closeConnection() {
        try {
            currentConnection.close();
        } catch(IOException ioe) {
            System.out.println("[ERROR] " + ioe.getMessage());
        }
    }
}
