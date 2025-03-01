# Common CI/CD Pipeline Vulnerabilities

This document outlines common security vulnerabilities in CI/CD pipelines that candidates should identify and fix during the exam.

## 1. Secrets Management

- **Hardcoded Secrets**: Credentials, API keys, and tokens stored directly in code or configuration files
- **Insecure Secrets Storage**: Using environment variables without proper encryption or protection
- **Lack of Secrets Rotation**: Static, long-lived credentials that are rarely or never rotated
- **Overly Permissive Credentials**: Using credentials with excessive permissions

## 2. Supply Chain Vulnerabilities

- **Dependency Confusion**: Confusion between internal and external package sources
- **Typosquatting**: Using packages with names similar to legitimate packages
- **Compromised Dependencies**: Using dependencies with known vulnerabilities
- **Unpinned Dependencies**: Not specifying exact versions of dependencies

## 3. Pipeline Configuration Issues

- **Insecure Pipeline Definitions**: Pipeline configurations that can be modified by unauthorized users
- **Script Injection**: Unsanitized inputs that can be exploited to inject malicious code
- **Lack of Build Provenance**: No cryptographic verification of build artifacts
- **Build Server Compromise**: Insecure build servers that can be compromised

## 4. Infrastructure Vulnerabilities

- **Excessive Permissions**: CI/CD systems with unnecessary permissions to production environments
- **Insecure Runners**: Build runners with direct access to sensitive resources
- **Lack of Network Segmentation**: No separation between build and production environments
- **Insecure Artifact Storage**: Artifacts stored without proper access controls or integrity verification

## 5. Process Issues

- **Lack of Approval Gates**: No required approvals for sensitive operations or deployments
- **Bypassing Security Checks**: Ability to skip or bypass security scanning
- **Manual Interventions**: Processes that rely on manual steps that can be forgotten
- **Lack of Audit Trails**: No logging of pipeline actions and approvals

## 6. Mitigation Strategies

- Implement proper secrets management using a dedicated solution
- Use pinned dependencies and verify integrity of packages
- Implement least privilege access for all pipeline components
- Use signed commits and verify build provenance
- Implement proper approval gates and audit logging
- Separate build environments from production environments
- Implement comprehensive security scanning at multiple stages
