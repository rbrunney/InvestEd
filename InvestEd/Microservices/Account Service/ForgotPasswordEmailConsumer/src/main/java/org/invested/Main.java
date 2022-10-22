package org.invested;

import org.invested.models.rabbitmq.RabbitMQConsumer;

public class Main {
    public static void main(String[] args) {
        RabbitMQConsumer consumer = new RabbitMQConsumer();
        consumer.startConsumingQueueMessages();
    }
}