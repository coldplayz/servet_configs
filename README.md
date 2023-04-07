# A servetMVP Configuration Remote Store
  This repository contains configuration management files for the Servet project.

### Platform
  Linux/Ubuntu 20.04

### Usage Directives
  Creating an environment, especially for the backend to function, is governed by the `governor.sh` shell script. To begin configuration, clone this repository, `cd` into the resulting directory, and run the governor script (under root user) as follows:
  ```sh
  sudo ./governor.sh
  ```
  This script will update the apt package index, install Puppet 5.5 and set up a `servet` environment with some required modules, and hand control over to Puppet to "do its thing."

  After Puppet is done running (with hopefully no errors, cause I've run several tests already), refresh your bash settings like so:
  ```sh
  source /etc/bash.bashrc
  ```
  I have a manifest declaration that was intented to do the refreshing automatically, but doesn't seem to work; probably for reasons not unrelated to execution context.

  Next, to set up the MySQL database for the backend, run:
  ```sh
  ./setup_db.sh
  ```

  Finally, to start the application server and enable it, execute:
  ```sh
  ./start_enable_gunicorn.sh
  ```
