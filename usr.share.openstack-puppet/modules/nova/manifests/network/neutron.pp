# == Class: nova::network::neutron
#
# Configures Nova network to use Neutron.
#
# === Parameters:
#
# [*neutron_password*]
#   (required) Password for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#
# [*neutron_auth_type*]
#   Name of the auth type to load (string value)
#   Defaults to 'v3password'
#
# [*neutron_url*]
#   (optional) URL for connecting to the Neutron networking service.
#   Defaults to 'http://127.0.0.1:9696'
#
# [*neutron_url_timeout*]
#   (optional) Timeout value for connecting to neutron in seconds.
#   Defaults to '30'
#
# [*neutron_project_name*]
#   (optional) Project name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'services'
#
# [*neutron_project_domain_name*]
#   (optional) Project Domain name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*neutron_user_domain_name*]
#   (optional) User Domain name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*neutron_region_name*]
#   (optional) Region name for connecting to neutron in admin context
#   through the OpenStack Identity service.
#   Defaults to 'RegionOne'
#
# [*neutron_username*]
#   (optional) Username for connecting to Neutron network services in admin context
#   through the OpenStack Identity service.
#   Defaults to 'neutron'
#
# [*neutron_ovs_bridge*]
#   (optional) Name of Integration Bridge used by Open vSwitch
#   Defaults to 'br-int'
#
# [*neutron_extension_sync_interval*]
#   (optional) Number of seconds before querying neutron for extensions
#   Defaults to '600'
#
# [*neutron_auth_url*]
#   (optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to 'http://127.0.0.1:35357/v3'
#
# [*firewall_driver*]
#   (optional) Firewall driver.
#   This prevents nova from maintaining a firewall so it does not interfere
#   with Neutron's. Set to 'nova.virt.firewall.IptablesFirewallDriver'
#   to re-enable the Nova firewall.
#   Defaults to 'nova.virt.firewall.NoopFirewallDriver'
#
# [*vif_plugging_is_fatal*]
#   (optional) Fail to boot instance if vif plugging fails.
#   This prevents nova from booting an instance if vif plugging notification
#   is not received from neutron.
#   Defaults to 'True'
#
# [*vif_plugging_timeout*]
#   (optional) Number of seconds to wait for neutron vif plugging events.
#   Set to '0' and vif_plugging_is_fatal to 'False' if vif plugging
#   notification is not being used.
#   Defaults to '300'
#
# [*dhcp_domain*]
#   (optional) domain to use for building the hostnames
#   Defaults to 'novalocal'
#
# [*default_floating_pool*]
#   (optional) Default pool for floating IPs
#   Defaults to 'nova'
#
# DEPRECATED PARAMETERS
# [*neutron_auth_strategy*]
#   (optional) DEPRECATED.
#
# [*neutron_admin_password*]
#   DEPRECATED. Password for connecting to Neutron network services
#   in admin context through the OpenStack Identity service.
#   Use neutron_password instead.
#
# [*neutron_admin_tenant_name*]
#   (optional) DEPRECATED. Tenant name for connecting to Neutron network
#   services in admin context through the OpenStack Identity service.
#   Use neutron_project_name instead.
#
# [*neutron_admin_username*]
#   (optional) DEPRECATED. Username for connecting to Neutron network services
#   in admin context through the OpenStack Identity service.
#   Use neutron_username instead.
#
# [*neutron_admin_auth_url*]
#   (optional) DEPRECATED. Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Use neutron_auth_url instead.
#
# [*neutron_default_tenant_id*]
#   (optional) DEPRECATED. Default tenant id when creating neutron networks
#
# [*neutron_auth_plugin*]
#   Name of the plugin to load (string value)
#   Defaults to undef
#
# [*neutron_ca_certificates_file*]
#   (optional) Location of ca certicates file to use for neutronclient requests.
#   Defaults to undef
#
class nova::network::neutron (
  $neutron_password                = false,
  $neutron_auth_type               = 'password',
  $neutron_project_name            = 'services',
  $neutron_project_domain_name     = 'Default',
  $neutron_username                = 'neutron',
  $neutron_user_domain_name        = 'Default',
  $neutron_auth_url                = 'http://127.0.0.1:35357/v3',
  $neutron_url                     = 'http://127.0.0.1:9696',
  $neutron_url_timeout             = '30',
  $neutron_region_name             = 'RegionOne',
  $neutron_ovs_bridge              = 'br-int',
  $neutron_extension_sync_interval = '600',
  $firewall_driver                 = 'nova.virt.firewall.NoopFirewallDriver',
  $vif_plugging_is_fatal           = true,
  $vif_plugging_timeout            = '300',
  $dhcp_domain                     = 'novalocal',
  $default_floating_pool           = 'nova',
  $neutron_default_tenant_id       = undef,
  $neutron_auth_plugin             = undef,
  $neutron_ca_certificates_file    = undef,
) {

  include ::nova::deps


  # WRS: remove dependency on nova::api
  $default_floating_pool_real = $default_floating_pool

  nova_config {
    'DEFAULT/dhcp_domain':             value => $dhcp_domain;
    'DEFAULT/firewall_driver':         value => $firewall_driver;
    'DEFAULT/vif_plugging_is_fatal':   value => $vif_plugging_is_fatal;
    'DEFAULT/vif_plugging_timeout':    value => $vif_plugging_timeout;
    'neutron/default_floating_pool':   value => $default_floating_pool_real;
    'neutron/url':                     value => $neutron_url;
    'neutron/timeout':                 value => $neutron_url_timeout;
    'neutron/project_name':            value => $neutron_project_name;
    'neutron/project_domain_name':     value => $neutron_project_domain_name;
    'neutron/region_name':             value => $neutron_region_name;
    'neutron/username':                value => $neutron_username;
    'neutron/user_domain_name':        value => $neutron_user_domain_name;
    'neutron/password':                value => $neutron_password, secret => true;
    'neutron/auth_url':                value => $neutron_auth_url;
    'neutron/ovs_bridge':              value => $neutron_ovs_bridge;
    'neutron/extension_sync_interval': value => $neutron_extension_sync_interval;
    'neutron/auth_type':               value => $neutron_auth_type;
  }

  nova_ironic_config {
    'DEFAULT/dhcp_domain':             value => $dhcp_domain;
    'DEFAULT/firewall_driver':         value => $firewall_driver;
    'DEFAULT/vif_plugging_is_fatal':   value => false;
    'DEFAULT/vif_plugging_timeout':    value => $vif_plugging_timeout;
    'neutron/default_floating_pool':   value => $default_floating_pool_real;
    'neutron/url':                     value => $neutron_url;
    'neutron/timeout':                 value => $neutron_url_timeout;
    'neutron/project_name':            value => $neutron_project_name;
    'neutron/project_domain_name':     value => $neutron_project_domain_name;
    'neutron/region_name':             value => $neutron_region_name;
    'neutron/username':                value => $neutron_username;
    'neutron/user_domain_name':        value => $neutron_user_domain_name;
    'neutron/password':                value => $neutron_password, secret => true;
    'neutron/auth_url':                value => $neutron_auth_url;
    'neutron/ovs_bridge':              value => $neutron_ovs_bridge;
    'neutron/extension_sync_interval': value => $neutron_extension_sync_interval;
    'neutron/auth_type':               value => $neutron_auth_type;
  }

}
