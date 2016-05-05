require 'spec_helper'

describe Contented::SwiftypeSync::Crawler do
  let(:klass){ Contented::SwiftypeSync::Crawler }
  let(:directory){ "_dir/" }
  let(:base_url){ "https://subdomain.example.com/subpath/" }

  describe "class methods" do
    describe "self.crawl" do
      let(:crawler){ klass.new directory: directory, base_url: base_url }

      it "should initialize instance with given parameters and call run_reindex" do
        expect(klass).to receive(:new).with(base_url: base_url, directory: directory).and_return crawler
        expect(crawler).to receive(:run_reindex).and_return true
        klass.crawl(base_url: base_url, directory: directory)
      end
    end

    describe "self.initialize" do
      context "without base_url" do
        let(:crawler){ klass.new directory: directory }

        it "should raise an error" do
          expect{ crawler }.to raise_error(ArgumentError, "missing keyword: base_url")
        end
      end

      context "without directory" do
        let(:crawler){ klass.new base_url: base_url }

        it "should raise an error" do
          expect{ crawler }.to raise_error(ArgumentError, "missing keyword: directory")
        end
      end

      context "with both base_url and directory" do
        let(:crawler){ klass.new directory: directory, base_url: base_url }

        it "should return an instance" do
          expect(crawler).to be_an_instance_of klass
        end
      end
    end

  end

  describe "instance methods" do
    let(:crawler){ klass.new directory: directory, base_url: base_url }
    let(:domain_id){ "applesauce234" }

    # stub out API interface methods
    before do
      allow(crawler).to receive(:find_domain_id).with(base_url).and_return domain_id
      allow(crawler).to receive(:crawl_url).and_return({})
    end

    describe "run_reindex" do
      let(:urls){ %w[example.com/abc example.com/def example.com/ghi] }

      it "should call crawl_domain_url on each item in urls" do
        expect(crawler).to receive(:urls).and_return urls
        expect(crawler).to receive(:crawl_domain_url).once.with(urls[0], verbose: false)
        expect(crawler).to receive(:crawl_domain_url).once.with(urls[1], verbose: false)
        expect(crawler).to receive(:crawl_domain_url).once.with(urls[2], verbose: false)
        crawler.run_reindex
      end
    end

    describe "urls" do
      let(:filepaths){ %w[_dir/abc.markdown _dir/def.markdown _dir/ghi.markdown] }
      let(:urls){ %w[example.com/abc example.com/def example.com/ghi] }

      before do
        allow(crawler).to receive(:filepaths).and_return filepaths
      end

      it "should call filepath_to_url for each filepath and return results" do
        expect(crawler).to receive(:filepath_to_url).once.with(filepaths[0]).and_return urls[0]
        expect(crawler).to receive(:filepath_to_url).once.with(filepaths[1]).and_return urls[1]
        expect(crawler).to receive(:filepath_to_url).once.with(filepaths[2]).and_return urls[2]
        expect(crawler.urls).to match_array urls
      end
    end

    describe "filepaths" do
      let(:filepaths){ %w[_dir/abc.markdown _dir/def.markdown _dir/ghi.markdown] }

      it "should call Dir.glob with correct path and return result" do
        expect(Dir).to receive(:glob).with("_dir/*.markdown").and_return filepaths
        expect(crawler.filepaths).to match_array filepaths
      end
    end

    describe "domain_id" do
      it "should return result of find_domain_id" do
        expect(crawler).to receive(:find_domain_id).with(base_url)
        expect(crawler.domain_id).to eq domain_id
      end

      it "should memoize the result" do
        expect(crawler).to receive(:find_domain_id).with(base_url).once
        crawler.domain_id
        crawler.domain_id
      end
    end

    describe "crawl_domain_url" do
      let(:url){ "https://subdomain.example.com/subpath/xyz" }

      it "should call crawl_url with given url and result of domain_id" do
        expect(crawler).to receive(:domain_id).and_return domain_id
        expect(crawler).to receive(:crawl_url).with(url, hash_including(domain_id: domain_id))
        crawler.crawl_domain_url url
      end
    end

    describe "filepath_to_url" do
      it "should generate correct URL for relative filepath" do
        expect(crawler.filepath_to_url("_dir/adam-kokosinski.markdown")).to eq "https://subdomain.example.com/subpath/adam-kokosinski/"
      end
      it "should generate correct URL for absolute filepath" do
        expect(crawler.filepath_to_url("/home/user/library.nyu.edu/_dir/adam-kokosinski.markdown")).to eq "https://subdomain.example.com/subpath/adam-kokosinski/"
      end
    end

  end
end
