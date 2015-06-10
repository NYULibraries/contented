require File.expand_path('../../lib/loaders/empty_theme.rb', __FILE__)
require File.expand_path('../../lib/loaders/hours.rb', __FILE__)
require File.expand_path('../../lib/loaders/department_page_post.rb', __FILE__)
namespace :siteleaf do
  namespace :compile do
    desc 'Compile Javascript and Sass from assets Folder to dist folder'
    task :all do
      run_locally 'bundle install'
      run_locally 'git submodule init'
      run_locally 'git submodule update'
      run_locally 'bundle exec ruby config/compile.rb'
    end
  end

  desc 'call all tests sequentially'
  task :deploy do
    compile.all
    siteleaf.empty_theme
    siteleaf.setup
    siteleaf.push_theme
    # siteleaf.staff
    # siteleaf.hours
    siteleaf.departments
    siteleaf.clean_up
  end

  desc 'Previous theme files on siteleaf are deleted so as to push in new ones'
  task :empty_theme do
    Nyulibraries::SiteLeaf::Loaders::EmptyTheme.new
  end

  desc 'config.ru file is created and this is essential for pushing to siteleaf'
  task :setup do
    run_locally 'echo "require \'rubygems\'" | tee -a config.ru'
    run_locally 'echo "require \'siteleaf\'" | tee -a config.ru'
    run_locally 'echo "run Siteleaf::Server.new(:site_id => \''+ENV['SITELEAF_ID']+'\')" | tee -a config.ru'
  end

  desc 'Push Theme on to Siteleaf'
  task :push_theme do
    run_locally 'siteleaf push theme'
  end

  desc 'Creates Posts for each individual Staff member on directory page'
  task :staff do
    # Nyulibraries::SiteLeaf::Loaders::Staff.new(ENV['STAFF_PAGE_ID'], ENV['STAFF_SPREADSHEET']).update_posts
  end

  desc 'Creates Posts for each library on hours page'
  task :hours do
    # Nyulibraries::SiteLeaf::Loaders::Hours.new(ENV['HOURS_PAGE_ID'], ENV['LIBCAL_HOURS']).update_posts
  end

  desc 'Creates Pages for each Departments'
  task :departments do
    Nyulibraries::SiteLeaf::Loaders::Department_Page_Post.new(ENV['DEPARTMENT_PAGE_ID'],ENV['DEPARTMENTS_SPREADSHEET']).create_pages
    # Nyulibraries::SiteLeaf::Loaders::Department.new(ENV['DEPARTMENT_PAGE_ID'],ENV['DEPARTMENTS_SPREADSHEET']).update_pages
  end

  desc 'Clean up so pushing to github is easier'
  task :clean_up do
    run_locally 'rm -rf javascripts'
    run_locally 'rm -rf stylesheets'
    run_locally 'rm config.ru'
  end
end
