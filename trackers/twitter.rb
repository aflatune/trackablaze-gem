require 'twitter'

module Trackablaze
  class Twitter < Tracker
    def get_metrics(params, metrics_keys)
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

