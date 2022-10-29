package org.invested;

import org.invested.rabbitmq.RabbitMQConsumer;

public class ConsumerMain {
    public static void main(String[] args) {
        RabbitMQConsumer consumer = new RabbitMQConsumer();
        consumer.startConsumingQueueMessages();
    }
}