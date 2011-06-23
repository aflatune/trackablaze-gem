module Trackablaze
  class Param
    attr_accessor :name, :title, :description, :config
    
    def initialize(name, config)
      @name = name
      @title = config['title']
      @description = config['description']
      @config = config
    end
  end
end
