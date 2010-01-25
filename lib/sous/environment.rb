require 'sous/role'

module Sous
  class Environment

    attr_accessor :name
    attr_accessor :cluster
    attr_accessor :roles
    attr_accessor :attributes

    def initialize(name, cluster, &block)
      self.name = name
      self.cluster = cluster
      self.roles = []
      self.attributes = {}
      self.instance_eval(&block) if block_given?
    end
    
    def role(name, &block)
      role = Role.new(name, self, &block)
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
    
    def handle
      [cluster.name, name].join("-")
    end
    
    def servers
      # TODO: check to see if credentials are provided here for a separate cloud provider
      # Otherwise, defer upward to the cluster
      @servers ||= cluster.servers
    end
    
    def connection
      # TODO: check to see if credentials are provided here for a separate cloud provider
      # Otherwise, defer upward to the cluster
      @connection ||= cluster.connection
    end
    
    ###
    # Cluster commands
    ##
    
    def list!
      roles.each do |role|
        role.list!
      end
    end
    
    def provision!
      puts "Provisioning #{handle}..." if verbose?
      roles.each do |role|
        role.provision!
      end
    end
    
    ###
    # Options accessors
    ##
    
    def options
      cluster.options
    end
    
    def verbose?
      cluster.verbose?
    end

  end
end