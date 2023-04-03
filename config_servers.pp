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

package { 'python3':
  ensure => '3.8.2-0ubuntu2',  # check if it installs pip3 implicitly
}

package { 'nginx':
  ensure => '1.18.0-0ubuntu1.4',
}

package { 'mysql-server':
  ensure => '8.0.32-0ubuntu0.20.04.2',
}

#package { 'git':
#  ensure => '1:2.25.1-1ubuntu3.8',
#}

package { 'curl':
  ensure => installed,  # version '7.68.0-1ubuntu2.18' on my Android
}

# Requirements installed implicitly: [greenlet, typing-extensions]
package { 'SQLAlchemy':
  ensure   => '2.0.1',
  require  => Package['python3'],
  provider => pip3,
}

# Requirements installed implicitly: [Jinja2, Werkzeug, click, itsdangerous, importlib-metadata]
package { 'Flask':
  ensure   => '2.2.2',
  require  => Package['python3'],
  provider => pip3,
}

package { 'Flask-SQLAlchemy':
  ensure   => '3.0.3',
  require  => Package[
    'python3',
    'Flask',
    'SQLAlchemy',
  ],
  provider => pip3,
}

# Requirements installed implicitly: [Werkzeug]
package { 'Flask-Login':
  ensure   => '0.6.2',
  require  => Package['python3', 'Flask'],
  provider => pip3,
}

# Requirements installed implicitly: [six]
package { 'Flask-Cors':
  ensure   => '3.0.10',
  require  => Package['python3', 'Flask'],
  provider => pip3,
}

# Requirements installed implicitly: [WTForms, itsdangerous]
package { 'Flask-WTF':
  ensure   => '1.0.1',
  require  => Package['python3', 'Flask'],
  provider => pip3,
}

# Requirements installed implicitly: [invoke, paramiko]
package { 'Fabric':
  ensure   => '3.0.0',
  require  => Package['python3'],
  provider => pip3,
}
