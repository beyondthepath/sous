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
      # TODO - launch an instance?
    end

    ###
    # Cluster properties
    ##
    
    def aws_access_key_id(aws_access_key_id=nil)
      self.attributes[:aws_access_key_id] = aws_access_key_id unless aws_access_key_id.nil?
      self.attributes[:aws_access_key_id]
    end

  end
end