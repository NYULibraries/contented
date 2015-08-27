require File.expand_path('../../lib/loaders/empty_theme.rb', __FILE__)
require File.expand_path('../../lib/loaders/hours.rb', __FILE__)
require File.expand_path('../../lib/loaders/department_page_post.rb', __FILE__)
require File.expand_path('../../lib/convert/convert.rb', __FILE__)
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
    # compile.all
    # siteleaf.empty_theme
    # siteleaf.setup
    # siteleaf.push_theme
    # siteleaf.staff
    # siteleaf.hours
    # siteleaf.departments
    # siteleaf.clean_up
  end

  desc 'Previous theme files on siteleaf are deleted so as to push in new ones'
  task :empty_theme do
    Nyulibraries::SiteLeaf::Loaders::EmptyTheme.new
  end

  desc 'config.ru file is created and this is essential for pushing to siteleaf'
  task :setup do
    run_locally 'echo "require \'rubygems\'" | tee -a config.ru'
    run_locally 'echo "require \'siteleaf\'" | tee -a config.ru'
    run_locally 'echo "run Siteleaf::Server.new(:site_id => \'' + ENV['SITELEAF_ID'] + '\')" | tee -a config.ru'
  end

  desc 'Push Theme on to Siteleaf'
  task :push_theme do
    run_locally 'siteleaf push theme'
  end

  desc 'Clean up so pushing to github is easier'
  task :clean_up do
    run_locally 'rm -rf javascripts'
    run_locally 'rm -rf stylesheets'
    run_locally 'rm config.ru'
  end
end

namespace :nyu_data do
  desc 'converts all the content from spreasheet to Markdown'
  task :all do
    convert = Convert.new
    convert.departments
    convert.locations
    convert.people
    convert.services
    convert.spaces
  end

  desc 'convert departments content from spreasheet to Markdown'
  task :departments do
    Convert.new.departments
  end

  desc 'convert locations content from spreasheet to Markdown'
  task :locations do
    Convert.new.locations
  end

  desc 'convert people content from spreasheet to Markdown'
  task :people do
    Convert.new.people
  end

  desc 'convert services content from spreasheet to Markdown'
  task :services do
    Convert.new.services
  end

  desc 'convert spaces content from spreasheet to Markdown'
  task :spaces do
    Convert.new.spaces
  end
end
