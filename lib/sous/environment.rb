require 'sous/role'

module Sous
  class Environment

    attr_accessor :name
    attr_accessor :roles
    attr_accessor :attributes

    def initialize(name, &block)
      self.name = name
      self.roles = []
      self.attributes = {}
      self.instance_eval(&block) if block_given?
    end
    
    def role(name, &block)
      self.roles << Role.new(name, &block)
    end

    ###
    # Cluster properties
    ##
    
    def aws_access_key_id(aws_access_key_id=nil)
      self.attributes[:aws_access_key_id] = aws_access_key_id unless aws_access_key_id.nil?
      self.attributes[:aws_access_key_id]
    end

  end
end