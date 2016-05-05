require 'contented'

namespace :contented do
  namespace :reindex do
    desc "Trigger Swiftype recrawl of all URLs for people in #{Contented::Helpers::PersonHelpers::DIR_NAME} directory"
    task :people, [:base_url] do |task_name, args|
      Contented::SwiftypeSync.reindex_people **args.to_h.slice(:base_url).merge(verbose: true)
    end
  end
end
