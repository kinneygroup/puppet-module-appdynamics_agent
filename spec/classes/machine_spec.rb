require 'spec_helper'

describe 'appdynamics_agent::machine' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          'machine_path'          => 'FOOBAR',
          'machine_agent_file_32' => 'FOOBAR',
          'machine_agent_file_64' => 'FOOBAR',
          'controller_host'       => 'FOOBAR',
          'controller_port'       => 'FOOBAR',
          'unique_host_id'        => 'FOOBAR',
          'account_access_key'    => 'FOOBAR',
          'account_name'          => 'FOOBAR',
        }
      end

      it { is_expected.to compile }
    end
  end
end
