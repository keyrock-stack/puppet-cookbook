# == Class: nova::compute::libvirt
#
# Install and manage nova-compute guests managed
# by libvirt
#
# === Parameters:
#
# [*ensure_package*]
#   (optional) The state of nova packages
#   Defaults to 'present'
#
# [*libvirt_virt_type*]
#   (optional) Libvirt domain type. Options are: kvm, lxc, qemu, uml, xen
#   Defaults to 'kvm'
#
# [*vncserver_listen*]
#   (optional) IP address on which instance vncservers should listen
#   Defaults to '127.0.0.1'
#
# [*migration_support*]
#   (optional) Whether to support virtual machine migration
#   Defaults to false
#
# [*libvirt_cpu_mode*]
#   (optional) The libvirt CPU mode to configure.  Possible values
#   include custom, host-model, none, host-passthrough.
#   Defaults to 'host-model' if libvirt_virt_type is set to kvm,
#   otherwise defaults to 'none'.
#
# [*libvirt_cpu_model*]
#   (optional) The named libvirt CPU model (see names listed in
#   /usr/share/libvirt/cpu_map.xml). Only has effect if
#   cpu_mode="custom" and virt_type="kvm|qemu".
#   Defaults to undef
#
# [*libvirt_snapshot_image_format*]
#   (optional) Format to save snapshots to. Some filesystems
#   have a preference and only operate on raw or qcow2
#   Defaults to $::os_service_default
#
# [*libvirt_disk_cachemodes*]
#   (optional) A list of cachemodes for different disk types, e.g.
#   ["file=directsync", "block=none"]
#   If an empty list is specified, the disk_cachemodes directive
#   will be removed from nova.conf completely.
#   Defaults to an empty list
#
# [*libvirt_hw_disk_discard*]
#   (optional) Discard option for nova managed disks. Need Libvirt(1.0.6)
#   Qemu1.5 (raw format) Qemu1.6(qcow2 format).
#   Defaults to $::os_service_default
#
# [*libvirt_hw_machine_type*]
#   (optional) Option to specify a default machine type per host architecture.
#   Defaults to $::os_service_default
#
# [*libvirt_inject_password*]
#   (optional) Inject the admin password at boot time, without an agent.
#   Defaults to false
#
# [*libvirt_inject_key*]
#   (optional) Inject the ssh public key at boot time.
#   Defaults to false
#
# [*libvirt_inject_partition*]
#   (optional) The partition to inject to : -2 => disable, -1 => inspect
#   (libguestfs only), 0 => not partitioned, >0 => partition
#   number (integer value)
#   Defaults to -2
#
# [*libvirt_enabled_perf_events*]
#   (optional) This is a performance event list which could be used as monitor.
#   A string list. For example: ``enabled_perf_events = cmt, mbml, mbmt``
#   The supported events list can be found in
#   https://libvirt.org/html/libvirt-libvirt-domain.html ,
#   which you may need to search key words ``VIR_PERF_PARAM_*``
#   Defaults to $::os_service_default
#
# [*remove_unused_base_images*]
#   (optional) Should unused base images be removed?
#   If undef is specified, remove the line in nova.conf
#   otherwise, use a boolean to remove or not the base images.
#   Defaults to undef
#
# [*remove_unused_resized_minimum_age_seconds*]
#   (optional) Unused resized base images younger
#   than this will not be removed
#   If undef is specified, remove the line in nova.conf
#   otherwise, use a integer or a string to define after
#   how many seconds it will be removed.
#   Defaults to undef
#
# [*remove_unused_original_minimum_age_seconds*]
#   (optional) Unused unresized base images younger
#   than this will not be removed
#   If undef is specified, remove the line in nova.conf
#   otherwise, use a integer or a string to define after
#   how many seconds it will be removed.
#   Defaults to undef
#
# [*libvirt_service_name*]
#   (optional) libvirt service name.
#   Defaults to $::nova::params::libvirt_service_name
#
# [*virtlock_service_name*]
#   (optional) virtlock service name.
#   Defaults to $::nova::params::virtlock_service_name
#
# [*virtlog_service_name*]
#   (optional) virtlog service name.
#   Defaults to $::nova::params::virtlog_service_name
#
# [*compute_driver*]
#   (optional) Compute driver.
#   Defaults to 'libvirt.LibvirtDriver'
#
# [*preallocate_images*]
#   (optional) The image preallocation mode to use.
#   Valid values are 'none' or 'space'.
#   Defaults to $::os_service_default
#
# [*manage_libvirt_services*]
#   (optional) Whether or not deploy Libvirt services.
#   In the case of micro-services, set it to False and use
#   nova::compute::libvirt::services + hiera to select what
#   you actually want to deploy.
#   Defaults to true for backward compatibility.
#
#  === WRS PARAMETERS ===
#
# [*live_migration_downtime*]
#   (optional) Maximum downtime in ms for live migration.
#   Defaults to 500
#
# [*live_migration_downtime_steps*]
#   (optional) Number of incremental steps to reach max
#   downtime value.
#   Defaults to 10
#
# [*live_migration_downtime_delay*]
#   (optional) Time to wait in seconds per GB of RAM
#   between each step increase of the migration downtime.
#   Defaults to 75
#
# [*live_migration_completion_timeout*]
#   (optional) Time to wait in seconds for migration to
#   complete. Set to 0 to disable timeouts.
#
# [*live_migration_progress_timeout*]
#   (optional) Time to wait in seconds for migration to make
#   forward progress in transferring data before aborting.
#   Defaults to 150
#
class nova::compute::libvirt (
  $ensure_package                             = 'present',
  $libvirt_virt_type                          = 'kvm',
  $vncserver_listen                           = '127.0.0.1',
  $migration_support                          = false,
  $libvirt_cpu_mode                           = false,
  $libvirt_cpu_model                          = undef,
  $libvirt_snapshot_image_format              = $::os_service_default,
  $libvirt_disk_cachemodes                    = [],
  $libvirt_hw_disk_discard                    = $::os_service_default,
  $libvirt_hw_machine_type                    = $::os_service_default,
  $libvirt_inject_password                    = false,
  $libvirt_inject_key                         = false,
  $libvirt_inject_partition                   = -2,
  $libvirt_enabled_perf_events                = $::os_service_default,
  $remove_unused_base_images                  = undef,
  $remove_unused_resized_minimum_age_seconds  = undef,
  $remove_unused_original_minimum_age_seconds = undef,
  $libvirt_service_name                       = $::nova::params::libvirt_service_name,
  $virtlock_service_name                      = $::nova::params::virtlock_service_name,
  $virtlog_service_name                       = $::nova::params::virtlog_service_name,
  $compute_driver                             = 'libvirt.LibvirtDriver',
  $preallocate_images                         = $::os_service_default,
  $manage_libvirt_services                    = true,
  # WRS PARAMETERS
  $live_migration_flag                        = undef,
  $live_migration_downtime                    = undef,
  $live_migration_downtime_steps              = undef,
  $live_migration_downtime_delay              = undef,
  $live_migration_completion_timeout          = undef,
  $live_migration_progress_timeout            = undef,
) inherits nova::params {

  include ::nova::deps
  include ::nova::params

  # libvirt_cpu_mode has different defaults depending on hypervisor.
  if !$libvirt_cpu_mode {
    case $libvirt_virt_type {
      'kvm': {
        $libvirt_cpu_mode_real = 'host-model'
      }
      default: {
        $libvirt_cpu_mode_real = 'none'
      }
    }
  } else {
    $libvirt_cpu_mode_real = $libvirt_cpu_mode
  }

  if($::osfamily == 'Debian') {
    package { "nova-compute-${libvirt_virt_type}":
      ensure => $ensure_package,
      tag    => ['openstack', 'nova-package'],
    }
  }

  if $migration_support {
    include ::nova::migration::libvirt
  }

  # manage_libvirt_services is here for backward compatibility to support
  # deployments that do not include nova::compute::libvirt::services
  #
  # If you're using hiera:
  #  - set nova::compute::libvirt::manage_libvirt_services to false
  #  - include ::nova::compute::libvirt::services in your composition layer
  #  - select which services you want to deploy with
  #    ::nova::compute::libvirt::services:* parameters.
  #
  # If you're not using hiera:
  #  - set nova::compute::libvirt::manage_libvirt_services to true (default).
  #  - select which services you want to deploy with
  #    ::nova::compute::libvirt::*_service_name parameters.
  if $manage_libvirt_services {
    class { '::nova::compute::libvirt::services':
      libvirt_service_name  => $libvirt_service_name,
      virtlock_service_name => $virtlock_service_name,
      virtlog_service_name  => $virtlog_service_name,
      libvirt_virt_type     => $libvirt_virt_type,
    }
  }

  nova_config {
    'DEFAULT/compute_driver':        value => $compute_driver;
    'DEFAULT/preallocate_images':    value => $preallocate_images;
    'vnc/vncserver_listen':          value => $vncserver_listen;
    'libvirt/virt_type':             value => $libvirt_virt_type;
    'libvirt/cpu_mode':              value => $libvirt_cpu_mode_real;
    'libvirt/snapshot_image_format': value => $libvirt_snapshot_image_format;
    'libvirt/inject_password':       value => $libvirt_inject_password;
    'libvirt/inject_key':            value => $libvirt_inject_key;
    'libvirt/inject_partition':      value => $libvirt_inject_partition;
    'libvirt/hw_disk_discard':       value => $libvirt_hw_disk_discard;
    'libvirt/hw_machine_type':       value => $libvirt_hw_machine_type;
    'libvirt/enabled_perf_events':   value => join(any2array($libvirt_enabled_perf_events), ',');
  }

  # cpu_model param is only valid if cpu_mode=custom
  # otherwise it should be commented out
  if $libvirt_cpu_mode_real == 'custom' {
    validate_string($libvirt_cpu_model)
    nova_config {
      'libvirt/cpu_model': value => $libvirt_cpu_model;
    }
  } else {
    nova_config {
      'libvirt/cpu_model': ensure => absent;
    }
    if $libvirt_cpu_model {
      warning('$libvirt_cpu_model requires that $libvirt_cpu_mode => "custom" and will be ignored')
    }
  }

  if size($libvirt_disk_cachemodes) > 0 {
    nova_config {
      'libvirt/disk_cachemodes': value => join($libvirt_disk_cachemodes, ',');
    }
  } else {
    nova_config {
      'libvirt/disk_cachemodes': ensure => absent;
    }
  }

  if $remove_unused_resized_minimum_age_seconds != undef {
    nova_config {
      'libvirt/remove_unused_resized_minimum_age_seconds': value => $remove_unused_resized_minimum_age_seconds;
    }
  } else {
    nova_config {
      'libvirt/remove_unused_resized_minimum_age_seconds': ensure => absent;
    }
  }

  if $remove_unused_base_images != undef {
    nova_config {
      'DEFAULT/remove_unused_base_images': value => $remove_unused_base_images;
    }
  } else {
    nova_config {
      'DEFAULT/remove_unused_base_images': ensure => absent;
    }
  }

  if $remove_unused_original_minimum_age_seconds != undef {
    nova_config {
      'DEFAULT/remove_unused_original_minimum_age_seconds': value => $remove_unused_original_minimum_age_seconds;
    }
  } else {
    nova_config {
      'DEFAULT/remove_unused_original_minimum_age_seconds': ensure => absent;
    }
  }


 # WRS
 if $live_migration_flag != undef {
    nova_config {
      'libvirt/live_migration_flag': value => $live_migration_flag;
    }
  } else {
    nova_config {
      'libvirt/live_migration_flag': ensure => absent;
    }
  }

  if $live_migration_downtime != undef {
    nova_config {
      'libvirt/live_migration_downtime': value => $live_migration_downtime;
    }
  } else {
    nova_config {
      'libvirt/live_migration_downtime': ensure => absent;
    }
  }

  if $live_migration_downtime_steps != undef {
    nova_config {
      'libvirt/live_migration_downtime_steps': value => $live_migration_downtime_steps;
    }
  } else {
    nova_config {
      'libvirt/live_migration_downtime_steps': ensure => absent;
    }
  }

  if $live_migration_downtime_delay != undef {
    nova_config {
      'libvirt/live_migration_downtime_delay': value => $live_migration_downtime_delay;
    }
  } else {
    nova_config {
      'libvirt/live_migration_downtime_delay': ensure => absent;
    }
  }

  if $live_migration_completion_timeout != undef {
    nova_config {
      'libvirt/live_migration_completion_timeout': value => $live_migration_completion_timeout;
    }
  } else {
    nova_config {
      'libvirt/live_migration_completion_timeout': ensure => absent;
    }
  }

  if $live_migration_progress_timeout != undef {
    nova_config {
      'libvirt/live_migration_progress_timeout': value => $live_migration_progress_timeout;
    }
  } else {
    nova_config {
      'libvirt/live_migration_progress_timeout': ensure => absent;
    }
  }

}
