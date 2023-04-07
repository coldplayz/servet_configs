#!/usr/bin/env bash
# Starts and enables the gunicorn application server for Servet.

# Note: run script as root user

systemctl start gunicorn
systemctl enable gunicorn

# Output produced from running above commands:
# Created symlink /etc/systemd/system/multi-user.target.wants/gunicorn.service → /etc/systemd/system/gunicorn.service.
