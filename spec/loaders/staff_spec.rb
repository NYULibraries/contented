require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'Staff' do
  let(:page_id) { 'TEST_ID' }
  let(:spreadsheet) { ENV['STAFF_SPREADSHEET'] }
  let(:staff) { Nyulibraries::SiteLeaf::Loaders::Staff.new(page_id, spreadsheet) }

  describe '.new' do
    subject { staff }
    context 'when all arguments are passed' do
      it 'should not raise error' do
        expect { staff }.not_to raise_error
      end
    end
    context 'when some arguments are missing' do
      let(:page_id) { '' }
      it 'should raise error' do
        expect { staff }.to raise_error
      end
    end
    context 'when some arguments are missing' do
      let(:spreadsheet) { '' }
      it 'should raise error' do
        expect { staff }.to raise_error
      end
    end
  end

  describe '#match_email' do
    context 'match email of post and arg' do
      it 'should return boolean' do
        # pending
      end
    end
  end

  describe '#find_staff_posts' do
    context 'find staff post using email' do
      it 'should return post or nil and nothing else' do
        # pending
      end
    end
  end

  describe '#find_staff_sheet' do
    context 'find staff elements in spreadsheet using email' do
      it 'should return boolean' do
        # pending
      end
    end
  end

  describe '#del_fired_staff_posts' do
    context 'delete posts of fired people' do
      it 'should delete posts in siteleaf directory' do
        # pending
      end
    end
  end

  describe '#create_update_posts' do
    context 'Create and update Posts from Staff spreasheet' do
      it 'should create or updats posts in siteleaf directory' do
        # pending
      end
    end
  end

  describe '#update_posts' do
    context 'Synchronize posts from spreadsheet to siteleaf posts' do
      it 'should call del_fired_staff_posts then create_update_posts' do
        # pending
      end
    end
  end
end
