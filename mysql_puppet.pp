# `facter -p` to display all system facts.
# Also `puppet facts` to include custom facts,
# ...and `facter <fact_name>` for specific info.
# fact values can be accessed globally in a manifest using $<fact_name> syntax

# Data types:
# ..String e.g 'a string',
# ..Integer e.g. 58,
# ..Boolean e.g. true,
# ..Array e.g. [45, 'hey', false],
# ..Hash e.g. { 'name' => 'Bayo', 'age' => 33, }

# Use `pip show <package_name>` to show details about a Python package.

# Use `puppet resource <resoure_type> <resource_name>` to show how
# ..puppet would represent the resource, in a manifest, in its current state on the system. E.g. `puppet resource package pip`

#package { 'mysql-server':
#  ensure => '8.0.32-0ubuntu0.20.04.2',
#}

# Use the puppetlabs/mysql module; to be installed by user
class { '::mysql::server':
  package_name     => 'mysql-server',
  package_ensure   => '8.0.32-0ubuntu0.20.04.2',
  root_password    => '',  # no password
  restart          => true,
  # service_provider => 'service',
}

# Already declared in the managing module
#service { 'mysql':
#  ensure => running,
#  enable => true,
#}
