require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

namespace :features do
  Cucumber::Rake::Task.new(:run) do |t|
    t.cucumber_opts = "features"
  end

  namespace :run do
    Cucumber::Rake::Task.new(:beta) do |t|
      t.cucumber_opts = "features DOMAIN=https://beta.library.nyu.edu"
    end

    Cucumber::Rake::Task.new(:local) do |t|
      t.cucumber_opts = "features DOMAIN=http://localhost:9292"
    end
  end

  namespace :benchmark do
    Cucumber::Rake::Task.new(:beta) do |t|
      t.cucumber_opts = "features --format usage DOMAIN=https://beta.library.nyu.edu"
    end

    Cucumber::Rake::Task.new(:local) do |t|
      t.cucumber_opts = "features --format usage DOMAIN=http://localhost:9292"
    end
  end
end
