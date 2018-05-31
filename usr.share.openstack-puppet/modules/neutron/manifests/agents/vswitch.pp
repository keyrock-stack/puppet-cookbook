# == Class: neutron::agents::vswitch
#
# Setups vswitch neutron agent.
#
# === Parameters
#
# [*enabled*]
#   (optional) The state of the service
#   Defaults to true
#
# [*physical_interface_mappings*]
#   (required) Comma-separated list of <physical_network>:<physical_interface>
#   tuples mapping physical network names to agent's node-specific physical
#   network interfaces.
#
# [*firewall_driver*]
#   (optional) Firewall driver for realizing neutron security group function.
#   Defaults to 'neutron.plugins.wrs.drivers.firewall.VSwitchFirewallDriver'.
#
# [*qos_driver*]
#   (optional) QoS driver for realizing neutron quality of service function.
#   Defaults to 'neutron.plugins.wrs.drivers.qos.VSwitchQoSDriver'.
#
# [*managed_host_state*]
#   (optional) Specifies whether the host state is managed by server
#   Defaults to true
#
# [*report_port_status]
#   (optional) Specifies whether to generate port status messages
#   Defaults to true
#
# [*enable_distributed_routing]
#   (optional) Specifies whether to enable distributed virtual routing
#   Defaults to true
#
# [*sdn_manage_external_networks]
#   (optional) Specifies whether avs agent should be managing external provider networks
#   Defaults to true
#
class neutron::agents::vswitch (
  $physical_interface_mappings,
  $firewall_driver = 'neutron.plugins.wrs.drivers.firewall.VSwitchFirewallDriver',
  $qos_driver = 'neutron.plugins.wrs.drivers.qos.VSwitchQoSDriver',
  $managed_host_state = true,
  $report_port_status = true,
  $enable_distributed_routing = true,
  $service_ensure  = 'running',
  $enable          = true,
  $managed_providers = true,
  $sdn_manage_external_networks = true
) {

  include neutron::params

  Neutron_config<||>               ~> Service['neutron-vswitch']
  Neutron_vswitch_agent_config<||> ~> Service['neutron-vswitch']

  neutron_vswitch_agent_config {
    'AGENT/physical_interface_mappings': value => $physical_interface_mappings;
    'AGENT/qos_driver': value => $qos_driver;
    'AGENT/enable_distributed_routing': value => $enable_distributed_routing;
    'SECURITYGROUP/firewall_driver': value => $firewall_driver;
    'AVS/managed_host_state': value => $managed_host_state;
    'AVS/report_port_status': value => $report_port_status;
    'AVS/managed_providers': value => $managed_providers;
    'SDN/manage_external_networks': value => $sdn_manage_external_networks;
  }

  if $::operatingsystem == 'CentOS' {
    $real_enabled = false
  } else {
    $real_enabled = $enable
  }

  service { 'neutron-vswitch':
    ensure  => $service_ensure,
    name    => $::neutron::params::vswitch_agent_service,
    enable  => $real_enabled,
    require => Class['neutron'],
  }
}
