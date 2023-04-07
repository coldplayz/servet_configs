#!/usr/bin/env bash
# Starts and enables the gunicorn application server for Servet.

# Note: run script as root user

systemctl start gunicorn
systemctl enable gunicorn
