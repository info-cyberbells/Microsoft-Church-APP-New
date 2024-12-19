FROM python:3.9-bullseye

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    portaudio19-dev \
    python3-pyaudio \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libc6 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /home/site/wwwroot

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir \
    wheel \
    && pip install --no-cache-dir -r requirements.txt

# Download spacy model
RUN python -m spacy download en_core_web_sm

# Copy application code
COPY . .

# Create non-root user
RUN addgroup --system appuser && adduser --system --group appuser
RUN chown -R appuser:appuser /home/site/wwwroot
USER appuser

# Expose port
EXPOSE 8000

# Default command
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "application:app"]
