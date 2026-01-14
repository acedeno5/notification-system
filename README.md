# Notification System — Event-driven microservices (Java 21) ✅
A small, production-like demo showing a Java 21 + Spring Boot event-driven notification system: a REST-based producer publishes JSON messages to a Kafka topic and an email consumer subscribes and exposes a simple UI. This repository demonstrates the upgrade and modernization work needed for multi-module Java projects (dependency alignment, logging, encoding, and reproducible Docker builds).

---

## Quick highlights
- **Language:** Java 21, **Framework:** Spring Boot 3.2.x
- **Messaging:** Apache Kafka (local demo via Docker Compose)
- **Deployment:** Docker (multi-stage), Docker Compose demo, optional Cloud Run deploy script
- **CI:** GitHub Actions workflow included (build + test)

---

## TL;DR for recruiters
- Performed a safe upgrade to Java 21 across a multi-module Maven project and resolved real-world issues (missing dependency versions, SLF4J/logging conflicts, packaging for Docker)
- Added a reproducible demo (producer → Kafka → consumer UI) and CI to showcase the runnable system and maintainability

## Architecture & where to look
```
notification-system/
├── pom.xml (root aggregator)
├── common/                      # shared DTOs & utilities
├── notification-producer/       # REST service (POST /api/notify)
├── email-consumer/              # Kafka consumer + UI (GET /consumer/ui)
├── user-service/                # user management (placeholder)
└── docker/                      # docker-compose (Zookeeper + Kafka + services)
```

Key endpoints (local demo):
- Producer: `POST http://localhost:8080/api/notify` — body: `{"to":"...","message":"..."}`
- Producer health: `GET http://localhost:8080/api/health`
- Consumer API: `GET http://localhost:8081/consumer/api/messages`
- Consumer UI: `GET http://localhost:8081/consumer/ui`

## Tests & CI
- Run tests locally: `mvn -T1C test`
- CI: `.github/workflows/ci.yml` performs a full Maven build & test run on push/PR

Add this badge to the README (replace `acedeno5/notification-system` if different):

```md
[![CI](https://github.com/acedeno5/notification-system/actions/workflows/ci.yml/badge.svg)](https://github.com/acedeno5/notification-system/actions/workflows/ci.yml)
```

## Run the demo locally (recommended, free)
Prerequisites: Docker & Docker Compose.

1) Start the stack (builds images):

```bash
# from repository root
scripts/start-all.sh
```

2) Publish a test message:

```bash
curl -sS -H "Content-Type: application/json" \
  -d '{"to":"user@example.com","message":"Hello from demo"}' \
  http://localhost:8080/api/notify
```

3) View messages in consumer UI:

```bash
open http://localhost:8081/consumer/ui
# or
curl -sS http://localhost:8081/consumer/api/messages | jq
```

4) Stop the stack:

```bash
scripts/stop-all.sh
```

Notes: The consumer keeps a short in-memory list for demo purposes; production systems should use durable storage and monitoring.

---

## Deploy (Optional) — Cloud Run
A helper script `scripts/deploy-to-cloud-run.sh` builds images, pushes to GCR, and deploys Cloud Run services. Use with caution — cloud usage may incur cost.

Prerequisites: `gcloud` configured and authenticated.

Important notes for production:
- Use a managed Kafka service (Confluent Cloud or Kafka on GKE) and secure credentials via secrets or a secret manager
- Configure monitoring, retries, and dead-letter queues for production reliability

---


Notes:
- Docker Compose builds the service using the `notification-producer/Dockerfile` (multi-stage build).
- If you prefer to run locally without Docker, build and run the jar as before (JDK 21 required):

```bash
export JAVA_HOME=/path/to/your/jdk21
mvn -pl notification-producer -am -DskipTests package
$JAVA_HOME/bin/java -jar notification-producer/target/notification-producer-0.1.0-SNAPSHOT.jar
```

---

## Design notes & trade-offs
- **Dependency alignment & BOM:** central dependency management prevents runtime class conflicts (e.g., SLF4J/logging)
- **Multi-stage Docker images:** small, secure images optimized for CI/CD
- **Demo simplicity:** in-memory consumer store for quick validation; swap for durable storage in production

---

## Next improvements (optional)
- Add Testcontainers-based integration tests for Kafka in CI
- Add SpotBugs/Checkstyle in CI for stronger quality gates
- Add an animated demo GIF to improve recruiter visibility

---

## Contribution & License
Contributions welcome via PR. Consider adding a `LICENSE` file (MIT recommended).

---

If you want, I can add a short demo GIF and update the PR description to highlight the changes for reviewers.

## 📈 Scalability Notes
- Add new consumer microservices without modifying existing code  
- Kafka allows millions of messages per minute  
- Stateless architecture enables easy auto-scaling  

## 🧩 Future Enhancements
- Add retry & dead-letter queues  
- Add dashboard for monitoring consumer lag  
- Add JWT authentication  
