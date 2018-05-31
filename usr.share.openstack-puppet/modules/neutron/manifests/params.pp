# == Class: neutron::params
#
# Parameters for puppet-neutron
#
class neutron::params {
  include ::openstacklib::defaults

  $client_package              = 'python-neutronclient'
  $server_service              = 'neutron-server'
  #$ovs_agent_service           = 'neutron-openvswitch-agent'
  #$linuxbridge_agent_service   = 'neutron-linuxbridge-agent'
  #$cisco_config_file           = '/etc/neutron/plugins/cisco/cisco_plugins.ini'
  $opencontrail_plugin_package = 'neutron-plugin-contrail'
  $opencontrail_config_file    = '/etc/neutron/plugins/opencontrail/ContrailPlugin.ini'
  #$midonet_server_package      = 'python-networking-midonet'
  #$midonet_server_package_ext  = 'python-networking-midonet-ext'
  #$midonet_config_file         = '/etc/neutron/plugins/midonet/midonet.ini'
  $ovn_plugin_package          = 'python-networking-ovn'
  $vpp_plugin_package          = 'python-networking-vpp'
  $vpp_agent_service           = 'neutron-vpp-agent'
  #$plumgrid_plugin_package     = 'networking-plumgrid'
  #$plumgrid_pythonlib_package  = 'plumgrid-pythonlib'
  #$plumgrid_config_file        = '/etc/neutron/plugins/plumgrid/plumgrid.ini'
  $nuage_config_file           = '/etc/neutron/plugins/nuage/plugin.ini'
  $dhcp_agent_service          = 'neutron-dhcp-agent'
  $lbaasv2_agent_service       = 'neutron-lbaasv2-agent'
  $haproxy_package             = 'haproxy'
  #$metering_agent_service      = 'neutron-metering-agent'
  #$vpnaas_agent_service        = 'neutron-vpn-agent'
  $l3_agent_service            = 'neutron-avr-agent'
  $metadata_agent_service      = 'neutron-metadata-agent'
  $metadata_agent_package = undef
  $bagpipe_bgp_package         = 'openstack-bagpipe-bgp'
  $bgpvpn_bagpipe_package      = 'python-networking-bagpipe'
  $bgpvpn_bagpipe_service      = 'bagpipe-bgp'
  $bgpvpn_plugin_package       = 'python-networking-bgpvpn'
  $l2gw_agent_service          = 'neutron-l2gw-agent'
  $nsx_plugin_package          = 'vmware-nsx'
  $nsx_config_file             = '/etc/neutron/plugins/vmware/nsx.ini'
  $vswitch_agent_service       = 'neutron-avs-agent'
  $router_scheduler_driver  = 'neutron.scheduler.l3_agent_scheduler.HostBasedScheduler'
  $network_scheduler_driver = 'neutron.scheduler.dhcp_agent_scheduler.HostBasedScheduler'
  $router_status_managed = true
  $bgp_dragent_service         = 'neutron-bgp-dragent'

  # CentOS is in the Redhat osfamily
  if($::osfamily == 'Redhat') {
    $nobody_user_group          = 'nobody'
    $package_name               = 'openstack-neutron'
    $server_package             = false
    #$ml2_server_package         = 'openstack-neutron-ml2'
    $ml2_server_package = false
    #$ovs_agent_package          = false
    #$ovs_server_package         = 'openstack-neutron-openvswitch'
    #$ovs_cleanup_service        = 'neutron-ovs-cleanup'
    #$libnl_package              = 'libnl'
    #$package_provider           = 'rpm'
    #$linuxbridge_agent_package  = false
    #$linuxbridge_server_package = 'openstack-neutron-linuxbridge'
    $sriov_nic_agent_service    = 'neutron-sriov-nic-agent'
    $sriov_nic_agent_package    = 'openstack-neutron-sriov-nic-agent'
    $bigswitch_lldp_package     = 'openstack-neutron-bigswitch-lldp'
    #$bigswitch_agent_package    = 'openstack-neutron-bigswitch-agent'
    #$bigswitch_lldp_service     = 'neutron-bsn-lldp'
    #$bigswitch_agent_service    = 'neutron-bsn-agent'
    #$cisco_server_package       = 'openstack-neutron-cisco'
    #$nvp_server_package         = 'openstack-neutron-nicira'
    $dhcp_agent_package         = false
    #$lbaasv2_agent_package      = 'openstack-neutron-lbaas'
    #$metering_agent_package     = 'openstack-neutron-metering-agent'
    #$vpnaas_agent_package       = 'openstack-neutron-vpnaas'
    $l2gw_agent_package         = 'openstack-neutron-l2gw-agent'
    $l2gw_package               = 'python2-networking-l2gw'
    #if $::operatingsystemrelease =~ /^7.*/ or $::operatingsystem == 'Fedora' {
    #  $openswan_package = 'libreswan'
    #} else {
    #  $openswan_package = 'openswan'
    #}
    #$libreswan_package          = 'libreswan'
    $l3_agent_package           = false
    #$fwaas_package              = 'openstack-neutron-fwaas'
    $neutron_wsgi_script_path   = '/var/www/cgi-bin/neutron'
    $neutron_wsgi_script_source = '/usr/bin/neutron-api'
  } elsif($::osfamily == 'Debian') {
    $nobody_user_group          = 'nogroup'
    $package_name               = 'neutron-common'
    $server_package             = 'neutron-server'
    if $::os_package_type =='debian' {
      $ml2_server_package = false
    } else {
      $ml2_server_package = 'neutron-plugin-ml2'
    }
    $ovs_agent_package          = 'neutron-openvswitch-agent'
    $ovs_server_package         = 'neutron-plugin-openvswitch'
    $ovs_cleanup_service        = false
    $libnl_package              = 'libnl1'
    $package_provider           = 'dpkg'
    $linuxbridge_agent_package  = 'neutron-linuxbridge-agent'
    $linuxbridge_server_package = 'neutron-plugin-linuxbridge'
    $sriov_nic_agent_service    = 'neutron-sriov-agent'
    $sriov_nic_agent_package    = 'neutron-sriov-agent'
    $cisco_server_package       = 'neutron-plugin-cisco'
    $nvp_server_package         = 'neutron-plugin-nicira'
    $dhcp_agent_package         = 'neutron-dhcp-agent'
    $lbaasv2_agent_package      = 'neutron-lbaasv2-agent'
    $metering_agent_package     = 'neutron-metering-agent'
    $vpnaas_agent_package       = 'neutron-vpn-agent'
    $openswan_package           = 'openswan'
    $libreswan_package          = false
    $metadata_agent_package     = undef
    $l3_agent_package           = 'neutron-l3-agent'
    $fwaas_package              = 'python-neutron-fwaas'
    $l2gw_agent_package         = 'neutron-l2gateway-agent'
    $l2gw_package               = 'python-networking-l2gw'
    $neutron_wsgi_script_path   = '/usr/lib/cgi-bin/neutron'
    $neutron_wsgi_script_source = '/usr/bin/neutron-api'
  } else {
    fail("Unsupported osfamily ${::osfamily}")
  }
}
