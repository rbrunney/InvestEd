package org.invested;

import org.invested.model.rabbitmq.RabbitMQConsumer;

public class ConsumerMain {
    public static void main(String[] args) {
        RabbitMQConsumer consumer = new RabbitMQConsumer();
        consumer.startConsumingQueueMessages();
    }
}