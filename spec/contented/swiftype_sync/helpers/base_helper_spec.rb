require 'spec_helper'

describe Contented::SwiftypeSync::Helpers::BaseHelper do
  let(:helper){ Class.new{ extend Contented::SwiftypeSync::Helpers::BaseHelper } }
  let(:engine_slug){ Contented::SwiftypeSync::Helpers::BaseHelper::ENGINE_SLUG }

  describe "crawl_url" do
    let(:client){ double Swiftype::Client }
    let(:url){ "example.com/abc" }
    let(:domain_id){ "blahblahblah" }
    let(:response){ {'sample'=>'sample'} }

    before do
      allow(helper).to receive(:client).and_return client
      allow(client).to receive(:crawl_url).and_return response
    end

    context "with domain_id" do
      it "should call crawl_url on client" do
        expect(client).to receive(:crawl_url).with(engine_slug, domain_id, url)
        expect(helper.crawl_url(url, domain_id: domain_id)).to eq response
      end
    end

    context "without domain_id" do
      let(:alt_domain_id){ "zzzzzzz" }

      it "should call crawl_url on client with result of find_domain_id" do
        expect(helper).to receive(:find_domain_id).with(url).and_return alt_domain_id
        expect(client).to receive(:crawl_url).with(engine_slug, alt_domain_id, url)
        expect(helper.crawl_url(url)).to eq response
      end
    end
  end

  describe "find_domain_id" do
    let(:url){ "example.com/abc" }
    let(:domain){ {'id'=>'abcd', 'other'=>'thing'} }

    it "should return id from find_domain result" do
      expect(helper).to receive(:find_domain).with(url).and_return domain
      expect(helper.find_domain_id(url)).to eq 'abcd'
    end
  end

  describe "find_domain" do
    let(:domain1){ {'id'=>'abcd', 'start_crawl_url'=>'http://example1.com/'} }
    let(:domain2){ {'id'=>'efgh', 'start_crawl_url'=>'https://example2.com/subpath/'} }
    let(:domain3){ {'id'=>'ijkl', 'start_crawl_url'=>'http://example3.com/sub/path/'} }

    before do
      allow(helper).to receive(:domains).and_return [domain1, domain2, domain3]
    end

    it "should find the domain hash whose start_crawl_url host matches the given URL with same protocol" do
      expect(helper.find_domain("http://example1.com/hello/world")).to eq domain1
    end

    it "should find the domain hash whose start_crawl_url host matches the given URL with mismatched protocol" do
      expect(helper.find_domain("https://example1.com/hello/world")).to eq domain1
    end

    it "should find the domain hash whose start_crawl_url host matches the given URL with same protocol and mismatched subpath" do
      expect(helper.find_domain("http://example3.com/hello/world")).to eq domain3
    end

    it "should find the domain hash whose start_crawl_url host matches the given URL with mismatched protocol and mismatched subpath" do
      expect(helper.find_domain("http://example2.com/hello/world")).to eq domain2
    end
  end

  describe "domains" do
    let(:client){ double Swiftype::Client }
    let(:domains){ %w[1 2 3] }

    before do
      allow(helper).to receive(:client).and_return client
    end

    it "should return result from client.domains" do
      expect(client).to receive(:domains).with(engine_slug).and_return domains
      expect(helper.domains).to eq domains
    end
  end

  describe "client" do
    context "with SWIFTYPE_API_KEY" do
      let(:swiftype_api_key){ "XXXX" }

      around do |example|
        with_modified_env swiftype_api_key: swiftype_api_key do
          example.run
        end
      end

      it "should generate client with correct api key" do
        expect(::Swiftype::Client).to receive(:new).with(hash_including(api_key: swiftype_api_key)).and_call_original
        expect(helper.client).to be_an_instance_of ::Swiftype::Client
      end
    end

    context "without SWIFTYPE_API_KEY" do
      around do |example|
        with_modified_env swiftype_api_key: nil do
          example.run
        end
      end

      it "should raise an error" do
        expect{ helper.client }.to raise_error "Must set swiftype_api_key to use Contented::Swiftype features"
      end
    end
  end
end
