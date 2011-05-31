require 'mini_fb'

module Trackablaze
  class FacebookPage < Tracker
    def get_metrics(configs)
      configs.collect {|c| get_metrics_single(c)}
    end
    
    def get_metrics_single(config)      
      params, metrics_keys = config['params'], config['metrics']
      metrics = {}
  
      begin
        page_info = MiniFB.get(nil, params["page_id"])
      rescue
        page_info = {}
      end
      
      metrics_keys ||= FacebookPage.default_metrics
  
      metrics_keys.each do |metrics_key|
        metrics[metrics_key] = page_info[metrics_key]
      end
  
      metrics
    end
  end
end

