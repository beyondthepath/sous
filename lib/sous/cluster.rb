require 'sous/environment'
require 'fog'

module Sous
  class Cluster < Base
    
    attr_accessor :name
    attr_accessor :environments
    attr_accessor :attributes
    attr_accessor :options

    def initialize(name, &block)
      self.name = name
      self.environments = []
      self.attributes = {}
      self.instance_eval(&block) if block_given?
    end
    
    def environment(name, &block)
      environment = Environment.new(name, self, &block)
      self.environments << environment
      environment
    end
    
    def roles
      environments.collect { |environment| environment.roles }.flatten
    end
    
    ###
    # Cluster properties
    ##
    
    sous_attribute  :aws_access_key_id, :aws_secret_access_key,
                    :image_id, :flavor
    
    ###
    # Cluster commands
    ##
    
    def list!(options={})
      self.options = options
      environments.each do |environment|
        environment.list!
      end
    end
    
    def provision!(options={})
      self.options = options
      info "Provisioning..." if verbose?
      environments.each do |environment|
        environment.provision!
      end
    end
    
    def destroy!(options={})
      self.options = options
      info "Destroying..." if verbose?
      environments.each do |environment|
        environment.destroy!
      end
    end
    
    # def bootstrap!
    #   environments.each do |environment|
    #     environment.bootstrap!
    #   end
    # end
    
    # def configure!
    #   environments.each do |environment|
    #     environment.configure!
    #   end
    # end
    
    ###
    # Options accessors
    ##
    
  protected

    def info(msg)
      puts [handle, msg].join(":\t") if verbose?
    end

  end
end