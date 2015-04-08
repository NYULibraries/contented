namespace :siteleaf do

  set :api_key, ENV['DEPLOY_KEY']
  set :api_secret, ENV['DEPLOY_SECRET']
  set :site_id, ENV['DEPLOY_SITE_ID']

  namespace :compile do
    desc "Compile Javascript and Sass from assets Folder to dist folder"
    task :all, :roles => :app do
      run_locally ("bundle install")
      run_locally ("git submodule init")
      run_locally ("git submodule update")
      run_locally ("bundle exec ruby config/compile.rb")
    end
  end

  desc "call all tests sequentially"
  task :deploy, :roles => :app do
    compile.all
    siteleaf.auth_cleanup
    siteleaf.setup
    siteleaf.push_theme
    siteleaf.clean_up
  end

  desc "Siteleaf Authorization & all the previous theme files on siteleaf are deleted so as to push in new ones"
  task :auth_cleanup, :roles => :app do
    run_locally ("echo \"require 'siteleaf'\" | tee -a auth.rb")
    run_locally ("echo \"Siteleaf.api_key    = 'efb629faf35a68ec48ac8b4acf1d4ad7'\" | tee -a auth.rb")
    run_locally ("echo \"Siteleaf.api_secret = '7c604efc88c676ca9c23b2be5675698b'\" | tee -a auth.rb")
    run_locally ("echo \"theme = theme = Siteleaf::Theme.find_by_site_id('5522b4265dde22cab20018e7')\" | tee -a auth.rb")
    run_locally ("echo \"assets = theme.assets\" | tee -a auth.rb")
    run_locally ("echo \"assets.each do |asset|\" | tee -a auth.rb")
    run_locally ("echo \"asset.delete\" | tee -a auth.rb")
    run_locally ("echo \"end\" | tee -a auth.rb")
    run_locally ("bundle exec ruby auth.rb")
    run_locally ("rm auth.rb")
  end

  desc "Setup Siteleaf , the config.ru file is created and this is essential for pushing to siteleaf"
  task :setup, :roles => :app do
    run_locally ("siteleaf config empty")
  end

  desc "Push Theme on to Siteleaf"
  task :push_theme, :roles => :app do
    run_locally ("siteleaf push theme")
  end

  desc "Clean up so pushing to github is easier"
  task :clean_up, :roles => :app do
    run_locally ("rm -rf javascripts")
    run_locally ("rm -rf stylesheets")
    run_locally ("rm config.ru")
  end

end
