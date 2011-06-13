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
      
      # This function takes config object, similar in structure to a loaded yml config file
      def run_trackers(config)
        results = []
        trackers = {}
        index = 0
        config.each do |tracker_node|
          tracker_name = tracker_node.keys.first
          trackers[tracker_name] ||= []
          tracker_config = tracker_node.values.first
          tracker_config['index'] = index
          trackers[tracker_name] << tracker_config
          index += 1
        end

        trackers.each do |tracker_name, tracker_configs|
          tracker = Trackablaze::Tracker.trackers[tracker_name].new

          tracker_config_index = 0
          tracker.get_metrics(tracker_configs).each do |tracker_result|
            index = tracker_configs[tracker_config_index]['index']
            results[index] = tracker_result
            tracker_config_index += 1
          end
        end
      
        return results
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
    
    def add_error(metrics, error, field = nil)
      puts "ADDING ERROR #{error} on #{field}"
      metrics['errors'] ||= []
      metrics['errors'].push({:error => error, :field => field})
      
      puts "ADDED ERROR #{metrics.inspect}"
    end

  end
end