require 'rspec/core/rake_task'
require 'rubocop/rake_task'

desc 'Checking Bundler setup'
begin
  Bundler.setup
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
  puts 'Run `bundle install` to install missing gems'
end

desc 'Run Rspec'
begin
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
  puts 'No Rspec available'
end

desc 'Run RuboCop'
begin
  RuboCop::RakeTask.new(:rubocop)
  task default: :rubocop
rescue LoadError
  puts 'No Rubocop available'
end

desc 'Run convert script to fill up Library.nyu.edu-data'
begin
  RuboCop::RakeTask.new(:rubocop)
  task default: :rubocop
rescue LoadError
  puts 'No Rubocop available'
end
