require 'mini_fb'

module Trackablaze
  class FacebookPage < Tracker
    def get_metrics(configs)
      configs.collect {|c| get_metrics_single(c)}
    end
    
    def get_metrics_single(config)      
      params, metrics_keys = config['params'], config['metrics']
      metrics = {}
  
      if (params["page_id"].nil?)
        add_error(metrics, "No Facebook page ID supplied", "page_id") 
        return metrics
      end
  
      begin
        page_info = MiniFB.get(nil, params["page_id"])
      rescue
        page_info = {}
      end
      
      if (page_info.nil? || page_info['likes'].nil?)
        add_error(metrics, "Invalid Facebook page ID supplied", "page_id")
        return metrics
      end
      
      metrics_keys ||= FacebookPage.default_metrics
  
      metrics_keys.each do |metrics_key|
        metrics[metrics_key] = page_info[metrics_key]
      end
  
      metrics
    end
  end
end

