require 'contented/swiftype_sync/crawler'

module Contented
  module SwiftypeSync
    PEOPLE_DIR_NAME = Contented::Helpers::PersonHelpers::DIR_NAME
    PEOPLE_URL_BASE = "http://dev.library.nyu.edu/people/"

    SERVICES_DIR_NAME = "_services"
    SERVICES_URL_BASE = "http://dev.library.nyu.edu/services/"

    LOCATIONS_DIR_NAME = "_locations"
    LOCATIONS_URL_BASE = "http://dev.library.nyu.edu/locations/"
  end
end
