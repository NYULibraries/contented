require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'Base' do
  let(:base) { Nyulibraries::SiteLeaf::Loaders::Base.new }

  describe '#new', vcr: { cassette_name: 'authenticated', record: :none } do
    subject { base }
    context 'Authenticate Siteleaf' do
      let(:key) { '123' }
      let(:secret) { '123' }
      it 'should authenticate and login' do
        response = open("https://api.siteleaf.com/v1/ping.json", http_basic_authentication: [key, secret]).string
        expect(response).to eq('{"ping":"pong"}')
      end
    end
  end

  describe '#create_page' do
    subject { base.create_page }
    it 'should create new page' do
      expect(base.create_page({})).to be_instance_of(Siteleaf::Page)
    end
  end

  describe '#get_page', vcr: { cassette_name: 'get_page', record: :none } do
    subject { base.get_page }
    context 'Get Page by page_id & Pages being tested as they need to exist' do
      it 'should return a page' do
        expect(base.get_page('Pass something so that sitleaf gem doesnt throw an error')).to be_instance_of(Siteleaf::Page)
      end
    end
  end

  describe '#get_all_posts', vcr: { cassette_name: 'get_all_posts', record: :none } do
    subject { base.get_all_posts }
    context 'Get All Posts on a Page by page_id' do
      it 'should return an array of posts' do
        expect(base.get_all_posts('Pass something so that sitleaf gem doesnt throw an error')[0]).to be_instance_of(Siteleaf::Post)
      end
    end
  end

  describe '#get_all_pages', vcr: { cassette_name: 'get_all_pages' } do
    subject { base.get_all_pages }
    context 'Get All sub-pages on a Page by page_id' do
      it 'should return an array of pages' do
        # Cannot test this until and unless siteleaf gem is fixed even the other gem but ahrrr will not fix it cause it returns a json
        # expect(base.get_all_pages(ENV['DEPARTMENT_PAGE_ID'])[0]).to be_instance_of(Siteleaf::Post)
      end
    end
  end

  describe '#update_post_meta' do
    subject { base.update_post_meta }
    context 'Update Meta-fields of a Post' do
      it 'should update the meta-fields of the post in the parameter' do
        expect(base.update_post_meta(Siteleaf::Post.new, {})).to be_instance_of(Siteleaf::Post)
      end
    end
  end

  describe '#update_post_tags' do
    subject { base.update_post_tags }
    context 'Update tags of a Post' do
      it 'should update the tags of the post in the parameter' do
        expect(base.update_post_tags(Siteleaf::Post.new, {})).to be_instance_of(Siteleaf::Post)
      end
    end
  end

  describe '#update_post_date' do
    subject { base.update_post_date }
    context 'Update published_date of a Post' do
      it 'should update the published_date of the post in the parameter' do
        expect(base.update_post_date(Siteleaf::Post.new, {})).to be_instance_of(Siteleaf::Post)
      end
    end
  end

  describe '#create_post' do
    subject { base.create_post }
    it 'should create new posts' do
      expect(base.create_post({})).to be_instance_of(Siteleaf::Post)
    end
  end

  describe '#theme' do
    subject { base.theme }
    context 'Return Theme' do
      it 'should be an instance of Theme' do
        expect(base.theme).to be_instance_of(Siteleaf::Theme)
      end
    end
  end
end
