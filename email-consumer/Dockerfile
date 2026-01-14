FROM maven:3.9.6-eclipse-temurin-21 as builder
WORKDIR /workspace
COPY . /workspace
RUN mvn -pl email-consumer -am -DskipTests package -DskipITs -T1C -U

FROM eclipse-temurin:21-jre
ARG JAR=/workspace/email-consumer/target/email-consumer-0.1.0-SNAPSHOT.jar
COPY --from=builder ${JAR} /app/consumer.jar
EXPOSE 8081
ENTRYPOINT ["java","-jar","/app/consumer.jar"]
