#!/usr/bin/env bash
# Controls the order of execution of various configuration scripts.

# Run this script as the root user

# First update apt package index
apt-get update

# Install Puppet 5.5
# source install_puppet.sh
# Use command -v instead of which; see https://www.shellcheck.net/wiki/SC2230
if [ ! "$(command -v puppet)" ]
then
	fab install_puppet5
fi

# Hand over control to Puppet
puppet apply --environment=servet config_server.pp
