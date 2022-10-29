FROM openjdk:latest

ARG JAR_FILE=./target/Gateway-1.0.jar
COPY ${JAR_FILE} Gateway.jar
ENTRYPOINT ["java", "-jar", "./Gateway.jar"]