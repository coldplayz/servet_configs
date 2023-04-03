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

$num1 = 5  # define a variable
$num2 = 23
$num3 = $num1 + $num2
$str1 = 'Greenbel'
$arr1 = [34, 'hey!', false]
$hash1 = {
  'name'      => 'Greenbel',
  'age'       => 33,
  street_name => 'Abayomi',
}

file { '/home/userland/playground/myppfile.txt':
  ensure  => file,
  content => "My content for testing Puppet ${puppetversion} ${facts['os']['hardware']} ${num3}\n",
}
# when interpolating in strings, it's good practice to enclose fact or variable names in braces.
# Also use double quotes, instead of single, if the string will
# ..contain an interpolated fact or variable you'll want expanded (just like in bash shell). You can escape `$` with backslash.

package { 'cowsay':
  ensure => installed
}

notice("${num1} and ${num2}")
notice($num3)
notice($str1 =~ String)
notice($hash1 =~ Hash)
notice($arr1 =~ Array)
notice(true =~ Boolean)
notice($num3 =~ Integer)
notice($hash1[street_name])


exec { 'print variables':
  command   => '/usr/bin/echo ########### $name $hardware',
  logoutput => true
}


file_line { 'add line':
  path => '/home/userland/playground/myppfile.txt',
  line => 'www-data - nofile 32768',
}
