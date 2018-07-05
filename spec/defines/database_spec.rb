require 'spec_helper'

describe 'hanaexpress::database' do
  let(:pre_condition) {'class { "hanaexpress": store_username => "test", store_pass_hash => "test" } class { "docker": }'}
  let(:title) {'testhana1'}
  let(:params) do
    {
        version: "some_version",
        password: "some_password",
        systemdb_port: 12345,
        tenantdb_port: 23456
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) {os_facts}

      context "with default parameters" do
        it "compiles" do
          is_expected.to compile
        end
        it "creates the data path for the instance" do
          is_expected
              .to contain_file('/data/testhana1')
                      .with(
                          'ensure' => 'directory',
                          'owner' => 12000,
                          'group' => 79
                      )
        end
        it "creates the password file" do
          is_expected
              .to contain_file('/data/testhana1/password.json')
                      .with(
                          'ensure' => 'file',
                          'owner' => 12000,
                          'group' => 79,
                          'mode' => '0600'
                      )
        end
        it "creates the container" do
          is_expected
              .to contain_docker__run('hana-testhana1')
                      .with(
                          'hostname' => 'hana-testhana1',
                          'image' => 'store/saplabs/hanaexpress:some_version',
                          'ports' => %w(12345:39017 23456:39041),
                          'volumes' => %w(/data/testhana1:/hana/mounts),
                          'extra_parameters' => [
                              '--ulimit nofile=1048576:1048576',
                              '--sysctl kernel.shmmax=1073741824',
                              '--sysctl net.ipv4.ip_local_port_range=\'40000 60999\'',
                              '--sysctl kernel.shmmni=524288',
                              '--sysctl kernel.shmall=8388608'
                          ],
                          'command' => '--passwords-url file:///hana/mounts/password.json --agree-to-sap-license'
                      )
        end
        it "sets fs.file-max" do
          is_expected
              .to contain_sysctl('fs.file-max')
                      .with_value('20000000')
        end
        it "sets fs.aio-max-nr" do
          is_expected
              .to contain_sysctl('fs.aio-max-nr')
                      .with_value('262144')
        end
        it "sets vm.vm-memory_failure_early_kill" do
          is_expected
              .to contain_sysctl('vm.memory_failure_early_kill')
                      .with_value('1')
        end
        it "sets vm.max_map_count" do
          is_expected
              .to contain_sysctl('vm.max_map_count')
                      .with_value('135217728')
        end
        it "sets net.ipv4.ip_local_port_range" do
          is_expected
              .to contain_sysctl('net.ipv4.ip_local_port_range')
                      .with_value('40000 60999')
        end
        it "logs into the docker store" do
          is_expected
              .to contain_docker__registry('https://index.docker.io/v1/')
                      .with(
                          'username' => 'test',
                          'pass_hash' => 'test'
                      )
        end
        it "creates the data path" do
          is_expected
              .to contain_file('/data').with_ensure('directory')
        end
      end

    end
  end
end
