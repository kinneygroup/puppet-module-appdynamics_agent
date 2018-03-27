
# appdynamics_agent

Welcome to your new module. A short overview of the generated parts can be found in the PDK documentation at https://docs.puppet.com/pdk/1.0/pdk_generating_modules.html#module-contents .

Below you'll find the default README template ready for some content.







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

## Description

AppDynamics (https://www.appdynamics.com/) is a solution that provides insight into application performance through application flow maps and transaction monitoring.

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

To use the Standalone Machine agent, add or update the values to the associated variables, either in a hiera structure or in the module:
  ```String $machine_path,
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
  Strgin $machine_service_name = 'appdynamics-machine-agent',```

Then add ```include appdynamics::machine``` to the profile for the host.

## Reference

Users need a complete list of your module's classes, types, defined types providers, facts, and functions, along with the parameters for each. You can provide this list either via Puppet Strings code comments or as a complete list in the README Reference section.

* If you are using Puppet Strings code comments, this Reference section should include Strings information so that your users know how to access your documentation.

* If you are not using Puppet Strings, include a list of all of your classes, defined types, and so on, along with their parameters. Each element in this listing should include:

  * The data type, if applicable.
  * A description of what the element does.
  * Valid values, if the data type doesn't make it obvious.
  * Default value, if any.

## Limitations

This only works for limited agents on RedHat/CentOS Linux. More will be developed and added over time.

## Development

Since your module is awesome, other users will want to play with it. Let them know what the ground rules for contributing are.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header. 
