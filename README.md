# Scalable Event-Driven Notification System  
A distributed microservices application for handling high-volume notifications (email, SMS, push) using Kafka, Spring Boot, and Docker. Modeled after large-scale architectures used at Meta, Uber, and Amazon.

## 🚀 Features
- Event-driven, asynchronous communication using **Apache Kafka**
- Microservices for:
  - User management  
  - Notification producer  
  - Email/SMS/Push consumers  
- Horizontal scalability for high-volume workloads  
- REST APIs for event triggering  
- Centralized DTO + shared utilities  
- Docker-compose environment (Kafka + Zookeeper + services)

## 🛠️ Tech Stack
- **Java, Spring Boot**
- **Apache Kafka, Zookeeper**
- **Docker & Docker Compose**
- **H2 / PostgreSQL**
- **RESTful APIs**

## 📁 Architecture
```
notification-system/
 ├── user-service/
 ├── notification-producer/
 ├── notification-consumers/
 │     ├── email-consumer/
 │     ├── sms-consumer/
 │     └── push-consumer/
 ├── common/
 └── docker/
```

## 📡 System Workflow
1. User-service triggers an event  
2. Producer publishes messages to Kafka topic  
3. Consumers pick up notifications  
4. Email/SMS/Push logic executes asynchronously  

## 🧪 Testing
- Unit tests for service + controller layers  
- Integration tests w/ Kafka Test Containers  

## ▶️ Running the System
Use Docker Compose to run a local development stack (Kafka + Zookeeper + `notification-producer`).

1) Build & run with Docker Compose (recommended):

```bash
# from repo root
scripts/start-all.sh
```

2) Stop the stack:

```bash
scripts/stop-all.sh
```

3) Validate the producer service:

```bash
# health check
curl -sS http://localhost:8080/api/health

# test notify
curl -sS -H "Content-Type: application/json" -d '{"to":"user@example.com","message":"Hello"}' http://localhost:8080/api/notify
```

---

## ☁️ Deploy to Google Cloud (Cloud Run)
This repo includes a convenience script to build Docker images, push them to Google Container Registry (GCR), and deploy them to Cloud Run.

Prerequisites:
- Google Cloud SDK installed and authenticated (`gcloud auth login`)
- `gcloud` project set (`gcloud config set project <PROJECT_ID>`)
- Enable Cloud Run APIs: `gcloud services enable run.googleapis.com artifactregistry.googleapis.com`

Quick steps:

```bash
# make script executable
chmod +x scripts/deploy-to-cloud-run.sh

# deploy (replace PROJECT_ID and optional region)
./scripts/deploy-to-cloud-run.sh <PROJECT_ID> us-central1
```

After deploy, get the service URLs:

```bash
# get public URLs
gcloud run services describe notification-producer --region us-central1 --format 'value(status.url)'
gcloud run services describe email-consumer --region us-central1 --format 'value(status.url)'
```

Notes:
- For production, use Artifact Registry instead of GCR and secure your services with IAM or IAP instead of `--allow-unauthenticated`.
- For Kafka in Cloud, use Confluent Cloud or run Kafka on GKE; you’ll need to configure `spring.kafka.bootstrap-servers` and credentials in `application.properties` or use secrets.

---

## ✅ CI (GitHub Actions)
This repository includes a GitHub Actions workflow that runs on push and pull requests to the `main` branch. The workflow builds the project, runs tests, and uploads built JARs as artifacts.

Add a CI badge to your README (replace `OWNER/REPO` with your GitHub repository):

```md
[![CI](https://github.com/OWNER/REPO/actions/workflows/ci.yml/badge.svg)](https://github.com/OWNER/REPO/actions/workflows/ci.yml)
```

You can extend the workflow to build Docker images and push them to an image registry if you provide credentials as GitHub Secrets. For now it performs a full Maven build and test run, which is free to run on GitHub Actions for public repositories.

---

Notes:
- Docker Compose builds the service using the `notification-producer/Dockerfile` (multi-stage build).
- If you prefer to run locally without Docker, build and run the jar as before (JDK 21 required):

```bash
export JAVA_HOME=/Users/_.alanc/Library/Java/JavaVirtualMachines/openjdk-21.0.1/Contents/Home
mvn -pl notification-producer -am -DskipTests package
$JAVA_HOME/bin/java -jar notification-producer/target/notification-producer-0.1.0-SNAPSHOT.jar
```


## 📈 Scalability Notes
- Add new consumer microservices without modifying existing code  
- Kafka allows millions of messages per minute  
- Stateless architecture enables easy auto-scaling  

## 🧩 Future Enhancements
- Add retry & dead-letter queues  
- Add dashboard for monitoring consumer lag  
- Add JWT authentication  
