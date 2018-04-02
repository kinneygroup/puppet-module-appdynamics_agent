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

  $machine_agent_file_32  = undef, #filename of the RPM package downloaded
  $machine_agent_file_64  = undef, #filename of the RPM package downloaded
  $controller_port        = '8090',  #default port is 8090
  $controller_host        = undef, #IP address of the controller
  $account_access_key     = undef, #from the controller
  $account_name           = undef, #from the controller
  $unique_host_id         = undef, #optional
  $machine_path           = undef, #optional
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
  if ($machine_agent_file_32 == 'undef')  and ($machine_agent_file_64 == 'undef') {
    fail('No RPM package provided. Follow the module instructions.')
  }
  if $controller_host == 'undef' {
    fail('The Controller IP adderss was not provided.')
  }
  if $account_access_key == 'undef' {
    fail('Access key is not defined. Get the key from the controller.')
  }
  if $account_name == 'undef' {
    fail('Access account is not defined. Get the account name from the controller.')
  }

  if $::facts['os']['family'] == 'RedHat' {
    if $::facts['os']['architecture'] == 'x86_64' {
      validate_absolute_path($machine_agent_file_64)
      file { '/tmp/appd_machine_agent.rpm':
        ensure => file,
        source => "puppet:///modules/appdynamics_agent/machine_agent/linux_64_rpm/${machine_agent_file_64}";
      }

      package { 'appdynamics-machine-agent':
        ensure   => installed,
        provider => 'rpm',
        source   => '/tmp/appd_machine_agent.rpm',
        require  => File['/tmp/appd_machine_agent.rpm'],
        notify   => Service[$machine_service_name],
      }
    } elsif $::facts['os']['architecture'] == i386 {
      validate_absolute_path($machine_agent_file_32)
      file { '/tmp/machine_agent_rpm':
        ensure => file,
        source => "puppet:///modules/appdynamics_agent/machine_agent/linux_32_rpm/${machine_agent_file_32}";
      }

      package { 'appdynamics-machine-agent':
        ensure   => installed,
        provider => 'rpm',
        source   => 'puppet:///modules/appdynamics_agent/machine_agent/linux_32_rpm',
        require  => File['/tmp/machine_agent_rpm'],
        notify   => Service[$machine_service_name],
      }
    } else {
      notify { 'Not a supported kernel version': }
    }

    service { $machine_service_name:
      ensure => running,
      enable => true,
    }

    file { $controller_info:
      ensure  => file,
      content => template('appdynamics_agent/machine_agent/controller-info.xml.erb'),
      mode    => '0600',
      notify  => Service[$machine_service_name],
    }

  } else {
    notify { 'Not a supported OS': }
  }
}
