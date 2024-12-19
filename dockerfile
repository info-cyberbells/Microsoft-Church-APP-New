# Use an official Python runtime as a parent image
FROM python:3.9-bullseye

# Prevent Python from writing pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Prevent interactive prompts during apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory in the container
WORKDIR /home/site/wwwroot

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libc6 \
    build-essential \
    && apt-get upgrade -y libc6 \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Create a virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy only the requirements file first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install spacy model
RUN python -m spacy download en_core_web_sm

# Copy the rest of the application code
COPY . .

# Create a non-root user for security
RUN addgroup --system appuser && adduser --system --group appuser
RUN chown -R appuser:appuser /home/site/wwwroot
USER appuser

# Expose the port the app runs on
EXPOSE 8000

# Debugging: print system and library information
RUN python --version && \
    pip list && \
    ldd --version

# Default command to run the application
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "application:app"]
