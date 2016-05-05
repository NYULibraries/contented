require 'pry'

module Contented
  module SwiftypeSync
    module Helpers
      module BaseHelper
        ENGINE_SLUG = 'nyu-libraries'

        # crawls given URL; specify domain ID to omit lookup
        def crawl_url(url, domain_id: nil)
          domain_id ||= find_domain_id(url)
          client.crawl_url(ENGINE_SLUG, domain_id, url)
        end

        # returns swiftype domain ID matching given URL's hostname (ignores subpath, protocol)
        def find_domain_id(hostname_or_url)
          find_domain(hostname_or_url)["id"]
        end

        def find_domain(hostname_or_url)
          domains.detect do |domain|
            parse_hostname(domain["start_crawl_url"]) == parse_hostname(hostname_or_url)
          end
        end

        def client
          @client ||= ::Swiftype::Client.new(api_key: api_key)
        end

        def domains
          @domains ||= client.domains(ENGINE_SLUG)
        end

        private

        def parse_hostname(uri)
          URI.parse(uri).hostname
        end

        def api_key
          ENV['SWIFTYPE_API_KEY'] || raise("Must set SWIFTYPE_API_KEY to use Contented::Swiftype features")
        end

      end
    end
  end
end
