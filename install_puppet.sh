#!/usr/bin/env bash
# Install puppet 5.5

apt-get install -y ruby=1:2.7+1 --allow-downgrades
apt-get install -y ruby-augeas  # interacted for timezone setup on container. Run 'dpkg-reconfigure tzdata' if you wish to change the setup.
apt-get install -y ruby-shadow
apt-get install -y puppet='5.5.10-4ubuntu3'  # or leave out version number
gem install puppet-lint
apt-get install -y ruby-full
gem install r10k
gem install generate-puppetfile  # append `export RUBYOPT='-KU -E utf-8:utf-8'` to /etc/bash.bashrc
