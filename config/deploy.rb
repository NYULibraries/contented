require './lib/convert/convert'
require 'figs'
Figs.load
namespace :siteleaf do
  desc 'Authenticate Siteleaf using ENV Variables in .siteleaf.yml files'
  task :auth do
    File.open('site/.siteleaf.yml', 'w') do |siteleaf_yml|
      siteleaf_yml.write("---\n")
      siteleaf_yml.write("api_key: #{ENV['api_key']}\n")
      siteleaf_yml.write("api_secret: #{ENV['api_secret']}\n")
      siteleaf_yml.write("site_id: #{ENV['site_id']}\n")
    end
  end

  desc 'Push all theme files alongwith Markdown collections to Siteleaf after converting them from worksheet to markdown'
  task :push_all do
    invoke 'siteleaf:auth'
    invoke 'convert:sheet_to_md:all'
    system 'cd site && bundle exec siteleaf push'
  end

  desc 'Push only people markdown files'
  task :push_only_people do
    invoke 'siteleaf:auth'
    invoke 'convert:sheet_to_md:people'
    FileUtils.rm_rf 'tmp_site'
    FileUtils.mkdir_p 'tmp_site'
    FileUtils.cp 'site/.siteleaf.yml', 'tmp_site/'
    system 'cd tmp_site && bundle exec siteleaf pull'
    FileUtils.rm_rf 'tmp_site/_people/'
    FileUtils.cp_r 'site/_people', 'tmp_site/_people'
    system 'cd tmp_site && bundle exec siteleaf push'
    FileUtils.rm_rf 'tmp_site'
  end

  desc 'Cleans up the site directory'
  task :clean_up do
    FileUtils.rm_rf 'tmp_site'
    FileUtils.rm_rf 'site/.siteleaf.yml'
    FileUtils.rm_rf 'site/_departments'
    FileUtils.rm_rf 'site/_locations'
    FileUtils.rm_rf 'site/_people'
    FileUtils.rm_rf 'site/_services'
    FileUtils.rm_rf 'site/_spaces'
  end
end

namespace :deploy do
  desc 'Initialize Deploy for library.nyu.edu'
  task :init do
    system 'bundle install'
    system 'git submodule init'
    system 'git submodule update'
  end

  desc 'Compile Javascript and Sass from assets Folder to dist folder'
  task :compile_js_sass do
    # run_locally 'bundle exec ruby config/compile.rb'
  end
end

namespace :convert do
  namespace :sheet_to_md do
    desc 'Converts all worksheets to Markdown and places them in their respective directory'
    task :all do
      invoke 'convert:sheet_to_md:departments'
      invoke 'convert:sheet_to_md:locations'
      invoke 'convert:sheet_to_md:people'
      invoke 'convert:sheet_to_md:services'
      invoke 'convert:sheet_to_md:spaces'
    end

    desc 'Converts departments worksheet to Markdown and places them in their respective directory'
    task :departments do
      Conversion::Convert.new.make_the_markdown(2, 'departments')
    end

    desc 'Converts locations worksheet to Markdown and places them in their respective directory'
    task :locations do
      Conversion::Convert.new.make_the_markdown(4, 'locations')
    end

    desc 'Converts people worksheet to Markdown and places them in their respective directory'
    task :people do
      # Conversion::Convert.new.make_the_markdown(6, 'people')
    end

    desc 'Converts services worksheet to Markdown and places them in their respective directory'
    task :services do
      Conversion::Convert.new.make_the_markdown(8, 'services')
    end

    desc 'Converts spaces worksheet to Markdown and places them in their respective directory'
    task :spaces do
      Conversion::Convert.new.make_the_markdown(10, 'spaces')
    end
  end
end
