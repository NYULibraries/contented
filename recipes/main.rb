unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end
Capistrano::Configuration.instance.load do

  namespace :testing do


#task :set_variables do
# Configure app_settings from config
# Defer processing until we have rails environment
#set(:api_key, ENV['DEPLOY_SCM_USERNAME'])
#set(:api_secret, ENV['DEPLOY_PATH'])
#set(:user, ENV['DEPLOY_USER'])
#set(:puma_ports, Figs::ENV.puma_ports) if Figs::ENV.puma_ports?
#set(:deploy_to) {"#{fetch :app_path}#{fetch :application}"}
#end

    desc "call all tests sequentially"
    task :RunAll, :roles => :app do
      testing.clone_theme_github
      testing.get_assets
      testing.get_bootstrap
      testing.pre_compilation
      testing.bundle_install
      testing.guard_setup
      testing.guard_Install_run
      testing.guard_post_run
      testing.setup_siteleaf
      testing.empty_siteleaf
      testing.push_theme_siteleaf
      testing.delete_files_end
    end


    desc "Clone entire project from github (version control on github only)"
    task :clone_theme_github, :roles => :app do
      run_locally ("git clone -b development-siteleaf \"https://github.com/NYULibraries/library.nyu.edu\"")
    end


    desc "Get NYU Libraries Assets from github repo NYULibraries/nyulibraries-assets"
    task :get_assets, :roles => :app do
      run_locally ("cd library.nyu.edu &&  git clone \"https://github.com/NYULibraries/nyulibraries-assets\"")
      run_locally ("cd library.nyu.edu &&  cp -a \"nyulibraries-assets/lib/assets/.\" \".\" ")
      run_locally ("cd library.nyu.edu &&  rm -rf nyulibraries-assets") # Remove is just avoid to avoid conflict issues
    end

    desc "Get Bootstrap Assets from github repo for Sass Compilation"
    task :get_bootstrap, :roles => :app do
      run_locally ("cd library.nyu.edu && git clone \"https://github.com/twbs/bootstrap-sass\"")
      # Next Three lines are to get the files that we need from bootstrap and place them in assets where we need them
      run_locally ("cd library.nyu.edu && cp  -r \"bootstrap-sass/assets/stylesheets/bootstrap\" \"stylesheets/bootstrap\"")
      run_locally ("cd library.nyu.edu && cp \"bootstrap-sass/assets/stylesheets/_bootstrap.scss\" \"stylesheets/_bootstrap.scss\"")
      run_locally ("cd library.nyu.edu && cp \"bootstrap-sass/assets/stylesheets/_bootstrap-sprockets.scss\" \"stylesheets/_bootstrap-sprockets.scss\"")
      run_locally ("cd library.nyu.edu && rm -rf bootstrap-sass") # Remove is just avoid to avoid conflict issues
    end

    desc "Initial setup sass stylesheets"
    task :pre_compilation, :roles => :app do
      #setup a SCSS file called assets.scss because all the scss files in assets are partials.
      #partials is not caught by guard until an unless we import it in another file.
      run_locally ("cd library.nyu.edu && echo \"@import 'nyulibraries';\" | tee -a stylesheets/assets.scss")
    end

    desc "getting the gemfile for guard and siteleaf Installing all the gems which include guard gems and siteleaf"
    task :bundle_install, :roles => :app do
      run_locally ("cp -a \"Gemfile\" \"library.nyu.edu/\" ")
      run_locally ("cd library.nyu.edu && bundle install")
    end


    desc "Makes the Directories for guards compilation"
    task :guard_setup, :roles => :app do
      run_locally ("mkdir library.nyu.edu/css")
      run_locally ("mkdir library.nyu.edu/jstmp")
      run_locally ("mkdir library.nyu.edu/jsc")
      run_locally ("mkdir library.nyu.edu/js")
    end


    desc "Copying guard file in place and running it"
    task :guard_Install_run, :roles => :app do
      run_locally ("cp -a \"Guardfile\" \"library.nyu.edu/\" ")
      run_locally ("cd library.nyu.edu && bundle exec guard -n f; true")
    end


    desc "Removes all the coffeescript and Sass folder of assets and renames the css and js folder to _styles and _scripts"
    task :guard_post_run, :roles => :app do
      run_locally ("rm -rf library.nyu.edu/jsc")
      run_locally ("rm -rf library.nyu.edu/jstmp")
      run_locally ("rm -rf library.nyu.edu/_styles")
      run_locally ("rm -rf library.nyu.edu/_scripts")
      #run_locally ("rm -rf library.nyu.edu/images")
      run_locally ("rm -rf library.nyu.edu/stylesheets")
      run_locally ("rm -rf library.nyu.edu/javascripts")

      run_locally ("mv library.nyu.edu/css library.nyu.edu/_styles")
      run_locally ("mv library.nyu.edu/js library.nyu.edu/_scripts")
    end


    desc "Setup Siteleaf"
    task :setup_siteleaf, :roles => :app do
      run_locally ("cd library.nyu.edu && siteleaf config test")
    end

    desc "Empty out Siteleaf theme"
    task :empty_siteleaf, :roles => :app do
      # Authentcation
      #Siteleaf.api_key    = 'efb629faf35a68ec48ac8b4acf1d4ad7'
      #Siteleaf.api_secret = '7c604efc88c676ca9c23b2be5675698b'
      run_locally ("cd library.nyu.edu && mkdir emptytheme");
      run_locally ("cd library.nyu.edu && zip -r  emptytheme.zip emptytheme");
      run_locally ("cd library.nyu.edu && rm -rf emptytheme");
      run_locally ("cd library.nyu.edu && curl -X POST -u {api_key:api_secret} -F file=@emptytheme.zip -F replace=true  https://api.siteleaf.com/v1/sites/551040035dde22e59e001856/theme/assets.json")
      run_locally ("cd library.nyu.edu && rm emptytheme.zip");
    end

    desc "Push Theme on to Siteleaf"
    task :push_theme_siteleaf, :roles => :app do
      run_locally ("cd library.nyu.edu && siteleaf push theme")
    end


    #desc "delete all files in the end so whenever we run these tasks again it'll start afresh without any conflicts"
    #task :delete_files_end, :roles => :app do
      #run_locally ("rm -rf library.nyu.edu")
    end
  end # End namespace
end # End Capistrano instance
