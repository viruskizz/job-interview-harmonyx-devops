# **🔥 Extreme DevOps Exam – Security & Large-Scale Performance Edition 🔥**

### **🕒 Duration: 4-5 Hours**

**Objective**: Test real-world **DevOps**, **Security**, and **Scalability** skills.

---

## **🚀 Part 1: Security Hardening & Compliance (80 mins)**

### **Task 1: Secure a Misconfigured Docker Container**

### **Scenario:**

You have received a Dockerfile with **critical security vulnerabilities**. Fix them.

### **Steps:**

1. Clone the repo:

   ```bash
   git clone https://github.com/your-repo/devops-extreme-exam.git
   cd devops-extreme-exam
   ```

2. Scan the provided Docker image using **Trivy**:

   ```bash
   trivy image insecure-app:latest
   ```

3. Fix the vulnerabilities:
   - Reduce the attack surface (use a **distroless** or **Alpine-based** image).
   - Remove unnecessary binaries.
   - Use non-root users inside the container.
   - Implement multi-stage builds.
4. Rescan to ensure no **CRITICAL** vulnerabilities remain:

   ```bash
   trivy image secure-app:latest
   ```

**Bonus**:

- Implement **AppArmor** or **Seccomp** to restrict container capabilities.
- Use `docker-bench-security` to audit security:

  ```bash
  docker run --net host --pid host --userns host --cap-add audit_control -e DOCKER_CONTENT_TRUST=1 --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc --label docker_bench_security docker/docker-bench-security

  ```

---

### **Task 2: Secrets Management (30 mins)**

### **Scenario:**

An application is storing database credentials **inside a config file**. Your job is to **secure secrets**.

### **Steps:**

1. **Identify the problem:**
   - Look for hardcoded secrets inside `config.json` or `.env` files.
   - Use `grep` to scan for secrets:
     ```bash
     grep -r "password" .
     ```
2. **Fix it**:
   - **Option 1**: Store secrets in **HashiCorp Vault**.
   - **Option 2**: Use **AWS Secrets Manager** (Simulated locally via **LocalStack**).
   - **Option 3**: Use **Kubernetes Secrets** if running in K8s.
3. **Validate:**
   - Ensure secrets are removed from files.
   - Access secrets securely via environment variables or API calls.

---

### **Task 3: Breaking & Defending a CI/CD Pipeline (30 mins)**

### **Scenario:**

An attacker injects a **malicious script** into your GitHub Actions pipeline. You must:

- **Identify the vulnerability**
- **Fix it**
- **Prevent future attacks**

### **Steps:**

1. **Clone the repo** and analyze `.github/workflows/pipeline.yml`.

   ```bash
   git clone https://github.com/your-repo/devops-extreme-exam.git
   cd devops-extreme-exam
   ```

2. **Find the security issue**:
   - Look for insecure commands (e.g., `curl | bash` without validation).
   - Identify potential **GitHub Action Token Leaks**.
3. **Fix it**:
   - Implement **signatures validation**.
   - Restrict permissions (`read-only` tokens).
   - Remove `set-env` command (deprecated due to security risks).
4. **Bonus**:
   - Use **SAST (Static Application Security Testing)** tools like:
     ```bash
     semgrep --config auto .
     ```

---

## **🚀 Part 2: Large-Scale Performance Testing (90 mins)**

### **Task 4: Stress Testing a Web Application (60 mins)**

### **Scenario:**

A Kubernetes cluster is **crashing under heavy traffic**. You must **simulate traffic**, **analyze performance bottlenecks**, and **optimize the system**.

### **Steps:**

1. Deploy the **test app** locally on **Minikube**:

   ```bash
   kubectl apply -f k8s/deployment.yaml
   ```

2. Simulate **10,000 concurrent users** with **k6**:

   ```bash
   k6 run --vus 10000 --duration 30s load-test.js
   ```

3. Identify bottlenecks:
   - Use `kubectl top pods` to check CPU & Memory usage.
   - Check **Pod Logs** for errors:
     ```bash
     kubectl logs -f <pod-name>
     ```
4. Optimize performance:
   - Enable **Horizontal Pod Autoscaling (HPA)**:
     ```bash
     kubectl autoscale deployment test-app --cpu-percent=50 --min=2 --max=10
     ```
   - Implement **caching** with Redis.
5. **Bonus**:
   - Use `Prometheus` & `Grafana` to visualize performance metrics.
   - Enable **Service Mesh (Istio or Linkerd)** to optimize traffic.

---

### **Task 5: Debugging a Network Issue (30 mins)**

### **Scenario:**

A service is **randomly failing** due to **network latency**. Find and fix the issue.

### **Steps:**

1. **Test network performance**:

   ```bash
   curl -o /dev/null -s -w "%{time_connect} %{time_starttransfer} %{time_total}\n" http://your-service
   ```

2. **Analyze network issues**:
   - Check **latency** with `ping`:
     ```bash
     ping your-service
     ```
   - Check **packet loss** with `iperf`:
     ```bash
     iperf -c your-service -u -b 100M
     ```
3. **Fix it**:
   - Reduce **DNS resolution time** using `CoreDNS` caching.
   - Optimize **ingress traffic** with Nginx or Envoy.
4. **Bonus**:
   - Implement **Circuit Breakers** using Istio.

---

## **🚀 Part 3: Chaos Engineering (Optional)**

### **Task 6: Inject Failures & Recover (30 mins)**

### **Scenario:**

Your Kubernetes service must survive **random failures**.

### **Steps:**

1. **Install Chaos Mesh**:

   ```bash
   kubectl apply -f https://mirrors.chaos-mesh.org/v2.1.1/install.yaml
   ```

2. **Simulate failure**:

   - Kill random pods:

     ```bash

     kubectl delete pod --selector app=test-app
     ```

   - Inject network delay:
     ```bash
     chaosctl attack network-delay --time 5s --namespace=default --selector app=test-app
     ```

3. **Implement Auto-Recovery**:
   - Deploy **self-healing Kubernetes manifests** with `livenessProbe`:
     ```yaml
     livenessProbe:
       httpGet:
         path: /health
         port: 8080
       initialDelaySeconds: 3
       periodSeconds: 5
     ```

---

## **💯 Scoring Criteria**

| **Category**                | **Weight (%)** |
| --------------------------- | -------------- |
| Security Hardening          | 25%            |
| Performance Optimization    | 25%            |
| Debugging & Troubleshooting | 20%            |
| CI/CD & Automation          | 15%            |
| Chaos Engineering           | 10%            |
| Bonus Tasks                 | 5%             |

---

## **📝 Submission Instructions**

1. Push all changes to GitHub.
2. Include a `README.md` explaining:
   - What you did
   - How you fixed security issues
   - Performance optimizations
   - Any bonus tasks completed
