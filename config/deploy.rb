namespace :siteleaf do
  
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
    siteleaf.staff
    siteleaf.clean_up
  end

  desc "Siteleaf Authorization & all the previous theme files on siteleaf are deleted so as to push in new ones"
  task :auth_cleanup, :roles => :app do
    run_locally ("bundle exec ruby config/empty_siteleaf.rb") 
  end

  desc "Setup Siteleaf , the config.ru file is created and this is essential for pushing to siteleaf"
  task :setup, :roles => :app do
    run_locally ("siteleaf config empty")
  end

  desc "Push Theme on to Siteleaf"
  task :push_theme, :roles => :app do
    run_locally ("siteleaf push theme")
  end

  desc "Push Theme on to Siteleaf"
  task :staff, :roles => :app do
    run_locally ("bundle exec ruby config/staff.rb") 
  end

  desc "Clean up so pushing to github is easier"
  task :clean_up, :roles => :app do
    run_locally ("rm -rf javascripts")
    run_locally ("rm -rf stylesheets")
    run_locally ("rm config.ru")
  end

end
