require 'contented'

namespace :contented do
  namespace :reindex do
    desc "Trigger Swiftype recrawl of all URLs for people in #{Contented::SwiftypeSync::PEOPLE_DIR_NAME} directory"
    task :people, [:base_url] do |task_name, args|
      Contented::SwiftypeSync.reindex_people **args.to_h.merge(verbose: true)
    end
  end

  namespace :reindex do
    desc "Trigger Swiftype recrawl of all URLs for services in #{Contented::SwiftypeSync::SERVICES_DIR_NAME} directory"
    task :services, [:base_url] do |task_name, args|
      Contented::SwiftypeSync.reindex_services **args.to_h.merge(verbose: true)
    end
  end
end
