#!/usr/bin/env bash
# Control the setup of the project's database

# Create project database, and user with grants.
cat setup_db.sql | sudo mysql
