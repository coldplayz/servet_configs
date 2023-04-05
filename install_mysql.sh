#!/usr/bin/env bash
# Script for installing MySQL

apt-get install gnupg  # required for the next command

apt-key adv --keyserver pgp.mit.edu --recv-keys 3A79BD29  # get GPG keys


echo "deb http://repo.mysql.com/apt/ubuntu/ bionic mysql-8.0" >> /etc/apt/sources.list.d/mysql.list  # register repo for mysql-8.0 resource; format: deb http://repo.mysql.com/apt/{debian|ubuntu}/ {buster|bionic} {mysql-5.7|mysql-8.0|workbench-8.0|connector-python-8.0}

apt-get update  # so that the newly added repo can reflect

apt install -f mysql-client=8.0* mysql-community-server=8.0* mysql-server=8.0*  # install mysql v8
