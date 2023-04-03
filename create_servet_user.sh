#!/usr/bin/env bash
# Create the user 'servet' and add to the sudo group

# Create the user `servet`
adduser servet

# Add to the sudo group to enable running privileged commands by prefixing `sudo`
usermod -aG sudo servet
