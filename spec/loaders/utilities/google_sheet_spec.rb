require File.expand_path('../../../spec_helper.rb', __FILE__)

describe 'GoogleSheet' do
  let(:uri) { ENV['STAFF_SPREADSHEET'] }
  let(:google_sheet) { Nyulibraries::SiteLeaf::Loaders::Utilities::GoogleSheet.new(uri) }

  describe '.new' do
    subject { google_sheet }
    context 'when all arguments are passed' do
      it 'should not raise error' do
        expect { google_sheet }.not_to raise_error
      end
    end
    context 'when argument is missing' do
      let(:uri) { '' }
      it 'should raise error' do
        expect { google_sheet }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#to_json' do
    subject { google_sheet.to_json }
    context 'should return an json object' do
      it 'should return json object without any $t or gsx$ var' do
        # expect(google_sheet.to_json).to match_response_schema(uri)
        # expect(google_sheet.to_json).not_to include('$t')
        # expect(google_sheet.to_json).not_to include('gsx$')
      end
    end
  end

  describe '#json_data' do
    subject { google_sheet.json_data }
    context 'should return an object form of the json' do
      # A Hashie Mash Functionality Need not be checked
    end
  end
end
