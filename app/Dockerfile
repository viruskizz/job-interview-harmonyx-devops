# SECURITY ISSUE: Using latest tag instead of specific version
FROM python:3.9

# SECURITY ISSUE: Running as root
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# SECURITY ISSUE: Exposing unnecessary ports
EXPOSE 5000

# SECURITY ISSUE: Using environment variables for sensitive information
ENV DB_PASSWORD="supersecretpassword"
ENV DEBUG=True

# SECURITY ISSUE: Running with high privileges
CMD ["python", "app.py"]
