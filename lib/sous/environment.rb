require 'sous/role'

module Sous
  class Environment < Base

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
    
    sous_attribute :aws_access_key_id, :aws_secret_access_key, :image_id
    
    ###
    # Cluster commands
    ##
    
    def list!
      roles.each do |role|
        role.list!
      end
    end
    
    def provision!
      info "Provisioning..." if verbose?
      roles.each do |role|
        role.provision!
      end
    end
    
    def destroy!(options={})
      info "Destroying..." if verbose?
      roles.each do |role|
        role.destroy!
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
  
  protected
  
    def info(msg)
      puts [handle, msg].join(":\t")
    end

  end
end