require 'bundler/gem_tasks'
require 'rake/testtask'

task default: %i[test selftest]

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

desc 'Run RuboCop::Git over itself'
task :selftest do
  require_relative 'lib/rubocop/git'
  RuboCop::Git::Runner.new.run(commits: ['v0.0.4'])
end
