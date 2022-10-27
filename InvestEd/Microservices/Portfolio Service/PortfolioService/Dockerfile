FROM tomcat:latest

COPY ./target/PortfolioService-1.0.jar /usr/local/lib/AccountService.jar

ENTRYPOINT ["java","-jar","/usr/local/lib/AccountService.jar"]

EXPOSE 8080