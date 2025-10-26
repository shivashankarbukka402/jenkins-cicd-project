FROM openjdk:11-jdk-slim
WORKDIR /app
COPY target/jenkins-cicd-project-1.0-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
