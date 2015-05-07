require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'Departments' do
  let(:page_id) { 'TEST_ID' }
  let(:spreadsheet) { ENV['DEPARTMENTS_SPREADSHEET'] }
  let(:dept) { Nyulibraries::SiteLeaf::Loaders::Departments.new(page_id, spreadsheet) }

  describe '.new' do
    subject { dept }
    context 'when all arguments are passed' do
      it 'should not raise error' do
        expect { dept }.not_to raise_error
      end
    end
    context 'when some arguments are missing' do
      let(:page_id) { '' }
      it 'should raise error' do
        expect { dept }.to raise_error
      end
    end
    context 'when some arguments are missing' do
      let(:spreadsheet) { '' }
      it 'should raise error' do
        expect { dept }.to raise_error
      end
    end
  end

  describe '#match_name' do
    context 'match name of post and arg' do
      it 'should return boolean' do
        # pending
      end
    end
  end

  describe '#find_dept_posts' do
    context 'find dept post using name' do
      it 'should return post or nil and nothing else' do
        # pending
      end
    end
  end

  describe '#find_dept_sheet' do
    context 'find department elements in spreadsheet using name' do
      it 'should return boolean' do
        # pending
      end
    end
  end

  describe '#del_fired_dept_posts' do
    context 'delete posts of fired departments' do
      it 'should delete posts in siteleaf post departments' do
        # pending
      end
    end
  end

  describe '#create_update_posts' do
    context 'Create and update Posts from Department spreasheet' do
      it 'should create or update posts in siteleaf departments' do
        # pending
      end
    end
  end

  describe '#update_posts' do
    context 'Synchronize posts from spreadsheet to department posts' do
      it 'should call del_fired_dept_posts then create_update_posts' do
        # pending
      end
    end
  end
end
