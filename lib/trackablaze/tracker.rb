module Trackablaze
  class Tracker    
    class << self
      attr_accessor :trackers, :info, :handle, :params, :metrics, :title, :default_metrics

      def load
        @info = YAML::load( File.open( File.dirname(__FILE__) + "/../../trackers/#{self.handle}.yml" ) )
        @title = @info['title']
        @params = {}

        self.info['params'].each do |param_name, param_config| 
          @params[param_name] = Param.new(param_name, param_config)
        end

        @metrics = {}
        self.info['metrics'].each do |metric_name, metric_config| 
          @metrics[metric_name] = Metric.new(metric_name, metric_config)
        end

        @default_metrics = self.info['metrics'].collect{|k, v| k if v && v['default']}.compact
      end

      def handle
        @handle ||= self.name.split('::')[1].underscore
      end
        
      def load_trackers
        @trackers = {}
        Trackablaze::Tracker.subclasses.each do |t|
          t.load
          @trackers[t.handle] = t
        end
      end
      
      # A string that uniquely identifies this instance of the tracker
      # This is to optimize multiple instances that are exactly the same
      # e.g. if 100 people want to track amolk's twitter account, the tracker can
      # be run only once, optimizing calls to Twitter API. 
      def key(config)
        # By default we use all params and metrics
        sb = []
        sb.push(self.handle)
        sb.push(config['params'].flatten) if config['params']
        sb.push((config['metrics'] || default_metrics).flatten)
        sb.flatten.join('_')
      end

      # A string that uniquely identifies this instance of the tracker, without the metrics list
      # This is used in the csv output
      def key2(config)
        # By default we use all params and metrics
        sb = []
        sb.push(self.handle)
        sb.push(config['params'].flatten) if config['params']
        sb.flatten.join('_')
      end


      def param_title(param_name)
        (params[param_name].title if params[param_name]) || param_name
      end

      def metric_title(metric_name)
        (metrics[metric_name].title if metrics[metric_name]) || metric_name
      end
    end
    
    def add_error(metrics, error, field = nil)
      metrics['errors'] ||= []
      metrics['errors'].push({:error => error, :field => field})
    end

  end
end