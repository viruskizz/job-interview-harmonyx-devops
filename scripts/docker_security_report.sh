#!/bin/bash
# Docker Security Report Generator
# This script analyzes a Docker image for security issues
#
# SECURITY ISSUES:
# 1. No proper error handling
# 2. No integration with CI/CD pipeline
# 3. Limited checks
# 4. No remediation suggestions
# 5. Not using proper tools for scanning

IMAGE_NAME=$1

if [ -z "$IMAGE_NAME" ]; then
    echo "Usage: $0 <image_name:tag>"
    exit 1
fi

echo "Generating security report for Docker image: $IMAGE_NAME"
echo "===================================="

# Check if image exists
docker image inspect $IMAGE_NAME >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Image $IMAGE_NAME does not exist locally"
    exit 1
fi

# Output report header
echo "DOCKER SECURITY REPORT"
echo "Image: $IMAGE_NAME"
echo "Date: $(date)"
echo "===================================="

# Check for latest tag
if [[ "$IMAGE_NAME" == *":latest" ]]; then
    echo "[HIGH] Using 'latest' tag which can lead to unpredictable builds"
else
    echo "[PASS] Not using 'latest' tag"
fi

# Check if image runs as root
USER_INFO=$(docker inspect --format='{{.Config.User}}' $IMAGE_NAME)
if [ -z "$USER_INFO" ] || [ "$USER_INFO" == "root" ] || [ "$USER_INFO" == "0" ]; then
    echo "[HIGH] Image runs as root user"
else
    echo "[PASS] Image runs as non-root user: $USER_INFO"
fi

# Check exposed ports
EXPOSED_PORTS=$(docker inspect --format='{{range $port, $_ := .Config.ExposedPorts}}{{$port}} {{end}}' $IMAGE_NAME)
if [ -z "$EXPOSED_PORTS" ]; then
    echo "[INFO] No exposed ports"
else
    echo "[INFO] Exposed ports: $EXPOSED_PORTS"
    
    # Check for sensitive ports
    for PORT in $EXPOSED_PORTS; do
        if [[ $PORT == *"22/"* ]] || [[ $PORT == *"3389/"* ]]; then
            echo "[HIGH] Potentially dangerous port exposed: $PORT"
        fi
    done
fi

# Check for environment variables with sensitive names
ENV_VARS=$(docker inspect --format='{{range .Config.Env}}{{.}} {{end}}' $IMAGE_NAME)
if [ -n "$ENV_VARS" ]; then
    echo "[INFO] Environment variables found"
    
    # Check for sensitive environment variables
    if [[ $ENV_VARS == *"PASSWORD"* ]] || [[ $ENV_VARS == *"SECRET"* ]] || [[ $ENV_VARS == *"KEY"* ]]; then
        echo "[HIGH] Potentially sensitive information in environment variables"
    fi
fi

# Check image size
IMAGE_SIZE=$(docker inspect --format='{{.Size}}' $IMAGE_NAME)
IMAGE_SIZE_MB=$((IMAGE_SIZE/1000000))
if [ $IMAGE_SIZE_MB -gt 500 ]; then
    echo "[MEDIUM] Image size is large: $IMAGE_SIZE_MB MB - Consider optimizing"
else
    echo "[PASS] Image size is reasonable: $IMAGE_SIZE_MB MB"
fi

# Check for unnecessary packages (simplified example)
echo "[INFO] Basic package check (simulated)"
echo "[INFO] A real implementation would use tools like Trivy, Clair, or Anchore"

# Summary
echo "===================================="
echo "Security scan completed"
echo "Consider using dedicated tools like Trivy, Clair, or Anchore for comprehensive scanning"
echo "===================================="

# SECURITY ISSUE: No proper exit code based on findings
exit 0
