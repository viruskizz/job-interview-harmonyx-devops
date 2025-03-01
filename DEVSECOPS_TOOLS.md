# DevSecOps Tools Quick Reference

This document provides a quick reference to tools commonly used in DevSecOps practices that may be helpful during the exam.

## Security Scanning Tools

### Static Application Security Testing (SAST)

| Tool                      | Language Support | Description                                                     | Command Example                                                                                |
| ------------------------- | ---------------- | --------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| SonarQube                 | Multi-language   | Code quality and security scanner                               | `docker run -d --name sonarqube -p 9000:9000 sonarqube:latest`                                 |
| Bandit                    | Python           | Finds common security issues in Python code                     | `pip install bandit && bandit -r ./app`                                                        |
| ESLint + security plugins | JavaScript       | Linting with security rules                                     | `npx eslint --ext .js,.jsx ./src`                                                              |
| Semgrep                   | Multi-language   | Fast, lightweight static analysis                               | `docker run --rm -v "${PWD}:/src" returntocorp/semgrep semgrep --config=p/owasp-top-ten ./src` |
| Checkov                   | IaC              | Static analysis for Terraform, CloudFormation, Kubernetes, etc. | `pip install checkov && checkov -d ./infra`                                                    |
| TFSec                     | Terraform        | Security scanner for Terraform                                  | `docker run --rm -v "$(pwd):/src" aquasec/tfsec:latest /src`                                   |

### Dynamic Application Security Testing (DAST)

| Tool      | Type               | Description                               | Command Example                                                                |
| --------- | ------------------ | ----------------------------------------- | ------------------------------------------------------------------------------ |
| OWASP ZAP | Web App Scanner    | Finds vulnerabilities in web applications | `docker run -t owasp/zap2docker-stable zap-baseline.py -t https://example.com` |
| Nikto     | Web Server Scanner | Web server vulnerability scanner          | `docker run --rm -it sullo/nikto -h https://example.com`                       |
| Sqlmap    | SQL Injection      | Automated SQL injection detection         | `docker run --rm -it paoloo/sqlmap -u "https://example.com/?id=1"`             |

ฟ

### Dependency Scanning

| Tool                   | Ecosystem      | Description                                    | Command Example                                                                                                |
| ---------------------- | -------------- | ---------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| OWASP Dependency-Check | Multi-language | Checks dependencies for known vulnerabilities  | `docker run --rm -v "$(pwd):/src" owasp/dependency-check:latest --scan /src --format "HTML" --out /src/report` |
| npm audit              | JavaScript     | Security audit for npm packages                | `npm audit --json`                                                                                             |
| Safety                 | Python         | Checks Python dependencies for vulnerabilities | `pip install safety && safety check -r requirements.txt`                                                       |
| Bundler-audit          | Ruby           | Audit Ruby gems for vulnerabilities            | `bundle audit`                                                                                                 |

### Container Security

| Tool     | Focus          | Description                                            | Command Example                                                                                                                               |
| -------- | -------------- | ------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------- |
| Trivy    | Container, IaC | Comprehensive vulnerability scanner                    | `docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:latest image alpine:latest` |
| Clair    | Container      | Static analysis of vulnerabilities in container images | Via API integration                                                                                                                           |
| Hadolint | Dockerfile     | Linter for Dockerfile                                  | `docker run --rm -i hadolint/hadolint < Dockerfile`                                                                                           |
| Dockle   | Container      | Container image linter for security                    | `docker run --rm -v /var/run/docker.sock:/var/run/docker.sock goodwithtech/dockle:latest myimage:latest`                                      |

### Kubernetes Security

| Tool        | Focus         | Description                                      | Command Example                                                                      |
| ----------- | ------------- | ------------------------------------------------ | ------------------------------------------------------------------------------------ |
| Kubesec     | K8s Manifests | Security risk analysis for Kubernetes resources  | `cat deployment.yaml \| docker run --rm -i kubesec/kubesec:v2 scan /dev/stdin`       |
| Kube-bench  | K8s Cluster   | CIS Kubernetes Benchmark checks                  | `docker run --pid=host -v /etc:/etc:ro -v /var:/var:ro -t aquasec/kube-bench:latest` |
| Kube-hunter | K8s Cluster   | Active scanner for Kubernetes security issues    | `docker run --rm -it aquasec/kube-hunter:latest --remote example.com`                |
| Kube-score  | K8s Manifests | Static analysis of Kubernetes object definitions | `cat deployment.yaml \| kube-score score -`                                          |

## Infrastructure Security

### Cloud Security

| Tool        | Platform    | Description                                          | Command Example                                                                                           |
| ----------- | ----------- | ---------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| ScoutSuite  | Multi-cloud | Multi-cloud security auditing tool                   | `docker run --rm -it --mount type=bind,source=$HOME/.aws,target=/root/.aws nccgroup/scoutsuite scout aws` |
| aws-nuke    | AWS         | Remove all resources from an AWS account             | `aws-nuke -c config.yaml --profile example --no-dry-run`                                                  |
| Prowler     | AWS         | CIS benchmark and security best practices assessment | `docker run --rm -it -v ~/.aws:/root/.aws toniblyx/prowler -r us-east-1 -M csv -F output`                 |
| CloudSploit | Multi-cloud | Cloud security configuration monitoring              | Via CLI or API                                                                                            |

