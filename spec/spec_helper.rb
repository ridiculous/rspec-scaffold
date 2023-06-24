$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec/scaffold'

FIXTURE_ROOT = Pathname.new(File.join File.expand_path('..', __FILE__), 'fixtures')

# requiring fixture code?
# Dir[
#   FIXTURE_ROOT.join('**', '*.rb')
# ].sort.each &method(:require)

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  # config.filter_run focus: true
end

RSpec::Matchers.define_negated_matcher(:not_change, :change)
RSpec::Matchers.define_negated_matcher(:not_receive, :receive)

require 'spec_setup_methods'
require 'fakefs/safe'
FakeFS.deactivate!

# FakeFS.with_fresh do
#   # whatever it does
# end
