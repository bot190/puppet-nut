# = Class: nut::client
#
# This script installs the nut-client (upsmon)
#
#
# This class is not to be called directly. See init.pp for details.
#
class nut::client inherits nut {

  ### Managed resources
  package { $nut::client_package:
    ensure  => $nut::manage_package,
    noop    => $nut::bool_noops,
  }

  # FIXME! This is a nasty hack, but in CentOS, nut-client and nut-server
  # have a single init script (ups), so we check if it's not already defined
  if ! defined(Service[$nut::client_service]) {
    service { $nut::client_service:
      ensure     => $nut::manage_service_ensure,
      name       => $nut::client_service,
      enable     => $nut::manage_service_enable,
      hasstatus  => $nut::service_status,
      pattern    => $nut::client_process,
      require    => Package[$nut::client_package],
      noop       => $nut::bool_noops,
    }
  }
  file { 'ups_client_conf':
    ensure  => $nut::manage_file,
    path    => $nut::client_config_file,
    mode    => $nut::config_file_mode,
    owner   => $nut::config_file_owner,
    group   => $nut::config_file_group,
    require => Package[$nut::client_package],
    notify  => $nut::manage_service_autorestart,
    source  => $nut::manage_client_file_source,
    content => $nut::manage_client_file_content,
    replace => $nut::manage_file_replace,
    audit   => $nut::manage_audit,
    noop    => $nut::bool_noops,
  }

  ### Service monitoring, if enabled ( monitor => true )
  if $nut::bool_monitor == true {
    if $nut::client_service != '' {
      monitor::process { 'ups_client_process':
      process  => $nut::client_process,
      service  => $nut::client_service,
      pidfile  => $nut::client_pid_file,
      user     => $nut::process_user,
      argument => $nut::process_args,
      tool     => $nut::monitor_tool,
      enable   => $nut::manage_monitor,
      noop     => $nut::bool_noops,
      }
    }
  }
}