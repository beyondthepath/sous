module Sous
  class Role < Base

    attr_accessor :name
    attr_accessor :cluster
    attr_accessor :environment, :parent
    attr_accessor :attributes
    
    def initialize(name, environment, &block)
      self.name = name
      self.parent = self.environment = environment
      self.cluster = environment.cluster
      self.attributes = {}
      self.instance_eval(&block) if block_given?
    end
    
    def instance(name)
      # TODO - cf. Cluster#environment, Environment#role - set attributes for a specific instance?
    end

    ###
    # Cluster properties
    ##
    
    sous_attribute :aws_access_key_id, :aws_secret_access_key, :image_id

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