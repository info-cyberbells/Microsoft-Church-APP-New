#!/bin/bash
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
gunicorn --bind=0.0.0.0 --timeout 600 application:app
