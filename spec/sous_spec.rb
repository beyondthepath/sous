require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
include Sous

describe Sous do
  describe "cluster method" do
    it "should require a name" do
      lambda { cluster }.should raise_error(ArgumentError)
    end
    describe "with a basic DSL" do
      before(:each) do
        @cluster = cluster :test do
          environment :production do
            role :app
            role :db
            role :worker
          end
          environment :staging do
            role :app
            role :db
            role :worker
          end
        end
      end
      it "should return a cluster object" do
        @cluster.should be_a(Sous::Cluster)
      end
      it "should have two environments" do
        @cluster.environments.length.should == 2
      end
      it "should have six roles" do
        @cluster.environments.collect{|e|e.roles}.flatten.length.should == 6
        @cluster.roles.length.should == 6
      end
    end
  end

  describe "using a DSL with some overridden attributes" do
    before(:each) do
      @cluster = cluster :test do
        aws_access_key_id 'test1'
        environment :test do
          aws_access_key_id 'test2'
          role :test do
            aws_access_key_id 'test3'
          end
        end
      end
    end
    it "should keep the environment level attributes" do
      @cluster.aws_access_key_id.should == 'test1'
    end
    it "should use the overridden environment attribute" do
      @cluster.environments.first.aws_access_key_id.should == 'test2'
    end
    it "should use the overridden role attribute" do
      @cluster.roles.first.aws_access_key_id.should == 'test3'
    end
  end

end
