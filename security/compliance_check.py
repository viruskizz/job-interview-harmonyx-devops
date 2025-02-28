#!/usr/bin/env python3
"""
Compliance checker script for security standards.
The script scans the infrastructure and generates compliance reports.

SECURITY ISSUES:
1. Does not integrate with CI/CD pipeline
2. Limited compliance standards
3. No remediation guidance
4. Not comprehensive in checks
5. No evidence collection
"""

import os
import sys
import json
import yaml
import argparse
from datetime import datetime

# SECURITY ISSUE: Fixed standards instead of configurable
COMPLIANCE_STANDARDS = {
    "PCI-DSS": {
        "1.1.4": "Install a firewall at each internet connection",
        "1.2.1": "Restrict inbound and outbound traffic",
        "2.1": "Change default passwords",
        "3.4": "Encrypt stored cardholder data",
        "4.1": "Use strong cryptography for sensitive data",
        "6.5": "Address common coding vulnerabilities",
        "8.2": "Use proper authentication methods"
    },
    "HIPAA": {
        "164.312(a)(1)": "Access Control",
        "164.312(a)(2)(i)": "Unique User Identification",
        "164.312(a)(2)(ii)": "Emergency Access Procedure",
        "164.312(c)(1)": "Data Integrity",
        "164.312(e)(1)": "Transmission Security"
    },
    "ISO-27001": {
        "A.5.1.1": "Information security policies",
        "A.8.2.3": "Information handling",
        "A.9.2.3": "Management of privileges",
        "A.10.1.1": "Cryptographic controls policy",
        "A.12.6.1": "Vulnerability management"
    }
}

def check_kubernetes_compliance(namespace):
    """Check Kubernetes resources for compliance violations"""
    print(f"Checking Kubernetes namespace: {namespace}")
    
    # SECURITY ISSUE: Only checking deployments, missing other resources
    # SECURITY ISSUE: Using kubectl directly instead of API
    try:
        # Simulate getting deployments
        print("Checking deployments for security context...")
        print("Checking deployments for resource limits...")
        print("Checking deployments for proper image tags...")
        
        # SECURITY ISSUE: No real checks, just simulation
        compliance_issues = [
            {"resource": "app-deployment", "rule": "PCI-DSS-6.5", "description": "No security context defined"},
            {"resource": "app-deployment", "rule": "ISO-27001-A.12.6.1", "description": "Using latest tag for container image"}
        ]
        
        return compliance_issues
    except Exception as e:
        print(f"Error checking Kubernetes compliance: {e}")
        return []

def check_terraform_compliance(terraform_dir):
    """Check Terraform files for compliance violations"""
    print(f"Checking Terraform directory: {terraform_dir}")
    
    if not os.path.exists(terraform_dir):
        print(f"Error: Directory {terraform_dir} does not exist")
        return []
    
    # SECURITY ISSUE: Basic checks only
    try:
        # Simulate checking terraform files
        print("Checking for encryption configuration...")
        print("Checking for public exposure...")
        print("Checking for IAM permissions...")
        
        # SECURITY ISSUE: No real checks, just simulation
        compliance_issues = [
            {"resource": "aws_s3_bucket.app_data", "rule": "PCI-DSS-3.4", "description": "Encryption not enabled"},
            {"resource": "aws_security_group.app_sg", "rule": "PCI-DSS-1.2.1", "description": "Open to world (0.0.0.0/0)"}
        ]
        
        return compliance_issues
    except Exception as e:
        print(f"Error checking Terraform compliance: {e}")
        return []

def check_dockerfile_compliance(dockerfile_path):
    """Check Dockerfile for compliance violations"""
    print(f"Checking Dockerfile: {dockerfile_path}")
    
    if not os.path.exists(dockerfile_path):
        print(f"Error: File {dockerfile_path} does not exist")
        return []
    
    # SECURITY ISSUE: Basic checks only
    try:
        # Simulate checking Dockerfile
        print("Checking for root user...")
        print("Checking for secure base images...")
        print("Checking for package vulnerabilities...")
        
        # SECURITY ISSUE: No real checks, just simulation
        compliance_issues = [
            {"resource": "Dockerfile", "rule": "PCI-DSS-2.1", "description": "Running as root user"},
            {"resource": "Dockerfile", "rule": "HIPAA-164.312(a)(1)", "description": "No user access controls"}
        ]
        
        return compliance_issues
    except Exception as e:
        print(f"Error checking Dockerfile compliance: {e}")
        return []

def generate_report(issues, output_format="json"):
    """Generate compliance report from issues"""
    if not issues:
        print("No compliance issues found.")
        return
    
    # SECURITY ISSUE: Limited output formats
    if output_format == "json":
        report = {
            "timestamp": datetime.now().isoformat(),
            "total_issues": len(issues),
            "issues": issues
        }
        return json.dumps(report, indent=2)
    else:
        # Simple text report
        report = f"Compliance Report ({datetime.now().isoformat()})\n"
        report += f"Total Issues: {len(issues)}\n\n"
        
        for i, issue in enumerate(issues, 1):
            report += f"Issue {i}:\n"
            report += f"  Resource: {issue['resource']}\n"
            report += f"  Rule: {issue['rule']}\n"
            report += f"  Description: {issue['description']}\n\n"
        
        return report

def main():
    parser = argparse.ArgumentParser(description="Compliance Checker")
    parser.add_argument("--k8s-namespace", help="Kubernetes namespace to check")
    parser.add_argument("--terraform-dir", help="Terraform directory to check")
    parser.add_argument("--dockerfile", help="Dockerfile to check")
    parser.add_argument("--output", choices=["json", "text"], default="text", help="Output format")
    
    args = parser.parse_args()
    
    all_issues = []
    
    if args.k8s_namespace:
        issues = check_kubernetes_compliance(args.k8s_namespace)
        all_issues.extend(issues)
    
    if args.terraform_dir:
        issues = check_terraform_compliance(args.terraform_dir)
        all_issues.extend(issues)
    
    if args.dockerfile:
        issues = check_dockerfile_compliance(args.dockerfile)
        all_issues.extend(issues)
    
    if not (args.k8s_namespace or args.terraform_dir or args.dockerfile):
        print("Error: Please specify at least one target to check")
        parser.print_help()
        sys.exit(1)
    
    report = generate_report(all_issues, args.output)
    print(report)
    
    # SECURITY ISSUE: No integration with CI/CD pipeline (no exit code based on findings)
    # SECURITY ISSUE: No report storage or forwarding to compliance systems

if __name__ == "__main__":
    main()
