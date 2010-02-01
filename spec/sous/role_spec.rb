require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include Sous

describe Role do

  before(:each) do
    @role = Role.new(:test, mock_environment)
    @role.stub!(:connection).and_return(mock_connection)
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
    it "should look to the connection for its servers" do
      @role.should_receive(:connection).at_least(:once).and_return(mock_connection)
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
      :connection => mock_connection,
      :servers => mock_servers,
      :image_id => "",
      :security_group => nil
    )
  end
  
  def mock_cluster
    @mock_cluster ||= mock(Cluster,
      :verbose? => false,
      :name => "cluster",
      :security_group => nil
    )
  end
  
  def mock_connection
    @mock_connection ||= mock(Fog::AWS::EC2,
      :servers => mock_servers,
      :security_groups => mock_security_groups
    )
  end
  
  def mock_servers
    @mock_servers ||= mock("servers",
      :create => mock("new server"),
      :length => 0,
      :select => [],
      :empty? => true
    )
  end
  
  def mock_security_groups
    @mock_security_groups ||= mock("security groups",
      :create => [],
      :collect => []
    )
  end

end