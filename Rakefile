require 'bundler/gem_tasks'
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: %i[spec selftest]

desc 'Run RuboCop::Git over itself'
task :selftest do
  require_relative 'lib/rubocop/git'
  RuboCop::Git::Runner.new.run(commits: ['v0.0.4'])
end
