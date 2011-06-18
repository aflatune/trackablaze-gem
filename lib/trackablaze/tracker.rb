module Trackablaze
  class Tracker
    
    # A string that uniquely identifies this instance of the tracker
    # This is to optimize multiple instances that are exactly the same
    # e.g. if 100 people want to track amolk's twitter account, the tracker can
    # be run only once, optimizing calls to Twitter API. 
    def self.key(config)
      # By default we use all params and metrics
      sb = []
      sb.push(self.handle)
      sb.push(config['params'].flatten) if config['params']
      sb.push((config['metrics'] || default_metrics).flatten)
      sb.flatten.join('_')
    end
    
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
    
    def add_error(metrics, error, field = nil)
      metrics['errors'] ||= []
      metrics['errors'].push({:error => error, :field => field})
    end

    def self.param_title(param_name)
      param_info = info['params'][param_name]
      if param_info
        param_info['name']
      else
        param_name
      end
    end
    
    def self.metric_title(metric_name)
      metric_info = info['metrics'][metric_name]
      if metric_info
        metric_info['name']
      else
        metric_name
      end
    end
  end
end