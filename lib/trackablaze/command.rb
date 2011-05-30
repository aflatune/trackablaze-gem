require 'trackablaze'
require 'thor'
require 'yaml'

module Trackablaze
  class Command < Thor
    include Thor::Actions
    
    desc "track FILE", "A YML file that lists trackers to run and parameters to run with"
    def track(file)
      Trackablaze::Tracker.load_trackers
      config = YAML::load( File.open( file ) )
      
      config.each do |tracker_node|
        tracker_name = tracker_node.keys.first
        tracker_config = tracker_node.values.first
        
        tracker = Trackablaze::Tracker.trackers[tracker_name].new

        puts tracker.get_metrics(tracker_config['params'], tracker_config['metrics'])
      end
    end
  end
end
