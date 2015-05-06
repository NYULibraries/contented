require File.expand_path('../../spec_helper.rb', __FILE__)

describe 'GoogleSheet' do
  let(:google_sheet) { GoogleSheet.new }

  describe '.new' do
    subject { google_sheet }
    context 'when all arguments are passed' do
      # it { should_not raise_error }
    end
    context 'when one argument is missing' do
      # let(:uri) { nil }
      # it { should raise_error }
    end
  end

  describe '#to_json' do
    subject { google_sheet.to_json }
    context 'should return an json object' do
      # pending
    end
  end

  describe '#json_data' do
    subject { google_sheet.json_data }
    context 'should return an object' do
      # pending
    end
  end
end
