require 'sous/base'
require 'sous/cluster'

def cluster(name, &block)
  @cluster = Sous::Cluster.new(name, &block)
end

module Sous
end