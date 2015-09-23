#!/bin/bash

# The user to run as
USER=www-data

# The group to run as
GROUP=www-data

# How many worker processes should Gunicorn spawn
NUM_WORKERS=3

# current working directory
CWD=$(dirname $(readlink -f "$0"))

# Base project application dir
PROJECT_DIR=$(readlink -f "$CWD/../")

# Django project name
DJANGO_PROJECT_NAME='babyplush'

# Name of project is taken from base project dir, not from django dir (./../../),
# This catalog is virtualenv name too
BASE_NAME=$(basename $(readlink -f "$PROJECT_DIR"))

# Socket file, we will communicte using this unix socket
SOCKET_FILE=$(readlink -f "$PROJECT_DIR/$DJANGO_PROJECT_NAME/runtime/gunicorn.sock")

# WSGI module name
DJANGO_WSGI_MODULE="$DJANGO_PROJECT_NAME.wsgi"

# Debug info
echo "-------------------------------"
echo "project dir: $PROJECT_DIR"
echo "base name (venv): $BASE_NAME"
echo "socket file: $SOCKET_FILE"
echo "Django project name: $DJANGO_PROJECT_NAME"
echo "Django wsgi module: $DJANGO_WSGI_MODULE"
echo "-------------------------------"

# Activate the virtual environment
source ~/.profile
workon $BASE_NAME

# Create the socket directory if it doesn't exist
SOCKET_DIR=$(dirname $SOCKET_FILE)
test -d $SOCKET_DIR || mkdir -p $SOCKET_DIR

# cd to django base dir
cd "$PROJECT_DIR/$DJANGO_PROJECT_NAME"

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $BASE_NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --log-level=debug \
  --bind=unix:$SOCKET_FILE \
  --error-logfile=- \
  --access-logfile=- \
  --log-level=debug \
  --debug
