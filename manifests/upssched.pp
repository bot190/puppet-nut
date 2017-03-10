# This define adds an event to UPSSchedule
#

# nut::upssched::ups_list:
#  'UPS':
#    action: 'START-TIMER'
#    upsname: 'UPSA'
#    timername: 'TIMERA'
#    interval: 10
#}

define nut::upssched (
  $upsname    = '',
  $action     = undef,
  $timername  = undef,
  $notifytype = undef,
  $command    = undef,
  $interval   = undef,
  $order      = '50',
  ) {

  include nut
  $upssched_file = $nut::client_upssched_config_file
  
  $real_upsname = $upsname ? {
    ''      => '*',
    default => $upsname,
  }
  
  ### Check sanity of properties
  if ($action == undef) {
    fail("No action specified!") 
  }
  if ($notifytype == undef) {
    fail ("No notification type specified!")
  }
  if (($action == "START-TIMER" or $action == "CANCEL-TIMER") and $timername == undef) {
    fail("No timer name specified!")  
  }
  if ($action == "EXECUTE" and $command == undef){
    fail("No command specified for EXECUTE")
  }
  if ($action == "START-TIMER" and $interval == undef) {
      fail("No inteval specified!")
  }
  
  if ! defined(Concat[$upssched_file]) {
    concat { $upssched_file:
      mode      => $nut::config_file_mode,
      show_diff => false,
      warn      => true,
      owner     => $nut::config_file_owner,
      group     => $nut::config_file_group,
      require   => Package[$nut::client_package],
    }
      concat::fragment{ 'nut_schedule_header':
      target    => $upssched_file,
      content   => template($nut::client_sched_template_header),
      order     => 01,
    }
  }
  
  # Allow for a command script file to be specified
  if ! defined(File[$nut::client_cmdscript]) and 
     ($nut::client_sched_cmd_template != undef or $nut::client_sched_cmd_source != undef ) {
    file { $nut::client_cmdscript:
      ensure    => file,
      show_diff => false,
      path      => $nut::client_cmdscript,
      require   => Package[$nut::client_package],
      source    => $nut::client_sched_cmd_source,
      content   => template($nut::client_sched_cmd_template),
      owner     => $nut::config_file_owner,
      group     => $nut::config_file_group,
    }
    
  }
  
  concat::fragment { "nut_schedule_$title":
    target  => $upssched_file,
    content => template($nut::client_sched_template_stanza),
    order   => $order,
  }
}
