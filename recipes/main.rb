unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end
Capistrano::Configuration.instance.load do

  namespace :testing do


set :api_key, ENV['DEPLOY_KEY']
set :api_secret, ENV['DEPLOY_SECRET']
set :site_id, ENV['DEPLOY_SITE_ID']

#{"api_key":"efb629faf35a68ec48ac8b4acf1d4ad7","api_secret":"7c604efc88c676ca9c23b2be5675698b"}site_id('5522b4265dde22cab20018e7')

    desc "call all tests sequentially"
    task :RunAll, :roles => :app do
      testing.compile_js_sass
      testing.auth_siteleaf
      testing.setup_siteleaf
      testing.push_theme_siteleaf
      #testing.delete_files_end
    end


    desc "Compile Javascript and Sass from assets Folder to dist folder"
    task :compile_js_sass, :roles => :app do
      run_locally ("bundle install")
      run_locally ("git submodule init")
      run_locally ("git submodule init")
      run_locally ("bundle exec ruby run.rb")
    end

    desc "Siteleaf Authorization & emptying out siteleaf theme"
    task :auth_siteleaf, :roles => :app do
      	run_locally ("echo \"require 'siteleaf'\" | tee -a auth.rb")
	run_locally ("echo \"Siteleaf.api_key    = 'efb629faf35a68ec48ac8b4acf1d4ad7'\" | tee -a auth.rb")
      	run_locally ("echo \"Siteleaf.api_secret = '7c604efc88c676ca9c23b2be5675698b'\" | tee -a auth.rb")
	run_locally ("echo \"theme = theme = Siteleaf::Theme.find_by_site_id('5522b4265dde22cab20018e7')\" | tee -a auth.rb")
      	#run_locally ("echo \"Siteleaf.api_key    = '#{api_key}'\" | tee -a auth.rb")
      	#run_locally ("echo \"Siteleaf.api_secret = '#{api_secret}'\" | tee -a auth.rb")
	#run_locally ("echo \"theme = theme = Siteleaf::Theme.find_by_site_id('#{site_id}')\" | tee -a auth.rb")
	run_locally ("echo \"assets = theme.assets\" | tee -a auth.rb")
	run_locally ("echo \"assets.each do |asset|\" | tee -a auth.rb")
	run_locally ("echo \"asset.delete\" | tee -a auth.rb")
	run_locally ("echo \"end\" | tee -a auth.rb")
      run_locally ("bundle exec ruby auth.rb")
      run_locally ("rm auth.rb")      
    end


    desc "Setup Siteleaf"
    task :setup_siteleaf, :roles => :app do
      run_locally ("siteleaf config empty")
    end

    desc "Push Theme on to Siteleaf"
    task :push_theme_siteleaf, :roles => :app do
      run_locally ("siteleaf push theme")
    end


    #desc "delete all files in the end so whenever we run these tasks again it'll start afresh without any conflicts"
    #task :delete_files_end, :roles => :app do
      #run_locally ("rm -rf library.nyu.edu")
    #end
  end # End namespace
end # End Capistrano instance
