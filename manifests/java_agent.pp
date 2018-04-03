# appdynamics_agent::java_agent
#
# This class installs and configures the AppDynamics JAVA agent.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include appdynamics_agent::java_agent
class appdynamics_agent::java_agent (
  $agent_install_dir = '',
  $controller_host = undef, 
  $controller_port = 8090,  # generally, the port is 8090
  $controller_ssl_enabled = '',
  $se_simple_hostname = false,  #default is false
  $application_name = '',  #Required
  $tier_name = '',  #Required
  $node_name = '', #Required
  $agent_runtime_dir = '',
  $enable_orchestration = false, #default is false
  $use_encrypted_credentials = '',
  $credential_store_filename = '',
  $credential_store_password = '',
  $use_ssl_client_auth = false, #default is false
  $asymmetric_keystore_filename = '',
  $asymmetric_keystore_password = '',
  $asymmetric_key_password = '',
  $asymmetric_key_alias = '',
  $account_name = '',
  $account_access_key = '',
  $force_agent_registration = false, #default is 
  $process_user = 'root',
  $proces_group = 'root',
  $permission = '0664',
){
  validate_absolute_path($agent_install_dir)
  validate_bool($se_simple_hostname)
  validate_bool($enable_orchestration)
  validate_bool($force_agent_registration)
  if $application_name == '' {
    fail('Application Name has not been defined. This is a required setting.')
  }
  if $tier_name == '' {
    fail('Tier Name has not been defined. This is a required setting.')
  }
  if $node_name == '' {
    fail('Node Name has not been defined. This is a required setting.')
  }

  File { 
    owner  => $process_user,
    group  => $proces_group,
    mode   => $permission,
  }
  file { $agent_install_dir:
    ensure => directory,
    source => 'puppet:///modules/appdynamics_agent/java_agent';
  }
  file { "${appdynamics_agent}/conf":
    ensure => directory,
  }
  file { 'config':
    ensure  => file,
    path    => "$appdynamics_agent/conf/controller-info.xml",
    content => template('appdynamics_agent/java_agent/controller-info.xml.erb'),
  }

}
