require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include Sous

describe Environment do
  
  before(:each) do
    @environment = Environment.new(:test, mock_cluster)
  end

  it "should require a name" do
    lambda { Environment.new }.should raise_error
  end

  it "should remember its name" do
    @environment.name.should == :test
  end

  it "should have roles" do
    @environment.roles
  end

  it "should have a method to add a new role" do
    @environment.role(:test)
  end

  describe "role method" do
    it "should require a name" do
      lambda{ @environment.role }.should raise_error
    end
    it "should return a role object" do
      @environment.role(:test).should be_a(Sous::Role)
    end
    it "should add a role to its roles" do
      @environment.role(:test)
      @environment.roles.should_not be_empty
    end
  end
  
  describe "roles" do
    it "should default to an empty array" do
      @environment.roles.should == []
    end
  end

  describe "provisioning" do
    before(:each) do
      @environment.role(:app)
    end
    it "should have its logic delegated down to the respective environments and roles" do
      @environment.roles.each { |e| e.should_receive(:provision!) }
      @environment.provision!
    end
  end
  
  describe "servers" do
    it "should default to an empty array" do
      @environment.servers.should == []
    end
    it "should look to the cluster if authorization is not provided" do
      @environment.cluster.should_receive(:servers)
      @environment.servers
    end
    it "should query for servers if authorization is provided on the role" do
      pending "TODO: add support for a separate, role-specific cloud provider"
    end
  end

protected

  def mock_cluster
    @mock_cluster ||= mock(Cluster,
      :verbose? => false,
      :servers => []
    )
  end

end