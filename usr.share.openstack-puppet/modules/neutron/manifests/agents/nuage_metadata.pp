# == Class: neutron::agents::nuage_metadata
#
# Setup and configure Neutron nuage metadata agent.
#
# === Parameters
#
# [*metadata_port*]
#   The TCP Port used by Nuage metadata agent. Defaults to 9697.
#
# [*nova_metadata_ip*]
#   (required) IP address used by Nova metadata server.
#
# [*nova_metadata_port*]
#   The TCP Port used by Nova metadata server. Defaults to 8775.
#
# [*metadata_proxy_shared_secret*]
#   (required) Used to sign the Instance-ID header.
#
# [*nova_client_version*]
#   Version of nova client. Defaults to 2.
#
# [*nova_os_username*]
#   (required) Nova username.
#
# [*nova_os_password*]
#   (required) Nova password.
#
# [*nova_os_tenant_name*]
#   (required) Nova tenant name.
#
# [*nova_os_auth_url*]
#   (required) Nova auth URL. Format: http://<ip_address>:5000/v2.0
#
# [*nova_metadata_agent_start_with_ovs*]
#   If nuage-metadata-agent needs to be started with nuage-openvswitch-switch.
#   Defaults to true.
#
# [*nova_api_endpoint_type*]
#   Nova API endpoint type (one of publicURL, internalURL, adminURL).
#   Defaults to publicURL.
#
# [*nova_region_name*]
#   (required) Nova region name.
#

class neutron::agents::nuage_metadata (
  $metadata_port = '9697',
  $nova_metadata_ip = undef,
  $nova_metadata_port = '8775',
  $metadata_proxy_shared_secret,
  $nova_client_version = '2',
  $nova_os_username = undef,
  $nova_os_password,
  $nova_os_tenant_name = undef,
  $nova_os_auth_url = undef,
  $nova_metadata_agent_start_with_ovs = 'true',
  $nova_api_endpoint_type = 'publicURL',
  $nova_region_name = undef,
  ) {

  Neutron_config<||> ~> Service['nuage-metadata-agent']
  Neutron_nuage_metadata_agent_config<||> ~> Service['nuage-metadata-agent']

  neutron_nuage_metadata_agent_config {
    '/METADATA_PORT': value => $metadata_port;
    '/NOVA_METADATA_IP': value => $nova_metadata_ip;
    '/NOVA_METADATA_PORT': value => $nova_metadata_port;
    '/METADATA_PROXY_SHARED_SECRET': value => $metadata_proxy_shared_secret;
    '/NOVA_CLIENT_VERSION': value => $nova_client_version;
    '/NOVA_OS_USERNAME': value => $nova_os_username;
    '/NOVA_OS_PASSWORD': value => $nova_os_password;
    '/NOVA_OS_TENANT_NAME': value => $nova_os_tenant_name;
    '/NOVA_OS_AUTH_URL': value => $nova_os_auth_url;
    '/NUAGE_METADATA_AGENT_START_WITH_OVS': value=> $nova_metadata_agent_start_with_ovs;
    '/NOVA_API_ENDPOINT_TYPE': value => $nova_api_endpoint_type;
    '/NOVA_REGION_NAME': value => $nova_region_name;
  }

  service { 'nuage-metadata-agent':
    ensure  => 'running',
    enable  => false,
    hasstatus => false,
    hasrestart => true,
    require => Class['neutron'],
  }
}
