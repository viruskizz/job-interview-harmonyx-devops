# Reference Architecture

The diagram `architecture.png` in this repository represents the target architecture for the secure application deployment. This document describes the key components shown in the diagram.

## Overview

The architecture follows modern cloud-native security practices with defense-in-depth approach. It includes multiple security layers spanning from application code to infrastructure and CI/CD pipeline.

## Key Components

### Application Layer
- **Web Application**: Flask-based user management application
- **API Gateway**: Handles authentication and rate limiting
- **Web Application Firewall (WAF)**: Protects against common web attacks
- **Container Security**: Runtime protection and vulnerability management

### Data Layer
- **Database**: Encrypted at rest and in transit
- **Data Validation**: Input/output validation services
- **Secrets Management**: AWS Secrets Manager for credential storage

### Infrastructure Layer
- **Kubernetes Cluster**: EKS with proper security configurations
- **Network Security**: VPC with public/private subnets, NACLs, Security Groups
- **IAM**: Role-based access control for all services
- **Encryption**: TLS for all services and data encryption at rest

### DevSecOps Pipeline
- **Source Control**: GitHub with branch protection
- **CI/CD**: GitHub Actions with security testing
- **Artifact Registry**: ECR with image scanning
- **IaC Security**: Terraform/CloudFormation with security validation
- **Security Testing**: SAST, DAST, SCA, container scanning

### Security Operations
- **Monitoring**: CloudWatch, Prometheus, and Grafana
- **Logging**: Centralized logging with ELK stack
- **SIEM**: Security information and event management
- **Incident Response**: Automated remediation and playbooks

## Security Controls

The architecture implements multiple security controls:

1. **Prevention**: WAF, security groups, IAM policies, input validation
2. **Detection**: Security scanning, monitoring, logging
3. **Response**: Automated remediation, incident response
4. **Recovery**: Backup and restore, disaster recovery

## Implementation Tasks

As part of the DevSecOps extreme interview exam, you are expected to implement key components of this architecture, focusing on:

1. Securing the application code
2. Implementing secure infrastructure as code
3. Setting up a secure CI/CD pipeline
4. Configuring security monitoring and response

Your implementation should demonstrate understanding of cloud-native security principles and DevSecOps practices.
