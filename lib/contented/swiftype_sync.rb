require 'contented/swiftype_sync/crawler'

module Contented
  module SwiftypeSync
    PEOPLE_DIR_NAME = Contented::Helpers::PersonHelpers::DIR_NAME
    PEOPLE_URL_BASE = "http://dev.library.nyu.edu/people/"

    def self.reindex_people(verbose: false)
      Contented::SwiftypeSync::Crawler.crawl(
        base_url: PEOPLE_URL_BASE,
        directory: PEOPLE_DIR_NAME,
        verbose: verbose
      )
    end

  end
end
