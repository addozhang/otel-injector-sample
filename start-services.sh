#!/bin/bash

# OpenTelemetry Injector Cross-Language Microservices Example Startup Script

set -e

echo "🚀 Starting OpenTelemetry Cross-Language Microservices Example..."

# Check if Docker and Docker Compose are installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed, please install Docker first"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed, please install Docker Compose first"
    exit 1
fi

# Build service images
echo "📦 Building service images..."
docker-compose build

# Start infrastructure services
echo "🏗️ Starting infrastructure services (OpenTelemetry Collector + Jaeger)..."
docker-compose up -d otel-collector jaeger

# Wait for services to start
echo "⏳ Waiting for infrastructure services to start..."
sleep 10

# Check service status
echo "🔍 Checking infrastructure service status..."
docker-compose ps otel-collector jaeger

# Start application services
echo "🎯 Starting application services..."
docker-compose up -d service-a service-b service-c

# Wait for application services to start
echo "⏳ Waiting for application services to start..."
sleep 15

# Check all service status
echo "📊 All service status:"
docker-compose ps

echo ""
echo "✅ All services have started!"
echo ""
echo "🌐 Service access addresses:"
echo "  Service-A (Java):    http://localhost:8080"
echo "  Service-B (Node.js): http://localhost:3000"
echo "  Service-C (.NET):    http://localhost:5000"
echo "  Jaeger UI:           http://localhost:16686"
echo ""
echo "🧪 Test command:"
echo "  curl http://localhost:8080/chain"
echo ""
echo "🛑 Stop services:"
echo "  docker-compose down"