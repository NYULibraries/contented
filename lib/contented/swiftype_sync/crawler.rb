require 'contented/swiftype_sync/helper/base_helper'

module Contented
  module SwiftypeSync
    class Crawler
      include Contented::SwiftypeSync::Helpers::BaseHelper

      FILE_EXTENSION = ".markdown"

      def self.crawl(base_url:, directory:, verbose: false)
        new(base_url: base_url, directory: directory).run_reindex verbose: verbose
      end

      def initialize(base_url:, directory:)
        @base_url = add_trailing_slash base_url
        @directory = directory
      end

      def run_reindex(verbose: false)
        urls.each do |url|
          crawl_domain_url(url, verbose: verbose)
        end
        puts "Finished crawling #{urls.count} URLs in #{@base_url}" if verbose
      end

      def urls
        @urls ||= filepaths.map{|filepath| filepath_to_url(filepath) }
      end

      def filepaths
        @filepaths ||= Dir.glob(File.join(@directory, "*#{FILE_EXTENSION}"))
      end

      def domain_id
        @domain_id ||= find_domain_id @base_url
      end

      def filepath_to_url(filepath)
        basename = File.basename(filepath).gsub(/#{FILE_EXTENSION}$/, '')
        URI.join(@base_url, add_trailing_slash(basename)).to_s
      end

      def crawl_domain_url(url, verbose: false)
        puts "Crawling url <#{url}>" if verbose
        response = crawl_url url, domain_id: domain_id
        puts "  Swiftype response: #{response.inspect}" if verbose
        puts "  ** New document **" if verbose && response['message']
        response
      end

      private
      def add_trailing_slash(url)
        url[-1] == '/' ? url : url + '/'
      end
    end
  end
end
