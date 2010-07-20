require File.dirname(__FILE__) + '/support/env.rb'

describe Dollhouse do
  context "babushka-ing with vars" do
    before do
      @online_server = Dollhouse::OnlineServer["spec_server", "server", :running]
      @mock_cloud_adapter = mock(:cloud_adapter)
      Dollhouse.stub!(:cloud_adapter).and_return(@mock_cloud_adapter)
    end

    it "shouldn't do anything special with no vars" do
      @mock_cloud_adapter.should_receive(:execute).once.with "spec_server", "babushka 'dep name'"
      @online_server.babushka "dep name"
    end

    it "should write out a single var" do
      @mock_cloud_adapter.should_receive(:write_file).once.with "spec_server", "~/.babushka/vars/dep name", {
        :vars => {'username' => 'glen'}
      }
      @mock_cloud_adapter.should_receive(:execute).once.with "spec_server", "babushka 'dep name' --defaults"
      @online_server.babushka "dep name", :username => "glen"
    end

    it "should write out some complex vars" do
      @mock_cloud_adapter.should_receive(:write_file).once.with "spec_server", "~/.babushka/vars/SSH alias", {
        :vars => {'ssh_config_file' => "~/.ssh/config", 'domain' => "github.com", 'key_file' => "~/.ssh/github_key"},
      }
      @mock_cloud_adapter.should_receive(:execute).once.with "spec_server", "babushka 'SSH alias' --defaults"
      @online_server.babushka "SSH alias", :ssh_config_file => "~/.ssh/config", :domain => "github.com", :key_file => "~/.ssh/github_key"
    end
  end
end

