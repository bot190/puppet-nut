# Puppet module: nut

## [Maintainer wanted](https://github.com/netmanagers/puppet-nut/issues/new)

**WARNING WARNING WARNING**

[puppet-nut](https://github.com/netmanagers/puppet-nut) is not currently being maintained, 
and may have unresolved issues or not be up-to-date. 

I'm still using it on a daily basis (with Puppet 3.8.5) and fixing issues I find
while using it. But sadly, I don't have the time required to actively add new features,
fix issues other people report or port it to Puppet 4.x.

If you would like to maintain this module,
please create an issue at: https://github.com/netmanagers/puppet-nut/issues
offering yourself.

## Getting started

Made by Sebastian Quaino / Netmanagers
Modified by Ben Beauregard

Official site: http://www.netmanagers.com.ar

Official git repository: http://github.com/netmanagers/puppet-nut

Released under the terms of Apache 2 License.

This module depends on R.I.Pienaar's concat module (https://github.com/ripienaar/puppet-concat).


## USAGE - Basic management

* All parameters can be set using Hiera. See the manifests to see what can be set.

* Install nut with default settings. By default, we just install nut client.

        class { 'nut': }

* Install nut server (and client), with a local UPS. As we have many options and they handle 
  so many different parts, we assume nothing (there's room for improvement, though):

        class { 'nut':
          install_mode            => 'server',
          server_ups_name         => 'localUPS',
          server_ups_driver       => 'some_driver',
          server_ups_port         => 'auto',
          server_ups_description  => 'My UPS',
          server_user_name        => 'myuser',
          server_user_password    => 'secret',
          server_user_actions     => 'SET FSD',
          server_user_instcmds    => 'ALL',
          server_user_upsmon_mode => 'master',
          client_UPSs             = {'ups@localhost' => {
                                      powervalue => '1'
                                      user       => 'user'
                                      password   => 'password'
                                      mode       => 'master'
                                     }
                                    }
        }

* Install a specific version of nut package

        class { 'nut':
          version => '1.0.1',
        }

* There are many defines that let you customize your config:
  * upsconcat: lets you add more than one ups to a single daemon.
  * upsd: adds ACLs for NUT users / clients into upsd.conf
  * usersconcat: adds users to upsd.users
  * upssched: lets you schedule events for usage with UPSSCHEDULER

* Disable nut service.

        class { 'nut':
          disable => true
        }

* Remove nut package

        class { 'nut':
          absent => true
        }

* Enable auditing without without making changes on existing nut configuration *files*

        class { 'nut':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'nut':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'nut':
          source => [ "puppet:///modules/example42/nut/nut.conf-${hostname}" , "puppet:///modules/example42/nut/nut.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'nut':
          source_dir       => 'puppet:///modules/example42/nut/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'nut':
          template => 'example42/nut/nut.conf.erb',
        }
