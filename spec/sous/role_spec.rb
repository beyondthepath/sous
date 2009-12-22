require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include Sous

describe Role do
  before(:each) do
    @role = Role.new(:test)
  end
  it "should require a name" do
    lambda { Role.new }.should raise_error
  end
  it "should remember its name" do
    @role.name.should == :test
  end
  it "should have instances" do
    @role.instances
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
  describe "instances" do
    it "should default to an empty array" do
      @role.instances.should == []
    end
  end

  describe "provisioning" do
    it "should not break" do
      @role.provision!
    end
  end

end