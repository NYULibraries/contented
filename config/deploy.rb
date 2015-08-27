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
end
