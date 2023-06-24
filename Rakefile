require 'rake/release'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |config|
  config.pattern = 'spec/lib/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:integration) do |config|
  config.pattern = 'spec/integration/**/*_spec.rb'
end

task default: [:spec, :integration]
