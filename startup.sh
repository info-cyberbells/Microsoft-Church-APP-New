#!/bin/bash
cd /home/site/wwwroot
gunicorn --bind=0.0.0.0:8000 --timeout 600 application:app
