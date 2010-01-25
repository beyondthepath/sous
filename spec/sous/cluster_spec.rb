require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include Sous

describe Cluster do

  before(:each) do
    @cluster = Cluster.new(:test)
  end

  it "should require a name" do
    lambda { Cluster.new }.should raise_error
  end

  it "should remember its name" do
    @cluster.name.should == :test
  end

  it "should have environments" do
    @cluster.environments
  end

  it "should have a method to add a new environment" do
    @cluster.environment(:test)
  end

  describe "environment method" do
    it "should require a name" do
      lambda { @cluster.environment }.should raise_error
    end
    it "should add an environment to environments" do
      @cluster.environment(:test)
      @cluster.environments.first.should be_a(Sous::Environment)
    end
  end

  describe "environments" do
    it "should default to an empty array" do
      @cluster.environments.should == []
    end
  end

  it "should accept a block to define an environment" do
    c = Cluster.new(:test_block) do
      environment :test_env
    end
    c.environments.should_not be_empty
  end
  
  describe "provisioning" do
    before(:each) do
      @cluster.environment(:test)
    end
    it "should have its logic delegated down to the respective environments and roles" do
      @cluster.environments.each { |e| e.should_receive(:provision!) }
      @cluster.provision!
    end
  end
  
  describe "servers" do
    before(:all) do
      # @cluster.stub!(:connection).and_return(mock_connection)
    end
    it "should open a connection to its provider" do
      # @cluster.should_receive(:connection).and_return(mock_connection)
      # @cluster.servers
    end
    it "should receive a listing of servers from its provider connection" do
      @cluster.connection.should_receive(:servers)
      @cluster.servers
    end
  end
  
  describe "aws credentials" do
    before(:each) do
      # @mock_credentials = {'aws_access_key_id' => '1', 'aws_secret_access_key' => '2'}
      # YAML.stub!(:parse).and_return(@mock_credentials)
      # File.stub!(:open).and_return(mock_file)
    end
    it "should support a string path to a file" do
      @cluster.aws_credentials 'examples/aws.yml'
      @cluster.aws_access_key_id.should_not be_nil
      @cluster.aws_secret_access_key.should_not be_nil
    end
  end
  
protected

  def mock_connection
    @mock_connection ||= mock("connection to cloud provider",
      :servers => []
    )
  end

end