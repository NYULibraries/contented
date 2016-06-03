require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

SITES = {
  beta: "https://beta.library.nyu.edu",
  local: "http://localhost:9292"
}

FEATURE_COLLECTIONS = %w[departments locations people about services]

namespace(:features) do
  Cucumber::Rake::Task.new(:all) do |t|
    t.cucumber_opts = "features"
  end

  FEATURE_COLLECTIONS.each do |collection_name|
    Cucumber::Rake::Task.new(collection_name) do |t|
      t.cucumber_opts = "features/#{collection_name}.feature --require features"
    end
  end

  namespace(:all) do
    SITES.each do |site_name, domain|
      Cucumber::Rake::Task.new(site_name) do |t|
        t.cucumber_opts = "features DOMAIN=#{domain}"
      end
    end
  end

  FEATURE_COLLECTIONS.each do |collection_name|
    namespace(collection_name) do
      SITES.each do |site_name, domain|
        Cucumber::Rake::Task.new(site_name) do |t|
          t.cucumber_opts = "features/#{collection_name}.feature --require features DOMAIN=#{domain}"
        end
      end
    end
  end

  namespace(:benckmark) do
    SITES.each do |site_name, domain|
      Cucumber::Rake::Task.new(site_name) do |t|
        t.cucumber_opts = "features DOMAIN=#{domain}"
      end
    end
  end

  # namespace :run do
  #   Cucumber::Rake::Task.new(:beta) do |t|
  #     t.cucumber_opts = "features DOMAIN=https://beta.library.nyu.edu"
  #   end
  #
  #   Cucumber::Rake::Task.new(:local) do |t|
  #     t.cucumber_opts = "features DOMAIN=http://localhost:9292"
  #   end
  # end
  #
  # namespace :benchmark do
  #   Cucumber::Rake::Task.new(:beta) do |t|
  #     t.cucumber_opts = "features --format usage DOMAIN=https://beta.library.nyu.edu"
  #   end
  #
  #   Cucumber::Rake::Task.new(:local) do |t|
  #     t.cucumber_opts = "features --format usage DOMAIN=http://localhost:9292"
  #   end
  # end
end
