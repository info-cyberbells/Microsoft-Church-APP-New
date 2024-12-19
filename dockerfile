# Use a base Python image
FROM python:3.9-bullseye

# Prevent interactive prompts during apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Update the package lists
RUN apt-get update

# Install system dependencies for PyAudio
RUN apt-get install -y \
    build-essential \
    portaudio19-dev \
    libportaudio2 \
    libportaudiocpp0 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /home/site/wwwroot

# Upgrade pip
RUN python -m pip install --upgrade pip

# Create a virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Create a non-root user
RUN addgroup --system appuser && adduser --system --group appuser
RUN chown -R appuser:appuser /home/site/wwwroot
USER appuser

# Expose the port
EXPOSE 8000

# Set the command to run the application
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "application:app"]
