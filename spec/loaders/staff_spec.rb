require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'Staff' do
  let(:page_id) { 'TEST_ID' }
  let(:spreadsheet) { ENV['STAFF_SPREADSHEET'] }
  let(:staff) { Nyulibraries::SiteLeaf::Loaders::Staff.new(page_id, spreadsheet) }

  describe '.new' do
    subject { staff }
    context 'when all arguments are passed' do
      it 'should not raise error' do
        # expect(staff).not_to fail
      end
    end
    context 'when some arguments are missing' do
      let(:page_id) { '' }
      it 'should raise error' do
        # expect(staff).to fail
      end
    end
  end
end
