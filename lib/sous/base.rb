module Sous
  class Base

    def set_or_get_attribute(value=nil)
      self.attributes[name.to_sym] = value if value
      self.attributes[name.to_sym] ||
        (@environment && @environment.attributes[name.to_sym]) ||
        (@cluster && @cluster.attributes[name.to_sym])
    end

    def self.sous_attribute(*names)
      names.each do |name|
        define_method(name.to_sym, instance_method(:set_or_get_attribute))
      end
    end
    
    def handle
      [
        self.class != Cluster ? cluster.name.to_s : nil,
        self.class == Role ? environment.name.to_s : nil,
        name.to_s
      ].compact.join("-")
    end
    
    def connection
      unless defined?(@connection)
        @connection = if self.attributes[:aws_access_key_id] && self.attributes[:aws_secret_access_key]
          Fog::AWS::EC2.new(
            :aws_access_key_id => aws_access_key_id,
            :aws_secret_access_key => aws_secret_access_key
          )
        elsif @environment
          @environment.connection
        elsif @cluster
          @cluster.connection
        end
      end
      @connection
    end

    def servers
      (connection.servers || []).select do |server|
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

    def verbose?
      options && options[:verbosity] && options[:verbosity] > 0
    end

  end
end