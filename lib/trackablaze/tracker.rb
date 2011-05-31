module Trackablaze
  class Tracker
    
    class << self
      attr_accessor :trackers
    
      def load_trackers
        @trackers = {}
        Trackablaze::Tracker.subclasses.each do |t|
          @trackers[t.handle] = t
        end
      end
    end
    
    def self.handle
      @handle ||= self.name.split('::')[1].underscore
    end
    
    def self.info
      @info ||= YAML::load( File.open( File.dirname(__FILE__) + "/../../trackers/#{self.handle}.yml" ) )
    end
    
    def self.title
      self.info['title']
    end
    
    def self.default_metrics
      @default_metrics ||= self.info['metrics'].collect{|k, v| k if v && v['default']}.compact
    end
    
    def get_metrics(params, metrics)
      {}
    end

  end
end