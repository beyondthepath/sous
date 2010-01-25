require 'sous/environment'
require 'fog'

module Sous
  class Cluster

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
    
    def aws_access_key_id(aws_access_key_id=nil)
      attributes[:aws_access_key_id] = aws_access_key_id if aws_access_key_id
      attributes[:aws_access_key_id]
    end
    
    def aws_secret_access_key(aws_secret_access_key=nil)
      attributes[:aws_secret_access_key] = aws_secret_access_key if aws_secret_access_key
      attributes[:aws_secret_access_key]
    end
    
    def handle
      name
    end
    
    def connection
      @connection ||= Fog::AWS::EC2.new(
        :aws_access_key_id => aws_access_key_id,
        :aws_secret_access_key => aws_secret_access_key
      )
    end
    
    def servers
      @servers ||= connection.servers
    end
    
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
      puts "Provisioning #{handle}..." if verbose?
      environments.each do |environment|
        environment.provision!
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
    
    def verbose?
      options[:verbosity] && options[:verbosity] > 0
    end

  end
end