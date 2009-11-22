require 'sous/role'

module Sous
  class Environment

    attr_accessor :name
    attr_accessor :roles

    def initialize(name)
      self.name = name
      self.roles = []
    end
    
    def role(name)
      self.roles << Role.new(name)
    end

  end
end