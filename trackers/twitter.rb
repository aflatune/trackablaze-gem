require 'twitter'

module Trackablaze
  class Twitter < Tracker
    def get_metrics(configs)
      configs.collect {|c| get_metrics_single(c)}
    end
    
    def get_metrics_single(config)      
      params, metrics_keys = config['params'], config['metrics']
      metrics = {}
  
      user = ::Twitter.user(params["handle"])
      
      metrics_keys ||= Twitter.default_metrics
  
      metrics_keys.each do |metrics_key|
        metrics[metrics_key] = user[metrics_key]
      end
  
      metrics
    end
  end
end

