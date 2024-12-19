FROM ubuntu:20.04

# Prevent interactive prompts during apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install Python, required system libraries, and GLIBC
RUN apt-get update && apt-get install -y \
    python3.9 \
    python3-pip \
    libssl-dev \
    libasound2 \
    build-essential \
    libc6 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories for Azure App Service
RUN mkdir -p /home/site/wwwroot
WORKDIR /home/site/wwwroot

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 8000

# No CMD needed as we'll use startup command from Azure
