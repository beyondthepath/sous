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
      environment.servers.select do |server|
        server.groups.include?(handle)
      end
    end
    
    def connection
      # TODO: check to see if credentials are provided here for a separate cloud provider
      # Otherwise, defer upward to the environment
      environment.connection
    end
    
    def cluster_attributes
      cluster.attributes.merge(environment.attributes).merge(attributes)
    end
    
    def image_id(image_id=nil)
      attributes[:image_id] = image_id if image_id
      attributes[:image_id] || environment.image_id
    end
    
    def security_groups
      @security_groups ||= connection.security_groups.collect { |group| group.name }
    end
    
    def security_group
      unless security_groups.include?(handle)
        connection.security_groups.create(:name => handle, :description => "Automatically created by sous.")
        security_groups << handle
      end
      handle
    end
    
    ###
    # Cluster commands
    ##
    
    def list!
      servers.each do |instance|
        info [instance.id, instance.state, instance.dns_name].join("\t")
      end
    end
    
    def provision!
      info "Provisioning..."

      # 1. Check to see whether we need to provision, based on servers already running
      info "Checking for running servers."
      if servers.length <= 0 # TODO: compare against minimum specified for this role
        info "We have #{servers.length} servers, provisioning a new one..."
        # 2. Verify that we have all the settings we need to start a new server
        # letting fog throw an image_id error for now
        
        # 3. Provision away as needed!
        info connection.servers.create(
          :image_id => image_id,
          :groups => [ security_group, environment.security_group, cluster.security_group ]
        )
      end
    end
    
    # Uh, yeah, careful with this one
    def destroy!(options={})
      info "Destroying..." if verbose?
      servers.each do |server|
        server.destroy
      end
    end
    
    ###
    # Options accessors
    ##
    
    def verbose?
      cluster.verbose?
    end
    
  protected

    def info(msg)
      puts [handle, msg].join(":\t") if verbose?
    end

  end
end