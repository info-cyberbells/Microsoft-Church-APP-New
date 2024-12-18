#!/bin/bash

# Install required system dependencies
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y wget

# Download and install a compatible version of GLIBC
wget http://ftp.us.debian.org/debian/pool/main/g/glibc/libc6_2.29-1_amd64.deb
dpkg -i libc6_2.29-1_amd64.deb

# Start Gunicorn
gunicorn --bind=0.0.0.0:8000 application:app
