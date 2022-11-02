FROM openjdk:17-jdk-slim-buster

COPY target/MarketOrderConsumer-1.0.jar /usr/local/lib/OrderConsumer.jar

ENTRYPOINT ["java","-jar","/usr/local/lib/OrderConsumer.jar"]