# = Class: nut
#
# This is the main nut class
#
#############################################################################
# == Parameters
#
# Pay attention that we have five kind of parameters:
#
# * General/module parameters: these affect the general behaviour of the module
#   Many of them are standard example42 parameters
#
# * Server parameters ( $nut::server* ): these configure upsd daemon and module behaviour
#   regarding the server.
# * UPS drivers ( $nut::server_ups* ): needed by the upsd to connect to the UPS.
# * upsd users ( $nut::server_user* ): configure the permissions related to access to the server.
# * Client parameters ( $nut::client_*): these configure upsmon daemon and module behaviour
#   regarding the client.
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*start_mode*]
#   The type of the service start: "netserver", "netclient", "standalone" or "none".
#   Default: none
#
# [*install_mode*]
#   The type of installation: "server" or "client".
#   Default: client
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*nutconf_config_file*]
#   Path of configuration file sourced by init script
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, nut class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $nut_myclass
#
# [*source_dir*]
#   If defined, the whole nut configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $nut_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $nut_source_dir_purge
#
# [*client_template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, nut main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $nut_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $nut_options
#
# [*service_autorestart*]
#   Automatically restarts the nut service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $nut_absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $nut_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $nut_disableboot
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the (top scope) variables $nut_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for nut checks
#   Can be defined also by the (top scope) variables $nut_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the (top scope) variables $nut_monitor_target
#   and $monitor_target
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $nut_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $nut_audit_only
#   and $audit_only
#
# [*service_status*]
#   If the nut service init script supports status argument
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: undef
#
# ###############################
# ### Client (upsmon) parameters.
#
# [*client_package*]
#   The name of nut client package
#
# [*client_service*]
#   The name of nut client service
#
# [*client_process*]
#   The name of nut client_process
#
# [*client_config_file*]
#   Main configuration file path to the nut client
#
# [*client_pid_file*]
#   Path of pid file. Used by monitor
#
# [*client_source*]
#   Sets the content of source parameter for main configuration file
#   If defined, nut main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $nut_source
#
# [*client_name*]
# [*client_user*]
# [*client_password*]
# [*client_minsupplies*]
# [*client_finaldelay*]
# [*client_deadtime*]
# [*client_hostsync*]
# [*client_nocommwarmtime*]
# [*client_pollfreq*]
# [*client_pollfreqalert*]
# [*client_powerdownflag*]
# [*client_powervalue*]
# [*client_rbwarntime*]
# [*client_run_as_user*]
# [*client_server_host*]
# [*client_shutdowncmd*]
# [*client_ups_mode*]
#
# [*client_notifycmd*]
#   upsmon calls this to send messages when things happen
#   This command is called with the full text of the message as one argument.
#   Note that this is only called for [*client_notifyflag_* *] events that have EXEC set.
#
# [*client_notifyflag_commbad*]
# [*client_notifyflag_commonk*]
# [*client_notifyflag_fsd*]
# [*client_notifyflag_lowbat*]
# [*client_notifyflag_nocomm*]
# [*client_notifyflag_noparent*]
# [*client_notifyflag_onbat*]
# [*client_notifyflag_online*]
# [*client_notifyflag_remplbatt*]
# [*client_notifyflag_shutdown*]
#   The value for these parameters are any combination of 'SYSLOG', 'WALL' and 'EXEC',
#   concatenated with +, like SYSLOG+EXEC or SYSLOG+WALL+EXEC.
#   Default: empty
#
# [*client_notify_msg_commbad*]
# [*client_notify_msg_commonk*]
# [*client_notify_msg_fsd*]
# [*client_notify_msg_nocomm*]
# [*client_notify_msg_noparent*]
# [*client_notify_msg_online*]
# [*client_notify_msg_remplbatt*]
# [*client_notify_msg_shutdown*]
# [*client_notify_msg_onbat*]
# [*client_notify_msg_lowbat*]
#   Examples of messages:
#     $client_notify_msg_online = 'UPS %s on line power'
#     $client_notify_onbat = 'UPS %s on battery'
#     $client_notify_lowbat = 'UPS %s battery is low'
#     $client_notify_msg_fsd = 'UPS %s: forced shutdown in progress'
#     $client_notify_msg_commonk = 'Communications with UPS %s established'
#     $client_notify_msg_commbad = 'Communications with UPS %s lost'
#     $client_notify_msg_shutdown = 'Auto logout and shutdown proceeding'
#     $client_notify_msg_remplbatt = 'UPS %s battery needs to be replaced'
#     $client_notify_msg_nocomm = 'UPS %s is unavailable'
#     $client_notify_msg_noparent ='client parent process died - shutdown impossible'
#
# ###############################
# ### Server daemon (upsd) parameters.
#
# [*server_service*]
#   The name of nut server service
#
# [*server_process*]
#   The name of nut server process
#
# [*server_config_file*]
#   Main configuration file path to the nut server
#
# [*server_upsdrivers_config_file*]
#   Main configuration file path to the nut server drivers file
#   This is where you configure your ups drivers
#
# [*server_pid_file*]
#   Path of pid file. Used by monitor
#
# [*port*]
#   The listening port, if any, of the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Note: This doesn't necessarily affect the service configuration file
#   Can be defined also by the (top scope) variable $nut_port
#
# [*protocol*]
#   The protocol used by the the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Can be defined also by the (top scope) variable $nut_protocol
#
# [*server_concat_template_footer*]
# [*server_concat_template_header*]
# [*server_config_type*]
# [*server_listen_ip*]
# [*server_package*]
# [*server_source*]
# [*server_template*]
# [*server_ups_description*]
# [*server_ups_driver*]

