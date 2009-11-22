require 'sous/cluster'

def cluster(name, &block)
  Cluster.new(name, &block)
end