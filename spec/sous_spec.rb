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
        @cluster.environments.size.should == 2
      end
    end
  end
end
