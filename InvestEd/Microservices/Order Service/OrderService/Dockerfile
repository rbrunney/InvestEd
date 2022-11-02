FROM tomcat:latest

COPY ./target/OrderService-1.0.jar /usr/local/lib/OrderService.jar

ENTRYPOINT ["java","-jar","/usr/local/lib/OrderService.jar"]

EXPOSE 8080