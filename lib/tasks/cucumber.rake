require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

FEATURE_COLLECTIONS = %w[departments locations people about services]

desc "Run cucumber tests for all pages on specified DOMAIN"
task :features do
  sh 'bundle exec cucumber features'
end

namespace(:features) do
  FEATURE_COLLECTIONS.each do |collection_name|
    desc "Run cucumber tests for #{collection_name} pages on specified DOMAIN"
    task collection_name do
      sh "bundle exec cucumber --require features/ features/#{collection_name}.feature"
    end
  end
end
