require 'sous/environment'

module Sous
  class Cluster

    attr_accessor :name
    attr_accessor :environments

    def initialize(name, &block)
      self.name = name
      self.environments = []
      self.instance_eval(&block) if block_given?
    end
    
    def environment(name)
      self.environments << Environment.new(name)
    end

  end
end