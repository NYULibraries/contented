# Ruby quote
## recipes ##
#require "recipes/nginx" # to only require a specific recipe
# grab all recipes in the folder
Dir[File.dirname(__FILE__) + '/../recipes/*.rb'].each {|file| require file }
## main config ##
#set :application, "remoteworld"

## source control ##
#set :repository, "/home/amay/helloworld/.git"
#set :deploy_to, "/home/amay/remoteworld/"
#set :scm, :git
# Or: 'accurev', 'bzr', 'cvs', 'darcs', 'git', 'mercurial', 'perforce', 'subversion' or 'none'

## misc ##
#set :user, "amay" # set this to whatever the remoteworld's user is
#set :use_sudo, true # set use sudo to false for security reasons
#default_run_options[:pty] = true # It solves 'pty ttl errors'. Not important.
#set :deploy_via, :remote_cache # it compares deployed files with remote files to only implement changed files. Saves bandwidth.

## roles ##
#role :web, "your primary web-server here" #nginx, Apache, etc.
role :app, "localhost" # This may be the same as your web server.
#role :db, "your primary db-server here", :primary => true # This is where rails migrations will run
#role :db, "your slave db-server here"
