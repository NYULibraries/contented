require 'spec_helper'

describe Contented::SwiftypeSync do
  let(:sync){ Contented::SwiftypeSync }

  describe "self.reindex_people" do
    it "should call crawl on Crawler with correct default parameters" do
      expect(Contented::SwiftypeSync::Crawler).to receive(:crawl).with(
        base_url: "http://dev.library.nyu.edu/people/",
        directory: "_people",
        verbose: false
      )
      sync.reindex_people
    end

    it "should call crawl on Crawler with verbose option if specified" do
      expect(Contented::SwiftypeSync::Crawler).to receive(:crawl).with(
        base_url: "http://dev.library.nyu.edu/people/",
        directory: "_people",
        verbose: true
      )
      sync.reindex_people verbose: true
    end
  end
  
end
