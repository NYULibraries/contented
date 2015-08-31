require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require './lib/convert/convert.rb'
require './lib/loaders/loader.rb'

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
  RSpec::Core::RakeTask.new :spec
  task default: :spec
rescue LoadError
  puts 'No Rspec available'
end

desc 'Run RuboCop'
begin
  RuboCop::RakeTask.new :rubocop
  task default: :rubocop
rescue LoadError
  puts 'No Rubocop available'
end

desc 'Converts all worksheets to Markdown and places them in their respective directory'
task :convert_to_markdowns do
  Loader.new.convert_all_data_to_markdowns
end

desc 'Siteleaf Push theme files alongwith collections'
task :siteleaf_push_all do
  # Note rake does not support Pipeling hence the other rake task had to be called like this and not by invoking
  system 'bundle exec rake convert_to_markdowns && cd site && siteleaf push'
end
