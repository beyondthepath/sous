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
end