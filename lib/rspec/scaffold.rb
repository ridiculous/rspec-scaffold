require "pathname"
require "delegate"
require "ryan"
require "highline"

module RSpec
  module Scaffold
    autoload :Version, "rspec/scaffold/version"
    autoload :Runner, "rspec/scaffold/runner"
    autoload :Generator, "rspec/scaffold/generator"
    autoload :ConditionExhibit, "rspec/scaffold/condition_exhibit"
  end
end

load "rspec/scaffold/tasks/scaffold.rake"
