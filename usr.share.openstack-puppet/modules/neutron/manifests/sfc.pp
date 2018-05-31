# == Class: neutron::sfc
#
# Sets up service function chaining.
#
# === Parameters
#
# [*sfc_drivers*]
#   (required) The SFC driver
#
# [*flowclassifier_drivers*]
#   (required) The flowclassifier driver
#
# [*quota_flow_classifier*]
#   (optional) The quota for flow classifiers
#
# [*quota_port_chain*]
#   (optional) The quota for port chains
#
# [*quota_port_pair_group*]
#   (optional) The quota for port pair groups
#
# [*quota_port_pair*]
#   (optional) The quota for port pairs
#
class neutron::sfc (
  $sfc_drivers,
  $flowclassifier_drivers,
  $quota_flow_classifier = $::os_service_default,
  $quota_port_chain = $::os_service_default,
  $quota_port_pair_group = $::os_service_default,
  $quota_port_pair = $::os_service_default,
) {

  include neutron::params

  neutron_config {
    'sfc/drivers': value => $sfc_drivers;
    'flowclassifier/drivers': value => $flowclassifier_drivers;
    'quotas/quota_flow_classifier':     value => $quota_flow_classifier;
    'quotas/quota_port_chain':          value => $quota_port_chain;
    'quotas/quota_port_pair_group':     value => $quota_port_pair_group;
    'quotas/quota_port_pair':           value => $quota_port_pair;
  }

}
