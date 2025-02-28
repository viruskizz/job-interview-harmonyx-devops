#!/bin/bash
# IaC Security Scanner Script
# This script scans Terraform files for security issues
#
# SECURITY ISSUES:
# 1. No error handling
# 2. No integration with CI/CD
# 3. Limited rule set
# 4. No remediation suggestions
# 5. Hardcoded credentials

# Set AWS credentials
# SECURITY ISSUE: Hardcoded credentials in script
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_DEFAULT_REGION="us-west-2"

TERRAFORM_DIR=$1

if [ -z "$TERRAFORM_DIR" ]; then
    echo "Usage: $0 <terraform_directory>"
    exit 1
fi

if [ ! -d "$TERRAFORM_DIR" ]; then
    echo "Error: Directory $TERRAFORM_DIR does not exist"
    exit 1
fi

echo "Scanning Terraform files in $TERRAFORM_DIR for security issues..."

# Check for public S3 buckets
echo "Checking for public S3 buckets..."
grep -r "acl.*public" $TERRAFORM_DIR --include="*.tf" || echo "No public S3 buckets found."

# Check for open security groups
echo "Checking for overly permissive security groups..."
grep -r "0.0.0.0/0" $TERRAFORM_DIR --include="*.tf" || echo "No overly permissive security groups found."

# Check for unencrypted resources
echo "Checking for unencrypted resources..."
grep -r "encrypted.*false" $TERRAFORM_DIR --include="*.tf" || echo "No unencrypted resources found."

# Check for hardcoded credentials
echo "Checking for hardcoded credentials..."
grep -r -E "(access_key|secret_key|password|token)" $TERRAFORM_DIR --include="*.tf" || echo "No hardcoded credentials found."

# Check for insecure TLS/SSL
echo "Checking for insecure TLS/SSL configurations..."
grep -r -E "(insecure_ssl|ssl_verification|tls_verification)" $TERRAFORM_DIR --include="*.tf" || echo "No insecure TLS/SSL configurations found."

# Simple output formatting
echo "===================================="
echo "Security scan completed"
echo "===================================="

# SECURITY ISSUE: No proper exit code based on findings
exit 0
