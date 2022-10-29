# Setting base docker file email consumer
FROM openjdk:17-jdk-slim-buster

COPY target/OrderCanceledEmailConsumer-1.0.jar /usr/local/lib/EmailConsumer.jar
COPY src/main/resources/logo/logo.png /user/local/imgs/logo.png

ENTRYPOINT ["java","-jar","/usr/local/lib/EmailConsumer.jar"]