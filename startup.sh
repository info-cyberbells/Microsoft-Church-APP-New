#!/bin/bash
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
cd /home/site/wwwroot
gunicorn --bind=0.0.0.0:8000 --timeout 600 application:app
