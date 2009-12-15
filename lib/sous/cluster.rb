require 'sous/environment'

module Sous
  class Cluster

    attr_accessor :name
    attr_accessor :environments
    attr_accessor :attributes

    def initialize(name, &block)
      self.name = name
      self.environments = []
      self.attributes = {}
      self.instance_eval(&block) if block_given?
    end
    
    def environment(name, &block)
      environment = Environment.new(name, &block)
      self.environments << environment
      environment
    end
    
    def roles
      environments.collect { |environment| environment.roles }.flatten
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
    
    # def provision!
    #   environments.each do |environment|
    #     environment.provision!
    #   end
    # end
    
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

  end
end