# == Class: ceilometer::db::sync
#
# Class to execute ceilometer database schema creation
#
# === Parameters:
#
# [*extra_params*]
#   (Optional) String of extra command line parameters
#   to append to the ceilometer-upgrade command.
#   Defaults to '--skip-gnocchi-resource-types'.
#
class ceilometer::db::sync(
  $extra_params = '--skip-gnocchi-resource-types',
) {

  include ::ceilometer::deps
  include ::ceilometer::params

  exec { 'ceilometer-upgrade':
    command     => "${::ceilometer::params::dbsync_command} ${extra_params}",
    path        => '/usr/bin',
    user        => $::ceilometer::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['ceilometer::install::end'],
      Anchor['ceilometer::config::end'],
      Anchor['ceilometer::dbsync::begin']
    ],
    # Only do the db sync if both controllers are running the same software
    # version. Avoids impacting mate controller during an upgrade.
    onlyif      => "test $::controller_sw_versions_match = true",
    notify      => Anchor['ceilometer::dbsync::end'],
  }

}
