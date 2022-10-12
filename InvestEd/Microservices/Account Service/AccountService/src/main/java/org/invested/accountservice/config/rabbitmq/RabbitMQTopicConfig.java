package org.invested.accountservice.config.rabbitmq;

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

    @Bean
    Queue confirmationEmailQueue() {
        return new Queue("confirmation-email-queue", true);
    }

    @Bean
    Queue forgotPasswordQueue() {
        return new Queue("forgot-pass-queue", true);
    }

    @Bean
    TopicExchange topicExchange() {
        return new TopicExchange("ACCOUNT_EMAIL_EXCHANGE");
    }

    @Bean
    Binding confirmationEmailBinding() {
        return BindingBuilder.bind(confirmationEmailQueue()).to(topicExchange()).with("email.confirmation");
    }

    @Bean
    Binding forgotPassBinding() {
        return BindingBuilder.bind(forgotPasswordQueue()).to(topicExchange()).with("email.forgot-pass");
    }

    @Bean
    public ConnectionFactory connectionFactory() {
        CachingConnectionFactory factory = new CachingConnectionFactory();

        factory.setHost(System.getenv("RABBITMQ_HOST"));
        factory.setPort(Integer.parseInt(System.getenv("RABBITMQ_PORT")));

        return factory;
    }

}
