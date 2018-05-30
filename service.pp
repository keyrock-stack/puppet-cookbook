  exec { 'TiC endpoint group filtering':
    command => '/bin/echo tic >> /tmp/endpointSanity',
    path   => '/usr/bin:/usr/sbin:/bin',
  }

  $cmd = "openstack --os-auth-url http://192.168.204.2:5000/v3 --os-username admin --os-password 'Li69nux*'  endpoint list > /tmp/endpointlist"
  exec { 'endpoint group filtering':
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
      provider    => shell,
      command     => $cmd,
      #subscribe   => Service['keystone'],
      #refreshonly => true,
      #tries       => $retries,
      #try_sleep   => $delay,
      #notify      => Anchor['keystone::service::end'],
  }