### Network Security

| Tool      | Focus                  | Description                             | Command Example                   |
| --------- | ---------------------- | --------------------------------------- | --------------------------------- |
| Nmap      | Network Scanning       | Network discovery and security auditing | `nmap -sV -sC -A -T4 example.com` |
| OpenVAS   | Vulnerability Scanning | Comprehensive vulnerability scanner     | Via Greenbone Security Assistant  |
| Wireshark | Packet Analysis        | Network protocol analyzer               | GUI or TShark CLI                 |

## CI/CD Security

| Tool                   | Focus   | Description                              | Command Example                                                                                   |
| ---------------------- | ------- | ---------------------------------------- | ------------------------------------------------------------------------------------------------- |
| GitLeaks               | Secrets | Find secrets in git repositories         | `docker run --rm -v $(pwd):/code zricethezav/gitleaks:latest detect --source="/code" --verbose`   |
| detect-secrets         | Secrets | Detect secrets in code                   | `pip install detect-secrets && detect-secrets scan .`                                             |
| OWASP Dependency-Track | SCA     | Continuous component analysis            | Via web interface                                                                                 |
| Trufflehog             | Secrets | Searches for secrets in git repositories | `docker run --rm -it -v "$(pwd):/path" trufflesecurity/trufflehog:latest git file:///path --json` |

## Runtime Security

| Tool    | Focus             | Description                                  | Command Example                                                                                                   |
| ------- | ----------------- | -------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| Falco   | Container Runtime | Cloud-native runtime security                | `docker run -d --name falco --privileged -v /var/run/docker.sock:/var/run/docker.sock falcosecurity/falco:latest` |
| Sysdig  | System Monitoring | Container monitoring and security            | Commercial product with free tier                                                                                 |
| Wazuh   | Host IDS/IPS      | Host-based intrusion detection               | Via manager and agents                                                                                            |
| Osquery | System Analysis   | SQL-powered operating system instrumentation | `osqueryi "SELECT * FROM processes"`                                                                              |

## Performance Testing

| Tool          | Focus        | Description                         | Command Example                                      |
| ------------- | ------------ | ----------------------------------- | ---------------------------------------------------- |
| K6            | Load Testing | Developer-centric load testing tool | `k6 run script.js`                                   |
| Apache JMeter | Load Testing | Load and performance testing        | Via GUI or `jmeter -n -t test.jmx -l results.jtl`    |
| Locust        | Load Testing | Python-based load testing           | `locust -f locustfile.py --host=https://example.com` |
| Gatling       | Load Testing | Load testing with complex scenarios | Via Scala DSL                                        |

## Chaos Engineering

| Tool         | Focus       | Description                      | Command Example         |
| ------------ | ----------- | -------------------------------- | ----------------------- |
| Chaos Mesh   | Kubernetes  | Chaos engineering for Kubernetes | Via Kubernetes operator |
| Litmus       | Kubernetes  | Cloud-native chaos engineering   | Via Kubernetes operator |
| Chaos Monkey | VM/Instance | Randomly terminates instances    | Netflix OSS             |

## Security Monitoring and Incident Response

| Tool                   | Focus             | Description                                | Command Example                                                       |
| ---------------------- | ----------------- | ------------------------------------------ | --------------------------------------------------------------------- |
| Prometheus             | Metrics           | Monitoring system and time series database | `docker run -d --name prometheus -p 9090:9090 prom/prometheus:latest` |
| Grafana                | Visualization     | Metrics visualization and alerting         | `docker run -d --name grafana -p 3000:3000 grafana/grafana:latest`    |
| Elasticsearch + Kibana | Logging           | Log aggregation and visualization          | Via docker-compose or Elastic Cloud                                   |
| TheHive                | Incident Response | Security incident response platform        | Via docker-compose                                                    |

## Compliance

| Tool               | Focus              | Description                       | Command Example                                                                                                  |
| ------------------ | ------------------ | --------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| InSpec             | Compliance Testing | Infrastructure compliance testing | `inspec exec profile --reporter json:output.json`                                                                |
| OpenSCAP           | Compliance         | Security compliance solution      | `oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_pci-dss --results results.xml ssg-rhel7-ds.xml` |
| Compliance Masonry | Documentation      | Compliance documentation tool     | `compliance-masonry docs gitbook`                                                                                |

## API Security

| Tool                          | Focus       | Description                      | Command Example                                                                                            |
| ----------------------------- | ----------- | -------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| OWASP ZAP API Scan            | API Testing | API-focused security scanner     | `docker run -t owasp/zap2docker-stable zap-api-scan.py -t https://api.example.com/openapi.json -f openapi` |
| Postman + Security Collection | API Testing | API testing with security checks | Via Postman collection                                                                                     |
| MobSF                         | Mobile API  | Mobile Security Framework        | `docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest`                     |

## Resources for Learning and Documentation

- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [SANS Cyber Security Resources](https://www.sans.org/blog/)
- [Awesome DevSecOps GitHub Repository](https://github.com/devsecops/awesome-devsecops)
- [DevSecOps Maturity Model](https://dsomm.timo-pagel.de/)
