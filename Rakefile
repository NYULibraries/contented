require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require './lib/convert/convert.rb'

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
task :nyu_data do
  Conversion::Convert.new.departments
  Conversion::Convert.new.locations
  Conversion::Convert.new.people
  Conversion::Convert.new.services
  Conversion::Convert.new.spaces
end

desc 'Converts departments worksheet to Markdown and places them in their respective directory'
task :departments do
  Conversion::Convert.new.departments
end

desc 'Converts locations worksheet to Markdown and places them in their respective directory'
task :locations do
  Conversion::Convert.new.locations
end

desc 'Converts people worksheet to Markdown and places them in their respective directory'
task :people do
  Conversion::Convert.new.people
end

desc 'Converts services worksheet to Markdown and places them in their respective directory'
task :services do
  Conversion::Convert.new.services
end

desc 'Converts spaces worksheet to Markdown and places them in their respective directory'
task :spaces do
  Conversion::Convert.new.spaces
end

desc 'Siteleaf Push theme files alongwith collections'
task :siteleaf_push do
  sh 'cd site && siteleaf push'
end
