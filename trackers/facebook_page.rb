require 'mini_fb'

module Trackablaze
  class FacebookPage < Tracker
    def get_metrics(tracker_items)
      tracker_items.collect {|tracker_item| get_metrics_single(tracker_item)}
    end
    
    def get_metrics_single(tracker_item)  
      metrics = {}
  
      if (tracker_item.params["page_id"].nil?)
        add_error(metrics, "No Facebook page ID supplied", "page_id") 
        return metrics
      end
  
      begin
        page_info = MiniFB.get(nil, tracker_item.params["page_id"])
      rescue
        page_info = {}
      end
      
      if (page_info.nil? || page_info['likes'].nil?)
        add_error(metrics, "Invalid Facebook page ID supplied", "page_id")
        return metrics
      end
  
      tracker_item.metrics.each do |metric|
        metrics[metric] = page_info[metric]
      end
  
      metrics
    end
  end
end

