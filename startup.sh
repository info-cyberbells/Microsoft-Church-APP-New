#!/bin/bash
cd /home/site/wwwroot
python3 -m pip install -r requirements.txt
gunicorn --bind=0.0.0.0:8000 application:app
