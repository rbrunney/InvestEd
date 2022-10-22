# Setting base docker file email consumer
FROM openjdk:17-jdk-slim-buster

COPY UpdateInfoEmailConsumer-1.0.jar /usr/local/lib/EmailConsumer.jar

ENTRYPOINT ["java","-jar","/usr/local/lib/EmailConsumer.jar"]