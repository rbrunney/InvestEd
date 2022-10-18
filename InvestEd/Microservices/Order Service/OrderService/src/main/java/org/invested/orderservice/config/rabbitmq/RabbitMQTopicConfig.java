package org.invested.orderservice.config.rabbitmq;

import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.core.TopicExchange;
import org.springframework.amqp.rabbit.connection.CachingConnectionFactory;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RabbitMQTopicConfig {

    // //////////////////////////////////////////////////////////
    // Setting up order topic exchange

    @Bean
    Queue marketOrderQueue() {
        return new Queue("market-order-queue", true);
    }

    @Bean
    Queue limitOrderQueue() {
        return new Queue("limit-order-queue'", true);
    }

    @Bean
    Queue stopLossOrderQueue() {
        return new Queue("stop-loss-order-queue", true);
    }

    @Bean
    Queue stopPriceOrderQueue() {
        return new Queue("stop-price-order-queue", true);
    }

    @Bean
    TopicExchange orderExchange() {
        return new TopicExchange("ORDER_EXCHANGE");
    }

    @Bean
    Binding marketOrderBinding() {
        return BindingBuilder.bind(marketOrderQueue()).to(orderExchange()).with("order.market-order");
    }

    @Bean
    Binding limitOrderBinding() {
        return BindingBuilder.bind(limitOrderQueue()).to(orderExchange()).with("order.limit-order");
    }

    @Bean
    Binding stopPriceOrderBinding() {
        return BindingBuilder.bind(stopPriceOrderQueue()).to(orderExchange()).with("order.stop-price-order");
    }

    @Bean
    Binding stopLossOrderBinding() {
        return BindingBuilder.bind(stopLossOrderQueue()).to(orderExchange()).with("order.stop-loss-order");
    }

    // ///////////////////////////////////////////////
    // Setting up Order Email Exchange

    @Bean
    Queue orderPlacedQueue() {
        return new Queue("order-placed-email-queue", true);
    }

    @Bean
    Queue orderFulFilledQueue() {
        return new Queue("order-fulfilled-email-queue", true);
    }

    @Bean
    Queue orderCanceledQueue() {
        return new Queue("order-canceled-email-queue", true);
    }

    @Bean
    TopicExchange orderEmailExchange() {
        return new TopicExchange("ORDER-EMAIL-EXCHANGE");
    }

    @Bean
    Binding orderPlacedBinding() {
        return BindingBuilder.bind(orderPlacedQueue()).to(orderEmailExchange()).with("order-email.placed");
    }

    @Bean
    Binding orderFulFilledBinding() {
        return BindingBuilder.bind(orderFulFilledQueue()).to(orderEmailExchange()).with("order-email.fulfilled");
    }


    @Bean
    Binding orderCanceledBinding() {
        return BindingBuilder.bind(orderCanceledQueue()).to(orderEmailExchange()).with("order-email.cancel");
    }


    // ///////////////////////////////////////////////
    // Setting up basic configuration for rabbitmq
    @Bean
    public ConnectionFactory connectionFactory() {
        CachingConnectionFactory factory = new CachingConnectionFactory();

        factory.setHost(System.getenv("RABBITMQ_HOST"));
        factory.setPort(Integer.parseInt(System.getenv("RABBITMQ_PORT")));

        return factory;
    }

}
