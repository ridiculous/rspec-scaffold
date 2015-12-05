$LOAD_PATH.unshift './lib'
require 'rspec/core/rake_task'
require 'bundler/setup'
Bundler.setup
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/lib/**/*_spec.rb'
end
desc 'Run specs'
task default: :spec
