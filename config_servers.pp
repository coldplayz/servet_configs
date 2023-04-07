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

# TODOs:
# 1. Use file_line resource to ensure the `export RUBYOPT...` line in /etc/bash.bashrc
# 2. Use an exec resource to apply OpenSSL fix if pyOpenSSL version is not 22.0.0
# 3. Use exec to install mysqlclient from fabfile if not exists
# 4. Use an exec to source the bashrc file on changing

package { 'python3':
  ensure => '3.8.2-0ubuntu2',  # check if it installs pip3 implicitly; no, doesn't
}

# Installs both pip and pip3
package { 'pip':
  ensure  => installed,
  require => Package['python3'],
}

# Apply OpenSSL fix, conditionally; TODO2
exec { 'openssl_fix':
  command => 'fab OpenSSL-fix',  # fab replaces underscores with hyphens when invoking as on CLI
  require => Package['python3', 'pip'],
  path    => "${facts['path']}",
  unless  => "test -d /usr/local/lib/python3.8/dist-packages/pyOpenSSL-22.0.0.dist-info/",
}

# Permanently set environment variable needed for `generate-puppetfile` to
# ...work without encoding errors, using file_line resource from stdlib module; TODO1
file_line { 'rubyopt':
  path => '/etc/bash.bashrc',
  line => "export RUBYOPT='-KU -E utf-8:utf-8'",
}

# Ensure SERVET_USER environment variable set
file_line { 'servet_user':
  path => '/etc/bash.bashrc',
  line => "export SERVET_USER='servet_user'",
}

# Ensure SERVET_PWD environment variable set
file_line { 'servet_pwd':
  path => '/etc/bash.bashrc',
  line => "export SERVET_PWD='servet_pwd'",
}

# Ensure SERVET_HOST environment variable is set
file_line { 'servet_host':
  path => '/etc/bash.bashrc',
  line => "export SERVET_HOST='localhost'",
}

# Ensure SERVET_DB environment variable set
file_line { 'servet_db':
  path => '/etc/bash.bashrc',
  line => "export SERVET_DB='servet_db'",
}

# Source the bashrc file on exporting RUBYOPT env. variable; TODO4
exec { 'source_bashrc':
  command   => 'bash -c "source /etc/bash.bashrc"',
  path      => "${facts['path']}",
  subscribe => File_line['rubyopt'],
}

#package { 'nginx':
#  ensure => '1.18.0-0ubuntu1.4',
#}

service { 'nginx':
  ensure => running,
  enable => true,
}

#package { 'mysql-server':
#  ensure => '8.0.32-0ubuntu0.20.04.2',
#}

# Use the puppetlabs/mysql module; to be installed by user
class { '::mysql::server':
  package_name   => 'mysql-server',
  package_ensure => '8.0.32-0ubuntu0.20.04.2',
  root_password  => '',  # no password
  restart        => true,  # restart service on config change
  # service_provider => 'service',
}

# Already declared in the managing module
#service { 'mysql':
#  ensure => running,
#  enable => true,
#}

#package { 'git':
#  ensure => '1:2.25.1-1ubuntu3.8',
#}

#package { 'curl':
#  ensure => installed,  # version '7.68.0-1ubuntu2.18' on my Android
#}

# Apply pip fix, conditionally
exec { 'pip_fix':
  command => 'fab pip-fix',
  require => Package['python3', 'pip'],
  path    => "${facts['path']}",
  unless  => 'test "$(pip show sqlalchemy)"',
}

# Requirements installed implicitly: [greenlet, typing-extensions]
package { 'SQLAlchemy':
  ensure   => '2.0.1',
  require  => Package['python3', 'pip'],
  provider => pip3,
}

# Install mysqlclient, conditionally; TODO3
exec { 'install_mysqlclient':
  command => 'fab install-mysqlclient',  # fab replaces underscores with hyphens when invoking as on CLI
  require => Package['python3', 'pip'],
  path    => "${facts['path']}",
  unless  => 'test "$(pip show mysqlclient)"',
}

# Requirements installed implicitly: [Jinja2, Werkzeug, click, itsdangerous, importlib-metadata]
package { 'Flask':
  ensure   => '2.2.2',
  require  => Package['python3', 'pip'],
  provider => pip3,
}

package { 'Flask-SQLAlchemy':
  ensure   => '3.0.3',
  require  => Package[
    'python3',
    'pip',
    'Flask',
    'SQLAlchemy',
  ],
  provider => pip3,
}

# Requirements installed implicitly: [Werkzeug]
package { 'Flask-Login':
  ensure   => '0.6.2',
  require  => Package['python3', 'pip', 'Flask'],
  provider => pip3,
}

# Requirements installed implicitly: [six]
package { 'Flask-Cors':
  ensure   => '3.0.10',
  require  => Package['python3', 'pip', 'Flask'],
  provider => pip3,
}

# Requirements installed implicitly: [WTForms, itsdangerous]
package { 'Flask-WTF':
  ensure   => '1.0.1',
  require  => Package['python3', 'pip', 'Flask'],
  provider => pip3,
}

# Requirements installed implicitly: [invoke, paramiko]
package { 'Fabric':
  ensure   => '3.0.0',
  require  => Package['python3', 'pip'],
  provider => pip3,
}

# Requirement: [setuptools]
package { 'gunicorn':
  ensure   => '20.1.0',
  require  => Package['python3', 'pip'],
  provider => pip3,
}
