module Sous
  class Role

    attr_accessor :name
    attr_accessor :instances
    attr_accessor :attributes

    def initialize(name, &block)
      self.name = name
      self.instances = []
      self.attributes = {}
      self.instance_eval(&block) if block_given?
    end
    
    def instance(name)
      # TODO - find and set attributes for a specific instance?
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
    
    def provision!
      # 1. Check to see whether we need to provision, based on instances already running
      # 2. Provision away as needed!
    end

  end
end