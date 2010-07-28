require File.dirname(__FILE__) + '/support/env.rb'

describe Dollhouse do
  before do
    @online_server = Dollhouse::OnlineServer["spec_server", "deployment", "server", :running]
    @mock_cloud_adapter = mock(:cloud_adapter)
    Dollhouse.stub!(:cloud_adapter).and_return(@mock_cloud_adapter)
  end

  context "babushka-ing with vars" do
    it "shouldn't do anything special with no vars" do
      @mock_cloud_adapter.should_receive(:execute).once.with "spec_server", "babushka 'dep name' --defaults", {}
      @online_server.babushka "dep name"
    end

    it "should write out a single var" do
      @mock_cloud_adapter.should_receive(:write_file).once.with "spec_server", ".babushka/vars/dep name", {
        :vars => {'username' => {:value => 'glen'}}
      }.to_yaml, {}
      @mock_cloud_adapter.should_receive(:execute).once.with "spec_server", "babushka 'dep name' --defaults", {}
      @online_server.babushka "dep name", :username => "glen"
    end

    it "should write out some complex vars" do
      vars = {:ssh_config_file => "~/.ssh/config", :domain => "github.com", :key_file => "~/.ssh/github_key"}
      @mock_cloud_adapter.should_receive(:write_file).once.with "spec_server", ".babushka/vars/SSH alias", {
        :vars => vars.map_keys(&:to_s).map_values { |v| {:value => v} }
      }.to_yaml, {}
      @mock_cloud_adapter.should_receive(:execute).once.with "spec_server", "babushka 'SSH alias' --defaults", {}
      @online_server.babushka "SSH alias", vars
    end
  end

  context "as-ing with a sudo password" do
    it "shouldn't send a nil password" do
      @mock_cloud_adapter.should_receive(:execute).once.with "spec_server", "sudo ls /", {:user=>"app"}
      @online_server.as('app') do
        shell "sudo ls /"
      end
    end
    it "should send a password along" do
      @mock_cloud_adapter.should_receive(:execute).once.with "spec_server", "sudo ls /", {:user=>"app", :sudo_password => 'test'}
      @online_server.as('app', :password => 'test') do
        shell "sudo ls /"
      end
    end
  end
end

