FROM python:3.8-slim-buster

WORKDIR /app

# First copy only requirements.txt for better caching
COPY requirements.txt .

# Install system dependencies and clean up in one RUN command
RUN apt-get update && \
    apt-get install -y awscli && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

CMD ["python3", "app.py"]