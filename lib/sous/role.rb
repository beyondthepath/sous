module Sous
  class Role

    attr_accessor :name
    attr_accessor :cluster
    attr_accessor :environment
    attr_accessor :servers
    attr_accessor :attributes

    def initialize(name, environment, &block)
      self.name = name
      self.environment = environment
      self.cluster = environment.cluster
      self.servers = []
      self.attributes = {}
      self.instance_eval(&block) if block_given?
    end
    
    def instance(name)
      # TODO - cf. Cluster#environment, Environment#role - set attributes for a specific instance?
    end

    ###
    # Cluster properties
    ##
    
    def aws_access_key_id(aws_access_key_id=nil)
      self.attributes[:aws_access_key_id] = aws_access_key_id unless aws_access_key_id.nil?
      self.attributes[:aws_access_key_id]
    end
    
    def handle
      [cluster.name, environment.name, name].join("-")
    end
    
    def servers(reload=false)
      # TODO: check to see if credentials are provided here for a separate cloud provider
      # Otherwise, defer upward to the environment
      environment.servers
    end
    
    def connection
      # TODO: check to see if credentials are provided here for a separate cloud provider
      # Otherwise, defer upward to the environment
      environment.connection
    end
    
    ###
    # Cluster commands
    ##
    
    def list!
      servers.each do |instance|
        puts instance.inspect if verbose?
      end
    end
    
    def provision!
      info "Provisioning #{handle}..."
      info "Checking to see if #{handle} has any running servers."
      info servers.inspect
      info connection.servers.new
      
      # 1. Check to see whether we need to provision, based on servers already running
      # 2. Provision away as needed!
    end
    
    ###
    # Options accessors
    ##
    
    def verbose?
      cluster.verbose?
    end
    
  protected

    def info(msg)
      puts msg if verbose?
    end

  end
end