# [*server_ups_vendor*]
# [*server_ups_vendorid*]
# [*server_ups_product*]
# [*server_ups_productid*]
# [*server_ups_offdelay*]
# [*server_ups_ondelay*]
# [*server_ups_pollfreq*]
# [*server_ups_serial*]
# [*server_ups_bus*]

# [*server_upsdrivers_template*]
# [*server_ups_name*]
# [*server_ups_port*]
#
# [*server_user_actions*]
# [*server_user_concat_template*]
# [*server_user_config_file*]
# [*server_user_instcmds*]
# [*server_user_name*]
# [*server_user_password*]
# [*server_user_upsmon_mode*]
#
# See README for usage patterns.
#
# == Author
#   Alessandro Franceschi <al@lab42.it/>
#   Sebastian Quaino <sebastian@netmanagers.com.ar/>
#   Javier Bertoli <javier@netmanagers.com.ar/>
#
class nut (
  $source_dir                    = $nut::params::source_dir,
  $source_dir_purge              = $nut::params::source_dir_purge,
  $service_autorestart           = $nut::params::service_autorestart,
  $options                       = $nut::params::options,
  $version                       = $nut::params::version,
  $absent                        = $nut::params::absent,
  $disable                       = $nut::params::disable,
  $disableboot                   = $nut::params::disableboot,
  $noops                         = $nut::params::noops,
  $service_status                = $nut::params::service_status,
  $config_file_mode              = $nut::params::config_file_mode,
  $config_file_owner             = $nut::params::config_file_owner,
  $config_file_group             = $nut::params::config_file_group,
  $data_dir                      = $nut::params::data_dir,
  $log_dir                       = $nut::params::log_dir,
  $log_file                      = $nut::params::log_file,
  $port                          = $nut::params::port,
  $protocol                      = $nut::params::protocol,
  $install_mode                  = $nut::params::install_mode,
  $start_mode                    = $nut::params::start_mode,
  $process_args                  = $nut::params::process_args,
  $process_user                  = $nut::params::process_user,
  $config_dir                    = $nut::params::config_dir,
  $server_source                 = $nut::params::server_source,
  $server_template               = $nut::params::server_template,
  $server_concat_template_header = $nut::params::server_concat_template_header,
  $server_concat_template_footer = $nut::params::server_concat_template_footer,
  $server_package                = $nut::params::server_package,
  $server_service                = $nut::params::server_service,
  $server_process                = $nut::params::server_process,
  $server_upsdrivers_config_file = $nut::params::server_upsdrivers_config_file,
  $server_upsdrivers_template    = $nut::params::server_upsdrivers_template,
  $server_listen_ip              = $nut::params::server_listen_ip,
  $server_ups_name               = $nut::params::server_ups_name,
  $server_ups_driver             = $nut::params::server_ups_driver,
  $server_ups_port               = $nut::params::server_ups_port,
  $server_ups_vendor             = $nut::params::server_ups_vendor,
  $server_ups_vendorid           = $nut::params::server_ups_vendorid,
  $server_ups_product            = $nut::params::server_ups_product,
  $server_ups_productid          = $nut::params::server_ups_productid,
  $server_ups_offdelay           = $nut::params::server_ups_offdelay,
  $server_ups_ondelay            = $nut::params::server_ups_ondelay,
  $server_ups_pollfreq           = $nut::params::server_ups_pollfreq,
  $server_ups_serial             = $nut::params::server_ups_serial,
  $server_ups_bus                = $nut::params::server_ups_bus,
  $server_ups_description        = $nut::params::server_ups_description,
  $server_user_config_file       = $nut::params::server_user_config_file,
  $server_user_concat_template   = $nut::params::server_user_concat_template,
  $server_user_name              = $nut::params::server_user_name,
  $server_user_password          = $nut::params::server_user_password,
  $server_user_actions           = $nut::params::server_user_actions,
  $server_user_instcmds          = $nut::params::server_user_instcmds,
  $server_user_upsmon_mode       = $nut::params::server_user_upsmon_mode,
  $server_config_file            = $nut::params::server_config_file,
  $server_pid_file               = $nut::params::server_pid_file,
  $server_config_type            = $nut::params::server_config_type,
  $nutconf_config_file           = $nut::params::nutconf_config_file,
  $nutconf_template              = $nut::params::nutconf_template,
  $nutconf_source                = $nut::params::nutconf_source,
  $client_source                 = $nut::params::client_source,
  $client_template               = $nut::params::client_template,
  $client_package                = $nut::params::client_package,
  $client_service                = $nut::params::client_service,
  $client_config_file            = $nut::params::client_config_file,
  $client_upssched_config_file   = $nut::params::client_upssched_config_file,
  $client_cmdscript              = $nut::params::cmdscript,
  $client_pipefn                 = $nut::params::pipefn,
  $client_lockfn                 = $nut::params::lockfn,
  $client_sched_template_stanza  = $nut::params::client_sched_template_stanza,
  $client_sched_template_header  = $nut::params::client_sched_template_header,
  $client_process                = $nut::params::client_process,
  $client_pid_file               = $nut::params::client_pid_file,
  $client_run_as_user            = $nut::params::client_run_as_user,
  $client_name                   = $nut::params::client_name,
  $client_server_host            = $nut::params::client_server_host,
  $client_powervalue             = $nut::params::client_powervalue,
  $client_user                   = $nut::params::client_user,
  $client_password               = $nut::params::client_password,
  $client_ups_mode               = $nut::params::client_ups_mode,
  $client_minsupplies            = $nut::params::client_minsupplies,
  $client_shutdowncmd            = $nut::params::client_shutdowncmd,
  $client_notifycmd              = $nut::params::client_notifycmd,
  $client_pollfreq               = $nut::params::client_pollfreq,
  $client_pollfreqalert          = $nut::params::client_pollfreqalert,
  $client_hostsync               = $nut::params::client_hostsync,
  $client_deadtime               = $nut::params::client_deadtime,
  $client_powerdownflag          = $nut::params::client_powerdownflag,
  $client_notify_msg_online      = $nut::params::client_notify_msg_online,
  $client_notify_msg_onbat       = $nut::params::client_notify_msg_onbat,
  $client_notify_msg_lowbat      = $nut::params::client_notify_msg_lowbat,
  $client_notify_msg_fsd         = $nut::params::client_notify_msg_fsd,
  $client_notify_msg_commonk     = $nut::params::client_notify_msg_commonk,
  $client_notify_msg_commbad     = $nut::params::client_notify_msg_commbad,
  $client_notify_msg_shutdown    = $nut::params::client_notify_msg_shutdown,
  $client_notify_msg_remplbatt   = $nut::params::client_notify_msg_remplbatt,
  $client_notify_msg_nocomm      = $nut::params::client_notify_msg_nocomm,
  $client_notify_msg_noparent    = $nut::params::client_notify_msg_noparent,
  $client_notifyflag_online      = $nut::params::client_notifyflag_online,
  $client_notifyflag_onbat       = $nut::params::client_notifyflag_onbat,
  $client_notifyflag_lowbat      = $nut::params::client_notifyflag_lowbat,
  $client_notifyflag_fsd         = $nut::params::client_notifyflag_fsd,
  $client_notifyflag_commonk     = $nut::params::client_notifyflag_commonk,
  $client_notifyflag_commbad     = $nut::params::client_notifyflag_commbad,
  $client_notifyflag_shutdown    = $nut::params::client_notifyflag_shutdown,
  $client_notifyflag_remplbatt   = $nut::params::client_notifyflag_remplbatt,
  $client_notifyflag_nocomm      = $nut::params::client_notifyflag_nocomm,
  $client_notifyflag_noparent    = $nut::params::client_notifyflag_noparent,
  $client_rbwarntime             = $nut::params::client_rbwarntime,
  $client_nocommwarmtime         = $nut::params::client_nocommwarmtime,
  $client_finaldelay             = $nut::params::client_finaldelay,
  ) inherits nut::params {

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_firewall=any2bool($firewall)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)

  ### Definition of some variables used in the module
  $manage_package = $nut::bool_absent ? {
    true  => 'absent',
    false => $nut::version,
  }

  $manage_service_enable = $nut::bool_disableboot ? {
    true    => false,
    default => $nut::bool_disable ? {
      true    => false,
      default => $nut::bool_absent ? {
        true  => false,
        false => true,
      },
    },
  }

  $manage_service_ensure = $nut::bool_disable ? {
    true    => 'stopped',
    default =>  $nut::bool_absent ? {
      true    => 'stopped',
      default => 'running',
    },
  }

  $manage_client_service_autorestart = $nut::bool_service_autorestart ? {
    true    => Service[$nut::client_service],
    false   => undef,
  }

  $manage_server_service_autorestart = $nut::bool_service_autorestart ? {
    true    => Service[$nut::server_service],
    false   => undef,
  }

  $manage_file = $nut::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  if $nut::bool_absent == true
  or $nut::bool_disable == true
  or $nut::bool_disableboot == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  if $nut::bool_absent == true
  or $nut::bool_disable == true {
    $manage_firewall = false
  } else {
    $manage_firewall = true
  }

  $manage_audit = $nut::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $nut::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_client_file_source = $nut::client_source ? {
    ''        => undef,
    default   => $nut::client_source,
  }

  $manage_server_file_source = $nut::server_source ? {
    ''        => undef,
    default   => $nut::server_source,
  }

  $manage_client_file_content = $nut::client_template ? {
    ''        => undef,
    default   => template($nut::client_template),
  }

  $manage_server_file_content = $nut::server_template ? {
    ''        => undef,
    default   => template($nut::server_template),
  }

  # The whole nut configuration directory can be recursively overriden
  if $nut::source_dir != '' {
    file { 'ups.dir':
      ensure  => directory,
      path    => $nut::config_dir,
      require => Package[$nut::client_package],
      notify  => $nut::manage_client_service_autorestart,
      source  => $nut::source_dir,
      recurse => true,
      purge   => $nut::bool_source_dir_purge,
      force   => $nut::bool_source_dir_purge,
      replace => $nut::manage_file_replace,
      audit   => $nut::manage_audit,
      noop    => $nut::noops,
    }
  }

  ## Nut.conf configuration
  if $nut::start_mode != '' {
    include nut::nutconf
  }

  ### Server configuration
  if $nut::install_mode == 'server' {
    include nut::server
  }

  include nut::client

  ### Include custom class if $my_class is set
  if $nut::my_class {
    include $nut::my_class
  }

  ### Debugging, if enabled ( debug => true )
  if $nut::bool_debug == true {
    file { 'debug_nut':
      ensure  => $nut::manage_file,
      path    => "${settings::vardir}/debug-nut",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
      noop    => $nut::noops,
    }
  }

}
