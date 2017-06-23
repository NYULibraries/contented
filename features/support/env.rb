# require 'figs'; Figs.load()
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'capybara'
require 'rspec'
require 'cucumber_helpers/project_dir_helpers'
require 'pry'

include CucumberHelpers::ProjectDirHelpers

# add project directory to load path
$LOAD_PATH.unshift(project_dir) unless $LOAD_PATH.include?(project_dir)

def constantize_helper_path(helper_path)
  camelized_basename = File.basename(helper_path).gsub(/\.rb$/, '').split('_').map(&:capitalize).join
  Kernel.const_get camelized_basename
end

# Require and include helper modules
# in feature/support/helpers and its subdirectories.
Dir[File.join(project_dir, "features", "support", "helpers", "**", "*.rb")].each do |helper_path|
  require helper_path
  World constantize_helper_path helper_path
end
