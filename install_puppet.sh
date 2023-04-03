#!/usr/bin/env bash
# Install puppet 5.5

apt-get install -y ruby=1:2.7+1 --allow-downgrades
apt-get install -y ruby-augeas
apt-get install -y ruby-shadow
apt-get install -y puppet=5.5.0  # or leave out version number
gem install puppet-lint
