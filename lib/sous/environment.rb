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
    
    def aws_secret_access_key(aws_secret_access_key=nil)
      self.attributes[:aws_secret_access_key] = aws_secret_access_key unless aws_secret_access_key.nil?
      self.attributes[:aws_secret_access_key]
    end
    
    def handle
      [cluster.name, name].join("-")
    end
    
    def connection
      @connection ||= if aws_access_key_id && aws_secret_access_key
        Fog::AWS::EC2.new(
          :aws_access_key_id => aws_access_key_id,
          :aws_secret_access_key => aws_secret_access_key
        )
      else
        cluster.connection
      end
    end
    
    def servers
      connection.servers.select do |server|
        server.state =~ /running|pending/
      end unless connection.servers.nil? || connection.servers.empty?
    end
    
    def image_id(image_id=nil)
      attributes[:image_id] = image_id if image_id
      attributes[:image_id] || cluster.image_id
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