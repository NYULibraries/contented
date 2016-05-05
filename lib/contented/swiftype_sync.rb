require 'contented/swiftype_sync/crawler'

module Contented
  module SwiftypeSync
    PEOPLE_DIR_NAME = Contented::Helpers::PersonHelpers::DIR_NAME
    PEOPLE_URL_BASE = "http://dev.library.nyu.edu/people/"

    def self.reindex_people(base_url: PEOPLE_URL_BASE, directory: PEOPLE_DIR_NAME, verbose: false)
      Contented::SwiftypeSync::Crawler.crawl(
        base_url: base_url,
        directory: directory,
        verbose: verbose
      )
    end

  end
end
