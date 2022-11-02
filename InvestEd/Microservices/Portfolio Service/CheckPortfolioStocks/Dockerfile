FROM tomcat:latest

COPY ./target/CheckPortfolioStocks-1.0.jar /usr/local/lib/CheckStockService.jar

ENTRYPOINT ["java","-jar","/usr/local/lib/CheckStockService.jar"]

EXPOSE 8080