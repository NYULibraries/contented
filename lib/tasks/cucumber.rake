require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'cucumber_helpers/project_dir_helpers'

include CucumberHelpers::ProjectDirHelpers

FEATURE_COLLECTIONS = %w[departments locations people about services]

def features_directory
  File.join(project_dir, "features")
end

desc "Run cucumber tests for all pages on specified DOMAIN"
task :features do
  sh "bundle exec cucumber --tags 'not @wip' --require #{features_directory} #{features_directory}"
end

namespace(:features) do
  FEATURE_COLLECTIONS.each do |collection_name|
    desc "Run cucumber tests for #{collection_name} pages on specified DOMAIN"
    task collection_name do
      sh "bundle exec cucumber --tags 'not @wip' --require #{features_directory} #{File.join(features_directory, "#{collection_name}.feature")}"
    end
  end
end
