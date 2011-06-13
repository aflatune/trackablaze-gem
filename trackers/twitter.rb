require 'twitter'

module Trackablaze
  class Twitter < Tracker
    def get_metrics(configs)
      configs.collect {|c| get_metrics_single(c)}
    end
    
    def get_metrics_single(config)      
      params, metrics_keys = config['params'], config['metrics']
      metrics = {}
  
      if (params["handle"].nil? || params["handle"].empty?)
        add_error(metrics, "No handle supplied", "handle") 
        return metrics
      end
      
      user = nil
      begin
        user = ::Twitter.user(params["handle"])
      rescue      
      end

      if (user.nil?)
        add_error(metrics, "Invalid handle supplied", "handle")
        return metrics
      end
      
      metrics_keys ||= Twitter.default_metrics
  
      metrics_keys.each do |metrics_key|
        value = user[metrics_key]
        metrics[metrics_key] = value
      end
  
      metrics
    end
  end
end

