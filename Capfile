# Load DSL and set up stages
require 'capistrano/setup'

# # Include default deployment tasks
# require 'capistrano/deploy'

load 'config/deploy.rb'

# # Load custom tasks from `lib/capistrano/tasks` if you have any defined
# Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

# For the new version of capistrano adding a prodcution stage is a necessity
set :stage, :production
