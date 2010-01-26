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
      name.to_s
    end
    
    def connection
      @connection ||= Fog::AWS::EC2.new(
        :aws_access_key_id => aws_access_key_id,
        :aws_secret_access_key => aws_secret_access_key
      )
    end
    
    def servers
      connection.servers.select do |server|
        server.state =~ /running|pending/
      end
    end

    # TODO: add support for Array, Hash, Proc, whatever
    def aws_credentials(path)
      case path
      when String
        require 'yaml'
        credentials = YAML.parse_file(path)
        aws_access_key_id(credentials['aws_access_key_id'].value)
        aws_secret_access_key(credentials['aws_secret_access_key'].value)
      end
    end
    
    def image_id(image_id=nil)
      attributes[:image_id] = image_id if image_id
      attributes[:image_id]
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
      options && options[:verbosity] && options[:verbosity] > 0
    end
    
  protected

    def info(msg)
      puts [handle, msg].join(":\t") if verbose?
    end

  end
end