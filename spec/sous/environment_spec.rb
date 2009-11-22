require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include Sous

describe Environment do
  before(:each) do
    @environment = Environment.new(:test)
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
      pending "not sure we really need this" do
        @environment.role(:test).should be_a(Sous::Role)
      end
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
end