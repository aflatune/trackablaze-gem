# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require File.dirname(__FILE__) + "/version"

Gem::Specification.new do |s|
  s.name        = "trackablaze"
  s.version     = Trackablaze::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Amol Kelkar"]
  s.email       = ["amolk@aflatune.com"]
  s.homepage    = "http://trackablaze.com"
  s.summary     = %q{A tool to track web metrics.}
  s.description = %q{Track metrics such as a Twitter account's number of followers, count of tweets, etc}

  s.rubyforge_project = "trackablaze"
  
  s.add_dependency "i18n"
  s.add_dependency "activesupport", ">= 3.0.0"
  s.add_dependency "thor"

  # Tracker gem dependencies
  s.add_dependency "twitter"
  s.add_dependency "mini_fb"
    
  s.add_development_dependency "rspec", "~> 2.5.0"
  s.add_development_dependency "mg"
  s.add_development_dependency "rails", ">= 3.0.0"

  s.files         = Dir["lib/**/*.rb", "trackers/*", "README.markdown", "version.rb"] 
  s.test_files    = Dir["spec/**/*"] 
  s.executables   = ["trackablaze"]
  s.require_paths = ["lib"]
end

