require 'twitter'

module Trackablaze
  class Twitter < Tracker
    def get_metrics(tracker_items)
      tracker_items.collect {|tracker_item| get_metrics_single(tracker_item)}
    end
    
    def get_metrics_single(tracker_item)  
      metrics = {}
  
      if (tracker_item.params["handle"].nil? || tracker_item.params["handle"].empty?)
        add_error(metrics, "No handle supplied", "handle") 
        return metrics
      end
      
      user = nil
      begin
        user = ::Twitter.user(tracker_item.params["handle"])
      rescue      
      end

      if (user.nil?)
        add_error(metrics, "Invalid handle supplied", "handle")
        return metrics
      end
  
      tracker_item.metrics.each do |metric|
        metrics[metric] = user[metric]
      end
  
      metrics
    end
  end
end

