module Trackablaze
  class Metric
    attr_accessor :name, :title, :config
    
    def initialize(name, config)
      @name = name
      @title = config['title']
      @default = config['default']
      @config = config
    end
    
    def default?
      @default == true
    end
  end
end
