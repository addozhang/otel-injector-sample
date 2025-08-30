# OpenTelemetry Injector Cross-Language Microservices Example

This example project demonstrates how to use OpenTelemetry Injector to automatically inject observability capabilities into cross-language microservices architecture.

## 🏗️ Architecture Overview

```
Client Request
    ↓
Service-A (Java) → Service-B (Node.js) → Service-C (.NET)
    ↓
OpenTelemetry Collector → Jaeger UI (Distributed Tracing Visualization)
```

**Call Chain Explanation**:
1. Client calls Service-A's `/chain` endpoint
2. Service-A calls Service-B's `/chain` endpoint
3. Service-B calls Service-C's `/chain` endpoint
4. Service-C returns response, passed back to client sequentially
5. The entire call chain is automatically traced and recorded by OpenTelemetry

## 📦 Service Description

### Service-A (Java)
- **Port**: 8080
- **Function**: Initiates call chain, calls Service-B
- **Tech Stack**: Spring Boot + OpenTelemetry Java Agent

### Service-B (Node.js)
- **Port**: 3000
- **Function**: Intermediate service, calls Service-C
- **Tech Stack**: Express.js + OpenTelemetry Node.js SDK

### Service-C (.NET)
- **Port**: 5000
- **Function**: Chain endpoint, returns response
- **Tech Stack**: ASP.NET Core + OpenTelemetry .NET SDK

## 🚀 Quick Start

### 1. Environment Preparation

Ensure the system has installed:
- Java 8+
- Node.js 14+
- .NET 6+
- Docker & Docker Compose

### 2. Install OpenTelemetry Injector

```bash
# Ubuntu/Debian
wget https://github.com/open-telemetry/opentelemetry-injector/releases/download/v1.0.0/opentelemetry-injector_1.0.0_amd64.deb
sudo dpkg -i opentelemetry-injector_1.0.0_amd64.deb

# CentOS/RHEL
wget https://github.com/open-telemetry/opentelemetry-injector/releases/download/v1.0.0/opentelemetry-injector-1.0.0-1.x86_64.rpm
sudo rpm -i opentelemetry-injector-1.0.0-1.x86_64.rpm
```

### 3. Configure OpenTelemetry

Create configuration files:

```bash
# Java service configuration
sudo tee /etc/opentelemetry/otelinject/java.conf << EOF
JAVA_TOOL_OPTIONS=-javaagent:/usr/lib/opentelemetry/javaagent.jar
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
OTEL_SERVICE_NAME=service-a
OTEL_RESOURCE_ATTRIBUTES=service.language=java,service.team=auth
EOF

# Node.js service configuration
sudo tee /etc/opentelemetry/otelinject/node.conf << EOF
NODE_OPTIONS=-r /usr/lib/opentelemetry/otel-js/node_modules/@opentelemetry/auto-instrumentations-node/register
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
OTEL_SERVICE_NAME=service-b
OTEL_RESOURCE_ATTRIBUTES=service.language=nodejs,service.team=product
EOF

# .NET service configuration
sudo tee /etc/opentelemetry/otelinject/dotnet.conf << EOF
CORECLR_ENABLE_PROFILING=1
CORECLR_PROFILER={918728DD-259F-4A6A-AC2B-B85E1B658318}
CORECLR_PROFILER_PATH=/usr/lib/opentelemetry/dotnet/linux-x64/OpenTelemetry.AutoInstrumentation.Native.so
DOTNET_ADDITIONAL_DEPS=/usr/lib/opentelemetry/dotnet/AdditionalDeps
DOTNET_SHARED_STORE=/usr/lib/opentelemetry/dotnet/store
DOTNET_STARTUP_HOOKS=/usr/lib/opentelemetry/dotnet/net/OpenTelemetry.AutoInstrumentation.StartupHook.dll
OTEL_DOTNET_AUTO_HOME=/usr/lib/opentelemetry/dotnet
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
OTEL_SERVICE_NAME=service-c
OTEL_RESOURCE_ATTRIBUTES=service.language=dotnet,service.team=order
EOF
```

### 4. Activate Injector

```bash
# Global activation (for testing environment)
sudo sh -c 'echo /usr/lib/opentelemetry/libotelinject.so >> /etc/ld.so.preload'
```

### 5. Start Services

```bash
# Start OpenTelemetry Collector and Jaeger
docker-compose up -d otel-collector jaeger

# Start microservices
./start-services.sh
```

### 6. Test Trace Chain

```bash
# Send test request
curl http://localhost:8080/chain

# Run automated test script
./test-services.sh

# View Jaeger UI
open http://localhost:16686
```

## 📁 Project Structure

```
otel-injector-sample/
├── service-a/                 # Java Spring Boot service
│   ├── src/
│   ├── pom.xml
│   └── Dockerfile
├── service-b/                 # Node.js Express service
│   ├── src/
│   ├── package.json
│   └── Dockerfile
├── service-c/                 # .NET ASP.NET Core service
│   ├── src/
│   ├── Program.cs
│   └── Dockerfile
├── docker-compose.yml         # Infrastructure orchestration
├── start-services.sh          # Service startup script
└── README.md                  # This documentation
```

## 🔧 Configuration Description

### OpenTelemetry Collector Configuration

```yaml
receivers:
  otlp:
    protocols:
      grpc:
      http:

processors:
  memory_limiter:
    limit_percentage: 75
  batch:
    send_batch_size: 10000

exporters:
  debug:
  otlp/jaeger:
    endpoint: "jaeger:4317"
    tls:
      insecure: true

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: []
      exporters: [debug, otlp/jaeger]
```

## 📊 Verification Results

### 1. View Trace Chain
Access Jaeger UI to view the complete call chain:
- Service-A → Service-B → Service-C
- Execution time and error information for each service

### 2. Check Logs
```bash
# View injection status for each service
sudo journalctl -u service-a -f
sudo journalctl -u service-b -f
sudo journalctl -u service-c -f
```

### 3. Verify Environment Variables
```bash
# Check injected environment variables
strings /proc/$(pidof java)/environ | grep OTEL_
strings /proc/$(pidof node)/environ | grep OTEL_
strings /proc/$(pidof dotnet)/environ | grep OTEL_
```

## 🎯 Learning Objectives

Through this example, you will learn:

1. **Zero-code Integration**: Obtain observability without modifying application code
2. **Cross-language Support**: Unified configuration approach for Java, Node.js, and .NET
3. **Microservice Trace Chain**: Complete distributed system call chain visualization
4. **Configuration Management**: Differences between system-level and service-level configuration
5. **Troubleshooting**: Debugging techniques in multi-language environments

## 📚 Related Documentation

- [OpenTelemetry Injector Homepage](https://github.com/open-telemetry/opentelemetry-injector)
- [OpenTelemetry Official Documentation](https://opentelemetry.io/)
- [Jaeger Documentation](https://www.jaegertracing.io/)

## 🤝 Contributing

Welcome to submit Issues and Pull Requests to improve this example project!

## 📄 License

This project uses the MIT license. See [LICENSE](LICENSE) for details.