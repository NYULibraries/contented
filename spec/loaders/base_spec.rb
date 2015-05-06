require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'Base' do
  before :all do
    expect(ENV['SITELEAF_KEY']).not_to be_empty
    expect(ENV['SITELEAF_SECRET']).not_to be_empty
    expect(ENV['SITELEAF_ID']).not_to be_empty
    expect(ENV['STAFF_PAGE_ID']).not_to be_empty
    expect(ENV['HOURS_PAGE_ID']).not_to be_empty
    expect(ENV['STAFF_SPREADSHEET']).not_to be_empty
    expect(ENV['LIBCAL_HOURS']).not_to be_empty
  end

  let(:base) { Nyulibraries::SiteLeaf::Loaders::Base.new }

  describe '#new' do
    subject { base }
    context 'Authenticate Siteleaf' do
      it 'should authenticate and login' do
        expect(Siteleaf::User.find('me').firstname).to eql('Amay')
      end
    end
  end

  describe '#create_posts_from_spreadsheet' do
    subject { base.create_posts_from_spreadsheet }
    context 'Needs to be implemented in child class' do
      it 'should raise error' do
        # expect(base.create_posts_from_spreadsheet).to fail
      end
    end
  end

  describe '#create_page' do
    subject { base.create_page }
    it 'should create new page' do
      # pending
    end
  end

  describe '#get_page' do
    subject { base.get_page }
    context 'Get Page by page_id' do
      it 'should return a page' do
        expect(base.get_page(ENV['STAFF_PAGE_ID'])).to be_instance_of(Siteleaf::Page)
        expect(base.get_page(ENV['HOURS_PAGE_ID'])).to be_instance_of(Siteleaf::Page)
      end
    end
  end

  describe '#get_all_posts' do
    subject { base.get_all_posts }
    context 'Get All Posts on a Page by page_id' do
      it 'should return an array of posts' do
        expect(base.get_all_posts(ENV['STAFF_PAGE_ID'])[0]).to be_instance_of(Siteleaf::Post)
        expect(base.get_all_posts(ENV['HOURS_PAGE_ID'])[0]).to be_instance_of(Siteleaf::Post)
      end
    end
  end

  describe '#update_post_meta' do
    subject { base.update_post_meta }
    context 'Update Meta-fields of a Post' do
      it 'should update the meta-fields of the post in the parameter' do
        # pending
      end
    end
  end

  describe '#update_post_date' do
    subject { base.update_post_date }
    context 'Update published_date of a Post' do
      it 'should update the published_date of the post in the parameter' do
        # pending
      end
    end
  end

  describe '#create_post' do
    subject { base.create_post }
    it 'should create new posts' do
      # pending
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
