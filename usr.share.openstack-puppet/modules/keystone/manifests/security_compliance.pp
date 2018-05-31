# == class: keystone::security_compliance
#
# Implements security compliance configuration for keystone.
#
# === parameters:
#
# [*unique_last_password_count*]
#   This controls the number of previous user password iterations
#   to keep in history, in order to enforce that newly created passwords
#   are unique. Setting the value to 1 (the default) disables this feature.
#   (integer value)
#   Defaults to 'undef'
#
# [*password_regex*]
#   The regular expression used to validate password strength 
#   requirements. By default, the regular expression will match
#   any password. (string value)
#   Defaults to 'undef'
#
# [*password_regex_description*]
#   If a password fails to match the regular expression (*password_regex*),
#   the contents of this configuration will be returned to users to explain
#   why their requested password was insufficient. (string value)
#   Defaults to 'undef'
#
# === DEPRECATED group/name
#
# == Copyright
#
# Copyright 2017 Wind River Systems, unless otherwise noted.
#
class keystone::security_compliance(
  $unique_last_password_count          = undef,
  $password_regex                      = undef,
  $password_regex_description          = undef,
) {
  
  include ::keystone::deps

  keystone_config {
    'security_compliance/unique_last_password_count':  value => $unique_last_password_count;
    'security_compliance/password_regex':              value => $password_regex;
    'security_compliance/password_regex_description':  value => $password_regex_description;
  } 
}
