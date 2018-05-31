# == Class: neutron::bgp
#
# Sets up bgp dynamic-routing agent.
#
# === Parameters
#
# [*bgp_router_id*]
#   (required) The BGP router_id
#
# [*bgp_speaker_driver*]
#   (required) The BGP speaker driver
#
class neutron::bgp (
  $bgp_router_id,
  $bgp_speaker_driver,
  $service_ensure  = 'running',
  $enable          = true,
) {

  include neutron::params

  Neutron_config<||>             ~> Service['neutron-bgp-dragent']
  Neutron_bgp_dragent_config<||> ~> Service['neutron-bgp-dragent']

  neutron_bgp_dragent_config {
    'bgp/bgp_router_id': value => $bgp_router_id;
    'bgp/bgp_speaker_driver': value => $bgp_speaker_driver;
  }

  service { 'neutron-bgp-dragent':
    ensure  => $service_ensure,
    name    => $::neutron::params::bgp_dragent_service,
    enable  => $enable,
    require => Class['neutron'],
  }
}
