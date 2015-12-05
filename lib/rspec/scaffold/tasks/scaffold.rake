require "rake"

namespace :rspec do
  task :scaffold, [:file_name] => :environment do |_, args|
    RSpec::Scaffold::Runner.new(args.file_name).perform
  end

  task :environment do
    # no-op hook task
  end if !Rake::Task.task_defined?(:environment) and !defined?(Rails)
end
