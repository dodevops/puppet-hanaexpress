require 'spec_helper'

describe 'database' do
  describe(file('/data/testhana1')) do
    it { is_expected.to exist }
    it { is_expected.to be_directory }
  end

  describe(file('/data/testhana1/password.json')) do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 600 }
    it { is_expected.to be_owned_by 12_000 }
    it { is_expected.to be_grouped_into 79 }
    its(:content_as_json) { is_expected.to include('master_password' => 'TestHanaExpress1') }
  end

  describe(command('/bin/bash /tmp/kitchen/files/waitForDocker.sh hana-testhana1 240')) do
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe(docker_image('store/saplabs/hanaexpress:2.00.030.00.20180403.2')) do
    it { is_expected.to exist }
  end

  describe(docker_container('hana-testhana1')) do
    it { is_expected.to be_running }
    it { is_expected.to have_volume('/hana/mounts', '/data/testhana1') }
  end
end
