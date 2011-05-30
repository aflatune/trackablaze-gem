require 'bundler'
Bundler.setup :development

require 'mg'
MG.new "trackablaze.gemspec"

require 'rspec/core/rake_task'

desc "run specs"
RSpec::Core::RakeTask.new

task :default => :spec
