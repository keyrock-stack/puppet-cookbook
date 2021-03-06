# Class: endpointgroup
# ===========================
#
# Full description of class endpointgroup here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'endpointgroup':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2018 Your name here, unless otherwise noted.
#
class endpointgroup {
  file {'/etc/motd':
    content => "${::fqdn}\nManaged by puppet... ${::puppetversion}\n"
  }
  exec { 'openstack endpoint list':
        #command     => '/usr/local/bin/openstack endpoint list > ~stack/abcdefg',
        command     => '/bin/ping -c 2 cnn.com > ~stack/abcdefg',
        path        => '/usr/local/bin:/bin',
        #user        => $keystone_user, #refreshonly => true, #creates     => $signing_keyfile, #notify      => Anchor['keystone::service::begin'], #subscribe   => [Anchor['keystone::install::end'], Anchor['keystone::config::end']], #tag         => 'keystone-exec',
  }
  exec { 'TiC endpoint group filtering':
    command => '/bin/echo root >> ~stack/allow4',
    path   => '/usr/bin:/usr/sbin:/bin',
    #unless => 'grep root /usr/lib/cron/cron.allow 2>/dev/null',
  }
  $values = [val1, val2, otherval]
  file {'/etc/epg':
    content =>  template('endpointgroup/endpointgroup.erb'),
    mode => '0755',
  }
}
