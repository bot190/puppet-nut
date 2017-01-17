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
      mode    => '0644',
      warn    => true,
      owner   => $nut::config_file_owner,
      group   => $nut::config_file_group,
      require => Package[$nut::client_package],
    }
      concat::fragment{ 'nut_schedule_header':
      target  => $nut::server_config_file,
      content => template($nut::client_sched_template_header),
      order   => 01,
    }
  }
  
  concat::fragment { "nut_schedule_$title":
    target  => $upssched_file,
    content => template($nut::client_sched_template_stanza),
    order   => $order,
  }

#  case $sched_action {
#    'START-TIMER': {
#      augeas { "$real_ups_name-$sched_notifytype":
#        incl => $upssched_file,
#        lens => "nutupsschedconf.aug",
#        changes => [
#          "set sched/upsname $real_ups_name",
#          "set sched/notifytype $sched_notifytype",
#          "set sched/START-TIMER/interval $sched_interval",
#          "set sched/START-TIMER/timername $sched_timername",
#          "mv sched $upssched_file/AT[upsname = $real_ups_name and notifytype = $sched_notifytype]"
#      ]}
#    }
#    'EXECUTE': {
#      augeas { "$real_ups_name-$sched_notifytype":
#        incl => $upssched_file,
#        lens => "nutupsschedconf.aug",
#        changes => [
#          "set sched/upsname $real_ups_name",
#          "set sched/notifytype $sched_notifytype",
#          "set sched/EXECUTE/command $sched_command",
#          "mv sched $upssched_file/AT[upsname = $real_ups_name and notifytype = $sched_notifytype]"
#      ]}
#    }
#    'CANCEL-TIMER': {
#      augeas { "$real_ups_name-$sched_notifytype":
#        incl => $upssched_file,
#        lens => "nutupsschedconf.aug",
#        changes => [
#          "set sched/upsname $real_ups_name",
#          "set sched/notifytype $sched_notifytype",
#          "set sched/CANCEL-TIMER/timername $sched_timername",
#          "mv sched $upssched_file/AT[upsname = $real_ups_name and notifytype = $sched_notifytype]"
#      ]}
#    }
#  }
}
