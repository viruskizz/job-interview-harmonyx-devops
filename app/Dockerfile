# SECURITY ISSUE: Using latest tag instead of specific version
FROM python:latest@sha256:8c55c44b9e81d537f8404d0000b7331863d134db87c1385dd0ec7fefff656495 AS builder

WORKDIR /app

# Copy only requirements file first for better caching
COPY requirements.txt .

# Install dependencies in a single layer
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:latest@sha256:8c55c44b9e81d537f8404d0000b7331863d134db87c1385dd0ec7fefff656495

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
    PYTHONUNBUFFERED=1\
    PORT=$PORT

ARG DB_PASSWORD
ARG DEBUG=False
ARG PORT=5000

ENV DB_PASSWORD=$DB_PASSWORD
ENV DEBUG=$DEBUG
ENV PORT=$PORT

USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:${PORT}/health || exit 1

# Container metadata
LABEL org.opencontainers.image.source="https://github.com/viruskizz/job-interview-harmonyx-devops" \
      org.opencontainers.image.description="Secure application container" \
      org.opencontainers.image.licenses="MIT" \
      maintainer="kizzaraiva@gmail.com"

# Run application with explicit port
EXPOSE $PORT

# SECURITY ISSUE: Running with high privileges
CMD ["python", "app.py"]
