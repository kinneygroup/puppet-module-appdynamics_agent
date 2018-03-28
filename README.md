
# appdynamics_agent

This module will install and manage App Dynamics Agents.

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with appdynamics_agent](#setup)
    * [What appdynamics_agent affects](#what-appdynamics_agent-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with appdynamics_agent](#beginning-with-appdynamics_agent)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Todo - Agents to be added](#todo)

## Description

AppDynamics (https://www.appdynamics.com/) is a solution that provides insight into application performance through application flow maps and transaction monitoring.

On first pass, this module only installs the machine agant. Additional agents will be added over time.

## Setup

### What appdynamics_agent affects 

This module configures AppDynamics agents to communicate with the controller. Becasue there are numerous agents and configurations, this module will be growing and changing over time. 

This module requires some setup before implementation:

* Hiera will need to be configured to identify the nodes configured.
* Requires a valide Controller license.
* Requires the contoller installed and functioning.

### Setup Requirements 

* A AppDynamics Controller installed and configured.
* A valid AppDynamics license
* stdlib 3.x or higher

### Installation

```puppet
puppet module install kinneygroup-appdynamics_agent
```

### Beginning with appdynamics_agent  

The very basic steps needed for a user to get the module up and running. This can include setup steps, if necessary, or it can be an example of the most basic use of the module.

## Usage

###Basic Install

* Download the required agent from AppDynamics an dplace it in the appropriate `Files` directory in this module.

To use the Standalone Machine agent, add or update the values to the associated variables, either in a hiera structure or in the module:
  ```$machine_path       = 'path_to_machine',
  $machine_agent_file_32 = 'file_name_here',
  $machine_agent_file_64 = 'file_name_here',
  $controller_host       = 'hostname_or_ip',
  $controller_port       = 'controller_port',
  $unique_host_id        = '', 
  $account_access_key    = '',
  $account_name          = '',
  $sim_enabled           = false,
  $ssl_enabled           = false,
  $enable_orchestration  = false,
  $controller_info       = '/etc/appdynamics/machine-agent/controller-info.xml',
  $machine_agent         = '/etc/sysconfig/appdynamics-machine-agent',
  $machine_service_name = 'appdynamics-machine-agent',
  ```

Then add `include appdynamics_agent::machine` to the profile for the host.

## Reference

There are a number of AppDynamics Agents. Each one will be a subclass of this module.

Classes:

* appdynamics_agent::machine

### Parameters

#### Machine Agent
##### `machine_path`
This value is used to create the hierarchy infrastructure view in the UI for this machine. Each hierarchy level should be separated with a vertical bar ("|"). For example, if this machine belongs to "DataRack1" and it is located in "Virginia Data Center", then the machine path could be set to "Virginia Data Center|DataRack1|Machine1" and the UI will display it in that hierarchy ("Virginia Data Center|DataRack1"). The last element of the path indicates the server name (e.g., "Machine1") and appears as the name on the servers list in the UI.
##### `machine_agent_file_32`
This is the name of the downloaded 32-bit verion of the agent that is manually stored with the module.
##### `machine_agent_file_64 `
This is the name of the downloaded 64-bit verion of the agent that is manually stored with the module.
##### `controller_host`
Use either the fully qualified hostname or the IP addess of the App Dynamics Controller. This is the same port that you use to access the AppDynamics browser-based User interface.
##### `controller_port`
This is the http(s) port of the AppDynamics Controller.
##### `unique_host_id`
The Machine Agent uses the Java API to get the host name of the agent. Use this option to override and set the identy.
##### `account_access_key`
This key is generated at installation time and can be found by viewing the license information in the controller settings.
##### `account_name`
If the AppDynamics Controller is running in multi-tenant mode or you are using the AppDynamics SaaS Controller, you must specify the account name for this agent to authenticate with the controller. If you are running in single-tenant mode (the default) there is no need to configure this value.
##### `sim_enabled`
If this agent is licensed for Server Monitoring, set this flag to 'true' to enable Server Monitoring expanded metrics. Default: false
##### `ssl_enabled`
This specifies if the AppDynamics agent should use SSL (HTTPS) to connect to the Controller. Default: false
##### `enable_orchestration`
Set this flag to 'true' to enable features required for AppDynamics Orchestration. Default: false
##### `controller_info`
Default: '/etc/appdynamics/machine-agent/controller-info.xml'
##### `machine_agent`
Default: '/etc/sysconfig/appdynamics-machine-agent'
##### `machine_service_name`
Default: 'appdynamics-machine-agent'

## Limitations

This only works for limited agents with more to be developed and added over time. Currently, the AppDynamics agent module has bee tested on the following operating systems:

* RPM-based Linux 64-bit Machine agent

## Development

Contributions to the module are welcome and appreciated. The following guidelines are required for any code to be merged.

* All code must have corresponding rspec tests where possible.
* Any additional variables or classes that are added must be documented in the readme.
* All TravisCI tests must pass.

## Todo

The remaining agents to add to this module include:
* Java Agent
* .NET Agent
* PHP Agent
* Machine Agent (additional Operating Systems)
* Apache Web Server Agent
* Database Agent
* Analytics Agent
* C/C++ SDK
* Python Agent
* Node.js Agent
* Go SDK
* Network Agent