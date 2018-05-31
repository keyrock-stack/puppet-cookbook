# == Class: ceilometer::policy
#
# Configure the ceilometer policies
#
# === Parameters:
#
# [*policies*]
#   (Optional) Set of policies to configure for ceilometer
#   Example : {
#               'ceilometer-context_is_admin' => {'context_is_admin' => 'true'},
#               'ceilometer-default' => {'default' => 'rule:admin_or_owner'}
#             }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the ceilometer policy.json file
#   Defaults to /etc/ceilometer/policy.json
#
class ceilometer::policy (
  $policies    = {},
  $policy_path = '/etc/ceilometer/policy.json',
) {

  include ::ceilometer::deps

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path => $policy_path,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'ceilometer_config': policy_file => $policy_path }

}
