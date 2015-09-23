#!/bin/bash

# current working directory
CWD=$(dirname $(readlink -f "$0"))

# Base project application dir
PROJECT_DIR=$(readlink -f "$CWD/../")

# Name of project is taken from base project dir, not from django dir (./../../),
# This catalog is virtualenv name too
BASE_NAME=$(basename $(readlink -f "$PROJECT_DIR"))

# Django project name
DJANGO_PROJECT_NAME='orgparts'

# Debug info
echo "-------------------------------"
echo "project dir: $PROJECT_DIR"
echo "base name (venv): $BASE_NAME"
echo "-------------------------------"

# Activate the virtual environment
source ~/.profile
workon $BASE_NAME
python orgparts/manage.py rqworker
