require 'contented'

namespace :contented do
  namespace :reindex do
    desc "Trigger Swiftype recrawl of all URLs for people in #{Contented::SwiftypeSync::PEOPLE_DIR_NAME} directory"
    task :people, [:base_url] do |task_name, args|
      Contented::SwiftypeSync::Crawler.crawl(**({
        directory: Contented::SwiftypeSync::PEOPLE_DIR_NAME,
        base_url: Contented::SwiftypeSync::PEOPLE_URL_BASE,
        verbose: true
      }).merge(args.to_h))
    end

    desc "Trigger Swiftype recrawl of all URLs for services in #{Contented::SwiftypeSync::SERVICES_DIR_NAME} directory"
    task :services, [:base_url] do |task_name, args|
      Contented::SwiftypeSync::Crawler.crawl(**({
        directory: Contented::SwiftypeSync::SERVICES_DIR_NAME,
        base_url: Contented::SwiftypeSync::SERVICES_URL_BASE,
        verbose: true
      }).merge(args.to_h))
    end

    desc "Trigger Swiftype recrawl of all URLs for people in #{Contented::SwiftypeSync::LOCATIONS_DIR_NAME} directory"
    task :locations, [:base_url] do |task_name, args|
      Contented::SwiftypeSync::Crawler.crawl(**({
        directory: Contented::SwiftypeSync::LOCATIONS_DIR_NAME,
        base_url: Contented::SwiftypeSync::LOCATIONS_URL_BASE,
        verbose: true
      }).merge(args.to_h))
    end
  end
end
