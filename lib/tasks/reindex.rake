require 'contented'

namespace :contented do
  namespace :reindex do
    desc "Trigger Swiftype recrawl of all URLs for people in #{Contented::Helpers::PersonHelpers::DIR_NAME} directory"
    task :people do
      Contented::SwiftypeSync.reindex_people verbose: true
    end
  end
end
