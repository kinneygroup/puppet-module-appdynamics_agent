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
  String $machine_path,
  String $machine_agent_file_32,
  String $machine_agent_file_64,
  String $controller_host,
  String $controller_port,
  String $unique_host_id,
  String $account_access_key,
  String $account_name,
  String $sim_enabled          = 'false',
  String $ssl_enabled          = 'false',
  String $enable_orchestration = 'false',
  String $controller_info      = '/etc/appdynamics/machine-agent/controller-info.xml',
  String $machine_agent        = '/etc/sysconfig/appdynamics-machine-agent',
  Strgin $machine_service_name = 'appdynamics-machine-agent',
) {
  validate_absolute_path($controller_info)
  validate_absolute_path($machine_agent)

  if $::fact[os][family] == 'RedHat' {
    if $::fact[os][architecture] == 'x86_64' {
      file { '/tmp/appd_machine_agent.rpm':
        ensure => file,
        source => "puppet:///modules/appdynamics_agent/machine_agent/linux_64_rpm/${machine_agent_file_64}";
      }

      package { 'machine_agent':
        ensure   => installed,
        provider => 'rpm',
        source   => '/tmp/appd_machine_agent.rpm',
        require  => File['/tmp/appd_machine_agent.rpm'],
      }
    } elsif $::fact[os][architecture] == i386 {
      file { '/tmp/machine_agent_rpm':
        ensure => file,
        source => "puppet:///modules/appdynamics_agent/machine_agent/linux_32_rpm/${machine_agent_file_32}";
      }

      package { 'machine_agent':
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
      require => Package['machine_agent'],
    }

    File_line {
      ensure => 'present',
      path   => $controller_info,
      notify => Service['machine_service_name'],
    }

    file_line { 'controller_host':
      line  => "   <controller-host>${controller_host}</controller-host>",
      match => '/.*<controller-host>/',
    }

    file_line { 'controller_port':
      line  => "    <controller-port>${controller_port}</controller-port>",
      match => '/.*<controller-port>/',
    }

    file_line { 'controller_ssl_enabled':
      line  => "    <controller-ssl-enabled>${ssl_enabled}</controller-ssl-enabled>",
      match => '/.*<controller-ssl-enabled>/',
    }

    file_line { 'enable_orchestration':
      line  => "    <enable-orchestration>${enable_orchestration}</enable-orchestration>",
      match => '/.*<enable-orchestration>/',
    }

    file_line { 'unique_host_id':
      line  => "    <unique-host-id>${unique_host_id}</unique-host-id>",
      match => '/.*<unique-host-id>/',
    }

    file_line { 'account_access_key':
      line  => "    <account-access-key>${account_access_key}</account-access-key>",
      match => '/.*<account-access-key>/',
    }

    file_line { 'account_name':
      line  => "    <account-name>${account_name}</account-name>",
      match => '/.*<account-name>/',
    }

    file_line { 'sim_enabled':
      line  => "    <sim-enabled>${sim_enabled}</sim-enabled>",
      match => '/.*<sim-enabled>/',
    }

    file_line { 'machine_path':
      line  => "      <machine-path>${machine_path}</machine-path>",
      match => '/.*<machine-path>/',
    }
  } else {
    notify { 'Not a supported OS': }
  }
}
