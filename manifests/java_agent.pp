# appdynamics_agent::java_agent
#
# This class installs and configures the AppDynamics JAVA agent.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include appdynamics_agent::java_agent
class appdynamics_agent::java_agent (
  $agent_install_dir            = '',
  $controller_host              = undef,
  $controller_port              = 8090,  # generally, the port is 8090
  $controller_ssl_enabled       = false,  #default is false
  $se_simple_hostname           = false,  #default is false
  $application_name             = '',  #Required
  $tier_name                    = '',  #Required
  $node_name                    = '',  #Required
  $agent_runtime_dir            = "${agent_install_dir}",  #defalts to install dir
  $enable_orchestration         = false, #default is false
  $use_encrypted_credentials    = '',
  $credential_store_filename    = '',
  $credential_store_password    = '',
  $use_ssl_client_auth          = false, #default is false
  $asymmetric_keystore_filename = '',
  $asymmetric_keystore_password = '',
  $asymmetric_key_password      = '',
  $asymmetric_key_alias         = '',
  $account_name                 = '',
  $account_access_key           = '',
  $force_agent_registration     = false, #default is false
  $monitored_service            = '', #the java service to monitor managed by puppet 
  $monitored_service_config     = '', #the path to the config file containing JAVA_OPTIONS
  $monitored_service_options    = "JAVA_OPTIONS = -javaagent:${agent_install_dir}/javaagent.jar", #the JAVA_OPTIONS configuration line
  $process_user                 = 'root',
  $proces_group                 = 'root',
  $permission                   = '0664',
){
  validate_absolute_path($agent_install_dir)
  validate_bool($controller_ssl_enabled)
  validate_bool($se_simple_hostname)
  validate_bool($enable_orchestration)
  validate_bool($force_agent_registration)
  if $controller_host == 'undef' {
    fail('Controller host was not defined.')
  }
  if $application_name == '' {
    fail('Application Name has not been defined. This is a required setting.')
  }
  if $tier_name == '' {
    fail('Tier Name has not been defined. This is a required setting.')
  }
  if $node_name == '' {
    fail('Node Name has not been defined. This is a required setting.')
  }
  if $monitored_service == '' {
    fail('Monitored service was not defined and m ust be managed by Puppet.')
  }
  if $monitored_service_config == '' {
    fail('Monitored service configuration file was not defined.')
  }
  if $monitored_service_options == '' {
    fail('Monitored service JAVA_OPTIONS were not defined.')
  }

  File { 
    owner  => $process_user,
    group  => $proces_group,
    mode   => $permission,
  }
  file { $agent_install_dir:
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/appdynamics_agent/java_agent';
  }

  file { 'config':
    ensure  => file,
    path    => "${appdynamics_agent}/conf/controller-info.xml",
    content => template('appdynamics_agent/java_agent/controller-info.xml.erb'),
  }

  file_line { 'java_option':
    ensure => 'present',
    line   => "${monitored_service_options}",
    path   => "${monitored_service_config}",
    match  => '/.*JAVA_OPTIONS.*/',
    #replace  => true, # 'true' or 'false'
    notify => Service["${monitored_service}"],
  }

}
