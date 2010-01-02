require 'sous/cluster'

def cluster(name, &block)
  Sous.cluster = Sous::Cluster.new(name, &block)
end

module Sous
  attr_accessor :cluster
end