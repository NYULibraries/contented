require File.expand_path('../../lib/loaders/empty_theme.rb', __FILE__)
require File.expand_path('../../lib/loaders/staff.rb', __FILE__)
require File.expand_path('../../lib/loaders/hours_about.rb', __FILE__)

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
    siteleaf.empty_theme
    siteleaf.setup
    siteleaf.push_theme
    siteleaf.staff
    siteleaf.hours
    siteleaf.clean_up
  end

  desc "Siteleaf Authorization & all the previous theme files on siteleaf are deleted so as to push in new ones"
  task :empty_theme, :roles => :app do
    Nyulibraries::Site_leaf::Loaders::Empty_Theme.new
  end

  desc "Setup Siteleaf , the config.ru file is created and this is essential for pushing to siteleaf"
  task :setup, :roles => :app do
    run_locally ("siteleaf config empty")
  end

  desc "Push Theme on to Siteleaf"
  task :push_theme, :roles => :app do
    run_locally ("siteleaf push theme")
  end

  desc "Creates Posts for each individual Staff member on directory page"
  task :staff, :roles => :app do
    Nyulibraries::Site_leaf::Loaders::Staff.new(ENV['STAFF_PAGE_ID'],ENV['STAFF_SPREADSHEET']).crud_posts
  end

  desc "Creates Posts for each library on hours page"
  task :hours, :roles => :app do
    Nyulibraries::Site_leaf::Loaders::Hours_About.new(ENV['HOURS_PAGE_ID'],ENV['LIBCAL_HOURS']).crud_posts
  end

  desc "Clean up so pushing to github is easier"
  task :clean_up, :roles => :app do
    run_locally ("rm -rf javascripts")
    run_locally ("rm -rf stylesheets")
    run_locally ("rm config.ru")
  end

end
