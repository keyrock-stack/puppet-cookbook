# == Class: base
#
# Full description of class base here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'base':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2018 Your name here, unless otherwise noted.
#
class base {
  $mysql_password = 'secret'
  file {'/etc/motddd':
    content => "${::fqdn}\nManaged by puppet... ${::puppetversion}\n"
  }
  file {'/etc/erb':
    content =>  template('admin/a.sh.erb'),
    mode => '0755',
  }
   
  exec { 'my-command':
    cwd => '/tmp',
    command =>  template('admin/a.sh.erb'),
    path =>  ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin/'],
  }
}
