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
```bash
docker-compose up --build
```

## 📈 Scalability Notes
- Add new consumer microservices without modifying existing code  
- Kafka allows millions of messages per minute  
- Stateless architecture enables easy auto-scaling  

## 🧩 Future Enhancements
- Add retry & dead-letter queues  
- Add dashboard for monitoring consumer lag  
- Add JWT authentication  
