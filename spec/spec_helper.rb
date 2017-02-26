$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))


require 'simplecov'
SimpleCov.start do
  puts "--required simplecov"

  add_filter "/bin/"
  add_filter "/spec/"
  add_filter "rspec/scaffold/tasks/"
  # add_group "Long files" do |src_file|
  #   src_file.lines.count > 100
  # end
end

require 'rspec/scaffold'
FIXTURE_ROOT = Pathname.new(File.join File.expand_path('..', __FILE__), 'fixtures')
Dir[
  FIXTURE_ROOT.join('**', '*.rb')
].sort.each &method(:require)
RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  # config.filter_run focus: true
end

require 'pry'
require 'spec_setup_methods'
