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
      
      results = Trackablaze::Tracker.run_trackers(config)
      
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
