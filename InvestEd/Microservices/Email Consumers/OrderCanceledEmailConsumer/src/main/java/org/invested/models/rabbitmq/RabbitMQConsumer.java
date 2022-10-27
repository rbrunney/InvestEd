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

                    String emailBody = "<link href=\"https://fonts.googleapis.com/css2?family=Rammetto+One&family=Work+Sans&display=swap\" rel=\"stylesheet\">\n" +
                            "    <div style=\"border:2px solid #1f1f1f; margin-left: 10; margin-right: 10;\">\n" +
                            "        <div style=\"background-color: #1f1f1f; text-align: center;\">\n" +
                            "            <img src=\"logo.png\" width=\"150\" height=\"100\" >\n" +
                            "        </div>\n" +
                            "        <div>\n" +
                            "            <h1 style=\"text-align:center;font-size: larger; font-family: 'Work Sans', sans-serif;\">Order Canceled!</h1>\n" +
                            "        </div>\n" +
                            "        <div>\n" +
                            "            <p style=\"font-weight: bold; margin-left: 1%; font-family: 'Work Sans', sans-serif;\">Hello,</p>\n" +
                            "            <p style=\"font-weight: bold; margin-left: 1%; font-family: 'Work Sans', sans-serif;\">Your order has been canceled! Information is below!</p>\n" +
                            "        </div> \n" +
                            "        <div>\n" +
                            "            <p style=\"font-weight: bold; margin-left: 1%; font-family: 'Work Sans', sans-serif;\">Order Id: " + msgToMap.get("order_id")+ "</p>\n" +
                            "            <p style=\"font-weight: bold; margin-left: 1%; font-family: 'Work Sans', sans-serif;\">Order Status: "+ msgToMap.get("order_status")+"</p>\n" +
                            "        </div>\n" +
                            "    </div>";

                    new SendEmail(msgToMap.get("email"), System.getenv("EMAIL_SUBJECT"), emailBody);
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
