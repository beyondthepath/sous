module Sous
  class Role

    attr_accessor :name
    attr_accessor :instances

    def initialize(name)
      self.name = name
      self.instances = []
    end
    
    def instance(name)
      # TODO - launch an instance?
    end

  end
end