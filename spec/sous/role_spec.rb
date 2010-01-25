require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include Sous

describe Role do

  before(:each) do
    @role = Role.new(:test, mock_environment)
  end

  it "should require a name" do
    lambda { Role.new }.should raise_error
  end

  it "should remember its name" do
    @role.name.should == :test
  end

  it "should have servers" do
    @role.servers
  end

  it "should have a method to add a new instance" do
    @role.instance(:test)
  end

  describe "instance method" do
    it "should require a name" do
      lambda{ @role.instance }.should raise_error
    end
    # it "should return an instance object" do
    #   pending "not sure whether we really need this yet" do
    #     @role.instance(:test).should be_a(Sous::Instance)
    #   end
    # end
  end

  describe "servers" do
    it "should default to an empty array" do
      @role.servers.should == []
    end
    it "should query for servers if authorization is provided on the role" do
      pending "TODO: add support for a separate, role-specific cloud provider"
    end
    it "should look to the environment if authorization is not provided" do
      mock_environment.should_receive(:servers)
      @role.servers
    end
  end

  describe "provisioning" do
    it "should not break" do
      @role.provision!
    end
  end

protected

  def mock_environment
    @mock_environment ||= mock(Environment,
      :cluster => mock_cluster,
      :name => "environment",
      :servers => [],
      :connection => mock_connection
    )
  end
  
  def mock_cluster
    @mock_cluster ||= mock(Cluster,
      :verbose? => false,
      :name => "cluster"
    )
  end
  
  def mock_connection
    @mock_connection ||= mock("connection",
      :servers => mock_servers
    )
  end
  
  def mock_servers
    @mock_servers ||= mock("servers",
      :new => mock("new server")
    )
  end

end