require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'Base' do

  let(:base) { Nyulibraries::SiteLeaf::Loaders::Base.new }

  describe '#new' do
    subject { base }
    context 'Authenticate Siteleaf' do
      it 'should authenticate and login' do
        # Doesn't need to be tested as it is Siteleaf functionality
      end
    end
  end

  describe '#create_page' do
    subject { base.create_page }
    it 'should create new page' do
      # Doesn't need to be tested as it is Siteleaf functionality
    end
  end

  describe '#get_page' do
    subject { base.get_page }
    context 'Get Page by page_id & Pages being tested as they need to exist' do
      it 'should return a page' do
        #expect(base.get_page(ENV['STAFF_PAGE_ID'])).to be_instance_of(Siteleaf::Page)
        #expect(base.get_page(ENV['HOURS_PAGE_ID'])).to be_instance_of(Siteleaf::Page)
        #expect(base.get_page(ENV['DEPARTMENT_PAGE_ID'])).to be_instance_of(Siteleaf::Page)
      end
    end
  end

  describe '#get_all_posts' do
    subject { base.get_all_posts }
    context 'Get All Posts on a Page by page_id' do
      it 'should return an array of posts' do
        # No need to test These at is all siteleaf Functionality
        #expect(base.get_all_posts(ENV['STAFF_PAGE_ID'])[0]).to be_instance_of(Siteleaf::Post)
        #expect(base.get_all_posts(ENV['HOURS_PAGE_ID'])[0]).to be_instance_of(Siteleaf::Post)
        #expect(base.get_all_posts(ENV['DEPARTMENT_PAGE_ID'])[0]).to be_instance_of(Siteleaf::Post)
      end
    end
  end

  describe '#update_post_meta' do
    subject { base.update_post_meta }
    context 'Update Meta-fields of a Post' do
      it 'should update the meta-fields of the post in the parameter' do
        # No need to test These at is all siteleaf Functionality
      end
    end
  end

  describe '#update_post_tags' do
    subject { base.update_post_tags }
    context 'Update tags of a Post' do
      it 'should update the tags of the post in the parameter' do
        # No need to test These at is all siteleaf Functionality
      end
    end
  end

  describe '#update_post_date' do
    subject { base.update_post_date }
    context 'Update published_date of a Post' do
      it 'should update the published_date of the post in the parameter' do
        # No need to test These at is all siteleaf Functionality
      end
    end
  end

  describe '#create_post' do
    subject { base.create_post }
    it 'should create new posts' do
      # No need to test These at is all siteleaf Functionality
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
