require 'klout'

module Trackablaze
  class Klout < Tracker
    def get_metrics(tracker_items)
      @klout_client = Kloutbg.new("zxz2p64gv3caabbqmvzaub9p")
      tracker_items.collect {|tracker_item| get_metrics_single(tracker_item)}
    end
    
    def get_metrics_single(tracker_item)  
      metrics = {}
  
      if (tracker_item.params["username"].nil? || tracker_item.params["username"].empty?)
        add_error(metrics, "No username supplied", "username") 
        return metrics
      end
      
      response = nil
      begin
        response = @klout_client.show(tracker_item.params["username"])
      rescue      
      end

      if (response.nil? || response['status'] == 404)
        add_error(metrics, "Invalid username supplied", "username")
        return metrics
      end
      
      s = response['users'][0]['score']
      
      tracker_item.metrics.each do |metric|
        metrics[metric] = s[metric]
      end
  
      metrics
    end
  end
end

