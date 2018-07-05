require 'spec_helper'

describe(file('/data/testhana1')) do
  it {should exist}
  it {should be_directory}
end
describe(file('/data/testhana1/password.json')) do
  it {should be_file}
  it {should be_mode 600}
  it {should be_owned_by 12000}
  it {should be_grouped_into 79}
  its(:content_as_json) {should include('master_password' => 'TestHanaExpress1')}
end
describe(command('/bin/bash /tmp/kitchen/files/waitForDocker.sh hana-testhana1 240')) do
  its(:exit_status) { should eq 0 }
end
describe(docker_image('store/saplabs/hanaexpress:2.00.030.00.20180403.2')) do
  it {should exist}
end
describe(docker_container('hana-testhana1')) do
  it {should be_running}
  it {should have_volume('/hana/mounts', '/data/testhana1')}
end