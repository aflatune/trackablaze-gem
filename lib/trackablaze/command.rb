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
      
      results = []
      trackers = {}
      index = 0
      config.each do |tracker_node|
        tracker_name = tracker_node.keys.first
        trackers[tracker_name] ||= []
        tracker_config = tracker_node.values.first
        tracker_config['index'] = index
        trackers[tracker_name] << tracker_config
        index += 1
      end
      
      trackers.each do |tracker_name, tracker_configs|
        tracker = Trackablaze::Tracker.trackers[tracker_name].new
        
        tracker_config_index = 0
        tracker.get_metrics(tracker_configs).each do |tracker_result|
          index = tracker_configs[tracker_config_index]['index']
          results[index] = tracker_result
          tracker_config_index += 1
        end
      end
      
      (0..config.length-1).each do |n|
        c = config[n]
        tracker_name = c.keys.first
        puts "[ #{Trackablaze::Tracker.trackers[tracker_name].title} ]".center(75,'-')
        puts "params: #{c[tracker_name]['params']}"
        puts "results: #{results[n]}"
      end
    end
  end
end
