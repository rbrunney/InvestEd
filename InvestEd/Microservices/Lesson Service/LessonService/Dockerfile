FROM tomcat:latest

COPY ./target/LessonService-1.0.jar /usr/local/lib/LessonService.jar

ENTRYPOINT ["java","-jar","/usr/local/lib/LessonService.jar"]

EXPOSE 8080