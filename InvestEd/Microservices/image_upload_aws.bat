:: Checking to see if connection is valid with login sucess
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 884873584882.dkr.ecr.us-east-1.amazonaws.com

:: /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:: API's

:: Stock API
docker tag invested-stock-api:1.0 884873584882.dkr.ecr.us-east-1.amazonaws.com/invested:stock-api
docker push 884873584882.dkr.ecr.us-east-1.amazonaws.com/invested:stock-api

:: Account API
docker tag invested-account-api:1.0 884873584882.dkr.ecr.us-east-1.amazonaws.com/invested:account-api
docker push 884873584882.dkr.ecr.us-east-1.amazonaws.com/invested:account-api

:: Portfolio API
docker tag invested-portfolio-api:1.0 884873584882.dkr.ecr.us-east-1.amazonaws.com/invested:portfolio-api
docker push 884873584882.dkr.ecr.us-east-1.amazonaws.com/invested:portfolio-api

:: /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:: Consumers

:: /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
:: Third Party Distributed Systems

:: Gateway
docker tag invested-gateway:1.0 884873584882.dkr.ecr.us-east-1.amazonaws.com/invested:gateway
docker push 884873584882.dkr.ecr.us-east-1.amazonaws.com/invested:gateway

:: Eureka
docker tag steeltoeoss/eureka-server:latest 884873584882.dkr.ecr.us-east-1.amazonaws.com/invested:eureka
docker push 884873584882.dkr.ecr.us-east-1.amazonaws.com/invested:eureka

:: RabbitMQ
docker tag rabbitmq:3-management 884873584882.dkr.ecr.us-east-1.amazonaws.com/invested:rabbitmq
docker push 884873584882.dkr.ecr.us-east-1.amazonaws.com/invested:rabbitmq