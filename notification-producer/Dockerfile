# Multi-stage build: build with Maven, run with a JRE
FROM maven:3.9.6-eclipse-temurin-21 as builder
WORKDIR /workspace
COPY . /workspace
RUN mvn -pl notification-producer -am -DskipTests package -DskipITs -T1C -U

FROM eclipse-temurin:21-jre
ARG JAR=/workspace/notification-producer/target/notification-producer-0.1.0-SNAPSHOT.jar
COPY --from=builder ${JAR} /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
