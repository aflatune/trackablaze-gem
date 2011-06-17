module Trackablaze
  class TrackerItem
    attr_accessor :name, :config, :params, :metrics, :tracker_class
    def initialize(config)
    	@name = config.keys[0]
  		@tracker_class = Trackablaze::Tracker.trackers[self.name]
    	@config = config[self.name]
  		@params = self.config['params']
  		@metrics = self.config['metrics'] || @tracker_class.default_metrics
    end
  
    def key()
      @key ||= tracker_class.key(config)
    end
    
    def title
      @tracker_class.title
    end

    def full_title
      sb = []
  		sb << @tracker_class.title
  		sb << " "
  		@params.each do |p, v|
  		  sb << "[#{@tracker_class.param_title(p)} = #{v}]"
  		end
  		
  		return sb.join('')
    end
    
    # This function takes config object, similar in structure to a loaded yml config file
    def self.run(tracker_items)
      Trackablaze::Tracker.load_trackers
      
      results = {}
    
      # Dedup tracker items using unique key
      unique_tracker_items = tracker_items.uniq {|ti| ti.key}
    
      # Gather up all unique tracker_items for a given tracker
      tracker_items_by_tracker = {}
      unique_tracker_items.each do |tracker_item|
        tracker_name = tracker_item.name
      
        tracker_items_by_tracker[tracker_name] ||= []
        tracker_items_by_tracker[tracker_name] << tracker_item
      end

      # Run one tracker at a time
      tracker_items_by_tracker.each do |tracker_name, items|
        tracker = items.first.tracker_class.new
        tracker_results = tracker.get_metrics(items)
      
        # Store results by tracker item key
        (0..items.length-1).each do |index|
          item = items[index]
          results[item.key] = tracker_results[index]
        end
      end

      # All keys should have results now, return results
      return results
    end
  end
end