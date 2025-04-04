# Stage 1: Builder (for compilation-heavy dependencies)
FROM python:3.8-slim-buster as builder
WORKDIR /app

# Install system dependencies only needed for build
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies (with cache cleanup)
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime (lean final image)
FROM python:3.8-slim-buster
WORKDIR /app

# Copy only what's needed from builder
COPY --from=builder /root/.local /root/.local
COPY . .

# Install runtime system dependencies (minimal set)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    libsm6 \
    libxext6 \
    awscli \
    && rm -rf /var/lib/apt/lists/*

# Ensure Python can find user-installed packages
ENV PATH=/root/.local/bin:$PATH
ENV PYTHONPATH=/root/.local/lib/python3.8/site-packages

CMD ["python3", "app.py"]