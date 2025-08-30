#!/bin/bash

# OpenTelemetry Injector Cross-Language Microservices Example Test Script

echo "🧪 Testing OpenTelemetry Cross-Language Microservices Example..."

# Check if services are running
echo "🔍 Checking service status..."
docker-compose ps

echo ""
echo "🌐 Testing service connectivity..."

# Test Service-A health check
echo "Testing Service-A..."
if curl -s http://localhost:8080/health > /dev/null; then
    echo "✅ Service-A (Java) is running"
else
    echo "❌ Service-A (Java) is not responding"
fi

# Test Service-B health check
echo "Testing Service-B..."
if curl -s http://localhost:3000/health > /dev/null; then
    echo "✅ Service-B (Node.js) is running"
else
    echo "❌ Service-B (Node.js) is not responding"
fi

# Test Service-C health check
echo "Testing Service-C..."
if curl -s http://localhost:5000/health > /dev/null; then
    echo "✅ Service-C (.NET) is running"
else
    echo "❌ Service-C (.NET) is not responding"
fi

echo ""
echo "🔗 Testing cross-service call chain..."

# Test the complete call chain
echo "Testing full call chain..."
response=$(curl -s http://localhost:8080/chain)
if [[ $response == *"Service-A"* ]] && [[ $response == *"Service-B"* ]] && [[ $response == *"Service-C"* ]]; then
    echo "✅ Full call chain is working!"
    echo "Response: $response"
else
    echo "❌ Full call chain failed"
    echo "Response: $response"
fi

echo ""
echo "📊 Viewing trace chain..."

# Check if Jaeger is accessible
if curl -s http://localhost:16686 > /dev/null; then
    echo "✅ Jaeger UI is accessible at http://localhost:16686"
    echo "   - Open Jaeger UI to view traces"
    echo "   - Look for service calls in the last few minutes"
else
    echo "❌ Jaeger UI is not accessible"
fi

echo ""
echo "🎉 Testing completed!"
echo ""
echo "💡 Tips:"
echo "   - If services are not responding, wait a few seconds for them to fully start"
echo "   - Use 'docker-compose logs [service-name]' to view service logs"
echo "   - Use 'docker-compose down' to stop all services"