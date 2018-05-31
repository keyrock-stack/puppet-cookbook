# == Class: nova::ironic::common
#
# [*api_endpoint*]
#   The url for Ironic api endpoint.
#   Defaults to 'http://127.0.0.1:6385/v1'
#
# [*auth_plugin*]
#   The authentication plugin to use when connecting to nova.
#   Defaults to 'password'
#
# [*auth_url*]
#   The address of the Keystone api endpoint.
#   Defaults to 'http://127.0.0.1:35357/'
#
# [*project_name*]
#   The Ironic Keystone project name.
#   Defaults to 'services'
#
# [*password*]
#   The admin password for Ironic to connect to Nova.
#   Defaults to 'ironic'
#
# [*username*]
#   The admin username for Ironic to connect to Nova.
#   Defaults to 'admin'
#
# [*api_max_retries*]
#   Max times for ironic driver to poll ironic api
#
# [*api_retry_interval*]
#   Interval in second for ironic driver to poll ironic api
#
# === DEPRECATED
#
# [*admin_username*]
#   The admin username for Ironic to connect to Nova.
#   Defaults to 'admin'
#
# [*admin_password*]
#   The admin password for Ironic to connect to Nova.
#   Defaults to 'ironic'
#
# [*admin_url*]
#   The address of the Keystone api endpoint.
#   Defaults to 'http://127.0.0.1:35357/v2.0'
#
# [*admin_tenant_name*]
#   The Ironic Keystone tenant name.
#   Defaults to 'services'
#
class nova::ironic::common (
  $api_endpoint         = 'http://127.0.0.1:6385/v1',
  $auth_plugin          = 'password',
  $auth_url             = 'http://127.0.0.1:35357/',
  $password             = 'ironic',
  $project_name         = 'services',
  $username             = 'admin',
  $api_max_retries      = $::os_service_default,
  $api_retry_interval   = $::os_service_default,
) {

  include ::nova::deps


  nova_ironic_config {
    'ironic/auth_plugin':          value => $auth_plugin;
    'ironic/username':             value => $username;
    'ironic/password':             value => $password;
    'ironic/auth_url':             value => $auth_url;
    'ironic/project_name':         value => $project_name;
    'ironic/api_endpoint':         value => $api_endpoint;
    'ironic/api_max_retries':      value => $api_max_retries;
    'ironic/api_retry_interval':   value => $api_retry_interval;
  }

}
