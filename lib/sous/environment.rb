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
      role = Role.new(name, &block)
      self.roles << role
      role
    end

    ###
    # Cluster properties
    ##
    
    def aws_access_key_id(aws_access_key_id=nil)
      self.attributes[:aws_access_key_id] = aws_access_key_id unless aws_access_key_id.nil?
      self.attributes[:aws_access_key_id]
    end
    
    ###
    # Cluster commands
    ##
    
    def provision!
      roles.each do |role|
        role.provision!
      end
    end

  end
end