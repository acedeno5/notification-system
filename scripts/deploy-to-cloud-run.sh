#!/usr/bin/env bash
set -euo pipefail

# Simple deploy script to push images to GCR and deploy to Cloud Run
# Usage: ./scripts/deploy-to-cloud-run.sh <PROJECT_ID> <REGION>
# Example: ./scripts/deploy-to-cloud-run.sh my-gcp-project us-central1

PROJECT_ID=${1:-}
REGION=${2:-us-central1}
if [ -z "$PROJECT_ID" ]; then
  echo "Usage: $0 <GCP_PROJECT_ID> [REGION]"
  exit 1
fi

# Build images
echo "Building Docker images..."
docker build -t gcr.io/${PROJECT_ID}/notification-producer:latest ./notification-producer
docker build -t gcr.io/${PROJECT_ID}/email-consumer:latest ./email-consumer

# Push to GCR
echo "Pushing images to Google Container Registry..."
docker push gcr.io/${PROJECT_ID}/notification-producer:latest
docker push gcr.io/${PROJECT_ID}/email-consumer:latest

# Deploy to Cloud Run (publicly accessible for demo)
echo "Deploying to Cloud Run..."
gcloud run deploy notification-producer \
  --image gcr.io/${PROJECT_ID}/notification-producer:latest \
  --region ${REGION} --platform managed --allow-unauthenticated --quiet

gcloud run deploy email-consumer \
  --image gcr.io/${PROJECT_ID}/email-consumer:latest \
  --region ${REGION} --platform managed --allow-unauthenticated --quiet

echo "Deployed. Use:
  gcloud run services describe notification-producer --region ${REGION} --format 'value(status.url)'
  gcloud run services describe email-consumer --region ${REGION} --format 'value(status.url)'"
