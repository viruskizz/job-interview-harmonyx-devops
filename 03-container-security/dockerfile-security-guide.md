# Docker Security Best Practices Guide

This guide outlines security best practices for creating secure Docker images and running containers in production environments.

## Secure Dockerfile Best Practices

### Base Image Selection

- **Use Official or Verified Images**: Start with official or verified base images from trusted sources
- **Use Specific Tags**: Always pin to specific image versions using SHA digests
- **Use Minimal Base Images**: Choose alpine or distroless images to reduce attack surface
- **Scan Base Images**: Regularly scan base images for vulnerabilities

### Build Process

- **Multi-stage Builds**: Use multi-stage builds to minimize image size
- **No Secrets in Builds**: Never include secrets in the Dockerfile (even temporarily)
- **Minimize Layers**: Combine commands to reduce the number of layers
- **Update Dependencies**: Update and clean package managers in the same layer

### User and Permissions

- **Non-root User**: Always create and use a non-root user
- **Proper File Permissions**: Set appropriate file permissions
- **Read-only Filesystem**: Mount filesystems as read-only when possible
- **Drop Capabilities**: Remove unnecessary Linux capabilities

### Content

- **Cleanup**: Remove build tools, caches, and temporary files
- **Documentation**: Include metadata and labels for transparency
- **No Backdoors**: Never include debugging tools or backdoors
- **Health Checks**: Implement health checks for better monitoring

## Example of a Secure vs. Insecure Dockerfile

### Insecure Example (Common Vulnerabilities)

```dockerfile
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y python3 python3-pip curl

# Install application
WORKDIR /app
COPY . /app/

# Install Python dependencies
RUN pip install -r requirements.txt

# Hardcoded credentials (BAD PRACTICE)
ENV DB_PASSWORD=password123

# Run as root (BAD PRACTICE)
CMD ["python3", "app.py"]
```

### Secure Example (Best Practices)

```dockerfile
# Use multi-stage build
FROM python:3.9-slim-bullseye@sha256:1c9946a0fef424c88972c3a822f5fbd8e6543bad7adcfbe5c9ae0472deb39c51 AS builder

# Set working directory
WORKDIR /app

# Copy only requirements file first for better caching
COPY requirements.txt .

# Install dependencies in a single layer
RUN pip install --no-cache-dir --user -r requirements.txt

# Second stage with minimal footprint
FROM python:3.9-slim-bullseye@sha256:1c9946a0fef424c88972c3a822f5fbd8e6543bad7adcfbe5c9ae0472deb39c51

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Set working directory
WORKDIR /app

# Copy dependencies from builder stage
COPY --from=builder /root/.local /home/appuser/.local

# Copy application code
COPY --chown=appuser:appuser . .

# Set environment variables
ENV PATH=/home/appuser/.local/bin:$PATH \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Use non-root user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

# Container metadata
LABEL org.opencontainers.image.source="https://github.com/organization/repository" \
      org.opencontainers.image.description="Secure application container" \
      org.opencontainers.image.licenses="MIT" \
      maintainer="security@example.com"

# Run application with explicit port
EXPOSE 8000
CMD ["python", "app.py"]
```

## Container Runtime Security

### Runtime Configuration

- **Read-Only Root Filesystem**: `--read-only` flag
- **CPU and Memory Limits**: Set resource constraints
- **No Privileged Mode**: Never use `--privileged` flag
- **No Host Network**: Avoid `--network=host`
- **Limited Capabilities**: Drop all capabilities and add only required ones

### Example Secure Docker Run Command

```bash
docker run \
  --name secure-app \
  --read-only \
  --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \
  --memory=512m \
  --memory-swap=512m \
  --cpu-shares=1024 \
  --security-opt=no-new-privileges \
  --security-opt seccomp=seccomp-profile.json \
  --health-cmd="curl -f http://localhost:8000/health || exit 1" \
  --health-interval=30s \
  --user=1000:1000 \
  --network=app-network \
  -e "DB_HOST=db.example.com" \
  -v /tmp/app-logs:/app/logs:rw \
  -p 8000:8000 \
  my-secure-app:1.0
```

## Secret Management

- **Use Secret Management Tools**: Use Docker secrets, Kubernetes secrets, HashiCorp Vault, AWS Secrets Manager, etc.
- **Environment Variables**: Avoid sensitive information in environment variables
- **Mount Secrets as Files**: Mount secrets as temporary files instead of environment variables
- **Never Commit Secrets**: Never commit secrets to version control

## Continuous Security

- **Scan Images**: Regularly scan images with tools like Trivy, Clair, or Snyk
- **Runtime Security Monitoring**: Use tools like Falco, Aqua Security, or Sysdig
- **Immutable Infrastructure**: Rebuild and redeploy containers instead of updating them
- **Signed Images**: Sign and verify images with Docker Content Trust

## Kubernetes-Specific Security

- **Pod Security Standards**: Apply Pod Security Standards (Baseline/Restricted)
- **Network Policies**: Implement network policies to restrict pod communication
- **Service Accounts**: Use dedicated service accounts with minimal permissions
- **Security Context**: Configure security context for pods and containers
- **Admission Controllers**: Use OPA/Gatekeeper or Kyverno for policy enforcement
