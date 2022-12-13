package org.invested.accountservice.config.rabbitmq;

import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.core.TopicExchange;
import org.springframework.amqp.rabbit.connection.CachingConnectionFactory;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableMBeanExport;

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
    Queue userUpdateInfoQueue() { return new Queue("updated-info-queue", true);}

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
    Binding userUpdateInfoBinding() {
        return BindingBuilder.bind(userUpdateInfoQueue()).to(topicExchange()).with("email.user-info-update");
    }
}
