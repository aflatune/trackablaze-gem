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
      
      tracker_items = []
      config.each do |c|
        tracker_items << Trackablaze::TrackerItem.new(c)
      end
      
      results = Trackablaze::TrackerItem.run(tracker_items)
      
      tracker_items.each do |tracker_item|
        puts "[ #{tracker_item.title} ]".center(75,'-')
        puts "Key: #{tracker_item.key}"
        puts "params: #{tracker_item.params}"
        puts "results: #{results[tracker_item.key]}"
      end
    end
  end
end
