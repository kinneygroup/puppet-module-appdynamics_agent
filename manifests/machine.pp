# appdynamics_agent::machine
#
# This module installes and configures the machine agent for AppDynamics
#
# @summary The Standalone Machine Agent (Machine Agent) collects and 
# displays CPU, Memory, Disk, and Network metrics on the Node Dashboard Server tab. 
#
# @example
#   include appdynamics_agent::machine
class appdynamics_agent::machine (
  $machine_path           = undef,
  $machine_agent_file_32  = undef,
  $machine_agent_file_64  = undef,
  $controller_host        = undef,
  $controller_port        = undef,
  $unique_host_id         = undef,
  $account_access_key     = undef,
  $account_name           = undef,
  $sim_enabled            = false,
  $ssl_enabled            = false,
  $enable_orchestration   = false,
  $controller_info        = '/etc/appdynamics/machine-agent/controller-info.xml',
  $machine_agent          = '/etc/sysconfig/appdynamics-machine-agent',
  $machine_service_name   = 'appdynamics-machine-agent',
) {
  validate_bool($sim_enabled)
  validate_bool($ssl_enabled)
  validate_bool($enable_orchestration)
  validate_absolute_path($controller_info)
  validate_absolute_path($machine_agent)

  if $::facts['os']['family'] == 'RedHat' {
    if $::facts['os']['architecture'] == 'x86_64' {
      file { '/tmp/appd_machine_agent.rpm':
        ensure => file,
        source => "puppet:///modules/appdynamics_agent/machine_agent/linux_64_rpm/${machine_agent_file_64}";
      }

      package { 'appdynamics-machine-agent':
        ensure   => installed,
        provider => 'rpm',
        source   => '/tmp/appd_machine_agent.rpm',
        require  => File['/tmp/appd_machine_agent.rpm'],
      }
    } elsif $::facts['os']['architecture'] == i386 {
      file { '/tmp/machine_agent_rpm':
        ensure => file,
        source => "puppet:///modules/appdynamics_agent/machine_agent/linux_32_rpm/${machine_agent_file_32}";
      }

      package { 'appdynamics-machine-agent':
        ensure   => installed,
        provider => 'rpm',
        source   => 'puppet:///modules/appdynamics_agent/machine_agent/linux_32_rpm',
        require  => File['/tmp/machine_agent_rpm'],
      }
    } else {
      notify { 'Not a supported kernel version': }
    }

    service { $machine_service_name:
      ensure  => running,
      enable  => true,
      require => Package['appdynamics-machine-agent'],
    }

    file { $controller_info:
      ensure  => present,
      content => template('appdynamics_agent/machine_agent/controller-info.xml.erb'),
      mode    => '0600',
      notify  => Service[$machine_service_name],
    }

  } else {
    notify { 'Not a supported OS': }
  }
}
